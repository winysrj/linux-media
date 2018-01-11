Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55455 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753686AbeAKIMd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 03:12:33 -0500
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
Date: Thu, 11 Jan 2018 08:12:11 +0000
Message-ID: <6661b493-5f2a-b201-390d-e3452e6873a0@st.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
 <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
 <20180110153724.l77zpdgxfbzkznuf@flea>
 <2089de18-1f7f-6d6e-7aee-9dc424bca335@st.com>
 <20180110222508.4x5kimanevttmqis@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180110222508.4x5kimanevttmqis@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <68291FD387E4D64286C641DCC30DDD75@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU2FrYXJpLA0KDQpPbiAwMS8xMC8yMDE4IDExOjI1IFBNLCBTYWthcmkgQWlsdXMgd3JvdGU6
DQo+IEhpIEh1Z3VlcywNCj4gDQo+IE9uIFdlZCwgSmFuIDEwLCAyMDE4IGF0IDAzOjUxOjA3UE0g
KzAwMDAsIEh1Z3VlcyBGUlVDSEVUIHdyb3RlOg0KPj4gR29vZCBuZXdzIE1heGltZSAhDQo+Pg0K
Pj4gSGF2ZSB5b3Ugc2VlbiB0aGF0IHlvdSBjYW4gYWRhcHQgdGhlIHBvbGFyaXRpZXMgdGhyb3Vn
aCBkZXZpY2V0cmVlID8NCj4+DQo+PiArICAgICAgICAgICAgICAgICAgICAgICAvKiBQYXJhbGxl
bCBidXMgZW5kcG9pbnQgKi8NCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIG92NTY0MF90b19w
YXJhbGxlbDogZW5kcG9pbnQgew0KPj4gWy4uLl0NCj4+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgaHN5bmMtYWN0aXZlID0gPDA+Ow0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB2c3luYy1hY3RpdmUgPSA8MD47DQo+PiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHBjbGstc2FtcGxlID0gPDE+Ow0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgfTsN
Cj4+DQo+PiBEb2luZyBzbyB5b3UgY2FuIGFkYXB0IHRvIHlvdXIgU29DL2JvYXJkIHNldHVwIGVh
c2lseS4NCj4+DQo+PiBJZiB5b3UgZG9uJ3QgcHV0IHRob3NlIGxpbmVzIGluIGRldmljZXRyZWUs
IHRoZSBvdjU2NDAgZGVmYXVsdCBpbml0DQo+PiBzZXF1ZW5jZSBpcyB1c2VkIHdoaWNoIHNldCB0
aGUgcG9sYXJpdHkgYXMgZGVmaW5lZCBpbiBiZWxvdyBjb21tZW50Og0KPj4gb3Y1NjQwX3NldF9z
dHJlYW1fZHZwKCkNCj4+IFsuLi5dDQo+PiArICAgICAgICAqIENvbnRyb2wgbGluZXMgcG9sYXJp
dHkgY2FuIGJlIGNvbmZpZ3VyZWQgdGhyb3VnaA0KPj4gKyAgICAgICAgKiBkZXZpY2V0cmVlIGVu
ZHBvaW50IGNvbnRyb2wgbGluZXMgcHJvcGVydGllcy4NCj4+ICsgICAgICAgICogSWYgbm8gZW5k
cG9pbnQgY29udHJvbCBsaW5lcyBwcm9wZXJ0aWVzIGFyZSBzZXQsDQo+PiArICAgICAgICAqIHBv
bGFyaXR5IHdpbGwgYmUgYXMgYmVsb3c6DQo+PiArICAgICAgICAqIC0gVlNZTkM6ICAgICBhY3Rp
dmUgaGlnaA0KPj4gKyAgICAgICAgKiAtIEhSRUY6ICAgICAgYWN0aXZlIGxvdw0KPj4gKyAgICAg
ICAgKiAtIFBDTEs6ICAgICAgYWN0aXZlIGxvdw0KPj4gKyAgICAgICAgKi8NCj4+IFsuLi5dDQo+
IA0KPiBUaGUgcHJvcGVydGllcyBhcmUgYXQgdGhlIG1vbWVudCBkb2N1bWVudGVkIGFzIG1hbmRh
dG9yeSBpbiBEVCBiaW5kaW5nDQo+IGRvY3VtZW50YXRpb24uDQo+IA0Kb2YgY291cnNlLCBpdCB3
YXMganVzdCB0byBhc2sgTWF4aW1lIHRvIGNoZWNrIHRoZSBkZXZpY2V0cmVlIG9uIGl0cyANCnNp
ZGUsIHRoZSBzeW1wdG9tIG9ic2VydmVkIGJ5IE1heGltZSB3aXRoIGhzeW5jL3ZzeW5jIGludmVy
c2VkIGlzIHRoZSANCnNhbWUgdGhhbiB0aGUgb25lIG9ic2VydmVkIGlmIHdlIHN0aWNrIHRvIGp1
c3QgZGVmYXVsdCBpbml0IHNlcXVlbmNlLg0KDQpCUiwNCkh1Z3Vlcy4=
