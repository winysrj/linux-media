Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbcGWD32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 23:29:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] [media] v4l2-ctrls.h: fully document the header file
Date: Sat, 23 Jul 2016 00:29:20 -0300
Message-Id: <fd20fc5ae65d3cd338b9925f633b2b962546b73f.1469244556.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of undocumented stuff on this header.

Document them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-ctrls.h | 365 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 279 insertions(+), 86 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index d6f63406b885..178a88d45aea 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1,21 +1,17 @@
 /*
-    V4L2 controls support header.
-
-    Copyright (C) 2010  Hans Verkuil <hverkuil@xs4all.nl>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *  V4L2 controls support header.
+ *
+ *  Copyright (C) 2010  Hans Verkuil <hverkuil@xs4all.nl>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
  */
 
 #ifndef _V4L2_CTRLS_H
@@ -58,6 +54,7 @@ union v4l2_ctrl_ptr {
 
 /**
  * struct v4l2_ctrl_ops - The control operations that the driver has to provide.
+ *
  * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
  *		for volatile (and usually read-only) controls such as a control
  *		that returns the current signal strength which changes
@@ -77,12 +74,13 @@ struct v4l2_ctrl_ops {
 
 /**
  * struct v4l2_ctrl_type_ops - The control type operations that the driver
- * 			       has to provide.
+ *			       has to provide.
  *
  * @equal: return true if both values are equal.
  * @init: initialize the value.
  * @log: log the value.
- * @validate: validate the value. Return 0 on success and a negative value otherwise.
+ * @validate: validate the value. Return 0 on success and a negative value
+ *	otherwise.
  */
 struct v4l2_ctrl_type_ops {
 	bool (*equal)(const struct v4l2_ctrl *ctrl, u32 idx,
@@ -99,6 +97,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
 
 /**
  * struct v4l2_ctrl - The control structure.
+ *
  * @node:	The list node.
  * @ev_subs:	The list of control event subscriptions.
  * @handler:	The handler that owns the control.
@@ -106,7 +105,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
  * @ncontrols:	Number of controls in cluster array.
  * @done:	Internal flag: set for each processed control.
  * @is_new:	Set when the user specified a new value for this control. It
- *		is also set when called from v4l2_ctrl_handler_setup. Drivers
+ *		is also set when called from v4l2_ctrl_handler_setup(). Drivers
  *		should never set this flag.
  * @has_changed: Set when the current value differs from the new value. Drivers
  *		should never use this flag.
@@ -119,9 +118,10 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
  *		set this flag directly.
  * @is_int:    If set, then this control has a simple integer value (i.e. it
  *		uses ctrl->val).
- * @is_string: If set, then this control has type V4L2_CTRL_TYPE_STRING.
- * @is_ptr:	If set, then this control is an array and/or has type >= V4L2_CTRL_COMPOUND_TYPES
- *		and/or has type V4L2_CTRL_TYPE_STRING. In other words, struct
+ * @is_string: If set, then this control has type %V4L2_CTRL_TYPE_STRING.
+ * @is_ptr:	If set, then this control is an array and/or has type >=
+ *		%V4L2_CTRL_COMPOUND_TYPES
+ *		and/or has type %V4L2_CTRL_TYPE_STRING. In other words, &struct
  *		v4l2_ext_control uses field p to point to the data.
  * @is_array: If set, then this control contains an N-dimensional array.
  * @has_volatiles: If set, then one or more members of the cluster are volatile.
@@ -177,7 +177,8 @@ struct v4l2_ctrl {
 	struct list_head ev_subs;
 	struct v4l2_ctrl_handler *handler;
 	struct v4l2_ctrl **cluster;
-	unsigned ncontrols;
+	unsigned int ncontrols;
+
 	unsigned int done:1;
 
 	unsigned int is_new:1;
@@ -223,10 +224,12 @@ struct v4l2_ctrl {
 
 /**
  * struct v4l2_ctrl_ref - The control reference.
+ *
  * @node:	List node for the sorted list.
  * @next:	Single-link list node for the hash.
  * @ctrl:	The actual control information.
- * @helper:	Pointer to helper struct. Used internally in prepare_ext_ctrls().
+ * @helper:	Pointer to helper struct. Used internally in
+ *		prepare_ext_ctrls().
  *
  * Each control handler has a list of these refs. The list_head is used to
  * keep a sorted-by-control-ID list of all controls, while the next pointer
@@ -241,8 +244,9 @@ struct v4l2_ctrl_ref {
 
 /**
  * struct v4l2_ctrl_handler - The control handler keeps track of all the
- * controls: both the controls owned by the handler and those inherited
- * from other handlers.
+ *	controls: both the controls owned by the handler and those inherited
+ *	from other handlers.
+ *
  * @_lock:	Default for "lock".
  * @lock:	Lock to control access to this handler and its controls.
  *		May be replaced by the user right after init.
@@ -252,7 +256,8 @@ struct v4l2_ctrl_ref {
  *		control is needed multiple times, so this is a simple
  *		optimization.
  * @buckets:	Buckets for the hashing. Allows for quick control lookup.
- * @notify:	A notify callback that is called whenever the control changes value.
+ * @notify:	A notify callback that is called whenever the control changes
+ *		value.
  *		Note that the handler's lock is held when the notify function
  *		is called!
  * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
@@ -274,6 +279,7 @@ struct v4l2_ctrl_handler {
 
 /**
  * struct v4l2_ctrl_config - Control configuration structure.
+ *
  * @ops:	The control ops.
  * @type_ops:	The control type ops. Only needed for compound controls.
  * @id:	The control ID.
@@ -282,7 +288,7 @@ struct v4l2_ctrl_handler {
  * @min:	The control's minimum value.
  * @max:	The control's maximum value.
  * @step:	The control's step value for non-menu controls.
- * @def: 	The control's default value.
+ * @def:	The control's default value.
  * @dims:	The size of each dimension.
  * @elem_size:	The size in bytes of the control.
  * @flags:	The control's flags.
@@ -297,7 +303,7 @@ struct v4l2_ctrl_handler {
  *		is in addition to the menu_skip_mask above). The last entry
  *		must be NULL.
  * @qmenu_int:	A const s64 integer array for all menu items of the type
- * 		V4L2_CTRL_TYPE_INTEGER_MENU.
+ *		V4L2_CTRL_TYPE_INTEGER_MENU.
  * @is_private: If set, then this control is private to its handler and it
  *		will not be added to any other handlers.
  */
@@ -320,20 +326,31 @@ struct v4l2_ctrl_config {
 	unsigned int is_private:1;
 };
 
-/*
- * v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
+/**
+ * v4l2_ctrl_fill - Fill in the control fields based on the control ID.
+ *
+ * @id: ID of the control
+ * @name: name of the control
+ * @type: type of the control
+ * @min: minimum value for the control
+ * @max: maximum value for the control
+ * @step: control step
+ * @def: default value for the control
+ * @flags: flags to be used on the control
  *
  * This works for all standard V4L2 controls.
  * For non-standard controls it will only fill in the given arguments
- * and @name will be NULL.
+ * and @name will be %NULL.
  *
  * This function will overwrite the contents of @name, @type and @flags.
  * The contents of @min, @max, @step and @def may be modified depending on
  * the type.
  *
- * Do not use in drivers! It is used internally for backwards compatibility
- * control handling only. Once all drivers are converted to use the new
- * control framework this function will no longer be exported.
+ * .. note::
+ *
+ *    Do not use in drivers! It is used internally for backwards compatibility
+ *    control handling only. Once all drivers are converted to use the new
+ *    control framework this function will no longer be exported.
  */
 void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		    s64 *min, s64 *max, u64 *step, s64 *def, u32 *flags);
@@ -359,7 +376,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
  * macro that hides the @key and @name arguments.
  */
 int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
-				 unsigned nr_of_controls_hint,
+				 unsigned int nr_of_controls_hint,
 				 struct lock_class_key *key, const char *name);
 
 #ifdef CONFIG_LOCKDEP
@@ -436,7 +453,8 @@ void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
 
 /**
  * v4l2_ctrl_new_custom() - Allocate and initialize a new custom V4L2
- * control.
+ *	control.
+ *
  * @hdl:	The control handler.
  * @cfg:	The control's configuration data.
  * @priv:	The control's driver-specific private data.
@@ -445,17 +463,20 @@ void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
  * and @hdl->error is set to the error code (if it wasn't set already).
  */
 struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
-			const struct v4l2_ctrl_config *cfg, void *priv);
+				       const struct v4l2_ctrl_config *cfg,
+				       void *priv);
 
 /**
- * v4l2_ctrl_new_std() - Allocate and initialize a new standard V4L2 non-menu control.
+ * v4l2_ctrl_new_std() - Allocate and initialize a new standard V4L2 non-menu
+ *	control.
+ *
  * @hdl:	The control handler.
  * @ops:	The control ops.
- * @id:	The control ID.
+ * @id:		The control ID.
  * @min:	The control's minimum value.
  * @max:	The control's maximum value.
  * @step:	The control's step value
- * @def: 	The control's default value.
+ * @def:	The control's default value.
  *
  * If the &v4l2_ctrl struct could not be allocated, or the control
  * ID is not known, then NULL is returned and @hdl->error is set to the
@@ -466,22 +487,25 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
  * Use v4l2_ctrl_new_std_menu() when adding menu controls.
  */
 struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
