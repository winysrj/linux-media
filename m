Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52960 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbeIZOVU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 10:21:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/2] v4l: ctrl: Remove old documentation from v4l2_ctrl_grab
Date: Wed, 26 Sep 2018 11:09:36 +0300
Message-Id: <20180926080937.19501-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180926080937.19501-1-sakari.ailus@linux.intel.com>
References: <20180926080937.19501-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_ctrl_grab() is documented in the header; there's no need to have a
comment explaining what the function does in the .c file.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ee006d34c19f..ab393adf51eb 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2511,12 +2511,6 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active)
 }
 EXPORT_SYMBOL(v4l2_ctrl_activate);
 
-/* Grab/ungrab a control.
-   Typically used when streaming starts and you want to grab controls,
-   preventing the user from changing them.
-
-   Just call this and the framework will block any attempts to change
-   these controls. */
 void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
 {
 	bool old;
-- 
2.11.0
