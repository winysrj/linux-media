Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:40890 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089AbbJ2Piu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 11:38:50 -0400
Date: Thu, 29 Oct 2015 10:33:46 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH v2 5/6] media/usb/pvrusb2: Support for
 V4L2_CTRL_WHICH_DEF_VAL
In-Reply-To: <1446113432-27390-6-git-send-email-ricardo.ribalda@gmail.com>
Message-ID: <alpine.DEB.2.02.1510291032010.334@cnc.isely.net>
References: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com> <1446113432-27390-6-git-send-email-ricardo.ribalda@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Looks good to me (still), including now the change I had previously 
suggested.  For the record, the ack still applies.  (I guess you can 
consider this to be an ack of the ack...)

  -Mike


On Thu, 29 Oct 2015, Ricardo Ribalda Delgado wrote:

> This driver does not use the control infrastructure.
> Add support for the new field which on structure
>  v4l2_ext_controls
> 
> Acked-by: Mike Isely <isely@pobox.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> index 1c5f85bf7ed4..81f788b7b242 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> @@ -628,6 +628,7 @@ static int pvr2_g_ext_ctrls(struct file *file, void *priv,
>  	struct pvr2_v4l2_fh *fh = file->private_data;
>  	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
>  	struct v4l2_ext_control *ctrl;
> +	struct pvr2_ctrl *cptr;
>  	unsigned int idx;
>  	int val;
>  	int ret;
> @@ -635,8 +636,15 @@ static int pvr2_g_ext_ctrls(struct file *file, void *priv,
>  	ret = 0;
>  	for (idx = 0; idx < ctls->count; idx++) {
>  		ctrl = ctls->controls + idx;
> -		ret = pvr2_ctrl_get_value(
> -				pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id), &val);
> +		cptr = pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id);
> +		if (cptr) {
> +			if (ctls->which == V4L2_CTRL_WHICH_DEF_VAL)
> +				pvr2_ctrl_get_def(cptr, &val);
> +			else
> +				ret = pvr2_ctrl_get_value(cptr, &val);
> +		} else
> +			ret = -EINVAL;
> +
>  		if (ret) {
>  			ctls->error_idx = idx;
>  			return ret;
> @@ -658,6 +666,10 @@ static int pvr2_s_ext_ctrls(struct file *file, void *priv,
>  	unsigned int idx;
>  	int ret;
>  
> +	/* Default value cannot be changed */
> +	if (ctls->which == V4L2_CTRL_WHICH_DEF_VAL)
> +		return -EINVAL;
> +
>  	ret = 0;
>  	for (idx = 0; idx < ctls->count; idx++) {
>  		ctrl = ctls->controls + idx;
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
