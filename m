Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57393 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753329AbdJMMct (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 08:32:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 05/17] media: v4l2-device.h: document ancillary macros
Date: Fri, 13 Oct 2017 15:33:01 +0300
Message-ID: <2033103.DJckbdrl9J@avalon>
In-Reply-To: <841040813f6fe8f3dbeba66c4f1a046b35e38e51.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com> <841040813f6fe8f3dbeba66c4f1a046b35e38e51.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 28 September 2017 00:46:48 EEST Mauro Carvalho Chehab wrote:
> There are several widely macros that aren't documented using kernel-docs

What's a widely macro ? :-)

> markups.
> 
> Add it.

Did you mean "Add documentation." ? "Document them." is also an option.

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-device.h | 238 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 204 insertions(+), 34 deletions(-)
> 
> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index 8ffa94009d1a..d6d1c4f7d42c 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -56,7 +56,6 @@ struct v4l2_ctrl_handler;
>   *    #) @dev->driver_data points to this struct.
>   *    #) @dev might be %NULL if there is no parent device
>   */
> -
>  struct v4l2_device {
>  	struct device *dev;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> @@ -166,7 +165,7 @@ void v4l2_device_unregister(struct v4l2_device
> *v4l2_dev); * v4l2_device_register_subdev - Registers a subdev with a v4l2
> device. *
>   * @v4l2_dev: pointer to struct &v4l2_device
> - * @sd: pointer to struct &v4l2_subdev
> + * @sd: pointer to &struct v4l2_subdev
>   *
>   * While registered, the subdev module is marked as in-use.
>   *
> @@ -179,7 +178,7 @@ int __must_check v4l2_device_register_subdev(struct
> v4l2_device *v4l2_dev, /**
>   * v4l2_device_unregister_subdev - Unregisters a subdev with a v4l2 device.
> *
> - * @sd: pointer to struct &v4l2_subdev
> + * @sd: pointer to &struct v4l2_subdev
>   *
>   * .. note ::
>   *
> @@ -201,7 +200,7 @@ v4l2_device_register_subdev_nodes(struct v4l2_device
> *v4l2_dev); /**
>   * v4l2_subdev_notify - Sends a notification to v4l2_device.
>   *
> - * @sd: pointer to struct &v4l2_subdev
> + * @sd: pointer to &struct v4l2_subdev
>   * @notification: type of notification. Please notice that the notification
>   *	type is driver-specific.
>   * @arg: arguments for the notification. Those are specific to each

While all this makes sense, it's not related to $SUBJECT.

> @@ -214,13 +213,43 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, sd->v4l2_dev->notify(sd, notification, arg);
>  }
> 
> -/* Iterate over all subdevs. */
> +/* Ancillary macros to iterate over all subdevs. */

Ancillary means supplemental and non-essential. I wouldn't call the macros 
below ancillary.

> +/**
> + * v4l2_device_for_each_subdev - Ancillary macro that interates over all
> + *	sub-devices

All sub-devices of a given v4l2_device. Otherwise it could be understood as 
all sub-devices in the system.

> + * @sd: pointer that will be filled by the macro with all
> + *	&struct v4l2_subdev sub-devices associated with @v4l2_dev.

How about "&struct v4l2_subdev pointer used as an iterator by the loop" ?

> + * @v4l2_dev: pointer to &struct v4l2_device

And "&struct v4l2_device owning the sub-devices to iterate over" or something 
similar ?

> + *
> + * Sometimes, a driver may need to broadcast a command to all subdevices.
> + * This ancillary macro allows interacting to all sub-devices associated
> + * to a device.

That's just one possible use of this macro. I wouldn't make it the only 
documented on. Maybe something as the following ?

"This macro iterates over all sub-devices owned by the @v4l2_dev device. It 
acts as a for loop iterator and executes the next statement with the @sd 
variable pointing to each sub-device in turn".

> + */
>  #define v4l2_device_for_each_subdev(sd, v4l2_dev)			\
>  	list_for_each_entry(sd, &(v4l2_dev)->subdevs, list)
> 
> -/* Call the specified callback for all subdevs matching the condition.
> -   Ignore any errors. Note that you cannot add or delete a subdev
> -   while walking the subdevs list. */
> +/**
> + * __v4l2_device_call_subdevs_p - Calls the specified callback for

All the __v4l2_device_* macros are internal, I don't think there's a need to 
document them just for the sake of it.

> + *	all subdevs matching the condition.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @sd: pointer that will be filled by the macro with all
> + *	&struct v4l2_subdev sub-devices associated with @v4l2_dev.
> + * @cond: condition to be match
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
> + * @args...: arguments for @f.
> + *
> + * Ignore any errors.
> + *
> + * Note: subdevs cannot be added or deleted while walking at
> + * the subdevs list.
> + */
>  #define __v4l2_device_call_subdevs_p(v4l2_dev, sd, cond, o, f, args...)	\
>  	do {								\
>  		list_for_each_entry((sd), &(v4l2_dev)->subdevs, list)	\
> @@ -228,6 +257,24 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, (sd)->ops->o->f((sd) , ##args);		\
>  	} while (0)
> 
> +/**
> + * __v4l2_device_call_subdevs - Calls the specified callback for
> + *	all subdevs matching the condition.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @cond: condition to be match
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
> + * @args...: arguments for @f.
> + *
> + * Ignore any errors.
> + *
> + * Note: subdevs cannot be added or deleted while walking at
> + * the subdevs list.
> + */
>  #define __v4l2_device_call_subdevs(v4l2_dev, cond, o, f, args...)	\
>  	do {								\
>  		struct v4l2_subdev *__sd;				\
> @@ -236,10 +283,29 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, f , ##args);		\
>  	} while (0)
> 
> -/* Call the specified callback for all subdevs matching the condition.
> -   If the callback returns an error other than 0 or -ENOIOCTLCMD, then
> -   return with that error code. Note that you cannot add or delete a
> -   subdev while walking the subdevs list. */
> +/**
> + * __v4l2_device_call_subdevs_until_err_p - Calls the specified callback
> for
> + *	all subdevs matching the condition.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @sd: pointer that will be filled by the macro with all
> + *	&struct v4l2_subdev sub-devices associated with @v4l2_dev.
> + * @cond: condition to be match
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
> + * @args...: arguments for @f.
> + *
> + * Return:
> + *
> + * If the callback returns an error other than 0 or ``-ENOIOCTLCMD``
> + * for any subdevice, then abort and return with that error code.
> + *
> + * Note: subdevs cannot be added or deleted while walking at
> + * the subdevs list.
> + */
>  #define __v4l2_device_call_subdevs_until_err_p(v4l2_dev, sd, cond, o, f,
> args...) \ ({									\
>  	long __err = 0;							\
> @@ -253,6 +319,27 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, (__err == -ENOIOCTLCMD) ? 0 : __err;				\
>  })
> 
> +/**
> + * __v4l2_device_call_subdevs_until_err - Calls the specified callback for
> + *	all subdevs matching the condition.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @cond: condition to be match
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
> + * @args...: arguments for @f.
> + *
> + * Return:
> + *
> + * If the callback returns an error other than 0 or ``-ENOIOCTLCMD``
> + * for any subdevice, then abort and return with that error code.
> + *
> + * Note: subdevs cannot be added or deleted while walking at
> + * the subdevs list.
> + */
>  #define __v4l2_device_call_subdevs_until_err(v4l2_dev, cond, o, f, args...)
> \ ({									\
>  	struct v4l2_subdev *__sd;					\
> @@ -260,9 +347,25 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, f , ##args);		\
>  })
> 
> -/* Call the specified callback for all subdevs matching grp_id (if 0, then
> -   match them all). Ignore any errors. Note that you cannot add or delete
> -   a subdev while walking the subdevs list. */
> +/**
> + * v4l2_device_call_all - Calls the specified callback for

The word "operation" would be better than the word "callback".

> + *	all subdevs matching a device-specific group ID.

How exactly is the group ID device-specific ?

> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @grpid: &struct v4l2_subdev->grp_id group ID to match.
> + * 	   Use 0 to match them all.
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.

Using the word "group" here makes it very confusing. You could use "operation 
class" instead. Another option would be to document @o.@f of Sphinx doesn't 
complain/

> + * @args...: arguments for @f.
> + *
> + * Ignore any errors.
> + *
> + * Note: subdevs cannot be added or deleted while walking at

s/walking at/walking/

All these comments apply for the macros below.

> + * the subdevs list.
> + */
>  #define v4l2_device_call_all(v4l2_dev, grpid, o, f, args...)		\
>  	do {								\
>  		struct v4l2_subdev *__sd;				\
> @@ -272,10 +375,28 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, ##args);					\
>  	} while (0)
> 
> -/* Call the specified callback for all subdevs matching grp_id (if 0, then
> -   match them all). If the callback returns an error other than 0 or
> -   -ENOIOCTLCMD, then return with that error code. Note that you cannot
> -   add or delete a subdev while walking the subdevs list. */
> +/**
> + * v4l2_device_call_until_err - Calls the specified callback for
> + *	all subdevs matching a device-specific group ID.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @grpid: &struct v4l2_subdev->grp_id group ID to match.
> + * 	   Use 0 to match them all.
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
> + * @args...: arguments for @f.
> + *
> + * Return:
> + *
> + * If the callback returns an error other than 0 or ``-ENOIOCTLCMD``
> + * for any subdevice, then abort and return with that error code.

Otherwise ?

> + * Note: subdevs cannot be added or deleted while walking at
> + * the subdevs list.
> + */
>  #define v4l2_device_call_until_err(v4l2_dev, grpid, o, f, args...)	\
>  ({									\
>  	struct v4l2_subdev *__sd;					\
> @@ -284,10 +405,24 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, ##args);					\
>  })
> 
> -/*
> - * Call the specified callback for all subdevs where grp_id & grpmsk != 0
> - * (if grpmsk == `0, then match them all). Ignore any errors. Note that you
> - * cannot add or delete a subdev while walking the subdevs list.
> +/**
> + * v4l2_device_mask_call_all - Calls the specified callback for
> + *	all subdevices where a group ID matches a specified bitmask.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @grpmsk: bitmask to be checked against &struct v4l2_subdev->grp_id
> + *	    group ID to be matched. Use 0 to match them all.
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
> + * @args...: arguments for @f.
> + *
> + * Ignore any errors.
> + *
> + * Note: subdevs cannot be added or deleted while walking at
> + * the subdevs list.
>   */
>  #define v4l2_device_mask_call_all(v4l2_dev, grpmsk, o, f, args...)	\
>  	do {								\
> @@ -298,11 +433,27 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, ##args);					\
>  	} while (0)
> 
> -/*
> - * Call the specified callback for all subdevs where grp_id & grpmsk != 0
> - * (if grpmsk == 0, then match them all). If the callback returns an error
> - * other than 0 or %-ENOIOCTLCMD, then return with that error code. Note
> that
> - * you cannot add or delete a subdev while walking the subdevs list.
> +/**
> + * v4l2_device_mask_call_until_err - Calls the specified callback for
> + *	all subdevices where a group ID matches a specified bitmask.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @grpmsk: bitmask to be checked against &struct v4l2_subdev->grp_id
> + *	    group ID to be matched. Use 0 to match them all.
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
> + * @args...: arguments for @f.
> + *
> + * Return:
> + *
> + * If the callback returns an error other than 0 or ``-ENOIOCTLCMD``
> + * for any subdevice, then abort and return with that error code.
> + *
> + * Note: subdevs cannot be added or deleted while walking at
> + * the subdevs list.
>   */
>  #define v4l2_device_mask_call_until_err(v4l2_dev, grpmsk, o, f, args...) \
>  ({									\
> @@ -312,9 +463,19 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, ##args);					\
>  })
> 
> -/*
> - * Does any subdev with matching grpid (or all if grpid == 0) has the given
> - * op?
> +
> +/**
> + * v4l2_device_has_op - checks if any subdev with matching grpid has a
> + * 	given ops.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @grpid: &struct v4l2_subdev->grp_id group ID to match.
> + * 	   Use 0 to match them all.
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
>   */
>  #define v4l2_device_has_op(v4l2_dev, grpid, o, f)			\
>  ({									\
> @@ -331,9 +492,18 @@ static inline void v4l2_subdev_notify(struct
> v4l2_subdev *sd, __result;							\
>  })
> 
> -/*
> - * Does any subdev with matching grpmsk (or all if grpmsk == 0) has the
> given 
> - * op?
> +/**
> + * v4l2_device_mask_has_op - checks if any subdev with matching group
> + *	mask has a given ops.
> + *
> + * @v4l2_dev: pointer to &struct v4l2_device
> + * @grpmsk: bitmask to be checked against &struct v4l2_subdev->grp_id
> + *	    group ID to be matched. Use 0 to match them all.
> + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> + *     Each element there groups a set of callbacks functions.
> + * @f: callback function that will be called if @cond matches.
> + * 	The callback functions are defined in groups, according to
> + *	each element at &struct v4l2_subdev_ops.
>   */
>  #define v4l2_device_mask_has_op(v4l2_dev, grpmsk, o, f)			\
>  ({									\


-- 
Regards,

Laurent Pinchart
