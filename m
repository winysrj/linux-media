Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:41175 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727321AbeIDLEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:06 -0400
Subject: Re: [PATCH v2] media: vimc: implement basic v4l2-ctrls
To: Guilherme Gallo <gagallo7@gmail.com>,
        Helen Koike <helen.koike@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: lkcamp@lists.libreplanetbr.org
References: <20180904014559.15765-1-gagallo7@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <529ce419-bba7-7e90-cb7d-e9a94fe64ac2@xs4all.nl>
Date: Tue, 4 Sep 2018 08:40:20 +0200
MIME-Version: 1.0
In-Reply-To: <20180904014559.15765-1-gagallo7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guilherme,

On 09/04/2018 03:45 AM, Guilherme Gallo wrote:
> Add brightness, contrast, hue and saturation controls in vimc-sensor
> 
> Signed-off-by: Guilherme Alcarde Gallo <gagallo7@gmail.com>
> Signed-off-by: Guilherme Gallo <gagallo7@gmail.com>

Looks good, but you have (probably unintended) two Signed-off-by lines.
Just let me know which one I should use and I'll drop the other one.

Regards,

	Hans

> ---
>  drivers/media/platform/vimc/vimc-sensor.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index b2b89315e7ba..edf4c85ae63d 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -317,6 +317,18 @@ static int vimc_sen_s_ctrl(struct v4l2_ctrl *ctrl)
>  	case V4L2_CID_VFLIP:
>  		tpg_s_vflip(&vsen->tpg, ctrl->val);
>  		break;
> +	case V4L2_CID_BRIGHTNESS:
> +		tpg_s_brightness(&vsen->tpg, ctrl->val);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		tpg_s_contrast(&vsen->tpg, ctrl->val);
> +		break;
> +	case V4L2_CID_HUE:
> +		tpg_s_hue(&vsen->tpg, ctrl->val);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		tpg_s_saturation(&vsen->tpg, ctrl->val);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -378,6 +390,14 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
>  			  V4L2_CID_VFLIP, 0, 1, 1, 0);
>  	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
>  			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
> +	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
> +			  V4L2_CID_CONTRAST, 0, 255, 1, 128);
> +	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
> +			  V4L2_CID_HUE, -128, 127, 1, 0);
> +	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
> +			  V4L2_CID_SATURATION, 0, 255, 1, 128);
>  	vsen->sd.ctrl_handler = &vsen->hdl;
>  	if (vsen->hdl.error) {
>  		ret = vsen->hdl.error;
> 
