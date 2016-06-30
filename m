Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59079 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbcF3GmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 02:42:01 -0400
Subject: Re: [PATCH] media: s5p-mfc fix vidioc_g_crop() to return crop info.
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@kernel.org,
	javier@osg.samsung.com
References: <1467243236-13395-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b6cc61d-836c-26f6-e6b9-269f5cb2be62@xs4all.nl>
Date: Thu, 30 Jun 2016 08:38:13 +0200
MIME-Version: 1.0
In-Reply-To: <1467243236-13395-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/30/2016 01:33 AM, Shuah Khan wrote:
> Fix vidioc_g_crop() to report crop information irrepective of ctx state.
> g_crop is expected to return crop information as long as the passed in
> v4l2_crop type field is vV4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index a01a373..4ace9e1 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -774,12 +774,9 @@ static int vidioc_g_crop(struct file *file, void *priv,
>  	struct s5p_mfc_dev *dev = ctx->dev;
>  	u32 left, right, top, bottom;
>  
> -	if (ctx->state != MFCINST_HEAD_PARSED &&
> -	ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
> -					&& ctx->state != MFCINST_FINISHED) {
> -			mfc_err("Cannont set crop\n");
> -			return -EINVAL;
> -		}

Well, without this information all you can do is to return a fake rectangle.
The decoder needs to have parsed the header to know the size.

> +	if (cr->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)

Actually, this should be V4L2_BUF_TYPE_VIDEO_OUTPUT. See the spec.

I actually wonder why there is a g_crop at all since without a s_crop it doesn't
provide any useful information.

And if it is needed, then g_selection is the right callback since g_crop for
output provides the compose rectangle, not the crop rectangle (one of the
reasons we introduced g/s_selection).

Regards,

	Hans

> +		return -EINVAL;
> +
>  	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
>  		left = s5p_mfc_hw_call(dev->mfc_ops, get_crop_info_h, ctx);
>  		right = left >> S5P_FIMV_SHARED_CROP_RIGHT_SHIFT;
> 
