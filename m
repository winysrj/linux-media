Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:45307 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbeIZRZY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 13:25:24 -0400
Subject: Re: [PATCH 1/2] v4l: ctrl: Remove old documentation from
 v4l2_ctrl_grab
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20180926080937.19501-1-sakari.ailus@linux.intel.com>
 <20180926080937.19501-2-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4d2a6d01-fd41-6e52-9b03-a463a29dddd4@xs4all.nl>
Date: Wed, 26 Sep 2018 13:12:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180926080937.19501-2-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2018 10:09 AM, Sakari Ailus wrote:
> v4l2_ctrl_grab() is documented in the header; there's no need to have a
> comment explaining what the function does in the .c file.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ee006d34c19f..ab393adf51eb 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2511,12 +2511,6 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_activate);
>  
> -/* Grab/ungrab a control.
> -   Typically used when streaming starts and you want to grab controls,
> -   preventing the user from changing them.
> -
> -   Just call this and the framework will block any attempts to change
> -   these controls. */
>  void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
>  {
>  	bool old;
> 
