Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43288 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021Ab0LXBtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 20:49:50 -0500
Subject: [RFC/PATCH] v4l2-ctrls: eliminate lockdep false alarms for struct
 v4l2_ctrl_handler.lock
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 20:50:27 -0500
Message-ID: <1293155427.2456.31.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

When calling v4l2_ctrl_add_handler(), lockdep would detect a potential
recursive locking problem on a situation that is by design intended and
not a recursive lock.  This happened because all struct
v4l2_ctrl_handler.lock mutexes were created as members of the same lock
class in v4l2_ctrl_handler_init(), and v4l2_ctrl_add_handler() takes the
hdl->lock on two different v4l2_ctrl_handler instances.

This change breaks the large lockdep lock class for struct
v4l2_ctrl_handler.lock and breaks it into v4l2_ctrl_handler
instantiation specific lock classes with meaningful class names.

This will validly eliminate lockdep alarms for v4l2_ctrl_handler locking
validation, as long as the relationships between drivers adding v4l2
controls to their own handler from other v4l2 drivers' control handlers
remains straightforward.

struct v4l2_ctrl_handler.lock lock classes are created with names such
that the output of cat /proc/lockdep indicates where in the v4l2 driver
code v4l2_ctrl_handle_init() is being called on instantiations:

ffffffffa045f490 FD:   10 BD:    8 +.+...: cx2341x:1534:(hdl)->lock
ffffffffa0497d20 FD:   12 BD:    2 +.+.+.: saa7115:1581:(hdl)->lock
ffffffffa04ac660 FD:   14 BD:    2 +.+.+.: msp3400_driver:756:(hdl)->lock
ffffffffa0484b90 FD:   12 BD:    1 +.+.+.: ivtv_gpio:366:(&itv->hdl_gpio)->lock
ffffffffa04eb530 FD:   11 BD:    2 +.+.+.: cx25840_core:1982:(&state->hdl)->lock
ffffffffa04fbc80 FD:   11 BD:    3 +.+.+.: wm8775:246:(&state->hdl)->lock

Some lock chains, that were previously causing the recursion alarms, are
now visible in the output of cat /proc/lockdep_chains:

irq_context: 0
[ffffffffa0497d20] saa7115:1581:(hdl)->lock
[ffffffffa045f490] cx2341x:1534:(hdl)->lock

irq_context: 0
[ffffffffa04ac660] msp3400_driver:756:(hdl)->lock
[ffffffffa045f490] cx2341x:1534:(hdl)->lock

irq_context: 0
[ffffffffa0484b90] ivtv_gpio:366:(&itv->hdl_gpio)->lock
[ffffffffa045f490] cx2341x:1534:(hdl)->lock

irq_context: 0
[ffffffffa04eb530] cx25840_core:1982:(&state->hdl)->lock
[ffffffffa045f490] cx2341x:1534:(hdl)->lock

irq_context: 0
[ffffffffa04fbc80] wm8775:246:(&state->hdl)->lock
[ffffffffa045f490] cx2341x:1534:(hdl)->lock


Signed-off-by: Andy Walls <awalls@md.metrocast.net>


diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9d2502c..8b7de34 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -761,10 +761,9 @@ static inline int handler_set_err(struct v4l2_ctrl_handler *hdl, int err)
 }
 
 /* Initialize the handler */
-int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
-			   unsigned nr_of_controls_hint)
+int _v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
+			    unsigned nr_of_controls_hint)
 {
-	mutex_init(&hdl->lock);
 	INIT_LIST_HEAD(&hdl->ctrls);
 	INIT_LIST_HEAD(&hdl->ctrl_refs);
 	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
@@ -773,7 +772,7 @@ int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
 	hdl->error = hdl->buckets ? 0 : -ENOMEM;
 	return hdl->error;
 }
-EXPORT_SYMBOL(v4l2_ctrl_handler_init);
+EXPORT_SYMBOL(_v4l2_ctrl_handler_init);
 
 /* Free all controls and control refs */
 void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 9b7bea9..3bc0f69 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -238,8 +238,21 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
   * Returns an error if the buckets could not be allocated. This error will
   * also be stored in @hdl->error.
   */
-int v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
-			   unsigned nr_of_controls_hint);
+int _v4l2_ctrl_handler_init(struct v4l2_ctrl_handler *hdl,
+			    unsigned nr_of_controls_hint);
+
+#define v4l2_ctrl_handler_init(hdl, nr_of_controls_hint)		\
+(									\
+	({								\
+		static struct lock_class_key _key;			\
+		mutex_init(&(hdl)->lock);				\
+		lockdep_set_class_and_name(&(hdl)->lock, &_key,		\
+					   KBUILD_BASENAME ":"		\
+					   __stringify(__LINE__) ":"	\
+					   "(" #hdl ")->lock");		\
+	}),								\
+	_v4l2_ctrl_handler_init(hdl, nr_of_controls_hint)		\
+)
 
 /** v4l2_ctrl_handler_free() - Free all controls owned by the handler and free
   * the control list.


