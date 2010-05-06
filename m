Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:34917 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab0EFVx4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 17:53:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 01/15] [RFC] v4l: Add new control handling framework
Date: Thu, 6 May 2010 23:54:40 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1272267136.git.hverkuil@xs4all.nl> <d3991cad71df246827f973da01d42bccc0bb9481.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <d3991cad71df246827f973da01d42bccc0bb9481.1272267137.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005062354.41866.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I don't think I should review the code in details before we agree on the 
architecture (please correct me if I'm wrong). Two comments though.

On Monday 26 April 2010 09:33:30 Hans Verkuil wrote:

[snip]

> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> new file mode 100644
> index 0000000..ea23f3d
> --- /dev/null
> +++ b/include/media/v4l2-ctrls.h

[snip]

> +/* Fill in the control fields based on the control ID. This works for all
> +   standard V4L2 controls.
> +   For non-standard controls it will only fill in the given arguments
> +   and name will be NULL.
> +   This function will overwrite the contents of name, type and flags.
> +   The contents of min, max, step and def may be modified depending on
> +   the type.
> +   Do not use in drivers! It is used internally for backwards
> compatibility +   control handling only. Once all drivers are converted to
> use the new +   control framework this function will no longer be
> exported. */ +void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, +		    s32 *min, s32 *max, s32 *step, s32 *def, u32
> *flags);

Using kerneldoc comments in the source file would provide a much better 
documentation than a few lines of comment in the header.

[snip]

> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 2dee938..cc9ed09 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -27,6 +27,7 @@
>  struct v4l2_ioctl_callbacks;
>  struct video_device;
>  struct v4l2_device;
> +struct v4l2_ctrl_handler;
> 
>  /* Flag to mark the video_device struct as registered.
>     Drivers can clear this flag if they want to block all future
> @@ -66,6 +67,9 @@ struct video_device
>  	struct device *parent;		/* device parent */
>  	struct v4l2_device *v4l2_dev;	/* v4l2_device parent */
> 
> +	/* Control handler associated with this device node. May be NULL. */

Shouldn't we talk about a control*s* handler ? It handles more than one 
control (would be a bit pointless otherwise :-)).

-- 
Regards,

Laurent Pinchart
