Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:40422 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab2DTPTj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 11:19:39 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	=?UTF-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [RFC PATCH 1/3] [media] gspca - main: rename get_ctrl to get_ctrl_index
Date: Fri, 20 Apr 2012 17:19:09 +0200
Message-Id: <1334935152-16165-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1334935152-16165-1-git-send-email-ospite@studenti.unina.it>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
 <1334935152-16165-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reflects better what the function does and is also in preparation
of a refactoring of setting and getting controls.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/gspca.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index ca5a2b1..bc9d037 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1415,7 +1415,7 @@ out:
 	return ret;
 }
 
-static int get_ctrl(struct gspca_dev *gspca_dev,
+static int get_ctrl_index(struct gspca_dev *gspca_dev,
 				   int id)
 {
 	const struct ctrl *ctrls;
@@ -1458,7 +1458,7 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 			idx = i;
 		}
 	} else {
-		idx = get_ctrl(gspca_dev, id);
+		idx = get_ctrl_index(gspca_dev, id);
 	}
 	if (idx < 0)
 		return -EINVAL;
@@ -1483,7 +1483,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	struct gspca_ctrl *gspca_ctrl;
 	int idx, ret;
 
-	idx = get_ctrl(gspca_dev, ctrl->id);
+	idx = get_ctrl_index(gspca_dev, ctrl->id);
 	if (idx < 0)
 		return -EINVAL;
 	if (gspca_dev->ctrl_inac & (1 << idx))
@@ -1531,7 +1531,7 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 	const struct ctrl *ctrls;
 	int idx, ret;
 
-	idx = get_ctrl(gspca_dev, ctrl->id);
+	idx = get_ctrl_index(gspca_dev, ctrl->id);
 	if (idx < 0)
 		return -EINVAL;
 	ctrls = &gspca_dev->sd_desc->ctrls[idx];
-- 
1.7.10

