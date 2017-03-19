Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35294 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbdCSWKX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 18:10:23 -0400
Subject: Re: [PATCH 1/4] media: imx-media-csi: fix v4l2-compliance check
To: Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <E1cpYOK-0006EZ-No@rmk-PC.armlinux.org.uk>
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <0bdcf910-d566-e46f-92e3-4a7380564736@gmail.com>
Date: Sun, 19 Mar 2017 15:00:26 -0700
MIME-Version: 1.0
In-Reply-To: <E1cpYOK-0006EZ-No@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good to me.

Steve


On 03/19/2017 03:48 AM, Russell King wrote:
> v4l2-compliance was failing with:
>
>                  fail: v4l2-test-formats.cpp(1076): cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0
>                  test VIDIOC_G/S_PARM: FAIL
>
> Fix this.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/staging/media/imx/imx-media-csi.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 0336891069dc..65346e789dd6 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -680,8 +680,10 @@ static const struct csi_skip_desc *csi_find_best_skip(struct v4l2_fract *in,
>   
>   	/* Default to 1:1 ratio */
>   	if (out->numerator == 0 || out->denominator == 0 ||
> -	    in->numerator == 0 || in->denominator == 0)
> +	    in->numerator == 0 || in->denominator == 0) {
> +		*out = *in;
>   		return best_skip;
> +	}
>   
>   	want_us = div_u64((u64)USEC_PER_SEC * out->numerator, out->denominator);
>   
