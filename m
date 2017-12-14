Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0097.outbound.protection.outlook.com ([104.47.32.97]:15680
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753696AbdLNRcl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:32:41 -0500
From: "Bird, Timothy" <Tim.Bird@sony.com>
To: Philippe Ombredanne <pombredanne@nexb.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>
Subject: RE: [PATCH v4 00/12] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
Date: Thu, 14 Dec 2017 17:32:34 +0000
Message-ID: <ECADFF3FD767C149AD96A924E7EA6EAF40AE4BB5@USCULXMSG01.am.sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
 <20171213173633.57edca85@vento.lan>
 <02699364973B424C83A42A84B04FDA85431742@JPYOKXMS113.jp.sony.com>
 <20171214085503.289f06f8@vento.lan>
 <CAOFm3uEYfMH8Zj8uEx-D9yYrTyDMTG_j02619esHu-j0brQKaA@mail.gmail.com>
In-Reply-To: <CAOFm3uEYfMH8Zj8uEx-D9yYrTyDMTG_j02619esHu-j0brQKaA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGhpbGlwcGUgb24gVGh1
cnNkYXksIERlY2VtYmVyIDE0LCAyMDE3IDY6MjUgQU0NCj4gRGVhciBNYXVybywNCj4gDQo+IE9u
IFRodSwgRGVjIDE0LCAyMDE3IGF0IDExOjU1IEFNLCBNYXVybyBDYXJ2YWxobyBDaGVoYWINCj4g
PG1jaGVoYWJAcy1vcGVuc291cmNlLmNvbT4gd3JvdGU6DQo+IA0KPiA+IFNQRFggaXMgYSBuZXcg
cmVxdWlyZW1lbnQgdGhhdCBzdGFydGVkIGxhdGUgb24gS2VybmVsIDQuMTQgZGV2ZWxvcG1lbnQN
Cj4gPiBjeWNsZSAoYW5kIHdob3NlIGluaXRpYWwgY2hhbmdlcyB3ZXJlIG1lcmdlZCBkaXJlY3Rs
eSBhdCBMaW51cyB0cmVlKS4NCj4gPiBOb3QgYWxsIGV4aXN0aW5nIGZpbGVzIGhhdmUgaXQgeWV0
LCBhcyBpZGVudGlmeWluZyB0aGUgcmlnaHQgbGljZW5zZQ0KPiA+IG9uIGV4aXN0aW5nIGZpbGVz
IGlzIGEgY29tcGxleCB0YXNrLCBidXQgaWYgeW91IGRvIGE6DQo+ID4NCj4gPiAgICAgICAgICQg
Z2l0IGdyZXAgU1BEWCAkKGZpbmQgLiAtbmFtZSBNYWtlZmlsZSkgJChmaW5kIC4gLW5hbWUgS2Nv
bmZpZykNCj4gPg0KPiA+IFlvdSdsbCBzZWUgdGhhdCBsb3Qgb2Ygc3VjaCBmaWxlcyBoYXZlIGl0
IGFscmVhZHkuDQo+IA0KPiBGV0lXLCBzaG9ydCBvZiBoYXZpbmcgU1BEWCB0YWdzLCBpZGVudGlm
eWluZyB0aGUgcmlnaHQgbGljZW5zZSBvbg0KPiBleGlzdGluZyBmaWxlcyBpcyBub3QgYSBzdXBl
ciBjb21wbGV4IHRhc2s6IGlmIGJvaWxzIGRvd24gdG8gcnVubmluZw0KPiBtYW55IGRpZmZzLg0K
PiANCj4gVGFrZSB0aGUgfjYwSyBmaWxlcyBpbiBrZXJuZWwsIGFuZCBhYm91dCA2SyBsaWNlbnNl
IGFuZCBub3RpY2VzDQo+IHJlZmVyZW5jZSB0ZXh0cy4gVGhlbiBjb21wdXRlIGEgcGFpcndpc2Ug
ZGlmZiBvZiBlYWNoIG9mIHRoZSA2MEsgZmlsZQ0KPiBhZ2FpbnN0IHRoZSA2SyByZWZlcmVuY2Ug
dGV4dHMuIFJlcGVhdCB0aGUgcGFpcndpc2UgZGlmZiBhIGZldyBtb3JlDQo+IHRpbWVzLCBzYXkg
MTAgdGltZXMsIGFzIG11bHRpcGxlIGxpY2Vuc2VzIG1heSBhcHBlYXIgaW4gYW55IGdpdmVuDQo+
IGtlcm5lbCBmaWxlLiBBbmQga2VlcCB0aGUgZGlmZnMgdGhhdCBoYXZlIHRoZSBmZXdlc3QNCj4g
ZGlmZmVyZW5jZS9oaWdoZXN0IHNpbWlsYXJpdHkgd2l0aCB0aGUgcmVmZXJlbmNlIHRleHRzIGFz
IHRoZSBkZXRlY3RlZA0KPiBsaWNlbnNlLiBEb25lIQ0KDQpZb3UgY2FuJ3QgZG8gbGljZW5zZSBk
ZXRlY3Rpb24gYW5kIGFzc2lnbm1lbnQgaW4gdGhpcyBhdXRvbWF0ZWQgZmFzaGlvbiAtIA0KYXQg
bGVhc3Qgbm90IGdlbmVyYWxseS4NCg0KRXZlbiBhIHNpbmdsZSB3b3JkIG9mIGRpZmZlcmVuY2Ug
YmV0d2VlbiB0aGUgbm90aWNlIGluIHRoZSBzb3VyY2UNCmNvZGUgYW5kIHRoZSByZWZlcmVuY2Ug
bGljZW5zZSBub3RpY2Ugb3IgdGV4dCBtYXkgaGF2ZSBsZWdhbCBpbXBsaWNhdGlvbnMNCnRoYXQg
YXJlIG5vdCBjb252ZXllZCBieSB0aGUgc2ltcGxpZmllZCBTUERYIHRhZy4gIFdoZW4gZGlmZmVy
ZW5jZXMgYXJlDQpmb3VuZCwgd2UncmUgZ29pbmcgdG8gaGF2ZSB0byBraWNrIHRoZSBkaXNjcmVw
YW5jaWVzIHRvIGEgaHVtYW4gZm9yIHJldmlldy4NClRoaXMgaXMgZXNwZWNpYWxseSB0cnVlIGZv
ciBmaWxlcyB3aXRoIG11bHRpcGxlIGxpY2Vuc2VzLg0KDQpGb3IgYSB3b3JrIG9mIG9yaWdpbmFs
IGF1dGhvcnNoaXAsIG9yIGEgc2luZ2xlIGNvcHlyaWdodCBob2xkZXIsIHRoZSBhdXRob3INCm9y
IGNvcHlyaWdodCBob2xkZXIgbWF5IGJlIGFibGUgdG8gY2hhbmdlIHRoZSBub3RpY2Ugb3IgdGV4
dCwgb3IgZ2xvc3MNCm92ZXIgYW55IGRpZmZlcmVuY2UgZnJvbSB0aGUgcmVmZXJlbmNlIHRleHQs
IGFuZCBtYWtlIHRoZSBTUERYICBhc3NpZ25tZW50DQoob3IgZXZlbiBjaGFuZ2UgdGhlIGxpY2Vu
c2UsIGlmIHRoZXkgd2FudCkuICBUaGlzIHdvdWxkIGFwcGx5IHRvIHNvbWV0aGluZw0KbmV3IGxp
a2UgdGhpcyBTb255IGRyaXZlci4gIEhvd2V2ZXIsIGZvciBjb2RlIHRoYXQgaXMgYWxyZWFkeSBp
biB0aGUga2VybmVsDQp0cmVlLCB3aXRoIGxpa2VseSBtdWx0aXBsZSBjb250cmlidXRvcnMsIHRo
ZSBsZWdhbCBzaXR1YXRpb24gZ2V0cyBhIGxpdHRsZQ0KbW9yZSBtdXJreS4NCg0KSSBzdXNwZWN0
IHRoZSB2YXN0IG1ham9yaXR5IG9mIHRoZSB+NjBrIGZpbGVzIHdpbGwgcHJvYmFibHkgZmFsbCBu
ZWF0bHkgaW50byBhbg0KU1BEWCBjYXRlZ29yeSwgYnV0IEknbSBndWVzc2luZyBhIGZhaXIgbnVt
YmVyIChtYXliZSBodW5kcmVkcykgd2lsbCByZXF1aXJlDQpzb21lIHJldmlldyBhbmQgZGlzY3Vz
c2lvbi4NCg0KIC0tIFRpbQ0KDQoNCg==
