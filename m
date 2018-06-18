Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39307 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934168AbeFRJu2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 05:50:28 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Nicholas Mc Guire <hofrat@osadl.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        Niklas Soderlund <niklas.soderlund+renesas@ragnatech.se>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] media: stm32-dcmi: add mandatory of_node_put() in
 success path
Date: Mon, 18 Jun 2018 09:49:44 +0000
Message-ID: <7f3ca88b-e1b0-ea2c-da02-63da5cdc9e09@st.com>
References: <1528824138-19089-1-git-send-email-hofrat@osadl.org>
 <1528824138-19089-2-git-send-email-hofrat@osadl.org>
In-Reply-To: <1528824138-19089-2-git-send-email-hofrat@osadl.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED13F2B41F034A4AA7F6E8862EA2BF13@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgTmljaG9sYXMsDQpUaGFua3MgZm9yIHBhdGNoLg0KQlIsDQpIdWd1ZXMuDQoNCk9uIDA2LzEy
LzIwMTggMDc6MjIgUE0sIE5pY2hvbGFzIE1jIEd1aXJlIHdyb3RlOg0KPiBUaGUgZW5kcG9pbnQg
YWxsb2NhdGVkIGJ5IG9mX2dyYXBoX2dldF9uZXh0X2VuZHBvaW50KCkgbmVlZHMgYW4gb2Zfbm9k
ZV9wdXQoKQ0KPiBpbiBib3RoIGVycm9yIGFuZCBzdWNjZXNzIHBhdGguIEFzICBlcCAgaXMgbm90
IHVzZWQgdGhlIHJlZmNvdW50IGRlY3JlbWVudA0KPiBjYW4gYmUgcmlnaHQgYWZ0ZXIgdGhlIGxh
c3QgdXNlIG9mICBlcC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5pY2hvbGFzIE1jIEd1aXJlIDxo
b2ZyYXRAb3NhZGwub3JnPg0KQWNrZWQtYnk6IEh1Z3VlcyBGcnVjaGV0IDxodWd1ZXMuZnJ1Y2hl
dEBzdC5jb20+DQoNCj4gRml4ZXM6IGNvbW1pdCAzNzQwNGY5MWVmOGIgKCJbbWVkaWFdIHN0bTMy
LWRjbWk6IFNUTTMyIERDTUkgY2FtZXJhIGludGVyZmFjZSBkcml2ZXIiKQ0KPiAtLS0NCj4gDQo+
IFByb2JsZW0gbG9jYXRlZCB3aXRoIGFuIGV4cGVyaW1lbnRhbCBjb2NjaW5lbGxlIHNjcmlwdA0K
PiANCj4gUGF0Y2ggd2FzIGNvbXBpbGUgdGVzdGVkIHdpdGg6IHg4Nl82NF9kZWZjb25maWcsIE1F
RElBX1NVUFBPUlQ9eQ0KPiBNRURJQV9DQU1FUkFfU1VQUE9SVD15LCBWNExfUExBVEZPUk1fRFJJ
VkVSUz15LCBPRj15LCBDT01QSUxFX1RFU1Q9eQ0KPiBDT05GSUdfVklERU9fU1RNMzJfRENNST15
DQo+IChUaGVyZSBhcmUgYSBudW1iZXIgb2Ygc3BhcnNlIHdhcm5pbmdzIC0gbm90IHJlbGF0ZWQg
dG8gdGhlIGNoYW5nZXMgdGhvdWdoKQ0KPiANCj4gUGF0Y2ggaXMgb24gdG9wIG9mICJbUEFUQ0gg
MS8yXSBtZWRpYTogc3RtMzItZGNtaTogZHJvcCB1bm5lY2VlYXJ5IHdoaWxlKDEpDQo+IGxvb3Ai
IGFnYWluc3QgNC4xNy4wIChsb2NhbHZlcnNpb24tbmV4dCBpcyBuZXh0LTIwMTgwNjA4KQ0KPiAN
Cj4gICBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL3N0bTMyL3N0bTMyLWRjbWkuYyB8IDUgKystLS0N
Cj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RtMzIvc3RtMzItZGNtaS5j
IGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdG0zMi9zdG0zMi1kY21pLmMNCj4gaW5kZXggNzBi
ODFkMi4uNTQyZDE0OCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdG0z
Mi9zdG0zMi1kY21pLmMNCj4gKysrIGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zdG0zMi9zdG0z
Mi1kY21pLmMNCj4gQEAgLTE2MTAsMTAgKzE2MTAsOSBAQCBzdGF0aWMgaW50IGRjbWlfZ3JhcGhf
cGFyc2Uoc3RydWN0IHN0bTMyX2RjbWkgKmRjbWksIHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSkN
Cj4gICAJCXJldHVybiAtRUlOVkFMOw0KPiAgIA0KPiAgIAlyZW1vdGUgPSBvZl9ncmFwaF9nZXRf
cmVtb3RlX3BvcnRfcGFyZW50KGVwKTsNCj4gLQlpZiAoIXJlbW90ZSkgew0KPiAtCQlvZl9ub2Rl
X3B1dChlcCk7DQo+ICsJb2Zfbm9kZV9wdXQoZXApOw0KPiArCWlmICghcmVtb3RlKQ0KPiAgIAkJ
cmV0dXJuIC1FSU5WQUw7DQo+IC0JfQ0KPiAgIA0KPiAgIAkvKiBSZW1vdGUgbm9kZSB0byBjb25u
ZWN0ICovDQo+ICAgCWRjbWktPmVudGl0eS5ub2RlID0gcmVtb3RlOw0KPiA=
