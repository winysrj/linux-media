Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34017 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754863AbeAHR4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 12:56:32 -0500
Received: by mail-lf0-f68.google.com with SMTP id h140so13016746lfg.1
        for <linux-media@vger.kernel.org>; Mon, 08 Jan 2018 09:56:31 -0800 (PST)
Date: Mon, 8 Jan 2018 18:56:29 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: i2c: adv748x: fix HDMI field heights
Message-ID: <20180108175629.GE23075@bigcity.dyn.berto.se>
References: <1515433167-15912-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1515433167-15912-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your patch.

On 2018-01-08 17:39:30 +0000, Kieran Bingham wrote:
> The ADV748x handles interlaced media using V4L2_FIELD_ALTERNATE field
> types.  The correct specification for the height on the mbus is the
> image height, in this instance, the field height.
> 
> The AFE component already correctly adjusts the height on the mbus, but
> the HDMI component got left behind.
> 
> Adjust the mbus height to correctly describe the image height of the
> fields when processing interlaced video for HDMI pipelines.
> 
> Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/i2c/adv748x/adv748x-hdmi.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> index 4da4253553fc..0e2f76f3f029 100644
> --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> @@ -105,6 +105,10 @@ static void adv748x_hdmi_fill_format(struct adv748x_hdmi *hdmi,
>  
>  	fmt->width = hdmi->timings.bt.width;
>  	fmt->height = hdmi->timings.bt.height;
> +
> +	/* Propagate field height on the mbus for FIELD_ALTERNATE fmts */
> +	if (hdmi->timings.bt.interlaced)

        if (V4L2_FIELD_HAS_T_OR_B(fmt->field))

Nit-picking but I would use the field here (which is set just above this 
in the same function) as it makes it more clear why the format is cut in 
half. I looked at the documentation for bt.interlaced and I'm not sure 
if it would be set to true for INTERLACED field formats when the height 
should not be halved? In this case it do not matter as 

        fmt->field = hdmi->timings.bt.interlaced ?
            V4L2_FIELD_ALTERNATE : V4L2_FIELD_NONE;

So I leave this up to you and feel free to add in either case.

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> +		fmt->height /= 2;
>  }
>  
>  static void adv748x_fill_optional_dv_timings(struct v4l2_dv_timings *timings)
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
