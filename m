Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1LcQcs-0007a6-BH
	for linux-dvb@linuxtv.org; Wed, 25 Feb 2009 21:45:06 +0100
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LcQco-0000Bf-AY
	for linux-dvb@linuxtv.org; Wed, 25 Feb 2009 20:45:02 +0000
Received: from 93-125-199-158.dsl.alice.nl ([93.125.199.158])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 25 Feb 2009 20:45:02 +0000
Received: from erik_bies by 93-125-199-158.dsl.alice.nl with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 25 Feb 2009 20:45:02 +0000
To: linux-dvb@linuxtv.org
From: erik <erik_bies@hotmail.com>
Date: Wed, 25 Feb 2009 20:42:00 +0000 (UTC)
Message-ID: <loom.20090225T203249-735@post.gmane.org>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
	<1223598995.4825.12.camel@pc10.localdom.local>
	<7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

a2xhYXMgZGUgd2FhbCA8a2xhYXMuZGUud2FhbCA8YXQ+IGdtYWlsLmNvbT4gd3JpdGVzOgo+IAo+
IE9uIEZyaSwgT2N0IDEwLCAyMDA4IGF0IDI6MzYgQU0sIGhlcm1hbm4gcGl0dG9uIDxoZXJtYW5u
LXBpdHRvbiA8YXQ+IGFyY29yLmRlPgp3cm90ZToKPiBIaSwKPiBBbSBEb25uZXJzdGFnLCBkZW4g
MDkuMTAuMjAwOCwgMjI6MTUgKzAyMDAgc2NocmllYiBrbGFhcyBkZSB3YWFsOgo+ICBUaGUgdGFi
bGUgc3RhcnRzIGEgbmV3IHNlZ21lbnQgYXQgMzkwTUh6LAo+ID4gaXQgdGhlbiBzdGFydHMgdG8g
dXNlIFZDTzIgaW5zdGVhZCBvZiBWQ08xLgo+ID4gSSBoYXZlIG5vdyAoaGFjaywgaGFjaykgY2hh
bmdlZCB0aGUgc2VnbWVudCBzdGFydCBmcm9tIDM5MCB0byAzOTVNSHoKPiA+IHNvIHRoYXQgdGhl
IDM4OE1IeiBpcyBzdGlsbCB0dW5lZCB3aXRoIFZDTzEsIGFuZCB0aGlzIHdvcmtzIE9LISEKPiA+
IExpa2UgdGhpczoKPiA+Cj4gPiBzdGF0aWMgY29uc3Qgc3RydWN0IHRkYTgyN3hhX2RhdGEgdGRh
ODI3eGFfZHZidFtdID0gewo+ID4gwqAgwqAgeyAubG9tYXggPSDCoDU2ODc1MDAwLCAuc3ZjbyA9
IDMsIC5zcGQgPSA0LCAuc2NyID0gMCwgLnNicyA9Cj4gPiAwLCAuZ2MzID0gMX0sCj4gPiAjZWxz
ZQo+ID4gwqAgwqAgeyAubG9tYXggPSAzOTUwMDAwMDAsIC5zdmNvID0gMiwgLnNwZCA9IDEsIC5z
Y3IgPSAwLCAuc2JzID0KPiA+IDMsIC5nYzMgPSAxfSwKPiA+ICNlbmRpZgo+ID4gwqAgwqAgeyAu
bG9tYXggPSA0NTUwMDAwMDAsIC5zdmNvID0gMywgLnNwZCA9IDEsIC5zY3IgPSAwLCAuc2JzID0K
PiA+IDMsIC5nYzMgPSAxfSwKPiA+IGV0YyBldGMKPiA+CgpIaSBLbGFhcy9IZXJtYW5uCgpZb3Vy
IGZpeCB3b3JrcyBwZXJmZWN0bHkgZm9yIG1lIGFzIHdlbGwuIFByaW9yIEkgY291bGQgbm90IGdl
dCB0aGUgY2hhbm5lbHMgaW4KdGhlIDM4Njc1MDAwMCBmcmVxLiBXaXRoIEZpeCBhcHBpZWQgbXkg
WmlnZ28gbG9ja2luZyBpc3N1ZXMgZGlzYXBwZWFyZWQuCgpJcyB0aGVyZSBhbnkgY2hhbmNlIHRv
IGdldCBpdCBpbnRvIHRoZSBvZmZpY2lhbCB2ZXJzaW9uPwoKRXJpawoKCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1kdmIgdXNlcnMgbWFpbGlu
ZyBsaXN0CkZvciBWNEwvRFZCIGRldmVsb3BtZW50LCBwbGVhc2UgdXNlIGluc3RlYWQgbGludXgt
bWVkaWFAdmdlci5rZXJuZWwub3JnCmxpbnV4LWR2YkBsaW51eHR2Lm9yZwpodHRwOi8vd3d3Lmxp
bnV4dHYub3JnL2NnaS1iaW4vbWFpbG1hbi9saXN0aW5mby9saW51eC1kdmI=
