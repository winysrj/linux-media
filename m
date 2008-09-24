Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1KiczN-0002M6-9Y
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 00:37:41 +0200
Date: Thu, 25 Sep 2008 01:37:37 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: "Igor M. Liplianin" <liplianin@tut.by>
Message-ID: <Pine.LNX.4.64.0809250125040.11057@shogun.pilppa.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463809533-977040583-1222295857=:11057"
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] dvb-t fix for hvr-4000 multiproto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463809533-977040583-1222295857=:11057
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Even if S2 will be the future, multiproto is still needed at least with 
VDR. So to get dvb-t working with latest multiproto from
http://mercurial.intuxication.org/hg/liplianindvb with HVR-4000 and 2.6.26 
kernel, I needed to add radio definitions for hvr-4000.

memset and udelay changes from s2-mfe were really not making any visible 
changes for me, but at least the memset call is a good thing to 
do.

Signed-off-by: Mika Laitio <lamikr@pilppa.org>
---1463809533-977040583-1222295857=:11057
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=multiproto-hvr4000-dvbt_fix.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0809250137370.11057@shogun.pilppa.org>
Content-Description: multiproto fixes for hvr-4000
Content-Disposition: attachment; filename=multiproto-hvr4000-dvbt_fix.patch

LS0tIGN4ODgtY2FyZHMuY19vbGQJMjAwOC0wOS0yNSAwMDo1MToxOC4wMDAw
MDAwMDAgKzAzMDANCisrKyBjeDg4LWNhcmRzLmMJMjAwOC0wOS0yNCAxMDo0
NDoxNS4wMDAwMDAwMDAgKzAzMDANCkBAIC0xNDgwLDYgKzE0ODAsMTAgQEAN
CiAJCX19LA0KIAkJLyogZml4bWU6IEFkZCByYWRpbyBzdXBwb3J0ICovDQog
CQkubXBlZyAgICAgICAgICAgPSBDWDg4X01QRUdfRFZCLA0KKwkJLnJhZGlv
ID0gew0KKwkJCS50eXBlICAgPSBDWDg4X1JBRElPLA0KKwkJCS5ncGlvMAk9
IDB4ZTc4MCwNCisJCX0sDQogCX0sDQogCVtDWDg4X0JPQVJEX0hBVVBQQVVH
RV9IVlI0MDAwTElURV0gPSB7DQogCQkubmFtZSAgICAgICAgICAgPSAiSGF1
cHBhdWdlIFdpblRWLUhWUjQwMDAoTGl0ZSkgRFZCLVMvUzIiLA0KQEAgLTI1
OTQsOCArMjU5OCw5IEBADQogCQlicmVhazsNCiAJY2FzZSBDWDg4X0JPQVJE
X0hBVVBQQVVHRV9IVlIzMDAwOiAvKiA/ICovDQogCWNhc2UgQ1g4OF9CT0FS
RF9IQVVQUEFVR0VfSFZSNDAwMDoNCi0JCS8qIEluaXQgR1BJTyBmb3IgRFZC
LVMvUzIvQW5hbG9nICovDQotCQljeF93cml0ZShNT19HUDBfSU8sY29yZS0+
Ym9hcmQuaW5wdXRbMF0uZ3BpbzApOw0KKwkJLyogSW5pdCBHUElPICovDQor
CQljeF93cml0ZShNT19HUDBfSU8sIGNvcmUtPmJvYXJkLmlucHV0WzBdLmdw
aW8wKTsNCisJCXVkZWxheSgxMDAwKTsNCiAJCWJyZWFrOw0KIA0KIAljYXNl
IENYODhfQk9BUkRfUFJPTElOS19QVl84MDAwR1Q6DQpAQCAtMjkzOSw2ICsy
OTQ0LDcgQEANCiAJCWN4ODhfY2FyZF9saXN0KGNvcmUsIHBjaSk7DQogCX0N
CiANCisJbWVtc2V0KCZjb3JlLT5ib2FyZCwgMCwgc2l6ZW9mKGNvcmUtPmJv
YXJkKSk7DQogCW1lbWNweSgmY29yZS0+Ym9hcmQsICZjeDg4X2JvYXJkc1tj
b3JlLT5ib2FyZG5yXSwgc2l6ZW9mKGNvcmUtPmJvYXJkKSk7DQogDQogCWlu
Zm9fcHJpbnRrKGNvcmUsICJzdWJzeXN0ZW06ICUwNHg6JTA0eCwgYm9hcmQ6
ICVzIFtjYXJkPSVkLCVzXVxuIiwNCg==

---1463809533-977040583-1222295857=:11057
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---1463809533-977040583-1222295857=:11057--
