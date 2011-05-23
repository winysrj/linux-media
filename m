Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <danzax69@yahoo.gr>) id 1QOS54-0003sB-Ja
	for linux-dvb@linuxtv.org; Mon, 23 May 2011 12:10:09 +0200
Received: from nm20.bullet.mail.ukl.yahoo.com ([217.146.183.194])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with smtp
	for <linux-dvb@linuxtv.org>
	id 1QOS54-0006Zi-E8; Mon, 23 May 2011 12:09:46 +0200
Message-ID: <885931.85151.qm@web28303.mail.ukl.yahoo.com>
Date: Mon, 23 May 2011 11:09:43 +0100 (BST)
From: Giwrgos Panou <danzax69@yahoo.gr>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] build.sh fails on kernel 2.6.38
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

SGVsbG8sCkkgdHJpZWQgdG8gYnVpbGQgdGhlIHY0bC1kdmIgb24gYW4gdWJ1bnR1IG1hY2hpbmUg
d2l0aCBrZXJuZWwgMi42LjM4LjggZ2VuZXJpYwphbmQgSSBnZXQgbWFrZSBlcnJvcjoKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KL2hvbWUvei9tZWRpYV9idWlsZC92
NGwva2luZWN0LmM6Mzg6MTk6IGVycm9yOiDigJhEX0VSUuKAmSB1bmRlY2xhcmVkIGhlcmUgKG5v
dCBpbiBhIGZ1bmN0aW9uKQovaG9tZS96L21lZGlhX2J1aWxkL3Y0bC9raW5lY3QuYzozODoyNzog
ZXJyb3I6IOKAmERfUFJPQkXigJkgdW5kZWNsYXJlZCBoZXJlIChub3QgaW4gYSBmdW5jdGlvbikK
L2hvbWUvei9tZWRpYV9idWlsZC92NGwva2luZWN0LmM6Mzg6Mzc6IGVycm9yOiDigJhEX0NPTkbi
gJkgdW5kZWNsYXJlZCBoZXJlIChub3QgaW4gYSBmdW5jdGlvbikKL2hvbWUvei9tZWRpYV9idWls
ZC92NGwva2luZWN0LmM6Mzg6NDY6IGVycm9yOiDigJhEX1NUUkVBTeKAmSB1bmRlY2xhcmVkIGhl
cmUgKG5vdCBpbiBhIGZ1bmN0aW9uKQovaG9tZS96L21lZGlhX2J1aWxkL3Y0bC9raW5lY3QuYzoz
ODo1NzogZXJyb3I6IOKAmERfRlJBTeKAmSB1bmRlY2xhcmVkIGhlcmUgKG5vdCBpbiBhIGZ1bmN0
aW9uKQovaG9tZS96L21lZGlhX2J1aWxkL3Y0bC9raW5lY3QuYzozODo2NjogZXJyb3I6IOKAmERf
UEFDS+KAmSB1bmRlY2xhcmVkIGhlcmUgKG5vdCBpbiBhIGZ1bmN0aW9uKQovaG9tZS96L21lZGlh
X2J1aWxkL3Y0bC9raW5lY3QuYzozOToyOiBlcnJvcjog4oCYRF9VU0JJ4oCZIHVuZGVjbGFyZWQg
aGVyZSAobm90IGluIGEgZnVuY3Rpb24pCi9ob21lLy9tZWRpYV9idWlsZC92NGwva2luZWN0LmM6
Mzk6MTE6IGVycm9yOiDigJhEX1VTQk/igJkgdW5kZWNsYXJlZCBoZXJlIChub3QgaW4gYSBmdW5j
dGlvbikKL2hvbWUvL21lZGlhX2J1aWxkL3Y0bC9raW5lY3QuYzozOToyMDogZXJyb3I6IOKAmERf
VjRMMuKAsiB1bmRlY2xhcmVkIGhlcmUgKG5vdCBpbiBhIGZ1bmN0aW9uKQptYWtlWzNdOiAqKiog
Wy9ob21lLy9tZWRpYV9idWlsZC92NGwva2luZWN0Lm9dIEVycm9yIDEKbWFrZVsyXTogKioqIFtf
bW9kdWxlXy9ob21lLy9tZWRpYV9idWlsZC92NGxdIEVycm9yIDIKPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1kdmIgdXNlcnMg
bWFpbGluZyBsaXN0CkZvciBWNEwvRFZCIGRldmVsb3BtZW50LCBwbGVhc2UgdXNlIGluc3RlYWQg
bGludXgtbWVkaWFAdmdlci5rZXJuZWwub3JnCmxpbnV4LWR2YkBsaW51eHR2Lm9yZwpodHRwOi8v
d3d3LmxpbnV4dHYub3JnL2NnaS1iaW4vbWFpbG1hbi9saXN0aW5mby9saW51eC1kdmI=
