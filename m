Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51674 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751041AbeACJNF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 04:13:05 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v4 3/5] media: dt-bindings: ov5640: refine CSI-2 and add
 parallel interface
Date: Wed, 3 Jan 2018 09:12:43 +0000
Message-ID: <e8b3900a-7fe0-d6d6-049d-86cd1e5a35e3@st.com>
References: <1513763474-1174-1-git-send-email-hugues.fruchet@st.com>
 <1513763474-1174-4-git-send-email-hugues.fruchet@st.com>
 <20180102122046.iso43ungfndrjhlp@valkosipuli.retiisi.org.uk>
 <20180102122453.u4tb7cmy5ig76v7z@valkosipuli.retiisi.org.uk>
 <55be0bed-7964-fc94-58fb-d385b1adcc98@st.com>
 <20180103091021.x2yego3wmhsq6bfx@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180103091021.x2yego3wmhsq6bfx@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FB64FDE10BC34479AD505FCFCA6B2D8@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

T0ssIHRoYW5rcyBmb3IgYWxsIFNha2FyaSAhDQoNCk9uIDAxLzAzLzIwMTggMTA6MTAgQU0sIFNh
a2FyaSBBaWx1cyB3cm90ZToNCj4gT24gV2VkLCBKYW4gMDMsIDIwMTggYXQgMDg6NDc6MDlBTSAr
MDAwMCwgSHVndWVzIEZSVUNIRVQgd3JvdGU6DQo+PiBIaSBTYWthcmksDQo+PiB0aGlzIGlzIGZp
bmUgZm9yIG1lIHRvIGRyb3AgdGhvc2UgdHdvIGxpbmVzIHNvIHN5bmMgc2lnbmFscyBiZWNvbWUN
Cj4+IG1hbmRhdG9yeS4NCj4+IE11c3QgSSByZXBvc3QgYSB2NSBzZXJpZSA/DQo+IA0KPiBIZXJl
J3MgdGhlIGRpZmY6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL21lZGlhL2kyYy9vdjU2NDAudHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL21lZGlhL2kyYy9vdjU2NDAudHh0DQo+IGluZGV4IGUyNmE4NDY0NjYwMy4uOGUz
NmRhMGQ4NDA2IDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbWVkaWEvaTJjL292NTY0MC50eHQNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL21lZGlhL2kyYy9vdjU2NDAudHh0DQo+IEBAIC0zMSw4ICszMSw2IEBAIEVuZHBv
aW50IG5vZGUgcmVxdWlyZWQgcHJvcGVydGllcyBmb3IgcGFyYWxsZWwgY29ubmVjdGlvbiBhcmU6
DQo+ICAgCSAgICAgb3IgPDEwPiBmb3IgMTAgYml0cyBwYXJhbGxlbCBidXMNCj4gICAtIGRhdGEt
c2hpZnQ6IHNoYWxsIGJlIHNldCB0byA8Mj4gZm9yIDggYml0cyBwYXJhbGxlbCBidXMNCj4gICAJ
ICAgICAgKGxpbmVzIDk6MiBhcmUgdXNlZCkgb3IgPDA+IGZvciAxMCBiaXRzIHBhcmFsbGVsIGJ1
cw0KPiAtDQo+IC1FbmRwb2ludCBub2RlIG9wdGlvbmFsIHByb3BlcnRpZXMgZm9yIHBhcmFsbGVs
IGNvbm5lY3Rpb24gYXJlOg0KPiAgIC0gaHN5bmMtYWN0aXZlOiBhY3RpdmUgc3RhdGUgb2YgdGhl
IEhTWU5DIHNpZ25hbCwgMC8xIGZvciBMT1cvSElHSCByZXNwZWN0aXZlbHkuDQo+ICAgLSB2c3lu
Yy1hY3RpdmU6IGFjdGl2ZSBzdGF0ZSBvZiB0aGUgVlNZTkMgc2lnbmFsLCAwLzEgZm9yIExPVy9I
SUdIIHJlc3BlY3RpdmVseS4NCj4gICAtIHBjbGstc2FtcGxlOiBzYW1wbGUgZGF0YSBvbiByaXNp
bmcgKDEpIG9yIGZhbGxpbmcgKDApIGVkZ2Ugb2YgdGhlIHBpeGVsIGNsb2NrDQo+IA==
