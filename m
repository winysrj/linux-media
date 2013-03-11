Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3048 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3CKLuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:50:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>
Subject: Re: [REVIEW PATCH 01/42] v4l2-ctrls: eliminate lockdep false alarms for struct v4l2_ctrl_handler.lock
Date: Mon, 11 Mar 2013 12:50:10 +0100
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl> <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111250.10211.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon March 11 2013 12:45:39 Hans Verkuil wrote:
> From: Andy Walls <awalls at>

Oops, somehow I messed up Andy's email. I've corrected it in my git tree.

Regards,

	Hans

> 
> When calling v4l2_ctrl_add_handler(), lockdep would detect a potential
> recursive locking problem on a situation that is by design intended and
> not a recursive lock.  This happened because all struct
> v4l2_ctrl_handler.lock mutexes were created as members of the same lock
> class in v4l2_ctrl_handler_init(), and v4l2_ctrl_add_handler() takes the
> hdl->lock on two different v4l2_ctrl_handler instances.
> 
> This change breaks the large lockdep lock class for struct
> v4l2_ctrl_handler.lock and breaks it into v4l2_ctrl_handler
> instantiation specific lock classes with meaningful class names.
> 
> This will validly eliminate lockdep alarms for v4l2_ctrl_handler locking
> validation, as long as the relationships between drivers adding v4l2
> controls to their own handler from other v4l2 drivers' control handlers
> remains straightforward.
> 
> struct v4l2_ctrl_handler.lock lock classes are created with names such
> that the output of cat /proc/lockdep indicates where in the v4l2 driver
> code v4l2_ctrl_handle_init() is being called on instantiations:
> 
> ffffffffa045f490 FD:   10 BD:    8 +.+...: cx2341x:1534:(hdl)->lock
> ffffffffa0497d20 FD:   12 BD:    2 +.+.+.: saa7115:1581:(hdl)->lock
> ffffffffa04ac660 FD:   14 BD:    2 +.+.+.: msp3400_driver:756:(hdl)->lock
> ffffffffa0484b90 FD:   12 BD:    1 +.+.+.: ivtv_gpio:366:(&itv->hdl_gpio)->lock
> ffffffffa04eb530 FD:   11 BD:    2 +.+.+.: cx25840_core:1982:(&state->hdl)->lock
> ffffffffa04fbc80 FD:   11 BD:    3 +.+.+.: wm8775:246:(&state->hdl)->lock
> 
> Some lock chains, that were previously causing the recursion alarms, are
> now visible in the output of cat /proc/lockdep_chains:
> 
> irq_context: 0
> [ffffffffa0497d20] saa7115:1581:(hdl)->lock
> [ffffffffa045f490] cx2341x:1534:(hdl)->lock
> 
> irq_context: 0
> [ffffffffa04ac660] msp3400_driver:756:(hdl)->lock
> [ffffffffa045f490] cx2341x:1534:(hdl)->lock
> 
> irq_context: 0
> [ffffffffa0484b90] ivtv_gpio:366:(&itv->hdl_gpio)->lock
> [ffffffffa045f490] cx2341x:1534:(hdl)->lock
> 
> irq_context: 0
> [ffffffffa04eb530] cx25840_core:1982:(&state->hdl)->lock
> [ffffffffa045f490] cx2341x:1534:(hdl)->lock
> 
> irq_context: 0
> [ffffffffa04fbc80] wm8775:246:(&state->hdl)->lock
> [ffffffffa045f490] cx2341x:1534:(hdl)->lock
> 
> Signed-off-by: Andy Walls <awalls <at> md.metrocast.net>
> [hans.verkuil@cisco.com: keep mutex_init in v4l2_ctrl_handler_init_class]
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c |    8 +++++---
>  include/media/v4l2-ctrls.h           |   29 ++++++++++++++++++++++++++---
>  2 files changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 6b28b58..b36d1ec 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1362,11 +1362,13 @@ static inline int handler_set_err(struct v4l2_ctrl_handler *hdl, int err)
>  }
>  
>  /* Initialize the handler */
> -int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
> -			   unsigned nr_of_controls_hint)
> +int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
> +				 unsigned nr_of_controls_hint,
> +				 struct lock_class_key *key, const char *name)
>  {
>  	hdl->lock = &hdl->_lock;
>  	mutex_init(hdl->lock);
> +	lockdep_set_class_and_name(hdl->lock, key, name);
>  	INIT_LIST_HEAD(&hdl->ctrls);
>  	INIT_LIST_HEAD(&hdl->ctrl_refs);
>  	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
> @@ -1375,7 +1377,7 @@ int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
>  	hdl->error = hdl->buckets ? 0 : -ENOMEM;
>  	return hdl->error;
>  }
> -EXPORT_SYMBOL(v4l2_ctrl_handler_init);
> +EXPORT_SYMBOL(v4l2_ctrl_handler_init_class);
>  
>  /* Free all controls and control refs */
>  void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index f00d42b..7343a27 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -259,7 +259,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  		    s32 *min, s32 *max, s32 *step, s32 *def, u32 *flags);
>  
>  
> -/** v4l2_ctrl_handler_init() - Initialize the control handler.
> +/** v4l2_ctrl_handler_init_class() - Initialize the control handler.
>    * @hdl:	The control handler.
>    * @nr_of_controls_hint: A hint of how many controls this handler is
>    *		expected to refer to. This is the total number, so including
> @@ -268,12 +268,35 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>    *		are allocated) or the control lookup becomes slower (not enough
>    *		buckets are allocated, so there are more slow list lookups).
>    *		It will always work, though.
> +  * @key:	Used by the lock validator if CONFIG_LOCKDEP is set.
> +  * @name:	Used by the lock validator if CONFIG_LOCKDEP is set.
>    *
>    * Returns an error if the buckets could not be allocated. This error will
>    * also be stored in @hdl->error.
> +  *
> +  * Never use this call directly, always use the v4l2_ctrl_handler_init
> +  * macro that hides the @key and @name arguments.
>    */
> -int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
> -			   unsigned nr_of_controls_hint);
> +int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
> +				 unsigned nr_of_controls_hint,
> +				 struct lock_class_key *key, const char *name);
> +
> +#ifdef CONFIG_LOCKDEP
> +#define v4l2_ctrl_handler_init(hdl, nr_of_controls_hint)		\
> +(									\
> +	({								\
> +		static struct lock_class_key _key;			\
> +		v4l2_ctrl_handler_init_class(hdl, nr_of_controls_hint,	\
> +					&_key,				\
> +					KBUILD_BASENAME ":"		\
> +					__stringify(__LINE__) ":"	\
> +					"(" #hdl ")->_lock");		\
> +	})								\
> +)
> +#else
> +#define v4l2_ctrl_handler_init(hdl, nr_of_controls_hint)		\
> +	v4l2_ctrl_handler_init_class(hdl, nr_of_controls_hint, NULL, NULL)
> +#endif
>  
>  /** v4l2_ctrl_handler_free() - Free all controls owned by the handler and free
>    * the control list.
> 
