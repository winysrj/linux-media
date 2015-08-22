Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 20/39] [media] v4l2-ctrls.h: add to device-drivers DocBook
Date: Sat, 22 Aug 2015 14:28:05 -0300
Message-Id: <f23c3be90c568881ab6a6c0c11dee46f5bb67684.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments there are using a wrong format. Due to that,
DocBook were unable to parse it.

Fix the tags format, and add it to device-drivers.xml.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 030b3803cc68..5f01f7ad15dc 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -231,17 +231,13 @@ X!Isound/sound_firmware.c
 !Idrivers/media/dvb-core/dvb_frontend.h
 !Idrivers/media/dvb-core/dvb_math.h
 !Idrivers/media/dvb-core/dvb_ringbuffer.h
+!Iinclude/media/v4l2-ctrls.h
 <!-- FIXME: Removed for now due to document generation inconsistency
-X!Iinclude/media/v4l2-ctrls.h
 X!Iinclude/media/v4l2-dv-timings.h
 X!Iinclude/media/v4l2-event.h
 X!Iinclude/media/v4l2-mediabus.h
 X!Iinclude/media/videobuf2-memops.h
 X!Iinclude/media/videobuf2-core.h
-X!Iinclude/media/lirc.h
-X!Edrivers/media/dvb-core/dvb_demux.c
-X!Idrivers/media/dvb-core/dvbdev.h
-X!Edrivers/media/dvb-core/dvb_net.c
 -->
 
   </chapter>
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 911f3e542834..88f736661c06 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -36,7 +36,8 @@ struct v4l2_subscribed_event;
 struct v4l2_fh;
 struct poll_table_struct;
 
-/** union v4l2_ctrl_ptr - A pointer to a control value.
+/**
+ * union v4l2_ctrl_ptr - A pointer to a control value.
  * @p_s32:	Pointer to a 32-bit signed value.
  * @p_s64:	Pointer to a 64-bit signed value.
  * @p_u8:	Pointer to a 8-bit unsigned value.
@@ -55,30 +56,34 @@ union v4l2_ctrl_ptr {
 	void *p;
 };
 
-/** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
-  * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
-  *		for volatile (and usually read-only) controls such as a control
-  *		that returns the current signal strength which changes
-  *		continuously.
-  *		If not set, then the currently cached value will be returned.
-  * @try_ctrl:	Test whether the control's value is valid. Only relevant when
-  *		the usual min/max/step checks are not sufficient.
-  * @s_ctrl:	Actually set the new control value. s_ctrl is compulsory. The
-  *		ctrl->handler->lock is held when these ops are called, so no
-  *		one else can access controls owned by that handler.
-  */
+/**
+ * struct v4l2_ctrl_ops - The control operations that the driver has to provide.
+ * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
+ *		for volatile (and usually read-only) controls such as a control
+ *		that returns the current signal strength which changes
+ *		continuously.
+ *		If not set, then the currently cached value will be returned.
+ * @try_ctrl:	Test whether the control's value is valid. Only relevant when
+ *		the usual min/max/step checks are not sufficient.
+ * @s_ctrl:	Actually set the new control value. s_ctrl is compulsory. The
+ *		ctrl->handler->lock is held when these ops are called, so no
+ *		one else can access controls owned by that handler.
+ */
 struct v4l2_ctrl_ops {
 	int (*g_volatile_ctrl)(struct v4l2_ctrl *ctrl);
 	int (*try_ctrl)(struct v4l2_ctrl *ctrl);
 	int (*s_ctrl)(struct v4l2_ctrl *ctrl);
 };
 
