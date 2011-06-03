Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36664 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1FCWCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 18:02:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 PATCH 04/11] v4l2-ctrls: Replace v4l2_ctrl_activate/grab with v4l2_ctrl_flags.
Date: Fri, 3 Jun 2011 21:55:59 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl> <6170b5a8f168957ed3675d9976e434d227867d27.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <6170b5a8f168957ed3675d9976e434d227867d27.1306329390.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106032155.59717.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch.

On Wednesday 25 May 2011 15:33:48 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This more generic function makes it possible to have a single function
> that takes care of flags handling, in particular with regards to sending
> a control event when the flags change.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

[snip]

> +/** v4l2_ctrl_flags_lock() - Clear and set flags for a control.
> +  * @ctrl:	The control whose flags should be changed.
> +  * @clear_flags:	Mask out these flags.
> +  * @set_flags:	Set these flags.
>    *
> -  * This sets or clears the V4L2_CTRL_FLAG_GRABBED flag atomically.
> -  * Does nothing if @ctrl == NULL.
> -  * This will usually be called when starting or stopping streaming in the
> -  * driver.
> +  * This clears and sets flags. Does nothing if @ctrl == NULL.
>    *
> -  * This function can be called regardless of whether the control handler
> -  * is locked or not.
> +  * This function expects that the control handler is unlocked and will
> lock +  * it before changing flags.
>    */
> -void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
> +void v4l2_ctrl_flags_lock(struct v4l2_ctrl *ctrl, u32 clear_flags, u32
> set_flags);

The v4l2_ctrl_flags_lock() function doesn't seem to be used. Do we need it ?

-- 
Regards,

Laurent Pinchart
