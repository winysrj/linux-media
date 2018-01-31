Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:56942 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752447AbeAaMgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 07:36:25 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH] media: ov5640: add error trace in case of i2c read
 failure
Date: Wed, 31 Jan 2018 12:36:13 +0000
Message-ID: <4897fe3d-5cdc-7a24-ee5d-bc56937e5f35@st.com>
References: <1517397564-12335-1-git-send-email-hugues.fruchet@st.com>
 <20180131115726.meyzjtv3odlr4rki@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180131115726.meyzjtv3odlr4rki@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EC4C9CE4F8ADF4D8932409297C9A82D@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU2FrYXJpLA0KSSd2ZSBtYWRlIGl0IHN5bWV0cmljIHRvIG92NTY0MF93cml0ZV9yZWcoKSB3
aGljaCBhbHNvIHVzZXMgdjRsMl9lcnIsDQpJIHdpbGwgY2hhbmdlIGJvdGggc28gd2UgYXJlIGdv
bmUgd2l0aCBhbGwgdjRsMl9lcnIuDQoNCkJSLA0KSHVndWVzLg0KDQpPbiAwMS8zMS8yMDE4IDEy
OjU3IFBNLCBTYWthcmkgQWlsdXMgd3JvdGU6DQo+IE9uIFdlZCwgSmFuIDMxLCAyMDE4IGF0IDEy
OjE5OjI0UE0gKzAxMDAsIEh1Z3VlcyBGcnVjaGV0IHdyb3RlOg0KPj4gQWRkIGFuIGVycm9yIHRy
YWNlIGluIG92NTY0MF9yZWFkX3JlZygpIGluIGNhc2Ugb2YgaTJjX3RyYW5zZmVyKCkNCj4+IGZh
aWx1cmUuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSHVndWVzIEZydWNoZXQgPGh1Z3Vlcy5mcnVj
aGV0QHN0LmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL21lZGlhL2kyYy9vdjU2NDAuYyB8IDUg
KysrKy0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL2kyYy9vdjU2NDAuYyBiL2RyaXZl
cnMvbWVkaWEvaTJjL292NTY0MC5jDQo+PiBpbmRleCA5OWE1OTAyLi44ODJhN2MzIDEwMDY0NA0K
Pj4gLS0tIGEvZHJpdmVycy9tZWRpYS9pMmMvb3Y1NjQwLmMNCj4+ICsrKyBiL2RyaXZlcnMvbWVk
aWEvaTJjL292NTY0MC5jDQo+PiBAQCAtODY4LDggKzg2OCwxMSBAQCBzdGF0aWMgaW50IG92NTY0
MF9yZWFkX3JlZyhzdHJ1Y3Qgb3Y1NjQwX2RldiAqc2Vuc29yLCB1MTYgcmVnLCB1OCAqdmFsKQ0K
Pj4gICAJbXNnWzFdLmxlbiA9IDE7DQo+PiAgIA0KPj4gICAJcmV0ID0gaTJjX3RyYW5zZmVyKGNs
aWVudC0+YWRhcHRlciwgbXNnLCAyKTsNCj4+IC0JaWYgKHJldCA8IDApDQo+PiArCWlmIChyZXQg
PCAwKSB7DQo+PiArCQl2NGwyX2Vycigmc2Vuc29yLT5zZCwgIiVzOiBlcnJvcjogcmVnPSV4XG4i
LA0KPiANCj4gVGhlIGRyaXZlciB1c2VzIGRldl8gbWFjcm9zIGFsbW9zdCB1bml2ZXJzYWxseSwg
aG93IGFib3V0IGRvaW5nIHRoZSBzYW1lDQo+IGhlcmU/DQo+IA0KPj4gKwkJCSBfX2Z1bmNfXywg
cmVnKTsNCj4+ICAgCQlyZXR1cm4gcmV0Ow0KPj4gKwl9DQo+PiAgIA0KPj4gICAJKnZhbCA9IGJ1
ZlswXTsNCj4+ICAgCXJldHVybiAwOw0KPj4gLS0gDQo+PiAxLjkuMQ0KPj4NCj4g