-/** struct v4l2_ctrl_type_ops - The control type operations that the driver has to provide.
-  * @equal: return true if both values are equal.
-  * @init: initialize the value.
-  * @log: log the value.
-  * @validate: validate the value. Return 0 on success and a negative value otherwise.
-  */
+/**
+ * struct v4l2_ctrl_type_ops - The control type operations that the driver
+ * 			       has to provide.
+ *
+ * @equal: return true if both values are equal.
+ * @init: initialize the value.
+ * @log: log the value.
+ * @validate: validate the value. Return 0 on success and a negative value otherwise.
+ */
 struct v4l2_ctrl_type_ops {
 	bool (*equal)(const struct v4l2_ctrl *ctrl, u32 idx,
 		      union v4l2_ctrl_ptr ptr1,
@@ -92,74 +97,75 @@ struct v4l2_ctrl_type_ops {
 
 typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
 
-/** struct v4l2_ctrl - The control structure.
-  * @node:	The list node.
-  * @ev_subs:	The list of control event subscriptions.
-  * @handler:	The handler that owns the control.
-  * @cluster:	Point to start of cluster array.
-  * @ncontrols:	Number of controls in cluster array.
-  * @done:	Internal flag: set for each processed control.
-  * @is_new:	Set when the user specified a new value for this control. It
-  *		is also set when called from v4l2_ctrl_handler_setup. Drivers
-  *		should never set this flag.
-  * @has_changed: Set when the current value differs from the new value. Drivers
-  *		should never use this flag.
-  * @is_private: If set, then this control is private to its handler and it
-  *		will not be added to any other handlers. Drivers can set
-  *		this flag.
-  * @is_auto:   If set, then this control selects whether the other cluster
-  *		members are in 'automatic' mode or 'manual' mode. This is
-  *		used for autogain/gain type clusters. Drivers should never
-  *		set this flag directly.
-  * @is_int:    If set, then this control has a simple integer value (i.e. it
-  *		uses ctrl->val).
-  * @is_string: If set, then this control has type V4L2_CTRL_TYPE_STRING.
-  * @is_ptr:	If set, then this control is an array and/or has type >= V4L2_CTRL_COMPOUND_TYPES
-  *		and/or has type V4L2_CTRL_TYPE_STRING. In other words, struct
-  *		v4l2_ext_control uses field p to point to the data.
-  * @is_array: If set, then this control contains an N-dimensional array.
-  * @has_volatiles: If set, then one or more members of the cluster are volatile.
-  *		Drivers should never touch this flag.
-  * @call_notify: If set, then call the handler's notify function whenever the
-  *		control's value changes.
-  * @manual_mode_value: If the is_auto flag is set, then this is the value
-  *		of the auto control that determines if that control is in
-  *		manual mode. So if the value of the auto control equals this
-  *		value, then the whole cluster is in manual mode. Drivers should
-  *		never set this flag directly.
-  * @ops:	The control ops.
-  * @type_ops:	The control type ops.
-  * @id:	The control ID.
-  * @name:	The control name.
-  * @type:	The control type.
-  * @minimum:	The control's minimum value.
-  * @maximum:	The control's maximum value.
-  * @default_value: The control's default value.
-  * @step:	The control's step value for non-menu controls.
-  * @elems:	The number of elements in the N-dimensional array.
-  * @elem_size:	The size in bytes of the control.
-  * @dims:	The size of each dimension.
-  * @nr_of_dims:The number of dimensions in @dims.
-  * @menu_skip_mask: The control's skip mask for menu controls. This makes it
-  *		easy to skip menu items that are not valid. If bit X is set,
-  *		then menu item X is skipped. Of course, this only works for
-  *		menus with <= 32 menu items. There are no menus that come
-  *		close to that number, so this is OK. Should we ever need more,
-  *		then this will have to be extended to a u64 or a bit array.
-  * @qmenu:	A const char * array for all menu items. Array entries that are
-  *		empty strings ("") correspond to non-existing menu items (this
-  *		is in addition to the menu_skip_mask above). The last entry
-  *		must be NULL.
-  * @flags:	The control's flags.
-  * @cur:	The control's current value.
-  * @val:	The control's new s32 value.
-  * @val64:	The control's new s64 value.
-  * @priv:	The control's private pointer. For use by the driver. It is
-  *		untouched by the control framework. Note that this pointer is
-  *		not freed when the control is deleted. Should this be needed
-  *		then a new internal bitfield can be added to tell the framework
-  *		to free this pointer.
-  */
+/**
+ * struct v4l2_ctrl - The control structure.
+ * @node:	The list node.
+ * @ev_subs:	The list of control event subscriptions.
+ * @handler:	The handler that owns the control.
+ * @cluster:	Point to start of cluster array.
+ * @ncontrols:	Number of controls in cluster array.
+ * @done:	Internal flag: set for each processed control.
+ * @is_new:	Set when the user specified a new value for this control. It
+ *		is also set when called from v4l2_ctrl_handler_setup. Drivers
+ *		should never set this flag.
+ * @has_changed: Set when the current value differs from the new value. Drivers
+ *		should never use this flag.
+ * @is_private: If set, then this control is private to its handler and it
+ *		will not be added to any other handlers. Drivers can set
+ *		this flag.
+ * @is_auto:   If set, then this control selects whether the other cluster
+ *		members are in 'automatic' mode or 'manual' mode. This is
+ *		used for autogain/gain type clusters. Drivers should never
+ *		set this flag directly.
+ * @is_int:    If set, then this control has a simple integer value (i.e. it
+ *		uses ctrl->val).
+ * @is_string: If set, then this control has type V4L2_CTRL_TYPE_STRING.
+ * @is_ptr:	If set, then this control is an array and/or has type >= V4L2_CTRL_COMPOUND_TYPES
+ *		and/or has type V4L2_CTRL_TYPE_STRING. In other words, struct
+ *		v4l2_ext_control uses field p to point to the data.
+ * @is_array: If set, then this control contains an N-dimensional array.
+ * @has_volatiles: If set, then one or more members of the cluster are volatile.
+ *		Drivers should never touch this flag.
+ * @call_notify: If set, then call the handler's notify function whenever the
+ *		control's value changes.
+ * @manual_mode_value: If the is_auto flag is set, then this is the value
+ *		of the auto control that determines if that control is in
+ *		manual mode. So if the value of the auto control equals this
+ *		value, then the whole cluster is in manual mode. Drivers should
+ *		never set this flag directly.
+ * @ops:	The control ops.
+ * @type_ops:	The control type ops.
+ * @id:	The control ID.
+ * @name:	The control name.
+ * @type:	The control type.
+ * @minimum:	The control's minimum value.
+ * @maximum:	The control's maximum value.
+ * @default_value: The control's default value.
+ * @step:	The control's step value for non-menu controls.
+ * @elems:	The number of elements in the N-dimensional array.
+ * @elem_size:	The size in bytes of the control.
+ * @dims:	The size of each dimension.
+ * @nr_of_dims:The number of dimensions in @dims.
+ * @menu_skip_mask: The control's skip mask for menu controls. This makes it
+ *		easy to skip menu items that are not valid. If bit X is set,
+ *		then menu item X is skipped. Of course, this only works for
+ *		menus with <= 32 menu items. There are no menus that come
+ *		close to that number, so this is OK. Should we ever need more,
+ *		then this will have to be extended to a u64 or a bit array.
+ * @qmenu:	A const char * array for all menu items. Array entries that are
+ *		empty strings ("") correspond to non-existing menu items (this
+ *		is in addition to the menu_skip_mask above). The last entry
+ *		must be NULL.
+ * @flags:	The control's flags.
+ * @cur:	The control's current value.
+ * @val:	The control's new s32 value.
+ * @val64:	The control's new s64 value.
+ * @priv:	The control's private pointer. For use by the driver. It is
+ *		untouched by the control framework. Note that this pointer is
+ *		not freed when the control is deleted. Should this be needed
+ *		then a new internal bitfield can be added to tell the framework
+ *		to free this pointer.
+ */
 struct v4l2_ctrl {
 	/* Administrative fields */
 	struct list_head node;
@@ -210,16 +216,17 @@ struct v4l2_ctrl {
 	union v4l2_ctrl_ptr p_cur;
 };
 
-/** struct v4l2_ctrl_ref - The control reference.
-  * @node:	List node for the sorted list.
-  * @next:	Single-link list node for the hash.
-  * @ctrl:	The actual control information.
-  * @helper:	Pointer to helper struct. Used internally in prepare_ext_ctrls().
-  *
-  * Each control handler has a list of these refs. The list_head is used to
-  * keep a sorted-by-control-ID list of all controls, while the next pointer
-  * is used to link the control in the hash's bucket.
-  */
+/**
+ * struct v4l2_ctrl_ref - The control reference.
+ * @node:	List node for the sorted list.
+ * @next:	Single-link list node for the hash.
+ * @ctrl:	The actual control information.
+ * @helper:	Pointer to helper struct. Used internally in prepare_ext_ctrls().
+ *
+ * Each control handler has a list of these refs. The list_head is used to
+ * keep a sorted-by-control-ID list of all controls, while the next pointer
+ * is used to link the control in the hash's bucket.
+ */
 struct v4l2_ctrl_ref {
 	struct list_head node;
 	struct v4l2_ctrl_ref *next;
@@ -227,25 +234,26 @@ struct v4l2_ctrl_ref {
 	struct v4l2_ctrl_helper *helper;
 };
 
-/** struct v4l2_ctrl_handler - The control handler keeps track of all the
-  * controls: both the controls owned by the handler and those inherited
-  * from other handlers.
-  * @_lock:	Default for "lock".
-  * @lock:	Lock to control access to this handler and its controls.
-  *		May be replaced by the user right after init.
-  * @ctrls:	The list of controls owned by this handler.
-  * @ctrl_refs:	The list of control references.
-  * @cached:	The last found control reference. It is common that the same
-  *		control is needed multiple times, so this is a simple
-  *		optimization.
-  * @buckets:	Buckets for the hashing. Allows for quick control lookup.
-  * @notify:	A notify callback that is called whenever the control changes value.
-  *		Note that the handler's lock is held when the notify function
-  *		is called!
-  * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
-  * @nr_of_buckets: Total number of buckets in the array.
-  * @error:	The error code of the first failed control addition.
-  */
+/**
+ * struct v4l2_ctrl_handler - The control handler keeps track of all the
+ * controls: both the controls owned by the handler and those inherited
+ * from other handlers.
+ * @_lock:	Default for "lock".
+ * @lock:	Lock to control access to this handler and its controls.
+ *		May be replaced by the user right after init.
+ * @ctrls:	The list of controls owned by this handler.
+ * @ctrl_refs:	The list of control references.
+ * @cached:	The last found control reference. It is common that the same
+ *		control is needed multiple times, so this is a simple
+ *		optimization.
+ * @buckets:	Buckets for the hashing. Allows for quick control lookup.
+ * @notify:	A notify callback that is called whenever the control changes value.
+ *		Note that the handler's lock is held when the notify function
+ *		is called!
+ * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
+ * @nr_of_buckets: Total number of buckets in the array.
+ * @error:	The error code of the first failed control addition.
+ */
 struct v4l2_ctrl_handler {
 	struct mutex _lock;
 	struct mutex *lock;
@@ -259,32 +267,33 @@ struct v4l2_ctrl_handler {
 	int error;
 };
 
-/** struct v4l2_ctrl_config - Control configuration structure.
-  * @ops:	The control ops.
-  * @type_ops:	The control type ops. Only needed for compound controls.
-  * @id:	The control ID.
-  * @name:	The control name.
-  * @type:	The control type.
-  * @min:	The control's minimum value.
-  * @max:	The control's maximum value.
-  * @step:	The control's step value for non-menu controls.
-  * @def: 	The control's default value.
-  * @dims:	The size of each dimension.
-  * @elem_size:	The size in bytes of the control.
-  * @flags:	The control's flags.
-  * @menu_skip_mask: The control's skip mask for menu controls. This makes it
-  *		easy to skip menu items that are not valid. If bit X is set,
-  *		then menu item X is skipped. Of course, this only works for
-  *		menus with <= 64 menu items. There are no menus that come
-  *		close to that number, so this is OK. Should we ever need more,
-  *		then this will have to be extended to a bit array.
-  * @qmenu:	A const char * array for all menu items. Array entries that are
-  *		empty strings ("") correspond to non-existing menu items (this
-  *		is in addition to the menu_skip_mask above). The last entry
-  *		must be NULL.
-  * @is_private: If set, then this control is private to its handler and it
-  *		will not be added to any other handlers.
-  */
+/**
+ * struct v4l2_ctrl_config - Control configuration structure.
+ * @ops:	The control ops.
+ * @type_ops:	The control type ops. Only needed for compound controls.
+ * @id:	The control ID.
+ * @name:	The control name.
+ * @type:	The control type.
+ * @min:	The control's minimum value.
+ * @max:	The control's maximum value.
+ * @step:	The control's step value for non-menu controls.
+ * @def: 	The control's default value.
+ * @dims:	The size of each dimension.
+ * @elem_size:	The size in bytes of the control.
+ * @flags:	The control's flags.
+ * @menu_skip_mask: The control's skip mask for menu controls. This makes it
+ *		easy to skip menu items that are not valid. If bit X is set,
+ *		then menu item X is skipped. Of course, this only works for
+ *		menus with <= 64 menu items. There are no menus that come
+ *		close to that number, so this is OK. Should we ever need more,
+ *		then this will have to be extended to a bit array.
+ * @qmenu:	A const char * array for all menu items. Array entries that are
+ *		empty strings ("") correspond to non-existing menu items (this
+ *		is in addition to the menu_skip_mask above). The last entry
+ *		must be NULL.
+ * @is_private: If set, then this control is private to its handler and it
+ *		will not be added to any other handlers.
+ */
 struct v4l2_ctrl_config {
 	const struct v4l2_ctrl_ops *ops;
 	const struct v4l2_ctrl_type_ops *type_ops;
@@ -304,42 +313,44 @@ struct v4l2_ctrl_config {
 	unsigned int is_private:1;
 };
 
-/** v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
-  *
-  * This works for all standard V4L2 controls.
-  * For non-standard controls it will only fill in the given arguments
-  * and @name will be NULL.
-  *
-  * This function will overwrite the contents of @name, @type and @flags.
-  * The contents of @min, @max, @step and @def may be modified depending on
-  * the type.
-  *
-  * Do not use in drivers! It is used internally for backwards compatibility
-  * control handling only. Once all drivers are converted to use the new
-  * control framework this function will no longer be exported.
-  */
+/**
+ * v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
+ *
+ * This works for all standard V4L2 controls.
+ * For non-standard controls it will only fill in the given arguments
+ * and @name will be NULL.
+ *
+ * This function will overwrite the contents of @name, @type and @flags.
+ * The contents of @min, @max, @step and @def may be modified depending on
+ * the type.
+ *
+ * Do not use in drivers! It is used internally for backwards compatibility
+ * control handling only. Once all drivers are converted to use the new
+ * control framework this function will no longer be exported.
+ */
 void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		    s64 *min, s64 *max, u64 *step, s64 *def, u32 *flags);
 
 
-/** v4l2_ctrl_handler_init_class() - Initialize the control handler.
-  * @hdl:	The control handler.
-  * @nr_of_controls_hint: A hint of how many controls this handler is
-  *		expected to refer to. This is the total number, so including
-  *		any inherited controls. It doesn't have to be precise, but if
-  *		it is way off, then you either waste memory (too many buckets
-  *		are allocated) or the control lookup becomes slower (not enough
-  *		buckets are allocated, so there are more slow list lookups).
-  *		It will always work, though.
-  * @key:	Used by the lock validator if CONFIG_LOCKDEP is set.
-  * @name:	Used by the lock validator if CONFIG_LOCKDEP is set.
-  *
-  * Returns an error if the buckets could not be allocated. This error will
-  * also be stored in @hdl->error.
-  *
-  * Never use this call directly, always use the v4l2_ctrl_handler_init
-  * macro that hides the @key and @name arguments.
-  */
+/**
+ * v4l2_ctrl_handler_init_class() - Initialize the control handler.
+ * @hdl:	The control handler.
+ * @nr_of_controls_hint: A hint of how many controls this handler is
+ *		expected to refer to. This is the total number, so including
+ *		any inherited controls. It doesn't have to be precise, but if
+ *		it is way off, then you either waste memory (too many buckets
+ *		are allocated) or the control lookup becomes slower (not enough
+ *		buckets are allocated, so there are more slow list lookups).
+ *		It will always work, though.
+ * @key:	Used by the lock validator if CONFIG_LOCKDEP is set.
+ * @name:	Used by the lock validator if CONFIG_LOCKDEP is set.
+ *
+ * Returns an error if the buckets could not be allocated. This error will
+ * also be stored in @hdl->error.
+ *
+ * Never use this call directly, always use the v4l2_ctrl_handler_init
+ * macro that hides the @key and @name arguments.
+ */
 int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
 				 unsigned nr_of_controls_hint,
 				 struct lock_class_key *key, const char *name);
@@ -361,289 +372,326 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
 	v4l2_ctrl_handler_init_class(hdl, nr_of_controls_hint, NULL, NULL)
 #endif
 
-/** v4l2_ctrl_handler_free() - Free all controls owned by the handler and free
-  * the control list.
-  * @hdl:	The control handler.
-  *
-  * Does nothing if @hdl == NULL.
-  */
+/**
+ * v4l2_ctrl_handler_free() - Free all controls owned by the handler and free
+ * the control list.
+ * @hdl:	The control handler.
+ *
+ * Does nothing if @hdl == NULL.
+ */
 void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl);
 
-/** v4l2_ctrl_lock() - Helper function to lock the handler
-  * associated with the control.
-  * @ctrl:	The control to lock.
-  */
+/**
+ * v4l2_ctrl_lock() - Helper function to lock the handler
+ * associated with the control.
+ * @ctrl:	The control to lock.
+ */
 static inline void v4l2_ctrl_lock(struct v4l2_ctrl *ctrl)
 {
 	mutex_lock(ctrl->handler->lock);
 }
 
-/** v4l2_ctrl_unlock() - Helper function to unlock the handler
-  * associated with the control.
-  * @ctrl:	The control to unlock.
-  */
+/**
+ * v4l2_ctrl_unlock() - Helper function to unlock the handler
+ * associated with the control.
+ * @ctrl:	The control to unlock.
+ */
 static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
 {
 	mutex_unlock(ctrl->handler->lock);
 }
 
-/** v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
-  * to the handler to initialize the hardware to the current control values.
-  * @hdl:	The control handler.
-  *
-  * Button controls will be skipped, as are read-only controls.
-  *
-  * If @hdl == NULL, then this just returns 0.
-  */
+/**
+ * v4l2_ctrl_handler_setup() - Call the s_ctrl op for all controls belonging
+ * to the handler to initialize the hardware to the current control values.
+ * @hdl:	The control handler.
+ *
+ * Button controls will be skipped, as are read-only controls.
+ *
+ * If @hdl == NULL, then this just returns 0.
+ */
 int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl);
 
-/** v4l2_ctrl_handler_log_status() - Log all controls owned by the handler.
-  * @hdl:	The control handler.
-  * @prefix:	The prefix to use when logging the control values. If the
-  *		prefix does not end with a space, then ": " will be added
-  *		after the prefix. If @prefix == NULL, then no prefix will be
-  *		used.
-  *
-  * For use with VIDIOC_LOG_STATUS.
-  *
-  * Does nothing if @hdl == NULL.
-  */
+/**
+ * v4l2_ctrl_handler_log_status() - Log all controls owned by the handler.
+ * @hdl:	The control handler.
+ * @prefix:	The prefix to use when logging the control values. If the
+ *		prefix does not end with a space, then ": " will be added
+ *		after the prefix. If @prefix == NULL, then no prefix will be
+ *		used.
+ *
+ * For use with VIDIOC_LOG_STATUS.
+ *
+ * Does nothing if @hdl == NULL.
+ */
 void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
 				  const char *prefix);
 
-/** v4l2_ctrl_new_custom() - Allocate and initialize a new custom V4L2
-  * control.
-  * @hdl:	The control handler.
-  * @cfg:	The control's configuration data.
-  * @priv:	The control's driver-specific private data.
-  *
-  * If the &v4l2_ctrl struct could not be allocated then NULL is returned
-  * and @hdl->error is set to the error code (if it wasn't set already).
-  */
+/**
+ * v4l2_ctrl_new_custom() - Allocate and initialize a new custom V4L2
+ * control.
+ * @hdl:	The control handler.
+ * @cfg:	The control's configuration data.
+ * @priv:	The control's driver-specific private data.
+ *
+ * If the &v4l2_ctrl struct could not be allocated then NULL is returned
+ * and @hdl->error is set to the error code (if it wasn't set already).
+ */
 struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_config *cfg, void *priv);
 
-/** v4l2_ctrl_new_std() - Allocate and initialize a new standard V4L2 non-menu control.
-  * @hdl:	The control handler.
-  * @ops:	The control ops.
-  * @id:	The control ID.
-  * @min:	The control's minimum value.
-  * @max:	The control's maximum value.
-  * @step:	The control's step value
-  * @def: 	The control's default value.
-  *
-  * If the &v4l2_ctrl struct could not be allocated, or the control
-  * ID is not known, then NULL is returned and @hdl->error is set to the
-  * appropriate error code (if it wasn't set already).
-  *
-  * If @id refers to a menu control, then this function will return NULL.
-  *
-  * Use v4l2_ctrl_new_std_menu() when adding menu controls.
-  */
+/**
+ * v4l2_ctrl_new_std() - Allocate and initialize a new standard V4L2 non-menu control.
+ * @hdl:	The control handler.
+ * @ops:	The control ops.
+ * @id:	The control ID.
+ * @min:	The control's minimum value.
+ * @max:	The control's maximum value.
+ * @step:	The control's step value
+ * @def: 	The control's default value.
+ *
+ * If the &v4l2_ctrl struct could not be allocated, or the control
+ * ID is not known, then NULL is returned and @hdl->error is set to the
+ * appropriate error code (if it wasn't set already).
+ *
+ * If @id refers to a menu control, then this function will return NULL.
+ *
+ * Use v4l2_ctrl_new_std_menu() when adding menu controls.
+ */
 struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s64 min, s64 max, u64 step, s64 def);
 
