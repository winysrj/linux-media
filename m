Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4897 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab3LTJcE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 29/50] adv7842: save platform data in state struct
Date: Fri, 20 Dec 2013 10:31:22 +0100
Message-Id: <1387531903-20496-30-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index cbbfa77..4f93526 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -61,6 +61,7 @@ MODULE_LICENSE("GPL");
 */
 
 struct adv7842_state {
+	struct adv7842_platform_data pdata;
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
@@ -2730,6 +2731,9 @@ static int adv7842_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
+	/* platform data */
+	state->pdata = *pdata;
+
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -2834,7 +2838,7 @@ static int adv7842_probe(struct i2c_client *client,
 	if (err)
 		goto err_work_queues;
 
-	err = adv7842_core_init(sd, pdata);
+	err = adv7842_core_init(sd);
 	if (err)
 		goto err_entity;
 
-- 
1.8.4.4

