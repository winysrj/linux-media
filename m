Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44058 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965475AbcIHMEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 14/47] [media] v4l2-ctrls: document some extra data structures
Date: Thu,  8 Sep 2016 09:03:36 -0300
Message-Id: <1461eece1c38a429c55e30498816a4f9a9d35099.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The typedefs and a macro are not defined. While here, improve a
few bits on the documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-ctrls.h | 51 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 178a88d45aea..a63f37044f1c 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -93,6 +93,16 @@ struct v4l2_ctrl_type_ops {
 			union v4l2_ctrl_ptr ptr);
 };
 
+/**
+ * typedef v4l2_ctrl_notify_fnc - typedef for a notify argument with a function
+ * 	that should be called when a control value has changed.
+ *
+ * @ctrl: pointer to struct &v4l2_ctrl
+ * @priv: control private data
+ *
+ * This typedef definition is used as an argument to v4l2_ctrl_notify()
+ * and as an argument at struct &v4l2_ctrl_handler.
+ */
 typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
 
 /**
@@ -369,17 +379,38 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
  * @key:	Used by the lock validator if CONFIG_LOCKDEP is set.
  * @name:	Used by the lock validator if CONFIG_LOCKDEP is set.
  *
- * Returns an error if the buckets could not be allocated. This error will
- * also be stored in @hdl->error.
+ * .. attention::
  *
- * Never use this call directly, always use the v4l2_ctrl_handler_init
- * macro that hides the @key and @name arguments.
+ *    Never use this call directly, always use the v4l2_ctrl_handler_init()
+ *    macro that hides the @key and @name arguments.
+ *
+ * Return: returns an error if the buckets could not be allocated. This
+ * error will also be stored in @hdl->error.
  */
 int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
 				 unsigned int nr_of_controls_hint,
 				 struct lock_class_key *key, const char *name);
 
 #ifdef CONFIG_LOCKDEP
+
+/**
+ * v4l2_ctrl_handler_init -
+ *
+ * @hdl:	The control handler.
+ * @nr_of_controls_hint: A hint of how many controls this handler is
+ *		expected to refer to. This is the total number, so including
+ *		any inherited controls. It doesn't have to be precise, but if
+ *		it is way off, then you either waste memory (too many buckets
+ *		are allocated) or the control lookup becomes slower (not enough
+ *		buckets are allocated, so there are more slow list lookups).
+ *		It will always work, though.
+ *
+ * This helper function creates a static struct &lock_class_key and
+ * calls v4l2_ctrl_handler_init_class(), providing a proper name for the lock
+ * validador.
+ *
+ * Use this helper function to initialize a control handler.
+ */
 #define v4l2_ctrl_handler_init(hdl, nr_of_controls_hint)		\
 (									\
 	({								\
@@ -564,6 +595,13 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 					 u32 id, u8 max, u8 def,
 					 const s64 *qmenu_int);
 
+/**
+ * typedef v4l2_ctrl_filter - Typedef to define the filter function to be
+ *	used when adding a control handler.
+ *
+ * @ctrl: pointer to struct &v4l2_ctrl.
+ */
+
 typedef bool (*v4l2_ctrl_filter)(const struct v4l2_ctrl *ctrl);
 
 /**
@@ -635,8 +673,8 @@ void v4l2_ctrl_cluster(unsigned int ncontrols, struct v4l2_ctrl **controls);
  * be marked active, and any reads will just return the current value without
  * going through g_volatile_ctrl.
  *
- * In addition, this function will set the V4L2_CTRL_FLAG_UPDATE flag
- * on the autofoo control and V4L2_CTRL_FLAG_INACTIVE on the foo control(s)
+ * In addition, this function will set the %V4L2_CTRL_FLAG_UPDATE flag
+ * on the autofoo control and %V4L2_CTRL_FLAG_INACTIVE on the foo control(s)
  * if autofoo is in auto mode.
  */
 void v4l2_ctrl_auto_cluster(unsigned int ncontrols,
@@ -686,7 +724,6 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
  */
 void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
 
-
 /**
  *__v4l2_ctrl_modify_range() - Unlocked variant of v4l2_ctrl_modify_range()
  *
-- 
2.7.4


