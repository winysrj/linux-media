Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <petr.mlejnek@seznam.cz>) id 1R1YYO-00085X-0D
	for linux-dvb@linuxtv.org; Thu, 08 Sep 2011 08:58:04 +0200
Received: from smtp2.seznam.cz ([77.75.76.43])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1R1YYN-0004zJ-CK; Thu, 08 Sep 2011 08:57:39 +0200
To: linux-dvb@linuxtv.org
Date: Thu, 08 Sep 2011 08:57:33 +0200
MIME-Version: 1.0
From: "petr.mlejnek" <petr.mlejnek@seznam.cz>
Message-ID: <op.v1g9l7tr3ep1lw@pop3.seznam.cz>
Subject: [linux-dvb] Mantis driver for Technisat CableStar HD2 and CI module
	support
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"; DelSp="yes"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

SGkgdG8gYWxsLApJIGJvdWdodCB0aGlzIERWQi1DIGNhcmQgMiB5ZWFycyBhZ28gYW5kIEkgaGF2
ZSBiZWVuIHVzaW5nIGl0IHdpdGggdGhlCm1hbnRpcyBkcml2ZXIgd2l0aG91dCBhbnkgcHJvYmxl
bS4gQlVUIEkgaGF2ZSBiZWVuIHVzaW5nIGl0IG9ubHkgZm9yCm5vbi1lbmNyeXB0ZWQgdHYgc3Ry
ZWFtcyAod2l0aG91dCBDQSBtb2R1bGUpLgpJIHdhbnQgdG8gd2F0Y2ggYWxzbyBlbmNyeXB0ZWQg
Y2hhbm5lbHMgc28gSSBwdXJjaGFzZWQgQ0kgbW9kdWxlIGZyb20gbXkKY2FibGUgdHYgcHJvdmlk
ZXIuIEJ1dCBpdCBkb2VzbsK0dCB3b3JrLiBJIGNhbiBzdGlsbCBzZWUgb25seSBmcmVlCm5vbi1l
bmNyeXB0ZWQgY2hhbm5lbHMuCkkgaGF2ZSBzZWFyY2hlZCB0aGlzIGRpc2N1c3Npb24gYW5kIHRo
ZSBsYXN0IG1lbnRpb24gYWJvdXQgQ0EgbW9kdWxlIGlzCiAgICAgZnJvbSB0aGUgeWVhciAyMDA4
IHNheWluZyB0aGF0IGl0IHdhc27CtHQgc3VwcG9ydGVkIHlldCwgYnV0IGl0IHdvdWxkIGJlCmRv
bmUgc29vbjoKaHR0cDovL3d3dy5saW51eHR2Lm9yZy9waXBlcm1haWwvbGludXgtZHZiLzIwMDgt
U2VwdGVtYmVyLzAyODg1Ny5odG1sCgpJcyB0aGVyZSBhbnkgcHJvZ3Jlc3M/IEFueSBoZWxwIHdp
bGwgYmUgYXBwcmVjaWF0ZWQuCkJlc3QgcmVnYXJkcywKUGV0cgoKCi0tIApPZGNob3rDrSB6cHLD
oXZhIG5lb2JzYWh1amUgdmlyeS4gRS1tYWlsIGJ5bCB0b3Rpxb4gdnl0dm/FmWVuIHYgcHJvc3TF
mWVkw60Kb3BlcmHEjW7DrWhvIHN5c3TDqWhvIExpbnV4LgotLQpUYXRvIHpwcsOhdmEgYnlsYSB2
eXR2b8WZZW5hIHBvxaF0b3Zuw61tIGtsaWVudGVtICJNMiIsIGt0ZXLDvSBqZSBzdGFuZGFyZG7D
rQpzb3XEjcOhc3TDrSB3ZWJvdsOpaG8gcHJvaGzDrcW+ZcSNZSBPcGVyYSBuYSBvcGVyYcSNbsOt
bSBzeXN0w6ltdSBMaW51eC4gVsOtY2UKaW5mb3JtYWPDrSBuYWpkZXRlIG5hIGh0dHA6Ly93d3cu
b3BlcmEuY29tL20yLwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KbGludXgtZHZiIHVzZXJzIG1haWxpbmcgbGlzdApGb3IgVjRML0RWQiBkZXZlbG9wbWVu
dCwgcGxlYXNlIHVzZSBpbnN0ZWFkIGxpbnV4LW1lZGlhQHZnZXIua2VybmVsLm9yZwpsaW51eC1k
dmJAbGludXh0di5vcmcKaHR0cDovL3d3dy5saW51eHR2Lm9yZy9jZ2ktYmluL21haWxtYW4vbGlz
dGluZm8vbGludXgtZHZi