-/** v4l2_ctrl_new_std_menu() - Allocate and initialize a new standard V4L2 menu control.
-  * @hdl:	The control handler.
-  * @ops:	The control ops.
-  * @id:	The control ID.
-  * @max:	The control's maximum value.
-  * @mask: 	The control's skip mask for menu controls. This makes it
-  *		easy to skip menu items that are not valid. If bit X is set,
-  *		then menu item X is skipped. Of course, this only works for
-  *		menus with <= 64 menu items. There are no menus that come
-  *		close to that number, so this is OK. Should we ever need more,
-  *		then this will have to be extended to a bit array.
-  * @def: 	The control's default value.
-  *
-  * Same as v4l2_ctrl_new_std(), but @min is set to 0 and the @mask value
-  * determines which menu items are to be skipped.
-  *
-  * If @id refers to a non-menu control, then this function will return NULL.
-  */
+/**
+ * v4l2_ctrl_new_std_menu() - Allocate and initialize a new standard V4L2 menu control.
+ * @hdl:	The control handler.
+ * @ops:	The control ops.
+ * @id:	The control ID.
+ * @max:	The control's maximum value.
+ * @mask: 	The control's skip mask for menu controls. This makes it
+ *		easy to skip menu items that are not valid. If bit X is set,
+ *		then menu item X is skipped. Of course, this only works for
+ *		menus with <= 64 menu items. There are no menus that come
+ *		close to that number, so this is OK. Should we ever need more,
+ *		then this will have to be extended to a bit array.
+ * @def: 	The control's default value.
+ *
+ * Same as v4l2_ctrl_new_std(), but @min is set to 0 and the @mask value
+ * determines which menu items are to be skipped.
+ *
+ * If @id refers to a non-menu control, then this function will return NULL.
+ */
 struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, u8 max, u64 mask, u8 def);
 
