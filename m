Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3260 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaHJL6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 17/19] cx23885: fix weird sizes.
Date: Sun, 10 Aug 2014 13:57:54 +0200
Message-Id: <1407671876-39386-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
References: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
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
2.0.1

