Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35153 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934978AbeFMKKH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 06:10:07 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Rob Herring <robh@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 2/2] media: ov5640: add support of module orientation
Date: Wed, 13 Jun 2018 10:09:58 +0000
Message-ID: <c109edf3-53f0-d80a-5d06-f56b49284045@st.com>
References: <1528709357-7251-1-git-send-email-hugues.fruchet@st.com>
 <1528709357-7251-3-git-send-email-hugues.fruchet@st.com>
 <20180612220628.GA18467@rob-hp-laptop>
 <0701a0f6-bc39-1754-55e2-1de9b9394b5b@st.com>
 <20180613082438.j7w5knhxtjcdjxng@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180613082438.j7w5knhxtjcdjxng@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBFA97BFBFEC234AAD948D340542A734@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU2FrYXJpLCBSb2IsDQoNCkZpbmQgYSBuZXcgcHJvcG9zYWwgYmVsb3c6DQoNCk9uIDA2LzEz
LzIwMTggMTA6MjQgQU0sIFNha2FyaSBBaWx1cyB3cm90ZToNCj4gT24gV2VkLCBKdW4gMTMsIDIw
MTggYXQgMDg6MTA6MDJBTSArMDAwMCwgSHVndWVzIEZSVUNIRVQgd3JvdGU6DQo+PiBIaSBSb2Is
IHRoYW5rcyBmb3IgcmV2aWV3LA0KPj4NCj4+IE9uIDA2LzEzLzIwMTggMTI6MDYgQU0sIFJvYiBI
ZXJyaW5nIHdyb3RlOg0KPj4+IE9uIE1vbiwgSnVuIDExLCAyMDE4IGF0IDExOjI5OjE3QU0gKzAy
MDAsIEh1Z3VlcyBGcnVjaGV0IHdyb3RlOg0KPj4+PiBBZGQgc3VwcG9ydCBvZiBtb2R1bGUgYmVp
bmcgcGh5c2ljYWxseSBtb3VudGVkIHVwc2lkZSBkb3duLg0KPj4+PiBJbiB0aGlzIGNhc2UsIG1p
cnJvciBhbmQgZmxpcCBhcmUgZW5hYmxlZCB0byBmaXggY2FwdHVyZWQgaW1hZ2VzDQo+Pj4+IG9y
aWVudGF0aW9uLg0KPj4+Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBIdWd1ZXMgRnJ1Y2hldCA8aHVn
dWVzLmZydWNoZXRAc3QuY29tPg0KPj4+PiAtLS0NCj4+Pj4gICAgLi4uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbWVkaWEvaTJjL292NTY0MC50eHQgICAgICAgfCAgMyArKysNCj4+Pg0KPj4+IFBsZWFz
ZSBzcGxpdCBiaW5kaW5ncyB0byBzZXBhcmF0ZSBwYXRjaGVzLg0KPj4NCj4+IE9LLCB3aWxsIGRv
IGluIG5leHQgcGF0Y2hzZXQuDQo+Pg0KPj4+DQo+Pj4+ICAgIGRyaXZlcnMvbWVkaWEvaTJjL292
NTY0MC5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgMjggKysrKysrKysrKysrKysrKysrKyst
LQ0KPj4+PiAgICAyIGZpbGVzIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbWVkaWEvaTJjL292NTY0MC50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbWVkaWEvaTJjL292NTY0MC50eHQNCj4+Pj4gaW5kZXggOGUzNmRhMC4uZjc2ZWI3ZSAx
MDA2NDQNCj4+Pj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlh
L2kyYy9vdjU2NDAudHh0DQo+Pj4+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9tZWRpYS9pMmMvb3Y1NjQwLnR4dA0KPj4+PiBAQCAtMTMsNiArMTMsOCBAQCBPcHRpb25h
bCBQcm9wZXJ0aWVzOg0KPj4+PiAgICAJICAgICAgIFRoaXMgaXMgYW4gYWN0aXZlIGxvdyBzaWdu
YWwgdG8gdGhlIE9WNTY0MC4NCj4+Pj4gICAgLSBwb3dlcmRvd24tZ3Bpb3M6IHJlZmVyZW5jZSB0
byB0aGUgR1BJTyBjb25uZWN0ZWQgdG8gdGhlIHBvd2VyZG93biBwaW4sDQo+Pj4+ICAgIAkJICAg
aWYgYW55LiBUaGlzIGlzIGFuIGFjdGl2ZSBoaWdoIHNpZ25hbCB0byB0aGUgT1Y1NjQwLg0KPj4+
PiArLSByb3RhdGlvbjogaW50ZWdlciBwcm9wZXJ0eTsgdmFsaWQgdmFsdWVzIGFyZSAwIChzZW5z
b3IgbW91bnRlZCB1cHJpZ2h0KQ0KPj4+PiArCSAgICBhbmQgMTgwIChzZW5zb3IgbW91bnRlZCB1
cHNpZGUgZG93bikuDQo+Pj4NCj4+PiBEaWRuJ3Qgd2UganVzdCBhZGQgdGhpcyBhcyBhIGNvbW1v
biBwcm9wZXJ0eT8gSWYgc28sIGp1c3QgcmVmZXJlbmNlIHRoZQ0KPj4+IGNvbW1vbiBkZWZpbml0
aW9uLiBJZiBub3QsIGl0IG5lZWRzIGEgY29tbW9uIGRlZmluaXRpb24uDQo+Pj4NCj4+DQo+PiBB
IGNvbW1vbiBkZWZpbml0aW9uIGhhcyBiZWVuIGludHJvZHVjZWQgYnkgU2FrYXJpLCBJJ20gcmV1
c2luZyBpdCwgc2VlOg0KPj4gaHR0cHM6Ly93d3cubWFpbC1hcmNoaXZlLmNvbS9saW51eC1tZWRp
YUB2Z2VyLmtlcm5lbC5vcmcvbXNnMTMyNTE3Lmh0bWwNCj4+DQo+PiBJIHdvdWxkIHNvIHByb3Bv
c2U6DQo+PiAgID4+ICstIHJvdGF0aW9uOiBhcyBkZWZpbmVkIGluDQo+PiAgID4+ICsJRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3ZpZGVvLWludGVyZmFjZXMudHh0Lg0K
PiANCj4gU2hvdWxkbid0IHRoZSBkZXNjcmlwdGlvbiBzdGlsbCBpbmNsdWRlIHRoZSB2YWxpZCB2
YWx1ZXM/IEFzIGZhciBhcyBJIGNhbg0KPiB0ZWxsLCB0aGVzZSBhcmUgdWx0aW1hdGVseSBkZXZp
Y2Ugc3BlY2lmaWMgYWxiZWl0IG1vcmUgb3IgbGVzcyB0aGUgc2FtZSBmb3INCj4gKnRoaXMga2lu
ZCogb2Ygc2Vuc29ycy4NCg0KWWVzIHlvdSdyZSByaWdodCwgbGV0J3MgcHV0IGJvdGggdG9nZXRo
ZXI6DQorLSByb3RhdGlvbjogYXMgZGVmaW5lZCBpbg0KKwlEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbWVkaWEvdmlkZW8taW50ZXJmYWNlcy50eHQsDQorCXZhbGlkIHZhbHVlcyBh
cmUgMCAoc2Vuc29yIG1vdW50ZWQgdXByaWdodCkgYW5kIDE4MCAoc2Vuc29yDQorCW1vdW50ZWQg
dXBzaWRlIGRvd24pLg0KDQoNCj4gDQo+IFRoZSBmaWxlIGFscmVhZHkgY29udGFpbnMgYSByZWZl
cmVuY2UgdG8gdmlkZW8taW50ZXJmYWNlcy50eHQuDQo+IA0KWWVzIGJ1dCBpdCB3YXMgcmVsYXRl
ZCB0byAncG9ydCcgY2hpbGQgbm9kZS4NCg0KQmVzdCByZWdhcmRzLA0KSHVndWVzLg==
