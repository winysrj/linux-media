Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1258 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZB0Lxw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 06:53:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Conversion of vino driver for SGI to not use the legacy decoder API
Date: Fri, 27 Feb 2009 12:53:28 +0100
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Old Video ML <video4linux-list@redhat.com>,
	Douglas Landgraf <dougsland@gmail.com>
References: <20090226214742.6576f30b@pedra.chehab.org> <20090227100947.160abd0b@hyperion.delvare> <20090227082216.574b42cf@pedra.chehab.org>
In-Reply-To: <20090227082216.574b42cf@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271253.28283.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 February 2009 12:22:16 Mauro Carvalho Chehab wrote:
> On Fri, 27 Feb 2009 10:09:47 +0100
>
> Jean Delvare <khali@linux-fr.org> wrote:
> > Hi Hans,
> >
> > On Fri, 27 Feb 2009 08:19:17 +0100, Hans Verkuil wrote:
> > > On Friday 27 February 2009 01:47:42 Mauro Carvalho Chehab wrote:
> > > > After the conversion of Zoran driver to V4L2, now almost all
> > > > drivers are using the new API. However, there are is one remaining
> > > > driver using the video_decoder.h API (based on V4L1 API) for
> > > > message exchange between the bridge driver and the i2c sensor: the
> > > > vino driver.
> > > >
> > > > This driver adds support for the Indy webcam and for a capture
> > > > hardware on SGI. Does someone have those hardware? If so, are you
> > > > interested on helping to convert those drivers to fully use V4L2
> > > > API?
> > > >
> > > > The SGI driver is located at:
> > > > 	drivers/media/video/vino.c
> > > >
> > > > Due to vino, those two drivers are also using the old API:
> > > > 	drivers/media/video/indycam.c
> > > > 	drivers/media/video/saa7191.c
> > > >
> > > > It shouldn't be hard to convert those files to use the proper APIs,
> > > > but AFAIK none of the current active developers has any hardware
> > > > for testing it.
> > >
> > > The conversion has already been done in my v4l-dvb-vino tree.
>
> Great! Do you have any other tree converting drivers from V4L1 to V4L2
> API? Btw, we should update the dependencies for the converted drivers.
> They are still dependent of V4L1:

Oops, forgot about those.

> config VIDEO_BT819
>         tristate "BT819A VideoStream decoder"
>         depends on VIDEO_V4L1 && I2C
>
> I'll do such update probably later today. I want to have an overall
> picture on what's still left.

I'm keeping a document with the state of all the drivers here:

http://www.xs4all.nl/%7Ehverkuil/drivers.txt

Basically it tells me which drivers are v4l1/2, use video_ioctl2, use 
v4l2_device and which use v4l2_subdev (this column is empty when the driver 
doesn't use modules at all). The final column tells me who can test this 
hardware.

At the bottom is a similar list of i2c modules.

I have also converted the cafe_ccic driver and I'm waiting for feedback from 
Jonathan Corbet whether it works or not.

The following drivers haven't been converted yet to v4l2_device/subdev:

em28xx (Douglas Landgraf said he'd tackle that one), pvrusb2 (Mike Isely is 
doing that one), cx88 (unassigned), bttv (I want to look at that one), 
cx23885 (also for me), and w9968cf. The last one is much more difficult 
since it is v4l1. I do have hardware to test this, but no experience 
porting from v4l1 to v4l2 or with gspca (the alternative conversion path 
that I can take). In all honesty, I was planning to just do a 
quick-and-dirty conversion to v4l2_subdev, while keeping the v4l1 API. I 
doubt I will have time to do anything more. It allows Jean to make his i2c 
cleanups and we can do a proper conversion to v4l2 later.

My status document also contains a list of the remaining v4l1 drivers:

arv, bw-qcam, c-qcam, cpia_pp: these four are ancient and we should consider 
dropping these altogether. The first seems to be tied to very specific 
hardware (we should contact the author first before making any decision on 
that one), the others are for parallel port webcams.

cpia_usb: ancient, but USB and I got my hands on one, so that might be 
interesting to see if it can be converted.

ov511: I got hardware for that one as well

pms: Amazingly, I got hardware for this one as well. Totally useless ISA 
video capture card, but it actually works and as a fun project I want to 
upgrade that one.

se401: I don't believe I have hardware for this one (I'm scouring ebay these 
days for old stuff, but I don't think I found hardware for this driver).

stradis: can't find any hardware at all. We might want to contact the author 
first, though, since these are (semi-?)professional devices.

stv680: got hardware for this

usbvideo: ditto

w9966: can't find any hardware for this one.

w9968cf: have hardware as described above.

Actually, if anyone else is interested in converting some of these drivers 
to v4l2 or gspca, I'd be happy to send him the hardware. It's too much work 
for one person, really.

The reason for me collecting all this information and hardware is that I 
think that for 2.6.31 we should set our goal to abolish these last v4l1 
drivers. In parallel to that we should convert the other drivers to 
v4l2_device and video_ioctl2 which gives a great foundation for the future.

> > > I'm trying to
> > > convince the original vino author to boot up his Indy and test it,
> > > but he is not very interested in doing that. I'll ask him a few more
> > > times, but we may have to just merge my code untested. Or perhaps
> > > just drop it.
>
> Well, let's merge the code. Maybe someone at the ML could have an Indy
> and can test it.
>
> I think that the risk of breaking vino is not big, since this conversion
> is more like a variable renaming. Also, after applying those changes at
> linux-next, more people can test its code. Maybe we can add some printk's
> asking for testers to contact us at LMML.
>
> I would love to finally remove another V4L1 header (video_decoder.h).

OK, I'll send the pull request.

> > > Jean, I remember you mentioning that you wouldn't mind if the
> > > i2c-algo-sgi code could be dropped which is only used by vino. How
> > > important is that to you? Perhaps we are flogging a dead horse here
> > > and we should just let this driver die.
> >
> > My rant was based on the fact that i2c-algo-sgi is totally SGI-specific
> > while i2c-algo-* modules are supposed to be generic abstractions that
> > can be reused by a variety of hardware. So i2c-algo-sgi should really
> > be merged into drivers/media/video/vino.c. But as it takes a SGI system
> > to build-test such a change, and I don't have one, I am reluctant to do
> > it. If we can find a tester for your V4L2 conversion then maybe the
> > same tester will be able to test my own changes.
> >
> > But i2c-algo-sgi isn't a big problem per se, it doesn't block further
> > evolutions or anything like that, so if we can't find a tester and it
> > has to stay for a few more years, this really isn't a problem for me.
>
> If the merger of i2c-algo-sgi is as not something complex, then we can
> try to merge and apply at vino. Otherwise, we can just keep as-is.
>
> PS.: probably you haven't noticed, but tea575x-tuner.c is still V4L1 (one
> of your patches changed the header improperly, breaking sound build).

Ah, missed that one. Sorry for the breakage. Added it to my status list. 
Should be trivial to convert to v4l2 looking at the code.

Regards,

	Hans

> Douglas,
>
> As you've done several radio conversions to V4L2 API, maybe you can also
> handle this one.
>
> Cheers,
> Mauro



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
