Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:32185 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750968AbdEIHhN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 03:37:13 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>
Subject: Re: [PATCH v5 2/8] [media] stm32-dcmi: STM32 DCMI camera interface
 driver
Date: Tue, 9 May 2017 07:36:34 +0000
Message-ID: <5d588e10-4185-60c5-de38-54b2a4428ae6@st.com>
References: <1493998287-5828-1-git-send-email-hugues.fruchet@st.com>
 <1493998287-5828-3-git-send-email-hugues.fruchet@st.com>
 <dd4a1ec1-b84a-81cb-51b6-c2e53b5efcc5@xs4all.nl>
In-Reply-To: <dd4a1ec1-b84a-81cb-51b6-c2e53b5efcc5@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <55EF19CDA8ED04469180783B236B4A77@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgSGFucywNCkl0J3MgT0ssIGZlZWwgZnJlZSB0byBjaGFuZ2UuDQpCUg0KSHVndWVzLg0KDQoN
Ck9uIDA1LzA2LzIwMTcgMTA6NTQgQU0sIEhhbnMgVmVya3VpbCB3cm90ZToNCj4gSGkgSHVndWVz
LA0KPg0KPiBPbiAwNS8wNS8yMDE3IDA1OjMxIFBNLCBIdWd1ZXMgRnJ1Y2hldCB3cm90ZToNCj4+
IFRoaXMgVjRMMiBzdWJkZXYgZHJpdmVyIGVuYWJsZXMgRGlnaXRhbCBDYW1lcmEgTWVtb3J5IElu
dGVyZmFjZSAoRENNSSkNCj4+IG9mIFNUTWljcm9lbGVjdHJvbmljcyBTVE0zMiBTb0Mgc2VyaWVz
Lg0KPj4NCj4+IFJldmlld2VkLWJ5OiBIYW5zIFZlcmt1aWwgPGhhbnMudmVya3VpbEBjaXNjby5j
b20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBZYW5uaWNrIEZlcnRyZSA8eWFubmljay5mZXJ0cmVAc3Qu
Y29tPg0KPj4gU2lnbmVkLW9mZi1ieTogSHVndWVzIEZydWNoZXQgPGh1Z3Vlcy5mcnVjaGV0QHN0
LmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vS2NvbmZpZyAgICAgICAg
ICAgIHwgICAxMiArDQo+PiAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9NYWtlZmlsZSAgICAgICAg
ICAgfCAgICAyICsNCj4+ICBkcml2ZXJzL21lZGlhL3BsYXRmb3JtL3N0bTMyL01ha2VmaWxlICAg
ICB8ICAgIDEgKw0KPj4gIGRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vc3RtMzIvc3RtMzItZGNtaS5j
IHwgMTQwMyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4gIDQgZmlsZXMgY2hhbmdl
ZCwgMTQxOCBpbnNlcnRpb25zKCspDQo+PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWVk
aWEvcGxhdGZvcm0vc3RtMzIvTWFrZWZpbGUNCj4+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVy
cy9tZWRpYS9wbGF0Zm9ybS9zdG0zMi9zdG0zMi1kY21pLmMNCj4+DQo+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9LY29uZmlnIGIvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9L
Y29uZmlnDQo+PiBpbmRleCBhYzAyNmVlLi5kZTZlMThiIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVy
cy9tZWRpYS9wbGF0Zm9ybS9LY29uZmlnDQo+PiArKysgYi9kcml2ZXJzL21lZGlhL3BsYXRmb3Jt
L0tjb25maWcNCj4+IEBAIC0xMTQsNiArMTE0LDE4IEBAIGNvbmZpZyBWSURFT19TM0NfQ0FNSUYN
Cj4+ICAJICBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBjaG9vc2UgTSBoZXJl
OiB0aGUgbW9kdWxlDQo+PiAgCSAgd2lsbCBiZSBjYWxsZWQgczNjLWNhbWlmLg0KPj4NCj4+ICtj
b25maWcgVklERU9fU1RNMzJfRENNSQ0KPj4gKwl0cmlzdGF0ZSAiRGlnaXRhbCBDYW1lcmEgTWVt
b3J5IEludGVyZmFjZSAoRENNSSkgc3VwcG9ydCINCj4NCj4gSXMgaXQgT0sgd2l0aCB5b3UgaWYg
SSBjaGFuZ2UgdGhpcyB0bzoNCj4NCj4gCXRyaXN0YXRlICJTVE0zMiBEaWdpdGFsIENhbWVyYSBN
ZW1vcnkgSW50ZXJmYWNlIChEQ01JKSBzdXBwb3J0Ig0KPg0KPiBSaWdodCBub3cgdGhlIHRleHQg
Z2l2ZXMgbm8gaW5kaWNhdGlvbiB0aGF0IHRoaXMgZHJpdmVyIGlzIGZvciBhbiBTVE0zMiBwbGF0
Zm9ybS4NCj4NCj4gTm8gbmVlZCB0byBzcGluIGEgbmV3IHBhdGNoLCBqdXN0IGxldCBtZSBrbm93
IHlvdSdyZSBPSyB3aXRoIGl0IGFuZCBJJ2xsIG1ha2UNCj4gdGhlIGNoYW5nZS4NCj4NCj4gUmVn
YXJkcywNCj4NCj4gCUhhbnMNCj4NCj4+ICsJZGVwZW5kcyBvbiBWSURFT19WNEwyICYmIE9GICYm
IEhBU19ETUENCj4+ICsJZGVwZW5kcyBvbiBBUkNIX1NUTTMyIHx8IENPTVBJTEVfVEVTVA0KPj4g
KwlzZWxlY3QgVklERU9CVUYyX0RNQV9DT05USUcNCj4+ICsJLS0taGVscC0tLQ0KPj4gKwkgIFRo
aXMgbW9kdWxlIG1ha2VzIHRoZSBTVE0zMiBEaWdpdGFsIENhbWVyYSBNZW1vcnkgSW50ZXJmYWNl
IChEQ01JKQ0KPj4gKwkgIGF2YWlsYWJsZSBhcyBhIHY0bDIgZGV2aWNlLg0KPj4gKw0KPj4gKwkg
IFRvIGNvbXBpbGUgdGhpcyBkcml2ZXIgYXMgYSBtb2R1bGUsIGNob29zZSBNIGhlcmU6IHRoZSBt
b2R1bGUNCj4+ICsJICB3aWxsIGJlIGNhbGxlZCBzdG0zMi1kY21pLg0KPj4gKw0KPj4gIHNvdXJj
ZSAiZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9zb2NfY2FtZXJhL0tjb25maWciDQo+PiAgc291cmNl
ICJkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2V4eW5vczQtaXMvS2NvbmZpZyINCj4+ICBzb3VyY2Ug
ImRyaXZlcnMvbWVkaWEvcGxhdGZvcm0vYW00Mzd4L0tjb25maWci
