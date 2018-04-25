Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0102.outbound.protection.outlook.com ([104.47.34.102]:52497
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756048AbeDYRnz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 13:43:55 -0400
From: Trent Piepho <tpiepho@impinj.com>
To: "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
CC: "hch@infradead.org" <hch@infradead.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "arvind.yadav.cs@gmail.com" <arvind.yadav.cs@gmail.com>,
        "mjpeg-users@lists.sourceforge.net"
        <mjpeg-users@lists.sourceforge.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
Date: Wed, 25 Apr 2018 17:43:53 +0000
Message-ID: <1524678233.31312.5.camel@impinj.com>
References: <20180424204158.2764095-1-arnd@arndb.de>
         <20180425061537.GA23383@infradead.org>
         <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
         <20180425072138.GA16375@infradead.org>
         <CAK8P3a1cs_SPesadAQhV3QU97WjNE8bLPSQCfaMQRU7zr_oh3w@mail.gmail.com>
         <20180425152636.GC27076@infradead.org>
         <CAK8P3a0CHSC7yP3x8xDJgcg5xMzD1-sC-rmBJECtYvGFmyG4vQ@mail.gmail.com>
         <20180425142229.25d756ed@vento.lan>
In-Reply-To: <20180425142229.25d756ed@vento.lan>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9FF15A57AA26B49B71F9C46AE3F6C5F@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

T24gV2VkLCAyMDE4LTA0LTI1IGF0IDE0OjIyIC0wMzAwLCBNYXVybyBDYXJ2YWxobyBDaGVoYWIg
d3JvdGU6DQo+IEVtIFdlZCwgMjUgQXByIDIwMTggMTc6NTg6MjUgKzAyMDANCj4gQXJuZCBCZXJn
bWFubiA8YXJuZEBhcm5kYi5kZT4gZXNjcmV2ZXU6DQo+IA0KPiA+IE9uIFdlZCwgQXByIDI1LCAy
MDE4IGF0IDU6MjYgUE0sIENocmlzdG9waCBIZWxsd2lnIDxoY2hAaW5mcmFkZWFkLm8NCj4gPiBy
Zz4gd3JvdGU6DQo+ID4gPiBPbiBXZWQsIEFwciAyNSwgMjAxOCBhdCAwMToxNToxOFBNICswMjAw
LCBBcm5kIEJlcmdtYW5uIHdyb3RlOiAgDQo+ID4gPiA+IFRoYXQgdGhvdWdodCBoYWQgb2NjdXJy
ZWQgdG8gbWUgYXMgd2VsbC4gSSByZW1vdmVkIHRoZSBvbGRlc3QgSVNETg0KPiA+ID4gPiBkcml2
ZXJzIGFscmVhZHkgc29tZSB5ZWFycyBhZ28sIGFuZCB0aGUgT1NTIHNvdW5kIGRyaXZlcnMNCj4g
PiA+ID4gZ290IHJlbW92ZWQgYXMgd2VsbCwgYW5kIGNvbWVkaSBnb3QgY29udmVydGVkIHRvIHRo
ZSBkbWEtbWFwcGluZw0KPiA+ID4gPiBpbnRlcmZhY2VzLCBzbyB0aGVyZSBpc24ndCBtdWNoIGxl
ZnQgYXQgYWxsIG5vdy4gVGhpcyBpcyB3aGF0IHdlDQo+ID4gPiA+IGhhdmUgYXMgb2YgdjQuMTct
cmMxOiAgDQo+ID4gPiANCj4gPiA+IFllcywgSSd2ZSBiZWVuIGxvb2tpbmcgYXQgdmFyaW91cyBn
cm90dHkgb2xkIGJpdHMgdG8gcHVyZ2UuICBVc3VhbGx5DQo+ID4gPiBJJ3ZlIGJlZW4gbG9va2lu
ZyBmb3Igc29tZSBub24tdHJlZSB3aWRlIHBhdGNoZXMgYW5kIENDZWQgdGhlIGxhc3QNCj4gPiA+
IGFjdGl2ZSBwZW9wbGUgdG8gc2VlIGlmIHRoZXkgY2FyZS4gIEluIGEgZmV3IGNhc2VzIHBlb3Bs
ZSBkbywgYnV0DQo+ID4gPiBtb3N0IG9mdGVuIG5vIG9uZSBkb2VzLiAgDQo+ID4gDQo+ID4gTGV0
J3Mgc3RhcnQgd2l0aCB0aGlzIG9uZSAoem9yYW4pIHRoZW4sIGFzIE1hdXJvIGlzIGtlZW4gb24g
aGF2aW5nDQo+ID4gYWxsIG1lZGlhIGRyaXZlcnMgY29tcGlsZS10ZXN0YWJsZSBvbiB4ODYtNjQg
YW5kIGFybS4NCj4gPiANCj4gPiBUcmVudCBQaWVwaG8gYW5kIEhhbnMgVmVya3VpbCBib3RoIHdv
cmtlZCBvbiB0aGlzIGRyaXZlciBpbiB0aGUNCj4gPiAyMDA4LzIwMDkgdGltZWZyYW1lIGFuZCB0
aG9zZSB3ZXJlIHRoZSBsYXN0IGNvbW1pdHMgZnJvbSBhbnlvbmUNCj4gPiB3aG8gYXBwZWFycyB0
byBoYXZlIHRlc3RlZCB0aGVpciBwYXRjaGVzIG9uIGFjdHVhbCBoYXJkd2FyZS4NCj4gDQo+IFpv
cmFuIGlzIGEgZHJpdmVyIGZvciBvbGQgaGFyZHdhcmUuIEkgZG9uJ3QgZG91YnQgdGhhdCBhcmUg
cGVvcGxlDQo+IG91dCB0aGVyZSBzdGlsbCB1c2luZyBpdCwgYnV0IHdobyBrbm93cz8NCj4gDQo+
IEkgaGF2ZSBhIGZldyB0aG9zZSBib2FyZHMgcGFja2VkIHNvbWV3aGVyZS4gSSBoYXZlbid0IHdv
cmsgd2l0aCBQQ0kNCj4gaGFyZHdhcmUgZm9yIGEgd2hpbGUuIElmIG5lZWRlZCwgSSBjYW4gdHJ5
IHRvIHNlZWsgZm9yIHRoZW0gYW5kDQo+IGRvIHNvbWUgdGVzdHMuIEkgbmVlZCBmaXJzdCB0byB1
bnBhY2sgYSBtYWNoaW5lIHdpdGggUENJIHNsb3RzLi4uDQo+IHRoZSBOVUNzIEkgZ2VuZXJhbGx5
IHVzZSBmb3IgZGV2ZWxvcG1lbnQgZG9uJ3QgaGF2ZSBhbnkgOi0pDQo+IA0KPiBBbnl3YXksIGV4
Y2VwdCBmb3IgdmlydF90b19idXMoKSBhbmQgcmVsYXRlZCBzdHVmZiwgSSB0aGluayB0aGF0IHRo
aXMNCj4gZHJpdmVyIGlzIGluIGdvb2Qgc2hhcGUsIGFzIEhhbnMgZGlkIGEgbG90IG9mIHdvcmsg
aW4gdGhlIHBhc3QgdG8NCj4gbWFrZSBpdCB0byB1c2UgdGhlIGN1cnJlbnQgbWVkaWEgZnJhbWV3
b3JrLg0KDQpJIHN0aWxsIGhhdmUgYSB6b3JhbiBib2FyZC4gIEFuZCBteSByZWNlbnRseSBwdXJj
aGFzZWQgcnl6ZW4gc3lzdGVtIGhhcw0KUENJIHNsb3RzLiAgVG8gbXkgc3VycHJpc2UgdGhleSBh
cmUgbm90IHVuY29tbW9uIG9uIG5ldyBzb2NrZXQgQU00DQpib2FyZHMuICBIb3dldmVyLCBJIHRo
aW5rIHRoZSB6b3JhbiBib2FyZCBJIGhhdmUgaXMgNVYgUENJIGFuZCB0aGF0IGlzDQpyYXRoZXIg
dW5jb21tb24uICBBbHNvIGJlY29taW5nIHVuY29tbW9uIGlzIGFuYWxvZyBOVFNDL1BBTCB2aWRl
byB0aGF0DQp0aGlzIGNoaXAgaXMgZGVzaWduZWQgZm9yIQ0KDQpJZiBhbnlvbmUgaXMgdXNpbmcg
dGhlc2Ugc3RpbGwsIHRoZXkgd291bGQgYmUgaW4gbGVnYWN5IHN5c3RlbXMgZm9yDQp0aGVzZSBs
ZWdhY3kgdmlkZW8gZm9ybWF0cy4NCg==
