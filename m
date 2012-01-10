Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1958 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab2AJUwC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 15:52:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l: Ignore ctrl_class in the control framework
Date: Tue, 10 Jan 2012 21:51:43 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teturtia@gmail.com
References: <1326222862-15936-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1326222862-15936-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201102151.43106.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, January 10, 2012 20:14:22 Sakari Ailus wrote:
> Back in the old days there was probably a reason to require that controls
> that are being used to access using VIDIOC_{TRY,G,S}_EXT_CTRLS belonged to
> the same class. These days such reason does not exist, or at least cannot be
> remembered, and concrete examples of the opposite can be seen: a single
> (sub)device may well offer controls that belong to different classes and
> there is no reason to deny changing them atomically.
> 
> This patch removes the check for v4l2_ext_controls.ctrl_class in the control
> framework. The control framework issues the s_ctrl() op to the drivers
> separately so changing the behaviour does not really change how this works
> from the drivers' perspective.

What is the rationale of this patch? It does change the behavior of the API.
There are still some drivers that use the extended control API without the
control framework (pvrusb2, and some other cx2341x-based drivers), and that
do test the ctrl_class argument.

I don't see any substantial gain by changing the current behavior of the
control framework.

Apps can just set ctrl_class to 0 and then the control framework will no
longer check the control class. And yes, this still has to be properly
documented in the spec.

The reason for the ctrl_class check is that without the control framework it
was next to impossible to allow atomic setting of controls of different
classes, since control of different classes would typically also be handled
by different drivers. By limiting the controls to one class it made it much
easier for drivers to implement this API.

Regards,

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/v4l2-ctrls.c |   18 +++++-------------
>  1 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index da1f4c2..fff3bb3 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -1855,9 +1855,6 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  
>  		cs->error_idx = i;
>  
> -		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
> -			return -EINVAL;
> -
>  		/* Old-style private controls are not allowed for
>  		   extended controls */
>  		if (id >= V4L2_CID_PRIVATE_BASE)
> @@ -1918,13 +1915,10 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  }
>  
>  /* Handles the corner case where cs->count == 0. It checks whether the
> -   specified control class exists. If that class ID is 0, then it checks
> -   whether there are any controls at all. */
> -static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
> +   there are any controls at all. */
> +static int handler_check(struct v4l2_ctrl_handler *hdl)
>  {
> -	if (ctrl_class == 0)
> -		return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
> -	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
> +	return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
>  }
>  
>  
> @@ -1938,13 +1932,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  	int i, j;
>  
>  	cs->error_idx = cs->count;
> -	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
>  
>  	if (hdl == NULL)
>  		return -EINVAL;
>  
>  	if (cs->count == 0)
> -		return class_check(hdl, cs->ctrl_class);
> +		return handler_check(hdl);
>  
>  	if (cs->count > ARRAY_SIZE(helper)) {
>  		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
> @@ -2160,13 +2153,12 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  	int ret;
>  
>  	cs->error_idx = cs->count;
> -	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
>  
>  	if (hdl == NULL)
>  		return -EINVAL;
>  
>  	if (cs->count == 0)
> -		return class_check(hdl, cs->ctrl_class);
> +		return handler_check(hdl);
>  
>  	if (cs->count > ARRAY_SIZE(helper)) {
>  		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
> 
