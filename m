Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2033 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaHNJyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 17/20] cx23885: fix weird sizes.
Date: Thu, 14 Aug 2014 11:54:02 +0200
Message-Id: <1408010045-24016-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These values make no sense. All SDTV standards have the same width.
This seems to be copied from the cx88 driver. Just drop these weird
values.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 99a5fe0..f542ced 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -610,15 +610,15 @@ extern int cx23885_risc_databuffer(struct pci_dev *pci,
 
 static inline unsigned int norm_maxw(v4l2_std_id norm)
 {
-	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 720 : 768;
+	return 720;
 }
 
 static inline unsigned int norm_maxh(v4l2_std_id norm)
 {
-	return (norm & V4L2_STD_625_50) ? 576 : 480;
+	return (norm & V4L2_STD_525_60) ? 480 : 576;
 }
 
 static inline unsigned int norm_swidth(v4l2_std_id norm)
 {
-	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 754 : 922;
+	return 754;
 }
-- 
2.1.0.rc1

