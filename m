Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41457 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635AbcANIxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 03:53:13 -0500
Subject: Re: [PATCH v2 2/2] s5p-mfc: add the support of
 V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.
To: Wu-Cheng Li <wuchengli@chromium.org>, pawel@osciak.com,
	mchehab@osg.samsung.com, k.debski@samsung.com, crope@iki.fi,
	standby24x7@gmail.com, nicolas.dufresne@collabora.com,
	ricardo.ribalda@gmail.com, ao2@ao2.it, bparrot@ti.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com
References: <1452760439-35564-1-git-send-email-wuchengli@chromium.org>
 <1452760439-35564-3-git-send-email-wuchengli@chromium.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	tiffany.lin@mediatek.com, djkurtz@chromium.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569762CE.2000104@xs4all.nl>
Date: Thu, 14 Jan 2016 09:56:46 +0100
MIME-Version: 1.0
In-Reply-To: <1452760439-35564-3-git-send-email-wuchengli@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/14/16 09:33, Wu-Cheng Li wrote:
> Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 0434f02..de1d68d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -212,6 +212,15 @@ static struct mfc_control controls[] = {
>  		.menu_skip_mask = 0,
>  	},
>  	{
> +		.id = V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME,
> +		.type = V4L2_CTRL_TYPE_BUTTON,
> +		.name = "Force an I frame",

Drop the name: this is a standard control, so the name will be filled in from
v4l2-ctrls.c.

Regards,

	Hans

> +		.minimum = 0,
> +		.maximum = 0,
> +		.step = 0,
> +		.default_value = 0,
> +	},
> +	{
>  		.id = V4L2_CID_MPEG_VIDEO_VBV_SIZE,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
>  		.minimum = 0,
> @@ -1423,6 +1432,10 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
>  		ctx->force_frame_type = ctrl->val;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME:
> +		ctx->force_frame_type
> +			= V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME;
> +		break;
>  	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
>  		p->vbv_size = ctrl->val;
>  		break;
> 
