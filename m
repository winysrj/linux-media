Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46112 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab3EWOnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 7/9] [media] coda: add coda_encode_header helper function
Date: Thu, 23 May 2013 16:42:59 +0200
Message-Id: <1369320181-17933-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for CODA7541 and CODA960 multi-stream support and for
replacement of the completion with a mutex lock, consolidate the
header encoding in a helper function.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 112 ++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 59 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 83e3caf..cd1ce70 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1031,6 +1031,28 @@ static int coda_h264_padding(int size, char *p)
 	return nal_size;
 }
 
+static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
+			      int header_code, u8 *header, int *size)
+{
+	struct coda_dev *dev = ctx->dev;
+	int ret;
+
+	coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0),
+		   CODA_CMD_ENC_HEADER_BB_START);
+	coda_write(dev, vb2_plane_size(buf, 0), CODA_CMD_ENC_HEADER_BB_SIZE);
+	coda_write(dev, header_code, CODA_CMD_ENC_HEADER_CODE);
+	ret = coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
+		return ret;
+	}
+	*size = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
+		coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+	memcpy(header, vb2_plane_vaddr(buf, 0), *size);
+
+	return 0;
+}
+
 static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
@@ -1041,7 +1063,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct vb2_buffer *buf;
 	u32 dst_fourcc;
 	u32 value;
-	int ret;
+	int ret = 0;
 
 	if (count < 1)
 		return -EINVAL;
@@ -1228,33 +1250,22 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		 * Get SPS in the first frame and copy it to an
 		 * intermediate buffer.
 		 */
-		coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
-		coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
-		coda_write(dev, CODA_HEADER_H264_SPS, CODA_CMD_ENC_HEADER_CODE);
-		if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
-			v4l2_err(v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
-			return -ETIMEDOUT;
-		}
-		ctx->vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
-				coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
-		memcpy(&ctx->vpu_header[0][0], vb2_plane_vaddr(buf, 0),
-		       ctx->vpu_header_size[0]);
+		ret = coda_encode_header(ctx, buf, CODA_HEADER_H264_SPS,
+					 &ctx->vpu_header[0][0],
+					 &ctx->vpu_header_size[0]);
+		if (ret < 0)
+			goto out;
 
 		/*
 		 * Get PPS in the first frame and copy it to an
 		 * intermediate buffer.
 		 */
-		coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
-		coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
-		coda_write(dev, CODA_HEADER_H264_PPS, CODA_CMD_ENC_HEADER_CODE);
-		if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
-			v4l2_err(v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
-			return -ETIMEDOUT;
-		}
-		ctx->vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
-				coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
-		memcpy(&ctx->vpu_header[1][0], vb2_plane_vaddr(buf, 0),
-		       ctx->vpu_header_size[1]);
+		ret = coda_encode_header(ctx, buf, CODA_HEADER_H264_PPS,
+					 &ctx->vpu_header[1][0],
+					 &ctx->vpu_header_size[1]);
+		if (ret < 0)
+			goto out;
+
 		/*
 		 * Length of H.264 headers is variable and thus it might not be
 		 * aligned for the coda to append the encoded frame. In that is
@@ -1270,48 +1281,31 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		 * Get VOS in the first frame and copy it to an
 		 * intermediate buffer
 		 */
-		coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
-		coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
-		coda_write(dev, CODA_HEADER_MP4V_VOS, CODA_CMD_ENC_HEADER_CODE);
-		if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
-			v4l2_err(v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
-			return -ETIMEDOUT;
-		}
-		ctx->vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
-				coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
-		memcpy(&ctx->vpu_header[0][0], vb2_plane_vaddr(buf, 0),
-		       ctx->vpu_header_size[0]);
-
-		coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
-		coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
-		coda_write(dev, CODA_HEADER_MP4V_VIS, CODA_CMD_ENC_HEADER_CODE);
-		if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
-			v4l2_err(v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
-			return -ETIMEDOUT;
-		}
-		ctx->vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
-				coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
-		memcpy(&ctx->vpu_header[1][0], vb2_plane_vaddr(buf, 0),
-		       ctx->vpu_header_size[1]);
-
-		coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
-		coda_write(dev, bitstream_size, CODA_CMD_ENC_HEADER_BB_SIZE);
-		coda_write(dev, CODA_HEADER_MP4V_VOL, CODA_CMD_ENC_HEADER_CODE);
-		if (coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER)) {
-			v4l2_err(v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
-			return -ETIMEDOUT;
-		}
-		ctx->vpu_header_size[2] = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx)) -
-				coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
-		memcpy(&ctx->vpu_header[2][0], vb2_plane_vaddr(buf, 0),
-		       ctx->vpu_header_size[2]);
+		ret = coda_encode_header(ctx, buf, CODA_HEADER_MP4V_VOS,
+					 &ctx->vpu_header[0][0],
+					 &ctx->vpu_header_size[0]);
+		if (ret < 0)
+			goto out;
+
+		ret = coda_encode_header(ctx, buf, CODA_HEADER_MP4V_VIS,
+					 &ctx->vpu_header[1][0],
+					 &ctx->vpu_header_size[1]);
+		if (ret < 0)
+			goto out;
+
+		ret = coda_encode_header(ctx, buf, CODA_HEADER_MP4V_VOL,
+					 &ctx->vpu_header[2][0],
+					 &ctx->vpu_header_size[2]);
+		if (ret < 0)
+			goto out;
 		break;
 	default:
 		/* No more formats need to save headers at the moment */
 		break;
 	}
 
-	return 0;
+out:
+	return ret;
 }
 
 static int coda_stop_streaming(struct vb2_queue *q)
-- 
1.8.2.rc2

