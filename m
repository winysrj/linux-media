Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1205 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3LJPGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/22] adv7842: save platform data in state struct
Date: Tue, 10 Dec 2013 16:03:50 +0100
Message-Id: <e9dee2e9fa1c6273c075d92eff509a36bb569dca.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
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
1.8.4.rc3

