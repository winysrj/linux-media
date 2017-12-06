Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:22480 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754173AbdLFJre (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Dec 2017 04:47:34 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 2/4] media: ov5640: check chip id
Date: Wed, 6 Dec 2017 09:47:18 +0000
Message-ID: <84e77f25-da1a-44df-e624-54f7a981d2e3@st.com>
References: <1511975472-26659-1-git-send-email-hugues.fruchet@st.com>
 <1511975472-26659-3-git-send-email-hugues.fruchet@st.com>
 <fcf7a6e3-e4b7-bf45-feca-8b9fa5b08716@mentor.com>
In-Reply-To: <fcf7a6e3-e4b7-bf45-feca-8b9fa5b08716@mentor.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDDE805B92C4A94E88374AB7A08EC786@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU3RldmUsDQp0aGFua3MgZm9yIHJldmlldywgY29tbWVudHMgYmVsb3cuDQoNCk9uIDEyLzAz
LzIwMTcgMTA6MzQgUE0sIFN0ZXZlIExvbmdlcmJlYW0gd3JvdGU6DQo+IA0KPiANCj4gT24gMTEv
MjkvMjAxNyAwOToxMSBBTSwgSHVndWVzIEZydWNoZXQgd3JvdGU6DQo+PiBWZXJpZnkgdGhhdCBj
aGlwIGlkZW50aWZpZXIgaXMgY29ycmVjdCBiZWZvcmUgc3RhcnRpbmcgc3RyZWFtaW5nDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogSHVndWVzIEZydWNoZXQgPGh1Z3Vlcy5mcnVjaGV0QHN0LmNvbT4N
Cj4+IC0tLQ0KPj4gwqAgZHJpdmVycy9tZWRpYS9pMmMvb3Y1NjQwLmMgfCAzMCArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0NCj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCAyOSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvaTJj
L292NTY0MC5jIGIvZHJpdmVycy9tZWRpYS9pMmMvb3Y1NjQwLmMNCj4+IGluZGV4IDYxMDcxZjUu
LmE1NzZkMTEgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL21lZGlhL2kyYy9vdjU2NDAuYw0KPj4g
KysrIGIvZHJpdmVycy9tZWRpYS9pMmMvb3Y1NjQwLmMNCj4+IEBAIC0zNCw3ICszNCw4IEBADQo+
PiDCoCAjZGVmaW5lIE9WNTY0MF9ERUZBVUxUX1NMQVZFX0lEIDB4M2MNCj4+IC0jZGVmaW5lIE9W
NTY0MF9SRUdfQ0hJUF9JRMKgwqDCoMKgwqDCoMKgIDB4MzAwYQ0KPj4gKyNkZWZpbmUgT1Y1NjQw
X1JFR19DSElQX0lEX0hJR0jCoMKgwqDCoMKgwqDCoCAweDMwMGENCj4+ICsjZGVmaW5lIE9WNTY0
MF9SRUdfQ0hJUF9JRF9MT1fCoMKgwqDCoMKgwqDCoCAweDMwMGINCj4gDQo+IFRoZXJlIGlzIG5v
IG5lZWQgdG8gc2VwYXJhdGUgbG93IGFuZCBoaWdoIGJ5dGUgYWRkcmVzc2VzLg0KPiBTZWUgYmVs
b3cuDQo+IA0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1BBRF9PVVRQVVQwMMKgwqDCoMKgwqDC
oMKgIDB4MzAxOQ0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1NDX1BMTF9DVFJMMMKgwqDCoMKg
wqDCoMKgIDB4MzAzNA0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1NDX1BMTF9DVFJMMcKgwqDC
oMKgwqDCoMKgIDB4MzAzNQ0KPj4gQEAgLTkyNiw2ICs5MjcsMjkgQEAgc3RhdGljIGludCBvdjU2
NDBfbG9hZF9yZWdzKHN0cnVjdCBvdjU2NDBfZGV2IA0KPj4gKnNlbnNvciwNCj4+IMKgwqDCoMKg
wqAgcmV0dXJuIHJldDsNCj4+IMKgIH0NCj4+ICtzdGF0aWMgaW50IG92NTY0MF9jaGVja19jaGlw
X2lkKHN0cnVjdCBvdjU2NDBfZGV2ICpzZW5zb3IpDQo+PiArew0KPj4gK8KgwqDCoCBzdHJ1Y3Qg
aTJjX2NsaWVudCAqY2xpZW50ID0gc2Vuc29yLT5pMmNfY2xpZW50Ow0KPj4gK8KgwqDCoCBpbnQg
cmV0Ow0KPj4gK8KgwqDCoCB1OCBjaGlwX2lkX2gsIGNoaXBfaWRfbDsNCj4+ICsNCj4+ICvCoMKg
wqAgcmV0ID0gb3Y1NjQwX3JlYWRfcmVnKHNlbnNvciwgT1Y1NjQwX1JFR19DSElQX0lEX0hJR0gs
ICZjaGlwX2lkX2gpOw0KPj4gK8KgwqDCoCBpZiAocmV0KQ0KPj4gK8KgwqDCoMKgwqDCoMKgIHJl
dHVybiByZXQ7DQo+PiArDQo+PiArwqDCoMKgIHJldCA9IG92NTY0MF9yZWFkX3JlZyhzZW5zb3Is
IE9WNTY0MF9SRUdfQ0hJUF9JRF9MT1csICZjaGlwX2lkX2wpOw0KPj4gK8KgwqDCoCBpZiAocmV0
KQ0KPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7DQo+PiArDQo+PiArwqDCoMKgIGlmICgh
KGNoaXBfaWRfaCA9PSAweDU2ICYmIGNoaXBfaWRfbCA9PSAweDQwKSkgew0KPj4gK8KgwqDCoMKg
wqDCoMKgIGRldl9lcnIoJmNsaWVudC0+ZGV2LCAiJXM6IHdyb25nIGNoaXAgaWRlbnRpZmllciwg
ZXhwZWN0ZWQgDQo+PiAweDU2NDAsIGdvdCAweCV4JXhcbiIsDQo+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBfX2Z1bmNfXywgY2hpcF9pZF9oLCBjaGlwX2lkX2wpOw0KPj4gK8KgwqDCoMKgwqDC
oMKgIHJldHVybiAtRUlOVkFMOw0KPj4gK8KgwqDCoCB9DQo+PiArDQo+IA0KPiBUaGlzIHNob3Vs
ZCBhbGwgYmUgYmUgcmVwbGFjZWQgYnk6DQo+IA0KPiB1MTYgY2hpcF9pZDsNCj4gDQo+IHJldCA9
IG92NTY0MF9yZWFkX3JlZzE2KHNlbnNvciwgT1Y1NjQwX1JFR19DSElQX0lELCAmY2hpcF9pZCk7
DQo+IA0KPiBldGMuDQo+IA0KDQpEb25lLCB0aGFua3MuDQoNCj4+ICvCoMKgwqAgcmV0dXJuIDA7
DQo+PiArfQ0KPj4gKw0KPj4gwqAgLyogcmVhZCBleHBvc3VyZSwgaW4gbnVtYmVyIG9mIGxpbmUg
cGVyaW9kcyAqLw0KPj4gwqAgc3RhdGljIGludCBvdjU2NDBfZ2V0X2V4cG9zdXJlKHN0cnVjdCBv
djU2NDBfZGV2ICpzZW5zb3IpDQo+PiDCoCB7DQo+PiBAQCAtMTU2Miw2ICsxNTg2LDEwIEBAIHN0
YXRpYyBpbnQgb3Y1NjQwX3NldF9wb3dlcihzdHJ1Y3Qgb3Y1NjQwX2RldiANCj4+ICpzZW5zb3Is
IGJvb2wgb24pDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgb3Y1NjQwX3Jlc2V0KHNlbnNvcik7DQo+
PiDCoMKgwqDCoMKgwqDCoMKgwqAgb3Y1NjQwX3Bvd2VyKHNlbnNvciwgdHJ1ZSk7DQo+PiArwqDC
oMKgwqDCoMKgwqAgcmV0ID0gb3Y1NjQwX2NoZWNrX2NoaXBfaWQoc2Vuc29yKTsNCj4+ICvCoMKg
wqDCoMKgwqDCoCBpZiAocmV0KQ0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBwb3dl
cl9vZmY7DQo+PiArDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gb3Y1NjQwX2luaXRfc2xh
dmVfaWQoc2Vuc29yKTsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KQ0KPj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBwb3dlcl9vZmY7DQo+IA0KDQpCZXN0IHJlZ2FyZHMs
DQpIdWd1ZXMu
