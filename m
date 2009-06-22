Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48503 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZFVOtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 10:49:49 -0400
From: "Menon, Nishanth" <nm@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Dongsoo Kim <dongsoo.kim@gmail.com>
CC: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	"Cohen David.A (Nokia-D/Helsinki)" <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	"gary@mlbassoc.com" <gary@mlbassoc.com>
Date: Mon, 22 Jun 2009 09:49:37 -0500
Subject: RE: OMAP3 ISP and camera drivers (update 2)
Message-ID: <7A436F7769CA33409C6B44B358BFFF0C0115F506D2@dlee02.ent.ti.com>
References: <4A3A7AE2.9080303@maxwell.research.nokia.com>
 <5e9665e10906200205ga45073eue92b73abba79e41c@mail.gmail.com>
 <200906221652.02119.tuukka.o.toivonen@nokia.com>
 <A24693684029E5489D1D202277BE894441306D3E@dlee02.ent.ti.com>
 <1DA2ED23-DD14-4E7C-9CDB-D86009620337@gmail.com>
 <A24693684029E5489D1D202277BE894441306D8A@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894441306D8A@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1tZWRpYS1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgW21haWx0bzpsaW51eC1tZWRpYS0NCj4gb3duZXJAdmdlci5rZXJuZWwu
b3JnXSBPbiBCZWhhbGYgT2YgQWd1aXJyZSBSb2RyaWd1ZXosIFNlcmdpbyBBbGJlcnRvDQo+IFNl
bnQ6IE1vbmRheSwgSnVuZSAyMiwgMjAwOSA1OjIyIFBNDQo+ID4gVGhhbmsgeW91IFNlcmdpby4g
U28geW91IG1lYW4gdGhhdCBJIGNhbiBidXkgT01BUCBab29tIHRhcmdldCBib2FyZA0KPiA+IHdp
dGggTVQgb3IgT1Ygc2Vuc29yIG9uIGl0IHNvb25lciBvciBsYXRlcj8gY29vbCENCj4gDQo+IEFG
QUlLLCB3aGVuIHlvdSBidXkgdGhlIFpvb20gVGFyZ2V0IHBsYXRmb3JtLCB5b3UgY2FuIG9ubHkg
aGF2ZSBPVjM2NDANCj4gc2Vuc29yLiBCVVQgeW91IGNvdWxkIGhhY2sgdGhlIGJvYXJkIHRvIGlu
Y2x1ZGUgYW5vdGhlciBzZW5zb3IgKE1heWJlDQo+IGNvbnN1bHRpbmcgTG9naWMgcGVvcGxlIGNv
dWxkIGNsYXJpZnkgdGhpcykuDQo+IA0KPiBJbiBab29tMSwgSSdsbCBiZSBhYmxlIGp1c3QgdG8g
dGVzdCB0aGUgT1YzNjQwIHNlbnNvciwgd2hpY2ggaXMgdGhlIG9uZSBJDQo+IGhhdmUgYXZhaWxh
YmxlIGhlcmUuDQo+IA0KPiBPbiAzNDMwU0RQLCBpcyB3aGVyZSBJIGRvIGhhdmUgTVQ5UDAxMiBz
ZW5zb3IgKDVNUCBSQVcgc2Vuc29yKSBjb25uZWN0ZWQNCj4gaW4gcGFyYWxsZWwsIGFuZCBhbiBP
VjM2NDAgKFNtYXJ0IHNlbnNvciwgYnV0IGRyaXZlciBpcyB1c2luZyBpdCBhcyBSQVcNCj4gc2Vu
c29yIGN1cnJlbnRseSBvbmx5KSBpbiBDU0kyIGludGVyZmFjZS4NCj4gDQoNCkN1cmlvdXM6IFRo
b3VnaHQgd2UgaGFkIHR3byBzZW5zb3JzOiBPVjM2NDBbMV0gb24gem9vbTEgYW5kIGEgOE1QIHNl
bnNvciBvbiB6b29tMlsyXSAtPiBhbSBJIHdyb25nIGluIHNheWluZyB0aGF0IHRoZSBjb25uZWN0
b3JzIGFyZSBjb21wYXRpYmxlIHNpbmNlIGJvdGggYXJlIENTSTJbM10/DQoNClNEUDM0MzBbNF0g
c3VwcG9ydHMgTVQ5cDAxMihDUEkpIGFuZCBvdjM2NDAoQ1NJMikuLiBhcyBsb25nIGFzIHNvbWVv
bmUgY2FuIHB1dCBhIHNlbnNvciB3aXRoIHRoZSByaWdodCBjb25uZWN0b3JzIGFuZCB2b2x0YWdl
IGNoZWNrcywgdGhleSBzaG91bGQgYmUgInBsdWcgYW5kIHBsYXkiIC0gYXQgbGVhc3QgZnJvbSBh
IGgvdyBwZXJzcGVjdGl2ZSA7KQ0KDQpSZWdhcmRzLA0KTmlzaGFudGggTWVub24NClJlZjoNClsx
XSBodHRwOi8vd3d3Lm92dC5jb20vcHJvZHVjdHMvcGFydF9kZXRhaWwucGhwP2lkPTI2DQpbMl0g
aHR0cHM6Ly93d3cub21hcHpvb20ub3JnL2dmL3Byb2plY3Qvb21hcHpvb20vd2lraS8/cGFnZW5h
bWU9V2hhdElzWm9vbTIgDQpbM10gaHR0cHM6Ly93d3cub21hcHpvb20uY29tL2dmL3Byb2plY3Qv
b21hcGFuZHJvaWQvbWFpbG1hbi8/X2ZvcnVtX2FjdGlvbj1Gb3J1bU1lc3NhZ2VCcm93c2UmdGhy
ZWFkX2lkPTE5MTImYWN0aW9uPUxpc3RUaHJlYWRzJm1haWxtYW5faWQ9MjIgDQpbNF0gaHR0cDov
L2ZvY3VzLnRpLmNvbS9nZW5lcmFsL2RvY3Mvd3RidS93dGJ1Z2VuY29udGVudC50c3A/dGVtcGxh
dGVJZD02MTIzJm5hdmlnYXRpb25JZD0xMjAxMyZjb250ZW50SWQ9Mjg3NDEjc2RwIA0K
