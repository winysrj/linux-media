Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:38222 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752091AbdGUPwH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 11:52:07 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>
Subject: [PATCH v1 2/2] [media] ov9655: fix missing mutex_destroy()
Date: Fri, 21 Jul 2017 17:49:41 +0200
Message-ID: <1500652181-971-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1500652181-971-1-git-send-email-hugues.fruchet@st.com>
References: <1500652181-971-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix missing mutex_destroy() when probe fails and
when driver is removed.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov9650.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index e8dea28..6ffb460 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1505,13 +1505,13 @@ static int ov965x_probe(struct i2c_client *client,
 
 	ret = ov965x_configure_gpios(ov965x, pdata);
 	if (ret < 0)
-		return ret;
+		goto err_mutex;
 
 	ov965x->pad.flags = MEDIA_PAD_FL_SOURCE;
 	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&sd->entity, 1, &ov965x->pad);
 	if (ret < 0)
-		return ret;
+		goto err_mutex;
 
 	ret = ov965x_initialize_controls(ov965x);
 	if (ret < 0)
@@ -1537,16 +1537,20 @@ static int ov965x_probe(struct i2c_client *client,
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 err_me:
 	media_entity_cleanup(&sd->entity);
+err_mutex:
+	mutex_destroy(&ov965x->lock);
 	return ret;
 }
 
 static int ov965x_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ov965x *ov965x = to_ov965x(sd);
 
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	media_entity_cleanup(&sd->entity);
+	mutex_destroy(&ov965x->lock);
 
 	return 0;
 }
-- 
1.9.1
