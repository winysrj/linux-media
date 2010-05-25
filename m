Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38633 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab0EYXop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 19:44:45 -0400
Received: by wyb29 with SMTP id 29so2823511wyb.19
        for <linux-media@vger.kernel.org>; Tue, 25 May 2010 16:44:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: h.ordiales@gmail.com
In-Reply-To: <AANLkTinD-7F0fHvKR3D89B3_IXHWgpHkFwYr0ud93EIJ@mail.gmail.com>
References: <AANLkTinD-7F0fHvKR3D89B3_IXHWgpHkFwYr0ud93EIJ@mail.gmail.com>
From: =?ISO-8859-1?Q?Hern=E1n_Ordiales?= <h.ordiales@gmail.com>
Date: Tue, 25 May 2010 20:44:28 -0300
Message-ID: <AANLkTinyVoBwSQQbmJrItuZoJzhkrc1yr-Uflc8o2Lex@mail.gmail.com>
Subject: [PATCH] Adding support to the Geniatech/MyGica SBTVD Stick S870
	remote control
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016363ba32ae72937048773bda7
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0016363ba32ae72937048773bda7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi, i'm sending as attachment a patch against
http://linuxtv.org/hg/v4l-dvb (i hope this is ok) with some changes to
the the dib0700 module to add support for this remote control. I added
the key codes and a new case on parsing ir data
(dvb_usb_dib0700_ir_proto=3D1).

Cheers
--
Hern=E1n
http://h.ordia.com.ar
GnuPG: 0xEE8A3FE9

--0016363ba32ae72937048773bda7
Content-Type: text/x-patch; charset=US-ASCII; name="geniatech-rc.patch"
Content-Disposition: attachment; filename="geniatech-rc.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9ncit8p0

