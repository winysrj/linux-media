Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:23853 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbeG3Nqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 09:46:44 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@chromium.org, andy.yeh@intel.com, rajmohan.mani@intel.com,
        ping-chung.chen@intel.com, jim.lai@intel.com, grundler@chromium.org
Subject: [PATCH 1/1] i2c: Fix pm_runtime_get_if_in_use() usage in sensor drivers
Date: Mon, 30 Jul 2018 15:10:57 +0300
Message-Id: <20180730121057.31798-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pm_runtime_get_if_in_use() returns -EINVAL if runtime PM is disabled. This
should not be considered an error. Generally the driver has enabled
runtime PM already so getting this error due to runtime PM being disabled
will not happen.

Instead of checking for lesser or equal to zero, check for zero only.
Address this for drivers where this pattern exists.

This patch has been produced using the following command:

$ git grep -l pm_runtime_get_if_in_use -- drivers/media/i2c/ | \
  xargs perl -i -pe 's/(pm_runtime_get_if_in_use\(.*\)) \<\= 0/!$1/'

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov13858.c | 2 +-
 drivers/media/i2c/ov2685.c  | 2 +-
 drivers/media/i2c/ov5670.c  | 2 +-
 drivers/media/i2c/ov5695.c  | 2 +-
 drivers/media/i2c/ov7740.c  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index a66f6201f53c7..0e7a85c4996c7 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1230,7 +1230,7 @@ static int ov13858_set_ctrl(struct v4l2_ctrl *ctrl)
 	 * Applying V4L2 control value only happens
 	 * when power is up for streaming
 	 */
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	ret = 0;
diff --git a/drivers/media/i2c/ov2685.c b/drivers/media/i2c/ov2685.c
index 385c1886a9470..98a1f2e312b58 100644
--- a/drivers/media/i2c/ov2685.c
+++ b/drivers/media/i2c/ov2685.c
@@ -549,7 +549,7 @@ static int ov2685_set_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	}
 
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	switch (ctrl->id) {
diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 7b7c74d773707..53dd30d96e691 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2016,7 +2016,7 @@ static int ov5670_set_ctrl(struct v4l2_ctrl *ctrl)
 	}
 
 	/* V4L2 controls values will be applied only when power is already up */
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	switch (ctrl->id) {
diff --git a/drivers/media/i2c/ov5695.c b/drivers/media/i2c/ov5695.c
index 9a80decd93d3c..5d107c53364d6 100644
--- a/drivers/media/i2c/ov5695.c
+++ b/drivers/media/i2c/ov5695.c
@@ -1110,7 +1110,7 @@ static int ov5695_set_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	}
 
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	switch (ctrl->id) {
diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 605f3e25ad82b..6e9c233cfbe35 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -510,7 +510,7 @@ static int ov7740_set_ctrl(struct v4l2_ctrl *ctrl)
 	int ret;
 	u8 val = 0;
 
-	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
+	if (!pm_runtime_get_if_in_use(&client->dev))
 		return 0;
 
 	switch (ctrl->id) {
-- 
2.11.0
