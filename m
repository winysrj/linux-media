Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37626 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965840AbeFRJey (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 05:34:54 -0400
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
Subject: Re: [PATCH 1/2] media: stm32-dcmi: drop unnecessary while(1) loop
Date: Mon, 18 Jun 2018 09:34:04 +0000
Message-ID: <a67e4d0c-8434-5669-329f-66a45b7be343@st.com>
References: <1528824138-19089-1-git-send-email-hofrat@osadl.org>
In-Reply-To: <1528824138-19089-1-git-send-email-hofrat@osadl.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F7FF8B9CF6BBE4C9B3F701360F3C82A@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgTmljaG9sYXMsDQp0aGFua3MgZm9yIHBhdGNoICENCg0KT24gMDYvMTIvMjAxOCAwNzoyMiBQ
TSwgTmljaG9sYXMgTWMgR3VpcmUgd3JvdGU6DQo+IFRoZSB3aGlsZSgxKSBpcyBlZmZlY3RpdmVs
eSB1c2VsZXNzIGFzIGFsbCBwb3NzaWJsZSBwYXRocyB3aXRoaW4gaXQNCj4gcmV0dXJuIHRodXMg
dGhlcmUgaXMgbm8gd2F5IHRvIGxvb3AuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNob2xhcyBN
YyBHdWlyZSA8aG9mcmF0QG9zYWRsLm9yZz4NCkFja2VkLWJ5OiBIdWd1ZXMgRnJ1Y2hldCA8aHVn
dWVzLmZydWNoZXRAc3QuY29tPg0KDQo+IC0tLQ0KPiANCj4gVGhpcyBpcyBub3QgYWN0dWFsbHkg
Zml4aW5nIGFueSBidWcgLSB0aGUgd2hpbGUoMSl7IH0gd2lsbCBub3QgaHVydCBoZXJlDQo+IGl0
IGlzIHRob3VnaCBzaW1wbHkgdW5uZWNlc3NhcnkuIEZvdW5kIGR1cmluZyBjb2RlIHJldmlldy4N
Cj4gDQo+IFRoZSBkaWZmIG91dHB1dCBpcyBub3QgdmVyeSByZWFkYWJsZSAtIGVzc2VudGlhbGx5
IG9ubHkgdGhlIG91dGVyDQo+IHdoaWxlKDEpeyB9IHdhcyByZW1vdmVkLg0KPiANCj4gUGF0Y2gg
d2FzIGNvbXBpbGUgdGVzdGVkIHdpdGg6IHg4Nl82NF9kZWZjb25maWcsIE1FRElBX1NVUFBPUlQ9
eQ0KPiBNRURJQV9DQU1FUkFfU1VQUE9SVD15LCBWNExfUExBVEZPUk1fRFJJVkVSUz15LCBPRj15
LCBDT01QSUxFX1RFU1Q9eQ0KPiBDT05GSUdfVklERU9fU1RNMzJfRENNST15DQo+IChUaGVyZSBh
cmUgYSBudW1iZXIgb2Ygc3BhcnNlIHdhcm5pbmdzIC0gbm90IHJlbGF0ZWQgdG8gdGhlIGNoYW5n
ZXMgdGhvdWdoKQ0KPiANCj4gUGF0Y2ggaXMgYWdhaW5zdCA0LjE3LjAgKGxvY2FsdmVyc2lvbi1u
ZXh0IGlzIG5leHQtMjAxODA2MDgpDQo+IA0KPiAgIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3Rt
MzIvc3RtMzItZGNtaS5jIHwgMjggKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL3N0bTMyL3N0bTMyLWRjbWkuYyBiL2Ry
aXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RtMzIvc3RtMzItZGNtaS5jDQo+IGluZGV4IDJlMTkzM2Qu
LjcwYjgxZDIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RtMzIvc3Rt
MzItZGNtaS5jDQo+ICsrKyBiL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RtMzIvc3RtMzItZGNt
aS5jDQo+IEBAIC0xNjA1LDIzICsxNjA1LDIxIEBAIHN0YXRpYyBpbnQgZGNtaV9ncmFwaF9wYXJz
ZShzdHJ1Y3Qgc3RtMzJfZGNtaSAqZGNtaSwgc3RydWN0IGRldmljZV9ub2RlICpub2RlKQ0KPiAg
IAlzdHJ1Y3QgZGV2aWNlX25vZGUgKmVwID0gTlVMTDsNCj4gICAJc3RydWN0IGRldmljZV9ub2Rl
ICpyZW1vdGU7DQo+ICAgDQo+IC0Jd2hpbGUgKDEpIHsNCj4gLQkJZXAgPSBvZl9ncmFwaF9nZXRf
bmV4dF9lbmRwb2ludChub2RlLCBlcCk7DQo+IC0JCWlmICghZXApDQo+IC0JCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gLQ0KPiAtCQlyZW1vdGUgPSBvZl9ncmFwaF9nZXRfcmVtb3RlX3BvcnRfcGFyZW50
KGVwKTsNCj4gLQkJaWYgKCFyZW1vdGUpIHsNCj4gLQkJCW9mX25vZGVfcHV0KGVwKTsNCj4gLQkJ
CXJldHVybiAtRUlOVkFMOw0KPiAtCQl9DQo+ICsJZXAgPSBvZl9ncmFwaF9nZXRfbmV4dF9lbmRw
b2ludChub2RlLCBlcCk7DQo+ICsJaWYgKCFlcCkNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICAg
DQo+IC0JCS8qIFJlbW90ZSBub2RlIHRvIGNvbm5lY3QgKi8NCj4gLQkJZGNtaS0+ZW50aXR5Lm5v
ZGUgPSByZW1vdGU7DQo+IC0JCWRjbWktPmVudGl0eS5hc2QubWF0Y2hfdHlwZSA9IFY0TDJfQVNZ
TkNfTUFUQ0hfRldOT0RFOw0KPiAtCQlkY21pLT5lbnRpdHkuYXNkLm1hdGNoLmZ3bm9kZSA9IG9m
X2Z3bm9kZV9oYW5kbGUocmVtb3RlKTsNCj4gLQkJcmV0dXJuIDA7DQo+ICsJcmVtb3RlID0gb2Zf
Z3JhcGhfZ2V0X3JlbW90ZV9wb3J0X3BhcmVudChlcCk7DQo+ICsJaWYgKCFyZW1vdGUpIHsNCj4g
KwkJb2Zfbm9kZV9wdXQoZXApOw0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gICAJfQ0KPiArDQo+
ICsJLyogUmVtb3RlIG5vZGUgdG8gY29ubmVjdCAqLw0KPiArCWRjbWktPmVudGl0eS5ub2RlID0g
cmVtb3RlOw0KPiArCWRjbWktPmVudGl0eS5hc2QubWF0Y2hfdHlwZSA9IFY0TDJfQVNZTkNfTUFU
Q0hfRldOT0RFOw0KPiArCWRjbWktPmVudGl0eS5hc2QubWF0Y2guZndub2RlID0gb2ZfZndub2Rl
X2hhbmRsZShyZW1vdGUpOw0KPiArCXJldHVybiAwOw0KPiAgIH0NCj4gICANCj4gICBzdGF0aWMg
aW50IGRjbWlfZ3JhcGhfaW5pdChzdHJ1Y3Qgc3RtMzJfZGNtaSAqZGNtaSkNCj4gDQoNCkJSLA0K
SHVndWVzLg==