-			const struct v4l2_ctrl_ops *ops,
-			u32 id, s64 min, s64 max, u64 step, s64 def);
+				    const struct v4l2_ctrl_ops *ops,
+				    u32 id, s64 min, s64 max, u64 step,
+				    s64 def);
 
 /**
- * v4l2_ctrl_new_std_menu() - Allocate and initialize a new standard V4L2 menu control.
+ * v4l2_ctrl_new_std_menu() - Allocate and initialize a new standard V4L2
+ *	menu control.
+ *
  * @hdl:	The control handler.
  * @ops:	The control ops.
- * @id:	The control ID.
+ * @id:		The control ID.
  * @max:	The control's maximum value.
- * @mask: 	The control's skip mask for menu controls. This makes it
+ * @mask:	The control's skip mask for menu controls. This makes it
  *		easy to skip menu items that are not valid. If bit X is set,
  *		then menu item X is skipped. Of course, this only works for
  *		menus with <= 64 menu items. There are no menus that come
  *		close to that number, so this is OK. Should we ever need more,
  *		then this will have to be extended to a bit array.
- * @def: 	The control's default value.
+ * @def:	The control's default value.
  *
  * Same as v4l2_ctrl_new_std(), but @min is set to 0 and the @mask value
  * determines which menu items are to be skipped.
@@ -489,12 +513,13 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
  * If @id refers to a non-menu control, then this function will return NULL.
  */
 struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
