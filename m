Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39138 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726422AbeJOVpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 17:45:19 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v4 12/12] ov5640: Enforce a mode change when changing the
 framerate
Date: Mon, 15 Oct 2018 13:57:40 +0000
Message-ID: <45c2db62-b6b9-34a6-1e4b-16d622f8461a@st.com>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
 <20181011092107.30715-13-maxime.ripard@bootlin.com>
In-Reply-To: <20181011092107.30715-13-maxime.ripard@bootlin.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <C73D8567AE4B7C438608DF26B502130A@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgTWF4aW1lLA0KDQpUaGlzIGlzIGFscmVhZHkgZml4ZWQgaW4gbWVkaWEgdHJlZToNCjA5Mjk5
ODNlNDljODFjMWQ0MTM3MDJjZDliODNiYjA2YzRhMjU1NWMgbWVkaWE6IG92NTY0MDogZml4IGZy
YW1lcmF0ZSB1cGRhdGUNCg0KDQpPbiAxMC8xMS8yMDE4IDExOjIxIEFNLCBNYXhpbWUgUmlwYXJk
IHdyb3RlOg0KPiBUaGUgY3VycmVudCBsb2dpYyBvbmx5IHJlcXVpcmVzIHRvIGNhbGwgb3Y1NjQw
X3NldF9tb2RlLCB3aGljaCB3aWxsIGluIHR1cm4NCj4gY2hhbmdlIHRoZSBjbG9jayByYXRlcyBh
Y2NvcmRpbmcgdG8gdGhlIG1vZGUgYW5kIGZyYW1lIGludGVydmFsLCB3aGVuIGEgbmV3DQo+IG1v
ZGUgaXMgc2V0IHVwLg0KPiANCj4gSG93ZXZlciwgd2hlbiBvbmx5IHRoZSBmcmFtZSBpbnRlcnZh
bCBpcyBjaGFuZ2VkIGJ1dCB0aGUgbW9kZSBpc24ndCwNCj4gb3Y1NjQwX3NldF9tb2RlIGlzIG5l
dmVyIGNhbGxlZCBhbmQgdGhlIHJlc3VsdGluZyBmcmFtZSByYXRlIHdpbGwgYmUgb2xkIG9yDQo+
IGRlZmF1bHQgb25lLiBGaXggdGhpcyBieSByZXF1aXJpbmcgdGhhdCBvdjU2NDBfc2V0X21vZGUg
aXMgY2FsbGVkIHdoZW4gdGhlDQo+IGZyYW1lIGludGVydmFsIGlzIGNoYW5nZWQgYXMgd2VsbC4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1heGltZSBSaXBhcmQgPG1heGltZS5yaXBhcmRAYm9vdGxp
bi5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbWVkaWEvaTJjL292NTY0MC5jIHwgOCArKysrKyst
LQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9pMmMvb3Y1NjQwLmMgYi9kcml2ZXJzL21l
ZGlhL2kyYy9vdjU2NDAuYw0KPiBpbmRleCA4MTg0MTE0MDBlZjYuLmUwMWQyY2I5M2M2NyAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9tZWRpYS9pMmMvb3Y1NjQwLmMNCj4gKysrIGIvZHJpdmVycy9t
ZWRpYS9pMmMvb3Y1NjQwLmMNCj4gQEAgLTI2MzgsOCArMjYzOCwxMiBAQCBzdGF0aWMgaW50IG92
NTY0MF9zX2ZyYW1lX2ludGVydmFsKHN0cnVjdCB2NGwyX3N1YmRldiAqc2QsDQo+ICAgCQlnb3Rv
IG91dDsNCj4gICAJfQ0KPiAgIA0KPiAtCXNlbnNvci0+Y3VycmVudF9mciA9IGZyYW1lX3JhdGU7
DQo+IC0Jc2Vuc29yLT5mcmFtZV9pbnRlcnZhbCA9IGZpLT5pbnRlcnZhbDsNCj4gKwlpZiAoZnJh
bWVfcmF0ZSAhPSBzZW5zb3ItPmN1cnJlbnRfZnIpIHsNCj4gKwkJc2Vuc29yLT5jdXJyZW50X2Zy
ID0gZnJhbWVfcmF0ZTsNCj4gKwkJc2Vuc29yLT5mcmFtZV9pbnRlcnZhbCA9IGZpLT5pbnRlcnZh
bDsNCj4gKwkJc2Vuc29yLT5wZW5kaW5nX21vZGVfY2hhbmdlID0gdHJ1ZTsNCj4gKwl9DQo+ICsN
Cj4gICAJbW9kZSA9IG92NTY0MF9maW5kX21vZGUoc2Vuc29yLCBmcmFtZV9yYXRlLCBtb2RlLT5o
YWN0LA0KPiAgIAkJCQltb2RlLT52YWN0LCB0cnVlKTsNCj4gICAJaWYgKCFtb2RlKSB7DQo+IA0K
DQpCUiwNCkh1Z3Vlcy4=
