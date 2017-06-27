Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56854 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752920AbdF0KPg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 06:15:36 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>
Subject: Re: [PATCH v1 2/6] [media] ov9650: add device tree support
Date: Tue, 27 Jun 2017 10:14:46 +0000
Message-ID: <00c5784a-8e13-be01-5c9e-4747aaa14ae5@st.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <1498143942-12682-3-git-send-email-hugues.fruchet@st.com>
 <20170626163102.GQ12407@valkosipuli.retiisi.org.uk>
 <D780984B-70A1-4E9C-A887-DD2CBAAC7CCA@goldelico.com>
 <20170627053642.GW12407@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170627053642.GW12407@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B917BC86A1C8248B4FEBDFE843330DF@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQoNCk9uIDA2LzI3LzIwMTcgMDc6MzYgQU0sIFNha2FyaSBBaWx1cyB3cm90ZToNCj4gT24gTW9u
LCBKdW4gMjYsIDIwMTcgYXQgMDc6NDY6MzRQTSArMDIwMCwgSC4gTmlrb2xhdXMgU2NoYWxsZXIg
d3JvdGU6DQo+PiBIaSwNCj4+DQo+Pj4gQW0gMjYuMDYuMjAxNyB1bSAxODozMSBzY2hyaWViIFNh
a2FyaSBBaWx1cyA8c2FrYXJpLmFpbHVzQGlraS5maT46DQo+Pj4NCj4+PiBIaSBIdWd1ZXMsDQo+
Pj4NCj4+PiBPbiBUaHUsIEp1biAyMiwgMjAxNyBhdCAwNTowNTozOFBNICswMjAwLCBIdWd1ZXMg
RnJ1Y2hldCB3cm90ZToNCj4+Pj4gQEAgLTE1NDUsMTUgKzE1NzcsMjIgQEAgc3RhdGljIGludCBv
djk2NXhfcmVtb3ZlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQpDQo+Pj4+IH0NCj4+Pj4NCj4+
Pj4gc3RhdGljIGNvbnN0IHN0cnVjdCBpMmNfZGV2aWNlX2lkIG92OTY1eF9pZFtdID0gew0KPj4+
PiAtCXsgIk9WOTY1MCIsIDAgfSwNCj4+Pj4gLQl7ICJPVjk2NTIiLCAwIH0sDQo+Pj4+ICsJeyAi
T1Y5NjUwIiwgMHg5NjUwIH0sDQo+Pj4+ICsJeyAiT1Y5NjUyIiwgMHg5NjUyIH0sDQo+Pj4NCj4+
PiBUaGlzIGNoYW5nZSBkb2VzIG5vdCBhcHBlYXIgdG8gbWF0Y2ggd2l0aCB0aGUgcGF0Y2ggZGVz
Y3JpcHRpb24gbm9yIGl0IHRoZQ0KPj4+IGluZm9ybWF0aW9uIGlzIHVzZWQuIEhvdyBhYm91dCBu
b3QgY2hhbmdpbmcgaXQsIHVubGVzcyB0aGVyZSdzIGEgcmVhc29uIHRvPw0KPj4+IFRoZSBzYW1l
IGZvciB0aGUgZGF0YSBmaWVsZCBvZiB0aGUgb2ZfZGV2aWNlX2lkIGFycmF5IGJlbG93Lg0KPj4N
Cj4+IEkgdGhpbmsgaXQgY291bGQvc2hvdWxkIGJlIHVzZWQgdG8gY2hlY2sgaWYgdGhlIGNhbWVy
YSBjaGlwIHRoYXQgaXMgZm91bmQNCj4+IGJ5IHJlYWRpbmcgdGhlIHByb2R1Y3QtaWQgYW5kIHZl
cnNpb24gcmVnaXN0ZXJzIGRvZXMgbWF0Y2ggd2hhdCB0aGUgZGV2aWNlDQo+PiB0cmVlIGV4cGVj
dHMgYW5kIGFib3J0IHByb2Jpbmcgb24gYSBtaXNtYXRjaC4NCj4gDQo+IE1ha2VzIHNlbnNlLiBC
dXQgaXQgc2hvdWxkIGJlIGEgc2VwYXJhdGUgcGF0Y2gsIHNob3VsZG4ndCBpdD8NCj4gDQo+IFlv
dSBjb3VsZCBhbHNvIHB1dCB0aGUgaWQgdG8gdGhlIG9wcyBzdHJ1Y3QsIGFuZCBjaG9vc2UgdGhl
IG9wcyBzdHJ1Y3QgdGhhdA0KPiB3YXkuIEVudGlyZWx5IHVwIHRvIHlvdS4NCj4gDQoNCkknbGwg
c3VnZ2VzdCB0byBza2lwIHRoZSBpZCBjaGVjayBiZXR3ZWVuIERUIGNvbXBhdGlibGUgc3RyaW5n
IGFuZCByZWFsIA0KZGV2aWNlIGlkIHJlYWQgZnJvbSBzZW5zb3IsIHRoaXMgaXMgbm90IHNvbWV0
aGluZyBJIHNlZSBpbiBvdGhlciBkcml2ZXJzIA0KY3VycmVudGx5Lg0KQnV0IEkgd291bGQgc3Vn
Z2VzdCB0byBrZWVwIGluIGEgc2VwYXJhdGUgcGF0Y2ggdGhlIHN3aXRjaCBvZiBkZXZpY2UgaWQg
DQpuYW1lcyB0byBsb3dlciBjYXNlIGluIG9yZGVyIHRvIGFsaWduIHdpdGggb3RoZXIgb21uaXZp
c2lvbiBjYW1lcmFzIGFuZCANCm5vdCBpbnRyb2R1Y2UgdXBwZXIvbG93ZXIgY2FzZSBwb3RlbnRp
YWwgYnVncyBpbiBEVCBsYXRlciBvbiAoYXMgdGhlIG9uZSANCmVuY291bnRlcmVkIGJ5IE5pa29s
YXVzKToNCg0KICBbbWVkaWFdIG92OTY1MDogc3dpdGNoIGkyYyBkZXZpY2UgaWQgdG8gbG93ZXIg
Y2FzZQ0KDQogIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaTJjX2RldmljZV9pZCBvdjk2NXhfaWRbXSA9
IHsNCi0JeyAiT1Y5NjUwIiwgMCB9LA0KLQl7ICJPVjk2NTIiLCAwIH0sDQorCXsgIm92OTY1MCIs
IDAgfSwNCisJeyAib3Y5NjUyIiwgMCB9LA0KDQoNCiAgW21lZGlhXSBvdjk2NTA6IGFkZCBkZXZp
Y2UgdHJlZSBzdXBwb3J0DQoNCitzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBvdjk2
NXhfb2ZfbWF0Y2hbXSA9IHsNCisJeyAuY29tcGF0aWJsZSA9ICJvdnRpLG92OTY1MCIsIH0sDQor
CXsgLmNvbXBhdGlibGUgPSAib3Z0aSxvdjk2NTIiLCB9LA0KKwl7IC8qIHNlbnRpbmVsICovIH0N
Cit9Ow0KK01PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIG92OTY1eF9vZl9tYXRjaCk7DQorDQogIHN0
YXRpYyBzdHJ1Y3QgaTJjX2RyaXZlciBvdjk2NXhfaTJjX2RyaXZlciA9IHsNCiAgCS5kcml2ZXIg
PSB7DQogIAkJLm5hbWUJPSBEUklWRVJfTkFNRSwNCisJCS5vZl9tYXRjaF90YWJsZSA9IG9mX21h
dGNoX3B0cihvdjk2NXhfb2ZfbWF0Y2gpLA0KDQo=
