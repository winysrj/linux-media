Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]:52645 "EHLO
	ctsmtpout1.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753423AbZHDLSf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Aug 2009 07:18:35 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Cyril Hansen <cyril.hansen@gmail.com>
Subject: Re: Noisy video with Avermedia AVerTV Digi Volar X HD (AF9015) and mythbuntu 9.04
Date: Tue, 4 Aug 2009 13:12:52 +0200
Cc: linux-media@vger.kernel.org
References: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com>
In-Reply-To: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0eBeKZ3jJuIWZYg"
Message-Id: <200908041312.52878.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_0eBeKZ3jJuIWZYg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

El Martes, 4 de Agosto de 2009, Cyril Hansen escribi=F3:
> Hi all,
>
> I am trying to solve a noisy video issue with my new avermedia stick
> (AF9015). I am receiving french DVB signal, both SD and HD. Viewing SD
> is annoying, with the occasional video and audio quirk, and HD is
> almost unwatchable.
>
> The same usb stick with another computer and Vista gives a perfect
> image with absolutely no error from the same antenna.
>
> Yesterday I tried to update the drivers from the mercurial tree with no
> change.
>
> I noticed that the firmware available from the Net and Mythbuntu for
> the chip is quite old (2007 ?), so maybe this is the source of my
> problem. I am willing to try to use usbsnoop and the firmware cutter
> from
>=20
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_=
fi
>les/ if nobody has done it with a recent windows driver.
>
>
> I haven't found any parameter for the module dvb_usb_af9015 : Are they
> any than can be worth to try to fix my issue ?
>
>
> Thank you in advance,
>
> Cyril Hansen
> --

I have problems with some hardware, and the buffersize when the buffersize =
is=20
not multiple of TS_PACKET_SIZE.

You can try the attached patch.

Jose Alberto


--Boundary-00=_0eBeKZ3jJuIWZYg
Content-Type: text/x-patch;
  charset="UTF-8";
  name="af9015.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="af9015.patch"

diff -r b15490457d60 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Sat Aug 01 01:38:01 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Tue Aug 04 13:02:37 2009 +0200
@@ -877,7 +877,7 @@
 			af9015_config.dual_mode = 0;
 		} else {
 			af9015_properties[i].adapter[0].stream.u.bulk.buffersize
-				= TS_USB20_MAX_PACKET_SIZE;
+				= TS_USB20_FRAME_SIZE;
 		}
 	}
 
@@ -1312,7 +1312,7 @@
 					.u = {
 						.bulk = {
 							.buffersize =
-						TS_USB20_MAX_PACKET_SIZE,
+						TS_USB20_FRAME_SIZE,
 						}
 					}
 				},
@@ -1417,7 +1417,7 @@
 					.u = {
 						.bulk = {
 							.buffersize =
-						TS_USB20_MAX_PACKET_SIZE,
+						TS_USB20_FRAME_SIZE,
 						}
 					}
 				},
@@ -1523,7 +1523,7 @@
 					.u = {
 						.bulk = {
 							.buffersize =
-						TS_USB20_MAX_PACKET_SIZE,
+						TS_USB20_FRAME_SIZE,
 						}
 					}
 				},

--Boundary-00=_0eBeKZ3jJuIWZYg--
