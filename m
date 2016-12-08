Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45269 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbcLHNle (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 08:41:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN if not needed
Date: Thu, 08 Dec 2016 15:41:59 +0200
Message-ID: <3555863.PStTa0BX6X@avalon>
In-Reply-To: <b47a9d956d740d63334bf0f07e6cfddd7f60e98b.1481204310.git.mchehab@s-opensource.com>
References: <b47a9d956d740d63334bf0f07e6cfddd7f60e98b.1481204310.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 08 Dec 2016 11:38:34 Mauro Carvalho Chehab wrote:
> changeset 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
> support") added a logic that overrides TVP5150_CONF_SHARED_PIN setting,
> depending on the type of bus set via the .set_fmt() subdev callback.
> 
> This is known to cause trobules on devices that don't use a V4L2
> subdev devnode, and a fix for it was made by changeset 47de9bf8931e
> ("[media] tvp5150: Fix breakage for serial usage"). Unfortunately,
> such fix doesn't consider the case of progressive video inputs,
> causing chroma decoding issues on such videos, as it overrides not
> only the type of video output, but also other unrelated bits.
> 
> So, instead of trying to guess, let's detect if the device is set
> via Device Tree. If not, just ignore the bogus logic.

If you add a big [HACK] tag to the subject line, sure. I thought this would 
have been an occasion to fix the problem correctly :-(

> Fixes: 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
> support") Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/i2c/tvp5150.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 6737685d5be5..eb43ac7002d6 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -57,6 +57,7 @@ struct tvp5150 {
>  	u16 rom_ver;
> 
>  	enum v4l2_mbus_type mbus_type;
> +	bool has_dt;
>  };
> 
>  static inline struct tvp5150 *to_tvp5150(struct v4l2_subdev *sd)
> @@ -795,7 +796,7 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32
> val)
> 
>  	tvp5150_set_std(sd, decoder->norm);
> 
> -	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
> +	if (decoder->mbus_type == V4L2_MBUS_PARALLEL || !decoder->has_dt)
>  		tvp5150_write(sd, TVP5150_DATA_RATE_SEL, 0x40);
> 
>  	return 0;
> @@ -1053,6 +1054,9 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd,
> int enable)
> 	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
>  	int val = 0x09;
> 
> +	if (!decoder->has_dt)
> +		return 0;
> +
>  	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
>  	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
>  		val = 0x0d;
> @@ -1374,6 +1378,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder,
> struct device_node *np)
>  	}
> 
>  	decoder->mbus_type = bus_cfg.bus_type;
> +	decoder->has_dt = true;
> 
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	connectors = of_get_child_by_name(np, "connectors");

-- 
Regards,

Laurent Pinchart

