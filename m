Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44654 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbeHGNr4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 09:47:56 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] media: vivid: shut up warnings due to a non-trivial logic
Date: Tue,  7 Aug 2018 07:33:58 -0400
Message-Id: <a399de231b0d762aaed8e37041c09ec6e521eb2c.1533641635.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vivid driver uses a complex logic to save one kalloc/kfree
allocation. That non-trivial way of allocating data causes
smatch to warn:
	drivers/media/platform/vivid/vivid-core.c:869 vivid_create_instance() warn: potentially one past the end of array 'dev->query_dv_timings_qmenu[dev->query_dv_timings_size]'
	drivers/media/platform/vivid/vivid-core.c:869 vivid_create_instance() warn: potentially one past the end of array 'dev->query_dv_timings_qmenu[dev->query_dv_timings_size]'

I also needed to read the code several times in order to understand
what it was desired there. It turns that the logic was right,
although confusing to read.

As it is doing allocations on a non-standard way, let's add some
documentation while shutting up the false positive.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vivid/vivid-core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 31db363602e5..4c235ea27987 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -647,6 +647,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	unsigned node_type = node_types[inst];
 	unsigned int allocator = allocators[inst];
 	v4l2_std_id tvnorms_cap = 0, tvnorms_out = 0;
+	char *strings_base;
 	int ret;
 	int i;
 
@@ -859,17 +860,33 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	/* create a string array containing the names of all the preset timings */
 	while (v4l2_dv_timings_presets[dev->query_dv_timings_size].bt.width)
 		dev->query_dv_timings_size++;
+
+	/*
+	 * In order to save one allocation and an extra free, let's optimize
+	 * the allocation here: we'll use the first elements of the
+	 * dev->query_dv_timings_qmenu to store the timing strings pointer,
+	 * adding an extra space there to a store a string up to 32 bytes.
+	 * So, instead of allocating an array with size of:
+	 * 	dev->query_dv_timings_size * (sizeof(void *)
+	 * it will allocate:
+	 * 	dev->query_dv_timings_size * (sizeof(void *) +
+	 *	dev->query_dv_timings_size * 32
+	 */
 	dev->query_dv_timings_qmenu = kmalloc_array(dev->query_dv_timings_size,
 						    (sizeof(void *) + 32),
 						    GFP_KERNEL);
 	if (dev->query_dv_timings_qmenu == NULL)
 		goto free_dev;
+
+	/* Sets strings_base to be after the space to store the pointers */
+	strings_base = ((char *)&dev->query_dv_timings_qmenu)
+		       + dev->query_dv_timings_size * sizeof(void *);
+
 	for (i = 0; i < dev->query_dv_timings_size; i++) {
 		const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[i].bt;
-		char *p = (char *)&dev->query_dv_timings_qmenu[dev->query_dv_timings_size];
+		char *p = strings_base + i * 32;
 		u32 htot, vtot;
 
-		p += i * 32;
 		dev->query_dv_timings_qmenu[i] = p;
 
 		htot = V4L2_DV_BT_FRAME_WIDTH(bt);
-- 
2.17.1
