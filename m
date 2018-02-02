Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:10288 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753009AbeBBWUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Feb 2018 17:20:23 -0500
Date: Sat, 3 Feb 2018 00:20:20 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l2-ctrls.h: remove wrong copy-and-paste comment
Message-ID: <20180202222020.6gfetzk7gg7gzefj@kekkonen.localdomain>
References: <b7bd5b6b-9fcf-318e-634b-0ee3b71523ae@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7bd5b6b-9fcf-318e-634b-0ee3b71523ae@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Feb 02, 2018 at 03:11:48PM +0100, Hans Verkuil wrote:
> The __v4l2_ctrl_modify_range is the unlocked variant, so the comment about
> taking a lock is obviously wrong.

The comment is wrong but I don't think it's a good idea either to leave the
matter undocumented.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 5253b5471897..33ce194a7481 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -760,9 +760,6 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
>   *
>   * An error is returned if one of the range arguments is invalid for this
>   * control type.
> - *
> - * This function assumes that the control handler is not locked and will
> - * take the lock itself.

How about:

    * The caller must be holding the control handler lock before calling
    * this function.

With that or something alike,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>   */
>  int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>  			     s64 min, s64 max, u64 step, s64 def);

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
