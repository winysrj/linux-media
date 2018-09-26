Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53144 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbeIZR03 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 13:26:29 -0400
Subject: Re: [PATCH 2/2] v4l: ctrl: Provide unlocked variant of v4l2_ctrl_grab
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20180926080937.19501-1-sakari.ailus@linux.intel.com>
 <20180926080937.19501-3-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b99195f5-2584-3491-9b51-a67e7a08e44f@xs4all.nl>
Date: Wed, 26 Sep 2018 13:13:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180926080937.19501-3-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2018 10:09 AM, Sakari Ailus wrote:
> Sometimes it may be necessary to grab a control while holding the control
> handler's lock. Provide an unlocked variant of v4l2_ctrl_grab for the
> purpose --- it's called __v4l2_ctrl_grab.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c |  8 ++++----
>  include/media/v4l2-ctrls.h           | 26 +++++++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ab393adf51eb..4c0ecf29d278 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2511,14 +2511,15 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_activate);
>  
> -void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
> +void __v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
>  {
>  	bool old;
>  
>  	if (ctrl == NULL)
>  		return;
>  
> -	v4l2_ctrl_lock(ctrl);
> +	lockdep_assert_held(ctrl->handler->lock);
> +
>  	if (grabbed)
>  		/* set V4L2_CTRL_FLAG_GRABBED */
>  		old = test_and_set_bit(1, &ctrl->flags);
> @@ -2527,9 +2528,8 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
>  		old = test_and_clear_bit(1, &ctrl->flags);
>  	if (old != grabbed)
>  		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_FLAGS);
> -	v4l2_ctrl_unlock(ctrl);
>  }
> -EXPORT_SYMBOL(v4l2_ctrl_grab);
> +EXPORT_SYMBOL(__v4l2_ctrl_grab);
>  
>  /* Log the control name and value */
>  static void log_ctrl(const struct v4l2_ctrl *ctrl,
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index f615ba1b29dd..ff89df428f79 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -729,6 +729,22 @@ struct v4l2_ctrl *v4l2_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
>  void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
>  
>  /**
> + * __v4l2_ctrl_grab() - Unlocked variant of v4l2_ctrl_grab.
> + *
> + * @ctrl:	The control to (de)activate.
> + * @grabbed:	True if the control should become grabbed.
> + *
> + * This sets or clears the V4L2_CTRL_FLAG_GRABBED flag atomically.
> + * Does nothing if @ctrl == NULL.
> + * The V4L2_EVENT_CTRL event will be generated afterwards.
> + * This will usually be called when starting or stopping streaming in the
> + * driver.
> + *
> + * This function assumes that the control handler is locked by the caller.
> + */
> +void __v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
> +
> +/**
>   * v4l2_ctrl_grab() - Mark the control as grabbed or not grabbed.
>   *
>   * @ctrl:	The control to (de)activate.
> @@ -743,7 +759,15 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
>   * This function assumes that the control handler is not locked and will
>   * take the lock itself.
>   */
> -void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
> +static inline void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
> +{
> +	if (!ctrl)
> +		return;
> +
> +	v4l2_ctrl_lock(ctrl);
> +	__v4l2_ctrl_grab(ctrl, grabbed);
> +	v4l2_ctrl_unlock(ctrl);
> +}
>  
>  /**
>   *__v4l2_ctrl_modify_range() - Unlocked variant of v4l2_ctrl_modify_range()
> 
