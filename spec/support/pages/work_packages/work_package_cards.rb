#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2018 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++
require 'support/pages/page'

module Pages
  class WorkPackageCards < Page
    include Capybara::DSL
    include RSpec::Matchers
    attr_reader :project

    def initialize(project = nil)
      @project = project
    end

    def expect_work_package_listed(*work_packages)
      work_packages.each do |wp|
        expect(page).to have_selector("wp-single-card[data-work-package-id='#{wp.id}']")
      end
    end

    def expect_work_package_order(*ids)
      retry_block do
        rows = page.all 'wp-single-card'
        expected = ids.map { |el| el.is_a?(WorkPackage) ? el.id.to_s : el.to_s }
        found = rows.map { |el| el['data-work-package-id'] }

        raise "Order is incorrect: #{found.inspect} != #{expected.inspect}" unless found == expected
      end
    end

    def open_full_screen_by_doubleclick(work_package)
      loading_indicator_saveguard
      page.driver.browser.action.double_click(card(work_package).native).perform

      Pages::FullWorkPackage.new(work_package, project)
    end

    def select_work_package(work_package)
      card(work_package).click
    end

    def card(work_package)
      page.find(".wp-card-#{work_package.id}")
    end

    def status_button(work_package)
      WorkPackageStatusField.new card(work_package)
    end
  end
end
