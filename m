Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46261 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430AbcAYQu3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 11:50:29 -0500
Date: Mon, 25 Jan 2016 14:50:22 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
Subject: Re: [PATCH] tvp5150: Fix breakage for serial usage
Message-ID: <20160125145022.5bf0738a@recife.lan>
In-Reply-To: <54ffe2ae9209b607f54142809902764e2eaaf1d2.1453740290.git.mchehab@osg.samsung.com>
References: <54ffe2ae9209b607f54142809902764e2eaaf1d2.1453740290.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Jan 2016 14:44:56 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> changeset 460b6c0831cb ("tvp5150: Add s_stream subdev operation
> support") broke for em28xx-based devices with uses tvp5150. On those
> devices, touching the TVP5150_MISC_CTL register causes em28xx to stop
> streaming.
> 
> I suspect that it uses the 27 MHz clock provided by tvp5150 to feed
> em28xx. So, change the logic to do nothing on s_stream if the tvp5150 is
> not set up to work with V4L2_MBUS_PARALLEL.

Forgot to mention:

Tested with Hauppauge WinTV USB 2 model 42012 Rev. C186
(USB ID: 2040:4200).


> 
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/i2c/tvp5150.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 437f1a7ecb96..779c6f453cc9 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -975,19 +975,18 @@ static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
>  static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct tvp5150 *decoder = to_tvp5150(sd);
> -	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
> -	int val = 0x09;
>  
>  	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
> -	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
> -		val = 0x0d;
> +	if (decoder->mbus_type != V4L2_MBUS_PARALLEL)
> +		return 0;
>  
>  	/* Initializes TVP5150 to its default values */
>  	/* # set PCLK (27MHz) */
>  	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
>  
> +	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
>  	if (enable)
> -		tvp5150_write(sd, TVP5150_MISC_CTL, val);
> +		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
>  	else
>  		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);
>  
