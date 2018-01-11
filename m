Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:59703 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932180AbeAKI0B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 03:26:01 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Yong Deng <yong.deng@magewell.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        "Hans Verkuil" <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Date: Thu, 11 Jan 2018 08:25:41 +0000
Message-ID: <40f2e25e-3662-fce9-549b-360bbafad623@st.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
 <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
 <20180110153724.l77zpdgxfbzkznuf@flea>
 <2089de18-1f7f-6d6e-7aee-9dc424bca335@st.com>
 <20180110222508.4x5kimanevttmqis@valkosipuli.retiisi.org.uk>
 <6661b493-5f2a-b201-390d-e3452e6873a0@st.com>
 <20180111081912.curkvpguof6ul555@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180111081912.curkvpguof6ul555@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <E67145C52CE1684BB72CB3F244915739@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

T24gMDEvMTEvMjAxOCAwOToxOSBBTSwgU2FrYXJpIEFpbHVzIHdyb3RlOg0KPiBPbiBUaHUsIEph
biAxMSwgMjAxOCBhdCAwODoxMjoxMUFNICswMDAwLCBIdWd1ZXMgRlJVQ0hFVCB3cm90ZToNCj4+
IEhpIFNha2FyaSwNCj4+DQo+PiBPbiAwMS8xMC8yMDE4IDExOjI1IFBNLCBTYWthcmkgQWlsdXMg
d3JvdGU6DQo+Pj4gSGkgSHVndWVzLA0KPj4+DQo+Pj4gT24gV2VkLCBKYW4gMTAsIDIwMTggYXQg
MDM6NTE6MDdQTSArMDAwMCwgSHVndWVzIEZSVUNIRVQgd3JvdGU6DQo+Pj4+IEdvb2QgbmV3cyBN
YXhpbWUgIQ0KPj4+Pg0KPj4+PiBIYXZlIHlvdSBzZWVuIHRoYXQgeW91IGNhbiBhZGFwdCB0aGUg
cG9sYXJpdGllcyB0aHJvdWdoIGRldmljZXRyZWUgPw0KPj4+Pg0KPj4+PiArICAgICAgICAgICAg
ICAgICAgICAgICAvKiBQYXJhbGxlbCBidXMgZW5kcG9pbnQgKi8NCj4+Pj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgb3Y1NjQwX3RvX3BhcmFsbGVsOiBlbmRwb2ludCB7DQo+Pj4+IFsuLi5dDQo+
Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaHN5bmMtYWN0aXZlID0gPDA+Ow0K
Pj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZzeW5jLWFjdGl2ZSA9IDwwPjsN
Cj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwY2xrLXNhbXBsZSA9IDwxPjsN
Cj4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgfTsNCj4+Pj4NCj4+Pj4gRG9pbmcgc28geW91
IGNhbiBhZGFwdCB0byB5b3VyIFNvQy9ib2FyZCBzZXR1cCBlYXNpbHkuDQo+Pj4+DQo+Pj4+IElm
IHlvdSBkb24ndCBwdXQgdGhvc2UgbGluZXMgaW4gZGV2aWNldHJlZSwgdGhlIG92NTY0MCBkZWZh
dWx0IGluaXQNCj4+Pj4gc2VxdWVuY2UgaXMgdXNlZCB3aGljaCBzZXQgdGhlIHBvbGFyaXR5IGFz
IGRlZmluZWQgaW4gYmVsb3cgY29tbWVudDoNCj4+Pj4gb3Y1NjQwX3NldF9zdHJlYW1fZHZwKCkN
Cj4+Pj4gWy4uLl0NCj4+Pj4gKyAgICAgICAgKiBDb250cm9sIGxpbmVzIHBvbGFyaXR5IGNhbiBi
ZSBjb25maWd1cmVkIHRocm91Z2gNCj4+Pj4gKyAgICAgICAgKiBkZXZpY2V0cmVlIGVuZHBvaW50
IGNvbnRyb2wgbGluZXMgcHJvcGVydGllcy4NCj4+Pj4gKyAgICAgICAgKiBJZiBubyBlbmRwb2lu
dCBjb250cm9sIGxpbmVzIHByb3BlcnRpZXMgYXJlIHNldCwNCj4+Pj4gKyAgICAgICAgKiBwb2xh
cml0eSB3aWxsIGJlIGFzIGJlbG93Og0KPj4+PiArICAgICAgICAqIC0gVlNZTkM6ICAgICBhY3Rp
dmUgaGlnaA0KPj4+PiArICAgICAgICAqIC0gSFJFRjogICAgICBhY3RpdmUgbG93DQo+Pj4+ICsg
ICAgICAgICogLSBQQ0xLOiAgICAgIGFjdGl2ZSBsb3cNCj4+Pj4gKyAgICAgICAgKi8NCj4+Pj4g
Wy4uLl0NCj4+Pg0KPj4+IFRoZSBwcm9wZXJ0aWVzIGFyZSBhdCB0aGUgbW9tZW50IGRvY3VtZW50
ZWQgYXMgbWFuZGF0b3J5IGluIERUIGJpbmRpbmcNCj4+PiBkb2N1bWVudGF0aW9uLg0KPj4+DQo+
PiBvZiBjb3Vyc2UsIGl0IHdhcyBqdXN0IHRvIGFzayBNYXhpbWUgdG8gY2hlY2sgdGhlIGRldmlj
ZXRyZWUgb24gaXRzDQo+PiBzaWRlLCB0aGUgc3ltcHRvbSBvYnNlcnZlZCBieSBNYXhpbWUgd2l0
aCBoc3luYy92c3luYyBpbnZlcnNlZCBpcyB0aGUNCj4+IHNhbWUgdGhhbiB0aGUgb25lIG9ic2Vy
dmVkIGlmIHdlIHN0aWNrIHRvIGp1c3QgZGVmYXVsdCBpbml0IHNlcXVlbmNlLg0KPiANCj4gSSB3
b25kZXIgaWYgdGhlIGRyaXZlciBzaG91bGQgYmUgY2hhbmdlZCB0byByZXF1aXJlIGhzeW5jIGFu
ZCB2c3luYy4gVGhlc2UNCj4gc2lnbmFscyB3b24ndCBiZSB0aGVyZSBhdCBhbGwgaW4gQnQuNjU2
IG1vZGUuDQo+IA0KSSB3aWxsIHJldmlzaXQgdGhpcyB3aGVuIHB1c2hpbmcgQnQuNjU2IG1vZGUu
