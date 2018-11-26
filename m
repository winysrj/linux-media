Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58669 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725199AbeK0FMU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 00:12:20 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: hverkuil@xs4all.nl
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 2/2] [media] v4l2-pci-skeleton: replace vb2_buffer with vb2_v4l2_buffer
Date: Mon, 26 Nov 2018 19:01:24 +0100
Message-Id: <20181126180124.15161-3-m.tretter@pengutronix.de>
In-Reply-To: <20181126180124.15161-1-m.tretter@pengutronix.de>
References: <20181126180124.15161-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 2d7007153f0c ("[media] media: videobuf2: Restructure vb2_buffer")
replaced vb2_buffer with vb2_v4l2_buffer in all v4l2 drivers. The
restructuring skipped the v4l2-pci-skeleton, probably because it resides
outside the drivers directory.

The v4l2_buf_ops assume that the passed buffer is a vb2_v4l2_buffer.
This is not the case if the skel_buffer is based on vb2_buffer instead
of vb2_v4l2_buffer.

Replace vb2_buffer with vb2_v4l2_buffer in the skeleton to make sure
that future drivers that are based on the skeleton use vb2_v4l2_buffer.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 samples/v4l/v4l2-pci-skeleton.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/samples/v4l/v4l2-pci-skeleton.c b/samples/v4l/v4l2-pci-skeleton.c
index f520e3aef9c6..27ec30952cfa 100644
--- a/samples/v4l/v4l2-pci-skeleton.c
+++ b/samples/v4l/v4l2-pci-skeleton.c
@@ -80,13 +80,13 @@ struct skeleton {
 };
 
 struct skel_buffer {
-	struct vb2_buffer vb;
+	struct vb2_v4l2_buffer vb;
 	struct list_head list;
 };
 
-static inline struct skel_buffer *to_skel_buffer(struct vb2_buffer *vb2)
+static inline struct skel_buffer *to_skel_buffer(struct vb2_v4l2_buffer *vbuf)
 {
-	return container_of(vb2, struct skel_buffer, vb);
+	return container_of(vbuf, struct skel_buffer, vb);
 }
 
 static const struct pci_device_id skeleton_pci_tbl[] = {
@@ -212,8 +212,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
  */
 static void buffer_queue(struct vb2_buffer *vb)
 {
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct skeleton *skel = vb2_get_drv_priv(vb->vb2_queue);
-	struct skel_buffer *buf = to_skel_buffer(vb);
+	struct skel_buffer *buf = to_skel_buffer(vbuf);
 	unsigned long flags;
 
 	spin_lock_irqsave(&skel->qlock, flags);
@@ -232,7 +233,7 @@ static void return_all_buffers(struct skeleton *skel,
 
 	spin_lock_irqsave(&skel->qlock, flags);
 	list_for_each_entry_safe(buf, node, &skel->buf_list, list) {
-		vb2_buffer_done(&buf->vb, state);
+		vb2_buffer_done(&buf->vb.vb2_buf, state);
 		list_del(&buf->list);
 	}
 	spin_unlock_irqrestore(&skel->qlock, flags);
-- 
2.19.1
