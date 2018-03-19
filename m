Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:58479 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755765AbeCSOgu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 10:36:50 -0400
Subject: Re: [PATCH] s5p-mfc: Amend initial min, max values of HEVC
 hierarchical coding QP controls
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org
Cc: smitha.t@samsung.com, a.hajda@samsung.com,
        linux-samsung-soc@vger.kernel.org
References: <CGME20180319143010epcas2p25aa33888e29cc229adf272369b6e684b@epcas2p2.samsung.com>
 <20180319142958.21569-1-s.nawrocki@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a8e337ca-5f94-7f29-c0b0-68726996e63b@xs4all.nl>
Date: Mon, 19 Mar 2018 15:36:45 +0100
MIME-Version: 1.0
In-Reply-To: <20180319142958.21569-1-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2018 03:29 PM, Sylwester Nawrocki wrote:
> Valid range for those controls is specified in documentation as [0, 51],
> so initialize the controls to such range rather than [INT_MIN, INT_MAX].
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Huh, I missed this when I reviewed this earlier. Thanks for catching this!

Regards,

	Hans

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 810dabe2f1b9..7382b41f4f6d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -856,56 +856,56 @@ static struct mfc_control controls[] = {
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.minimum = INT_MIN,
> -		.maximum = INT_MAX,
> +		.minimum = 0,
> +		.maximum = 51,
>  		.step = 1,
>  		.default_value = 0,
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.minimum = INT_MIN,
> -		.maximum = INT_MAX,
> +		.minimum = 0,
> +		.maximum = 51,
>  		.step = 1,
>  		.default_value = 0,
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.minimum = INT_MIN,
> -		.maximum = INT_MAX,
> +		.minimum = 0,
> +		.maximum = 51,
>  		.step = 1,
>  		.default_value = 0,
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.minimum = INT_MIN,
> -		.maximum = INT_MAX,
> +		.minimum = 0,
> +		.maximum = 51,
>  		.step = 1,
>  		.default_value = 0,
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.minimum = INT_MIN,
> -		.maximum = INT_MAX,
> +		.minimum = 0,
> +		.maximum = 51,
>  		.step = 1,
>  		.default_value = 0,
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.minimum = INT_MIN,
> -		.maximum = INT_MAX,
> +		.minimum = 0,
> +		.maximum = 51,
>  		.step = 1,
>  		.default_value = 0,
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
> -		.minimum = INT_MIN,
> -		.maximum = INT_MAX,
> +		.minimum = 0,
> +		.maximum = 51,
>  		.step = 1,
>  		.default_value = 0,
>  	},
> 
