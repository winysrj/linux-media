Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2005 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030362Ab3FTU2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 16:28:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Vladimir Barinov <source@cogentembedded.com>
Subject: [REVIEW PATCH 1/3] ml86v7667: fix compiler warning
Date: Thu, 20 Jun 2013 22:28:14 +0200
Message-Id: <1371760096-19256-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

build/media_build/v4l/ml86v7667.c: In function 'ml86v7667_s_ctrl':
build/media_build/v4l/ml86v7667.c:120:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret = 0;
        ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Vladimir Barinov <source@cogentembedded.com>
---
 drivers/media/i2c/ml86v7667.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index cd9f86e..efdc873 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -117,7 +117,7 @@ static int ml86v7667_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret = 0;
+	int ret;
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-- 
1.8.3.1

