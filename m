Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2027 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaITNTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 09:19:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 1/2] cx23885: fix VBI support.
Date: Sat, 20 Sep 2014 15:19:32 +0200
Message-Id: <1411219173-32869-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411219173-32869-1-git-send-email-hverkuil@xs4all.nl>
References: <1411219173-32869-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Tested VBI support and discovered that the wrong offset was used.
After this change it is now working. Verified with CC/XDS for NTSC
and WSS/Teletext on PAL.

It also reported the wrong start lines for the second field. That's
now fixed as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-core.c | 4 ++--
 drivers/media/pci/cx23885/cx23885-vbi.c  | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index cb94366b..331edda 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1228,11 +1228,11 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct cx23885_riscmem *risc,
 	/* Sync to line 6, so US CC line 21 will appear in line '12'
 	 * in the userland vbi payload */
 	if (UNSET != top_offset)
-		rp = cx23885_risc_field(rp, sglist, top_offset, 6,
+		rp = cx23885_risc_field(rp, sglist, top_offset, 0,
 					bpl, padding, lines, 0, true);
 
 	if (UNSET != bottom_offset)
-		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x207,
+		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x200,
 					bpl, padding, lines, 0, UNSET == top_offset);
 
 
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 67b71f9..a7c6ef8 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -54,14 +54,14 @@ int cx23885_vbi_fmt(struct file *file, void *priv,
 	f->fmt.vbi.flags = 0;
 	if (dev->tvnorm & V4L2_STD_525_60) {
 		/* ntsc */
-		f->fmt.vbi.start[0] = 10;
-		f->fmt.vbi.start[1] = 272;
+		f->fmt.vbi.start[0] = V4L2_VBI_ITU_525_F1_START + 9;
+		f->fmt.vbi.start[1] = V4L2_VBI_ITU_525_F2_START + 9;
 		f->fmt.vbi.count[0] = VBI_NTSC_LINE_COUNT;
 		f->fmt.vbi.count[1] = VBI_NTSC_LINE_COUNT;
 	} else if (dev->tvnorm & V4L2_STD_625_50) {
 		/* pal */
-		f->fmt.vbi.start[0] = 6;
-		f->fmt.vbi.start[1] = 318;
+		f->fmt.vbi.start[0] = V4L2_VBI_ITU_625_F1_START + 5;
+		f->fmt.vbi.start[1] = V4L2_VBI_ITU_625_F2_START + 5;
 		f->fmt.vbi.count[0] = VBI_PAL_LINE_COUNT;
 		f->fmt.vbi.count[1] = VBI_PAL_LINE_COUNT;
 	}
-- 
2.1.0

