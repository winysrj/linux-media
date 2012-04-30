Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:24950 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2D3QJR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 12:09:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v3 14/14] vivi: Add controls
Date: Mon, 30 Apr 2012 18:09:04 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <1335536611-4298-15-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1335536611-4298-15-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301809.04891.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 April 2012 16:23:31 Sylwester Nawrocki wrote:
> This patch is just for testing the new controls, it is NOT
> intended for merging upstream.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/vivi.c |  111 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 110 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> index d64d482..cbe103e 100644
> --- a/drivers/media/video/vivi.c
> +++ b/drivers/media/video/vivi.c
> @@ -179,6 +179,29 @@ struct vivi_dev {
>  	struct v4l2_ctrl	   *bitmask;
>  	struct v4l2_ctrl	   *int_menu;
>  
> +	struct v4l2_ctrl	   *exposure_bias;
> +	struct v4l2_ctrl	   *metering;
> +	struct v4l2_ctrl	   *wb_preset;
> +	struct {
> +		/* iso/auto iso cluster */
> +		struct v4l2_ctrl  *auto_iso;
> +		struct v4l2_ctrl  *iso;
> +	};
> +	struct {
> +		/* continuous auto focus/auto focus cluster */
> +		struct v4l2_ctrl  *focus_auto;
> +		struct v4l2_ctrl  *af_start;
> +		struct v4l2_ctrl  *af_stop;
> +		struct v4l2_ctrl  *af_status;
> +		struct v4l2_ctrl  *af_distance;
> +		struct v4l2_ctrl  *af_area;
> +	};
> +	struct v4l2_ctrl	  *scene_mode;
> +	struct v4l2_ctrl	  *lock_3a;
> +	struct v4l2_ctrl	  *colorfx;
> +	struct v4l2_ctrl	  *wdr;
> +	struct v4l2_ctrl	  *stabilization;
> +

Why add these controls to vivi? It doesn't belong here.

Regards,

	Hans

>  	spinlock_t                 slock;
>  	struct mutex		   mutex;
>  
> @@ -208,6 +231,14 @@ struct vivi_dev {
>  	u8 			   line[MAX_WIDTH * 4];
>  };
>  
> +static const s64 vivi_iso_qmenu[] = {
> +	50, 100, 200, 400, 800, 1600
> +};
> +
> +static const s64 vivi_ev_bias_qmenu[] = {
> +	-1500, -1000, -500, 0, 500, 1000, 1500
> +};
> +
>  /* ------------------------------------------------------------------
>  	DMA and thread functions
>     ------------------------------------------------------------------*/
> @@ -516,6 +547,10 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
>  		gen_text(dev, vbuf, line++ * 16, 16, str);
>  	}
>  
> +	snprintf(str, sizeof(str), " auto iso: %s, iso: %lld ",
> +		 dev->auto_iso->cur.val ? "on" : "off",
> +		 vivi_iso_qmenu[dev->iso->cur.val]);
> +
>  	dev->mv_count += 2;
>  
>  	buf->vb.v4l2_buf.field = dev->field;
> @@ -1023,6 +1058,13 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
>  
>  	if (ctrl == dev->button)
>  		dev->button_pressed = 30;
> +
> +	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
> +		return 0;
> +
> +	dprintk(dev, 1, "%s: control: %s, val: %d, val64: %lld",
> +		__func__, ctrl->name, ctrl->val, ctrl->val64);
> +
>  	return 0;
>  }
>  
> @@ -1267,7 +1309,8 @@ static int __init vivi_create_instance(int inst)
>  	dev->width = 640;
>  	dev->height = 480;
>  	hdl = &dev->ctrl_handler;
> -	v4l2_ctrl_handler_init(hdl, 11);
> +	v4l2_ctrl_handler_init(hdl, 26);
> +
>  	dev->volume = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
>  			V4L2_CID_AUDIO_VOLUME, 0, 255, 1, 200);
>  	dev->brightness = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
> @@ -1290,11 +1333,77 @@ static int __init vivi_create_instance(int inst)
>  	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
>  	dev->bitmask = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_bitmask, NULL);
>  	dev->int_menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int_menu, NULL);
> +
> +	dev->wb_preset = v4l2_ctrl_new_std_menu(hdl,
> +			&vivi_ctrl_ops, V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
> +			9, ~0x3ff, V4L2_WHITE_BALANCE_AUTO);
> +
> +	dev->exposure_bias = v4l2_ctrl_new_std_int_menu(hdl,
> +			&vivi_ctrl_ops, V4L2_CID_AUTO_EXPOSURE_BIAS,
> +			ARRAY_SIZE(vivi_ev_bias_qmenu) - 1,
> +			ARRAY_SIZE(vivi_ev_bias_qmenu)/2 - 1,
> +			vivi_ev_bias_qmenu);
> +
> +	dev->metering = v4l2_ctrl_new_std_menu(hdl,
> +			&vivi_ctrl_ops, V4L2_CID_EXPOSURE_METERING,
> +			2, ~0x7, V4L2_EXPOSURE_METERING_AVERAGE);
> +
> +	/* ISO cluster */
> +	dev->auto_iso = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_ISO_SENSITIVITY_AUTO, 0, 1, 1, 1);
> +
> +	dev->iso = v4l2_ctrl_new_std_int_menu(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(vivi_iso_qmenu) - 1,
> +			ARRAY_SIZE(vivi_iso_qmenu)/2 - 1, vivi_iso_qmenu);
> +
> +	/* Auto focus cluster */
> +	dev->focus_auto = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_FOCUS_AUTO, 0, 1, 1, 0);
> +
> +	dev->af_start = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_AUTO_FOCUS_START, 0, 1, 1, 0);
> +
> +	dev->af_stop = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_AUTO_FOCUS_STOP, 0, 1, 1, 0);
> +
> +	dev->af_status = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_AUTO_FOCUS_STATUS, 0, 0x07, 0, 0);
> +
> +	dev->af_distance = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_AUTO_FOCUS_DISTANCE,
> +			2, 0, V4L2_AUTO_FOCUS_DISTANCE_NORMAL);
> +
> +	dev->af_area = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_AUTO_FOCUS_AREA, 1, 0,
> +			V4L2_AUTO_FOCUS_AREA_ALL);
> +
> +	dev->colorfx = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_COLORFX, 15, 0, V4L2_COLORFX_NONE);
> +
> +	dev->wdr = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_WIDE_DYNAMIC_RANGE, 1, 0, 0);
> +
> +	dev->stabilization = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_IMAGE_STABILIZATION, 1, 0, 0);
> +
> +	dev->lock_3a = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_3A_LOCK, 0, 0x7, 0, 0);
> +
> +	dev->scene_mode = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
> +			V4L2_CID_SCENE_MODE, 13, ~0x1fff,
> +			V4L2_SCENE_MODE_NONE);
> +
>  	if (hdl->error) {
>  		ret = hdl->error;
>  		goto unreg_dev;
>  	}
>  	v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
> +
> +	v4l2_ctrl_auto_cluster(2, &dev->auto_iso, 0, false);
> +	dev->af_status->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +	v4l2_ctrl_cluster(6, &dev->focus_auto);
> +	dev->lock_3a->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +
>  	dev->v4l2_dev.ctrl_handler = hdl;
>  
>  	/* initialize locks */
> 
