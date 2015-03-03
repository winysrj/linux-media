Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34115 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbbCCBiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 20:38:05 -0500
Received: by pdjg10 with SMTP id g10so44191633pdj.1
        for <linux-media@vger.kernel.org>; Mon, 02 Mar 2015 17:38:04 -0800 (PST)
Message-ID: <54F51078.5030507@gmail.com>
Date: Mon, 02 Mar 2015 17:38:00 -0800
From: Mack Stanley <mcs1937@gmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	John Klug <ski.brimson@gmail.com>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: PCTV 800i
References: <CADU0VqyzEdG=07O=9LufbZAYa0BVzgUbcBeVzUnfH+Mpup5=Fw@mail.gmail.com>	<CALzAhNVD3od1WSyi98icqhy4WveoutAoTJzqVV6g4yw+tMAEMg@mail.gmail.com>	<CADU0Vqxaa8XP+0j+Y5JqGuRRK8=avjQ_N_F2VoXQV1ZF=3PxmA@mail.gmail.com>	<CALzAhNViOw8EY=_WzEa7r92HGgDs1J9GvHcgQrun82GYXjNKpw@mail.gmail.com> <CALzAhNXv3Czx=2VXpQzdudau4iJXk1cseHN9cBRfgtm=55AjXQ@mail.gmail.com>
In-Reply-To: <CALzAhNXv3Czx=2VXpQzdudau4iJXk1cseHN9cBRfgtm=55AjXQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070407000802060602050207"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070407000802060602050207
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 01/27/2015 05:48 AM, Steven Toth wrote:
>> John replied off list:
>>
>> "http://linux-media.vger.kernel.narkive.com/kAviSkda/chipset-change-for-cx88-board-pinnacle-pctv-hd-800i
>>
>> Wonder if any code was ever integrated?"
>>
>> It looks like basics of a patch was developed to support the card but
>> it was incompatible with the existing cards and nobody took the time
>> to understand how to differentiate between the older 800i and the
>> newer 800i. So, the problem fell on the floor.
>>
>> I'll look through my card library. If I have an old _AND_ new rev then
>> I'll find an hour and see if I can find an acceptable solution.
>>
>> Summary: PCTV released a new 800i (quite a while ago) changing the
>> demodulator, which is why the existing driver doesn't work.
> 
> I have a pair of 800i's with the S5H1409 demodulator, probably from
> when I did the original 800i support (2008):
> http://marc.info/?l=linux-dvb&m=120032380226094&w=2
> 
> I don't have a 800i with a s5h1411, so I can't really help without it.
> 
Dear John and Steven,

Back in 2012 I twice submitted a patch that got my pctv 800i with an s5h1411 working.  Both times 
either my email or something along the way wrapped lines and spoiled the patch for testing.  I've 
patched several kernels since then, but not any very recently.  I just checked and that machine is running
Fedora 3.14.4-200.fc20.x86_64.  

I've attached what I believe is the patch I made then.  Since then, I've just edited the v4l source 
whenever and built a modified module whenever I upgraded.  I put instructions on fedora forum back
then: http://forums.fedoraforum.org/showthread.php?t=281161

I hope this helps.

Best, Mack Stanley


--------------070407000802060602050207
Content-Type: text/x-patch;
 name="pctv800i.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pctv800i.patch"

=46rom 5d4733b79360d414eea38085abc397cd3b8131e7 Mon Sep 17 00:00:00 2001
From: Mack Stanley <mcs1937@gmail.com>
Date: Thu, 28 Jun 2012 13:50:33 -0700
Subject: [PATCH 1/1] Add support for newer PCTC HD TV 800i cards with
 S5H1411 demodulators
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>

Testing needed on older (Pinnacle) PCTV 800i cards with S5H1409 demodulat=
ors
to check that current support for them isn't broken by this patch.

Signed-off-by: Mack Stanley <mcs1937@gmail.com>
---
 drivers/media/video/cx88/cx88-dvb.c |   40 ++++++++++++++++++++++++-----=
