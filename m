Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:62713 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751901AbdFZKAS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 06:00:18 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "Rob Herring" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        "kbuild-all@01.org" <kbuild-all@01.org>
Subject: Re: [PATCH v1 5/6] [media] ov9650: add multiple variant support (fwd)
Date: Mon, 26 Jun 2017 09:59:04 +0000
Message-ID: <c58a896c-4955-e051-82b6-395174cdbe7e@st.com>
References: <alpine.DEB.2.20.1706251559180.3109@hadrien>
In-Reply-To: <alpine.DEB.2.20.1706251559180.3109@hadrien>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DEAE6A33F22974AA2DF8424A82E7F86@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

T2sgY291cnNlLCB0aGFua3MgSnVsaWEuDQoNCk9uIDA2LzI1LzIwMTcgMTA6MDAgUE0sIEp1bGlh
IExhd2FsbCB3cm90ZToNCj4gQnJhY2VzIGFyZSBwcm9iYWJseSBtaXNzaW5nIGFyb3VkIGxpbmVz
IDE2MTgtMTYyMC4NCj4gDQo+IGp1bGlhDQo+IA0KPiAtLS0tLS0tLS0tIEZvcndhcmRlZCBtZXNz
YWdlIC0tLS0tLS0tLS0NCj4gRGF0ZTogU3VuLCAyNSBKdW4gMjAxNyAyMzowNjowMyArMDgwMA0K
PiBGcm9tOiBrYnVpbGQgdGVzdCByb2JvdCA8ZmVuZ2d1YW5nLnd1QGludGVsLmNvbT4NCj4gVG86
IGtidWlsZEAwMS5vcmcNCj4gQ2M6IEp1bGlhIExhd2FsbCA8anVsaWEubGF3YWxsQGxpcDYuZnI+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgNS82XSBbbWVkaWFdIG92OTY1MDogYWRkIG11bHRp
cGxlIHZhcmlhbnQgc3VwcG9ydA0KPiANCj4gSGkgSHVndWVzLA0KPiANCj4gW2F1dG8gYnVpbGQg
dGVzdCBXQVJOSU5HIG9uIGxpbnV4dHYtbWVkaWEvbWFzdGVyXQ0KPiBbYWxzbyBidWlsZCB0ZXN0
IFdBUk5JTkcgb24gdjQuMTItcmM2IG5leHQtMjAxNzA2MjNdDQo+IFtpZiB5b3VyIHBhdGNoIGlz
IGFwcGxpZWQgdG8gdGhlIHdyb25nIGdpdCB0cmVlLCBwbGVhc2UgZHJvcCB1cyBhIG5vdGUgdG8g
aGVscCBpbXByb3ZlIHRoZSBzeXN0ZW1dDQo+IA0KPiB1cmw6ICAgIGh0dHBzOi8vZ2l0aHViLmNv
bS8wZGF5LWNpL2xpbnV4L2NvbW1pdHMvSHVndWVzLUZydWNoZXQvQWRkLXN1cHBvcnQtb2YtT1Y5
NjU1LWNhbWVyYS8yMDE3MDYyNS0yMDExNTMNCj4gYmFzZTogICBnaXQ6Ly9saW51eHR2Lm9yZy9t
ZWRpYV90cmVlLmdpdCBtYXN0ZXINCj4gOjo6Ojo6IGJyYW5jaCBkYXRlOiAzIGhvdXJzIGFnbw0K
PiA6Ojo6OjogY29tbWl0IGRhdGU6IDMgaG91cnMgYWdvDQo+IA0KPj4+IGRyaXZlcnMvbWVkaWEv
aTJjL292OTY1MC5jOjE2MTg6Mi00NDogY29kZSBhbGlnbmVkIHdpdGggZm9sbG93aW5nIGNvZGUg
b24gbGluZSAxNjE5DQo+IA0KPiBnaXQgcmVtb3RlIGFkZCBsaW51eC1yZXZpZXcgaHR0cHM6Ly9n
aXRodWIuY29tLzBkYXktY2kvbGludXgNCj4gZ2l0IHJlbW90ZSB1cGRhdGUgbGludXgtcmV2aWV3
DQo+IGdpdCBjaGVja291dCBhOWZlOGMyMzI0MGE3ZjhkZjM5YzYyMzhkOThlNDFmNDFmZWRiNjQx
DQo+IHZpbSArMTYxOCBkcml2ZXJzL21lZGlhL2kyYy9vdjk2NTAuYw0KPiANCj4gYTlmZThjMjMg
SHVndWVzIEZydWNoZXQgICAgIDIwMTctMDYtMjIgIDE2MTIgIAlvdjk2NXgtPnNldF9wYXJhbXMg
PSBfX292OTY1eF9zZXRfcGFyYW1zOw0KPiA4NGExNWRlZCBTeWx3ZXN0ZXIgTmF3cm9ja2kgMjAx
Mi0xMi0yNiAgMTYxMw0KPiBhOWZlOGMyMyBIdWd1ZXMgRnJ1Y2hldCAgICAgMjAxNy0wNi0yMiAg
MTYxNCAgCW92OTY1eC0+ZnJhbWVfc2l6ZSA9ICZvdjk2NXgtPmZyYW1lc2l6ZXNbMF07DQo+IGE5
ZmU4YzIzIEh1Z3VlcyBGcnVjaGV0ICAgICAyMDE3LTA2LTIyICAxNjE1ICAJb3Y5NjV4X2dldF9k
ZWZhdWx0X2Zvcm1hdChvdjk2NXgsICZvdjk2NXgtPmZvcm1hdCk7DQo+IGE5ZmU4YzIzIEh1Z3Vl
cyBGcnVjaGV0ICAgICAyMDE3LTA2LTIyICAxNjE2DQo+IGE5ZmU4YzIzIEh1Z3VlcyBGcnVjaGV0
ICAgICAyMDE3LTA2LTIyICAxNjE3ICAJaWYgKG92OTY1eC0+aW5pdGlhbGl6ZV9jb250cm9scykN
Cj4gYTlmZThjMjMgSHVndWVzIEZydWNoZXQgICAgIDIwMTctMDYtMjIgQDE2MTggIAkJcmV0ID0g
b3Y5NjV4LT5pbml0aWFsaXplX2NvbnRyb2xzKG92OTY1eCk7DQo+IDg0YTE1ZGVkIFN5bHdlc3Rl
ciBOYXdyb2NraSAyMDEyLTEyLTI2IEAxNjE5ICAJCWlmIChyZXQgPCAwKQ0KPiA4NGExNWRlZCBT
eWx3ZXN0ZXIgTmF3cm9ja2kgMjAxMi0xMi0yNiAgMTYyMCAgCQkJZ290byBlcnJfY3RybHM7DQo+
IDg0YTE1ZGVkIFN5bHdlc3RlciBOYXdyb2NraSAyMDEyLTEyLTI2ICAxNjIxDQo+IDg0YTE1ZGVk
IFN5bHdlc3RlciBOYXdyb2NraSAyMDEyLTEyLTI2ICAxNjIyICAJLyogVXBkYXRlIGV4cG9zdXJl
IHRpbWUgbWluL21heCB0byBtYXRjaCBmcmFtZSBmb3JtYXQgKi8NCj4gDQo+IC0tLQ0KPiAwLURB
WSBrZXJuZWwgdGVzdCBpbmZyYXN0cnVjdHVyZSAgICAgICAgICAgICAgICBPcGVuIFNvdXJjZSBU
ZWNobm9sb2d5IENlbnRlcg0KPiBodHRwczovL2xpc3RzLjAxLm9yZy9waXBlcm1haWwva2J1aWxk
LWFsbCAgICAgICAgICAgICAgICAgICBJbnRlbCBDb3Jwb3JhdGlvbg0KPiA=
