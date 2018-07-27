Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36952 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731568AbeG0SmD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 14:42:03 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] v4l: vsp1: Fix deadlock in VSPDL DRM pipelines
Date: Fri, 27 Jul 2018 20:19:45 +0300
Message-Id: <20180727171945.25603-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSP uses a lock to protect the BRU and BRS assignment when
configuring pipelines. The lock is taken in vsp1_du_atomic_begin() and
released in vsp1_du_atomic_flush(), as well as taken and released in
vsp1_du_setup_lif(). This guards against multiple pipelines trying to
assign the same BRU and BRS at the same time.

The DRM framework calls the .atomic_begin() operations in a loop over
all CRTCs included in an atomic commit. On a VSPDL (the only VSP type
where this matters), a single VSP instance handles two CRTCs, with a
single lock. This results in a deadlock when the .atomic_begin()
operation is called on the second CRTC.

The DRM framework serializes atomic commits that affect the same CRTCs,
but doesn't know about two CRTCs sharing the same VSPDL. Two commits
affecting the VSPDL LIF0 and LIF1 respectively can thus race each other,
hence the need for a lock.

This could be fixed on the DRM side by forcing serialization of commits
affecting CRTCs backed by the same VSPDL, but that would negatively
affect performances, as the locking is only needed when the BRU and BRS
need to be reassigned, which is an uncommon case.

The lock protects the whole .atomic_begin() to .atomic_flush() sequence.
The only operation that can occur in-between is vsp1_du_atomic_update(),
which doesn't touch the BRU and BRS, and thus doesn't need to be
protected by the lock. We can thus only take the lock around the
pipeline setup calls in vsp1_du_atomic_flush(), which fixes the
deadlock.

Fixes: f81f9adc4ee1 ("media: v4l: vsp1: Assign BRU and BRS to pipelines dynamically")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

I've successfully tested the patch with kmstest --flip running with four
outputs on a Salvator-XS board, as well as with the DU kms-test-brxalloc.py
test. The deadlock is gone, and no race has been observed.

Mauro, this is a v4.18 regression fix. I'm sorry for sending it so late,
I haven't noticed the issue earlier. Once Kieran reviews it (which should
happen in the next few days), could you send it to Linus ? The breakage is
pretty bad otherwise for people using both the VGA and LVDS outputs at the
same time.

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index edb35a5c57ea..a99fc0ced7a7 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -728,9 +728,6 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
  */
 void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
 {
-	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
-
-	mutex_lock(&vsp1->drm->lock);
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
 
@@ -846,6 +843,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
 
 	drm_pipe->crc = cfg->crc;
 
+	mutex_lock(&vsp1->drm->lock);
 	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
 	vsp1_du_pipeline_configure(pipe);
 	mutex_unlock(&vsp1->drm->lock);
-- 
Regards,

Laurent Pinchart
