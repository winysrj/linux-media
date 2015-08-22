Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:33445 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbbHVCAT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 22:00:19 -0400
Date: Fri, 21 Aug 2015 20:55:14 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely at pobox <isely@pobox.com>
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
Subject: Re: [PATCH v2 07/10] media/usb/pvrusb2: Support for
 V4L2_CTRL_WHICH_DEF_VAL
In-Reply-To: <1440163169-18047-8-git-send-email-ricardo.ribalda@gmail.com>
Message-ID: <alpine.DEB.2.02.1508212048050.26546@cnc.isely.net>
References: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com> <1440163169-18047-8-git-send-email-ricardo.ribalda@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The code you've added is carefully checking the return pointer from 
pvr2_hdw_get_ctrl_v4l() yet the original code did not operate this way.  
The result is that now there's this "unbalanced" effect where it appears 
that the validity of the pvr2_ctrl instance is only checked on one side 
of the if-statement.  I would recommend instead to elevate the call to 
pvr2_hdw_get_ctrl_v4l() out of the if-statement - since in both cases 
it's being called the same way both times.  Then do the validity check 
in that one spot and that simplifies the if-statement all the way down 
to choosing between pvr2_ctrl_get_value() vs pvr2_ctrl_get_def().

It's not a correctness comment; what you have should work fine.  So I'm 
ack'ing this in any case:

Acked-By: Mike Isely <isely@pobox.com>

But you can do the above pretty easily & safely, and simplify it a bit 
further.

  -Mike


On Fri, 21 Aug 2015, Ricardo Ribalda Delgado wrote:

> This driver does not use the control infrastructure.
> Add support for the new field which on structure
>  v4l2_ext_controls
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> index 1c5f85bf7ed4..43b2f2214798 100644
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
> @@ -635,8 +636,18 @@ static int pvr2_g_ext_ctrls(struct file *file, void *priv,
>  	ret = 0;
>  	for (idx = 0; idx < ctls->count; idx++) {
>  		ctrl = ctls->controls + idx;
> -		ret = pvr2_ctrl_get_value(
> +		if (ctls->which == V4L2_CTRL_WHICH_DEF_VAL) {
> +			cptr = pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id);
> +			if (cptr)
> +				pvr2_ctrl_get_def(cptr, &val);
> +			else
> +				ret = -EINVAL;
> +
> +
> +		} else
> +			ret = pvr2_ctrl_get_value(
>  				pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id), &val);
> +
>  		if (ret) {
>  			ctls->error_idx = idx;
>  			return ret;
> @@ -658,6 +669,10 @@ static int pvr2_s_ext_ctrls(struct file *file, void *priv,
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
