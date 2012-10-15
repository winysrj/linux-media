Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34267 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JOLBt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 07:01:49 -0400
Message-id: <507BED18.3040509@samsung.com>
Date: Mon, 15 Oct 2012 13:01:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Ritesh Kumar Solanki <r.solanki@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] [media] s5p-csis: Added RAW data format as the supported
 format.
References: <1350294483-7417-1-git-send-email-r.solanki@samsung.com>
In-reply-to: <1350294483-7417-1-git-send-email-r.solanki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ritesh,

On 10/15/2012 11:48 AM, Ritesh Kumar Solanki wrote:
> csis can support jpeg, yuv and raw data format.
> 
> Signed-off-by: Ritesh Kumar Solanki <r.solanki@samsung.com>

Thanks for the patch. I already have a patch adding all three
raw Bayer formats (SGRBG8/10/12) at the driver and I plan it
for v3.8. So I'd like to use it instead of your patch.
I'll post it as soon as I get my development branch cleaned up.

Regards,
Sylwester

> ---
>  drivers/media/platform/s5p-fimc/mipi-csis.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
> index 2f73d9e..0205ae4 100644
> --- a/drivers/media/platform/s5p-fimc/mipi-csis.c
> +++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
> @@ -145,6 +145,10 @@ static const struct csis_pix_format s5pcsis_formats[] = {
>  		.code = V4L2_MBUS_FMT_JPEG_1X8,
>  		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
>  		.data_alignment = 32,
> +	}, {
> +		.code = V4L2_MBUS_FMT_SGRBG10_1X10,
> +		.fmt_reg = S5PCSIS_CFG_FMT_RAW10,
> +		.data_alignment = 24,
>  	},
>  };
