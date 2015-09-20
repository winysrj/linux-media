Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53949 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752704AbbITHtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2015 03:49:17 -0400
Date: Sun, 20 Sep 2015 10:49:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [Patch] media: v4l2-ctrls: Fix 64bit support in get_ctrl()
Message-ID: <20150920074908.GN3175@valkosipuli.retiisi.org.uk>
References: <1442444299-25054-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1442444299-25054-1-git-send-email-bparrot@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benoit,

On Wed, Sep 16, 2015 at 05:58:19PM -0500, Benoit Parrot wrote:
> When trying to use v4l2_ctrl_g_ctrl_int64() to retrieve a
> V4L2_CTRL_TYPE_INTEGER64 type value the internal helper function
> get_ctrl() would prematurely exits because for this control type
> the 'is_int' flag is not set. This would result in v4l2_ctrl_g_ctrl_int64
> always returning 0.
> 
> This patch extend the condition check to allow V4L2_CTRL_TYPE_INTEGER64
> type to continue processing instead of exiting.
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b6b7dcc1b77d..989919c44c2f 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2884,7 +2884,7 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
>  	 * cur_to_user() calls below would need to be modified not to access
>  	 * userspace memory when called from get_ctrl().
>  	 */
> -	if (!ctrl->is_int)
> +	if (!ctrl->is_int && ctrl->type != V4L2_CTRL_TYPE_INTEGER64)
>  		return -EINVAL;
>  
>  	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)

Well spotted.

However, this does not appear to be the only problem with
v4l2_ctrl_g_ctrl_int64(). It accesses the 32-bit value field instead of
value64. While at it, could you fix that one as well?

I wonder how this could have happened. :-o

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
