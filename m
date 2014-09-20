Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2382 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaITMmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/16] cx88: fix sparse warning
Date: Sat, 20 Sep 2014 14:41:40 +0200
Message-Id: <1411216911-7950-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cx88/cx88-blackbird.c:476:25: warning: cast to restricted __le32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 25d06f3..32abba4 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -428,7 +428,7 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 	int i, retval = 0;
 	u32 value = 0;
 	u32 checksum = 0;
-	u32 *dataptr;
+	__le32 *dataptr;
 
 	retval  = register_write(dev->core, IVTV_REG_VPU, 0xFFFFFFED);
 	retval |= register_write(dev->core, IVTV_REG_HW_BLOCKS, IVTV_CMD_HW_BLOCKS_RST);
@@ -467,7 +467,7 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 
 	/* transfer to the chip */
 	dprintk(1,"Loading firmware ...\n");
-	dataptr = (u32*)firmware->data;
+	dataptr = (__le32 *)firmware->data;
 	for (i = 0; i < (firmware->size >> 2); i++) {
 		value = le32_to_cpu(*dataptr);
 		checksum += ~value;
-- 
2.1.0

