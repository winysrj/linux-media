Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41854 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750862AbdH3V2V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 17:28:21 -0400
Date: Thu, 31 Aug 2017 00:28:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rajmohan Mani <rajmohan.mani@intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        hverkuil@xs4all.nl, tfiga@chromium.org, s.nawrocki@samsung.com,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH] [media] dw9714: Set the v4l2 focus ctrl step as 1
Message-ID: <20170830212819.6tepof4jzdiqtezd@valkosipuli.retiisi.org.uk>
References: <1504115332-26651-1-git-send-email-rajmohan.mani@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504115332-26651-1-git-send-email-rajmohan.mani@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rajmohan,

On Wed, Aug 30, 2017 at 10:48:52AM -0700, Rajmohan Mani wrote:
> Current v4l2 focus ctrl step value of 16, limits
> the minimum granularity of focus positions to 16.
> Setting this value as 1, enables more accurate
> focus positions.

Thanks for the patch.

The recommended limit for line length is 75, not 50 (or 25 or whatever) as
it might be in certain Gerrit installations. :-) Please make good use of
lines in the future, I've rewrapped the text this time. Thanks.

> 
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  drivers/media/i2c/dw9714.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
> index 6a607d7..f9212a8 100644
> --- a/drivers/media/i2c/dw9714.c
> +++ b/drivers/media/i2c/dw9714.c
> @@ -22,6 +22,11 @@
>  #define DW9714_NAME		"dw9714"
>  #define DW9714_MAX_FOCUS_POS	1023
>  /*
> + * This sets the minimum granularity for the focus positions.
> + * A value of 1 gives maximum accuracy for a desired focus position
> + */
> +#define DW9714_FOCUS_STEPS	1
> +/*
>   * This acts as the minimum granularity of lens movement.
>   * Keep this value power of 2, so the control steps can be
>   * uniformly adjusted for gradual lens movement, with desired
> @@ -138,7 +143,7 @@ static int dw9714_init_controls(struct dw9714_device *dev_vcm)
>  	v4l2_ctrl_handler_init(hdl, 1);
>  
>  	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
> -			  0, DW9714_MAX_FOCUS_POS, DW9714_CTRL_STEPS, 0);
> +			  0, DW9714_MAX_FOCUS_POS, DW9714_FOCUS_STEPS, 0);
>  
>  	if (hdl->error)
>  		dev_err(&client->dev, "%s fail error: 0x%x\n",

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
