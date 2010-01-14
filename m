Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm2.telefonica.net ([213.4.138.2]:28767 "EHLO
	IMPaqm2.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab0ANQ0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 11:26:54 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: Problem with gspca and zc3xx
Date: Thu, 14 Jan 2010 17:26:51 +0100
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
References: <201001090015.31357.jareguero@telefonica.net> <201001121557.10312.jareguero@telefonica.net> <201001131450.44689.jareguero@telefonica.net>
In-Reply-To: <201001131450.44689.jareguero@telefonica.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MX0TL2v+zyyJZ9g"
Message-Id: <201001141726.52062.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_MX0TL2v+zyyJZ9g
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

El Mi=C3=A9rcoles, 13 de Enero de 2010, Jose Alberto Reguero escribi=C3=B3:
> El Martes, 12 de Enero de 2010, Jose Alberto Reguero escribi=C3=B3:
> > El Martes, 12 de Enero de 2010, Jean-Francois Moine escribi=C3=B3:
> > > On Mon, 11 Jan 2010 15:49:55 +0100
> > >
> > > Jose Alberto Reguero <jareguero@telefonica.net> wrote:
> > > > I take another image with 640x480 and the bad bottom lines are 8. T=
he
> > > > right side look right this time. The good sizes are:
> > > > 320x240->320x232
> > > > 640x480->640x472
> > >
> > > Hi Jose Alberto and Hans,
> > >
> > > Hans, I modified a bit your patch to handle the 2 resolutions (also,
> > > the problem with pas202b does not exist anymore). May you sign or ack
> > > it?
> > >
> > > Jose Alberto, the attached patch is to be applied to the last version
> > > of the gspca in my test repository at LinuxTv.org
> > > 	http://linuxtv.org/hg/~jfrancois/gspca
> > > May you try it?
> > >
> > > Regards.
> >
> >  The patch works well.
> > There is another problem. When autogain is on(default), the image is ba=
d.
> >  It is possible to put autogain off by default?
> >
> > Thanks.
> > Jose Alberto
>=20
> Autogain works well again. I can't reproduce the problem. Perhaps the deb=
ug
> messages. (Now I have debug off).
>=20
> Thanks.
> Jose Alberto

I found the problem. Autogain don't work well if brightness is de default=20
value(128). if brightness is less(64) autogain work well. There is a proble=
m=20
when setting the brightness. It is safe to remove the brightness control?
Patch attached.

Jose Alberto

--Boundary-00=_MX0TL2v+zyyJZ9g
Content-Type: text/x-patch;
  charset="UTF-8";
  name="zc3xx.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="zc3xx.patch"

diff -r d490d84a64ac linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Wed Jan 13 12:11:34 2010 -0200
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Thu Jan 14 17:03:10 2010 +0100
@@ -6028,6 +6041,7 @@
 	case SENSOR_OV7620:
 	case SENSOR_PAS202B:
 	case SENSOR_PO2030:
+	case SENSOR_MC501CB:
 		return;
 	}
 /*fixme: is it really write to 011d and 018d for all other sensors? */
@@ -6796,6 +6837,7 @@
 	case SENSOR_OV7620:
 	case SENSOR_PAS202B:
 	case SENSOR_PO2030:
+	case SENSOR_MC501CB:
 		gspca_dev->ctrl_dis = (1 << BRIGHTNESS_IDX);
 		break;
 	case SENSOR_HV7131B:

--Boundary-00=_MX0TL2v+zyyJZ9g--
