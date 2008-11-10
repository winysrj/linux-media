Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAA8u8Ai028132
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 03:56:08 -0500
Received: from root.phytec.de (mail.tricorecenter.de [217.6.246.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAA8tceP029634
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 03:55:38 -0500
Received: from idefix.phytec.de (idefix.phytec.de [172.16.0.10])
	by root.phytec.de (Postfix) with ESMTP id 33CE7BF0CA
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 09:31:32 +0100 (CET)
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <OF45DBB1DF.D820068E-ONC12574FD.002E8F63-C12574FD.00310D0D@phytec.de>
From: Dirk Heer <D.Heer@phytec.de>
Date: Mon, 10 Nov 2008 09:55:37 +0100
Content-Type: multipart/mixed; boundary="=_mixed 00310D0AC12574FD_="
Subject: [PATCH] bttv
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

--=_mixed 00310D0AC12574FD_=
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

hear i have a patch for v4l.=20
I hope someone can put them into the Kernel.


***************************************************************************=
***********************************************************


From:
Dirk Heer
Phytec Messtechnik GmbH
Email: d.heer@phytec.de
http://www.phytec.de

This Patch does modify the bttv-cards.c and bttc.h so that the driver=20
supports VD-011, VD-012, VD-012-X1 and VD-012-X2 Framegrabber from Phytec=20
Messtechnik GmbH.

Priority: normal

Signed-off-by: Dirk Heer <d.heer@phytec.de>

diff -u -r=20
v4l-dvb-8486cbf6af4e/linux/drivers/media/video/bt8xx/bttv-cards.c=20
v4l-dvb-8486cbf6af4e=5Fpatched//linux/drivers/media/video/bt8xx/bttv-cards.c
--- v4l-dvb-8486cbf6af4e/linux/drivers/media/video/bt8xx/bttv-cards.c=20
2008-10-27 00:25:21.000000000 +0100
+++=20
v4l-dvb-8486cbf6af4e=5Fpatched//linux/drivers/media/video/bt8xx/bttv-cards.=
c=20
2008-10-28 13:09:15.000000000 +0100
@@ -2240,9 +2240,9 @@
                .tuner=5Faddr     =3D ADDR=5FUNSET,
                .radio=5Faddr     =3D ADDR=5FUNSET,
        },
-       [BTTV=5FBOARD=5FVD009X1=5FMINIDIN] =3D {
+       [BTTV=5FBOARD=5FVD009X1=5FVD011=5FMINIDIN] =3D {
                /* M.Klahr@phytec.de */
-               .name           =3D "PHYTEC VD-009-X1 MiniDIN (bt878)",
+               .name           =3D "PHYTEC VD-009-X1 VD-011 MiniDIN=20
(bt878)",
                .video=5Finputs   =3D 4,
                .audio=5Finputs   =3D 0,
                .tuner          =3D UNSET, /* card has no tuner */
@@ -2250,14 +2250,14 @@
                .gpiomask       =3D 0x00,
                .muxsel         =3D { 2, 3, 1, 0 },
                .gpiomux        =3D { 0, 0, 0, 0 }, /* card has no audio */
-               .needs=5Ftvaudio  =3D 1,
+               .needs=5Ftvaudio  =3D 0,
                .pll            =3D PLL=5F28,
                .tuner=5Ftype     =3D UNSET,
                .tuner=5Faddr     =3D ADDR=5FUNSET,
                .radio=5Faddr     =3D ADDR=5FUNSET,
        },
-       [BTTV=5FBOARD=5FVD009X1=5FCOMBI] =3D {
-               .name           =3D "PHYTEC VD-009-X1 Combi (bt878)",
+       [BTTV=5FBOARD=5FVD009X1=5FVD011=5FCOMBI] =3D {
+               .name           =3D "PHYTEC VD-009-X1 VD-011 Combi (bt878)",
                .video=5Finputs   =3D 4,
                .audio=5Finputs   =3D 0,
                .tuner          =3D UNSET, /* card has no tuner */
@@ -2265,7 +2265,7 @@
                .gpiomask       =3D 0x00,
                .muxsel         =3D { 2, 3, 1, 1 },
                .gpiomux        =3D { 0, 0, 0, 0 }, /* card has no audio */
-               .needs=5Ftvaudio  =3D 1,
+               .needs=5Ftvaudio  =3D 0,
                .pll            =3D PLL=5F28,
                .tuner=5Ftype     =3D UNSET,
                .tuner=5Faddr     =3D ADDR=5FUNSET,
@@ -3093,6 +3093,54 @@
                .pll            =3D PLL=5F28,
                .has=5Fradio      =3D 1,
                .has=5Fremote     =3D 1,
+       },
+               [BTTV=5FBOARD=5FVD012] =3D {
+               /* D.Heer@Phytec.de */
+               .name           =3D "PHYTEC VD-012 (bt878)",
+               .video=5Finputs   =3D 4,
+               .audio=5Finputs   =3D 0,
+               .tuner          =3D UNSET, /* card has no tuner */
+               .svhs           =3D UNSET, /* card has no s-video */
+               .gpiomask       =3D 0x00,
+               .muxsel         =3D { 0, 2, 3, 1 },
+               .gpiomux        =3D { 0, 0, 0, 0 }, /* card has no audio */
+               .needs=5Ftvaudio  =3D 0,
+               .pll            =3D PLL=5F28,
+               .tuner=5Ftype     =3D UNSET,
+               .tuner=5Faddr     =3D ADDR=5FUNSET,
+               .radio=5Faddr     =3D ADDR=5FUNSET,
+       },
+               [BTTV=5FBOARD=5FVD012=5FX1] =3D {
+               /* D.Heer@Phytec.de */
+               .name           =3D "PHYTEC VD-012-X1 (bt878)",
+               .video=5Finputs   =3D 4,
+               .audio=5Finputs   =3D 0,
+               .tuner          =3D UNSET, /* card has no tuner */
+               .svhs           =3D 3,
+               .gpiomask       =3D 0x00,
+               .muxsel         =3D { 2, 3, 1 },
+               .gpiomux        =3D { 0, 0, 0, 0 }, /* card has no audio */
+               .needs=5Ftvaudio  =3D 0,
+               .pll            =3D PLL=5F28,
+               .tuner=5Ftype     =3D UNSET,
+               .tuner=5Faddr     =3D ADDR=5FUNSET,
+               .radio=5Faddr     =3D ADDR=5FUNSET,
+       },
+               [BTTV=5FBOARD=5FVD012=5FX2] =3D {
+               /* D.Heer@Phytec.de */
+               .name           =3D "PHYTEC VD-012-X2 (bt878)",
+               .video=5Finputs   =3D 4,
+               .audio=5Finputs   =3D 0,
+               .tuner          =3D UNSET, /* card has no tuner */
+               .svhs           =3D 3,
+               .gpiomask       =3D 0x00,
+               .muxsel         =3D { 3, 2, 1 },
+               .gpiomux        =3D { 0, 0, 0, 0 }, /* card has no audio */
+               .needs=5Ftvaudio  =3D 0,
+               .pll            =3D PLL=5F28,
+               .tuner=5Ftype     =3D UNSET,
+               .tuner=5Faddr     =3D ADDR=5FUNSET,
+               .radio=5Faddr     =3D ADDR=5FUNSET,
        }
 };
=20
diff -u -r v4l-dvb-8486cbf6af4e/linux/drivers/media/video/bt8xx/bttv.h=20
v4l-dvb-8486cbf6af4e=5Fpatched//linux/drivers/media/video/bt8xx/bttv.h
--- v4l-dvb-8486cbf6af4e/linux/drivers/media/video/bt8xx/bttv.h 2008-10-27 =

00:25:21.000000000 +0100
+++ v4l-dvb-8486cbf6af4e=5Fpatched//linux/drivers/media/video/bt8xx/bttv.h =

2008-10-28 12:35:44.000000000 +0100
@@ -131,8 +131,8 @@
 #define BTTV=5FBOARD=5FXGUARD                  0x67
 #define BTTV=5FBOARD=5FNEBULA=5FDIGITV           0x68
 #define BTTV=5FBOARD=5FPV143                   0x69
-#define BTTV=5FBOARD=5FVD009X1=5FMINIDIN         0x6a
-#define BTTV=5FBOARD=5FVD009X1=5FCOMBI           0x6b
+#define BTTV=5FBOARD=5FVD009X1=5FVD011=5FMINIDIN   0x6a
+#define BTTV=5FBOARD=5FVD009X1=5FVD011=5FCOMBI     0x6b
 #define BTTV=5FBOARD=5FVD009=5FMINIDIN           0x6c
 #define BTTV=5FBOARD=5FVD009=5FCOMBI             0x6d
 #define BTTV=5FBOARD=5FIVC100                  0x6e
@@ -178,6 +178,10 @@
 #define BTTV=5FBOARD=5FGEOVISION=5FGV600        0x96
 #define BTTV=5FBOARD=5FKOZUMI=5FKTV=5F01C          0x97
 #define BTTV=5FBOARD=5FENLTV=5FFM=5F2             0x98
+#define BTTV=5FBOARD=5FVD012                  0x99
+#define BTTV=5FBOARD=5FVD012=5FX1               0x9a
+#define BTTV=5FBOARD=5FVD012=5FX2               0x9b
+
=20
 /* more card-specific defines */
 #define PT2254=5FL=5FCHANNEL 0x10
Nur in v4l-dvb-8486cbf6af4e=5Fpatched/: phytec=5Fbttv=5Fpatch.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: .config.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: Kconfig.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: .kconfig.dep.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: Kconfig.kern.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: Makefile.media.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: modules.order.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: .myconfig.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: oss.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: .tmp=5Fversions.
Nur in v4l-dvb-8486cbf6af4e=5Fpatched//v4l: .version.




***************************************************************************=
***********************************************************






Yours faithfully / Mit freundlichen Gr=FC=DFen

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


--=_mixed 00310D0AC12574FD_=
Content-Type: application/octet-stream; name="phytec_bttv_patch"
Content-Disposition: attachment; filename="phytec_bttv_patch"
Content-Transfer-Encoding: base64

CkZyb206CkRpcmsgSGVlcgpQaHl0ZWMgTWVzc3RlY2huaWsgR21iSApFbWFpbDogZC5oZWVyQHBo
eXRlYy5kZQpodHRwOi8vd3d3LnBoeXRlYy5kZQoKVGhpcyBQYXRjaCBkb2VzIG1vZGlmeSB0aGUg
YnR0di1jYXJkcy5jIGFuZCBidHRjLmggc28gdGhhdCB0aGUgZHJpdmVyIHN1cHBvcnRzIFZELTAx
MSwgVkQtMDEyLCBWRC0wMTItWDEgYW5kIFZELTAxMi1YMiBGcmFtZWdyYWJiZXIgZnJvbSBQaHl0
ZWMgTWVzc3RlY2huaWsgR21iSC4KClByaW9yaXR5OiBub3JtYWwKClNpZ25lZC1vZmYtYnk6IERp
cmsgSGVlciA8ZC5oZWVyQHBoeXRlYy5kZT4KCmRpZmYgLXUgLXIgdjRsLWR2Yi04NDg2Y2JmNmFm
NGUvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDh4eC9idHR2LWNhcmRzLmMgdjRsLWR2Yi04
NDg2Y2JmNmFmNGVfcGF0Y2hlZC8vbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDh4eC9idHR2
LWNhcmRzLmMKLS0tIHY0bC1kdmItODQ4NmNiZjZhZjRlL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlk
ZW8vYnQ4eHgvYnR0di1jYXJkcy5jCTIwMDgtMTAtMjcgMDA6MjU6MjEuMDAwMDAwMDAwICswMTAw
CisrKyB2NGwtZHZiLTg0ODZjYmY2YWY0ZV9wYXRjaGVkLy9saW51eC9kcml2ZXJzL21lZGlhL3Zp
ZGVvL2J0OHh4L2J0dHYtY2FyZHMuYwkyMDA4LTEwLTI4IDEzOjA5OjE1LjAwMDAwMDAwMCArMDEw
MApAQCAtMjI0MCw5ICsyMjQwLDkgQEAKIAkJLnR1bmVyX2FkZHIJPSBBRERSX1VOU0VULAogCQku
cmFkaW9fYWRkciAgICAgPSBBRERSX1VOU0VULAogCX0sCi0JW0JUVFZfQk9BUkRfVkQwMDlYMV9N
SU5JRElOXSA9IHsKKwlbQlRUVl9CT0FSRF9WRDAwOVgxX1ZEMDExX01JTklESU5dID0gewogCQkv
KiBNLktsYWhyQHBoeXRlYy5kZSAqLwotCQkubmFtZSAgICAgICAgICAgPSAiUEhZVEVDIFZELTAw
OS1YMSBNaW5pRElOIChidDg3OCkiLAorCQkubmFtZSAgICAgICAgICAgPSAiUEhZVEVDIFZELTAw
OS1YMSBWRC0wMTEgTWluaURJTiAoYnQ4NzgpIiwKIAkJLnZpZGVvX2lucHV0cyAgID0gNCwKIAkJ
LmF1ZGlvX2lucHV0cyAgID0gMCwKIAkJLnR1bmVyICAgICAgICAgID0gVU5TRVQsIC8qIGNhcmQg
aGFzIG5vIHR1bmVyICovCkBAIC0yMjUwLDE0ICsyMjUwLDE0IEBACiAJCS5ncGlvbWFzayAgICAg
ICA9IDB4MDAsCiAJCS5tdXhzZWwgICAgICAgICA9IHsgMiwgMywgMSwgMCB9LAogCQkuZ3Bpb211
eCAgICAgICAgPSB7IDAsIDAsIDAsIDAgfSwgLyogY2FyZCBoYXMgbm8gYXVkaW8gKi8KLQkJLm5l
ZWRzX3R2YXVkaW8gID0gMSwKKwkJLm5lZWRzX3R2YXVkaW8gID0gMCwKIAkJLnBsbCAgICAgICAg
ICAgID0gUExMXzI4LAogCQkudHVuZXJfdHlwZSAgICAgPSBVTlNFVCwKIAkJLnR1bmVyX2FkZHIJ
PSBBRERSX1VOU0VULAogCQkucmFkaW9fYWRkciAgICAgPSBBRERSX1VOU0VULAogCX0sCi0JW0JU
VFZfQk9BUkRfVkQwMDlYMV9DT01CSV0gPSB7Ci0JCS5uYW1lICAgICAgICAgICA9ICJQSFlURUMg
VkQtMDA5LVgxIENvbWJpIChidDg3OCkiLAorCVtCVFRWX0JPQVJEX1ZEMDA5WDFfVkQwMTFfQ09N
QkldID0geworCQkubmFtZSAgICAgICAgICAgPSAiUEhZVEVDIFZELTAwOS1YMSBWRC0wMTEgQ29t
YmkgKGJ0ODc4KSIsCiAJCS52aWRlb19pbnB1dHMgICA9IDQsCiAJCS5hdWRpb19pbnB1dHMgICA9
IDAsCiAJCS50dW5lciAgICAgICAgICA9IFVOU0VULCAvKiBjYXJkIGhhcyBubyB0dW5lciAqLwpA
QCAtMjI2NSw3ICsyMjY1LDcgQEAKIAkJLmdwaW9tYXNrICAgICAgID0gMHgwMCwKIAkJLm11eHNl
bCAgICAgICAgID0geyAyLCAzLCAxLCAxIH0sCiAJCS5ncGlvbXV4ICAgICAgICA9IHsgMCwgMCwg
MCwgMCB9LCAvKiBjYXJkIGhhcyBubyBhdWRpbyAqLwotCQkubmVlZHNfdHZhdWRpbyAgPSAxLAor
CQkubmVlZHNfdHZhdWRpbyAgPSAwLAogCQkucGxsICAgICAgICAgICAgPSBQTExfMjgsCiAJCS50
dW5lcl90eXBlICAgICA9IFVOU0VULAogCQkudHVuZXJfYWRkcgk9IEFERFJfVU5TRVQsCkBAIC0z
MDkzLDYgKzMwOTMsNTQgQEAKIAkJLnBsbCAgICAgICAgICAgID0gUExMXzI4LAogCQkuaGFzX3Jh
ZGlvICAgICAgPSAxLAogCQkuaGFzX3JlbW90ZSAgICAgPSAxLAorCX0sCisJCVtCVFRWX0JPQVJE
X1ZEMDEyXSA9IHsKKwkJLyogRC5IZWVyQFBoeXRlYy5kZSAqLworCQkubmFtZSAgICAgICAgICAg
PSAiUEhZVEVDIFZELTAxMiAoYnQ4NzgpIiwKKwkJLnZpZGVvX2lucHV0cyAgID0gNCwKKwkJLmF1
ZGlvX2lucHV0cyAgID0gMCwKKwkJLnR1bmVyICAgICAgICAgID0gVU5TRVQsIC8qIGNhcmQgaGFz
IG5vIHR1bmVyICovCisJCS5zdmhzICAgICAgICAgICA9IFVOU0VULCAvKiBjYXJkIGhhcyBubyBz
LXZpZGVvICovCisJCS5ncGlvbWFzayAgICAgICA9IDB4MDAsCisJCS5tdXhzZWwgICAgICAgICA9
IHsgMCwgMiwgMywgMSB9LAorCQkuZ3Bpb211eCAgICAgICAgPSB7IDAsIDAsIDAsIDAgfSwgLyog
Y2FyZCBoYXMgbm8gYXVkaW8gKi8KKwkJLm5lZWRzX3R2YXVkaW8gID0gMCwKKwkJLnBsbCAgICAg
ICAgICAgID0gUExMXzI4LAorCQkudHVuZXJfdHlwZSAgICAgPSBVTlNFVCwKKwkJLnR1bmVyX2Fk
ZHIJPSBBRERSX1VOU0VULAorCQkucmFkaW9fYWRkciAgICAgPSBBRERSX1VOU0VULAorCX0sCisJ
CVtCVFRWX0JPQVJEX1ZEMDEyX1gxXSA9IHsKKwkJLyogRC5IZWVyQFBoeXRlYy5kZSAqLworCQku
bmFtZSAgICAgICAgICAgPSAiUEhZVEVDIFZELTAxMi1YMSAoYnQ4NzgpIiwKKwkJLnZpZGVvX2lu
cHV0cyAgID0gNCwKKwkJLmF1ZGlvX2lucHV0cyAgID0gMCwKKwkJLnR1bmVyICAgICAgICAgID0g
VU5TRVQsIC8qIGNhcmQgaGFzIG5vIHR1bmVyICovCisJCS5zdmhzICAgICAgICAgICA9IDMsCisJ
CS5ncGlvbWFzayAgICAgICA9IDB4MDAsCisJCS5tdXhzZWwgICAgICAgICA9IHsgMiwgMywgMSB9
LAorCQkuZ3Bpb211eCAgICAgICAgPSB7IDAsIDAsIDAsIDAgfSwgLyogY2FyZCBoYXMgbm8gYXVk
aW8gKi8KKwkJLm5lZWRzX3R2YXVkaW8gID0gMCwKKwkJLnBsbCAgICAgICAgICAgID0gUExMXzI4
LAorCQkudHVuZXJfdHlwZSAgICAgPSBVTlNFVCwKKwkJLnR1bmVyX2FkZHIJPSBBRERSX1VOU0VU
LAorCQkucmFkaW9fYWRkciAgICAgPSBBRERSX1VOU0VULAorCX0sCisJCVtCVFRWX0JPQVJEX1ZE
MDEyX1gyXSA9IHsKKwkJLyogRC5IZWVyQFBoeXRlYy5kZSAqLworCQkubmFtZSAgICAgICAgICAg
PSAiUEhZVEVDIFZELTAxMi1YMiAoYnQ4NzgpIiwKKwkJLnZpZGVvX2lucHV0cyAgID0gNCwKKwkJ
LmF1ZGlvX2lucHV0cyAgID0gMCwKKwkJLnR1bmVyICAgICAgICAgID0gVU5TRVQsIC8qIGNhcmQg
aGFzIG5vIHR1bmVyICovCisJCS5zdmhzICAgICAgICAgICA9IDMsCisJCS5ncGlvbWFzayAgICAg
ICA9IDB4MDAsCisJCS5tdXhzZWwgICAgICAgICA9IHsgMywgMiwgMSB9LAorCQkuZ3Bpb211eCAg
ICAgICAgPSB7IDAsIDAsIDAsIDAgfSwgLyogY2FyZCBoYXMgbm8gYXVkaW8gKi8KKwkJLm5lZWRz
X3R2YXVkaW8gID0gMCwKKwkJLnBsbCAgICAgICAgICAgID0gUExMXzI4LAorCQkudHVuZXJfdHlw
ZSAgICAgPSBVTlNFVCwKKwkJLnR1bmVyX2FkZHIJPSBBRERSX1VOU0VULAorCQkucmFkaW9fYWRk
ciAgICAgPSBBRERSX1VOU0VULAogCX0KIH07CiAKZGlmZiAtdSAtciB2NGwtZHZiLTg0ODZjYmY2
YWY0ZS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2J0OHh4L2J0dHYuaCB2NGwtZHZiLTg0ODZj
YmY2YWY0ZV9wYXRjaGVkLy9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2J0OHh4L2J0dHYuaAot
LS0gdjRsLWR2Yi04NDg2Y2JmNmFmNGUvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDh4eC9i
dHR2LmgJMjAwOC0xMC0yNyAwMDoyNToyMS4wMDAwMDAwMDAgKzAxMDAKKysrIHY0bC1kdmItODQ4
NmNiZjZhZjRlX3BhdGNoZWQvL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vYnQ4eHgvYnR0di5o
CTIwMDgtMTAtMjggMTI6MzU6NDQuMDAwMDAwMDAwICswMTAwCkBAIC0xMzEsOCArMTMxLDggQEAK
ICNkZWZpbmUgQlRUVl9CT0FSRF9YR1VBUkQgICAgICAgICAgICAgICAgICAweDY3CiAjZGVmaW5l
IEJUVFZfQk9BUkRfTkVCVUxBX0RJR0lUViAgICAgICAgICAgMHg2OAogI2RlZmluZSBCVFRWX0JP
QVJEX1BWMTQzICAgICAgICAgICAgICAgICAgIDB4NjkKLSNkZWZpbmUgQlRUVl9CT0FSRF9WRDAw
OVgxX01JTklESU4gICAgICAgICAweDZhCi0jZGVmaW5lIEJUVFZfQk9BUkRfVkQwMDlYMV9DT01C
SSAgICAgICAgICAgMHg2YgorI2RlZmluZSBCVFRWX0JPQVJEX1ZEMDA5WDFfVkQwMTFfTUlOSURJ
TiAgIDB4NmEKKyNkZWZpbmUgQlRUVl9CT0FSRF9WRDAwOVgxX1ZEMDExX0NPTUJJICAgICAweDZi
CiAjZGVmaW5lIEJUVFZfQk9BUkRfVkQwMDlfTUlOSURJTiAgICAgICAgICAgMHg2YwogI2RlZmlu
ZSBCVFRWX0JPQVJEX1ZEMDA5X0NPTUJJICAgICAgICAgICAgIDB4NmQKICNkZWZpbmUgQlRUVl9C
T0FSRF9JVkMxMDAgICAgICAgICAgICAgICAgICAweDZlCkBAIC0xNzgsNiArMTc4LDEwIEBACiAj
ZGVmaW5lIEJUVFZfQk9BUkRfR0VPVklTSU9OX0dWNjAwCSAgIDB4OTYKICNkZWZpbmUgQlRUVl9C
T0FSRF9LT1pVTUlfS1RWXzAxQyAgICAgICAgICAweDk3CiAjZGVmaW5lIEJUVFZfQk9BUkRfRU5M
VFZfRk1fMgkJICAgMHg5OAorI2RlZmluZSBCVFRWX0JPQVJEX1ZEMDEyCQkgICAweDk5CisjZGVm
aW5lIEJUVFZfQk9BUkRfVkQwMTJfWDEJCSAgIDB4OWEKKyNkZWZpbmUgQlRUVl9CT0FSRF9WRDAx
Ml9YMgkJICAgMHg5YgorCiAKIC8qIG1vcmUgY2FyZC1zcGVjaWZpYyBkZWZpbmVzICovCiAjZGVm
aW5lIFBUMjI1NF9MX0NIQU5ORUwgMHgxMApOdXIgaW4gdjRsLWR2Yi04NDg2Y2JmNmFmNGVfcGF0
Y2hlZC86IHBoeXRlY19idHR2X3BhdGNoLgpOdXIgaW4gdjRsLWR2Yi04NDg2Y2JmNmFmNGVfcGF0
Y2hlZC8vdjRsOiAuY29uZmlnLgpOdXIgaW4gdjRsLWR2Yi04NDg2Y2JmNmFmNGVfcGF0Y2hlZC8v
djRsOiBLY29uZmlnLgpOdXIgaW4gdjRsLWR2Yi04NDg2Y2JmNmFmNGVfcGF0Y2hlZC8vdjRsOiAu
a2NvbmZpZy5kZXAuCk51ciBpbiB2NGwtZHZiLTg0ODZjYmY2YWY0ZV9wYXRjaGVkLy92NGw6IEtj
b25maWcua2Vybi4KTnVyIGluIHY0bC1kdmItODQ4NmNiZjZhZjRlX3BhdGNoZWQvL3Y0bDogTWFr
ZWZpbGUubWVkaWEuCk51ciBpbiB2NGwtZHZiLTg0ODZjYmY2YWY0ZV9wYXRjaGVkLy92NGw6IG1v
ZHVsZXMub3JkZXIuCk51ciBpbiB2NGwtZHZiLTg0ODZjYmY2YWY0ZV9wYXRjaGVkLy92NGw6IC5t
eWNvbmZpZy4KTnVyIGluIHY0bC1kdmItODQ4NmNiZjZhZjRlX3BhdGNoZWQvL3Y0bDogb3NzLgpO
dXIgaW4gdjRsLWR2Yi04NDg2Y2JmNmFmNGVfcGF0Y2hlZC8vdjRsOiAudG1wX3ZlcnNpb25zLgpO
dXIgaW4gdjRsLWR2Yi04NDg2Y2JmNmFmNGVfcGF0Y2hlZC8vdjRsOiAudmVyc2lvbi4K

--=_mixed 00310D0AC12574FD_=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=_mixed 00310D0AC12574FD_=--