-/** v4l2_ctrl_new_std_menu_items() - Create a new standard V4L2 menu control
-  * with driver specific menu.
-  * @hdl:	The control handler.
-  * @ops:	The control ops.
-  * @id:	The control ID.
-  * @max:	The control's maximum value.
-  * @mask:	The control's skip mask for menu controls. This makes it
-  *		easy to skip menu items that are not valid. If bit X is set,
-  *		then menu item X is skipped. Of course, this only works for
-  *		menus with <= 64 menu items. There are no menus that come
-  *		close to that number, so this is OK. Should we ever need more,
-  *		then this will have to be extended to a bit array.
-  * @def:	The control's default value.
-  * @qmenu:	The new menu.
-  *
-  * Same as v4l2_ctrl_new_std_menu(), but @qmenu will be the driver specific
-  * menu of this control.
-  *
-  */
+/**
+ * v4l2_ctrl_new_std_menu_items() - Create a new standard V4L2 menu control
+ * with driver specific menu.
+ * @hdl:	The control handler.
+ * @ops:	The control ops.
+ * @id:	The control ID.
+ * @max:	The control's maximum value.
+ * @mask:	The control's skip mask for menu controls. This makes it
+ *		easy to skip menu items that are not valid. If bit X is set,
+ *		then menu item X is skipped. Of course, this only works for
+ *		menus with <= 64 menu items. There are no menus that come
+ *		close to that number, so this is OK. Should we ever need more,
+ *		then this will have to be extended to a bit array.
+ * @def:	The control's default value.
+ * @qmenu:	The new menu.
+ *
+ * Same as v4l2_ctrl_new_std_menu(), but @qmenu will be the driver specific
+ * menu of this control.
+ *
+ */
 struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops, u32 id, u8 max,
 			u64 mask, u8 def, const char * const *qmenu);
 
