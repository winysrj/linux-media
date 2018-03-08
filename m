Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:14653 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751684AbeCHIsb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 03:48:31 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH] media: ov5640: fix get_/set_fmt colorspace related fields
Date: Thu, 8 Mar 2018 08:48:18 +0000
Message-ID: <15045540-2dca-b2fc-349d-04790b9efc4c@st.com>
References: <1520355879-20291-1-git-send-email-hugues.fruchet@st.com>
 <20180307081302.h47mjhlkeq72shw7@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180307081302.h47mjhlkeq72shw7@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9EFEE4F444B5A4CB18A60D63ACE31BD@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU2FrYXJpLA0KDQpUaGlzIGlzIHRoZSByaWdodCBvbmUgYW5kIGl0J3MgT0sgdG8gc3dhcCB0
aGUgbGluZXMgZm9yIGxvY2FsIHZhcmlhYmxlcywgDQpJJ2xsIGtlZXAgdGhpcyBpbiBtaW5kIGZv
ciBuZXh0IGNoYW5nZXMuDQoNCkJlc3QgcmVnYXJkcywNCkh1Z3Vlcy4NCg0KT24gMDMvMDcvMjAx
OCAwOToxMyBBTSwgU2FrYXJpIEFpbHVzIHdyb3RlOg0KPiBIaSBIdWd1ZXMsDQo+IA0KPiBPbiBU
dWUsIE1hciAwNiwgMjAxOCBhdCAwNjowNDozOVBNICswMTAwLCBIdWd1ZXMgRnJ1Y2hldCB3cm90
ZToNCj4+IEZpeCBzZXQgb2YgbWlzc2luZyBjb2xvcnNwYWNlIHJlbGF0ZWQgZmllbGRzIGluIGdl
dF8vc2V0X2ZtdC4NCj4+IERldGVjdGVkIGJ5IHY0bDItY29tcGxpYW5jZSB0b29sLg0KPj4NCj4+
IFNpZ25lZC1vZmYtYnk6IEh1Z3VlcyBGcnVjaGV0IDxodWd1ZXMuZnJ1Y2hldEBzdC5jb20+DQo+
IA0KPiBDb3VsZCB5b3UgY29uZmlybSB0aGlzIGlzIHRoZSBvbmUgeW91IGludGVuZGVkIHRvIHNl
bmQ/IFRoZXJlIGFyZSB0d28NCj4gb3RoZXJzIHdpdGggc2ltaWxhciBjb250ZW50Lg0KPiANCj4g
Li4uDQo+IA0KPj4gQEAgLTI0OTcsMTYgKzI1MDQsMjIgQEAgc3RhdGljIGludCBvdjU2NDBfcHJv
YmUoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCwNCj4+ICAgCXN0cnVjdCBmd25vZGVfaGFuZGxl
ICplbmRwb2ludDsNCj4+ICAgCXN0cnVjdCBvdjU2NDBfZGV2ICpzZW5zb3I7DQo+PiAgIAlpbnQg
cmV0Ow0KPj4gKwlzdHJ1Y3QgdjRsMl9tYnVzX2ZyYW1lZm10ICpmbXQ7DQo+IA0KPiBUaGlzIG9u
ZSBJJ2QgYXJyYW5nZSBiZWZvcmUgcmV0LiBUaGUgbG9jYWwgdmFyaWFibGUgZGVjbGFyYXRpb25z
IHNob3VsZA0KPiBnZW5lcmFsbHkgbG9vayBsaWtlIGEgQ2hyaXN0bWFzIHRyZWUgYnV0IHVwc2lk
ZSBkb3duLg0KPiANCj4gSWYgeW91J3JlIGhhcHB5IHdpdGggdGhhdCwgSSBjYW4gc3dhcCB0aGUg
dHdvIGxpbmVzIGFzIHdlbGwgKG5vIG5lZWQgZm9yDQo+IHYyKS4NCj4gDQo+PiAgIA0KPj4gICAJ
c2Vuc29yID0gZGV2bV9remFsbG9jKGRldiwgc2l6ZW9mKCpzZW5zb3IpLCBHRlBfS0VSTkVMKTsN
Cj4+ICAgCWlmICghc2Vuc29yKQ0KPj4gICAJCXJldHVybiAtRU5PTUVNOw0KPj4gICANCj4+ICAg
CXNlbnNvci0+aTJjX2NsaWVudCA9IGNsaWVudDsNCj4+IC0Jc2Vuc29yLT5mbXQuY29kZSA9IE1F
RElBX0JVU19GTVRfVVlWWThfMlg4Ow0KPj4gLQlzZW5zb3ItPmZtdC53aWR0aCA9IDY0MDsNCj4+
IC0Jc2Vuc29yLT5mbXQuaGVpZ2h0ID0gNDgwOw0KPj4gLQlzZW5zb3ItPmZtdC5maWVsZCA9IFY0
TDJfRklFTERfTk9ORTsNCj4+ICsJZm10ID0gJnNlbnNvci0+Zm10Ow0KPj4gKwlmbXQtPmNvZGUg
PSBvdjU2NDBfZm9ybWF0c1swXS5jb2RlOw0KPj4gKwlmbXQtPmNvbG9yc3BhY2UgPSBvdjU2NDBf
Zm9ybWF0c1swXS5jb2xvcnNwYWNlOw0KPj4gKwlmbXQtPnljYmNyX2VuYyA9IFY0TDJfTUFQX1lD
QkNSX0VOQ19ERUZBVUxUKGZtdC0+Y29sb3JzcGFjZSk7DQo+PiArCWZtdC0+cXVhbnRpemF0aW9u
ID0gVjRMMl9RVUFOVElaQVRJT05fRlVMTF9SQU5HRTsNCj4+ICsJZm10LT54ZmVyX2Z1bmMgPSBW
NEwyX01BUF9YRkVSX0ZVTkNfREVGQVVMVChmbXQtPmNvbG9yc3BhY2UpOw0KPj4gKwlmbXQtPndp
ZHRoID0gNjQwOw0KPj4gKwlmbXQtPmhlaWdodCA9IDQ4MDsNCj4+ICsJZm10LT5maWVsZCA9IFY0
TDJfRklFTERfTk9ORTsNCj4+ICAgCXNlbnNvci0+ZnJhbWVfaW50ZXJ2YWwubnVtZXJhdG9yID0g
MTsNCj4+ICAgCXNlbnNvci0+ZnJhbWVfaW50ZXJ2YWwuZGVub21pbmF0b3IgPSBvdjU2NDBfZnJh
bWVyYXRlc1tPVjU2NDBfMzBfRlBTXTsNCj4+ICAgCXNlbnNvci0+Y3VycmVudF9mciA9IE9WNTY0
MF8zMF9GUFM7DQo+IA==
