Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:39013 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab3EDEIs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 May 2013 00:08:48 -0400
From: Olivier GRENIE <olivier.grenie@parrot.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Patrick BOETTCHER <patrick.boettcher@parrot.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Date: Sat, 4 May 2013 05:05:50 +0100
Subject: RE: [GIT PULL FOR 3.10] DiBxxxx: fixes and improvements
Message-ID: <C73E570AC040D442A4DD326F39F0F00E2AE21490DA@SAPHIR.xi-lite.lan>
References: <1411209.JetyNPSOgp@dibcom294>,<20130427112833.203d7fbb@redhat.com>
In-Reply-To: <20130427112833.203d7fbb@redhat.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_C73E570AC040D442A4DD326F39F0F00E2AE21490DASAPHIRxilitel_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_C73E570AC040D442A4DD326F39F0F00E2AE21490DASAPHIRxilitel_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello Mauro,
can you apply the attached patch. This patch correct the proposed patch by =
Patrick for the dib807x. Sorry to not have seen it before.

regards,
Olivier

________________________________________
From: Mauro Carvalho Chehab [mchehab@redhat.com]
Sent: Saturday, April 27, 2013 4:28 PM
To: Patrick Boettcher
Cc: linux-media@vger.kernel.org; Olivier GRENIE; Patrick BOETTCHER
Subject: Re: [GIT PULL FOR 3.10] DiBxxxx: fixes and improvements

Hi Patrick,

Em Mon, 22 Apr 2013 10:12:34 +0200
Patrick Boettcher <pboettcher@kernellabs.com> escreveu:

> Hi Mauro,
>
> These patches contains some fixes and changes for the DiBcom demods and
> SIPs.
>
> Please merge for 3.10 if possible.
>
>
> The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f=
0e:
>
>   Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)
>
> are available in the git repository at:
>
>   git://git.linuxtv.org/pb/media_tree.git/ master

Hmm... I suspect that there's something wrong with those changes.

Testing it with a dib8076 usb stick seems that the code is worse than
before, as it is now harder to get a lock here.

With the previous code:

INFO     Scanning frequency #1 725142857
Carrier(0x03) Signal=3D 67.46% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
Viterbi(0x05) Signal=3D 67.08% C/N=3D 0.00% UCB=3D 0 postBER=3D 2097151
Viterbi(0x07) Signal=3D 67.54% C/N=3D 0.25% UCB=3D 165 postBER=3D 0
Sync   (0x0f) Signal=3D 67.06% C/N=3D 0.23% UCB=3D 151 postBER=3D 0
Lock   (0x1f) Signal=3D 67.58% C/N=3D 0.24% UCB=3D 160 postBER=3D 338688
Service #0 (60320) BAND HD channel 57.1.0
Service #1 (60345) BAND 1SEG channel 57.1.1

With the new code:

INFO     Scanning frequency #1 725142857
       (0x00) Signal=3D 68.80% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.78% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.69% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.82% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.29% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.27% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.28% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.27% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.55% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.50% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.43% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.65% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.75% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.29% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.28% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.25% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.43% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.46% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.43% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.90% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.50% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.28% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.22% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.22% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.43% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.41% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.41% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 68.96% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.42% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.24% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.22% C/N=3D 0.00% UCB=3D 0 postBER=3D 0
RF     (0x01) Signal=3D 69.25% C/N=3D 0.00% UCB=3D 0 postBER=3D 0

So, it seems that the changes broke something.

Regards,
Mauro=

--_002_C73E570AC040D442A4DD326F39F0F00E2AE21490DASAPHIRxilitel_
Content-Type: text/x-patch;
	name="0001-media-dib8000-correct-previous-commit.patch"
Content-Description: 0001-media-dib8000-correct-previous-commit.patch
Content-Disposition: attachment;
	filename="0001-media-dib8000-correct-previous-commit.patch"; size=2404;
	creation-date="Sat, 04 May 2013 05:07:50 GMT";
	modification-date="Sat, 04 May 2013 05:07:50 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2ZDU2Nzk1NThhYTk5ZDk3NjNmYjJkNjM4ZGU3NzFhOGY1MmM5NGZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbGl2aWVyIEdyZW5pZSA8b2xpdmllci5ncmVuaWVAcGFycm90
