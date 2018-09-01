Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40875 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbeIAQ6f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2018 12:58:35 -0400
Received: by mail-wm0-f66.google.com with SMTP id 207-v6so7618626wme.5
        for <linux-media@vger.kernel.org>; Sat, 01 Sep 2018 05:46:38 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 2/2] media: ov2680: rename ov2680_v4l2_init() to ov2680_v4l2_register()
Date: Sat,  1 Sep 2018 14:46:30 +0200
Message-Id: <20180901124630.14139-2-javierm@redhat.com>
In-Reply-To: <20180901124630.14139-1-javierm@redhat.com>
References: <20180901124630.14139-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function not only does initialization but also registers the subdevice
so change its name to make this more clear.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

---

Changes in v2: None

 drivers/media/i2c/ov2680.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 3ccd584568fb..0e34e15b67b3 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -926,7 +926,7 @@ static int ov2680_mode_init(struct ov2680_dev *sensor)
 	return 0;
 }
 
-static int ov2680_v4l2_init(struct ov2680_dev *sensor)
+static int ov2680_v4l2_register(struct ov2680_dev *sensor)
 {
 	const struct v4l2_ctrl_ops *ops = &ov2680_ctrl_ops;
 	struct ov2680_ctrls *ctrls = &sensor->ctrls;
@@ -1092,7 +1092,7 @@ static int ov2680_probe(struct i2c_client *client)
 	if (ret < 0)
 		goto lock_destroy;
 
-	ret = ov2680_v4l2_init(sensor);
+	ret = ov2680_v4l2_register(sensor);
 	if (ret < 0)
 		goto lock_destroy;
 
-- 
2.17.1
