Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:9608 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1759048AbdACPmM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 10:42:12 -0500
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Antti Palosaari" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
Date: Tue, 3 Jan 2017 15:20:50 +0000
Message-ID: <HK2PR06MB05453E11C8931F881E106939C36E0@HK2PR06MB0545.apcprd06.prod.outlook.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-7-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <11494368.ZdobxT7gGY@avalon>
 <CAMuHMdXj-xBrnBXfYu6BeXr7Gfv4wogH4z610Ddq-BSyVS=-8Q@mail.gmail.com>
In-Reply-To: <CAMuHMdXj-xBrnBXfYu6BeXr7Gfv4wogH4z610Ddq-BSyVS=-8Q@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGkgTGF1cmVudCwgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyBjb21tZW50cy4NCg0K
PiA+IE9uIFdlZG5lc2RheSAyMSBEZWMgMjAxNiAwODoxMDozNyBSYW1lc2ggU2hhbm11Z2FzdW5k
YXJhbSB3cm90ZToNCj4gPj4gQWRkIGJpbmRpbmcgZG9jdW1lbnRhdGlvbiBmb3IgUmVuZXNhcyBS
LUNhciBEaWdpdGFsIFJhZGlvIEludGVyZmFjZQ0KPiA+PiAoRFJJRikgY29udHJvbGxlci4NCj4g
Pj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogUmFtZXNoIFNoYW5tdWdhc3VuZGFyYW0NCj4gPj4gPHJh
bWVzaC5zaGFubXVnYXN1bmRhcmFtQGJwLnJlbmVzYXMuY29tPiAtLS0NCj4gPj4gIC4uLi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL21lZGlhL3JlbmVzYXMsZHJpZi50eHQgICAgIHwgMjAyDQo+ICsrKysr
KysrKysrKysrKysrKw0KPiA+PiAgMSBmaWxlIGNoYW5nZWQsIDIwMiBpbnNlcnRpb25zKCspDQo+
ID4+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gPj4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL21lZGlhL3JlbmVzYXMsZHJpZi50eHQNCj4gPj4NCj4gPj4gZGlmZiAtLWdpdCBhL0Rv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLGRyaWYudHh0DQo+
ID4+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL21lZGlhL3JlbmVzYXMsZHJp
Zi50eHQgbmV3IGZpbGUNCj4gPj4gbW9kZQ0KPiA+PiAxMDA2NDQNCj4gPj4gaW5kZXggMDAwMDAw
MC4uMWYzZmVhZg0KPiA+PiAtLS0gL2Rldi9udWxsDQo+ID4+ICsrKyBiL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9tZWRpYS9yZW5lc2FzLGRyaWYudHh0DQo+IA0KPiA+PiArT3B0
aW9uYWwgcHJvcGVydGllcyBvZiBhbiBpbnRlcm5hbCBjaGFubmVsIHdoZW46DQo+ID4+ICsgICAg
IC0gSXQgaXMgdGhlIG9ubHkgZW5hYmxlZCBjaGFubmVsIG9mIHRoZSBib25kIChvcikNCj4gPj4g
KyAgICAgLSBJZiBpdCBhY3RzIGFzIHByaW1hcnkgYW1vbmcgZW5hYmxlZCBib25kcw0KPiA+PiAr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
Cj4gPj4gKy0gcmVuZXNhcyxzeW5jbWQgICAgICAgOiBzeW5jIG1vZGUNCj4gPj4gKyAgICAgICAg
ICAgICAgICAgICAgICAwIChGcmFtZSBzdGFydCBzeW5jIHB1bHNlIG1vZGUuIDEtYml0IHdpZHRo
DQo+IHB1bHNlDQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgaW5kaWNhdGVzIHN0YXJ0
IG9mIGEgZnJhbWUpDQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgMSAoTC9SIHN5bmMgb3Ig
STJTIG1vZGUpIChkZWZhdWx0KQ0KPiA+PiArLSByZW5lc2FzLGxzYi1maXJzdCAgICA6IGVtcHR5
IHByb3BlcnR5IGluZGljYXRlcyBsc2IgYml0IGlzIHJlY2VpdmVkDQo+ID4+IGZpcnN0Lg0KPiA+
PiArICAgICAgICAgICAgICAgICAgICAgIFdoZW4gbm90IGRlZmluZWQgbXNiIGJpdCBpcyByZWNl
aXZlZCBmaXJzdA0KPiA+PiArKGRlZmF1bHQpDQo+ID4+ICstIHJlbmVzYXMsc3luY2FjLWFjdGl2
ZTogSW5kaWNhdGVzIHN5bmMgc2lnbmFsIHBvbGFyaXR5LCAwLzEgZm9yDQo+IGxvdy9oaWdoDQo+
ID4+ICsgICAgICAgICAgICAgICAgICAgICAgcmVzcGVjdGl2ZWx5LiBUaGUgZGVmYXVsdCBpcyAx
IChhY3RpdmUgaGlnaCkNCj4gPj4gKy0gcmVuZXNhcyxkdGRsICAgICAgICAgOiBkZWxheSBiZXR3
ZWVuIHN5bmMgc2lnbmFsIGFuZCBzdGFydCBvZg0KPiByZWNlcHRpb24uDQo+ID4+ICsgICAgICAg
ICAgICAgICAgICAgICAgVGhlIHBvc3NpYmxlIHZhbHVlcyBhcmUgcmVwcmVzZW50ZWQgaW4gMC41
IGNsb2NrDQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgY3ljbGUgdW5pdHMgYW5kIHRoZSBy
YW5nZSBpcyAwIHRvIDQuIFRoZSBkZWZhdWx0DQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAg
dmFsdWUgaXMgMiAoaS5lLikgMSBjbG9jayBjeWNsZSBkZWxheS4NCj4gPj4gKy0gcmVuZXNhcyxz
eW5jZGwgICAgICAgOiBkZWxheSBiZXR3ZWVuIGVuZCBvZiByZWNlcHRpb24gYW5kIHN5bmMNCj4g
c2lnbmFsDQo+ID4+IGVkZ2UuDQo+ID4+ICsgICAgICAgICAgICAgICAgICAgICAgVGhlIHBvc3Np
YmxlIHZhbHVlcyBhcmUgcmVwcmVzZW50ZWQgaW4gMC41IGNsb2NrDQo+ID4+ICsgICAgICAgICAg
ICAgICAgICAgICAgY3ljbGUgdW5pdHMgYW5kIHRoZSByYW5nZSBpcyAwIHRvIDQgJiA2LiBUaGUN
Cj4gZGVmYXVsdA0KPiA+PiArICAgICAgICAgICAgICAgICAgICAgIHZhbHVlIGlzIDAgKGkuZS4p
IG5vIGRlbGF5Lg0KPiA+DQo+ID4gTW9zdCBvZiB0aGVzZSBwcm9wZXJ0aWVzIGFyZSBwcmV0dHkg
c2ltaWxhciB0byB0aGUgdmlkZW8gYnVzDQo+ID4gcHJvcGVydGllcyBkZWZpbmVkIGF0IHRoZSBl
bmRwb2ludCBsZXZlbCBpbg0KPiA+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9t
ZWRpYS92aWRlby1pbnRlcmZhY2VzLnR4dC4gSQ0KPiA+IGJlbGlldmUgaXQgd291bGQgbWFrZSBz
ZW5zZSB0byB1c2UgT0YgZ3JhcGggYW5kIHRyeSB0byBzdGFuZGFyZGl6ZQ0KPiA+IHRoZXNlIHBy
b3BlcnRpZXMgc2ltaWxhcmx5Lg0KPiANCj4gTm90ZSB0aGF0IHRoZSBsYXN0IHR3byBwcm9wZXJ0
aWVzIG1hdGNoIHRoZSB0aG9zZSBpbg0KPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3Mvc3BpL3NoLW1zaW9mLnR4dC4NCj4gV2UgbWF5IHdhbnQgdG8gdXNlIG9uZSBEUklGIGNoYW5u
ZWwgYXMgYSBwbGFpbiBTUEkgc2xhdmUgd2l0aCB0aGUNCj4gKG1vZGlmaWVkKSBNU0lPRiBkcml2
ZXIgaW4gdGhlIGZ1dHVyZS4NCg0KU2hvdWxkIEkgbGVhdmUgaXQgYXMgaXQgaXMgb3IgbW9kaWZ5
IHRoZXNlIGFzIGluIHZpZGVvLWludGVyZmFjZXMudHh0PyBTaGFsbCB3ZSBjb25jbHVkZSBvbiB0
aGlzIHBsZWFzZT8NCg0KVGhhbmtzLA0KUmFtZXNoDQo=
