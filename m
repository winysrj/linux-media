Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailserv.web-arts.de ([85.220.131.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thorsten.barth@web-arts.com>) id 1JzGaL-0002fv-Ig
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 21:36:26 +0200
Message-ID: <4835CCE9.9060005@web-arts.com>
Date: Thu, 22 May 2008 21:43:37 +0200
From: Thorsten Barth <thorsten.barth@web-arts.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Cc: Thorsten Barth <thorsten.barth@web-arts.com>
Subject: [linux-dvb] driver problem with both TechnoTrend 1500 PCI and Nova
 S-Plus - none of the cards work
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

SGVsbG8sCgpJIGhhdmUgYSBkcml2ZXIgcHJvYmxlbSB3aXRoIHR3byBidWRnZXQgRFZCIGNhcmRz
IC0gbm9uZSBvZiB0aGVtIHdvcmtzLgpBIFRlY2hub1RyZW5kIDE1MDAsIGFuZCBhIEhhdXBwYXVn
ZSBOb3ZhIFMtUGx1cy4KClRoZSBIYXVwcGF1Z2UgY2FyZCBvbmx5IHNob3dzIHVwIGFzIC9kZXYv
dmlkZW8wLCBhbmQgdGhlcmUgaXMgbm8KZGlyZWN0b3J5IC9kZXYvZHZiLCB0aG91Z2ggdWRldiBp
cyBydW5uaW5nLiBUaGUgVGVjaG5vdHJlbmQgY2FyZCBkb2VzCm5vdCBzaG93IHVwIGFzIGRldmlj
ZSBhdCBhbGwuCgpJIGFtIHVzaW5nIGt1YnVudHUgNy4xMCAobGludXhNQ0UpLCBidXQgYWZ0ZXIg
SSBmb3VuZCBvdXQgdGhhdCBub3RoaW5nCndvcmtlZCwgSSBjb21waWxlZCBhbmQgaW5zdGFsbGVk
IHRoZSBsYXRlc3QgSTRMIGRyaXZlcnMgLSBubyBkaWZmZXJlbmNlLgoKPiBkbWVzZ3xncmVwIGR2
YgpbIDM4LjY0MjUxNF0gY3g4OC8yOiBjeDIzODh4IGR2YiBkcml2ZXIgdmVyc2lvbiAwLjAuNiBs
b2FkZWQKWyAzOC42NDI1MjBdIGN4ODgvMjogcmVnaXN0ZXJpbmcgY3g4ODAyIGRyaXZlciwgdHlw
ZTogZHZiIGFjY2Vzczogc2hhcmVkClsgMzguNjgzMzA3XSBjeDg4WzBdLzI6IGR2Yl9yZWdpc3Rl
ciBmYWlsZWQgKGVyciA9IC0yMikKClRoaXMgaXMgd2hhdCBpdCBkb2VzIGluIC92YXIvbG9nL21l
c3NhZ2VzIC0gdGhlcmUgYXJlIHNvbWUgZXJyb3JzLiBJCmRvbsK0dCBmaW5kIGFueXRoaW5nIGlu
IHRoZSBmaWxlIGZvciB0aGUgVGVjaG5vVHJlbmQgY2FyZC4KCk1heSAxOCAxNDo0NDo0OCBkY2Vy
b3V0ZXIga2VybmVsOiBbIDQxLjc2MzU4Nl0gY3gyMzg4eCBkdmIgZHJpdmVyCnZlcnNpb24gMC4w
LjYgbG9hZGVkCk1heSAxOCAxNDo0NDo0OCBkY2Vyb3V0ZXIga2VybmVsOiBbIDQxLjY4NTcyNl0g
dHZlZXByb20gMC0wMDUwOiBkZWNvZGVyCnByb2Nlc3NvciBpcyBDWDg4MyAoaWR4IDIyKQpNYXkg
MTggMTQ6NDQ6NDggZGNlcm91dGVyIGtlcm5lbDogWyA0MS42ODU3MjhdIHR2ZWVwcm9tIDAtMDA1
MDogaGFzIG5vCnJhZGlvLCBoYXMgSVIgcmVjZWl2ZXIsIGhhcyBubyBJUiB0cmFuc21pdHRlcgpN
YXkgMTggMTQ6NDQ6NDggZGNlcm91dGVyIGtlcm5lbDogWyA0MS42ODU3MzFdIGN4ODhbMF06IGhh
dXBwYXVnZQplZXByb206IG1vZGVsPTkyMDAxCk1heSAxOCAxNDo0NDo0OCBkY2Vyb3V0ZXIga2Vy
bmVsOiBbIDQxLjY4NTgyMF0gaW5wdXQ6IGN4ODggSVIgKEhhdXBwYXVnZQpOb3ZhLVMtUGx1cyBh
cyAvY2xhc3MvaW5wdXQvaW5wdXQ1Ck1heSAxOCAxNDo0NDo0OCBkY2Vyb3V0ZXIga2VybmVsOiBb
IDQxLjY4NTg1OV0gY3g4OFswXS8yOiBjeDIzODh4IDg4MDIKRHJpdmVyIE1hbmFnZXIKTWF5IDE4
IDE0OjQ0OjQ4IGRjZXJvdXRlciBrZXJuZWw6IFsgNDEuNjg1ODgzXSBBQ1BJOiBQQ0kgSW50ZXJy
dXB0CjAwMDA6MDI6MDIuMltBXSAtPiBHU0kgMTggKGxldmVsLCBsb3cpIC0+IElSUSAxOApNYXkg
MTggMTQ6NDQ6NDggZGNlcm91dGVyIGtlcm5lbDogWyA0MS42ODU4OTVdIGN4ODhbMF0vMjogZm91
bmQgYXQKMDAwMDowMjowMi4yLCByZXY6IDUsIGlycTogMTgsIGxhdGVuY3k6IDY0LCBtbWlvOiAw
eGZjMDAwMDAwCk1heSAxOCAxNDo0NDo0OCBkY2Vyb3V0ZXIga2VybmVsOiBbIDQxLjY4NTk5NF0g
QUNQSTogUENJIEludGVycnVwdAowMDAwOjAyOjAyLjBbQV0gLT4gR1NJIDE4IChsZXZlbCwgbG93
KSAtPiBJUlEgMTgKTWF5IDE4IDE0OjQ0OjQ4IGRjZXJvdXRlciBrZXJuZWw6IFsgNDEuNjg1ODIw
XSBpbnB1dDogY3g4OCBJUiAoSGF1cHBhdWdlCk5vdmEtUy1QbHVzIGFzIC9jbGFzcy9pbnB1dC9p
bnB1dDUKTWF5IDE4IDE0OjQ0OjQ4IGRjZXJvdXRlciBrZXJuZWw6IFsgNDEuNjg1ODU5XSBjeDg4
WzBdLzI6IGN4MjM4OHggODgwMgpEcml2ZXIgTWFuYWdlcgpNYXkgMTggMTQ6NDQ6NDggZGNlcm91
dGVyIGtlcm5lbDogWyA0MS42ODU4ODNdIEFDUEk6IFBDSSBJbnRlcnJ1cHQKMDAwMDowMjowMi4y
W0FdIC0+IEdTSSAxOCAobGV2ZWwsIGxvdykgLT4gSVJRIDE4Ck1heSAxOCAxNDo0NDo0OCBkY2Vy
b3V0ZXIga2VybmVsOiBbIDQxLjY4NTg5NV0gY3g4OFswXS8yOiBmb3VuZCBhdAowMDAwOjAyOjAy
LjIsIHJldjogNSwgaXJxOiAxOCwgbGF0ZW5jeTogNjQsIG1taW86IDB4ZmMwMDAwMDAKTWF5IDE4
IDE0OjQ0OjQ4IGRjZXJvdXRlciBrZXJuZWw6IFsgNDEuNjg1OTk0XSBBQ1BJOiBQQ0kgSW50ZXJy
dXB0CjAwMDA6MDI6MDIuMFtBXSAtPiBHU0kgMTggKGxldmVsLCBsb3cpIC0+IElSUSAxOApNYXkg
MTggMTQ6NDQ6NDggZGNlcm91dGVyIGtlcm5lbDogWyA0MS42ODYwMDldIGN4ODhbMF0vMDogZm91
bmQgYXQKMDAwMDowMjowMi4wLCByZXY6IDUsIGlycTogMTgsIGxhdGVuY3k6IDY0LCBtbWlvOiAw
eGZhMDAwMDAwCk1heSAxOCAxNDo0NDo0OCBkY2Vyb3V0ZXIga2VybmVsOiBbIDQxLjY4NjA1OF0g
Y3g4OFswXS8wOiByZWdpc3RlcmVkCmRldmljZSB2aWRlbzAgW3Y0bDJdCk1heSAxOCAxNDo0NDo0
OCBkY2Vyb3V0ZXIga2VybmVsOiBbIDQxLjY4NjA4NF0gY3g4OFswXS8wOiByZWdpc3RlcmVkCmRl
dmljZSB2YmkwCk1heSAxOCAxNDo0NDo0OCBkY2Vyb3V0ZXIga2VybmVsOiBbIDQxLjc2MzU4Nl0g
Y3gyMzg4eCBkdmIgZHJpdmVyCnZlcnNpb24gMC4wLjYgbG9hZGVkCk1heSAxOCAxNDo0NDo0OCBk
Y2Vyb3V0ZXIga2VybmVsOiBbIDQxLjc2MzU5Ml0gY3g4ODAyX3JlZ2lzdGVyX2RyaXZlcigpCi0+
cmVnaXN0ZXJpbmcgZHJpdmVyIHR5cGU9ZHZiIGFjY2Vzcz1zaGFyZWQKTWF5IDE4IDE0OjQ0OjQ4
IGRjZXJvdXRlciBrZXJuZWw6IFsgNDEuNzYzNTk4XSBDT1JFIGN4ODhbMF06IHN1YnN5c3RlbToK
MDA3MDo5MjAyLCBib2FyZDogSGF1cHBhdWdlIE5vdmEtUy1QbHVzIERWQi1TIFtjYXJkPTM3XQpN
YXkgMTggMTQ6NDQ6NDggZGNlcm91dGVyIGtlcm5lbDogWyA0MS43NjM2MDNdIGN4ODhbMF0vMjog
Y3gyMzg4eCBiYXNlZApkdmIgY2FyZApNYXkgMTggMTQ6NDQ6NDggZGNlcm91dGVyIGtlcm5lbDog
WyA0MS44MTUyNzhdIGN4MjQxMjNfcmVhZHJlZzogcmVnPTB4MAooZXJyb3I9LTEyMSkKTWF5IDE4
IDE0OjQ0OjQ4IGRjZXJvdXRlciBrZXJuZWw6IFsgNDEuODE1Mjg0XSBWZXJzaW9uICE9IGQxIG9y
IGUxCk1heSAxOCAxNDo0NDo0OCBkY2Vyb3V0ZXIga2VybmVsOiBbIDQxLjgxNTM2OV0gY3g4OFsw
XTogZnJvbnRlbmQKaW5pdGlhbGl6YXRpb24gZmFpbGVkCk1heSAxOCAxNDo0NDo0OCBkY2Vyb3V0
ZXIga2VybmVsOiBbIDQxLjgxNTM3Ml0gY3g4ODAyX2R2Yl9wcm9iZQpkdmJfcmVnaXN0ZXIgZmFp
bGVkIGVyciA9IC0xCgpCdXQgaXQgaXMgdHJ5aW5nIHRvIGRvIHNvbWV0aGluZyB3aXRoIHRoZSBU
ZWNobm9UcmVuZCBjYXJkIGFzIHdlbGwKKGRtZXNnLi4uKQpbIDM5LjAxMzEwMl0gc2FhNzE0Njog
cmVnaXN0ZXIgZXh0ZW5zaW9uICdidWRnZXRfY2kgZHZiJy4KClRoZSBUZWNobm90cmVuZCBjYXJk
IEkgd2FudGVkIHRvIHNldCB1cCB3aXRoICJzdWRvIG1vZHByb2JlIGR2Yi10dHBjaSIgLQphZnRl
ciB0aGF0IGRtZXNnIHNob3dzOgpbIDcwOS42MDI4OTRdIHNhYTcxNDY6IHJlZ2lzdGVyIGV4dGVu
c2lvbiAnZHZiJy4KCkkgZXZlbiB0cmllZCAic3VkbyBtb2Rwcm9iZSBzdHYwMjk5IiB3aGljaCB3
b3JrZWQsIGJ1dCBnYXZlIG5vCmFkZGl0aW9uYWwgcmVzdWx0LgoKUmlnaHQgbm93ICJsc21vZHxn
cmVwIGR2YiIgbG9va3MgbGlrZSB0aGlzOgoKZHZiX3R0cGNpIDEwNDc3NiAwCnNhYTcxNDZfdnYg
NTA2ODggMSBkdmJfdHRwY2kKc2FhNzE0NiAyMDM2MCA1IGJ1ZGdldCxkdmJfdHRwY2ksc2FhNzE0
Nl92dixidWRnZXRfY2ksYnVkZ2V0X2NvcmUKdHRwY2lfZWVwcm9tIDM0NTYgMiBkdmJfdHRwY2ks
YnVkZ2V0X2NvcmUKdmlkZW9idWZfZHZiIDc4MTIgMApkdmJfY29yZSA4MTA1MiA2IHN0djAyOTks
YnVkZ2V0LGR2Yl90dHBjaSxidWRnZXRfY2ksYnVkZ2V0X2NvcmUsdmlkZW9idWZfZHZiCnZpZGVv
YnVmX2NvcmUgMTk1ODggNgpzYWE3MTQ2X3Z2LHZpZGVvYnVmX2R2YixjeDg4MDAsY3g4ODAyLGN4
ODh4eCx2aWRlb2J1Zl9kbWFfc2cKaTJjX2NvcmUgMjYxMTIgMTMKc3R2MDI5OSxidWRnZXQsZHZi
X3R0cGNpLGJ1ZGdldF9jaSxidWRnZXRfY29yZSx0dHBjaV9lZXByb20sY3gyNDEyMyxjeDg4X3Zw
MzA1NF9pMmMsY3g4OHh4LGkyY19hbGdvX2JpdCx0dmVlcHJvbSx2NGwyX2NvbW1vbixudmlkaWEK
CkkgYW0gZmluYWxseSBzdHVjayBjb21wbGV0ZWx5IGFuZCB3b3VsZCBhcHByZWNpYXRlIGFueSBo
ZWxwLgoKS2luZCByZWdhcmRzCi0tIAoqVGhvcnN0ZW4gQmFydGgqCgoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgtZHZiIG1haWxpbmcgbGlzdAps
aW51eC1kdmJAbGludXh0di5vcmcKaHR0cDovL3d3dy5saW51eHR2Lm9yZy9jZ2ktYmluL21haWxt
YW4vbGlzdGluZm8vbGludXgtZHZi
