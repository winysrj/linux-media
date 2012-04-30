Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:15351 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2D3PUq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 11:20:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v3 01/14] V4L: Add helper function for standard integer menu controls
Date: Mon, 30 Apr 2012 17:20:34 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <1335536611-4298-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1335536611-4298-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301720.34275.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester!

Can you also update Documentation/video4linux/v4l2-controls.txt?

Thanks,

	Hans


On Friday 27 April 2012 16:23:18 Sylwester Nawrocki wrote:
> This patch adds v4l2_ctrl_new_std_int_menu() helper function which can
> be used in drivers for creating standard integer menu control. It is
> similar to v4l2_ctrl_new_std_menu(), except it doesn't have a mask
> parameter and an additional qmenu parameter allows passing an array
> of signed 64-bit integers constituting the menu items.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |   21 +++++++++++++++++++++
>  include/media/v4l2-ctrls.h       |   17 +++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index c93a979..e0725b5 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -1517,6 +1517,27 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
>  
> +/* Helper function for standard integer menu controls */
> +struct v4l2_ctrl *v4l2_ctrl_new_std_int_menu(struct v4l2_ctrl_handler *hdl,
> +			const struct v4l2_ctrl_ops *ops,
> +			u32 id, s32 max, s32 def, const s64 *qmenu_int)
> +{
> +	const char *name;
> +	enum v4l2_ctrl_type type;
> +	s32 min;
> +	s32 step;
> +	u32 flags;
> +
> +	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
> +	if (type != V4L2_CTRL_TYPE_INTEGER_MENU) {
> +		handler_set_err(hdl, -EINVAL);
> +		return NULL;
> +	}
> +	return v4l2_ctrl_new(hdl, ops, id, name, type,
> +			     0, max, 0, def, flags, NULL, qmenu_int, NULL);
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_new_std_int_menu);
> +
>  /* Add a control from another handler to this handler */
>  struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
>  					  struct v4l2_ctrl *ctrl)
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 8920f82..15116d2 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -347,6 +347,23 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
>  			const struct v4l2_ctrl_ops *ops,
>  			u32 id, s32 max, s32 mask, s32 def);
>  
> +/** v4l2_ctrl_new_std_int_menu() - Create a new standard V4L2 integer menu control.
> +  * @hdl:	The control handler.
> +  * @ops:	The control ops.
> +  * @id:	The control ID.
> +  * @max:	The control's maximum value.
> +  * @def:	The control's default value.
> +  * @qmenu_int:	The control's menu entries.
> +  *
> +  * Same as v4l2_ctrl_new_std_menu(), but @mask is set to 0 and it additionaly
> +  * needs an array of integers determining the menu entries.
> +  *
> +  * If @id refers to a non-integer-menu control, then this function will return NULL.
> +  */
> +struct v4l2_ctrl *v4l2_ctrl_new_std_int_menu(struct v4l2_ctrl_handler *hdl,
> +			const struct v4l2_ctrl_ops *ops,
> +			u32 id, s32 max, s32 def, const s64 *qmenu_int);
> +
>  /** v4l2_ctrl_add_ctrl() - Add a control from another handler to this handler.
>    * @hdl:	The control handler.
>    * @ctrl:	The control to add.
> 
