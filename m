Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2541 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaILNAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 09:00:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 13/14] saa7134: don't rebuild the page table unless new_cookies is set.
Date: Fri, 12 Sep 2014 15:00:02 +0200
Message-Id: <1410526803-25887-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Only if new_cookies is set do you need to build the page table,
otherwise it will be unchanged.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-ts.c    | 2 ++
 drivers/media/pci/saa7134/saa7134-vbi.c   | 2 ++
 drivers/media/pci/saa7134/saa7134-video.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 2709b83..4095776 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -107,6 +107,8 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 	vb2_set_plane_payload(vb2, 0, size);
 	vb2->v4l2_buf.field = dev->field;
 
+	if (!vb2->new_cookies)
+		return 0;
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
 }
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index e188903..5b422d0 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -131,6 +131,8 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 
 	vb2_set_plane_payload(vb2, 0, size);
 
+	if (!vb2->new_cookies)
+		return 0;
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
 }
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 15a686b..3ab39be 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -895,6 +895,8 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 	vb2_set_plane_payload(vb2, 0, size);
 	vb2->v4l2_buf.field = dev->field;
 
+	if (!vb2->new_cookies)
+		return 0;
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
 }
-- 
2.1.0

