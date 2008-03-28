Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JfMZw-0006Qr-Ey
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 22:57:41 +0100
Received: by py-out-1112.google.com with SMTP id a29so516005pyi.0
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 14:57:27 -0700 (PDT)
Message-ID: <19a3b7a80803281457j40c2fd6at908a8e0d62310875@mail.gmail.com>
Date: Fri, 28 Mar 2008 22:57:27 +0100
From: "Christoph Pfister" <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <200803281820.54243.christophpfister@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_11261_17380257.1206741447284"
References: <200803212024.17198.christophpfister@gmail.com>
	<200803220732.06390@orion.escape-edv.de>
	<200803281820.54243.christophpfister@gmail.com>
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

------=_Part_11261_17380257.1206741447284
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/3/28, Christoph Pfister <christophpfister@gmail.com>:
<snip>
>  > Are you _sure_ that 'reinitialise_demod = 1' is required by all 3 card
>  > types, and does not hurt for SUBID_DVBS_KNC1_PLUS (1131:0011, 1894:0011)
>  > and SUBID_DVBS_EASYWATCH_1 (1894:001a)?
>
>
> Do you want me to limit reinitialise_demod to the one type of card I'm using
>  or is it ok for you this way?
>
>  (I'll repost a modified version of the first patch removing the 0xff check
>  altogether later today ...)
<snip>

Here it is.

Christoph

------=_Part_11261_17380257.1206741447284
Content-Type: text/plain; name=fix-budget-av-cam.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fedap0z6
Content-Disposition: attachment; filename=fix-budget-av-cam.diff

IyBIRyBjaGFuZ2VzZXQgcGF0Y2gKIyBVc2VyIENocmlzdG9waCBQZmlzdGVyIDxwZmlzdGVyQGxp
bnV4dHYub3JnPgojIERhdGUgMTIwNjc0MTE4NyAtMzYwMAojIE5vZGUgSUQgZjkzYzMwMmMxNGU1
MWRjN2RiZjJhMjYyNWNmYzA4NDIzYzYwODM4OQojIFBhcmVudCAgMDc3NmU0ODAxOTkxMjg1MTk2
NjZjYzc1ZmE5NGM0ZWQ2NGRiODNmMgpGaXggc3VwcG9ydCBmb3IgY2VydGFpbiBjYW1zIGluIGJ1
Z2V0LWF2ClRoZSBjdXJyZW50IGNpIGltcGxlbWVudGF0aW9uIGRvZXNuJ3QgYWNjZXB0IDB4ZmYg
d2hlbiByZWFkaW5nIGRhdGEgYnl0ZXMgKGFkZHJlc3MgPT0gMCksCnRodXMgYnJlYWtzIGNhbXMg
d2hpY2ggcmVwb3J0IGEgYnVmZmVyIHNpemUgb2YgMHgtLWZmIGxpa2UgbXkgb3Jpb24gb25lLgpS
ZW1vdmUgdGhlIDB4ZmYgY2hlY2sgYWx0b2dldGhlciwgYmVjYXVzZSB2YWxpZGF0aW9uIGlzIHJl
YWxseSB0aGUgam9iIG9mIGEgaGlnaGVyIGxheWVyLgpTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
UGZpc3RlciA8cGZpc3RlckBsaW51eHR2Lm9yZz4KCmRpZmYgLXIgMDc3NmU0ODAxOTkxIC1yIGY5
M2MzMDJjMTRlNSBsaW51eC9kcml2ZXJzL21lZGlhL2R2Yi90dHBjaS9idWRnZXQtYXYuYwotLS0g
YS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi90dHBjaS9idWRnZXQtYXYuYwlGcmkgTWFyIDI4IDE0
OjUyOjQ0IDIwMDggLTAzMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvdHRwY2kvYnVk
Z2V0LWF2LmMJRnJpIE1hciAyOCAyMjo1MzowNyAyMDA4ICswMTAwCkBAIC0xNzgsNyArMTc4LDcg
QEAgc3RhdGljIGludCBjaWludGZfcmVhZF9jYW1fY29udHJvbChzdHJ1YwogCXVkZWxheSgxKTsK
IAogCXJlc3VsdCA9IHR0cGNpX2J1ZGdldF9kZWJpcmVhZCgmYnVkZ2V0X2F2LT5idWRnZXQsIERF
QklDSUNBTSwgYWRkcmVzcyAmIDMsIDEsIDAsIDApOwotCWlmICgocmVzdWx0ID09IC1FVElNRURP
VVQpIHx8ICgocmVzdWx0ID09IDB4ZmYpICYmICgoYWRkcmVzcyAmIDMpIDwgMikpKSB7CisJaWYg
KHJlc3VsdCA9PSAtRVRJTUVET1VUKSB7CiAJCWNpaW50Zl9zbG90X3NodXRkb3duKGNhLCBzbG90
KTsKIAkJcHJpbnRrKEtFUk5fSU5GTyAiYnVkZ2V0LWF2OiBjYW0gZWplY3RlZCAzXG4iKTsKIAkJ
cmV0dXJuIC1FVElNRURPVVQ7Cg==
------=_Part_11261_17380257.1206741447284
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_11261_17380257.1206741447284--
