Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57337 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbcGDIfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH 03/14] davinci: drop unused control callbacks
Date: Mon,  4 Jul 2016 10:34:59 +0200
Message-Id: <1467621310-8203-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These callbacks are no longer used since the davinci drivers use the
control framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/ccdc_hw_device.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/davinci/ccdc_hw_device.h b/drivers/media/platform/davinci/ccdc_hw_device.h
index 86b9b35..ae5605d 100644
--- a/drivers/media/platform/davinci/ccdc_hw_device.h
+++ b/drivers/media/platform/davinci/ccdc_hw_device.h
@@ -80,13 +80,6 @@ struct ccdc_hw_ops {
 	/* Pointer to function to get line length */
 	unsigned int (*get_line_length) (void);
 
-	/* Query CCDC control IDs */
-	int (*queryctrl)(struct v4l2_queryctrl *qctrl);
-	/* Set CCDC control */
-	int (*set_control)(struct v4l2_control *ctrl);
-	/* Get CCDC control */
-	int (*get_control)(struct v4l2_control *ctrl);
-
 	/* Pointer to function to set frame buffer address */
 	void (*setfbaddr) (unsigned long addr);
 	/* Pointer to function to get field id */
-- 
2.8.1