-/** v4l2_ctrl_new_int_menu() - Create a new standard V4L2 integer menu control.
-  * @hdl:	The control handler.
-  * @ops:	The control ops.
-  * @id:	The control ID.
-  * @max:	The control's maximum value.
-  * @def:	The control's default value.
-  * @qmenu_int:	The control's menu entries.
-  *
-  * Same as v4l2_ctrl_new_std_menu(), but @mask is set to 0 and it additionaly
-  * takes as an argument an array of integers determining the menu items.
-  *
-  * If @id refers to a non-integer-menu control, then this function will return NULL.
-  */
+/**
+ * v4l2_ctrl_new_int_menu() - Create a new standard V4L2 integer menu control.
+ * @hdl:	The control handler.
+ * @ops:	The control ops.
+ * @id:	The control ID.
+ * @max:	The control's maximum value.
+ * @def:	The control's default value.
+ * @qmenu_int:	The control's menu entries.
+ *
+ * Same as v4l2_ctrl_new_std_menu(), but @mask is set to 0 and it additionaly
+ * takes as an argument an array of integers determining the menu items.
+ *
+ * If @id refers to a non-integer-menu control, then this function will return NULL.
+ */
 struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, u8 max, u8 def, const s64 *qmenu_int);
 
-/** v4l2_ctrl_add_ctrl() - Add a control from another handler to this handler.
-  * @hdl:	The control handler.
-  * @ctrl:	The control to add.
-  *
-  * It will return NULL if it was unable to add the control reference.
-  * If the control already belonged to the handler, then it will do
-  * nothing and just return @ctrl.
-  */
+/**
+ * v4l2_ctrl_add_ctrl() - Add a control from another handler to this handler.
+ * @hdl:	The control handler.
+ * @ctrl:	The control to add.
+ *
+ * It will return NULL if it was unable to add the control reference.
+ * If the control already belonged to the handler, then it will do
+ * nothing and just return @ctrl.
+ */
 struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
 					  struct v4l2_ctrl *ctrl);
 
