Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <h@ordia.com.ar>) id 1OH3YK-0003FK-CA
	for linux-dvb@linuxtv.org; Wed, 26 May 2010 01:28:53 +0200
Received: from mail-ww0-f54.google.com ([74.125.82.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OH3YJ-0003JS-Bp; Wed, 26 May 2010 01:28:51 +0200
Received: by wwe15 with SMTP id 15so234540wwe.41
	for <linux-dvb@linuxtv.org>; Tue, 25 May 2010 16:28:50 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Hern=E1n_Ordiales?= <h.ordiales@gmail.com>
Date: Tue, 25 May 2010 20:28:35 -0300
Message-ID: <AANLkTinD-7F0fHvKR3D89B3_IXHWgpHkFwYr0ud93EIJ@mail.gmail.com>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary=0016e6d7df9f0f6d1c0487738587
Subject: [linux-dvb] [PATCH] Adding support to the Geniatech/MyGica SBTVD
	Stick S870 remote control
Reply-To: linux-media@vger.kernel.org, h.ordiales@gmail.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--0016e6d7df9f0f6d1c0487738587
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi, i'm sending as attachment a patch against
http://linuxtv.org/hg/v4l-dvb (i hope this is ok) with some changes to
the the dib0700 module to add support for this remote control. I added
the key codes and a new case on parsing ir data
(dvb_usb_dib0700_ir_proto=3D1).

Cheers
--=20
Hern=E1n
http://h.ordia.com.ar
GnuPG: 0xEE8A3FE9

--0016e6d7df9f0f6d1c0487738587
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
--0016e6d7df9f0f6d1c0487738587
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--0016e6d7df9f0f6d1c0487738587--
