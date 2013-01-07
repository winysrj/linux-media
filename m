Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47649 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab3AGIrI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 03:47:08 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: "devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	David Airlie <airlied@linux.ie>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Rob Clark <robdclark@gmail.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCHv16 5/7] fbmon: add of_videomode helpers
Date: Mon, 7 Jan 2013 08:46:41 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA7FBF7@DBDE01.ent.ti.com>
References: <1355850256-16135-1-git-send-email-s.trumtrar@pengutronix.de>
 <1355850256-16135-6-git-send-email-s.trumtrar@pengutronix.de>
 <C8443D0743D26F4388EA172BF4E2A7A93EA7FB02@DBDE01.ent.ti.com>
 <20130107080648.GB23478@pengutronix.de>
In-Reply-To: <20130107080648.GB23478@pengutronix.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgU3RlZmZlbiwNCg0KT24gTW9uLCBKYW4gMDcsIDIwMTMgYXQgMTM6MzY6NDgsIFN0ZWZmZW4g
VHJ1bXRyYXIgd3JvdGU6DQo+IE9uIE1vbiwgSmFuIDA3LCAyMDEzIGF0IDA2OjEwOjEzQU0gKzAw
MDAsIE1vaGFtbWVkLCBBZnphbCB3cm90ZToNCg0KPiA+IFRoaXMgYnJlYWtzIERhVmluY2kgKGRh
OHh4X29tYXBsX2RlZmNvbmZpZyksIGZvbGxvd2luZyBjaGFuZ2Ugd2FzDQo+ID4gcmVxdWlyZWQg
dG8gZ2V0IGl0IGJ1aWxkIGlmIE9GX1ZJREVPTU9ERSBvci9hbmQgRkJfTU9ERV9IRUxQRVJTDQo+
ID4gaXMgbm90IGRlZmluZWQuIFRoZXJlIG1heSBiZSBiZXR0ZXIgc29sdXRpb25zLCBmb2xsb3dp
bmcgd2FzIHRoZQ0KPiA+IG9uZSB0aGF0IHdhcyB1c2VkIGJ5IG1lIHRvIHRlc3QgdGhpcyBzZXJp
ZXMuDQoNCj4gSSBqdXN0IGRpZCBhIHF1aWNrICJtYWtlIGRhOHh4X29tYXBsX2RlZmNvbmZpZyAm
JiBtYWtlIiBhbmQgaXQgYnVpbGRzIGp1c3QgZmluZS4NCj4gT24gd2hhdCB2ZXJzaW9uIGRpZCB5
b3UgYXBwbHkgdGhlIHNlcmllcz8NCj4gQXQgdGhlIG1vbWVudCBJIGhhdmUgdGhlIHNlcmllcyBz
aXR0aW5nIG9uIDMuNy4gRGlkbid0IHRyeSBhbnkgMy44LXJjeCB5ZXQuDQo+IEJ1dCBmaXhpbmcg
dGhpcyBzaG91bGRuJ3QgYmUgYSBwcm9ibGVtLg0KDQpZb3UgYXJlIHJpZ2h0LCBtZSBpZGlvdCwg
ZXJyb3Igd2lsbCBoYXBwZW4gb25seSB1cG9uIHRyeSB0byBtYWtlIHVzZSBvZg0Kb2ZfZ2V0X2Zi
X3ZpZGVvbW9kZSgpIChkZWZpbmVkIGluIHRoaXMgcGF0Y2gpIGluIHRoZSBkYTh4eC1mYiBkcml2
ZXINCih3aXRoIGRhOHh4X29tYXBsX2RlZmNvbmZpZyksIHRvIGJlIGV4YWN0IHVwb24gYWRkaW5n
LA0KDQoidmlkZW86IGRhOHh4LWZiOiBvYnRhaW4gZmJfdmlkZW9tb2RlIGluZm8gZnJvbSBkdCIg
b2YgbXkgcGF0Y2ggc2VyaWVzLg0KDQpUaGUgY2hhbmdlIGFzIEkgbWVudGlvbmVkIG9yIHNvbWV0
aGluZyBzaW1pbGFyIHdvdWxkIGJlIHJlcXVpcmVkIGFzDQphbnkgZHJpdmVyIHRoYXQgaXMgZ29p
bmcgdG8gbWFrZSB1c2Ugb2Ygb2ZfZ2V0X2ZiX3ZpZGVvbW9kZSgpIHdvdWxkDQpicmVhayBpZiBD
T05GSUdfT0ZfVklERU9NT0RFIG9yIENPTkZJR19GQl9NT0RFX0hFTFBFUlMgaXMgbm90IGRlZmlu
ZWQuDQoNCkFuZCB0ZXN0aW5nIHdhcyBkb25lIG92ZXIgdjMuOC1yYzIuDQoNCj4gPiA+ICsjaWYg
SVNfRU5BQkxFRChDT05GSUdfT0ZfVklERU9NT0RFKQ0KPiA+IA0KPiA+IEFzIF9PRl9WSURFT01P
REUgaXMgYSBib29sIHR5cGUgQ09ORklHLCBpc24ndCwNCj4gPiANCj4gPiAjaWZkZWYgQ09ORklH
X09GX1ZJREVPTU9ERQ0KPiA+IA0KPiA+IHN1ZmZpY2llbnQgPw0KPiA+IA0KPiANCj4gWWVzLCB0
aGF0IGlzIHJpZ2h0LiBCdXQgSSB0aGluayBJU19FTkFCTEVEIGlzIHRoZSBwcmVmZXJyZWQgd2F5
IHRvIGRvIGl0LCBpc24ndCBpdD8NCg0KTm93IEkgcmVhbGl6ZSBpdCBpcy4NCg0KUmVnYXJkcw0K
QWZ6YWwNCg==