-			const struct v4l2_ctrl_ops *ops,
-			u32 id, u8 max, u64 mask, u8 def);
+					 const struct v4l2_ctrl_ops *ops,
+					 u32 id, u8 max, u64 mask, u8 def);
 
 /**
  * v4l2_ctrl_new_std_menu_items() - Create a new standard V4L2 menu control
- * with driver specific menu.
+ *	with driver specific menu.
+ *
  * @hdl:	The control handler.
  * @ops:	The control ops.
  * @id:	The control ID.
@@ -513,11 +538,14 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
  *
  */
 struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
-			const struct v4l2_ctrl_ops *ops, u32 id, u8 max,
-			u64 mask, u8 def, const char * const *qmenu);
+					       const struct v4l2_ctrl_ops *ops,
+					       u32 id, u8 max,
+					       u64 mask, u8 def,
+					       const char * const *qmenu);
 
 /**
  * v4l2_ctrl_new_int_menu() - Create a new standard V4L2 integer menu control.
+ *
  * @hdl:	The control handler.
  * @ops:	The control ops.
  * @id:	The control ID.
@@ -528,17 +556,20 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
  * Same as v4l2_ctrl_new_std_menu(), but @mask is set to 0 and it additionaly
  * takes as an argument an array of integers determining the menu items.
  *
- * If @id refers to a non-integer-menu control, then this function will return NULL.
+ * If @id refers to a non-integer-menu control, then this function will
+ * return %NULL.
  */
 struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
