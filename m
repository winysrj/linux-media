Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:36196 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754475AbeFMIKR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 04:10:17 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Rob Herring <robh@kernel.org>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 2/2] media: ov5640: add support of module orientation
Date: Wed, 13 Jun 2018 08:10:02 +0000
Message-ID: <0701a0f6-bc39-1754-55e2-1de9b9394b5b@st.com>
References: <1528709357-7251-1-git-send-email-hugues.fruchet@st.com>
 <1528709357-7251-3-git-send-email-hugues.fruchet@st.com>
 <20180612220628.GA18467@rob-hp-laptop>
In-Reply-To: <20180612220628.GA18467@rob-hp-laptop>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5918F1678A0F74FB02965DD628498AF@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgUm9iLCB0aGFua3MgZm9yIHJldmlldywNCg0KT24gMDYvMTMvMjAxOCAxMjowNiBBTSwgUm9i
IEhlcnJpbmcgd3JvdGU6DQo+IE9uIE1vbiwgSnVuIDExLCAyMDE4IGF0IDExOjI5OjE3QU0gKzAy
MDAsIEh1Z3VlcyBGcnVjaGV0IHdyb3RlOg0KPj4gQWRkIHN1cHBvcnQgb2YgbW9kdWxlIGJlaW5n
IHBoeXNpY2FsbHkgbW91bnRlZCB1cHNpZGUgZG93bi4NCj4+IEluIHRoaXMgY2FzZSwgbWlycm9y
IGFuZCBmbGlwIGFyZSBlbmFibGVkIHRvIGZpeCBjYXB0dXJlZCBpbWFnZXMNCj4+IG9yaWVudGF0
aW9uLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEh1Z3VlcyBGcnVjaGV0IDxodWd1ZXMuZnJ1Y2hl
dEBzdC5jb20+DQo+PiAtLS0NCj4+ICAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvaTJj
L292NTY0MC50eHQgICAgICAgfCAgMyArKysNCj4gDQo+IFBsZWFzZSBzcGxpdCBiaW5kaW5ncyB0
byBzZXBhcmF0ZSBwYXRjaGVzLg0KDQpPSywgd2lsbCBkbyBpbiBuZXh0IHBhdGNoc2V0Lg0KDQo+
IA0KPj4gICBkcml2ZXJzL21lZGlhL2kyYy9vdjU2NDAuYyAgICAgICAgICAgICAgICAgICAgICAg
ICB8IDI4ICsrKysrKysrKysrKysrKysrKysrLS0NCj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCAyOSBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvaTJjL292NTY0MC50eHQgYi9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvaTJjL292NTY0MC50eHQNCj4+IGluZGV4
IDhlMzZkYTAuLmY3NmViN2UgMTAwNjQ0DQo+PiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbWVkaWEvaTJjL292NTY0MC50eHQNCj4+ICsrKyBiL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9pMmMvb3Y1NjQwLnR4dA0KPj4gQEAgLTEzLDYgKzEz
LDggQEAgT3B0aW9uYWwgUHJvcGVydGllczoNCj4+ICAgCSAgICAgICBUaGlzIGlzIGFuIGFjdGl2
ZSBsb3cgc2lnbmFsIHRvIHRoZSBPVjU2NDAuDQo+PiAgIC0gcG93ZXJkb3duLWdwaW9zOiByZWZl
cmVuY2UgdG8gdGhlIEdQSU8gY29ubmVjdGVkIHRvIHRoZSBwb3dlcmRvd24gcGluLA0KPj4gICAJ
CSAgIGlmIGFueS4gVGhpcyBpcyBhbiBhY3RpdmUgaGlnaCBzaWduYWwgdG8gdGhlIE9WNTY0MC4N
Cj4+ICstIHJvdGF0aW9uOiBpbnRlZ2VyIHByb3BlcnR5OyB2YWxpZCB2YWx1ZXMgYXJlIDAgKHNl
bnNvciBtb3VudGVkIHVwcmlnaHQpDQo+PiArCSAgICBhbmQgMTgwIChzZW5zb3IgbW91bnRlZCB1
cHNpZGUgZG93bikuDQo+IA0KPiBEaWRuJ3Qgd2UganVzdCBhZGQgdGhpcyBhcyBhIGNvbW1vbiBw
cm9wZXJ0eT8gSWYgc28sIGp1c3QgcmVmZXJlbmNlIHRoZQ0KPiBjb21tb24gZGVmaW5pdGlvbi4g
SWYgbm90LCBpdCBuZWVkcyBhIGNvbW1vbiBkZWZpbml0aW9uLg0KPiANCg0KQSBjb21tb24gZGVm
aW5pdGlvbiBoYXMgYmVlbiBpbnRyb2R1Y2VkIGJ5IFNha2FyaSwgSSdtIHJldXNpbmcgaXQsIHNl
ZToNCmh0dHBzOi8vd3d3Lm1haWwtYXJjaGl2ZS5jb20vbGludXgtbWVkaWFAdmdlci5rZXJuZWwu
b3JnL21zZzEzMjUxNy5odG1sDQoNCkkgd291bGQgc28gcHJvcG9zZToNCiA+PiArLSByb3RhdGlv
bjogYXMgZGVmaW5lZCBpbg0KID4+ICsJRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L21lZGlhL3ZpZGVvLWludGVyZmFjZXMudHh0Lg0KDQoNCkJlc3QgcmVnYXJkcywNCkh1Z3Vlcy4=
