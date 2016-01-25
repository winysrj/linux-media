Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46745 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbcAYTH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 14:07:28 -0500
Date: Mon, 25 Jan 2016 17:07:21 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
Subject: Re: [PATCH] tvp5150: Fix breakage for serial usage
Message-ID: <20160125170721.01dcf4dc@recife.lan>
In-Reply-To: <1496492.fG104z7bmU@avalon>
References: <54ffe2ae9209b607f54142809902764e2eaaf1d2.1453740290.git.mchehab@osg.samsung.com>
	<4155957.1rbkLsApT9@avalon>
	<20160125161334.3ea3decb@recife.lan>
	<1496492.fG104z7bmU@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Jan 2016 20:42:49 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Monday 25 January 2016 16:13:34 Mauro Carvalho Chehab wrote:
> > Em Mon, 25 Jan 2016 19:38:55 +0200 Laurent Pinchart escreveu:  
> > > On Monday 25 January 2016 15:35:52 Mauro Carvalho Chehab wrote:  
> > > > Em Mon, 25 Jan 2016 19:23:40 +0200 Laurent Pinchart escreveu:  
> > > > > On Monday 25 January 2016 14:44:56 Mauro Carvalho Chehab wrote:  
> > > > >> changeset 460b6c0831cb ("tvp5150: Add s_stream subdev operation
> > > > >> support") broke for em28xx-based devices with uses tvp5150. On those
> > > > >> devices, touching the TVP5150_MISC_CTL register causes em28xx to stop
> > > > >> streaming.
> > > > >> 
> > > > >> I suspect that it uses the 27 MHz clock provided by tvp5150 to feed
> > > > >> em28xx. So, change the logic to do nothing on s_stream if the tvp5150
> > > > >> is not set up to work with V4L2_MBUS_PARALLEL.
> > > > >> 
> > > > >> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> > > > >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > >> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > > >> ---
> > > > >> 
> > > > >>  drivers/media/i2c/tvp5150.c | 9 ++++-----
> > > > >>  1 file changed, 4 insertions(+), 5 deletions(-)
> > > > >> 
> > > > >> diff --git a/drivers/media/i2c/tvp5150.c
> > > > >> b/drivers/media/i2c/tvp5150.c
> > > > >> index 437f1a7ecb96..779c6f453cc9 100644
> > > > >> --- a/drivers/media/i2c/tvp5150.c
> > > > >> +++ b/drivers/media/i2c/tvp5150.c
> > > > >> @@ -975,19 +975,18 @@ static int tvp5150_g_mbus_config(struct
> > > > >> v4l2_subdev *sd,
> > > > >> 
> > > > >>  static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
> > > > >>  {
> > > > >>  
> > > > >>  	struct tvp5150 *decoder = to_tvp5150(sd);
> > > > >> 
> > > > >> -	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
> > > > >> -	int val = 0x09;
> > > > >> 
> > > > >>  	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
> > > > >> 
> > > > >> -	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
> > > > >> -		val = 0x0d;
> > > > >> +	if (decoder->mbus_type != V4L2_MBUS_PARALLEL)
> > > > >> +		return 0;  
> > > > > 
> > > > > This will break TVP5151 operation with the OMAP3 ISP in BT.656 mode.
> > > > > The OMAP3 requires the TVP5151 to start and stop streaming when
> > > > > requested.  
> > > > 
> > > > Does OMAP3 work in BT.656 with the current hardware? If so, then we'll
> > > > need an extra property to enable the start/stop ops if used with OMAP3.  
> > > 
> > > Yes it does work in BT.656 mode with tvp5151. That was the purpose of my
> > > original patch.  
> > 
> > The problem is that the original patch not only enable/disable streaming,
> > but it actually changes all bits at the TVP5150_MISC_CTL register, touching
> > on all clock setup. It also touches TVP5150_CONF_SHARED_PIN.  
> 
> OK, that's certainly an issue. Does it work if you just fix that but keep the 
> stream on/off ?

I tried to just disable the settings for TVP5150_CONF_SHARED_PIN. 
It doesn't work.

Perhaps some other settings could be possible, like touching only bit 4
and/or bit 6 of TVP5150_MISC_CTL, but more tests are required.

> 
> > On em28xx devices (with comes with a tvp5150am1), the value used is
> > TVP5150_MISC_CTL = 0X6f
> > TVP5150_CONF_SHARED_PIN = 0x08
> > 
> > Other values cause it to not stream at all.
> >  
> > > If the em28xx can't work with the tvp5151 being turned off
> > > when not used then we need a workaround for the em28xx.  
> > 
> > No regressions are allowed. The em28xx-based tvp5150am1 devices are
> > there since the beginning, when I wrote this driver to support
> > WinTV USB2. Almost all early analog TV devices after this one comes
> > with a tvp5150a or tvp5150am1 on it.
> > 
> > The OMAP3 tvp5151 devices are new. Adding support for them
> > should not break support for the already supported devices.  
> 
> Sure, it shouldn't, but it did, so we have to fix it.
> 
> > One possible way to fix for OMAP3+TVP5051 is to check if the device has
> > a TVP5051 on it and use the new logic only for such devices, but this
> > sounds a little bit hacky.  
> 
> Yes, that's quite hackish.
> 
> My point was that s_stream() is supposed to start/stop streaming. That's what 
> the tvp5150 driver should implement. If the em28xx breaks if the stream is 
> stopped (with the problem you mention above regarding CONF_SHARED_PIN fixed or 
> course) then it's the em28xx driver that should avoid stopping the stream. The 
> tvp5150 driver isn't supposed to know which driver uses it, it should 
> start/stop streaming when requested.

See page 32 of the datasheet:
	http://www.ti.com/lit/ds/symlink/tvp5150am1.pdf

Except for those bits:
	bit 6 - Output enabled
	bit 4 - YOUT[7:0] active

all other bits control the interface between tvp5150/5151 and the
chip that receives the signal (either em28xx or omap3). Even if
em28xx accepts to touch those two bits, we can't touch the other
values of this register, or it would break the signaling between
the video standard decoder and the bridge/master chipset.

So, no matter how we fix it, omap3 will need a different setting
than em28xx.

Regards,
Mauro

> 
> > The best fix seems to add some DT property to tell that the device
> > needs a s_stream enable/disable logic.  
> 
> DT is supposed to be a hardware description, not a bunch of random software 
> properties :-)
> 
> > >> Otherwise, we could add a notice here and write such change when needed.
> > >>   
> > >>>>  	/* Initializes TVP5150 to its default values */
> > >>>>  	/* # set PCLK (27MHz) */
> > >>>>  	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
> > >>>> 
> > >>>> +	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
> > >>>>  	if (enable)
> > >>>> -		tvp5150_write(sd, TVP5150_MISC_CTL, val);
> > >>>> +		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
> > >>>>  	else
> > >>>>  		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);  
> 
