Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:40997 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758492AbdAIOmy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 09:42:54 -0500
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        "Chris Paterson" <Chris.Paterson2@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
Date: Mon, 9 Jan 2017 14:42:47 +0000
Message-ID: <HK2PR06MB05457872CD4C9011E39F2DFAC3640@HK2PR06MB0545.apcprd06.prod.outlook.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-7-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <11494368.ZdobxT7gGY@avalon>
 <CAMuHMdXj-xBrnBXfYu6BeXr7Gfv4wogH4z610Ddq-BSyVS=-8Q@mail.gmail.com>
 <HK2PR06MB05453E11C8931F881E106939C36E0@HK2PR06MB0545.apcprd06.prod.outlook.com>
 <cca1ade8-01ef-8eab-f4b1-7dd7f204fdea@xs4all.nl>
In-Reply-To: <cca1ade8-01ef-8eab-f4b1-7dd7f204fdea@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgSGFucywNCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KDQo+ID4+PiBPbiBXZWRuZXNkYXkg
MjEgRGVjIDIwMTYgMDg6MTA6MzcgUmFtZXNoIFNoYW5tdWdhc3VuZGFyYW0gd3JvdGU6DQo+ID4+
Pj4gQWRkIGJpbmRpbmcgZG9jdW1lbnRhdGlvbiBmb3IgUmVuZXNhcyBSLUNhciBEaWdpdGFsIFJh
ZGlvIEludGVyZmFjZQ0KPiA+Pj4+IChEUklGKSBjb250cm9sbGVyLg0KPiA+Pj4+DQo+ID4+Pj4g
U2lnbmVkLW9mZi1ieTogUmFtZXNoIFNoYW5tdWdhc3VuZGFyYW0NCj4gPj4+PiA8cmFtZXNoLnNo
YW5tdWdhc3VuZGFyYW1AYnAucmVuZXNhcy5jb20+IC0tLQ0KPiA+Pj4+ICAuLi4vZGV2aWNldHJl
ZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLGRyaWYudHh0ICAgICB8IDIwMg0KPiA+PiArKysrKysr
KysrKysrKysrKysNCj4gPj4+PiAgMSBmaWxlIGNoYW5nZWQsIDIwMiBpbnNlcnRpb25zKCspDQo+
ID4+Pj4gIGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiA+Pj4+IERvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLGRyaWYudHh0DQo+ID4+Pj4NCj4gPj4+PiBkaWZmIC0t
Z2l0DQo+ID4+Pj4gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvcmVu
ZXNhcyxkcmlmLnR4dA0KPiA+Pj4+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L21lZGlhL3JlbmVzYXMsZHJpZi50eHQgbmV3IGZpbGUNCj4gPj4+PiBtb2RlDQo+ID4+Pj4gMTAw
NjQ0DQo+ID4+Pj4gaW5kZXggMDAwMDAwMC4uMWYzZmVhZg0KPiA+Pj4+IC0tLSAvZGV2L251bGwN
Cj4gPj4+PiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvcmVu
ZXNhcyxkcmlmLnR4dA0KPiA+Pg0KPiA+Pj4+ICtPcHRpb25hbCBwcm9wZXJ0aWVzIG9mIGFuIGlu
dGVybmFsIGNoYW5uZWwgd2hlbjoNCj4gPj4+PiArICAgICAtIEl0IGlzIHRoZSBvbmx5IGVuYWJs
ZWQgY2hhbm5lbCBvZiB0aGUgYm9uZCAob3IpDQo+ID4+Pj4gKyAgICAgLSBJZiBpdCBhY3RzIGFz
IHByaW1hcnkgYW1vbmcgZW5hYmxlZCBib25kcw0KPiA+Pj4+ICstLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+Pj4+ICstIHJlbmVzYXMs
c3luY21kICAgICAgIDogc3luYyBtb2RlDQo+ID4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAw
IChGcmFtZSBzdGFydCBzeW5jIHB1bHNlIG1vZGUuIDEtYml0IHdpZHRoDQo+ID4+IHB1bHNlDQo+
ID4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICBpbmRpY2F0ZXMgc3RhcnQgb2YgYSBmcmFt
ZSkNCj4gPj4+PiArICAgICAgICAgICAgICAgICAgICAgIDEgKEwvUiBzeW5jIG9yIEkyUyBtb2Rl
KSAoZGVmYXVsdCkNCj4gPj4+PiArLSByZW5lc2FzLGxzYi1maXJzdCAgICA6IGVtcHR5IHByb3Bl
cnR5IGluZGljYXRlcyBsc2IgYml0IGlzDQo+IHJlY2VpdmVkDQo+ID4+Pj4gZmlyc3QuDQo+ID4+
Pj4gKyAgICAgICAgICAgICAgICAgICAgICBXaGVuIG5vdCBkZWZpbmVkIG1zYiBiaXQgaXMgcmVj
ZWl2ZWQgZmlyc3QNCj4gPj4+PiArKGRlZmF1bHQpDQo+ID4+Pj4gKy0gcmVuZXNhcyxzeW5jYWMt
YWN0aXZlOiBJbmRpY2F0ZXMgc3luYyBzaWduYWwgcG9sYXJpdHksIDAvMSBmb3INCj4gPj4gbG93
L2hpZ2gNCj4gDQo+IFNob3VsZG4ndCB0aGlzIGJlICdyZW5lc2FzLHN5bmMtYWN0aXZlJyBpbnN0
ZWFkIG9mIHN5bmNhYy1hY3RpdmU/DQo+IA0KPiBJJ20gbm90IHN1cmUgaWYgc3luY2FjIGlzIGlu
dGVuZGVkIG9yIGlmIGl0IGlzIGEgdHlwby4NCg0KWWVzLCAic3luY2FjIiBpcyBpbnRlbmRlZC4g
SSBrZXB0IHRoZSBzYW1lIG5hbWUgYXMgaW4gaC93IG1hbnVhbCBmb3IgZWFzeSByZWZlcmVuY2Uu
IFNhbWUgZm9yIG90aGVyIHByb3BlcnRpZXMgLSBzeW5jbWQsIGR0ZGwgJiBzeW5jZGwuDQoNCj4g
DQo+ID4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICByZXNwZWN0aXZlbHkuIFRoZSBkZWZhdWx0
IGlzIDEgKGFjdGl2ZSBoaWdoKQ0KPiA+Pj4+ICstIHJlbmVzYXMsZHRkbCAgICAgICAgIDogZGVs
YXkgYmV0d2VlbiBzeW5jIHNpZ25hbCBhbmQgc3RhcnQgb2YNCj4gPj4gcmVjZXB0aW9uLg0KPiA+
Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgVGhlIHBvc3NpYmxlIHZhbHVlcyBhcmUgcmVwcmVz
ZW50ZWQgaW4gMC41DQo+IGNsb2NrDQo+ID4+Pj4gKyAgICAgICAgICAgICAgICAgICAgICBjeWNs
ZSB1bml0cyBhbmQgdGhlIHJhbmdlIGlzIDAgdG8gNC4gVGhlDQo+IGRlZmF1bHQNCj4gPj4+PiAr
ICAgICAgICAgICAgICAgICAgICAgIHZhbHVlIGlzIDIgKGkuZS4pIDEgY2xvY2sgY3ljbGUgZGVs
YXkuDQo+ID4+Pj4gKy0gcmVuZXNhcyxzeW5jZGwgICAgICAgOiBkZWxheSBiZXR3ZWVuIGVuZCBv
ZiByZWNlcHRpb24gYW5kIHN5bmMNCj4gPj4gc2lnbmFsDQo+ID4+Pj4gZWRnZS4NCj4gPj4+PiAr
ICAgICAgICAgICAgICAgICAgICAgIFRoZSBwb3NzaWJsZSB2YWx1ZXMgYXJlIHJlcHJlc2VudGVk
IGluIDAuNQ0KPiBjbG9jaw0KPiA+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgY3ljbGUgdW5p
dHMgYW5kIHRoZSByYW5nZSBpcyAwIHRvIDQgJiA2LiBUaGUNCj4gPj4gZGVmYXVsdA0KPiA+Pj4+
ICsgICAgICAgICAgICAgICAgICAgICAgdmFsdWUgaXMgMCAoaS5lLikgbm8gZGVsYXkuDQo+ID4+
Pg0KPiA+Pj4gTW9zdCBvZiB0aGVzZSBwcm9wZXJ0aWVzIGFyZSBwcmV0dHkgc2ltaWxhciB0byB0
aGUgdmlkZW8gYnVzDQo+ID4+PiBwcm9wZXJ0aWVzIGRlZmluZWQgYXQgdGhlIGVuZHBvaW50IGxl
dmVsIGluDQo+ID4+PiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbWVkaWEvdmlk
ZW8taW50ZXJmYWNlcy50eHQuIEkNCj4gPj4+IGJlbGlldmUgaXQgd291bGQgbWFrZSBzZW5zZSB0
byB1c2UgT0YgZ3JhcGggYW5kIHRyeSB0byBzdGFuZGFyZGl6ZQ0KPiA+Pj4gdGhlc2UgcHJvcGVy
dGllcyBzaW1pbGFybHkuDQo+IA0KPiBPdGhlciB0aGFuIHN5bmMtYWN0aXZlLCBpcyB0aGVyZSBy
ZWFsbHkgYW55dGhpbmcgZWxzZSB0aGF0IGlzIHNpbWlsYXI/IEFuZA0KPiBldmVuIHRoZSBzeW5j
LWFjdGl2ZSBpc24ndCBhIGdvb2QgZml0IHNpbmNlIGhlcmUgdGhlcmUgaXMgb25seSBvbmUgc3lu
Yw0KPiBzaWduYWwgaW5zdGVhZCBvZiB0d28gZm9yIHZpZGVvIChoIGFuZCB2c3luYykuDQo+IA0K
PiBSZWdhcmRzLA0KPiANCj4gCUhhbnMNCj4gDQoNClRoYW5rcywNClJhbWVzaA0K
