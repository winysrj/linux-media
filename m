Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48071 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729439AbeJAVcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 17:32:23 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com"
        <linux-stm32@st-md-mailman.stormreply.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH 3/4] media: dt-bindings: media: Document
 pclk-max-frequency property
Date: Mon, 1 Oct 2018 14:53:30 +0000
Message-ID: <1e57c359-9916-0629-7a33-48435204db94@st.com>
References: <1538059567-8381-1-git-send-email-hugues.fruchet@st.com>
 <1538059567-8381-4-git-send-email-hugues.fruchet@st.com>
 <20180928070312.a22olexufppfejes@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180928070312.a22olexufppfejes@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <52487EC1A447024282EC935AD05A70C2@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU2FrYXJpLA0KDQpPbiAwOS8yOC8yMDE4IDA5OjAzIEFNLCBTYWthcmkgQWlsdXMgd3JvdGU6
DQo+IEhpIEh1Z3VlcywNCj4gDQo+IE9uIFRodSwgU2VwIDI3LCAyMDE4IGF0IDA0OjQ2OjA2UE0g
KzAyMDAsIEh1Z3VlcyBGcnVjaGV0IHdyb3RlOg0KPj4gVGhpcyBvcHRpb25hbCBwcm9wZXJ0eSBh
aW1zIHRvIGluZm9ybSBwYXJhbGxlbCB2aWRlbyBkZXZpY2VzDQo+PiBvZiB0aGUgbWF4aW11bSBw
aXhlbCBjbG9jayBmcmVxdWVuY3kgYWRtaXNzaWJsZSBieSBob3N0IHZpZGVvDQo+PiBpbnRlcmZh
Y2UuIElmIGJhbmR3aWR0aCBvZiBkYXRhIHRvIGJlIHRyYW5zZmVycmVkIHJlcXVpcmVzIGENCj4+
IHBpeGVsIGNsb2NrIHdoaWNoIGlzIGhpZ2hlciB0aGFuIHRoaXMgdmFsdWUsIHBhcmFsbGVsIHZp
ZGVvDQo+PiBkZXZpY2UgY291bGQgdGhlbiB0eXBpY2FsbHkgYWRhcHQgZnJhbWVyYXRlIHRvIHJl
YWNoDQo+PiB0aGlzIGNvbnN0cmFpbnQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSHVndWVzIEZy
dWNoZXQgPGh1Z3Vlcy5mcnVjaGV0QHN0LmNvbT4NCj4+IC0tLQ0KPj4gICBEb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvdmlkZW8taW50ZXJmYWNlcy50eHQgfCAyICsrDQo+
PiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3ZpZGVvLWludGVyZmFjZXMu
dHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3ZpZGVvLWludGVy
ZmFjZXMudHh0DQo+PiBpbmRleCBiYWY5ZDk3Li5mYTRjMTEyIDEwMDY0NA0KPj4gLS0tIGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3ZpZGVvLWludGVyZmFjZXMudHh0
DQo+PiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvdmlkZW8t
aW50ZXJmYWNlcy50eHQNCj4+IEBAIC0xNDcsNiArMTQ3LDggQEAgT3B0aW9uYWwgZW5kcG9pbnQg
cHJvcGVydGllcw0KPj4gICAgIGFzIDAgKG5vcm1hbCkuIFRoaXMgcHJvcGVydHkgaXMgdmFsaWQg
Zm9yIHNlcmlhbCBidXNzZXMgb25seS4NCj4+ICAgLSBzdHJvYmU6IFdoZXRoZXIgdGhlIGNsb2Nr
IHNpZ25hbCBpcyB1c2VkIGFzIGNsb2NrICgwKSBvciBzdHJvYmUgKDEpLiBVc2VkDQo+PiAgICAg
d2l0aCBDQ1AyLCBmb3IgaW5zdGFuY2UuDQo+PiArLSBwY2xrLW1heC1mcmVxdWVuY3k6IG1heGlt
dW0gcGl4ZWwgY2xvY2sgZnJlcXVlbmN5IGFkbWlzc2libGUgYnkgdmlkZW8NCj4+ICsgIGhvc3Qg
aW50ZXJmYWNlLg0KPiANCj4gSXMgdGhlcmUgYSBsaW1pdCBvbiB0aGUgcGl4ZWwgY2xvY2sgb3Ig
dGhlIGxpbmsgZnJlcXVlbmN5Pw0KDQpUaGUgY29uc3RyYWludCBpcyB0aGUgZnJlcXVlbmN5IG9m
IHRoZSBjbG9jayBpbiBpbnB1dCBvZiB0aGUgU29DIChwaXhlbCANCmNsb2NrIGxpbmUpLg0KDQo+
IA0KPiBXZSBkbyBoYXZlIGEgcHJvcGVydHkgZm9yIHRoZSBsaW5rIGZyZXF1ZW5jeSBhbmQgYSBj
b250cm9sIGZvciB0aGUgcGl4ZWwNCj4gbG9jayBhcyB3ZWxsIGFzIGZvciB0aGUgbGluayBmcmVx
dWVuY3kuIENvdWxkIHRoZXNlIGJlIHVzZWQgZm9yIHRoZQ0KPiBwdXJwb3NlPw0KDQpBcyB0aGlz
IHdhcyBkb2N1bWVudGVkIG1haW5seSBmb3IgTUlQSS1DU0kyIEkgd2FzIG5vdCBjbGVhciBpZiB0
aGlzIA0KY291bGQgYmUgdXNlZCBvciBub3QsIGJ1dCB2aWRlby1pbnRlcmZhY2UudHh0IGJpbmRp
bmcgbGV0IG9wZW4gdGhlIGRvb3INCnRvIHBhcmFsbGVsIHBvcnQgdXNhZ2UuLi4NCkkgaGFkIGFs
c28gc29tZSBoZXNpdGF0aW9ucyB0byB1c2UgdGhpcyBwcm9wZXJ0eSBiZWNhdXNlIHdoYXQgSSB3
YXMgDQpzZWFyY2hpbmcgZm9yIGhlcmUgd2FzIGEgbWF4aW11bSBsaW1pdCB0byBub3QgZXhjZWVk
IHdoaWxlIA0KImxpbmstZnJlcXVlbmNpZXMiIGlzIGRlc2NyaWJlZCBhcyBmcmVxdWVuY2llcyB0
byB1c2U6ICJBbGxvd2VkIGRhdGEgYnVzIA0KZnJlcXVlbmNpZXMiLg0KVGhlIGZhY3QgdGhhdCB0
aGVyZSB3YXMgc2V2ZXJhbCBlbnRyaWVzIGZvciB0aGlzIHByb3BlcnR5IHdhcyBhbHNvIHF1aXRl
IA0KY29uZnVzaW5nLg0KV2hhdCBJIGNhbiBkbyBpcyB0byB1c2UgdGhpcyBwcm9wZXJ0eSBhbmQg
YWRkIGEgY29tbWVudCBleHBsYWluaW5nIHRoYXQgDQp0aGlzIGNhbiBhbHNvIGJlIHVzZWQgZm9y
IHBhcmFsbGVsIHBvcnQgYXMgdGhlIGZyZXF1ZW5jeSB0byBub3QgZXhjZWVkIA0Kb24gcGl4ZWwg
Y2xvY2sgc2lnbmFsLCB3aGF0IGRvIHlvdSB0aGluayBhYm91dCBpdCA/DQoNCkNoZWNraW5nIGRy
aXZlcnMgd2hpY2ggYXJlIGltcGxlbWVudGluZyAibGluay1mcmVxdWVuY2llcyIsIEkndmUgZm91
bmQgDQpPVjI2NTkgc2Vuc29yIHdoaWNoIGlzIGRvaW5nIGFsbW9zdCB3aGF0IEkgd2FudCB0bywg
aWUgY29tcHV0ZSB0aGUgY2xvY2sgDQpyYXRlIGRlcGVuZGluZyBvbiBsaW5rLWZyZXF1ZW5jeSwg
c2VlIG92MjY1OV9wbGxfY2FsY19wYXJhbXMoKS4NCg0KPiANCj4gVGhlIGxpbmsgZnJlcXVlbmN5
IGluIGdlbmVyYWwgc2hvdWxkIGJlIHNwZWNpZmllZCBmb3IgdGhlIGJvYXJkLCBhbmQgdGhhdA0K
PiBsaW1pdHMgdGhlIHBpeGVsIGNsb2NrIGFzIHdlbGwgaW4gdGhlIGNhc2UgdGhlIGJ1cyB0cmFu
c2ZlcnMgYSBnaXZlbiBudW1iZXINCj4gb2YgcGl4ZWxzIHBlciBjbG9jay4NCj4gDQo+IFRoZSBP
TUFQM0lTUCBkcml2ZXIgYWxzbyBhZGRyZXNzIHRoaXMgYnkgcmVhZGluZyBiYWNrIHRoZSBwaXhl
bCBjbG9jayBmcm9tDQo+IHRoZSBzZW5zb3IgYmVmb3JlIHN0YXJ0aW5nIHN0cmVhbWluZy4NCj4g
DQoNCkJSLA0KSHVndWVzLg==
