Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bis.amsnet.pl ([195.64.174.7] helo=host.amsnet.pl ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gasiu@konto.pl>) id 1JdmMH-00069P-4p
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 14:05:07 +0100
Received: from dxa166.neoplus.adsl.tpnet.pl ([83.22.86.166] helo=[192.168.1.3])
	by host.amsnet.pl with esmtpa (Exim 4.67)
	(envelope-from <gasiu@konto.pl>) id 1JdmPn-0006Id-L7
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 14:08:39 +0100
Message-ID: <47E7A6F5.8030106@konto.pl>
Date: Mon, 24 Mar 2008 14:04:53 +0100
From: Gasiu <gasiu@konto.pl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] I'm not able to compile hacked szap. with new multiproto
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

SSdtIG5vdCBhYmxlIHRvIGNvbXBpbGUgaGFja2VkIHN6YXAgKGZyb20gCmFicmFoYW0ubWFudS5n
b29nbGVwYWdlcy5jb20vc3phcC5jKSB3aXRoIG5ldyBtdWx0aXByb3RvIChiNWEzNGI2YTIwOWQp
LiAKMiB3ZWVrcyBhZ28gd2FzIGEgY2hhbmdlLCBhbmQgbm93IGJ5IGNvbXBpbGluZzoKCkNDIHN6
YXAKc3phcC5jOiBJbiBmdW5jdGlvbiDigJh6YXBfdG/igJk6CnN6YXAuYzozNjg6IGVycm9yOiDi
gJhzdHJ1Y3QgZHZiZmVfaW5mb+KAmSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmGRlbGl2ZXJ54oCZ
CnN6YXAuYzozNzI6IGVycm9yOiDigJhzdHJ1Y3QgZHZiZmVfaW5mb+KAmSBoYXMgbm8gbWVtYmVy
IG5hbWVkIOKAmGRlbGl2ZXJ54oCZCnN6YXAuYzozNzY6IGVycm9yOiDigJhzdHJ1Y3QgZHZiZmVf
aW5mb+KAmSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmGRlbGl2ZXJ54oCZCnN6YXAuYzo0MDE6IGVy
cm9yOiDigJhzdHJ1Y3QgZHZiZmVfaW5mb+KAmSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmGRlbGl2
ZXJ54oCZCnN6YXAuYzo0MTI6IGVycm9yOiDigJhzdHJ1Y3QgZHZiZmVfaW5mb+KAmSBoYXMgbm8g
bWVtYmVyIG5hbWVkIOKAmGRlbGl2ZXJ54oCZCm1ha2U6ICoqKiBbc3phcF0gRXJyb3IgMQoKc3ph
cCBmcm9tOgoKZHZiLWFwcHMtMjY4NmMwODBlMGI1LnRhci5negoKZG9lc24ndCB3b3JrLi4uCgoK
Li9zemFwIHBvbG9uaWEKcmVhZGluZyBjaGFubmVscyBmcm9tIGZpbGUgJy9ob21lL2dhc2l1Ly5z
emFwL2NoYW5uZWxzLmNvbmYnCnphcHBpbmcgdG8gNCAncG9sb25pYSc6CnNhdCAwLCBmcmVxdWVu
Y3kgPSAxMTQ4OCBNSHogSCwgc3ltYm9scmF0ZSAyNzUwMDAwMCwgdnBpZCA9IDB4MDBhMCwgYXBp
ZCAKPSAweDAwNTAgc2lkID0gMHgxM2VkCnVzaW5nICcvZGV2L2R2Yi9hZGFwdGVyMC9mcm9udGVu
ZDAnIGFuZCAnL2Rldi9kdmIvYWRhcHRlcjAvZGVtdXgwJwpGRV9SRUFEX1NUQVRVUyBmYWlsZWQ6
IEludmFsaWQgYXJndW1lbnQKc3RhdHVzIDQwMDAwIHwgc2lnbmFsIGZmZmUgfCBzbnIgZmZmZSB8
IGJlciBmZmZmZmZmZSB8IHVuYyBmZmZmZmZmZSB8CkZFX1JFQURfU1RBVFVTIGZhaWxlZDogSW52
YWxpZCBhcmd1bWVudApzdGF0dXMgNDAwMDAgfCBzaWduYWwgZmZmZSB8IHNuciBmZmZlIHwgYmVy
IGZmZmZmZmZlIHwgdW5jIGZmZmZmZmZlIHwKRkVfUkVBRF9TVEFUVVMgZmFpbGVkOiBJbnZhbGlk
IGFyZ3VtZW50CnN0YXR1cyA0MDAwMCB8IHNpZ25hbCBmZmZlIHwgc25yIGZmZmUgfCBiZXIgZmZm
ZmZmZmUgfCB1bmMgZmZmZmZmZmUgfAoKCgoiLS0gClBvemRyYXdpYW0hCkdhc2l1CgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgtZHZiIG1haWxp
bmcgbGlzdApsaW51eC1kdmJAbGludXh0di5vcmcKaHR0cDovL3d3dy5saW51eHR2Lm9yZy9jZ2kt
YmluL21haWxtYW4vbGlzdGluZm8vbGludXgtZHZi
