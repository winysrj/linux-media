Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from corsa.pop-pr.rnp.br ([200.238.128.2])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lyra@pop-pr.rnp.br>) id 1LutpR-0008Dv-5r
	for linux-dvb@linuxtv.org; Fri, 17 Apr 2009 21:34:27 +0200
Received: from localhost (localhost [127.0.0.1])
	by corsa.pop-pr.rnp.br (Postfix) with ESMTP id E4AAB42205
	for <linux-dvb@linuxtv.org>; Fri, 17 Apr 2009 16:33:46 -0300 (BRT)
Received: from corsa.pop-pr.rnp.br ([127.0.0.1])
	by localhost (corsa.pop-pr.rnp.br [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 04387-04 for <linux-dvb@linuxtv.org>;
	Fri, 17 Apr 2009 16:33:44 -0300 (BRT)
Received: from viper.pop-pr.rnp.br (viper.pop-pr.rnp.br [200.238.128.25])
	by corsa.pop-pr.rnp.br (Postfix) with ESMTP id 68CA242204
	for <linux-dvb@linuxtv.org>; Fri, 17 Apr 2009 16:33:44 -0300 (BRT)
From: Christian Lyra <lyra@pop-pr.rnp.br>
To: linux-dvb@linuxtv.org
Date: Fri, 17 Apr 2009 16:33:54 -0300
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904171633.54211.lyra@pop-pr.rnp.br>
Subject: [linux-dvb] Current state of DVB-C support
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

SGkgdGhlcmUsCgoJScK0ZCBsaWtlIHRvIHNoYXJlIHdpdGggeW91IG15IHJlY2VudCBleHBlcmll
bmNlIHdpdGggRFZCLUMgY2FyZHMgYW5kIGEgCkJyYXppbGlhbiBQcm92aWRlci4KCQoJTXkgZmly
c3QgYXR0ZW1wdCB0byB1c2UgYSBEVkItQyB3YXMgd2l0aCBhIEtOQzEgY2FyZC4gSSBqdXN0IGhh
ZCB0byAKZG93bmxvYWQgdGhlIGxhdGVzdCBzb3VyY2UgZnJvbSBkdmIgcmVwb3NpdG9yeSwgY29t
cGlsZSBhbmQgaW5zdGFsbC4gClRoZSBjYXJkIHdhcyBpZGVudGlmaWVkLCBJIGNvdWxkIHNjYW4g
Y2hhbm5lbHMgYW5kIHdhdGNoIFRWLiBCVVQgc29tZSAKY2hhbm5lbHMgd29ya3MgdmVyeSBiYWRs
eSwgYXMgdGhlIGNhcmQgY291bGRudCBsb2NrIHByb3Blcmx5IG9uIGEgZmV3IAp0cmFuc3BvbmRl
cnMgKDMwOW1oeiBhbmQgMzIxbWh6KS4gUnVubmluZyBhIGN6YXAgb24gdGhvc2UgY2hhbm5lbHMg
CnNob3dzIHRoYXQgdGhlIGNhcmQga2VlcCAibG9ja2luZyIgYW5kIGxvb3NpbmcgdGhlIGxvY2su
CglJIHRob3VnaHQgdGhhdCB0aGUgcHJvYmxlbSBjb3VsZCBiZSBzb21ldGhpbmcgd2l0aCBteSBj
YWJsaW5nLCBzbyBJIAp0cmllZCBteSBjYXJkIGF0IGEgZnJpZW5kwrRzIGhvdXNlIHdpdGggdGhl
IHNhbWUgcmVzdWx0cy4gSSBhbHNvIHRyaWVkIGEgCmF0dGVudWF0b3IsIGJ1dCB3aXRob3V0IHN1
Y2Nlc3MgdG9vLgoJICAKCU9uIG15IHNlY29uZCBhdHRlbXB0IEkgYm91Z2h0IGEgdHdpbmhhbiBD
QUIgY2kgY2FyZC4gQ2FyZCBpZGVudGlmaWVkLCAKYnV0IHNjYW4gZGlkbnQgd29ya2VkLiBTb21l
IGdvb2dsZWluZyBsYXRlciwgSSBnb3QgaXQgd29ya2luZyBieSAKY29tbWVudGluZyB0aGUgbGlu
ZSAxMzYwIGluIGRzdC5jICghKHN0YXRlLT5kc3RfdHlwZSA9PSAKRFNUX1RZUEVfSVNfQ0FCTEUp
ICYmKS4gVG8gbXkgc3VycHJpc2UgdGhpcyBjYXJkIGhhcyBOTyBwcm9ibGVtIGxvY2tpbmcgCm9u
IDMwOW1oeiBhbmQgMzIxbWh6IGNoYW5uZWxzLiBJdCBzZWVtcyB0byB0YWtlIGEgbGl0dGxlIGxv
bmdlciB0byAKbG9jay9jaGFuZ2luZyBjaGFubmVscyBjb21wYXJlZCB0byBteSB0d2luaGFuIERW
Qi1TIGNhcmQgKEnCtG0gY29tcGFyaW5nIAphcHBsZXMgYW5kIG9yYW5nZXMsIHJpZ2h0PyksIGJ1
dCBzbyBmYXIgaXTCtHMgd29ya2luZyBvay4KCglNeSB0aGlyZCBhdHRlbXB0IHdhcyB3aXRoIGEg
dGVjaG5pc2F0IGNhYmxlc3RhciBIRDIgY2FyZC4gSSB1c2VkIHRoZSAKbWFudGlzIHJlcG9zaXRv
cnkgdG8gZ2V0IHRoZSBjYXJkIHdvcmtpbmcgKGlzIHRoZSBtYW50aXMgZHJpdmVyIGFscmVhZHkg
Cm1lcmdlZCB3aXRoIHY0bC1kdmI/KS4gQWdhaW4sIEkgY2FuIHNjYW4gY2hhbm5lbHMsIGJ1dCB0
aGUgY2FyZCBjb3VsZCAKbm90ICBsb2NrIG9uIHRob3NlIFRyYW5zcG9uZGVycy4gSW4gZmFjdCBp
dCBhbHNvIHRha2UgYSBsb3QgbG9uZ2VyIHRvIApsb2NrIG9uIGEgY2hhbm5lbCwgYnV0IGFmdGVy
IGl0IGdvdCBhIGxvY2ssIGl0IHdvcmtzIHJpZ2h0LgoKCVNpbmNlIHR3aW5oYW4gd29ya3MgZmlu
ZSwgSSBzdXBvc2UgdGhhdCB0aGVyZcK0cyBubyBwcm9ibGVtIHdpdGggbXkgCmNhYmxlL3NwbGl0
dGVyLiBBbHNvLCBJIHN1cG9zZSB0aGF0IHRoZSBjaGFuY2Ugb2YgdHdvIGRpc2N0aW5jdCBicm9r
ZW4gCnR1bmVycyBpcyBsb3cuIEEgcmVjZW50IHRocmVhZCBvbiBUVC0xNTAxIHNob3dzIHRoYXQs
IGlmIEkgdW5kZXJzdG9vZCAKaXQgcmlnaHQsIHRoZXJlwrRzIGEga2luZCBvZiB0YWJsZSB3aGVy
ZSBhIHBvd2VyIGxldmVsIGlzIHNldCB0byBlYWNoIApmcmVxdWVuY3kgcmFuZ2UuIElzIGl0IHBv
c3NpYmxlIHRoYXQgbXkgdHdvIGNhcmRzIGRpZG50IHdvcmtlZCBvbiB0aG9zZSAKZXNwZWNpZiB0
cmFuc3BvcmRlcnMgYmVjYXVzZSBvZiB0aGlzIGtpbmQgb2Ygc2V0dGluZz8gCgoJScK0bSBub3Qg
YSBkZXYsIGJ1dCBJIHdvdWxkIGxpa2UgdG8gaGVscCB0byBkZWJ1ZyB0aGlzLiBIb3cgY2FuIEkg
aGVscD8KCi0tIApDaHJpc3RpYW4gTHlyYQpQT1AtUFIgLSBSTlAKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmxpbnV4LWR2YiB1c2VycyBtYWlsaW5nIGxp
c3QKRm9yIFY0TC9EVkIgZGV2ZWxvcG1lbnQsIHBsZWFzZSB1c2UgaW5zdGVhZCBsaW51eC1tZWRp
YUB2Z2VyLmtlcm5lbC5vcmcKbGludXgtZHZiQGxpbnV4dHYub3JnCmh0dHA6Ly93d3cubGludXh0
di5vcmcvY2dpLWJpbi9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWR2Yg==
