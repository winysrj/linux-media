Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:34675 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752898AbeCOTNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 15:13:38 -0400
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Seiderer <ps.report@gmx.net>
Subject: [PATCH v4 1/2] media: staging/imx: fill vb2_v4l2_buffer field entry
Date: Thu, 15 Mar 2018 20:13:22 +0100
Message-Id: <20180315191323.6028-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- fixes gstreamer v4l2src warning:

  0:00:00.716640334  349  0x164f720 WARN  v4l2bufferpool gstv4l2bufferpool.c:1195:gst_v4l2_buffer_pool_dqbuf:<v4l2src0:pool:src> Driver should never set v4l2_buffer.field to ANY

- fixes v4l2-compliance test failure:

  Streaming ioctls:
          test read/write: OK (Not Supported)
              Video Capture:
                  Buffer: 0 Sequence: 0 Field: Any Timestamp: 58.383658s
                  fail: v4l2-test-buffers.cpp(297): g_field() == V4L2_FIELD_ANY

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
Changes in v4:
  - new patch (put first because patch is needed to advance with
    the v4l2-compliance test), thanks to Philipp Zabel
    <p.zabel@pengutronix.de> for suggested solution for the right
    field value source
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 1 +
 drivers/staging/media/imx/imx-media-csi.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index ae453fd422f0..ffeb017c73b2 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -210,6 +210,7 @@ static void prp_vb2_buf_done(struct prp_priv *priv, struct ipuv3_channel *ch)
 
 	done = priv->active_vb2_buf[priv->ipu_buf_num];
 	if (done) {
+		done->vbuf.field = vdev->fmt.fmt.pix.field;
 		vb = &done->vbuf.vb2_buf;
 		vb->timestamp = ktime_get_ns();
 		vb2_buffer_done(vb, priv->nfb4eof ?
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 5a195f80a24d..5f69117b5811 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -236,6 +236,7 @@ static void csi_vb2_buf_done(struct csi_priv *priv)
 
 	done = priv->active_vb2_buf[priv->ipu_buf_num];
 	if (done) {
+		done->vbuf.field = vdev->fmt.fmt.pix.field;
 		vb = &done->vbuf.vb2_buf;
 		vb->timestamp = ktime_get_ns();
 		vb2_buffer_done(vb, priv->nfb4eof ?
-- 
2.16.2
