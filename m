Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35663 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbcDXVKU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:20 -0400
Received: by mail-wm0-f66.google.com with SMTP id e201so17586865wme.2
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:19 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [RFC PATCH 06/24] smiapp: Add quirk control support
Date: Mon, 25 Apr 2016 00:08:06 +0300
Message-Id: <1461532104-24032-7-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Quirk controls can be set up in the init quirk.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c  | 6 ++++++
 drivers/media/i2c/smiapp/smiapp-quirk.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 3dfe387..c6a897b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -412,6 +412,12 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 	int exposure;
 	int rval;
 
+	rval = smiapp_call_quirk(sensor, s_ctrl, ctrl);
+	if (rval < 0)
+		return rval;
+	if (rval > 0)
+		return 0;
+
 	switch (ctrl->id) {
 	case V4L2_CID_ANALOGUE_GAIN:
 		return smiapp_write(
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index 209818f..504c16a 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -32,6 +32,8 @@ struct smiapp_sensor;
  * @pll_flags: Return flags for the PLL calculator.
  * @init: Quirk initialisation, called the last in probe(). This is
  *	  also appropriate for adding sensor specific controls, for instance.
+ * @s_ctrl: Set control quirk. Returns 0 if the control isn't
+ *	    implemented by the quirk, > 0 if it is.
  * @reg_access: Register access quirk. The quirk may divert the access
  *		to another register, or no register at all.
  *
@@ -51,6 +53,7 @@ struct smiapp_quirk {
 	int (*post_streamoff)(struct smiapp_sensor *sensor);
 	unsigned long (*pll_flags)(struct smiapp_sensor *sensor);
 	int (*init)(struct smiapp_sensor *sensor);
+	int (*s_ctrl)(struct smiapp_sensor *sensor, struct v4l2_ctrl *ctrl);
 	int (*reg_access)(struct smiapp_sensor *sensor, bool write, u32 *reg,
 			  u32 *val);
 	unsigned long flags;
-- 
1.9.1

