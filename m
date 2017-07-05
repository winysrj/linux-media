Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:31326 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751626AbdGEOtH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 10:49:07 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Rob Herring <robh@kernel.org>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>
Subject: Re: [PATCH v2 1/7] DT bindings: add bindings for ov965x camera module
Date: Wed, 5 Jul 2017 14:48:15 +0000
Message-ID: <6fa2e20e-ac19-0296-d481-f0cb4aa4a231@st.com>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
 <1499073368-31905-2-git-send-email-hugues.fruchet@st.com>
 <20170705140305.pixlhd65xu6g3nlf@rob-hp-laptop>
In-Reply-To: <20170705140305.pixlhd65xu6g3nlf@rob-hp-laptop>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B72E720168E7A4888E0005E8C16AB31@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQpPbiAwNy8wNS8yMDE3IDA0OjAzIFBNLCBSb2IgSGVycmluZyB3cm90ZToNCj4gT24gTW9uLCBK
dWwgMDMsIDIwMTcgYXQgMTE6MTY6MDJBTSArMDIwMCwgSHVndWVzIEZydWNoZXQgd3JvdGU6DQo+
PiBGcm9tOiAiSC4gTmlrb2xhdXMgU2NoYWxsZXIiIDxobnNAZ29sZGVsaWNvLmNvbT4NCj4+DQo+
PiBUaGlzIGFkZHMgZG9jdW1lbnRhdGlvbiBvZiBkZXZpY2UgdHJlZSBiaW5kaW5ncw0KPj4gZm9y
IHRoZSBPVjk2NVggZmFtaWx5IGNhbWVyYSBzZW5zb3IgbW9kdWxlLg0KPj4NCj4+IFNpZ25lZC1v
ZmYtYnk6IEguIE5pa29sYXVzIFNjaGFsbGVyIDxobnNAZ29sZGVsaWNvLmNvbT4NCj4+IFNpZ25l
ZC1vZmYtYnk6IEh1Z3VlcyBGcnVjaGV0IDxodWd1ZXMuZnJ1Y2hldEBzdC5jb20+DQo+PiAtLS0N
Cj4+ICAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvaTJjL292OTY1eC50eHQgICAgICAg
fCA0NSArKysrKysrKysrKysrKysrKysrKysrDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCA0NSBpbnNl
cnRpb25zKCspDQo+PiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbWVkaWEvaTJjL292OTY1eC50eHQNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL2kyYy9vdjk2NXgudHh0IGIvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL2kyYy9vdjk2NXgudHh0DQo+PiBu
ZXcgZmlsZSBtb2RlIDEwMDY0NA0KPj4gaW5kZXggMDAwMDAwMC4uNGNlYjcyNw0KPj4gLS0tIC9k
ZXYvbnVsbA0KPj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlh
L2kyYy9vdjk2NXgudHh0DQo+PiBAQCAtMCwwICsxLDQ1IEBADQo+PiArKiBPbW5pdmlzaW9uIE9W
OTY1MC85NjUyLzk2NTUgQ01PUyBzZW5zb3INCj4+ICsNCj4+ICtUaGUgT21uaXZpc2lvbiBPVjk2
NXggc2Vuc29yIHN1cHBvcnQgbXVsdGlwbGUgcmVzb2x1dGlvbnMgb3V0cHV0LCBzdWNoIGFzDQo+
PiArQ0lGLCBTVkdBLCBVWEdBLiBJdCBhbHNvIGNhbiBzdXBwb3J0IFlVVjQyMi80MjAsIFJHQjU2
NS81NTUgb3IgcmF3IFJHQg0KPj4gK291dHB1dCBmb3JtYXQuDQo+PiArDQo+PiArUmVxdWlyZWQg
UHJvcGVydGllczoNCj4+ICstIGNvbXBhdGlibGU6IHNob3VsZCBiZSBvbmUgb2YNCj4+ICsJIm92
dGksb3Y5NjUwIg0KPj4gKwkib3Z0aSxvdjk2NTIiDQo+PiArCSJvdnRpLG92OTY1NSINCj4+ICst
IGNsb2NrczogcmVmZXJlbmNlIHRvIHRoZSBtY2xrIGlucHV0IGNsb2NrLg0KPj4gKw0KPj4gK09w
dGlvbmFsIFByb3BlcnRpZXM6DQo+PiArLSByZXNldGItZ3Bpb3M6IHJlZmVyZW5jZSB0byB0aGUg
R1BJTyBjb25uZWN0ZWQgdG8gdGhlIFJFU0VUQiBwaW4sIGlmIGFueSwNCj4+ICsJCXBvbGFyaXR5
IGlzIGFjdGl2ZSBsb3cuDQo+IA0KPiByZXNldC1ncGlvcw0KPiANCj4+ICstIHB3ZG4tZ3Bpb3M6
IHJlZmVyZW5jZSB0byB0aGUgR1BJTyBjb25uZWN0ZWQgdG8gdGhlIFBXRE4gcGluLCBpZiBhbnks
DQo+PiArCQlwb2xhcml0eSBpcyBhY3RpdmUgaGlnaC4NCj4gDQo+IHBvd2VyZG93bi1ncGlvcw0K
PiANCj4gQm90aCBhcmUgc3RhbmRhcmRpc2ggbmFtZXMgZm9yIHN1Y2ggc2lnbmFscy4NCj4gDQo+
IFJvYg0KDQpUaGFua3MgUm9iLCBJIHdpbGwgZml4LA0KSHVndWVzLg0KDQo+IA==
