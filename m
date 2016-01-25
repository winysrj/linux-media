Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34245 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789AbcAYRih (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 12:38:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
Subject: Re: [PATCH] tvp5150: Fix breakage for serial usage
Date: Mon, 25 Jan 2016 19:38:55 +0200
Message-ID: <4155957.1rbkLsApT9@avalon>
In-Reply-To: <20160125153552.58423888@recife.lan>
References: <54ffe2ae9209b607f54142809902764e2eaaf1d2.1453740290.git.mchehab@osg.samsung.com> <2245834.R0faizq23Z@avalon> <20160125153552.58423888@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 25 January 2016 15:35:52 Mauro Carvalho Chehab wrote:
> Em Mon, 25 Jan 2016 19:23:40 +0200 Laurent Pinchart escreveu:
> > On Monday 25 January 2016 14:44:56 Mauro Carvalho Chehab wrote:
> >> changeset 460b6c0831cb ("tvp5150: Add s_stream subdev operation
> >> support") broke for em28xx-based devices with uses tvp5150. On those
> >> devices, touching the TVP5150_MISC_CTL register causes em28xx to stop
> >> streaming.
> >> 
> >> I suspect that it uses the 27 MHz clock provided by tvp5150 to feed
> >> em28xx. So, change the logic to do nothing on s_stream if the tvp5150 is
> >> not set up to work with V4L2_MBUS_PARALLEL.
> >> 
> >> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >> ---
> >> 
> >>  drivers/media/i2c/tvp5150.c | 9 ++++-----
> >>  1 file changed, 4 insertions(+), 5 deletions(-)
> >> 
> >> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> >> index 437f1a7ecb96..779c6f453cc9 100644
> >> --- a/drivers/media/i2c/tvp5150.c
> >> +++ b/drivers/media/i2c/tvp5150.c
> >> @@ -975,19 +975,18 @@ static int tvp5150_g_mbus_config(struct
> >> v4l2_subdev *sd,
> >>  static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
> >>  {
> >>  	struct tvp5150 *decoder = to_tvp5150(sd);
> >> 
> >> -	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
> >> -	int val = 0x09;
> >> 
> >>  	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
> >> -	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
> >> -		val = 0x0d;
> >> +	if (decoder->mbus_type != V4L2_MBUS_PARALLEL)
> >> +		return 0;
> > 
> > This will break TVP5151 operation with the OMAP3 ISP in BT.656 mode. The
> > OMAP3 requires the TVP5151 to start and stop streaming when requested.
> 
> Does OMAP3 work in BT.656 with the current hardware? If so, then we'll need
> an extra property to enable the start/stop ops if used with OMAP3.

Yes it does work in BT.656 mode with tvp5151. That was the purpose of my 
original patch. If the em28xx can't work with the tvp5151 being turned off 
when not used then we need a workaround for the em28xx.

> Otherwise, we could add a notice here and write such change when needed.
> 
> >>  	/* Initializes TVP5150 to its default values */
> >>  	/* # set PCLK (27MHz) */
> >>  	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
> >> 
> >> +	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
> >>  	if (enable)
> >> -		tvp5150_write(sd, TVP5150_MISC_CTL, val);
> >> +		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
> >>  	else
> >>  		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);

-- 
Regards,

Laurent Pinchart