-/** v4l2_ctrl_add_handler() - Add all controls from handler @add to
-  * handler @hdl.
-  * @hdl:	The control handler.
-  * @add:	The control handler whose controls you want to add to
-  *		the @hdl control handler.
-  * @filter:	This function will filter which controls should be added.
-  *
-  * Does nothing if either of the two handlers is a NULL pointer.
-  * If @filter is NULL, then all controls are added. Otherwise only those
-  * controls for which @filter returns true will be added.
-  * In case of an error @hdl->error will be set to the error code (if it
-  * wasn't set already).
-  */
+/**
+ * v4l2_ctrl_add_handler() - Add all controls from handler @add to
+ * handler @hdl.
+ * @hdl:	The control handler.
+ * @add:	The control handler whose controls you want to add to
+ *		the @hdl control handler.
+ * @filter:	This function will filter which controls should be added.
+ *
+ * Does nothing if either of the two handlers is a NULL pointer.
+ * If @filter is NULL, then all controls are added. Otherwise only those
+ * controls for which @filter returns true will be added.
+ * In case of an error @hdl->error will be set to the error code (if it
+ * wasn't set already).
+ */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 			  struct v4l2_ctrl_handler *add,
 			  bool (*filter)(const struct v4l2_ctrl *ctrl));
 
-/** v4l2_ctrl_radio_filter() - Standard filter for radio controls.
-  * @ctrl:	The control that is filtered.
-  *
-  * This will return true for any controls that are valid for radio device
-  * nodes. Those are all of the V4L2_CID_AUDIO_* user controls and all FM
-  * transmitter class controls.
-  *
-  * This function is to be used with v4l2_ctrl_add_handler().
-  */
+/**
+ * v4l2_ctrl_radio_filter() - Standard filter for radio controls.
+ * @ctrl:	The control that is filtered.
+ *
+ * This will return true for any controls that are valid for radio device
+ * nodes. Those are all of the V4L2_CID_AUDIO_* user controls and all FM
+ * transmitter class controls.
+ *
+ * This function is to be used with v4l2_ctrl_add_handler().
+ */
 bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl);
 
-/** v4l2_ctrl_cluster() - Mark all controls in the cluster as belonging to that cluster.
-  * @ncontrols:	The number of controls in this cluster.
-  * @controls: 	The cluster control array of size @ncontrols.
-  */
+/**
+ * v4l2_ctrl_cluster() - Mark all controls in the cluster as belonging to that cluster.
+ * @ncontrols:	The number of controls in this cluster.
+ * @controls: 	The cluster control array of size @ncontrols.
+ */
 void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
 
 
-/** v4l2_ctrl_auto_cluster() - Mark all controls in the cluster as belonging to
-  * that cluster and set it up for autofoo/foo-type handling.
-  * @ncontrols:	The number of controls in this cluster.
-  * @controls:	The cluster control array of size @ncontrols. The first control
-  *		must be the 'auto' control (e.g. autogain, autoexposure, etc.)
-  * @manual_val: The value for the first control in the cluster that equals the
-  *		manual setting.
-  * @set_volatile: If true, then all controls except the first auto control will
-  *		be volatile.
-  *
-  * Use for control groups where one control selects some automatic feature and
-  * the other controls are only active whenever the automatic feature is turned
-  * off (manual mode). Typical examples: autogain vs gain, auto-whitebalance vs
-  * red and blue balance, etc.
-  *
-  * The behavior of such controls is as follows:
-  *
-  * When the autofoo control is set to automatic, then any manual controls
-  * are set to inactive and any reads will call g_volatile_ctrl (if the control
-  * was marked volatile).
-  *
-  * When the autofoo control is set to manual, then any manual controls will
-  * be marked active, and any reads will just return the current value without
-  * going through g_volatile_ctrl.
-  *
-  * In addition, this function will set the V4L2_CTRL_FLAG_UPDATE flag
-  * on the autofoo control and V4L2_CTRL_FLAG_INACTIVE on the foo control(s)
-  * if autofoo is in auto mode.
-  */
+/**
+ * v4l2_ctrl_auto_cluster() - Mark all controls in the cluster as belonging to
+ * that cluster and set it up for autofoo/foo-type handling.
+ * @ncontrols:	The number of controls in this cluster.
+ * @controls:	The cluster control array of size @ncontrols. The first control
+ *		must be the 'auto' control (e.g. autogain, autoexposure, etc.)
+ * @manual_val: The value for the first control in the cluster that equals the
+ *		manual setting.
+ * @set_volatile: If true, then all controls except the first auto control will
+ *		be volatile.
+ *
+ * Use for control groups where one control selects some automatic feature and
+ * the other controls are only active whenever the automatic feature is turned
+ * off (manual mode). Typical examples: autogain vs gain, auto-whitebalance vs
+ * red and blue balance, etc.
+ *
+ * The behavior of such controls is as follows:
+ *
+ * When the autofoo control is set to automatic, then any manual controls
+ * are set to inactive and any reads will call g_volatile_ctrl (if the control
+ * was marked volatile).
+ *
+ * When the autofoo control is set to manual, then any manual controls will
+ * be marked active, and any reads will just return the current value without
+ * going through g_volatile_ctrl.
+ *
+ * In addition, this function will set the V4L2_CTRL_FLAG_UPDATE flag
+ * on the autofoo control and V4L2_CTRL_FLAG_INACTIVE on the foo control(s)
+ * if autofoo is in auto mode.
+ */
 void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
 			u8 manual_val, bool set_volatile);
 
 
-/** v4l2_ctrl_find() - Find a control with the given ID.
-  * @hdl:	The control handler.
-  * @id:	The control ID to find.
-  *
-  * If @hdl == NULL this will return NULL as well. Will lock the handler so
-  * do not use from inside &v4l2_ctrl_ops.
-  */
+/**
+ * v4l2_ctrl_find() - Find a control with the given ID.
+ * @hdl:	The control handler.
+ * @id:	The control ID to find.
+ *
+ * If @hdl == NULL this will return NULL as well. Will lock the handler so
+ * do not use from inside &v4l2_ctrl_ops.
+ */
 struct v4l2_ctrl *v4l2_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
 
