Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:39946 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751668AbeACIrX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 03:47:23 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v4 3/5] media: dt-bindings: ov5640: refine CSI-2 and add
 parallel interface
Date: Wed, 3 Jan 2018 08:47:09 +0000
Message-ID: <55be0bed-7964-fc94-58fb-d385b1adcc98@st.com>
References: <1513763474-1174-1-git-send-email-hugues.fruchet@st.com>
 <1513763474-1174-4-git-send-email-hugues.fruchet@st.com>
 <20180102122046.iso43ungfndrjhlp@valkosipuli.retiisi.org.uk>
 <20180102122453.u4tb7cmy5ig76v7z@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180102122453.u4tb7cmy5ig76v7z@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7398FC6F50A2C44BD6D13983573D04B@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU2FrYXJpLA0KdGhpcyBpcyBmaW5lIGZvciBtZSB0byBkcm9wIHRob3NlIHR3byBsaW5lcyBz
byBzeW5jIHNpZ25hbHMgYmVjb21lIA0KbWFuZGF0b3J5Lg0KTXVzdCBJIHJlcG9zdCBhIHY1IHNl
cmllID8NCg0KQmVzdCByZWdhcmRzLA0KSHVndWVzLg0KDQpPbiAwMS8wMi8yMDE4IDAxOjI0IFBN
LCBTYWthcmkgQWlsdXMgd3JvdGU6DQo+IE9uIFR1ZSwgSmFuIDAyLCAyMDE4IGF0IDAyOjIwOjQ2
UE0gKzAyMDAsIFNha2FyaSBBaWx1cyB3cm90ZToNCj4+IEhpIEh1Z3VlcywNCj4+DQo+PiBPbmUg
bW9yZSB0aGluZywgcGxlYXNlIHNlZSBiZWxvdy4NCj4+DQo+PiBPbiBXZWQsIERlYyAyMCwgMjAx
NyBhdCAxMDo1MToxMkFNICswMTAwLCBIdWd1ZXMgRnJ1Y2hldCB3cm90ZToNCj4+PiBSZWZpbmUg
Q1NJLTIgZW5kcG9pbnQgZG9jdW1lbnRhdGlvbiBhbmQgYWRkIGJpbmRpbmdzDQo+Pj4gZm9yIERW
UCBwYXJhbGxlbCBpbnRlcmZhY2Ugc3VwcG9ydC4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IEh1
Z3VlcyBGcnVjaGV0IDxodWd1ZXMuZnJ1Y2hldEBzdC5jb20+DQo+Pj4gLS0tDQo+Pj4gICAuLi4v
ZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9pMmMvb3Y1NjQwLnR4dCAgICAgICB8IDQ4ICsrKysr
KysrKysrKysrKysrKysrKy0NCj4+PiAgIDEgZmlsZSBjaGFuZ2VkLCA0NiBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9pMmMvb3Y1NjQwLnR4dCBiL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9pMmMvb3Y1NjQwLnR4dA0KPj4+IGluZGV4IDU0MGIzNmMu
LmUyNmE4NDYgMTAwNjQ0DQo+Pj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL21lZGlhL2kyYy9vdjU2NDAudHh0DQo+Pj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL21lZGlhL2kyYy9vdjU2NDAudHh0DQo+Pj4gQEAgLTEsNCArMSw0IEBADQo+
Pj4gLSogT21uaXZpc2lvbiBPVjU2NDAgTUlQSSBDU0ktMiBzZW5zb3INCj4+PiArKiBPbW5pdmlz
aW9uIE9WNTY0MCBNSVBJIENTSS0yIC8gcGFyYWxsZWwgc2Vuc29yDQo+Pj4gICANCj4+PiAgIFJl
cXVpcmVkIFByb3BlcnRpZXM6DQo+Pj4gICAtIGNvbXBhdGlibGU6IHNob3VsZCBiZSAib3Z0aSxv
djU2NDAiDQo+Pj4gQEAgLTE4LDcgKzE4LDI3IEBAIFRoZSBkZXZpY2Ugbm9kZSBtdXN0IGNvbnRh
aW4gb25lICdwb3J0JyBjaGlsZCBub2RlIGZvciBpdHMgZGlnaXRhbCBvdXRwdXQNCj4+PiAgIHZp
ZGVvIHBvcnQsIGluIGFjY29yZGFuY2Ugd2l0aCB0aGUgdmlkZW8gaW50ZXJmYWNlIGJpbmRpbmdz
IGRlZmluZWQgaW4NCj4+PiAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRp
YS92aWRlby1pbnRlcmZhY2VzLnR4dC4NCj4+PiAgIA0KPj4+IC1FeGFtcGxlOg0KPj4+ICtPVjU2
NDAgY2FuIGJlIGNvbm5lY3RlZCB0byBhIE1JUEkgQ1NJLTIgYnVzIG9yIGEgcGFyYWxsZWwgYnVz
IGVuZHBvaW50Lg0KPj4+ICsNCj4+PiArRW5kcG9pbnQgbm9kZSByZXF1aXJlZCBwcm9wZXJ0aWVz
IGZvciBDU0ktMiBjb25uZWN0aW9uIGFyZToNCj4+PiArLSByZW1vdGUtZW5kcG9pbnQ6IGEgcGhh
bmRsZSB0byB0aGUgYnVzIHJlY2VpdmVyJ3MgZW5kcG9pbnQgbm9kZS4NCj4+PiArLSBjbG9jay1s
YW5lczogc2hvdWxkIGJlIHNldCB0byA8MD4gKGNsb2NrIGxhbmUgb24gaGFyZHdhcmUgbGFuZSAw
KQ0KPj4+ICstIGRhdGEtbGFuZXM6IHNob3VsZCBiZSBzZXQgdG8gPDE+IG9yIDwxIDI+IChvbmUg
b3IgdHdvIENTSS0yIGxhbmVzIHN1cHBvcnRlZCkNCj4+PiArDQo+Pj4gK0VuZHBvaW50IG5vZGUg
cmVxdWlyZWQgcHJvcGVydGllcyBmb3IgcGFyYWxsZWwgY29ubmVjdGlvbiBhcmU6DQo+Pj4gKy0g
cmVtb3RlLWVuZHBvaW50OiBhIHBoYW5kbGUgdG8gdGhlIGJ1cyByZWNlaXZlcidzIGVuZHBvaW50
IG5vZGUuDQo+Pj4gKy0gYnVzLXdpZHRoOiBzaGFsbCBiZSBzZXQgdG8gPDg+IGZvciA4IGJpdHMg
cGFyYWxsZWwgYnVzDQo+Pj4gKwkgICAgIG9yIDwxMD4gZm9yIDEwIGJpdHMgcGFyYWxsZWwgYnVz
DQo+Pj4gKy0gZGF0YS1zaGlmdDogc2hhbGwgYmUgc2V0IHRvIDwyPiBmb3IgOCBiaXRzIHBhcmFs
bGVsIGJ1cw0KPj4+ICsJICAgICAgKGxpbmVzIDk6MiBhcmUgdXNlZCkgb3IgPDA+IGZvciAxMCBi
aXRzIHBhcmFsbGVsIGJ1cw0KPj4+ICsNCj4+PiArRW5kcG9pbnQgbm9kZSBvcHRpb25hbCBwcm9w
ZXJ0aWVzIGZvciBwYXJhbGxlbCBjb25uZWN0aW9uIGFyZToNCj4gDQo+ICAgICAgIF4NCj4gDQo+
Pj4gKy0gaHN5bmMtYWN0aXZlOiBhY3RpdmUgc3RhdGUgb2YgdGhlIEhTWU5DIHNpZ25hbCwgMC8x
IGZvciBMT1cvSElHSCByZXNwZWN0aXZlbHkuDQo+Pj4gKy0gdnN5bmMtYWN0aXZlOiBhY3RpdmUg
c3RhdGUgb2YgdGhlIFZTWU5DIHNpZ25hbCwgMC8xIGZvciBMT1cvSElHSCByZXNwZWN0aXZlbHku
DQo+Pj4gKy0gcGNsay1zYW1wbGU6IHNhbXBsZSBkYXRhIG9uIHJpc2luZyAoMSkgb3IgZmFsbGlu
ZyAoMCkgZWRnZSBvZiB0aGUgcGl4ZWwgY2xvY2sNCj4+PiArCSAgICAgICBzaWduYWwuDQo+Pg0K
Pj4gSSBwcmVzdW1lIHRoZSBzZW5zb3IgY2FuIGFsc28gZG8gQnQuNjU2IChDQ0lSNjU2KSBpbiB3
aGljaCBjYXNlIHlvdQ0KPj4gd291bGRuJ3Qgc2ltcGx5IGhhdmUgaHN5bmMgLyB2c3luYyBzaWdu
YWxzIGF0IGFsbC4gSG93IGFib3V0IG1ha2luZyB0aGVtDQo+PiBtYW5kYXRvcnkgZm9yIHBhcmFs
bGVsIGJ1cyBub3cgYW5kIHRoZW4gb3B0aW9uYWwgaWYgc3VwcG9ydCBmb3IgQ0NJUjY1Ng0KPj4g
bW9kZSBpcyBhZGRlZD8NCj4gDQo+IElmIHRoaXMgaXMgZmluZSwgdGhlbiBsZXQgbWUga25vdyBp
ZiB5b3UncmUgZmluZSB3aXRoIG1lIGRyb3BwaW5nIHRoZSB0d28NCj4gbGluZXMgYWJvdmUsIHNv
IHRoYXQgb25seSBtYW5kYXRvcnkgcHJvcGVydGllcyBleGlzdC4NCj4gDQo+IFRoZSBzZXQgbG9v
a3Mgb3RoZXJ3aXNlIGdvb2QgdG8gbWUuDQo+IA0KPiBUaGFua3MuDQo+IA0KPj4NCj4+PiArDQo+
Pj4gK0V4YW1wbGVzOg0KPj4+ICAgDQo+Pj4gICAmaTJjMSB7DQo+Pj4gICAJb3Y1NjQwOiBjYW1l
cmFAM2Mgew0KPj4+IEBAIC0zNSw2ICs1NSw3IEBAIEV4YW1wbGU6DQo+Pj4gICAJCXJlc2V0LWdw
aW9zID0gPCZncGlvMSAyMCBHUElPX0FDVElWRV9MT1c+Ow0KPj4+ICAgDQo+Pj4gICAJCXBvcnQg
ew0KPj4+ICsJCQkvKiBNSVBJIENTSS0yIGJ1cyBlbmRwb2ludCAqLw0KPj4+ICAgCQkJb3Y1NjQw
X3RvX21pcGlfY3NpMjogZW5kcG9pbnQgew0KPj4+ICAgCQkJCXJlbW90ZS1lbmRwb2ludCA9IDwm
bWlwaV9jc2kyX2Zyb21fb3Y1NjQwPjsNCj4+PiAgIAkJCQljbG9jay1sYW5lcyA9IDwwPjsNCj4+
PiBAQCAtNDMsMyArNjQsMjYgQEAgRXhhbXBsZToNCj4+PiAgIAkJfTsNCj4+PiAgIAl9Ow0KPj4+
ICAgfTsNCj4+PiArDQo+Pj4gKyZpMmMxIHsNCj4+PiArCW92NTY0MDogY2FtZXJhQDNjIHsNCj4+
PiArCQljb21wYXRpYmxlID0gIm92dGksb3Y1NjQwIjsNCj4+PiArCQlwaW5jdHJsLW5hbWVzID0g
ImRlZmF1bHQiOw0KPj4+ICsJCXBpbmN0cmwtMCA9IDwmcGluY3RybF9vdjU2NDA+Ow0KPj4+ICsJ
CXJlZyA9IDwweDNjPjsNCj4+PiArCQljbG9ja3MgPSA8JmNsa19leHRfY2FtZXJhPjsNCj4+PiAr
CQljbG9jay1uYW1lcyA9ICJ4Y2xrIjsNCj4+PiArDQo+Pj4gKwkJcG9ydCB7DQo+Pj4gKwkJCS8q
IFBhcmFsbGVsIGJ1cyBlbmRwb2ludCAqLw0KPj4+ICsJCQlvdjU2NDBfdG9fcGFyYWxsZWw6IGVu
ZHBvaW50IHsNCj4+PiArCQkJCXJlbW90ZS1lbmRwb2ludCA9IDwmcGFyYWxsZWxfZnJvbV9vdjU2
NDA+Ow0KPj4+ICsJCQkJYnVzLXdpZHRoID0gPDg+Ow0KPj4+ICsJCQkJZGF0YS1zaGlmdCA9IDwy
PjsgLyogbGluZXMgOToyIGFyZSB1c2VkICovDQo+Pj4gKwkJCQloc3luYy1hY3RpdmUgPSA8MD47
DQo+Pj4gKwkJCQl2c3luYy1hY3RpdmUgPSA8MD47DQo+Pj4gKwkJCQlwY2xrLXNhbXBsZSA9IDwx
PjsNCj4+PiArCQkJfTsNCj4+PiArCQl9Ow0KPj4+ICsJfTsNCj4+PiArfTsNCj4+PiAtLSANCj4+
PiAxLjkuMQ0KPj4+DQo+Pg0KPj4gLS0gDQo+PiBTYWthcmkgQWlsdXMNCj4+IGUtbWFpbDogc2Fr
YXJpLmFpbHVzQGlraS5maQ0KPiA=
