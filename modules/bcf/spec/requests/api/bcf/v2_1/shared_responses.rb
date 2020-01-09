#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2019 the OpenProject Foundation (OPF)
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

shared_examples_for 'bcf api successful response' do
  it 'responds correctly with the expected body', :aggregate_failures do
    expect(subject.status)
      .to eql(defined?(expected_status) ? expected_status : 200)
    expect(subject.body).to be_json_eql(expected_body.to_json)
    expect(subject.headers['Content-Type']).to eql 'application/json; charset=utf-8' unless defined?(no_content)
  end
end

shared_examples_for 'bcf api successful response expectation' do
  it 'responds correctly with the expected body', :aggregate_failures do
    expect(subject.status).to eq 200

    instance_exec(subject.body, &expectations)

    expect(subject.headers['Content-Type']).to eql 'application/json; charset=utf-8'
  end
end

shared_examples_for 'bcf api not found response' do
  let(:expect_404) do
    { message: 'The requested resource could not be found.' }
  end

  it 'responds 404 NOT FOUND', :aggregate_failures do
    expect(subject.status).to eq 404
    expect(subject.body).to be_json_eql(expect_404.to_json)
    expect(subject.headers['Content-Type']).to eql 'application/json; charset=utf-8'
  end
end

shared_examples_for 'bcf api not allowed response' do
  let(:expect_403) do
    { message: 'You are not authorized to access this resource.' }
  end

  it 'responds 403 NOT ALLOWED', :aggregate_failures do
    expect(subject.status).to eq 403
    expect(subject.body).to be_json_eql(expect_403.to_json)
    expect(subject.headers['Content-Type']).to eql 'application/json; charset=utf-8'
  end
end

shared_examples_for 'bcf api unprocessable response' do
  let(:expect_422) do
    { message: message }
  end

  it 'responds 422 UNPROCESSABLE ENTITY', :aggregate_failures do
    expect(subject.status).to eq 422
    expect(subject.body).to be_json_eql(expect_422.to_json)
    expect(subject.headers['Content-Type']).to eql 'application/json; charset=utf-8'
  end
end

shared_examples_for 'bcf api not implemented response' do
  it 'responds 501 not implemented', :aggregate_failures do
    expect(subject.status).to eql 501

    expected = {
      message: expected_message
    }

    expect(subject.body).to be_json_eql(expected.to_json)
    expect(subject.headers['Content-Type']).to eql 'application/json; charset=utf-8'
  end
end
