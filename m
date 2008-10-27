Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9RCit3D011173
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 08:44:55 -0400
Received: from root.phytec.de (mail.microcatalog.org.uk [217.6.246.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9RChxDd028186
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 08:44:00 -0400
Received: from idefix.phytec.de (idefix.phytec.de [172.16.0.10])
	by root.phytec.de (Postfix) with ESMTP id AFDBABF0E9
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 13:20:08 +0100 (CET)
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <OFCC904212.642A003E-ONC12574EF.00458E69-C12574EF.0045EFB0@phytec.de>
From: Dirk Heer <D.Heer@phytec.de>
Date: Mon, 27 Oct 2008 13:43:53 +0100
Content-Type: multipart/mixed; boundary="=_mixed 0045EFACC12574EF_="
Subject: patch for bttv driver  (bttv-cards.c and bttv.h)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--=_mixed 0045EFACC12574EF_=
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

i build a patch for the bttv driver.



I hope some one can build them into the Kernel.

The patch is made with the 2.6.25.16-0.1-pae Kernel version.


Yours faithfully,

Dipl.-Ing. (FH) Dirk Heer


++++++++++++++++++++++++++
PHYTEC Messtechnik GmbH
Abteilung Bildverarbeitung
Robert-Koch-Str. 39
D-55129 Mainz

Tel:   +49 (6131) / 9221-0
Fax:  +49 (6131) / 9221-33

E-Mail: d.heer@phytec.de
Internet: http://www.phytec.de

Handelsregister Mainz HRB 4656
Gesch=E4ftsf=FChrer: Dipl.-Ing. Michael Mitezki
+++++++++++++++++++++++++


--=_mixed 0045EFACC12574EF_=
Content-Type: application/octet-stream; name="phytec_bttv_patch"
Content-Disposition: attachment; filename="phytec_bttv_patch"
Content-Transfer-Encoding: base64

ZGlmZiAtdSAtciBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2J0OHh4L2J0dHYtY2FyZHMuYyBi
dHR2X3BhdGNoL2RyaXZlcnMvbWVkaWEvdmlkZW8vYnQ4eHgvYnR0di1jYXJkcy5jCi0tLSBsaW51
eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2J0OHh4L2J0dHYtY2FyZHMuYwkyMDA4LTA0LTE3IDA0OjQ5
OjQ0LjAwMDAwMDAwMCArMDIwMAorKysgYnR0dl9wYXRjaC9kcml2ZXJzL21lZGlhL3ZpZGVvL2J0
OHh4L2J0dHYtY2FyZHMuYwkyMDA4LTEwLTI3IDEyOjU3OjM2LjAwMDAwMDAwMCArMDEwMApAQCAt
Mjk5Miw2ICsyOTkyLDY5IEBACiAJCS50dW5lcl9hZGRyICAgICA9IEFERFJfVU5TRVQsCiAJCS5y
YWRpb19hZGRyICAgICA9IEFERFJfVU5TRVQsCiAJfSwKKwkKKwkJW0JUVFZfQk9BUkRfVkQwMTFf
TUlOSURJTl0gPSB7CisJCS8qQEQuSGVlckBweXRlYy5kZSAqLworCQkubmFtZSAgICAgICAgICAg
PSAiUEhZVEVDIFZELTAxMSBNaW5pRElOIChidDg3OCkiLAorCQkudmlkZW9faW5wdXRzICAgPSA0
LAorCQkuYXVkaW9faW5wdXRzICAgPSAwLAorCQkudHVuZXIgICAgICAgICAgPSBVTlNFVCwgLyog
Y2FyZCBoYXMgbm8gdHVuZXIgKi8KKwkJLnN2aHMgICAgICAgICAgID0gMywKKwkJLmdwaW9tYXNr
ICAgICAgID0gMHgwMCwKKwkJLm11eHNlbCAgICAgICAgID0geyAyLCAzLCAxLCAwIH0sCisJCS5n
cGlvbXV4ICAgICAgICA9IHsgMCwgMCwgMCwgMCB9LCAvKiBjYXJkIGhhcyBubyBhdWRpbyAqLwor
CQkubmVlZHNfdHZhdWRpbyAgPSAxLAorCQkucGxsICAgICAgICAgICAgPSBQTExfMjgsCisJCS50
dW5lcl90eXBlICAgICA9IFVOU0VULAorCQkudHVuZXJfYWRkcgk9IEFERFJfVU5TRVQsCisJCS5y
YWRpb19hZGRyICAgICA9IEFERFJfVU5TRVQsCisJfSwJCisJCVtCVFRWX0JPQVJEX1ZEMDEyXSA9
IHsKKwkJLypARC5IZWVyQHB5dGVjLmRlICovCisJCS5uYW1lICAgICAgICAgICA9ICJQSFlURUMg
VkQtMDEyIChidDg3OCkiLAorCQkudmlkZW9faW5wdXRzICAgPSA0LAorCQkuYXVkaW9faW5wdXRz
ICAgPSAwLAorCQkudHVuZXIgICAgICAgICAgPSBVTlNFVCwgLyogY2FyZCBoYXMgbm8gdHVuZXIg
Ki8KKwkJLnN2aHMgICAgICAgICAgID0gVU5TRVQsIC8qIGNhcmQgaGFzIG5vIHN2aHMgKi8KKwkJ
LmdwaW9tYXNrICAgICAgID0gMHgwMCwKKwkJLm11eHNlbCAgICAgICAgID0geyAwLCAyLCAzLCAx
IH0sCisJCS5ncGlvbXV4ICAgICAgICA9IHsgMCwgMCwgMCwgMCB9LCAvKiBjYXJkIGhhcyBubyBh
dWRpbyAqLworCQkubmVlZHNfdHZhdWRpbyAgPSAxLAorCQkucGxsICAgICAgICAgICAgPSBQTExf
MjgsCisJCS50dW5lcl90eXBlICAgICA9IFVOU0VULAorCQkudHVuZXJfYWRkcgk9IEFERFJfVU5T
RVQsCisJCS5yYWRpb19hZGRyICAgICA9IEFERFJfVU5TRVQsCisJfSwJCVtCVFRWX0JPQVJEX1ZE
MDEyX1gxXSA9IHsKKwkJLypARC5IZWVyQHB5dGVjLmRlICovCisJCS5uYW1lICAgICAgICAgICA9
ICJQSFlURUMgVkQtMDEyLVgxIChidDg3OCkiLAorCQkudmlkZW9faW5wdXRzICAgPSA0LAorCQku
YXVkaW9faW5wdXRzICAgPSAwLAorCQkudHVuZXIgICAgICAgICAgPSBVTlNFVCwgLyogY2FyZCBo
YXMgbm8gdHVuZXIgKi8KKwkJLnN2aHMgICAgICAgICAgID0gMywKKwkJLmdwaW9tYXNrICAgICAg
ID0gMHgwMCwKKwkJLm11eHNlbCAgICAgICAgID0geyAyLCAzLCAxIH0sCisJCS5ncGlvbXV4ICAg
ICAgICA9IHsgMCwgMCwgMCwgMCB9LCAvKiBjYXJkIGhhcyBubyBhdWRpbyAqLworCQkubmVlZHNf
dHZhdWRpbyAgPSAxLAorCQkucGxsICAgICAgICAgICAgPSBQTExfMjgsCisJCS50dW5lcl90eXBl
ICAgICA9IFVOU0VULAorCQkudHVuZXJfYWRkcgk9IEFERFJfVU5TRVQsCisJCS5yYWRpb19hZGRy
ICAgICA9IEFERFJfVU5TRVQsCisJfSwJCVtCVFRWX0JPQVJEX1ZEMDEyX1gyXSA9IHsKKwkJLypA
RC5IZWVyQHB5dGVjLmRlICovCisJCS5uYW1lICAgICAgICAgICA9ICJQSFlURUMgVkQtMDEyLVgy
IChidDg3OCkiLAorCQkudmlkZW9faW5wdXRzICAgPSA0LAorCQkuYXVkaW9faW5wdXRzICAgPSAw
LAorCQkudHVuZXIgICAgICAgICAgPSBVTlNFVCwgLyogY2FyZCBoYXMgbm8gdHVuZXIgKi8KKwkJ
LnN2aHMgICAgICAgICAgID0gMywKKwkJLmdwaW9tYXNrICAgICAgID0gMHgwMCwKKwkJLm11eHNl
bCAgICAgICAgID0geyAzLCAyLCAxIH0sCisJCS5ncGlvbXV4ICAgICAgICA9IHsgMCwgMCwgMCwg
MCB9LCAvKiBjYXJkIGhhcyBubyBhdWRpbyAqLworCQkubmVlZHNfdHZhdWRpbyAgPSAxLAorCQku
cGxsICAgICAgICAgICAgPSBQTExfMjgsCisJCS50dW5lcl90eXBlICAgICA9IFVOU0VULAorCQku
dHVuZXJfYWRkcgk9IEFERFJfVU5TRVQsCisJCS5yYWRpb19hZGRyICAgICA9IEFERFJfVU5TRVQs
CisJfSwKIH07CiAKIHN0YXRpYyBjb25zdCB1bnNpZ25lZCBpbnQgYnR0dl9udW1fdHZjYXJkcyA9
IEFSUkFZX1NJWkUoYnR0dl90dmNhcmRzKTsKZGlmZiAtdSAtciBsaW51eC9kcml2ZXJzL21lZGlh
L3ZpZGVvL2J0OHh4L2J0dHYuaCBidHR2X3BhdGNoL2RyaXZlcnMvbWVkaWEvdmlkZW8vYnQ4eHgv
YnR0di5oCi0tLSBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2J0OHh4L2J0dHYuaAkyMDA4LTA0
LTE3IDA0OjQ5OjQ0LjAwMDAwMDAwMCArMDIwMAorKysgYnR0dl9wYXRjaC9kcml2ZXJzL21lZGlh
L3ZpZGVvL2J0OHh4L2J0dHYuaAkyMDA4LTEwLTI3IDEyOjU3OjM2LjAwMDAwMDAwMCArMDEwMApA
QCAtMTczLDcgKzE3MywxMCBAQAogI2RlZmluZSBCVFRWX0JPQVJEX1ZPT0RPT1RWXzIwMAkJICAg
MHg5MwogI2RlZmluZSBCVFRWX0JPQVJEX0RWSUNPX0ZVU0lPTkhEVFZfMgkgICAweDk0CiAjZGVm
aW5lIEJUVFZfQk9BUkRfVFlQSE9PTl9UVlRVTkVSUENJCSAgIDB4OTUKLQorI2RlZmluZSBCVFRW
X0JPQVJEX1ZEMDExX01JTklESU4gICAgICAgICAgIDB4OTYKKyNkZWZpbmUgQlRUVl9CT0FSRF9W
RDAxMgkJICAgMHg5NworI2RlZmluZSBCVFRWX0JPQVJEX1ZEMDEyX1gxCQkgICAweDk4CisjZGVm
aW5lIEJUVFZfQk9BUkRfVkQwMTJfWDIJCSAgIDB4OTkKIAogLyogbW9yZSBjYXJkLXNwZWNpZmlj
IGRlZmluZXMgKi8KICNkZWZpbmUgUFQyMjU0X0xfQ0hBTk5FTCAweDEwCg==

--=_mixed 0045EFACC12574EF_=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=_mixed 0045EFACC12574EF_=--
