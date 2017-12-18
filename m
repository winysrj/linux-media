Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46993 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753137AbdLRO6O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 09:58:14 -0500
Date: Mon, 18 Dec 2017 12:58:00 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 05/17] media: v4l2-device.h: document ancillary
 macros
Message-ID: <20171218125800.2e3882fc@vento.lan>
In-Reply-To: <2033103.DJckbdrl9J@avalon>
References: <cover.1506548682.git.mchehab@s-opensource.com>
        <841040813f6fe8f3dbeba66c4f1a046b35e38e51.1506548682.git.mchehab@s-opensource.com>
        <2033103.DJckbdrl9J@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Oct 2017 15:33:01 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Thursday, 28 September 2017 00:46:48 EEST Mauro Carvalho Chehab wrote:
> > There are several widely macros that aren't documented using kernel-docs  
> 
> What's a widely macro ? :-)
> 
> > markups.
> > 
> > Add it.  
> 
> Did you mean "Add documentation." ? "Document them." is also an option.
> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I attended most of the points you pointed. I'll comment just the
ones that I have a different opinion, or require further discussions.

> > -/* Call the specified callback for all subdevs matching the condition.
> > -   Ignore any errors. Note that you cannot add or delete a subdev
> > -   while walking the subdevs list. */
> > +/**
> > + * __v4l2_device_call_subdevs_p - Calls the specified callback for  
> 
> All the __v4l2_device_* macros are internal, I don't think there's a need to 
> document them just for the sake of it.

Yeah, they're meant to be used only internally, but there are lot
of tricks on those macros. So, I prefer to keep them documented.

> 
> > + *	all subdevs matching a device-specific group ID.  
> 
> How exactly is the group ID device-specific ?

This "group" is really device-specific: each device may define its own
private set of device groups. I guess only one or two drivers actually
use it, like this one:

	drivers/media/platform/davinci/vpif_display.c

See calls for v4l2_device_call_until_err() there.

The group ID is filled on this logic, inside vpif_probe():

			if (vpif_obj.sd[i])
				vpif_obj.sd[i]->grp_id = 1 << i;

Maybe it could say, instead:

	"all subdevs matching the &v4l2_subdev.grp_id, as
assigned by the bridge driver."

 
> > + * @v4l2_dev: pointer to &struct v4l2_device
> > + * @grpid: &struct v4l2_subdev->grp_id group ID to match.
> > + * 	   Use 0 to match them all.
> > + * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
> > + *     Each element there groups a set of callbacks functions.
> > + * @f: callback function that will be called if @cond matches.
> > + * 	The callback functions are defined in groups, according to
> > + *	each element at &struct v4l2_subdev_ops.  
> 
> Using the word "group" here makes it very confusing. You could use "operation 
> class" instead.

It isn't an operation class. It is a group of sub-devices, defined by
the bridge driver.

> Another option would be to document @o.@f of Sphinx doesn't 
> complain/

It will complain.

I'm enclosing a new version of this patch with the requested changes.


Thanks,
Mauro

[PATCH v3 05/17] media: v4l2-device.h: document helper macros

There are several macros that aren't documented using kernel-docs
markups.

Document them.

While here, add cross-references to structs on this file.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-device.h |  246 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 211 insertions(+), 35 deletions(-)

--- patchwork.orig/include/media/v4l2-device.h
+++ patchwork/include/media/v4l2-device.h
@@ -38,7 +38,7 @@ struct v4l2_ctrl_handler;
  * @lock: lock this struct; can be used by the driver as well
  *	if this struct is embedded into a larger struct.
  * @name: unique device name, by default the driver name + bus ID
- * @notify: notify callback called by some sub-devices.
+ * @notify: notify operation called by some sub-devices.
  * @ctrl_handler: The control handler. May be %NULL.
  * @prio: Device's priority state
  * @ref: Keep track of the references to this struct.
@@ -56,7 +56,6 @@ struct v4l2_ctrl_handler;
  *    #) @dev->driver_data points to this struct.
  *    #) @dev might be %NULL if there is no parent device
  */
