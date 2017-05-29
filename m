Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49272 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750987AbdE2Opp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 10:45:45 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l2-ctrls: Correctly destroy mutex in v4l2_ctrl_handler_free()
Date: Mon, 29 May 2017 17:45:43 +0300
Message-Id: <1496069143-2039-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mutex that was initialised in v4l2_ctrl_handler_init_class() was not
destroyed in v4l2_ctrl_handler_free(). Do that.

Additionally, explicitly refer to the ctrl handler's mutex in mutex
initialisation for clarity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ec42872..488149d 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1739,8 +1739,8 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
 				 unsigned nr_of_controls_hint,
 				 struct lock_class_key *key, const char *name)
 {
+	mutex_init(&hdl->_lock);
 	hdl->lock = &hdl->_lock;
-	mutex_init(hdl->lock);
 	lockdep_set_class_and_name(hdl->lock, key, name);
 	INIT_LIST_HEAD(&hdl->ctrls);
 	INIT_LIST_HEAD(&hdl->ctrl_refs);
@@ -1780,6 +1780,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 	hdl->cached = NULL;
 	hdl->error = 0;
 	mutex_unlock(hdl->lock);
+	mutex_destroy(&hdl->_lock);
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_free);
 
-- 
2.1.4
