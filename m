Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:55771 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727109AbeJDSJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 14:09:42 -0400
Subject: Re: [PATCH 2/2] media: vivid: Add 16-bit bayer to format list
To: bwinther@cisco.com, linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com
References: <20181004110114.3150-1-bwinther@cisco.com>
 <20181004110114.3150-2-bwinther@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <00c43925-6e3e-9dcb-37e5-5d48863937f4@xs4all.nl>
Date: Thu, 4 Oct 2018 13:16:48 +0200
MIME-Version: 1.0
In-Reply-To: <20181004110114.3150-2-bwinther@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/18 13:01, bwinther@cisco.com wrote:
> From: Bård Eirik Winther <bwinther@cisco.com>
> 

Same here: missing commit message.

This patch looks good otherwise.

Regards,

	Hans

> Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
> ---
>  .../media/platform/vivid/vivid-vid-common.c   | 28 +++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
> index 27a0000a5973..9645a91b8782 100644
> --- a/drivers/media/platform/vivid/vivid-vid-common.c
> +++ b/drivers/media/platform/vivid/vivid-vid-common.c
> @@ -449,6 +449,34 @@ struct vivid_fmt vivid_formats[] = {
>  		.planes   = 1,
>  		.buffers = 1,
>  	},
> +	{
> +		.fourcc   = V4L2_PIX_FMT_SBGGR16, /* Bayer BG/GR */
> +		.vdownsampling = { 1 },
> +		.bit_depth = { 16 },
> +		.planes   = 1,
> +		.buffers = 1,
> +	},
> +	{
> +		.fourcc   = V4L2_PIX_FMT_SGBRG16, /* Bayer GB/RG */
> +		.vdownsampling = { 1 },
> +		.bit_depth = { 16 },
> +		.planes   = 1,
> +		.buffers = 1,
> +	},
> +	{
> +		.fourcc   = V4L2_PIX_FMT_SGRBG16, /* Bayer GR/BG */
> +		.vdownsampling = { 1 },
> +		.bit_depth = { 16 },
> +		.planes   = 1,
> +		.buffers = 1,
> +	},
> +	{
> +		.fourcc   = V4L2_PIX_FMT_SRGGB16, /* Bayer RG/GB */
> +		.vdownsampling = { 1 },
> +		.bit_depth = { 16 },
> +		.planes   = 1,
> +		.buffers = 1,
> +	},
>  	{
>  		.fourcc   = V4L2_PIX_FMT_HSV24, /* HSV 24bits */
>  		.color_enc = TGP_COLOR_ENC_HSV,
> 
