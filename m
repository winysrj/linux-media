Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:36097 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932623AbeCMNrP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 09:47:15 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 00/12] media: ov5640: Misc cleanup and improvements
Date: Tue, 13 Mar 2018 13:47:04 +0000
Message-ID: <2ce861f3-7a01-f257-e1d3-cfed747e0939@st.com>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
In-Reply-To: <20180302143500.32650-1-maxime.ripard@bootlin.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <3766EF6A23DA454084A7F68865A1F70F@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VGhhbmtzIE1heGltZSBmb3IgdGhpcyBncmVhdCBzZXJpZXMgIQ0KDQpJJ3ZlIHRlc3RlZCB0aGlz
IHNlcmllcyBzdWNjZXNzZnVsbHkgb24gU1RNMzIgcGxhdGZvcm0sIEkgaGFkIGEgDQpyZWdyZXNz
aW9uIG9uIEpQRUcgY2FwdHVyZSBsaW5rZWQgdG8gcmV2aXNpdCBvZiBjbG9ja2luZywgYnV0IGVh
c3kgdG8gZml4Lg0KSSBoYWQgYW5vdGhlciBwcm9ibGVtIGNsYWltZWQgYnkgdjRsMi1jb21wbGlh
bmNlIG9uIGZvcm1hdCB0ZXN0czoNCnY0bDItdGVzdC1mb3JtYXRzLmNwcCg5NjEpOiBWaWRlbyBD
YXB0dXJlOiBTX0ZNVChHX0ZNVCkgIT0gR19GTVQNCnRoaXMgd2FzIG1vcmUgdHJpY2t5IHRvIGZp
eCwgaXQgaXMgbGlua2VkIHRvIGNoYW5nZXMgYXJvdW5kIGZyYW1lcmF0ZSANCmhhbmRsaW5nLg0K
DQpTZWUgbXkgZnVydGhlciBjb21tZW50cyBpbiBjb3JyZXNwb25kaW5nIHBhdGNoc2V0cy4NCg0K
QmVzdCByZWdhcmRzLA0KSHVndWVzLg0KDQpPbiAwMy8wMi8yMDE4IDAzOjM0IFBNLCBNYXhpbWUg
UmlwYXJkIHdyb3RlOg0KPiBIaSwNCj4gDQo+IEhlcmUgaXMgYSAic21hbGwiIHNlcmllcyB0aGF0
IG1vc3RseSBjbGVhbnMgdXAgdGhlIG92NTY0MCBkcml2ZXIgY29kZSwNCj4gc2xvd2x5IGdldHRp
bmcgcmlkIG9mIHRoZSBiaWcgZGF0YSBhcnJheSBmb3IgbW9yZSB1bmRlcnN0YW5kYWJsZSBjb2Rl
DQo+IChob3BlZnVsbHkpLg0KPiANCj4gVGhlIGJpZ2dlc3QgYWRkaXRpb24gd291bGQgYmUgdGhl
IGNsb2NrIHJhdGUgY29tcHV0YXRpb24gYXQgcnVudGltZSwNCj4gaW5zdGVhZCBvZiByZWx5aW5n
IG9uIHRob3NlIGFycmF5cyB0byBzZXR1cCB0aGUgY2xvY2sgdHJlZQ0KPiBwcm9wZXJseS4gQXMg
YSBzaWRlIGVmZmVjdCwgaXQgZml4ZXMgdGhlIGZyYW1lcmF0ZSB0aGF0IHdhcyBvZmYgYnkNCj4g
YXJvdW5kIDEwJSBvbiB0aGUgc21hbGxlciByZXNvbHV0aW9ucywgYW5kIHdlIG5vdyBzdXBwb3J0
IDYwZnBzLg0KPiANCj4gVGhpcyBhbHNvIGludHJvZHVjZXMgYSBidW5jaCBvZiBuZXcgZmVhdHVy
ZXMuDQo+IA0KPiBMZXQgbWUga25vdyB3aGF0IHlvdSB0aGluaywNCj4gTWF4aW1lDQo+IA0KPiBN
YXhpbWUgUmlwYXJkICgxMCk6DQo+ICAgIG1lZGlhOiBvdjU2NDA6IERvbid0IGZvcmNlIHRoZSBh
dXRvIGV4cG9zdXJlIHN0YXRlIGF0IHN0YXJ0IHRpbWUNCj4gICAgbWVkaWE6IG92NTY0MDogSW5p
dCBwcm9wZXJseSB0aGUgU0NMSyBkaXZpZGVycw0KPiAgICBtZWRpYTogb3Y1NjQwOiBDaGFuZ2Ug
aG9yaXpvbnRhbCBhbmQgdmVydGljYWwgcmVzb2x1dGlvbnMgbmFtZQ0KPiAgICBtZWRpYTogb3Y1
NjQwOiBBZGQgaG9yaXpvbnRhbCBhbmQgdmVydGljYWwgdG90YWxzDQo+ICAgIG1lZGlhOiBvdjU2
NDA6IFByb2dyYW0gdGhlIHZpc2libGUgcmVzb2x1dGlvbg0KPiAgICBtZWRpYTogb3Y1NjQwOiBB
ZGp1c3QgdGhlIGNsb2NrIGJhc2VkIG9uIHRoZSBleHBlY3RlZCByYXRlDQo+ICAgIG1lZGlhOiBv
djU2NDA6IENvbXB1dGUgdGhlIGNsb2NrIHJhdGUgYXQgcnVudGltZQ0KPiAgICBtZWRpYTogb3Y1
NjQwOiBFbmhhbmNlIEZQUyBoYW5kbGluZw0KPiAgICBtZWRpYTogb3Y1NjQwOiBBZGQgNjAgZnBz
IHN1cHBvcnQNCj4gICAgbWVkaWE6IG92NTY0MDogUmVtb3ZlIGR1cGxpY2F0ZSBhdXRvLWV4cG9z
dXJlIHNldHVwDQo+IA0KPiBNeWzDqG5lIEpvc3NlcmFuZCAoMik6DQo+ICAgIG1lZGlhOiBvdjU2
NDA6IEFkZCBhdXRvLWZvY3VzIGZlYXR1cmUNCj4gICAgbWVkaWE6IG92NTY0MDogQWRkIGxpZ2h0
IGZyZXF1ZW5jeSBjb250cm9sDQo+IA0KPiAgIGRyaXZlcnMvbWVkaWEvaTJjL292NTY0MC5jIHwg
Nzc3ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCA0NTIgaW5zZXJ0aW9ucygrKSwgMzI1IGRlbGV0aW9ucygtKQ0KPiA=
