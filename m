Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:34517 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932257AbeCMUBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 16:01:38 -0400
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Seiderer <ps.report@gmx.net>
Subject: [PATCH] media: staging/imx: fill vb2_v4l2_buffer sequence entry
Date: Tue, 13 Mar 2018 21:00:54 +0100
Message-Id: <20180313200054.31305-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 drivers/staging/media/imx/imx-media-csi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 5a195f80a24d..3a6a645b9dce 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -111,6 +111,7 @@ struct csi_priv {
 	struct v4l2_ctrl_handler ctrl_hdlr;
 
 	int stream_count; /* streaming counter */
+	__u32 frame_sequence; /* frame sequence counter */
 	bool last_eof;   /* waiting for last EOF at stream off */
 	bool nfb4eof;    /* NFB4EOF encountered during streaming */
 	struct completion last_eof_comp;
@@ -234,8 +235,11 @@ static void csi_vb2_buf_done(struct csi_priv *priv)
 	struct vb2_buffer *vb;
 	dma_addr_t phys;
 
+	priv->frame_sequence++;
+
 	done = priv->active_vb2_buf[priv->ipu_buf_num];
 	if (done) {
+		done->vbuf.sequence = priv->frame_sequence;
 		vb = &done->vbuf.vb2_buf;
 		vb->timestamp = ktime_get_ns();
 		vb2_buffer_done(vb, priv->nfb4eof ?
@@ -543,6 +547,7 @@ static int csi_idmac_start(struct csi_priv *priv)
 
 	/* init EOF completion waitq */
 	init_completion(&priv->last_eof_comp);
+	priv->frame_sequence = 0;
 	priv->last_eof = false;
 	priv->nfb4eof = false;
 
-- 
2.16.2