-
 struct v4l2_device {
 	struct device *dev;
 #if defined(CONFIG_MEDIA_CONTROLLER)
@@ -166,7 +165,7 @@ void v4l2_device_unregister(struct v4l2_
  * v4l2_device_register_subdev - Registers a subdev with a v4l2 device.
  *
  * @v4l2_dev: pointer to struct &v4l2_device
- * @sd: pointer to struct &v4l2_subdev
+ * @sd: pointer to &struct v4l2_subdev
  *
  * While registered, the subdev module is marked as in-use.
  *
@@ -179,7 +178,7 @@ int __must_check v4l2_device_register_su
 /**
  * v4l2_device_unregister_subdev - Unregisters a subdev with a v4l2 device.
  *
- * @sd: pointer to struct &v4l2_subdev
+ * @sd: pointer to &struct v4l2_subdev
  *
  * .. note ::
  *
@@ -201,7 +200,7 @@ v4l2_device_register_subdev_nodes(struct
 /**
  * v4l2_subdev_notify - Sends a notification to v4l2_device.
  *
- * @sd: pointer to struct &v4l2_subdev
+ * @sd: pointer to &struct v4l2_subdev
  * @notification: type of notification. Please notice that the notification
  *	type is driver-specific.
  * @arg: arguments for the notification. Those are specific to each
@@ -214,13 +213,43 @@ static inline void v4l2_subdev_notify(st
 		sd->v4l2_dev->notify(sd, notification, arg);
 }
 
-/* Iterate over all subdevs. */
+/* Helper macros to iterate over all subdevs. */
+
+/**
+ * v4l2_device_for_each_subdev - Helper macro that interates over all
+ *	sub-devices of a given &v4l2_device.
+ *
+ * @sd: pointer that will be filled by the macro with all
+ *	&struct v4l2_subdev pointer used as an iterator by the loop.
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ *
+ * This macro iterates over all sub-devices owned by the @v4l2_dev device.
+ * It acts as a for loop iterator and executes the next statement with
+ * the @sd variable pointing to each sub-device in turn.
+ */
 #define v4l2_device_for_each_subdev(sd, v4l2_dev)			\
 	list_for_each_entry(sd, &(v4l2_dev)->subdevs, list)
 
-/* Call the specified callback for all subdevs matching the condition.
-   Ignore any errors. Note that you cannot add or delete a subdev
-   while walking the subdevs list. */
+/**
+ * __v4l2_device_call_subdevs_p - Calls the specified operation for
+ *	all subdevs matching the condition.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @sd: pointer that will be filled by the macro with all
+ *	&struct v4l2_subdev pointer used as an iterator by the loop.
+ * @cond: condition to be match
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
+ *
+ * Ignore any errors.
+ *
+ * Note: subdevs cannot be added or deleted while walking
+ * the subdevs list.
+ */
 #define __v4l2_device_call_subdevs_p(v4l2_dev, sd, cond, o, f, args...)	\
 	do {								\
 		list_for_each_entry((sd), &(v4l2_dev)->subdevs, list)	\
@@ -228,6 +257,24 @@ static inline void v4l2_subdev_notify(st
 				(sd)->ops->o->f((sd) , ##args);		\
 	} while (0)
 
+/**
+ * __v4l2_device_call_subdevs - Calls the specified operation for
+ *	all subdevs matching the condition.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @cond: condition to be match
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
+ *
+ * Ignore any errors.
+ *
+ * Note: subdevs cannot be added or deleted while walking
+ * the subdevs list.
+ */
 #define __v4l2_device_call_subdevs(v4l2_dev, cond, o, f, args...)	\
 	do {								\
 		struct v4l2_subdev *__sd;				\
@@ -236,10 +283,30 @@ static inline void v4l2_subdev_notify(st
 						f , ##args);		\
 	} while (0)
 
-/* Call the specified callback for all subdevs matching the condition.
-   If the callback returns an error other than 0 or -ENOIOCTLCMD, then
-   return with that error code. Note that you cannot add or delete a
-   subdev while walking the subdevs list. */
+/**
+ * __v4l2_device_call_subdevs_until_err_p - Calls the specified operation for
+ *	all subdevs matching the condition.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @sd: pointer that will be filled by the macro with all
+ *	&struct v4l2_subdev sub-devices associated with @v4l2_dev.
+ * @cond: condition to be match
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
+ *
+ * Return:
+ *
+ * If the operation returns an error other than 0 or ``-ENOIOCTLCMD``
+ * for any subdevice, then abort and return with that error code, zero
+ * otherwise.
+ *
+ * Note: subdevs cannot be added or deleted while walking
+ * the subdevs list.
+ */
 #define __v4l2_device_call_subdevs_until_err_p(v4l2_dev, sd, cond, o, f, args...) \
 ({									\
 	long __err = 0;							\
@@ -253,6 +320,28 @@ static inline void v4l2_subdev_notify(st
 	(__err == -ENOIOCTLCMD) ? 0 : __err;				\
 })
 
+/**
+ * __v4l2_device_call_subdevs_until_err - Calls the specified operation for
+ *	all subdevs matching the condition.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @cond: condition to be match
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
+ *
+ * Return:
+ *
+ * If the operation returns an error other than 0 or ``-ENOIOCTLCMD``
+ * for any subdevice, then abort and return with that error code,
+ * zero otherwise.
+ *
+ * Note: subdevs cannot be added or deleted while walking
+ * the subdevs list.
+ */
 #define __v4l2_device_call_subdevs_until_err(v4l2_dev, cond, o, f, args...) \
 ({									\
 	struct v4l2_subdev *__sd;					\
@@ -260,9 +349,26 @@ static inline void v4l2_subdev_notify(st
 						f , ##args);		\
 })
 
-/* Call the specified callback for all subdevs matching grp_id (if 0, then
-   match them all). Ignore any errors. Note that you cannot add or delete
-   a subdev while walking the subdevs list. */
+/**
+ * v4l2_device_call_all - Calls the specified operation for
+ *	all subdevs matching the &v4l2_subdev.grp_id, as assigned
+ *	by the bridge driver.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @grpid: &struct v4l2_subdev->grp_id group ID to match.
+ * 	   Use 0 to match them all.
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
+ *
+ * Ignore any errors.
+ *
+ * Note: subdevs cannot be added or deleted while walking
+ * the subdevs list.
+ */
 #define v4l2_device_call_all(v4l2_dev, grpid, o, f, args...)		\
 	do {								\
 		struct v4l2_subdev *__sd;				\
@@ -272,10 +378,30 @@ static inline void v4l2_subdev_notify(st
 			##args);					\
 	} while (0)
 
-/* Call the specified callback for all subdevs matching grp_id (if 0, then
-   match them all). If the callback returns an error other than 0 or
-   -ENOIOCTLCMD, then return with that error code. Note that you cannot
-   add or delete a subdev while walking the subdevs list. */
+/**
+ * v4l2_device_call_until_err - Calls the specified operation for
+ *	all subdevs matching the &v4l2_subdev.grp_id, as assigned
+ *	by the bridge driver, until an error occurs.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @grpid: &struct v4l2_subdev->grp_id group ID to match.
+ * 	   Use 0 to match them all.
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
+ *
+ * Return:
+ *
+ * If the operation returns an error other than 0 or ``-ENOIOCTLCMD``
+ * for any subdevice, then abort and return with that error code,
+ * zero otherwise.
+ *
+ * Note: subdevs cannot be added or deleted while walking
+ * the subdevs list.
+ */
 #define v4l2_device_call_until_err(v4l2_dev, grpid, o, f, args...)	\
 ({									\
 	struct v4l2_subdev *__sd;					\
@@ -284,10 +410,24 @@ static inline void v4l2_subdev_notify(st
 			##args);					\
 })
 
-/*
- * Call the specified callback for all subdevs where grp_id & grpmsk != 0
- * (if grpmsk == `0, then match them all). Ignore any errors. Note that you
- * cannot add or delete a subdev while walking the subdevs list.
+/**
+ * v4l2_device_mask_call_all - Calls the specified operation for
+ *	all subdevices where a group ID matches a specified bitmask.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @grpmsk: bitmask to be checked against &struct v4l2_subdev->grp_id
+ *	    group ID to be matched. Use 0 to match them all.
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
+ *
+ * Ignore any errors.
+ *
+ * Note: subdevs cannot be added or deleted while walking
+ * the subdevs list.
  */
 #define v4l2_device_mask_call_all(v4l2_dev, grpmsk, o, f, args...)	\
 	do {								\
@@ -298,11 +438,28 @@ static inline void v4l2_subdev_notify(st
 			##args);					\
 	} while (0)
 
-/*
- * Call the specified callback for all subdevs where grp_id & grpmsk != 0
- * (if grpmsk == 0, then match them all). If the callback returns an error
- * other than 0 or %-ENOIOCTLCMD, then return with that error code. Note that
- * you cannot add or delete a subdev while walking the subdevs list.
+/**
+ * v4l2_device_mask_call_until_err - Calls the specified operation for
+ *	all subdevices where a group ID matches a specified bitmask.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @grpmsk: bitmask to be checked against &struct v4l2_subdev->grp_id
+ *	    group ID to be matched. Use 0 to match them all.
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
+ * @args...: arguments for @f.
+ *
+ * Return:
+ *
+ * If the operation returns an error other than 0 or ``-ENOIOCTLCMD``
+ * for any subdevice, then abort and return with that error code,
+ * zero otherwise.
+ *
+ * Note: subdevs cannot be added or deleted while walking
+ * the subdevs list.
  */
 #define v4l2_device_mask_call_until_err(v4l2_dev, grpmsk, o, f, args...) \
 ({									\
@@ -312,9 +469,19 @@ static inline void v4l2_subdev_notify(st
 			##args);					\
 })
 
-/*
- * Does any subdev with matching grpid (or all if grpid == 0) has the given
- * op?
+
+/**
+ * v4l2_device_has_op - checks if any subdev with matching grpid has a
+ * 	given ops.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @grpid: &struct v4l2_subdev->grp_id group ID to match.
+ * 	   Use 0 to match them all.
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
  */
 #define v4l2_device_has_op(v4l2_dev, grpid, o, f)			\
 ({									\
@@ -331,9 +498,18 @@ static inline void v4l2_subdev_notify(st
 	__result;							\
 })
 
-/*
- * Does any subdev with matching grpmsk (or all if grpmsk == 0) has the given
- * op?
+/**
+ * v4l2_device_mask_has_op - checks if any subdev with matching group
+ *	mask has a given ops.
+ *
+ * @v4l2_dev: &struct v4l2_device owning the sub-devices to iterate over.
+ * @grpmsk: bitmask to be checked against &struct v4l2_subdev->grp_id
+ *	    group ID to be matched. Use 0 to match them all.
+ * @o: name of the element at &struct v4l2_subdev_ops that contains @f.
+ *     Each element there groups a set of operations functions.
+ * @f: operation function that will be called if @cond matches.
+ * 	The operation functions are defined in groups, according to
+ *	each element at &struct v4l2_subdev_ops.
  */
 #define v4l2_device_mask_has_op(v4l2_dev, grpmsk, o, f)			\
 ({									\
