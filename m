Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42880 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933136AbdKOR72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 12:59:28 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] v4l: sh_mobile_ceu: Return buffers on streamoff()
Date: Wed, 15 Nov 2017 18:59:12 +0100
Message-Id: <1510768752-7588-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf2 core reports an error when not all buffers have been returned
to the framework:

drivers/media/v4l2-core/videobuf2-core.c:1651
WARN_ON(atomic_read(&q->owned_by_drv_count))

Fix this returning all buffers currently in capture queue.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---

I know I'm working to get rid of this driver, but while I was trying to have
it working again on mainline, I found this had to be fixed.

Thanks
  j

---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 36762ec..9180a1d 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -451,13 +451,18 @@ static void sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct list_head *buf_head, *tmp;
+	struct vb2_v4l2_buffer *vbuf;

 	spin_lock_irq(&pcdev->lock);

 	pcdev->active = NULL;

-	list_for_each_safe(buf_head, tmp, &pcdev->capture)
+	list_for_each_safe(buf_head, tmp, &pcdev->capture) {
+		vbuf = &list_entry(buf_head, struct sh_mobile_ceu_buffer,
+				   queue)->vb;
+		vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 		list_del_init(buf_head);
+	}

 	spin_unlock_irq(&pcdev->lock);

--
2.7.4
