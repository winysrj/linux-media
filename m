Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49982 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbeJAUKr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 16:10:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
Date: Mon, 01 Oct 2018 16:33:12 +0300
Message-ID: <3032208.Lnne8Zlx0s@avalon>
In-Reply-To: <d24d3977163f6c05cd65210b743f4e0dc321388d.camel@ndufresne.ca>
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl> <d24d3977163f6c05cd65210b743f4e0dc321388d.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, 1 October 2018 15:42:56 EEST Nicolas Dufresne wrote:
> Le lundi 01 octobre 2018 =E0 10:43 +0200, Hans Verkuil a =E9crit :
> > It turns out that we have both JPEG and Motion-JPEG pixel formats defin=
ed.
> >=20
> > Furthermore, some drivers support one, some the other and some both.
> >=20
> > These pixelformats both mean the same.
> >=20
> > I propose that we settle on JPEG (since it seems to be used most often)
> > and add JPEG support to those drivers that currently only use MJPEG.
>=20
> Thanks for looking into this. As per GStreamer code, I see 3 alias for
> JPEG. V4L2_PIX_FMT_MJPEG/JPEG/PJPG. I don't know the context, this code
> was written before I knew GStreamer existed. It's possible there is a
> subtle difference, I have never looked at it, but clearly all our JPEG
> decoder handle these as being the same.
>=20
> https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/sys/v4l2/gst=
v4l
> 2object.c#n956

Some old code to give a bit of context:

https://github.com/TimSC/mjpeg/

It should be feasible to implement a decoder that inserts the right Huffman=
=20
table when none exists, but it has to be explicitly handled. An out-of-band=
=20
mechanism to convey the information seems potentially useful to me.

> > We also need to update the V4L2_PIX_FMT_JPEG documentation since it just
> > says TBD:
> >=20
> > https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-comp=
res
> > sed.html
> >=20
> > $ git grep -l V4L2_PIX_FMT_MJPEG
> > drivers/media/pci/meye/meye.c
> > drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> > drivers/media/platform/sti/delta/delta-cfg.h
> > drivers/media/platform/sti/delta/delta-mjpeg-dec.c
> > drivers/media/usb/cpia2/cpia2_v4l.c
> > drivers/media/usb/go7007/go7007-driver.c
> > drivers/media/usb/go7007/go7007-fw.c
> > drivers/media/usb/go7007/go7007-v4l2.c
> > drivers/media/usb/s2255/s2255drv.c
> > drivers/media/usb/uvc/uvc_driver.c
> > drivers/staging/media/zoran/zoran_driver.c
> > drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
> > drivers/usb/gadget/function/uvc_v4l2.c
> >=20
> > It looks like s2255 and cpia2 support both already, so that would leave
> > 8 drivers that need to be modified, uvc being the most important of the
> > lot.
> >=20
> > Any comments?

=2D-=20
Regards,

Laurent Pinchart