-			const struct v4l2_ctrl_ops *ops,
-			u32 id, u8 max, u8 def, const s64 *qmenu_int);
+					 const struct v4l2_ctrl_ops *ops,
+					 u32 id, u8 max, u8 def,
+					 const s64 *qmenu_int);
 
 typedef bool (*v4l2_ctrl_filter)(const struct v4l2_ctrl *ctrl);
 
 /**
  * v4l2_ctrl_add_handler() - Add all controls from handler @add to
- * handler @hdl.
+ *	handler @hdl.
+ *
  * @hdl:	The control handler.
  * @add:	The control handler whose controls you want to add to
  *		the @hdl control handler.
@@ -556,6 +587,7 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 
 /**
  * v4l2_ctrl_radio_filter() - Standard filter for radio controls.
+ *
  * @ctrl:	The control that is filtered.
  *
  * This will return true for any controls that are valid for radio device
@@ -567,16 +599,19 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl);
 
 /**
- * v4l2_ctrl_cluster() - Mark all controls in the cluster as belonging to that cluster.
+ * v4l2_ctrl_cluster() - Mark all controls in the cluster as belonging
+ *	to that cluster.
+ *
  * @ncontrols:	The number of controls in this cluster.
- * @controls: 	The cluster control array of size @ncontrols.
+ * @controls:	The cluster control array of size @ncontrols.
  */
-void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
+void v4l2_ctrl_cluster(unsigned int ncontrols, struct v4l2_ctrl **controls);
 
 
 /**
- * v4l2_ctrl_auto_cluster() - Mark all controls in the cluster as belonging to
- * that cluster and set it up for autofoo/foo-type handling.
+ * v4l2_ctrl_auto_cluster() - Mark all controls in the cluster as belonging
+ *	to that cluster and set it up for autofoo/foo-type handling.
+ *
  * @ncontrols:	The number of controls in this cluster.
  * @controls:	The cluster control array of size @ncontrols. The first control
  *		must be the 'auto' control (e.g. autogain, autoexposure, etc.)
@@ -604,12 +639,14 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls);
  * on the autofoo control and V4L2_CTRL_FLAG_INACTIVE on the foo control(s)
  * if autofoo is in auto mode.
  */
-void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
-			u8 manual_val, bool set_volatile);
+void v4l2_ctrl_auto_cluster(unsigned int ncontrols,
+			    struct v4l2_ctrl **controls,
+			    u8 manual_val, bool set_volatile);
 
 
 /**
  * v4l2_ctrl_find() - Find a control with the given ID.
+ *
  * @hdl:	The control handler.
  * @id:	The control ID to find.
  *
@@ -634,6 +671,7 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
 
 /**
  * v4l2_ctrl_grab() - Mark the control as grabbed or not grabbed.
+ *
  * @ctrl:	The control to (de)activate.
  * @grabbed:	True if the control should become grabbed.
  *
@@ -673,6 +711,7 @@ int __v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 
 /**
  * v4l2_ctrl_modify_range() - Update the range of a control.
+ *
  * @ctrl:	The control to update.
  * @min:	The control's minimum value.
  * @max:	The control's maximum value.
@@ -703,6 +742,7 @@ static inline int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 
 /**
  * v4l2_ctrl_notify() - Function to set a notify callback for a control.
+ *
  * @ctrl:	The control.
  * @notify:	The callback function.
  * @priv:	The callback private handle, passed as argument to the callback.
@@ -714,10 +754,12 @@ static inline int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
  * There can be only one notify. If another already exists, then a WARN_ON
  * will be issued and the function will do nothing.
  */
-void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv);
+void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify,
+		      void *priv);
 
 /**
  * v4l2_ctrl_get_name() - Get the name of the control
+ *
  * @id:		The control ID.
  *
  * This function returns the name of the given control ID or NULL if it isn't
@@ -727,6 +769,7 @@ const char *v4l2_ctrl_get_name(u32 id);
 
 /**
  * v4l2_ctrl_get_menu() - Get the menu string array of the control
+ *
  * @id:		The control ID.
  *
  * This function returns the NULL-terminated menu string array name of the
@@ -736,6 +779,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id);
 
 /**
  * v4l2_ctrl_get_int_menu() - Get the integer menu array of the control
+ *
  * @id:		The control ID.
  * @len:	The size of the integer array.
  *
@@ -745,7 +789,9 @@ const char * const *v4l2_ctrl_get_menu(u32 id);
 const s64 *v4l2_ctrl_get_int_menu(u32 id, u32 *len);
 
 /**
- * v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
+ * v4l2_ctrl_g_ctrl() - Helper function to get the control's value from
+ *	within a driver.
+ *
  * @ctrl:	The control.
  *
  * This returns the control's value safely by going through the control
@@ -758,8 +804,9 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
 
 /**
  * __v4l2_ctrl_s_ctrl() - Unlocked variant of v4l2_ctrl_s_ctrl().
+ *
  * @ctrl:	The control.
- * @val:	The new value.
+ * @val:	TheControls name new value.
  *
  * This sets the control's new value safely by going through the control
  * framework. This function assumes the control's handler is already locked,
@@ -769,7 +816,9 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
  */
 int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
