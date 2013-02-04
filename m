Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48785 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3BCPoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:44:06 -0500
Received: by mail-pa0-f42.google.com with SMTP id kq12so77922pab.15
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:44:06 -0800 (PST)
Message-ID: <510F3D6D.3000408@gmail.com>
Date: Sun, 03 Feb 2013 23:47:41 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 06/18] tlg2300: add control handler for radio device
 node.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <6f3366e175ce5a8ff0dd4c959e2128f851723283.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <6f3366e175ce5a8ff0dd4c959e2128f851723283.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-common.h |    2 +
>  drivers/media/usb/tlg2300/pd-radio.c  |  112 ++++++++-------------------------
>  2 files changed, 28 insertions(+), 86 deletions(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
> index 3a89128..b26082a 100644
> --- a/drivers/media/usb/tlg2300/pd-common.h
> +++ b/drivers/media/usb/tlg2300/pd-common.h
> @@ -10,6 +10,7 @@
>  #include <linux/poll.h>
>  #include <media/videobuf-vmalloc.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-ctrls.h>
>  
>  #include "dvb_frontend.h"
>  #include "dvbdev.h"
> @@ -119,6 +120,7 @@ struct radio_data {
>  	unsigned int	is_radio_streaming;
>  	int		pre_emphasis;
>  	struct video_device fm_dev;
> +	struct v4l2_ctrl_handler ctrl_handler;
>  };
>  
>  #define DVB_SBUF_NUM		4
> diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> index 719c3da..45b3d7a 100644
> --- a/drivers/media/usb/tlg2300/pd-radio.c
> +++ b/drivers/media/usb/tlg2300/pd-radio.c
> @@ -261,104 +261,34 @@ static int fm_set_freq(struct file *file, void *priv,
>  	return set_frequency(p, argp->frequency);
>  }
>  
> -static int tlg_fm_vidioc_g_ctrl(struct file *file, void *priv,
> -		struct v4l2_control *arg)
> +static int tlg_fm_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> -	return 0;
> -}
> -
> -static int tlg_fm_vidioc_g_exts_ctrl(struct file *file, void *fh,
> -				struct v4l2_ext_controls *ctrls)
> -{
> -	struct poseidon *p = file->private_data;
> -	int i;
> -
> -	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
> -		return -EINVAL;
> -
> -	for (i = 0; i < ctrls->count; i++) {
> -		struct v4l2_ext_control *ctrl = ctrls->controls + i;
> -
> -		if (ctrl->id != V4L2_CID_TUNE_PREEMPHASIS)
> -			continue;
> -
> -		if (i < MAX_PREEMPHASIS)
> -			ctrl->value = p->radio_data.pre_emphasis;
> -	}
> -	return 0;
> -}
> -
> -static int tlg_fm_vidioc_s_exts_ctrl(struct file *file, void *fh,
> -			struct v4l2_ext_controls *ctrls)
> -{
> -	int i;
> -
> -	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
> -		return -EINVAL;
> -
> -	for (i = 0; i < ctrls->count; i++) {
> -		struct v4l2_ext_control *ctrl = ctrls->controls + i;
> -
> -		if (ctrl->id != V4L2_CID_TUNE_PREEMPHASIS)
> -			continue;
> -
> -		if (ctrl->value >= 0 && ctrl->value < MAX_PREEMPHASIS) {
> -			struct poseidon *p = file->private_data;
> -			int pre_emphasis = preemphasis[ctrl->value];
> -			u32 status;
> -
> -			send_set_req(p, TUNER_AUD_ANA_STD,
> -						pre_emphasis, &status);
> -			p->radio_data.pre_emphasis = pre_emphasis;
> -		}
> -	}
> -	return 0;
> -}
> -
> -static int tlg_fm_vidioc_s_ctrl(struct file *file, void *priv,
> -		struct v4l2_control *ctrl)
> -{
> -	return 0;
> -}
> -
> -static int tlg_fm_vidioc_queryctrl(struct file *file, void *priv,
> -		struct v4l2_queryctrl *ctrl)
> -{
> -	if (!(ctrl->id & V4L2_CTRL_FLAG_NEXT_CTRL))
> -		return -EINVAL;
> +	struct poseidon *p = container_of(ctrl->handler, struct poseidon,
> +						radio_data.ctrl_handler);
> +	int pre_emphasis;
> +	u32 status;
>  
> -	ctrl->id &= ~V4L2_CTRL_FLAG_NEXT_CTRL;
> -	if (ctrl->id != V4L2_CID_TUNE_PREEMPHASIS) {
> -		/* return the next supported control */
> -		ctrl->id = V4L2_CID_TUNE_PREEMPHASIS;
> -		v4l2_ctrl_query_fill(ctrl, V4L2_PREEMPHASIS_DISABLED,
> -					V4L2_PREEMPHASIS_75_uS, 1,
> -					V4L2_PREEMPHASIS_50_uS);
> -		ctrl->flags = V4L2_CTRL_FLAG_UPDATE;
> +	switch (ctrl->id) {
> +	case V4L2_CID_TUNE_PREEMPHASIS:
> +		pre_emphasis = preemphasis[ctrl->val];
> +		send_set_req(p, TUNER_AUD_ANA_STD, pre_emphasis, &status);
> +		p->radio_data.pre_emphasis = pre_emphasis;
>  		return 0;
>  	}
>  	return -EINVAL;
>  }
>  
> -static int tlg_fm_vidioc_querymenu(struct file *file, void *fh,
> -				struct v4l2_querymenu *qmenu)
> -{
> -	return v4l2_ctrl_query_menu(qmenu, NULL, NULL);
> -}
> -
>  static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
>  {
>  	return vt->index > 0 ? -EINVAL : 0;
>  }
>  
> +static const struct v4l2_ctrl_ops tlg_fm_ctrl_ops = {
> +	.s_ctrl = tlg_fm_s_ctrl,
> +};
> +
>  static const struct v4l2_ioctl_ops poseidon_fm_ioctl_ops = {
>  	.vidioc_querycap    = vidioc_querycap,
> -	.vidioc_queryctrl   = tlg_fm_vidioc_queryctrl,
> -	.vidioc_querymenu   = tlg_fm_vidioc_querymenu,
> -	.vidioc_g_ctrl      = tlg_fm_vidioc_g_ctrl,
> -	.vidioc_s_ctrl      = tlg_fm_vidioc_s_ctrl,
> -	.vidioc_s_ext_ctrls = tlg_fm_vidioc_s_exts_ctrl,
> -	.vidioc_g_ext_ctrls = tlg_fm_vidioc_g_exts_ctrl,
>  	.vidioc_s_tuner     = vidioc_s_tuner,
>  	.vidioc_g_tuner     = tlg_fm_vidioc_g_tuner,
>  	.vidioc_g_frequency = fm_get_freq,
> @@ -376,16 +306,26 @@ static struct video_device poseidon_fm_template = {
>  int poseidon_fm_init(struct poseidon *p)
>  {
>  	struct video_device *vfd = &p->radio_data.fm_dev;
> +	struct v4l2_ctrl_handler *hdl = &p->radio_data.ctrl_handler;
>  
>  	*vfd = poseidon_fm_template;
> -	vfd->v4l2_dev	= &p->v4l2_dev;
> -	video_set_drvdata(vfd, p);
>  
>  	set_frequency(p, TUNER_FREQ_MIN_FM);
> +	v4l2_ctrl_handler_init(hdl, 1);
> +	v4l2_ctrl_new_std_menu(hdl, &tlg_fm_ctrl_ops, V4L2_CID_TUNE_PREEMPHASIS,
> +			V4L2_PREEMPHASIS_75_uS, 0, V4L2_PREEMPHASIS_50_uS);
> +	if (hdl->error) {
> +		v4l2_ctrl_handler_free(hdl);
> +		return hdl->error;
> +	}
> +	vfd->v4l2_dev = &p->v4l2_dev;
> +	vfd->ctrl_handler = hdl;
> +	video_set_drvdata(vfd, p);
>  	return video_register_device(vfd, VFL_TYPE_RADIO, -1);
>  }
>  
>  int poseidon_fm_exit(struct poseidon *p)
>  {
> +	v4l2_ctrl_handler_free(&p->radio_data.ctrl_handler);
>  	return 0;
>  }
Acked-by: Huang Shijie <shijie8@gmail.com>
