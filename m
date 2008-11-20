Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L31TB-0002Gs-2F
	for linux-dvb@linuxtv.org; Thu, 20 Nov 2008 05:48:47 +0100
Received: by ug-out-1314.google.com with SMTP id x30so177994ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 19 Nov 2008 20:48:41 -0800 (PST)
Message-ID: <412bdbff0811192048g19830371ve78b32d066794845@mail.gmail.com>
Date: Wed, 19 Nov 2008 23:48:41 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_44643_26391992.1227156521328"
Subject: [linux-dvb] [PATCH] Fix Ubuntu cleanup routine
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

------=_Part_44643_26391992.1227156521328
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attached patch addresses a problem Mike Krufky raised a couple of
weeks ago where some LUM modules were not being removed from Ubuntu
Hardy when using the make install target.

Please let me know if you have any questions.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_44643_26391992.1227156521328
Content-Type: text/x-diff; name=makefile_ubuntu_remove.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnqxa8no0
Content-Disposition: attachment; filename=makefile_ubuntu_remove.patch

Rml4IFVidW50dSBtb2R1bGUgcmVtb3ZhbCBzY3JpcHQKCkZyb206IERldmluIEhlaXRtdWVsbGVy
IDxkZXZpbi5oZWl0bXVlbGxlckBnbWFpbC5jb20+CgpUaGUgZ2VuZXJhdGVkIE1ha2VmaWxlLm1l
ZGlhIGhhZCBlbnRyaWVzIGluIGl0J3MgcmVtb3ZlIGxpc3QgZm9yClVidW50dSB0aGF0IHdlcmUg
Y29uY2F0ZW5hdGVkIHRvZ2V0aGVyLiAgQWRkIGEgc3BhY2Ugd2hlbiBjb25jYXRlbmF0aW5nCnRv
Z2V0aGVyIHRoZSB2YXJpb3VzIGxpc3RzIChzbyB0aGVyZSBpcyBhIHNwYWNlIGJldHdlZW4gdGhl
IGxpc3RzKQoKVGhhbmtzIGZvciBNaWtlIEtydWZreSA8bWtydWZreUBsaW51eHR2Lm9yZz4gZm9y
IHBvaW50aW5nIHRoaXMgb3V0IGFuZAp0ZXN0aW5nIHRoZSBmaXguCgpTaWduZWQtb2ZmLWJ5OiBE
ZXZpbiBIZWl0bXVlbGxlciA8ZGV2aW4uaGVpdG11ZWxsZXJAZ21haWwuY29tPgpJbmRleDogdjRs
LWR2Yi92NGwvc2NyaXB0cy9tYWtlX21ha2VmaWxlLnBsCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHY0bC1kdmIu
b3JpZy92NGwvc2NyaXB0cy9tYWtlX21ha2VmaWxlLnBsCTIwMDgtMTEtMTkgMjM6Mjk6NTAuMDAw
MDAwMDAwIC0wNTAwCisrKyB2NGwtZHZiL3Y0bC9zY3JpcHRzL21ha2VfbWFrZWZpbGUucGwJMjAw
OC0xMS0xOSAyMzozMDowOC4wMDAwMDAwMDAgLTA1MDAKQEAgLTE2NiwxMCArMTY2LDEwIEBACiAJ
bXkgJGZpbGVsaXN0OwogCiAJd2hpbGUgKCBteSAoJGRpciwgJGZpbGVzKSA9IGVhY2goJWluc3Rk
aXIpICkgewotCQkkZmlsZWxpc3QgLj0gam9pbignICcsIGtleXMgJSRmaWxlcyk7CisJCSRmaWxl
bGlzdCAuPSAnICcuIGpvaW4oJyAnLCBrZXlzICUkZmlsZXMpOwogCX0KIAl3aGlsZSAoIG15ICgk
ZGlyLCAkZmlsZXMpID0gZWFjaCglb2Jzb2xldGUpICkgewotCQkkZmlsZWxpc3QgLj0gam9pbign
ICcsIGtleXMgJSRmaWxlcyk7CisJCSRmaWxlbGlzdCAuPSAnICcgLiBqb2luKCcgJywga2V5cyAl
JGZpbGVzKTsKIAl9CiAJJGZpbGVsaXN0ID1+IHMvXHMrJC8vOwogCg==
------=_Part_44643_26391992.1227156521328
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_44643_26391992.1227156521328--
