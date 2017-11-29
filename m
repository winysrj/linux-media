Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33410 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754642AbdK2MI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 07:08:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 3/7] media: v4l2-core: Fix kernel-doc markups
Date: Wed, 29 Nov 2017 07:08:06 -0500
Message-Id: <d9374fd822735a5edbb950529eaa7d7b25217057.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
In-Reply-To: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
References: <c73fcbc4af259923feac19eda4bb5e996b6de0fd.1511952403.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some troubles on kernel-doc markups, as warned:

	drivers/media/v4l2-core/v4l2-dv-timings.c:259: warning: No description found for parameter 't1'
	drivers/media/v4l2-core/v4l2-dv-timings.c:259: warning: No description found for parameter 't2'
	drivers/media/v4l2-core/v4l2-dv-timings.c:259: warning: No description found for parameter 'pclock_delta'
	drivers/media/v4l2-core/v4l2-dv-timings.c:259: warning: No description found for parameter 'match_reduced_fps'
	drivers/media/v4l2-core/tuner-core.c:242: warning: bad line: internal parameters, like LNA mode
	drivers/media/v4l2-core/tuner-core.c:765: warning: No description found for parameter 'mode'
	drivers/media/v4l2-core/videobuf2-memops.c:127: warning: cannot understand function prototype: 'const struct vm_operations_struct vb2_common_vm_ops = '
	drivers/media/v4l2-core/v4l2-mem2mem.c:190: warning: No description found for parameter 'm2m_dev'
	drivers/media/v4l2-core/v4l2-mem2mem.c:291: warning: No description found for parameter 'm2m_ctx'
	drivers/media/v4l2-core/videobuf-core.c:233: warning: No description found for parameter 'q'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/tuner-core.c       |  4 +++-
 drivers/media/v4l2-core/v4l2-dv-timings.c  | 10 +++++-----
 drivers/media/v4l2-core/v4l2-mem2mem.c     |  2 ++
 drivers/media/v4l2-core/videobuf-core.c    |  2 +-
 drivers/media/v4l2-core/videobuf2-memops.c |  2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 8db45dfc271b..82852f23a3b6 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -239,7 +239,7 @@ static const struct analog_demod_ops tuner_analog_ops = {
  * @type:		type of the tuner (e. g. tuner number)
  * @new_mode_mask:	Indicates if tuner supports TV and/or Radio
  * @new_config:		an optional parameter used by a few tuners to adjust
-			internal parameters, like LNA mode
+ *			internal parameters, like LNA mode
  * @tuner_callback:	an optional function to be called when switching
  *			to analog mode
  *
@@ -750,6 +750,7 @@ static int tuner_remove(struct i2c_client *client)
 /**
  * check_mode - Verify if tuner supports the requested mode
  * @t: a pointer to the module's internal struct_tuner
+ * @mode: mode of the tuner, as defined by &enum v4l2_tuner_type.
  *
  * This function checks if the tuner is capable of tuning analog TV,
  * digital TV or radio, depending on what the caller wants. If the
@@ -757,6 +758,7 @@ static int tuner_remove(struct i2c_client *client)
  * returns 0.
  * This function is needed for boards that have a separate tuner for
  * radio (like devices with tea5767).
+ *
  * NOTE: mt20xx uses V4L2_TUNER_DIGITAL_TV and calls set_tv_freq to
  *       select a TV frequency. So, t_mode = T_ANALOG_TV could actually
  *	 be used to represent a Digital TV too.
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5c8c49d240d1..930f9c53a64e 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -245,11 +245,11 @@ EXPORT_SYMBOL_GPL(v4l2_find_dv_timings_cea861_vic);
 
 /**
  * v4l2_match_dv_timings - check if two timings match
- * @t1 - compare this v4l2_dv_timings struct...
- * @t2 - with this struct.
- * @pclock_delta - the allowed pixelclock deviation.
- * @match_reduced_fps - if true, then fail if V4L2_DV_FL_REDUCED_FPS does not
- * match.
+ * @t1: compare this v4l2_dv_timings struct...
+ * @t2: with this struct.
+ * @pclock_delta: the allowed pixelclock deviation.
+ * @match_reduced_fps: if true, then fail if V4L2_DV_FL_REDUCED_FPS does not
+ * 	match.
  *
  * Compare t1 with t2 with a given margin of error for the pixelclock.
  */
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index f62e68aa04c4..bc580fbe18fa 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -183,6 +183,7 @@ EXPORT_SYMBOL(v4l2_m2m_get_curr_priv);
 
 /**
  * v4l2_m2m_try_run() - select next job to perform and run it if possible
+ * @m2m_dev: per-device context
  *
  * Get next transaction (if present) from the waiting jobs list and run it.
  */
@@ -281,6 +282,7 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_try_schedule);
 
 /**
  * v4l2_m2m_cancel_job() - cancel pending jobs for the context
+ * @m2m_ctx: m2m context with jobs to be canceled
  *
  * In case of streamoff or release called on any context,
  * 1] If the context is currently running, then abort job will be called
diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index 1dbf6f7785bb..e87fb13b22dc 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -222,7 +222,7 @@ int videobuf_queue_is_busy(struct videobuf_queue *q)
 }
 EXPORT_SYMBOL_GPL(videobuf_queue_is_busy);
 
-/**
+/*
  * __videobuf_free() - free all the buffers and their control structures
  *
  * This function can only be called if streaming/reading is off, i.e. no buffers
diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index 4bb8424114ce..89e51989332b 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -120,7 +120,7 @@ static void vb2_common_vm_close(struct vm_area_struct *vma)
 	h->put(h->arg);
 }
 
-/**
+/*
  * vb2_common_vm_ops - common vm_ops used for tracking refcount of mmaped
  * video buffers
  */
-- 
2.14.3