-/** v4l2_ctrl_activate() - Make the control active or inactive.
-  * @ctrl:	The control to (de)activate.
-  * @active:	True if the control should become active.
-  *
-  * This sets or clears the V4L2_CTRL_FLAG_INACTIVE flag atomically.
-  * Does nothing if @ctrl == NULL.
-  * This will usually be called from within the s_ctrl op.
-  * The V4L2_EVENT_CTRL event will be generated afterwards.
-  *
-  * This function assumes that the control handler is locked.
-  */
+/**
+ * v4l2_ctrl_activate() - Make the control active or inactive.
+ * @ctrl:	The control to (de)activate.
+ * @active:	True if the control should become active.
+ *
+ * This sets or clears the V4L2_CTRL_FLAG_INACTIVE flag atomically.
+ * Does nothing if @ctrl == NULL.
+ * This will usually be called from within the s_ctrl op.
+ * The V4L2_EVENT_CTRL event will be generated afterwards.
+ *
+ * This function assumes that the control handler is locked.
+ */
 void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
 
-/** v4l2_ctrl_grab() - Mark the control as grabbed or not grabbed.
-  * @ctrl:	The control to (de)activate.
-  * @grabbed:	True if the control should become grabbed.
-  *
-  * This sets or clears the V4L2_CTRL_FLAG_GRABBED flag atomically.
-  * Does nothing if @ctrl == NULL.
-  * The V4L2_EVENT_CTRL event will be generated afterwards.
-  * This will usually be called when starting or stopping streaming in the
-  * driver.
-  *
-  * This function assumes that the control handler is not locked and will
-  * take the lock itself.
-  */
+/**
+ * v4l2_ctrl_grab() - Mark the control as grabbed or not grabbed.
+ * @ctrl:	The control to (de)activate.
+ * @grabbed:	True if the control should become grabbed.
+ *
+ * This sets or clears the V4L2_CTRL_FLAG_GRABBED flag atomically.
+ * Does nothing if @ctrl == NULL.
+ * The V4L2_EVENT_CTRL event will be generated afterwards.
+ * This will usually be called when starting or stopping streaming in the
+ * driver.
+ *
+ * This function assumes that the control handler is not locked and will
+ * take the lock itself.
+ */
 void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
 
 
-/** __v4l2_ctrl_modify_range() - Unlocked variant of v4l2_ctrl_modify_range() */
+/**
+ *__v4l2_ctrl_modify_range() - Unlocked variant of v4l2_ctrl_modify_range()
+ *
+ * @ctrl:	The control to update.
+ * @min:	The control's minimum value.
+ * @max:	The control's maximum value.
+ * @step:	The control's step value
+ * @def:	The control's default value.
+ *
+ * Update the range of a control on the fly. This works for control types
+ * INTEGER, BOOLEAN, MENU, INTEGER MENU and BITMASK. For menu controls the
+ * @step value is interpreted as a menu_skip_mask.
+ *
+ * An error is returned if one of the range arguments is invalid for this
+ * control type.
+ *
+ * This function assumes that the control handler is not locked and will
+ * take the lock itself.
+ */
 int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 			     s64 min, s64 max, u64 step, s64 def);
 
-/** v4l2_ctrl_modify_range() - Update the range of a control.
-  * @ctrl:	The control to update.
-  * @min:	The control's minimum value.
-  * @max:	The control's maximum value.
-  * @step:	The control's step value
-  * @def:	The control's default value.
-  *
-  * Update the range of a control on the fly. This works for control types
-  * INTEGER, BOOLEAN, MENU, INTEGER MENU and BITMASK. For menu controls the
-  * @step value is interpreted as a menu_skip_mask.
-  *
-  * An error is returned if one of the range arguments is invalid for this
-  * control type.
-  *
-  * This function assumes that the control handler is not locked and will
-  * take the lock itself.
-  */
+/**
+ * v4l2_ctrl_modify_range() - Update the range of a control.
+ * @ctrl:	The control to update.
+ * @min:	The control's minimum value.
+ * @max:	The control's maximum value.
+ * @step:	The control's step value
+ * @def:	The control's default value.
+ *
+ * Update the range of a control on the fly. This works for control types
+ * INTEGER, BOOLEAN, MENU, INTEGER MENU and BITMASK. For menu controls the
+ * @step value is interpreted as a menu_skip_mask.
+ *
+ * An error is returned if one of the range arguments is invalid for this
+ * control type.
+ *
+ * This function assumes that the control handler is not locked and will
+ * take the lock itself.
+ */
 static inline int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 					 s64 min, s64 max, u64 step, s64 def)
 {
@@ -656,21 +704,23 @@ static inline int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	return rval;
 }
 
-/** v4l2_ctrl_notify() - Function to set a notify callback for a control.
-  * @ctrl:	The control.
-  * @notify:	The callback function.
-  * @priv:	The callback private handle, passed as argument to the callback.
-  *
-  * This function sets a callback function for the control. If @ctrl is NULL,
-  * then it will do nothing. If @notify is NULL, then the notify callback will
-  * be removed.
-  *
-  * There can be only one notify. If another already exists, then a WARN_ON
-  * will be issued and the function will do nothing.
-  */
+/**
+ * v4l2_ctrl_notify() - Function to set a notify callback for a control.
+ * @ctrl:	The control.
+ * @notify:	The callback function.
+ * @priv:	The callback private handle, passed as argument to the callback.
+ *
+ * This function sets a callback function for the control. If @ctrl is NULL,
+ * then it will do nothing. If @notify is NULL, then the notify callback will
+ * be removed.
+ *
+ * There can be only one notify. If another already exists, then a WARN_ON
+ * will be issued and the function will do nothing.
+ */
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv);
 
-/** v4l2_ctrl_get_name() - Get the name of the control
+/**
+ * v4l2_ctrl_get_name() - Get the name of the control
  * @id:		The control ID.
  *
  * This function returns the name of the given control ID or NULL if it isn't
@@ -678,7 +728,8 @@ void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void
  */
 const char *v4l2_ctrl_get_name(u32 id);
 
-/** v4l2_ctrl_get_menu() - Get the menu string array of the control
+/**
+ * v4l2_ctrl_get_menu() - Get the menu string array of the control
  * @id:		The control ID.
  *
  * This function returns the NULL-terminated menu string array name of the
@@ -686,7 +737,8 @@ const char *v4l2_ctrl_get_name(u32 id);
  */
 const char * const *v4l2_ctrl_get_menu(u32 id);
 