-/** v4l2_ctrl_s_ctrl() - Helper function to set the control's value from within a driver.
+/**
+ * v4l2_ctrl_s_ctrl() - Helper function to set the control's value from
+ *	within a driver.
  * @ctrl:	The control.
  * @val:	The new value.
  *
@@ -793,6 +842,7 @@ static inline int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 /**
  * v4l2_ctrl_g_ctrl_int64() - Helper function to get a 64-bit control's value
  *	from within a driver.
+ *
  * @ctrl:	The control.
  *
  * This returns the control's value safely by going through the control
@@ -817,7 +867,8 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl);
  */
 int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val);
 
-/** v4l2_ctrl_s_ctrl_int64() - Helper function to set a 64-bit control's value
+/**
+ * v4l2_ctrl_s_ctrl_int64() - Helper function to set a 64-bit control's value
  *	from within a driver.
  *
  * @ctrl:	The control.
@@ -840,7 +891,8 @@ static inline int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 	return rval;
 }
 
-/** __v4l2_ctrl_s_ctrl_string() - Unlocked variant of v4l2_ctrl_s_ctrl_string().
+/**
+ * __v4l2_ctrl_s_ctrl_string() - Unlocked variant of v4l2_ctrl_s_ctrl_string().
  *
  * @ctrl:	The control.
  * @s:		The new string.
@@ -853,12 +905,13 @@ static inline int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
  */
 int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s);
 
-/** v4l2_ctrl_s_ctrl_string() - Helper function to set a control's string value
+/**
+ * v4l2_ctrl_s_ctrl_string() - Helper function to set a control's string value
  *	 from within a driver.
  *
  * @ctrl:	The control.
  * @s:		The new string.
- *
+ *Controls name
  * This sets the control's new string safely by going through the control
  * framework. This function will lock the control's handler, so it cannot be
  * used from within the &v4l2_ctrl_ops functions.
@@ -878,39 +931,179 @@ static inline int v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
+
+/**
+ * v4l2_ctrl_replace - Function to be used as a callback to
+ *	&struct v4l2_subscribed_event_ops replace\(\)
+ *
+ * @old: pointer to :ref:`struct v4l2_event <v4l2-event>` with the reported
+ *	 event;
+ * @new: pointer to :ref:`struct v4l2_event <v4l2-event>` with the modified
+ *	 event;
+ */
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
+
+/**
+ * v4l2_ctrl_merge - Function to be used as a callback to
+ *	&struct v4l2_subscribed_event_ops merge(\)
+ *
+ * @old: pointer to :ref:`struct v4l2_event <v4l2-event>` with the reported
+ *	 event;
+ * @new: pointer to :ref:`struct v4l2_event <v4l2-event>` with the merged
+ *	 event;
+ */
 void v4l2_ctrl_merge(const struct v4l2_event *old, struct v4l2_event *new);
 
-/* Can be used as a vidioc_log_status function that just dumps all controls
-   associated with the filehandle. */
+/**
+ * v4l2_ctrl_log_status - helper function to implement %VIDIOC_LOG_STATUS ioctl
+ *
+ * @file: pointer to struct file
+ * @fh: unused. Kept just to be compatible to the arguments expected by
+ *	&struct v4l2_ioctl_ops.vidioc_log_status.
+ *
+ * Can be used as a vidioc_log_status function that just dumps all controls
+ * associated with the filehandle.
+ */
 int v4l2_ctrl_log_status(struct file *file, void *fh);
 
-/* Can be used as a vidioc_subscribe_event function that just subscribes
-   control events. */
+/**
+ * v4l2_ctrl_subscribe_event - Subscribes to an event
+ *
+ *
+ * @fh: pointer to struct v4l2_fh
+ * @sub: pointer to &struct v4l2_event_subscription
+ *
+ * Can be used as a vidioc_subscribe_event function that just subscribes
+ * control events.
+ */
 int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
 				const struct v4l2_event_subscription *sub);
 