ZGlmZiAtciBiNTc2NTA5ZWE2ZDIgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIw
NzAwX2NvcmUuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBf
Y29yZS5jCVdlZCBNYXkgMTkgMTk6MzQ6MzMgMjAxMCAtMDMwMAorKysgYi9saW51eC9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfY29yZS5jCVdlZCBNYXkgMjYgMTk6MzE6MjQgMjAx
MCAtMDMwMApAQCAtNTUwLDYgKzU1MCwxNiBAQAogCQkJcG9sbF9yZXBseS5kYXRhX3N0YXRlID0g
MjsKIAkJCWJyZWFrOwogCQl9CisKKwkJYnJlYWs7CisJY2FzZSAxOgorCQkvKiBHZW5pYXRlY2gv
TXlHaWNhIHJlbW90ZSBwcm90b2NvbCAqLworCQlwb2xsX3JlcGx5LnJlcG9ydF9pZCAgPSBidWZb
MF07CisJCXBvbGxfcmVwbHkuZGF0YV9zdGF0ZSA9IGJ1ZlsxXTsKKwkJcG9sbF9yZXBseS5zeXN0
ZW0gICAgID0gKGJ1Zls0XSA8PCA4KSB8IGJ1Zls0XTsKKwkJcG9sbF9yZXBseS5kYXRhICAgICAg
ID0gYnVmWzVdOworCQlwb2xsX3JlcGx5Lm5vdF9kYXRhICAgPSBidWZbNF07IC8qIGludGVncml0
eSBjaGVjayAqLworCQkKIAkJYnJlYWs7CiAJZGVmYXVsdDoKIAkJLyogUkM1IFByb3RvY29sICov
CmRpZmYgLXIgYjU3NjUwOWVhNmQyIGxpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGli
MDcwMF9kZXZpY2VzLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIw
NzAwX2RldmljZXMuYwlXZWQgTWF5IDE5IDE5OjM0OjMzIDIwMTAgLTAzMDAKKysrIGIvbGludXgv
ZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIwNzAwX2RldmljZXMuYwlXZWQgTWF5IDI2IDE5
OjMxOjI0IDIwMTAgLTAzMDAKQEAgLTgzMSw2ICs4MzEsNDYgQEAKIAl7IDB4NDU0MCwgS0VZX1JF
Q09SRCB9LCAvKiBGb250ICdTaXplJyBmb3IgVGVsZXRleHQgKi8KIAl7IDB4NDU0MSwgS0VZX1ND
UkVFTiB9LCAvKiAgRnVsbCBzY3JlZW4gdG9nZ2xlLCAnSG9sZCcgZm9yIFRlbGV0ZXh0ICovCiAJ
eyAweDQ1NDIsIEtFWV9TRUxFQ1QgfSwgLyogU2VsZWN0IHZpZGVvIGlucHV0LCAnU2VsZWN0JyBm
b3IgVGVsZXRleHQgKi8KKworCisJLyogS2V5IGNvZGVzIGZvciB0aGUgR2VuaWF0ZWNoL015R2lj
YSBTQlRWRCBTdGljayBTODcwIHJlbW90ZQorCSAgIHNldCBkdmJfdXNiX2RpYjA3MDBfaXJfcHJv
dG89MSAqLworCXsgMHgzOGM3LCBLRVlfVFYgfSwgLyogVFYvQVYgKi8KKwl7IDB4MGNmMywgS0VZ
X1BPV0VSIH0sCisJeyAweDBhZjUsIEtFWV9NVVRFIH0sCisJeyAweDJiZDQsIEtFWV9WT0xVTUVV
UCB9LAorCXsgMHgyY2QzLCBLRVlfVk9MVU1FRE9XTiB9LAorCXsgMHgxMmVkLCBLRVlfQ0hBTk5F
TFVQIH0sCisJeyAweDEzZWMsIEtFWV9DSEFOTkVMRE9XTiB9LAorCXsgMHgwMWZlLCBLRVlfMSB9
LAorCXsgMHgwMmZkLCBLRVlfMiB9LAorCXsgMHgwM2ZjLCBLRVlfMyB9LAorCXsgMHgwNGZiLCBL
RVlfNCB9LAorCXsgMHgwNWZhLCBLRVlfNSB9LAorCXsgMHgwNmY5LCBLRVlfNiB9LAorCXsgMHgw
N2Y4LCBLRVlfNyB9LAorCXsgMHgwOGY3LCBLRVlfOCB9LAorCXsgMHgwOWY2LCBLRVlfOSB9LAor
CXsgMHgwMGZmLCBLRVlfMCB9LAorCXsgMHgxNmU5LCBLRVlfUEFVU0UgfSwKKwl7IDB4MTdlOCwg
S0VZX1BMQVkgfSwKKwl7IDB4MGJmNCwgS0VZX1NUT1AgfSwKKwl7IDB4MjZkOSwgS0VZX1JFV0lO
RCB9LAorCXsgMHgyN2Q4LCBLRVlfRkFTVEZPUldBUkQgfSwKKwl7IDB4MjlkNiwgS0VZX0VTQyB9
LAorCXsgMHgxZmUwLCBLRVlfUkVDT1JEIH0sCisJeyAweDIwZGYsIEtFWV9VUCB9LAorCXsgMHgy
MWRlLCBLRVlfRE9XTiB9LAorCXsgMHgxMWVlLCBLRVlfTEVGVCB9LAorCXsgMHgxMGVmLCBLRVlf
UklHSFQgfSwKKwl7IDB4MGRmMiwgS0VZX09LIH0sCisJeyAweDFlZTEsIEtFWV9QTEFZUEFVU0Ug
fSwgLyogVGltZXNoaWZ0ICovCisJeyAweDBlZjEsIEtFWV9DQU1FUkEgfSwgLyogU25hcHNob3Qg
Ki8KKwl7IDB4MjVkYSwgS0VZX0VQRyB9LCAvKiBJbmZvIEtFWV9JTkZPICovCisJeyAweDJkZDIs
IEtFWV9NRU5VIH0sIC8qIERWRCBNZW51ICovCisJeyAweDBmZjAsIEtFWV9TQ1JFRU4gfSwgLyog
RnVsbCBzY3JlZW4gdG9nZ2xlICovCisJeyAweDE0ZWIsIEtFWV9TSFVGRkxFIH0sCisKIH07CiAK
IC8qIFNUSzc3MDBQOiBIYXVwcGF1Z2UgTm92YS1UIFN0aWNrLCBBVmVyTWVkaWEgVm9sYXIgKi8K
--0016363ba32ae72937048773bda7--
