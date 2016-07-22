Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbcGVPDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 11/11] [media] doc-rst: Fix some typedef ugly warnings
Date: Fri, 22 Jul 2016 12:03:07 -0300
Message-Id: <b32909983ab03e03504bb44d5c66f44b9d57adc3.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx can't handle well typedefs. Change two typedef
occurrences, in order to cleanup some of such warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-ctrls.h      | 4 +++-
 include/media/v4l2-dv-timings.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 8b59336b2217..d6f63406b885 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -534,6 +534,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, u8 max, u8 def, const s64 *qmenu_int);
 
+typedef bool (*v4l2_ctrl_filter)(const struct v4l2_ctrl *ctrl);
+
 /**
  * v4l2_ctrl_add_handler() - Add all controls from handler @add to
  * handler @hdl.
@@ -550,7 +552,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
  */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 			  struct v4l2_ctrl_handler *add,
-			  bool (*filter)(const struct v4l2_ctrl *ctrl));
+			  v4l2_ctrl_filter filter);
 
 /**
  * v4l2_ctrl_radio_filter() - Standard filter for radio controls.
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 1113c8874c26..65caadf13eec 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -28,7 +28,7 @@
  */
 extern const struct v4l2_dv_timings v4l2_dv_timings_presets[];
 
-/**
+/*
  * v4l2_check_dv_timings_fnc - timings check callback
  *
  * @t: the v4l2_dv_timings struct.
-- 
2.7.4