-/* Can be used as a poll function that just polls for control events. */
+/**
+ * v4l2_ctrl_poll - function to be used as a callback to the poll()
+ *	That just polls for control events.
+ *
+ * @file: pointer to struct file
+ * @wait: pointer to struct poll_table_struct
+ */
 unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
 
-/* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
+/* Helpers for ioctl_ops */
+
+/**
+ * v4l2_queryctrl - Helper function to implement
+ *	:ref:`VIDIOC_QUERYCTRL <vidioc_queryctrl>` ioctl
+ *
+ * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @qc: pointer to &struct v4l2_queryctrl
+ *
+ * If hdl == NULL then they will all return -EINVAL.
+ */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
-int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctrl *qc);
+
+/**
+ * v4l2_query_ext_ctrl - Helper function to implement
+ *	 :ref:`VIDIOC_QUERY_EXT_CTRL <vidioc_queryctrl>` ioctl
+ *
+ * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @qc: pointer to &struct v4l2_query_ext_ctrl
+ *
+ * If hdl == NULL then they will all return -EINVAL.
+ */
+int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl,
+			struct v4l2_query_ext_ctrl *qc);
+
+/**
+ * v4l2_querymenu - Helper function to implement
+ *	:ref:`VIDIOC_QUERYMENU <vidioc_queryctrl>` ioctl
+ *
+ * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @qm: pointer to &struct v4l2_querymenu
+ *
+ * If hdl == NULL then they will all return -EINVAL.
+ */
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
+
+/**
+ * v4l2_g_ctrl - Helper function to implement
+ *	:ref:`VIDIOC_G_CTRL <vidioc_g_ctrl>` ioctl
+ *
+ * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @ctrl: pointer to &struct v4l2_control
+ *
+ * If hdl == NULL then they will all return -EINVAL.
+ */
 int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
+
+/**
+ * v4l2_s_ctrl - Helper function to implement
+ *	:ref:`VIDIOC_S_CTRL <vidioc_g_ctrl>` ioctl
+ *
+ * @fh: pointer to &struct v4l2_fh
+ * @hdl: pointer to &struct v4l2_ctrl_handler
+ *
+ * @ctrl: pointer to &struct v4l2_control
+ *
+ * If hdl == NULL then they will all return -EINVAL.
+ */
 int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-						struct v4l2_control *ctrl);
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
-int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
+		struct v4l2_control *ctrl);
+
+/**
+ * v4l2_g_ext_ctrls - Helper function to implement
+ *	:ref:`VIDIOC_G_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
+ *
+ * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @c: pointer to &struct v4l2_ext_controls
+ *
+ * If hdl == NULL then they will all return -EINVAL.
+ */
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+		     struct v4l2_ext_controls *c);
+
+/**
+ * v4l2_try_ext_ctrls - Helper function to implement
+ *	:ref:`VIDIOC_TRY_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
+ *
+ * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @c: pointer to &struct v4l2_ext_controls
+ *
+ * If hdl == NULL then they will all return -EINVAL.
+ */
+int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+		       struct v4l2_ext_controls *c);
+
+/**
+ * v4l2_s_ext_ctrls - Helper function to implement
+ *	:ref:`VIDIOC_S_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
+ *
+ * @fh: pointer to &struct v4l2_fh
+ * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @c: pointer to &struct v4l2_ext_controls
+ *
+ * If hdl == NULL then they will all return -EINVAL.
+ */
 int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-						struct v4l2_ext_controls *c);
+		     struct v4l2_ext_controls *c);
 
-/* Can be used as a subscribe_event function that just subscribes control
-   events. */
+/**
+ * v4l2_ctrl_subdev_subscribe_event - Helper function to implement
+ * 	as a &struct v4l2_subdev_core_ops subscribe_event function
+ *	that just subscribes control events.
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ * @fh: pointer to &struct v4l2_fh
+ * @sub: pointer to &struct v4l2_event_subscription
+ */
 int v4l2_ctrl_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 				     struct v4l2_event_subscription *sub);
 
-/* Log all controls owned by subdev's control handler. */
+/**
+ * v4l2_ctrl_subdev_log_status - Log all controls owned by subdev's control
+ *	 handler.
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ */
 int v4l2_ctrl_subdev_log_status(struct v4l2_subdev *sd);
 
 #endif
-- 
2.7.4

