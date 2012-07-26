Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62579 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2GZGYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 02:24:30 -0400
Received: by yenl2 with SMTP id l2so1589868yen.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 23:24:30 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/2] [media] s5k6aa: Add missing static storage class specifier
Date: Thu, 26 Jul 2012 11:53:33 +0530
Message-Id: <1343283813-24326-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1343283813-24326-1-git-send-email-sachin.kamat@linaro.org>
References: <1343283813-24326-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:
drivers/media/video/s5k6aa.c:1439:5: warning:
symbol 's5k6aa_check_fw_revision' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5k6aa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5k6aa.c b/drivers/media/video/s5k6aa.c
index 0c3bc58..045ca7f 100644
--- a/drivers/media/video/s5k6aa.c
+++ b/drivers/media/video/s5k6aa.c
@@ -1436,7 +1436,7 @@ static int s5k6aa_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	return 0;
 }
 
-int s5k6aa_check_fw_revision(struct s5k6aa *s5k6aa)
+static int s5k6aa_check_fw_revision(struct s5k6aa *s5k6aa)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&s5k6aa->sd);
 	u16 api_ver = 0, fw_rev = 0;
-- 
1.7.4.1

