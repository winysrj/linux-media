Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44061 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390637AbeKWWvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 17:51:33 -0500
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] vivid: fix smatch warnings
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <8ed60d90-00cc-8266-84d3-ffa090fb0078@xs4all.nl>
Date: Fri, 23 Nov 2018 13:07:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorganize code to fix two smatch warnings:

drivers/media/platform/vivid/vivid-core.c: drivers/media/platform/vivid/vivid-core.c:889 vivid_create_instance() warn: potentially one past the end of array
'dev->query_dv_timings_qmenu[dev->query_dv_timings_size]'
drivers/media/platform/vivid/vivid-core.c: drivers/media/platform/vivid/vivid-core.c:889 vivid_create_instance() warn: potentially one past the end of array
'dev->query_dv_timings_qmenu[dev->query_dv_timings_size]'

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vivid/vivid-core.c | 24 +++++++++++++++++------
 drivers/media/platform/vivid/vivid-core.h |  1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index bc7307183b1d..e64137611026 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -625,6 +625,7 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 	vfree(dev->bitmap_out);
 	tpg_free(&dev->tpg);
 	kfree(dev->query_dv_timings_qmenu);
+	kfree(dev->query_dv_timings_qmenu_strings);
 	kfree(dev);
 }

@@ -874,20 +875,31 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	if (!dev->edid)
 		goto free_dev;

-	/* create a string array containing the names of all the preset timings */
 	while (v4l2_dv_timings_presets[dev->query_dv_timings_size].bt.width)
 		dev->query_dv_timings_size++;
+
+	/*
+	 * Create a char pointer array that points to the names of all the
+	 * preset timings
+	 */
 	dev->query_dv_timings_qmenu = kmalloc_array(dev->query_dv_timings_size,
-						    (sizeof(void *) + 32),
-						    GFP_KERNEL);
-	if (dev->query_dv_timings_qmenu == NULL)
+						    sizeof(char *), GFP_KERNEL);
+	/*
+	 * Create a string array containing the names of all the preset
+	 * timings. Each name is max 31 chars long (+ terminating 0).
+	 */
+	dev->query_dv_timings_qmenu_strings =
+		kmalloc_array(dev->query_dv_timings_size, 32, GFP_KERNEL);
+
+	if (!dev->query_dv_timings_qmenu ||
+	    !dev->query_dv_timings_qmenu_strings)
 		goto free_dev;
+
 	for (i = 0; i < dev->query_dv_timings_size; i++) {
 		const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[i].bt;
-		char *p = (char *)&dev->query_dv_timings_qmenu[dev->query_dv_timings_size];
+		char *p = dev->query_dv_timings_qmenu_strings + i * 32;
 		u32 htot, vtot;

-		p += i * 32;
 		dev->query_dv_timings_qmenu[i] = p;

 		htot = V4L2_DV_BT_FRAME_WIDTH(bt);
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 1891254c8f0b..0bec2c3401d2 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -305,6 +305,7 @@ struct vivid_dev {

 	enum vivid_signal_mode		dv_timings_signal_mode;
 	char				**query_dv_timings_qmenu;
+	char				*query_dv_timings_qmenu_strings;
 	unsigned			query_dv_timings_size;
 	unsigned			query_dv_timings_last;
 	unsigned			query_dv_timings;
-- 
2.19.1
