Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46525 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbcLHWc6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 17:32:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] [media] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN if not needed
Date: Fri, 09 Dec 2016 00:33:22 +0200
Message-ID: <1726705.V5pZ2YOHyk@avalon>
In-Reply-To: <1358e218a098d1633d758ed63934d84da7619bd9.1481226269.git.mchehab@s-opensource.com>
References: <1358e218a098d1633d758ed63934d84da7619bd9.1481226269.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I've just sent a series of patches ("[PATCH 0/6] Fix tvp5150 regression with 
em28xx") that should fix this problem properly. I unfortunately haven't been 
able to test it with an em28xx device as I don't own any.

On Thursday 08 Dec 2016 17:46:53 Mauro Carvalho Chehab wrote:
> commit 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
> support") added a logic that overrides TVP5150_CONF_SHARED_PIN setting,
> depending on the type of bus set via the .set_fmt() subdev callback.
> 
> This is known to cause trobules on devices that don't use a V4L2
> subdev devnode, and a fix for it was made by commit 47de9bf8931e
> ("[media] tvp5150: Fix breakage for serial usage"). Unfortunately,
> such fix doesn't consider the case of progressive video inputs,
> causing chroma decoding issues on such videos, as it overrides not
> only the type of video output, but also other unrelated bits.
> 
> So, instead of trying to guess, let's detect if the device configuration
> is set via Device Tree. If not, just ignore the new logic, restoring
> the original behavior.
> 
> Fixes: 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
> support") Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
> 
> changes since version 2:
>   - fixed settings for register 0x0d
>   - tested on WinTV USB2 with S-Video input
> 
> I'll do an extra test with HVR-950 on both S-Video and composite soon enough
> 
> changes since version 1: added a notice about what's broken at the
> tvp5150_stream() logic, and improved patch's description.
> 
> changes since RFC: don't touch at enum v4l2_mbus_type.
> 
>  drivers/media/i2c/tvp5150.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 6737685d5be5..8b9d2fad17df 100644
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
> @@ -1053,6 +1054,20 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd,
> int enable) /* Output format: 8-bit ITU-R BT.656 with embedded syncs */
>  	int val = 0x09;
> 
> +	if (!decoder->has_dt)
> +		return 0;
> +
> +	/*
> +	 * FIXME: the logic below is hardcoded to work with some OMAP3
> +	 * hardware with tvp5151. As such, it hardcodes values for
> +	 * both TVP5150_CONF_SHARED_PIN and TVP5150_MISC_CTL, and ignores
> +	 * what was set before at the driver. Ideally, we should have
> +	 * DT nodes describing the setup, instead of hardcoding those
> +	 * values, and doing a read before writing values to
> +	 * TVP5150_MISC_CTL, but any patch adding support for it should
> +	 * keep DT backward-compatible.
> +	 */
> +
>  	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
>  	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
>  		val = 0x0d;
> @@ -1471,6 +1486,7 @@ static int tvp5150_probe(struct i2c_client *c,
>  			dev_err(sd->dev, "DT parsing error: %d\n", res);
>  			return res;
>  		}
> +		decoder->has_dt = true;
>  	} else {
>  		/* Default to BT.656 embedded sync */
>  		core->mbus_type = V4L2_MBUS_BT656;

-- 
Regards,

Laurent Pinchart