-/** v4l2_ctrl_get_int_menu() - Get the integer menu array of the control
+/**
+ * v4l2_ctrl_get_int_menu() - Get the integer menu array of the control
  * @id:		The control ID.
  * @len:	The size of the integer array.
  *
@@ -695,29 +747,41 @@ const char * const *v4l2_ctrl_get_menu(u32 id);
  */
 const s64 *v4l2_ctrl_get_int_menu(u32 id, u32 *len);
 
-/** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
-  * @ctrl:	The control.
-  *
-  * This returns the control's value safely by going through the control
-  * framework. This function will lock the control's handler, so it cannot be
-  * used from within the &v4l2_ctrl_ops functions.
-  *
-  * This function is for integer type controls only.
-  */
+/**
+ * v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
+ * @ctrl:	The control.
+ *
+ * This returns the control's value safely by going through the control
+ * framework. This function will lock the control's handler, so it cannot be
+ * used from within the &v4l2_ctrl_ops functions.
+ *
+ * This function is for integer type controls only.
+ */
 s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
 
-/** __v4l2_ctrl_s_ctrl() - Unlocked variant of v4l2_ctrl_s_ctrl(). */
+/**
+ * __v4l2_ctrl_s_ctrl() - Unlocked variant of v4l2_ctrl_s_ctrl().
+ * @ctrl:	The control.
+ * @val:	The new value.
+ *
+ * This set the control's new value safely by going through the control
+ * framework. This function will lock the control's handler, so it cannot be
+ * used from within the &v4l2_ctrl_ops functions.
+ *
+ * This function is for integer type controls only.
+ */
 int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
+
 /** v4l2_ctrl_s_ctrl() - Helper function to set the control's value from within a driver.
-  * @ctrl:	The control.
-  * @val:	The new value.
-  *
-  * This set the control's new value safely by going through the control
-  * framework. This function will lock the control's handler, so it cannot be
-  * used from within the &v4l2_ctrl_ops functions.
-  *
-  * This function is for integer type controls only.
-  */
+ * @ctrl:	The control.
+ * @val:	The new value.
+ *
+ * This set the control's new value safely by going through the control
+ * framework. This function will lock the control's handler, so it cannot be
+ * used from within the &v4l2_ctrl_ops functions.
+ *
+ * This function is for integer type controls only.
+ */
 static inline int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
 	int rval;
@@ -729,30 +793,45 @@ static inline int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 	return rval;
 }
 
-/** v4l2_ctrl_g_ctrl_int64() - Helper function to get a 64-bit control's value from within a driver.
-  * @ctrl:	The control.
-  *
-  * This returns the control's value safely by going through the control
-  * framework. This function will lock the control's handler, so it cannot be
-  * used from within the &v4l2_ctrl_ops functions.
-  *
-  * This function is for 64-bit integer type controls only.
-  */
+/**
+ * v4l2_ctrl_g_ctrl_int64() - Helper function to get a 64-bit control's value
+ *	from within a driver.
+ * @ctrl:	The control.
+ *
+ * This returns the control's value safely by going through the control
+ * framework. This function will lock the control's handler, so it cannot be
+ * used from within the &v4l2_ctrl_ops functions.
+ *
+ * This function is for 64-bit integer type controls only.
+ */
 s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl);
 
-/** __v4l2_ctrl_s_ctrl_int64() - Unlocked variant of v4l2_ctrl_s_ctrl_int64(). */
+/**
+ * __v4l2_ctrl_s_ctrl_int64() - Unlocked variant of v4l2_ctrl_s_ctrl_int64().
+ *
+ * @ctrl:	The control.
+ * @val:	The new value.
+ *
+ * This set the control's new value safely by going through the control
+ * framework. This function will lock the control's handler, so it cannot be
+ * used from within the &v4l2_ctrl_ops functions.
+ *
+ * This function is for 64-bit integer type controls only.
+ */
 int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val);
 
-/** v4l2_ctrl_s_ctrl_int64() - Helper function to set a 64-bit control's value from within a driver.
-  * @ctrl:	The control.
-  * @val:	The new value.
-  *
-  * This set the control's new value safely by going through the control
-  * framework. This function will lock the control's handler, so it cannot be
-  * used from within the &v4l2_ctrl_ops functions.
-  *
-  * This function is for 64-bit integer type controls only.
-  */
+/** v4l2_ctrl_s_ctrl_int64() - Helper function to set a 64-bit control's value
+ *	from within a driver.
+ *
+ * @ctrl:	The control.
+ * @val:	The new value.
+ *
+ * This set the control's new value safely by going through the control
+ * framework. This function will lock the control's handler, so it cannot be
+ * used from within the &v4l2_ctrl_ops functions.
+ *
+ * This function is for 64-bit integer type controls only.
+ */
 static inline int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 {
 	int rval;
@@ -764,19 +843,31 @@ static inline int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 	return rval;
 }
 
-/** __v4l2_ctrl_s_ctrl_string() - Unlocked variant of v4l2_ctrl_s_ctrl_string(). */
+/** __v4l2_ctrl_s_ctrl_string() - Unlocked variant of v4l2_ctrl_s_ctrl_string().
+ *
+ * @ctrl:	The control.
+ * @s:		The new string.
+ *
+ * This set the control's new string safely by going through the control
+ * framework. This function will lock the control's handler, so it cannot be
+ * used from within the &v4l2_ctrl_ops functions.
+ *
+ * This function is for string type controls only.
+ */
 int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s);
 
-/** v4l2_ctrl_s_ctrl_string() - Helper function to set a control's string value from within a driver.
-  * @ctrl:	The control.
-  * @s:		The new string.
-  *
-  * This set the control's new string safely by going through the control
-  * framework. This function will lock the control's handler, so it cannot be
-  * used from within the &v4l2_ctrl_ops functions.
-  *
-  * This function is for string type controls only.
-  */
+/** v4l2_ctrl_s_ctrl_string() - Helper function to set a control's string value
+ *	 from within a driver.
+ *
+ * @ctrl:	The control.
+ * @s:		The new string.
+ *
+ * This set the control's new string safely by going through the control
+ * framework. This function will lock the control's handler, so it cannot be
+ * used from within the &v4l2_ctrl_ops functions.
+ *
+ * This function is for string type controls only.
+ */
 static inline int v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 {
 	int rval;
-- 
2.4.3