LmNvbT4KRGF0ZTogVGh1LCAyIE1heSAyMDEzIDE2OjExOjE0ICswMjAwClN1YmplY3Q6IFtQQVRD
SF0gW21lZGlhXSBkaWI4MDAwOiBjb3JyZWN0IHByZXZpb3VzIGNvbW1pdCBUaGUgaW50ZW5kIG9m
IHRoaXMKIHBhdGNoIGlzIHRvIGNvcnJlY3QgYSBwcmV2aW91cyBjb21taXQuIFRoaXMgY29tbWl0
IGNvcnJlY3RzCiB0aGUgYmVoYXZpb3Igb2YgdGhlIGRpYjgwN3guCgpTaWduZWQtb2ZmLWJ5OiBP
bGl2aWVyIEdyZW5pZSA8b2xpdmllci5ncmVuaWVAcGFycm90LmNvbT4KLS0tCiBkcml2ZXJzL21l
ZGlhL2R2Yi1mcm9udGVuZHMvZGliODAwMC5jIHwgICAgNiArKystLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZWRpYS9kdmItZnJvbnRlbmRzL2RpYjgwMDAuYyBiL2RyaXZlcnMvbWVkaWEvZHZiLWZyb250ZW5k
cy9kaWI4MDAwLmMKaW5kZXggNGJhN2M5MC4uYTU3OTI2YiAxMDA2NDQKLS0tIGEvZHJpdmVycy9t
ZWRpYS9kdmItZnJvbnRlbmRzL2RpYjgwMDAuYworKysgYi9kcml2ZXJzL21lZGlhL2R2Yi1mcm9u
dGVuZHMvZGliODAwMC5jCkBAIC0yNDM5LDcgKzI0MzksNyBAQCBzdGF0aWMgaW50IGRpYjgwMDBf
YXV0b3NlYXJjaF9zdGFydChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAlpZiAoc3RhdGUtPnJl
dmlzaW9uID09IDB4ODA5MCkKIAkJaW50ZXJuYWwgPSBkaWI4MDAwX3JlYWQzMihzdGF0ZSwgMjMp
IC8gMTAwMDsKIAotCWlmIChzdGF0ZS0+YXV0b3NlYXJjaF9zdGF0ZSA9PSBBU19TRUFSQ0hJTkdf
RkZUKSB7CisJaWYgKChzdGF0ZS0+cmV2aXNpb24gPj0gMHg4MDAyKSAmJiAoc3RhdGUtPmF1dG9z
ZWFyY2hfc3RhdGUgPT0gQVNfU0VBUkNISU5HX0ZGVCkpIHsKIAkJZGliODAwMF93cml0ZV93b3Jk
KHN0YXRlLCAgMzcsIDB4MDA2NSk7IC8qIFBfY3RybF9waGFfb2ZmX21heCBkZWZhdWx0IHZhbHVl
cyAqLwogCQlkaWI4MDAwX3dyaXRlX3dvcmQoc3RhdGUsIDExNiwgMHgwMDAwKTsgLyogUF9hbmFf
Z2FpbiB0byAwICovCiAKQEAgLTI0NzUsNyArMjQ3NSw3IEBAIHN0YXRpYyBpbnQgZGliODAwMF9h
dXRvc2VhcmNoX3N0YXJ0KHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlKQogCQlkaWI4MDAwX3dyaXRl
X3dvcmQoc3RhdGUsIDc3MCwgKGRpYjgwMDBfcmVhZF93b3JkKHN0YXRlLCA3NzApICYgMHhkZmZm
KSB8ICgxIDw8IDEzKSk7IC8qIFBfcmVzdGFydF9jY2cgPSAxICovCiAJCWRpYjgwMDBfd3JpdGVf
d29yZChzdGF0ZSwgNzcwLCAoZGliODAwMF9yZWFkX3dvcmQoc3RhdGUsIDc3MCkgJiAweGRmZmYp
IHwgKDAgPDwgMTMpKTsgLyogUF9yZXN0YXJ0X2NjZyA9IDAgKi8KIAkJZGliODAwMF93cml0ZV93
b3JkKHN0YXRlLCAwLCAoZGliODAwMF9yZWFkX3dvcmQoc3RhdGUsIDApICYgMHg3ZmYpIHwgKDAg
PDwgMTUpIHwgKDEgPDwgMTMpKTsgLyogUF9yZXN0YXJ0X3NlYXJjaCA9IDA7ICovCi0JfSBlbHNl
IGlmIChzdGF0ZS0+YXV0b3NlYXJjaF9zdGF0ZSA9PSBBU19TRUFSQ0hJTkdfR1VBUkQpIHsKKwl9
IGVsc2UgaWYgKChzdGF0ZS0+cmV2aXNpb24gPj0gMHg4MDAyKSAmJiAoc3RhdGUtPmF1dG9zZWFy
Y2hfc3RhdGUgPT0gQVNfU0VBUkNISU5HX0dVQVJEKSkgewogCQlzdGF0ZS0+ZmVbMF0tPmR0dl9w
cm9wZXJ0eV9jYWNoZS50cmFuc21pc3Npb25fbW9kZSA9IFRSQU5TTUlTU0lPTl9NT0RFXzhLOwog
CQlzdGF0ZS0+ZmVbMF0tPmR0dl9wcm9wZXJ0eV9jYWNoZS5ndWFyZF9pbnRlcnZhbCA9IEdVQVJE
X0lOVEVSVkFMXzFfODsKIAkJc3RhdGUtPmZlWzBdLT5kdHZfcHJvcGVydHlfY2FjaGUuaW52ZXJz
aW9uID0gMDsKQEAgLTI1NzcsNyArMjU3Nyw3IEBAIHN0YXRpYyBpbnQgZGliODAwMF9hdXRvc2Vh
cmNoX2lycShzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAlzdHJ1Y3QgZGliODAwMF9zdGF0ZSAq
c3RhdGUgPSBmZS0+ZGVtb2R1bGF0b3JfcHJpdjsKIAl1MTYgaXJxX3BlbmRpbmcgPSBkaWI4MDAw
X3JlYWRfd29yZChzdGF0ZSwgMTI4NCk7CiAKLQlpZiAoc3RhdGUtPmF1dG9zZWFyY2hfc3RhdGUg
PT0gQVNfU0VBUkNISU5HX0ZGVCkgeworCWlmICgoc3RhdGUtPnJldmlzaW9uID49IDB4ODAwMikg
JiYgKHN0YXRlLT5hdXRvc2VhcmNoX3N0YXRlID09IEFTX1NFQVJDSElOR19GRlQpKSB7CiAJCWlm
IChpcnFfcGVuZGluZyAmIDB4MSkgewogCQkJZHByaW50aygiZGliODAwMF9hdXRvc2VhcmNoX2ly
cTogbWF4IGNvcnJlbGF0aW9uIHJlc3VsdCBhdmFpbGFibGUiKTsKIAkJCXJldHVybiAzOwotLSAK
MS43LjEwLjQKCg==

--_002_C73E570AC040D442A4DD326F39F0F00E2AE21490DASAPHIRxilitel_--
