Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:6340 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751371AbdGRMxs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 08:53:48 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: "H. Nikolaus Schaller" <hns@goldelico.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Yannick FERTRE" <yannick.fertre@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] [PATCH v2 0/7] Add support of OV9655 camera
Date: Tue, 18 Jul 2017 12:53:12 +0000
Message-ID: <2dd3402e-55b0-231d-878f-5ba95ee8cb36@st.com>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
 <8157da84-1484-8375-1f2b-9831973915b4@kernel.org>
 <956f17e6-36dd-6733-0d35-9b801ed4244d@xs4all.nl>
 <BCD1BD18-96E3-4638-8935-B5C832D8EE52@goldelico.com>
In-Reply-To: <BCD1BD18-96E3-4638-8935-B5C832D8EE52@goldelico.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <0606AD7205958C4DB8FD3950C939896E@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQoNCk9uIDA3LzE4LzIwMTcgMDI6MTcgUE0sIEguIE5pa29sYXVzIFNjaGFsbGVyIHdyb3RlOg0K
PiBIaSwNCj4gDQo+PiBBbSAxOC4wNy4yMDE3IHVtIDEzOjU5IHNjaHJpZWIgSGFucyBWZXJrdWls
IDxodmVya3VpbEB4czRhbGwubmw+Og0KPj4NCj4+IE9uIDEyLzA3LzE3IDIyOjAxLCBTeWx3ZXN0
ZXIgTmF3cm9ja2kgd3JvdGU6DQo+Pj4gSGkgSHVndWVzLA0KPj4+DQo+Pj4gT24gMDcvMDMvMjAx
NyAxMToxNiBBTSwgSHVndWVzIEZydWNoZXQgd3JvdGU6DQo+Pj4+IFRoaXMgcGF0Y2hzZXQgZW5h
YmxlcyBPVjk2NTUgY2FtZXJhIHN1cHBvcnQuDQo+Pj4+DQo+Pj4+IE9WOTY1NSBzdXBwb3J0IGhh
cyBiZWVuIHRlc3RlZCB1c2luZyBTVE0zMkY0RElTLUNBTSBleHRlbnNpb24gYm9hcmQNCj4+Pj4g
cGx1Z2dlZCBvbiBjb25uZWN0b3IgUDEgb2YgU1RNMzJGNzQ2Ry1ESVNDTyBib2FyZC4NCj4+Pj4g
RHVlIHRvIGxhY2sgb2YgT1Y5NjUwLzUyIGhhcmR3YXJlIHN1cHBvcnQsIHRoZSBtb2RpZmllZCBy
ZWxhdGVkIGNvZGUNCj4+Pj4gY291bGQgbm90IGhhdmUgYmVlbiBjaGVja2VkIGZvciBub24tcmVn
cmVzc2lvbi4NCj4+Pj4NCj4+Pj4gRmlyc3QgcGF0Y2hlcyB1cGdyYWRlIGN1cnJlbnQgc3VwcG9y
dCBvZiBPVjk2NTAvNTIgdG8gcHJlcGFyZSB0aGVuDQo+Pj4+IGludHJvZHVjdGlvbiBvZiBPVjk2
NTUgdmFyaWFudCBwYXRjaC4NCj4+Pj4gQmVjYXVzZSBvZiBPVjk2NTUgcmVnaXN0ZXIgc2V0IHNs
aWdodGx5IGRpZmZlcmVudCBmcm9tIE9WOTY1MC85NjUyLA0KPj4+PiBub3QgYWxsIG9mIHRoZSBk
cml2ZXIgZmVhdHVyZXMgYXJlIHN1cHBvcnRlZCAoY29udHJvbHMpLiBTdXBwb3J0ZWQNCj4+Pj4g
cmVzb2x1dGlvbnMgYXJlIGxpbWl0ZWQgdG8gVkdBLCBRVkdBLCBRUVZHQS4NCj4+Pj4gU3VwcG9y
dGVkIGZvcm1hdCBpcyBsaW1pdGVkIHRvIFJHQjU2NS4NCj4+Pj4gQ29udHJvbHMgYXJlIGxpbWl0
ZWQgdG8gY29sb3IgYmFyIHRlc3QgcGF0dGVybiBmb3IgdGVzdCBwdXJwb3NlLg0KPj4+DQo+Pj4g
SSBhcHByZWNpYXRlIHlvdXIgZWZmb3J0cyB0b3dhcmRzIG1ha2luZyBhIGNvbW1vbiBkcml2ZXIg
YnV0IElNTyBpdCB3b3VsZCBiZQ0KPj4+IGJldHRlciB0byBjcmVhdGUgYSBzZXBhcmF0ZSBkcml2
ZXIgZm9yIHRoZSBPVjk2NTUgc2Vuc29yLiAgVGhlIG9yaWdpbmFsIGRyaXZlcg0KPj4+IGlzIDE1
NzYgbGluZXMgb2YgY29kZSwgeW91ciBwYXRjaCBzZXQgYWRkcyBoYWxmIG9mIHRoYXQgKDgxNiku
ICBUaGVyZSBhcmUNCj4+PiBzaWduaWZpY2FudCBkaWZmZXJlbmNlcyBpbiB0aGUgZmVhdHVyZSBz
ZXQgb2YgYm90aCBzZW5zb3JzLCB0aGVyZSBhcmUNCj4+PiBkaWZmZXJlbmNlcyBpbiB0aGUgcmVn
aXN0ZXIgbGF5b3V0LiAgSSB3b3VsZCBnbyBmb3IgYSBzZXBhcmF0ZSBkcml2ZXIsIHdlDQo+Pj4g
d291bGQgdGhlbiBoYXZlIGNvZGUgZWFzaWVyIHRvIGZvbGxvdyBhbmQgd291bGRuJ3QgbmVlZCB0
byB3b3JyeSBhYm91dCBwb3NzaWJsZQ0KPj4+IHJlZ3Jlc3Npb25zLiAgSSdtIGFmcmFpZCBJIGhh
dmUgbG9zdCB0aGUgY2FtZXJhIG1vZHVsZSBhbmQgd29uJ3QgYmUgYWJsZQ0KPj4+IHRvIHRlc3Qg
dGhlIHBhdGNoIHNldCBhZ2FpbnN0IHJlZ3Jlc3Npb25zLg0KPj4+DQo+Pj4gSU1ITyBmcm9tIG1h
aW50ZW5hbmNlIFBPViBpdCdzIGJldHRlciB0byBtYWtlIGEgc2VwYXJhdGUgZHJpdmVyLiBJbiB0
aGUgZW5kDQo+Pj4gb2YgdGhlIGRheSB3ZSB3b3VsZG4ndCBiZSBhZGRpbmcgbXVjaCBtb3JlIGNv
ZGUgdGhhbiBpdCBpcyBiZWluZyBkb25lIG5vdy4NCj4+DQo+PiBJIGFncmVlLiBXZSBkbyBub3Qg
aGF2ZSBncmVhdCBleHBlcmllbmNlcyBpbiB0aGUgcGFzdCB3aXRoIHRyeWluZyB0byBzdXBwb3J0
DQo+PiBtdWx0aXBsZSB2YXJpYW50cyBpbiBhIHNpbmdsZSBkcml2ZXIgKHVubGVzcyB0aGUgZGlm
ZnMgYXJlIHRydWx5IHNtYWxsKS4NCj4gDQo+IFdlbGwsDQo+IElNSE8gdGhlIGRpZmZzIGluIG92
OTY1eCBhcmUgc21hbGxlciAoYnV0IHVudGVzdGFibGUgYmVjYXVzZSBub2JvZHkgc2VlbXMNCj4g
dG8gaGF2ZSBhbiBvdjk2NTAvNTIgYm9hcmQpIHRoYW4gd2l0aGluIHRoZSBicTI3eHh4IGNoaXBz
LCBidXQgSSBjYW4gZGlnIG91dA0KPiBhbiBvbGQgcGRhdGEgYmFzZWQgc2VwYXJhdGUgb3Y5NjU1
IGRyaXZlciBhbmQgZXh0ZW5kIHRoYXQgdG8gYmVjb21lIERUIGNvbXBhdGlibGUuDQo+IA0KPiBJ
IGhhZCBhYmFuZG9uZWQgdGhhdCBzZXBhcmF0ZSBhcHByb2FjaCBpbiBmYXZvdXIgb2YgZXh0ZW5k
aW5nIHRoZSBvdjk2NXggZHJpdmVyLg0KPiANCj4gSGF2ZSB0byBkaXNjdXNzIHdpdGggSHVndWVz
IGhvdyB0byBwcm9jZWVkLg0KPiANCj4gQlIgYW5kIHRoYW5rcywNCj4gTmlrb2xhdXMNCj4gDQoN
CkFzIFN5bHdlc3RlciBhbmQgSGFucywgSSdtIGFsc28gaW4gZmxhdm91ciBvZiBhIHNlcGFyYXRl
IGRyaXZlciwgdGhlIA0KZmFjdCB0aGF0IHJlZ2lzdGVyIHNldCBzZWVtcyBzaW1pbGFyIGJ1dCBp
biBmYWN0IGlzIG5vdCBhbmQgdGhhdCB3ZSANCmNhbm5vdCB0ZXN0IGZvciBub24tcmVncmVzc2lv
biBvZiA5NjUwLzUyIGFyZSBraWxsZXIgZm9yIG1lIHRvIGNvbnRpbnVlIA0Kb24gYSBzaW5nbGUg
ZHJpdmVyLg0KV2UgY2FuIG5vdyByZXN0YXJ0IGZyb20gYSBuZXcgZnJlc2ggc3RhdGUgb2YgdGhl
IGFydCBzZW5zb3IgZHJpdmVyIA0KZ2V0dGluZyByaWQgb2YgbGVnYWN5IChwZGF0YSwgb2xkIGdw
aW8sIGV0Yy4uLikuDQoNCkJSLA0KSHVndWVzLg==
