Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:28103 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754619AbdLFKB6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Dec 2017 05:01:58 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 3/4] media: ov5640: add support of DVP parallel
 interface
Date: Wed, 6 Dec 2017 10:01:44 +0000
Message-ID: <ef496546-dc67-60be-20a6-8361b15a421d@st.com>
References: <1511975472-26659-1-git-send-email-hugues.fruchet@st.com>
 <1511975472-26659-4-git-send-email-hugues.fruchet@st.com>
 <2f640898-872b-3211-0e7c-c1707e8a63c4@mentor.com>
In-Reply-To: <2f640898-872b-3211-0e7c-c1707e8a63c4@mentor.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <15D653967FF1414FA45AB3890F2BD2AB@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU3RldmUsDQoNCk9uIDEyLzAzLzIwMTcgMTA6NTggUE0sIFN0ZXZlIExvbmdlcmJlYW0gd3Jv
dGU6DQo+IA0KPiANCj4gT24gMTEvMjkvMjAxNyAwOToxMSBBTSwgSHVndWVzIEZydWNoZXQgd3Jv
dGU6DQo+PiBBZGQgc3VwcG9ydCBvZiBEVlAgcGFyYWxsZWwgbW9kZSBpbiBhZGRpdGlvbiBvZg0K
Pj4gZXhpc3RpbmcgTUlQSSBDU0kgbW9kZS4gVGhlIGNob2ljZSBiZXR3ZWVuIHR3byBtb2Rlcw0K
Pj4gYW5kIGNvbmZpZ3VyYXRpb24gaXMgbWFkZSB0aHJvdWdoIGRldmljZSB0cmVlLg0KPj4NCj4+
IFNpZ25lZC1vZmYtYnk6IEh1Z3VlcyBGcnVjaGV0IDxodWd1ZXMuZnJ1Y2hldEBzdC5jb20+DQo+
PiAtLS0NCj4+IMKgIGRyaXZlcnMvbWVkaWEvaTJjL292NTY0MC5jIHwgMTAxIA0KPj4gKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tDQo+PiDCoCAxIGZpbGUgY2hh
bmdlZCwgODMgaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWVkaWEvaTJjL292NTY0MC5jIGIvZHJpdmVycy9tZWRpYS9pMmMvb3Y1NjQw
LmMNCj4+IGluZGV4IGE1NzZkMTEuLjgyNmIxMDIgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL21l
ZGlhL2kyYy9vdjU2NDAuYw0KPj4gKysrIGIvZHJpdmVycy9tZWRpYS9pMmMvb3Y1NjQwLmMNCj4+
IEBAIC0zNCwxNCArMzQsMjAgQEANCj4+IMKgICNkZWZpbmUgT1Y1NjQwX0RFRkFVTFRfU0xBVkVf
SUQgMHgzYw0KPj4gKyNkZWZpbmUgT1Y1NjQwX1JFR19TWVNfQ1RSTDDCoMKgwqDCoMKgwqDCoCAw
eDMwMDgNCj4+IMKgICNkZWZpbmUgT1Y1NjQwX1JFR19DSElQX0lEX0hJR0jCoMKgwqDCoMKgwqDC
oCAweDMwMGENCj4+IMKgICNkZWZpbmUgT1Y1NjQwX1JFR19DSElQX0lEX0xPV8KgwqDCoMKgwqDC
oMKgIDB4MzAwYg0KPj4gKyNkZWZpbmUgT1Y1NjQwX1JFR19JT19NSVBJX0NUUkwwMMKgwqDCoCAw
eDMwMGUNCj4+ICsjZGVmaW5lIE9WNTY0MF9SRUdfUEFEX09VVFBVVF9FTkFCTEUwMcKgwqDCoCAw
eDMwMTcNCj4+ICsjZGVmaW5lIE9WNTY0MF9SRUdfUEFEX09VVFBVVF9FTkFCTEUwMsKgwqDCoCAw
eDMwMTgNCj4+IMKgICNkZWZpbmUgT1Y1NjQwX1JFR19QQURfT1VUUFVUMDDCoMKgwqDCoMKgwqDC
oCAweDMwMTkNCj4+ICsjZGVmaW5lIE9WNTY0MF9SRUdfU1lTVEVNX0NPTlRST0wxwqDCoMKgIDB4
MzAyZQ0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1NDX1BMTF9DVFJMMMKgwqDCoMKgwqDCoMKg
IDB4MzAzNA0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1NDX1BMTF9DVFJMMcKgwqDCoMKgwqDC
oMKgIDB4MzAzNQ0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1NDX1BMTF9DVFJMMsKgwqDCoMKg
wqDCoMKgIDB4MzAzNg0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1NDX1BMTF9DVFJMM8KgwqDC
oMKgwqDCoMKgIDB4MzAzNw0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1NMQVZFX0lEwqDCoMKg
wqDCoMKgwqAgMHgzMTAwDQo+PiArI2RlZmluZSBPVjU2NDBfUkVHX1NDQ0JfU1lTX0NUUkwxwqDC
oMKgIDB4MzEwMw0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX1NZU19ST09UX0RJVklERVLCoMKg
wqAgMHgzMTA4DQo+PiDCoCAjZGVmaW5lIE9WNTY0MF9SRUdfQVdCX1JfR0FJTsKgwqDCoMKgwqDC
oMKgIDB4MzQwMA0KPj4gwqAgI2RlZmluZSBPVjU2NDBfUkVHX0FXQl9HX0dBSU7CoMKgwqDCoMKg
wqDCoCAweDM0MDINCj4+IEBAIC0xMDA2LDcgKzEwMTIsNjUgQEAgc3RhdGljIGludCBvdjU2NDBf
Z2V0X2dhaW4oc3RydWN0IG92NTY0MF9kZXYgDQo+PiAqc2Vuc29yKQ0KPj4gwqDCoMKgwqDCoCBy
ZXR1cm4gZ2FpbiAmIDB4M2ZmOw0KPj4gwqAgfQ0KPj4gLXN0YXRpYyBpbnQgb3Y1NjQwX3NldF9z
dHJlYW0oc3RydWN0IG92NTY0MF9kZXYgKnNlbnNvciwgYm9vbCBvbikNCj4+ICtzdGF0aWMgaW50
IG92NTY0MF9zZXRfc3RyZWFtX2R2cChzdHJ1Y3Qgb3Y1NjQwX2RldiAqc2Vuc29yLCBib29sIG9u
KQ0KPj4gK3sNCj4+ICvCoMKgwqAgaW50IHJldDsNCj4+ICsNCj4+ICvCoMKgwqAgaWYgKG9uKSB7
DQo+PiArwqDCoMKgwqDCoMKgwqAgLyoNCj4+ICvCoMKgwqDCoMKgwqDCoMKgICogcmVzZXQgTUlQ
SSBQQ0xLL1NFUkNMSyBkaXZpZGVyDQo+PiArwqDCoMKgwqDCoMKgwqDCoCAqDQo+PiArwqDCoMKg
wqDCoMKgwqDCoCAqIFNDIFBMTCBDT05UUkwxIDANCj4+ICvCoMKgwqDCoMKgwqDCoMKgICogLSBb
My4uMF06wqDCoMKgIE1JUEkgUENMSy9TRVJDTEsgZGl2aWRlcg0KPj4gK8KgwqDCoMKgwqDCoMKg
wqAgKi8NCj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBvdjU2NDBfbW9kX3JlZyhzZW5zb3IsIE9W
NTY0MF9SRUdfU0NfUExMX0NUUkwxLCAweEYsIDApOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChy
ZXQpDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4gK8KgwqDCoCB9
DQo+PiArDQo+PiArwqDCoMKgIC8qDQo+PiArwqDCoMKgwqAgKiBwb3dlcmRvd24gTUlQSSBUWC9S
WCBQSFkgJiBkaXNhYmxlIE1JUEkNCj4+ICvCoMKgwqDCoCAqDQo+PiArwqDCoMKgwqAgKiBNSVBJ
IENPTlRST0wgMDANCj4+ICvCoMKgwqDCoCAqIDQ6wqDCoMKgwqAgUFdETiBQSFkgVFgNCj4+ICvC
oMKgwqDCoCAqIDM6wqDCoMKgwqAgUFdETiBQSFkgUlgNCj4+ICvCoMKgwqDCoCAqIDI6wqDCoMKg
wqAgTUlQSSBlbmFibGUNCj4+ICvCoMKgwqDCoCAqLw0KPj4gK8KgwqDCoCByZXQgPSBvdjU2NDBf
d3JpdGVfcmVnKHNlbnNvciwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgT1Y1NjQwX1JFR19JT19NSVBJX0NUUkwwMCwgb24gPyAweDE4IDogMCk7DQo+PiArwqDCoMKg
IGlmIChyZXQpDQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4+ICsNCj4+ICvCoMKg
wqAgLyoNCj4+ICvCoMKgwqDCoCAqIGVuYWJsZSBWU1lOQy9IUkVGL1BDTEsgRFZQIGNvbnRyb2wg
bGluZXMNCj4+ICvCoMKgwqDCoCAqICYgRFs5OjZdIERWUCBkYXRhIGxpbmVzDQo+PiArwqDCoMKg
wqAgKg0KPj4gK8KgwqDCoMKgICogUEFEIE9VVFBVVCBFTkFCTEUgMDENCj4+ICvCoMKgwqDCoCAq
IC0gNjrCoMKgwqDCoMKgwqDCoCBWU1lOQyBvdXRwdXQgZW5hYmxlDQo+PiArwqDCoMKgwqAgKiAt
IDU6wqDCoMKgwqDCoMKgwqAgSFJFRiBvdXRwdXQgZW5hYmxlDQo+PiArwqDCoMKgwqAgKiAtIDQ6
wqDCoMKgwqDCoMKgwqAgUENMSyBvdXRwdXQgZW5hYmxlDQo+PiArwqDCoMKgwqAgKiAtIFszOjBd
OsKgwqDCoCBEWzk6Nl0gb3V0cHV0IGVuYWJsZQ0KPj4gK8KgwqDCoMKgICovDQo+PiArwqDCoMKg
IHJldCA9IG92NTY0MF93cml0ZV9yZWcoc2Vuc29yLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBPVjU2NDBfUkVHX1BBRF9PVVRQVVRfRU5BQkxFMDEsIG9uID8gMHg3
ZiA6IDApOw0KPj4gK8KgwqDCoCBpZiAocmV0KQ0KPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBy
ZXQ7DQo+PiArDQo+PiArwqDCoMKgIC8qDQo+PiArwqDCoMKgwqAgKiBlbmFibGUgRFs1OjJdIERW
UCBkYXRhIGxpbmVzIChEWzA6MV0gYXJlIHVudXNlZCB3aXRoIDggYml0cw0KPj4gK8KgwqDCoMKg
ICogcGFyYWxsZWwgbW9kZSwgOCBiaXRzIG91dHB1dCBhcmUgbWFwcGVkIG9uIERbOToyXSkNCj4+
ICvCoMKgwqDCoCAqDQo+PiArwqDCoMKgwqAgKiBQQUQgT1VUUFVUIEVOQUJMRSAwMg0KPj4gK8Kg
wqDCoMKgICogLSBbNzo0XTrCoMKgwqAgRFs1OjJdIG91dHB1dCBlbmFibGUNCj4+ICvCoMKgwqDC
oCAqwqDCoMKgwqDCoMKgwqAgMDoxIGFyZSB1bnVzZWQgd2l0aCA4IGJpdHMNCj4+ICvCoMKgwqDC
oCAqwqDCoMKgwqDCoMKgwqAgcGFyYWxsZWwgbW9kZSAoOCBiaXRzIG91dHB1dA0KPj4gK8KgwqDC
oMKgICrCoMKgwqDCoMKgwqDCoCBhcmUgb24gRFs5OjJdKQ0KPj4gK8KgwqDCoMKgICovDQo+IA0K
PiBJdCBzaG91bGQgYmUgdmVyaWZpZWQgaW4gdGhpcyBkcml2ZXIsIGF0IHByb2JlLCB0aGF0IHRo
ZSBkZXZpY2UgdHJlZQ0KPiBlbmRwb2ludCBmb3IgdGhlIE9WNTY0MCBvdXRwdXQgcGFyYWxsZWwg
aW50ZXJmYWNlIGhhcyBzcGVjaWZpZWQgdGhpcw0KPiB3aXRoICJidXMtd2lkdGg9PDg+OyBkYXRh
LXNoaWZ0PTwyPjsiDQo+IA0KPiBTdGV2ZQ0KPiANCg0KSSBoYXZlIGNoYW5nZWQgdGhlIGNvZGUg
ZW5hYmxpbmcgdGhlIHdob2xlIDEwIGJpdHM6DQoJLyoNCgkgKiBlbmFibGUgVlNZTkMvSFJFRi9Q
Q0xLIERWUCBjb250cm9sIGxpbmVzDQoJICogJiBEWzk6Nl0gRFZQIGRhdGEgbGluZXMNCgkgKg0K
CSAqIFBBRCBPVVRQVVQgRU5BQkxFIDAxDQoJICogLSA2OgkJVlNZTkMgb3V0cHV0IGVuYWJsZQ0K
CSAqIC0gNToJCUhSRUYgb3V0cHV0IGVuYWJsZQ0KCSAqIC0gNDoJCVBDTEsgb3V0cHV0IGVuYWJs
ZQ0KCSAqIC0gWzM6MF06CURbOTo2XSBvdXRwdXQgZW5hYmxlDQoJICovDQoJcmV0ID0gb3Y1NjQw
X3dyaXRlX3JlZyhzZW5zb3IsDQoJCQkgICAgICAgT1Y1NjQwX1JFR19QQURfT1VUUFVUX0VOQUJM
RTAxLA0KCQkJICAgICAgIG9uID8gMHg3RiA6IDApOw0KDQpkb2luZyBzbywgbm8gbmVlZCB0byB2
ZXJpZnkgYnVzLXdpZHRoL2RhdGEtc2hpZnQsIGFuZCBzZW5zb3IgaXMgcmVhZHkgDQpmb3IgMTAg
Yml0cyBvdXRwdXQuDQpJbiBhZGRpdGlvbiB0byB0aGlzIEkgY2FuIGRvIGEgY2hlY2sgYXQgcHJv
YmUgdmVyaWZ5aW5nIHRoYXQgDQpidXMtd2lkdGgvZGF0YS1zaGlmdCBhcmUgdmFsaWQsIGllIDgv
MiBvciAxMC8wLCB3aGF0IGRvIHlvdSB0aGluayBhYm91dCANCnRoaXMgPw0KDQoNCj4+ICvCoMKg
wqAgcmV0dXJuIG92NTY0MF93cml0ZV9yZWcoc2Vuc29yLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBPVjU2NDBfUkVHX1BBRF9PVVRQVVRfRU5BQkxFMDIsIG9uID8gMHhmMCA6
IDApOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgaW50IG92NTY0MF9zZXRfc3RyZWFtX21pcGko
c3RydWN0IG92NTY0MF9kZXYgKnNlbnNvciwgYm9vbCBvbikNCj4+IMKgIHsNCj4+IMKgwqDCoMKg
wqAgaW50IHJldDsNCj4+IEBAIC0xNTk4LDE3ICsxNjYyLDE5IEBAIHN0YXRpYyBpbnQgb3Y1NjQw
X3NldF9wb3dlcihzdHJ1Y3Qgb3Y1NjQwX2RldiANCj4+ICpzZW5zb3IsIGJvb2wgb24pDQo+PiDC
oMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGdvdG8gcG93ZXJfb2ZmOw0KPj4gLcKgwqDCoMKgwqDCoMKgIC8qDQo+PiAtwqDCoMKgwqDCoMKg
wqDCoCAqIHN0YXJ0IHN0cmVhbWluZyBicmllZmx5IGZvbGxvd2VkIGJ5IHN0cmVhbSBvZmYgaW4N
Cj4+IC3CoMKgwqDCoMKgwqDCoMKgICogb3JkZXIgdG8gY29heCB0aGUgY2xvY2sgbGFuZSBpbnRv
IExQLTExIHN0YXRlLg0KPj4gLcKgwqDCoMKgwqDCoMKgwqAgKi8NCj4+IC3CoMKgwqDCoMKgwqDC
oCByZXQgPSBvdjU2NDBfc2V0X3N0cmVhbShzZW5zb3IsIHRydWUpOw0KPj4gLcKgwqDCoMKgwqDC
oMKgIGlmIChyZXQpDQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIHBvd2VyX29mZjsN
Cj4+IC3CoMKgwqDCoMKgwqDCoCB1c2xlZXBfcmFuZ2UoMTAwMCwgMjAwMCk7DQo+PiAtwqDCoMKg
wqDCoMKgwqAgcmV0ID0gb3Y1NjQwX3NldF9zdHJlYW0oc2Vuc29yLCBmYWxzZSk7DQo+PiAtwqDC
oMKgwqDCoMKgwqAgaWYgKHJldCkNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gcG93
ZXJfb2ZmOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChzZW5zb3ItPmVwLmJ1c190eXBlID09IFY0
TDJfTUJVU19DU0kyKSB7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKg0KPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqIHN0YXJ0IHN0cmVhbWluZyBicmllZmx5IGZvbGxvd2VkIGJ5
IHN0cmVhbSBvZmYgaW4NCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBvcmRlciB0byBj
b2F4IHRoZSBjbG9jayBsYW5lIGludG8gTFAtMTEgc3RhdGUuDQo+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgICovDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBvdjU2NDBfc2V0
X3N0cmVhbV9taXBpKHNlbnNvciwgdHJ1ZSk7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBp
ZiAocmV0KQ0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIHBvd2VyX29m
ZjsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVzbGVlcF9yYW5nZSgxMDAwLCAyMDAwKTsN
Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IG92NTY0MF9zZXRfc3RyZWFtX21pcGko
c2Vuc29yLCBmYWxzZSk7DQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KQ0KPj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIHBvd2VyX29mZjsNCj4+ICvCoMKg
wqDCoMKgwqDCoCB9DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+PiDCoMKgwqDC
oMKgIH0NCj4+IEBAIC0yMTg1LDcgKzIyNTEsMTEgQEAgc3RhdGljIGludCBvdjU2NDBfc19zdHJl
YW0oc3RydWN0IHY0bDJfc3ViZGV2IA0KPj4gKnNkLCBpbnQgZW5hYmxlKQ0KPj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsNCj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCB9DQo+PiAtwqDCoMKgwqDCoMKgwqAgcmV0ID0gb3Y1NjQwX3NldF9zdHJlYW0oc2Vuc29yLCBl
bmFibGUpOw0KPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChzZW5zb3ItPmVwLmJ1c190eXBlID09IFY0
TDJfTUJVU19DU0kyKQ0KPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gb3Y1NjQwX3Nl
dF9zdHJlYW1fbWlwaShzZW5zb3IsIGVuYWJsZSk7DQo+PiArwqDCoMKgwqDCoMKgwqAgZWxzZQ0K
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gb3Y1NjQwX3NldF9zdHJlYW1fZHZwKHNl
bnNvciwgZW5hYmxlKTsNCj4+ICsNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXJldCkNCj4+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNlbnNvci0+c3RyZWFtaW5nID0gZW5hYmxlOw0K
Pj4gwqDCoMKgwqDCoCB9DQo+PiBAQCAtMjI3MCwxMSArMjM0MCw2IEBAIHN0YXRpYyBpbnQgb3Y1
NjQwX3Byb2JlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsDQo+PiDCoMKgwqDCoMKgwqDCoMKg
wqAgcmV0dXJuIHJldDsNCj4+IMKgwqDCoMKgwqAgfQ0KPj4gLcKgwqDCoCBpZiAoc2Vuc29yLT5l
cC5idXNfdHlwZSAhPSBWNEwyX01CVVNfQ1NJMikgew0KPj4gLcKgwqDCoMKgwqDCoMKgIGRldl9l
cnIoZGV2LCAiaW52YWxpZCBidXMgdHlwZSwgbXVzdCBiZSBNSVBJIENTSTJcbiIpOw0KPj4gLcKg
wqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOw0KPj4gLcKgwqDCoCB9DQo+PiAtDQo+PiDCoMKg
wqDCoMKgIC8qIGdldCBzeXN0ZW0gY2xvY2sgKHhjbGspICovDQo+PiDCoMKgwqDCoMKgIHNlbnNv
ci0+eGNsayA9IGRldm1fY2xrX2dldChkZXYsICJ4Y2xrIik7DQo+PiDCoMKgwqDCoMKgIGlmIChJ
U19FUlIoc2Vuc29yLT54Y2xrKSkgew0KPiANCg0KQmVzdCByZWdhcmRzLA0KSHVndWVzLg==
