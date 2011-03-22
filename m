Return-path: <mchehab@pedra>
Received: from nm15-vm0.bullet.mail.ird.yahoo.com ([77.238.189.216]:28337 "HELO
	nm15-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753341Ab1CVT5x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 15:57:53 -0400
Message-ID: <601699.85761.qm@web29505.mail.ird.yahoo.com>
Date: Tue, 22 Mar 2011 19:57:51 +0000 (GMT)
From: Emil Meier <emil276me@yahoo.com>
Subject: Analog input for Hauppauge express-card HVR-1400
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1641246507-1300823871=:85761"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--0-1641246507-1300823871=:85761
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

In the attached files I have added some code for the analog part of a HVR-1=
400 =0Acard. (The patch is taken from a patch for HVR1800..)=0AUntil now on=
ly the composite video input is functional. =0AThe s-video input captures o=
nly the b&w part of the video.=0AThe patch in cx25840-core.c was needed to =
get PAL support for the video input. =0AIf the line=0Acx25840_write(client,=
 0x2, 0x76);=0Ais needed by other cards, the skipping should depend on the =
card-name... but I =0Adon't know how I can get the card-model in this modul=
e...=0A=0AMaybe this helps someone else in using the analog part of this ca=
rd.=0A=0AEmil=0A=0A=0A      
--0-1641246507-1300823871=:85761
Content-Type: text/x-patch; name="patch-cx23885-cards.c.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch-cx23885-cards.c.diff"

KioqIC4vZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtY2Fy
ZHMuY34JMjAxMS0wMi0xOCAwMDoxNDozOC4wMDAwMDAwMDAgKzAxMDAKLS0t
IC4vZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtY2FyZHMu
YwkyMDExLTAzLTA5IDExOjUzOjA1LjAwMDAwMDAwMCArMDEwMAoqKioqKioq
KioqKioqKioKKioqIDE1NCwxNjAgKioqKgotLS0gMTU0LDE4MyAtLS0tCiAg
CX0sCiAgCVtDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxNDAwXSA9IHsK
ICAJCS5uYW1lCQk9ICJIYXVwcGF1Z2UgV2luVFYtSFZSMTQwMCIsCisgCQku
cG9ydGEgICAgICAgICAgPSBDWDIzODg1X0FOQUxPR19WSURFTywKICAJCS5w
b3J0YwkJPSBDWDIzODg1X01QRUdfRFZCLAorIAkJLnR1bmVyX3R5cGUgICAg
ID0gVFVORVJfWEMyMDI4LAorIAkJLnR1bmVyX2FkZHIgICAgID0gMHg2MSwg
LyogMHg4NCA+PiAxICovCisgCQkuaW5wdXQgICAgICAgICAgPSB7eworIAkJ
ICAgICAudHlwZSAgID0gQ1gyMzg4NV9WTVVYX1RFTEVWSVNJT04sCisgCQkg
ICAgIC52bXV4ICAgPSAgICAgICBDWDI1ODQwX1ZJTjdfQ0gzIHwKKyAJCSAg
ICAgQ1gyNTg0MF9WSU41X0NIMiB8CisgCQkgICAgIENYMjU4NDBfVklOMl9D
SDEsCisgCQkgICAgIC5ncGlvMCAgPSAwLAorIAkJICAgfSwgeworIAkJICAg
ICAudHlwZSAgID0gQ1gyMzg4NV9WTVVYX0NPTVBPU0lURTEsCisgCQkgICAg
IC52bXV4ICAgPSAgICAgICBDWDI1ODQwX1ZJTjdfQ0gzIHwKKyAJCSAgICAg
Q1gyNTg0MF9WSU40X0NIMiB8CisgCQkgICAgIENYMjU4NDBfVklONl9DSDEs
CisgCQkgICAgIC5ncGlvMCAgPSAwLAorIAkJICAgfSwgeworIAkJICAgICAu
dHlwZSAgID0gQ1gyMzg4NV9WTVVYX1NWSURFTywKKyAJCSAgICAgLnZtdXgg
ICA9ICAgICAgIENYMjU4NDBfVklON19DSDMgfAorIAkJICAgICBDWDI1ODQw
X1ZJTjRfQ0gyIHwKKyAJCSAgICAgQ1gyNTg0MF9WSU44X0NIMSB8CisgCQkg
ICAgIENYMjU4NDBfU1ZJREVPX09OLAorIAkJICAgICAuZ3BpbzAgID0gMCwK
KyAJICAgICAgIAkgICB9IH0sCiAgCX0sCiAgCVtDWDIzODg1X0JPQVJEX0RW
SUNPX0ZVU0lPTkhEVFZfN19EVUFMX0VYUF0gPSB7CiAgCQkubmFtZQkJPSAi
RFZpQ08gRnVzaW9uSERUVjcgRHVhbCBFeHByZXNzIiwKKioqKioqKioqKioq
KioqCioqKiAxMjQ1LDEyNTAgKioqKgotLS0gMTI2OCwxMjc0IC0tLS0KICAJ
Y2FzZSBDWDIzODg1X0JPQVJEX01BR0lDUFJPX1BST0hEVFZFMjoKICAJY2Fz
ZSBDWDIzODg1X0JPQVJEX0hBVVBQQVVHRV9IVlIxMjkwOgogIAljYXNlIENY
MjM4ODVfQk9BUkRfTEVBRFRFS19XSU5GQVNUX1BYVFYxMjAwOgorIAljYXNl
IENYMjM4ODVfQk9BUkRfSEFVUFBBVUdFX0hWUjE0MDA6CiAgCQlkZXYtPnNk
X2N4MjU4NDAgPSB2NGwyX2kyY19uZXdfc3ViZGV2KCZkZXYtPnY0bDJfZGV2
LAogIAkJCQkmZGV2LT5pMmNfYnVzWzJdLmkyY19hZGFwLAogIAkJCQkiY3gy
NTg0MCIsICJjeDI1ODQwIiwgMHg4OCA+PiAxLCBOVUxMKTsK

--0-1641246507-1300823871=:85761
Content-Type: text/x-patch; name="patch-cx25840-core.c.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch-cx25840-core.c.diff"

KioqIC4vZHJpdmVycy9tZWRpYS92aWRlby9jeDI1ODQwL2N4MjU4NDAtY29y
ZS5jfgkyMDExLTAyLTE4IDAwOjE0OjM4LjAwMDAwMDAwMCArMDEwMAotLS0g
Li9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjU4NDAvY3gyNTg0MC1jb3JlLmMJ
MjAxMS0wMy0wOSAxMTo1NDoyNC4wMDAwMDAwMDAgKzAxMDAKKioqKioqKioq
KioqKioqCioqKiA2NTQsNjYwICoqKioKICAKICAJLyogVHJ1c3QgdGhlIGRl
ZmF1bHQgeHRhbCwgbm8gZGl2aXNpb24gKi8KICAJLyogVGhpcyBjaGFuZ2Vz
IGZvciB0aGUgY3gyMzg4OCBwcm9kdWN0cyAqLwohIAljeDI1ODQwX3dyaXRl
KGNsaWVudCwgMHgyLCAweDc2KTsKICAKICAJLyogQnJpbmcgZG93biB0aGUg
cmVndWxhdG9yIGZvciBBVVggY2xrICovCiAgCWN4MjU4NDBfd3JpdGUoY2xp
ZW50LCAweDEsIDB4NDApOwotLS0gNjU0LDY2MSAtLS0tCiAgCiAgCS8qIFRy
dXN0IHRoZSBkZWZhdWx0IHh0YWwsIG5vIGRpdmlzaW9uICovCiAgCS8qIFRo
aXMgY2hhbmdlcyBmb3IgdGhlIGN4MjM4ODggcHJvZHVjdHMgKi8KISAJLy8g
bm90IGZvciBodnIxNDAwIGVtIDA5MDgxOAohIAkvL2N4MjU4NDBfd3JpdGUo
Y2xpZW50LCAweDIsIDB4NzYpOwogIAogIAkvKiBCcmluZyBkb3duIHRoZSBy
ZWd1bGF0b3IgZm9yIEFVWCBjbGsgKi8KICAJY3gyNTg0MF93cml0ZShjbGll
bnQsIDB4MSwgMHg0MCk7Cg==

--0-1641246507-1300823871=:85761--
