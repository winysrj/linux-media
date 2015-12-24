Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54220 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbbLXLrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 06:47:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@gmail.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk
Subject: Re: [PATCH v2 2/2] media: adv7604: update timings on change of input signal
Date: Thu, 24 Dec 2015 13:47:47 +0200
Message-ID: <1491106.CZOxgP2rDa@avalon>
In-Reply-To: <1450794122-31293-3-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com> <1450794122-31293-3-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

(With a question for Hans below)

Thank you for the patch.

On Tuesday 22 December 2015 15:22:02 Ulrich Hecht wrote:
> Without this, .get_selection will always return the boot-time state.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/i2c/adv7604.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 8ad5c28..dcd659b 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -1945,6 +1945,7 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32
> status, bool *handled) u8 fmt_change_digital;
>  	u8 fmt_change;
>  	u8 tx_5v;
> +	int ret;
> 
>  	if (irq_reg_0x43)
>  		io_write(sd, 0x44, irq_reg_0x43);
> @@ -1968,6 +1969,14 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32
> status, bool *handled)
> 
>  		v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
> 
> +		/* update timings */
> +		ret = adv76xx_query_dv_timings(sd, &state->timings);

I'm not too familiar with the DV timings API, but I'm not sure this is 
correct. This would result in g_dv_timings returning the detected timings, 
while we have the dedicated query_dv_timings operation for that. Hans, could 
you comment on this ? How do query_dv_timings and g_dv_timings interact ? The 
API documentation isn't very clear about that.

> +		if (ret == -ENOLINK) {
> +			/* no signal, fall back to default timings */
> +			state->timings = (struct v4l2_dv_timings)
> +				V4L2_DV_BT_CEA_640X480P59_94;
> +		}
> +
>  		if (handled)
>  			*handled = true;
>  	}

-- 
Regards,

Laurent Pinchart

