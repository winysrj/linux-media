Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:54416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2FFOW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 10:22:29 -0400
Date: Wed, 6 Jun 2012 16:22:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Uzycki <janusz.uzycki@elproma.com.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: SH7724, VOU, PAL mode
In-Reply-To: <151B1A2540C945E48D7AAE0A8FC2DDEE@laptop2>
Message-ID: <Pine.LNX.4.64.1206061614250.12739@axis700.grange>
References: <1E539FC23CF84B8A91428720570395E0@laptop2>
 <Pine.LNX.4.64.1101241720001.17567@axis700.grange> <AD14536027B946D6B4504D4F43E352A5@laptop2>
 <Pine.LNX.4.64.1101262045550.3989@axis700.grange> <F95361ABAE1D4A70A10790A798004482@laptop2>
 <Pine.LNX.4.64.1101271809030.8916@axis700.grange> <8026191608244DB98F002E983C866149@laptop2>
 <Pine.LNX.4.64.1102011420540.6673@axis700.grange> <18BE1662A1F04B6C8B39AA46440A3FBB@laptop2>
 <Pine.LNX.4.64.1102011532360.6673@axis700.grange> <2F2263A44E0F466F898DD3E2F1D19F12@laptop2>
 <Pine.LNX.4.64.1102081427500.1393@axis700.grange> <CEA83F28AF7C47E7B83AE1DBFFBC8514@laptop2>
 <Pine.LNX.4.64.1206051651220.2145@axis700.grange> <151B1A2540C945E48D7AAE0A8FC2DDEE@laptop2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 6 Jun 2012, Janusz Uzycki wrote:

> Hi.
> 
> > Sorry, this is not going to be a very detailed reply. It's been a long
> > time since I've worked with VOU and AK8813(4).
> 
> I see.
> 
> > > If I set PAL mode (v4l2-ctl -s) VOUCR::MD is still configured for NTSC.
> > 
> > This shouldn't be the case: look at sh_vou_s_std(). Can you try to add
> > debugging to the driver to see, whether that function gets called, when
> > you run v4l2-ctl? If not - either you're calling it wrongly, or there's a
> > bug in it. If it is - see, whether it's not configuring VOUCR properly or
> > somehow it gets reset again later.
> 
> Before I turned on CONFIG_VIDEO_ADV_DEBUG only for I2C debug (v4l2-dbg). Now I
> turned on dynamic printk (dev_dbg) for sh_vou.c and observed that
> sh_vou_open() calls sh_vou_hw_init() what causes VOU reset:
> v4l2-ctl  -s 5
> sh-vou sh-vou: sh_vou_open()
> sh-vou sh-vou: Reset took 1us
> sh-vou sh-vou: sh_vou_querycap()
> sh-vou sh-vou: sh_vou_s_std(): 0xff
> CS495X-set: VOUER was 0x00000000, now SEN and ST bits are set
> CS495X set format: 000000ff
> CS495X-set: VOUER 0x00000000 restored
> sh-vou sh-vou: sh_vou_release()
> Standard set to 000000ff
> 
> This is why "v4l2-ctl -s 5" used before my simple test program (modified
> capture example with mmap method) finally has no effect for VOU.
> When the test program opens video device it causes reset PAL mode in VOU and
> does not in TV encoder.

Right, this is actually a bug in the VOU driver. It didn't affect me, 
because I was opening the device only once before all the configuration 
and streaming. Could you create and submit a patch to save the standard in 
driver private data and restore it on open() after the reset? I guess, 
other configuration parameters are lost too, feel free to fix them as 
well.

> Thanks Guennadi for the hints.
> (VOUER messages explanation: I have to set SEN and ST bits in CS49X driver
> because the chip needs 27MHz clock to I2C block operate)
> 
> > > I noticed that VOU is limited to NTSC resolution: "Maximum destination
> > > image
> > > size: 720 x 240 per field".
> > 
> > You mean in the datasheet?
> 
> Yes, exactly.
> 
> > I don't have it currently at hand, but I seem
> > to remember, that there was a bug and the VOU does actually support a full
> > PAL resolution too. I'm not 100% certain, though.
> 
> OK, I will test it. Do you remember how you discovered that?

Asked the manufacturer company :)

> > > Unfortunately I can't still manage to work video data from VOU to the
> > > encoder
> > > - green picture only. Do you have any test program for video v4l2 output?
> > 
> > You can use gstreamer, e.g.:
> > 
> > gst-launch -v filesrc location=x.avi ! decodebin ! ffmpegcolorspace ! \
> > video/x-raw-rgb,bpp=24 ! v4l2sink device=/dev/video0 tv-norm=PAL-B
> 
> thanks
> 
> > I also used a (possibly modified) program by Laurent (cc'ed) which either
> > I - with his agreement - can re-send to you, or maybe he'd send you the
> > original.
> 
> ok, is it media-ctl (git://git.ideasonboard.org/media-ctl.git)?

No, I'll send it to you off the list - Laurent agreed. But he also said, 
it was a preliminary version of his yavta proram, so, you might be able to 
use that one.

> > > Does
> > > the idea fb->v4l2 output
> > > http://www.spinics.net/lists/linux-fbdev/msg01102.html is alive?
> > 
> > More dead, than alive, I think.
> 
> Ok. Did you find another solution (software/library like DirectFB) for common
> and easier video output support in userspace?

No, sorry, I did not.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
