Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58196 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758875AbcAKKWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 05:22:35 -0500
Subject: Re: [PATCH v2 2/2] media: adv7604: update timings on change of input
 signal
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
References: <1450794122-31293-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1450794122-31293-3-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56938265.6050803@xs4all.nl>
Date: Mon, 11 Jan 2016 11:22:29 +0100
MIME-Version: 1.0
In-Reply-To: <1450794122-31293-3-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/22/2015 03:22 PM, Ulrich Hecht wrote:
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
> @@ -1945,6 +1945,7 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
>  	u8 fmt_change_digital;
>  	u8 fmt_change;
>  	u8 tx_5v;
> +	int ret;
>  
>  	if (irq_reg_0x43)
>  		io_write(sd, 0x44, irq_reg_0x43);
> @@ -1968,6 +1969,14 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
>  
>  		v4l2_subdev_notify_event(sd, &adv76xx_ev_fmt);
>  
> +		/* update timings */
> +		ret = adv76xx_query_dv_timings(sd, &state->timings);
> +		if (ret == -ENOLINK) {
> +			/* no signal, fall back to default timings */
> +			state->timings = (struct v4l2_dv_timings)
> +				V4L2_DV_BT_CEA_640X480P59_94;
> +		}

Nack.

If you detect a change in timings, then send the V4L2_EVENT_SOURCE_CHANGE event and leave
it to the app to query the new timings. Never do this in the driver itself.

The reason is that this will pull the rug out from under the application: the app thinks
it is using timings A but the driver is using timings B. Instead, tell the app that the
timings have changed and let the app handle this.

Regards,

	Hans

> +
>  		if (handled)
>  			*handled = true;
>  	}
> 

