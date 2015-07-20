Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45897 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbbGTNTe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:19:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] zoran: remove unnecessary memset
Date: Mon, 20 Jul 2015 15:18:18 +0200
Message-Id: <1437398302-6211-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
References: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is no need to zero the v4l2_capability struct, the v4l2 core has done
that already.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/zoran/zoran_driver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 2b25d31..25cd18b 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1523,7 +1523,6 @@ static int zoran_querycap(struct file *file, void *__fh, struct v4l2_capability
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
 
-	memset(cap, 0, sizeof(*cap));
 	strncpy(cap->card, ZR_DEVNAME(zr), sizeof(cap->card)-1);
 	strncpy(cap->driver, "zoran", sizeof(cap->driver)-1);
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
-- 
2.1.4