-----
 1 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx=
88/cx88-dvb.c
index 003937c..6d49672 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -501,7 +501,7 @@ static const struct cx24123_config kworld_dvbs_100_co=
nfig =3D {
 	.lnb_polarity  =3D 1,
 };
=20
-static const struct s5h1409_config pinnacle_pctv_hd_800i_config =3D {
+static const struct s5h1409_config pinnacle_pctv_hd_800i_s5h1409_config =
=3D {
 	.demod_address =3D 0x32 >> 1,
 	.output_mode   =3D S5H1409_PARALLEL_OUTPUT,
 	.gpio	       =3D S5H1409_GPIO_ON,
@@ -509,7 +509,7 @@ static const struct s5h1409_config pinnacle_pctv_hd_8=
00i_config =3D {
 	.inversion     =3D S5H1409_INVERSION_OFF,
 	.status_mode   =3D S5H1409_DEMODLOCKING,
 	.mpeg_timing   =3D S5H1409_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
-};
+};=20
=20
 static const struct s5h1409_config dvico_hdtv5_pci_nano_config =3D {
 	.demod_address =3D 0x32 >> 1,
@@ -556,6 +556,16 @@ static const struct s5h1411_config dvico_fusionhdtv7=
_config =3D {
 	.status_mode   =3D S5H1411_DEMODLOCKING
 };
=20
+static const struct s5h1411_config pinnacle_pctv_hd_800i_s5h1411_config =
=3D {
+  	.output_mode   =3D S5H1411_PARALLEL_OUTPUT,
+  	.gpio          =3D S5H1411_GPIO_ON,
+  	.mpeg_timing   =3D S5H1411_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK=
,
+  	.qam_if        =3D S5H1411_IF_44000,
+  	.vsb_if        =3D S5H1411_IF_44000,
+  	.inversion     =3D S5H1411_INVERSION_OFF,
+  	.status_mode   =3D S5H1411_DEMODLOCKING
+};
+
 static const struct xc5000_config dvico_fusionhdtv7_tuner_config =3D {
 	.i2c_address    =3D 0xc2 >> 1,
 	.if_khz         =3D 5380,
@@ -1297,16 +1307,22 @@ static int dvb_register(struct cx8802_dev *dev)
 		}
 		break;
 	case CX88_BOARD_PINNACLE_PCTV_HD_800i:
-		fe0->dvb.frontend =3D dvb_attach(s5h1409_attach,
-					       &pinnacle_pctv_hd_800i_config,
-					       &core->i2c_adap);
-		if (fe0->dvb.frontend !=3D NULL) {
-			if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
-					&core->i2c_adap,
-					&pinnacle_pctv_hd_800i_tuner_config))
-				goto frontend_detach;
-		}
-		break;
+	  	/* Try s5h1409 chip first */
+	  	fe0->dvb.frontend =3D dvb_attach(s5h1409_attach, =20
+					&pinnacle_pctv_hd_800i_s5h1409_config,
+   					&core->i2c_adap);
+	  	/* Otherwise, try s5h1411 */
+	  	if (fe0->dvb.frontend =3D=3D NULL)=20
+	    		fe0->dvb.frontend =3D dvb_attach(s5h1411_attach,
+					&pinnacle_pctv_hd_800i_s5h1411_config,
+					&core->i2c_adap);
+	  	if (fe0->dvb.frontend !=3D NULL) {
+	    		if (!dvb_attach(xc5000_attach, fe0->dvb.frontend,
+					&core->i2c_adap,
+			    		&pinnacle_pctv_hd_800i_tuner_config))
+	      			goto frontend_detach;
+	  	}
+	  	break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO:
 		fe0->dvb.frontend =3D dvb_attach(s5h1409_attach,
 						&dvico_hdtv5_pci_nano_config,
--=20
1.7.7.6


--------------070407000802060602050207--
