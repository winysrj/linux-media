Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:36612 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab3ILM2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 08:28:08 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	ismael.luceno@corp.bluecherry.net
Date: Thu, 12 Sep 2013 14:28:07 +0200
MIME-Version: 1.0
Message-ID: <m34n9qb4x4.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] SOLO6x10: Fix video encoding on big-endian systems.
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index a4c5896..e501287 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -95,38 +95,11 @@ static unsigned char vop_6110_pal_cif[] = {
 	0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00, 0x00,
 };
 
-struct vop_header {
-	/* VE_STATUS0 */
-	u32 mpeg_size:20, sad_motion_flag:1, video_motion_flag:1, vop_type:2,
-		channel:5, source_fl:1, interlace:1, progressive:1;
-
-	/* VE_STATUS1 */
-	u32 vsize:8, hsize:8, last_queue:4, nop0:8, scale:4;
-
-	/* VE_STATUS2 */
-	u32 mpeg_off;
-
-	/* VE_STATUS3 */
-	u32 jpeg_off;
-
-	/* VE_STATUS4 */
-	u32 jpeg_size:20, interval:10, nop1:2;
-
-	/* VE_STATUS5/6 */
-	u32 sec, usec;
-
-	/* VE_STATUS7/8/9 */
-	u32 nop2[3];
-
-	/* VE_STATUS10 */
-	u32 mpeg_size_alt:20, nop3:12;
-
-	u32 end_nops[5];
-} __packed;
+typedef __le32 vop_header[16];
 
 struct solo_enc_buf {
 	enum solo_enc_types	type;
-	struct vop_header	*vh;
+	const vop_header	*vh;
 	int			motion;
 };
 
@@ -430,8 +403,64 @@ static int solo_send_desc(struct solo_enc_dev *solo_enc, int skip,
 				 solo_enc->desc_count - 1);
 }
 
+/* Extract values from VOP header - VE_STATUSxx */
+static inline int vop_interlaced(const vop_header *vh)
+{
+	return (__le32_to_cpu((*vh)[0]) >> 30) & 1;
+}
+
+static inline u8 vop_channel(const vop_header *vh)
+{
+	return (__le32_to_cpu((*vh)[0]) >> 24) & 0x1F;
+}
+
+static inline u8 vop_type(const vop_header *vh)
+{
+	return (__le32_to_cpu((*vh)[0]) >> 22) & 3;
+}
+
+static inline u32 vop_mpeg_size(const vop_header *vh)
+{
+	return __le32_to_cpu((*vh)[0]) & 0xFFFFF;
+}
+
+static inline u8 vop_hsize(const vop_header *vh)
+{
+	return (__le32_to_cpu((*vh)[1]) >> 8) & 0xFF;
+}
+
+static inline u8 vop_vsize(const vop_header *vh)
+{
+	return __le32_to_cpu((*vh)[1]) & 0xFF;
+}
+
+static inline u32 vop_mpeg_offset(const vop_header *vh)
+{
+	return __le32_to_cpu((*vh)[2]);
+}
+
+static inline u32 vop_jpeg_offset(const vop_header *vh)
+{
+	return __le32_to_cpu((*vh)[3]);
+}
+
+static inline u32 vop_jpeg_size(const vop_header *vh)
+{
+	return __le32_to_cpu((*vh)[4]) & 0xFFFFF;
+}
+
+static inline u32 vop_sec(const vop_header *vh)
+{
+	return __le32_to_cpu((*vh)[5]);
+}
+
+static inline u32 vop_usec(const vop_header *vh)
+{
+	return __le32_to_cpu((*vh)[6]);
+}
+
 static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
-		struct vb2_buffer *vb, struct vop_header *vh)
+			  struct vb2_buffer *vb, const vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);
@@ -440,29 +469,30 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 
 	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
 
-	if (vb2_plane_size(vb, 0) < vh->jpeg_size + solo_enc->jpeg_len)
+	if (vb2_plane_size(vb, 0) < vop_jpeg_size(vh) + solo_enc->jpeg_len)
 		return -EIO;
 
 	sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
 			solo_enc->jpeg_header,
 			solo_enc->jpeg_len);
 
-	frame_size = (vh->jpeg_size + solo_enc->jpeg_len + (DMA_ALIGN - 1))
+	frame_size = (vop_jpeg_size(vh) + solo_enc->jpeg_len + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
-	vb2_set_plane_payload(vb, 0, vh->jpeg_size + solo_enc->jpeg_len);
+	vb2_set_plane_payload(vb, 0, vop_jpeg_size(vh) + solo_enc->jpeg_len);
 
 	dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
 			DMA_FROM_DEVICE);
-	ret = solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf, vh->jpeg_off,
-			frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
-			SOLO_JPEG_EXT_SIZE(solo_dev));
+	ret = solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf,
+			     vop_jpeg_offset(vh) - SOLO_JPEG_EXT_ADDR(solo_dev),
+			     frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
+			     SOLO_JPEG_EXT_SIZE(solo_dev));
 	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
 			DMA_FROM_DEVICE);
 	return ret;
 }
 
 static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
-		struct vb2_buffer *vb, struct vop_header *vh)
+		struct vb2_buffer *vb, const vop_header *vh)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);
@@ -470,11 +500,11 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	int skip = 0;
 	int ret;
 
-	if (vb2_plane_size(vb, 0) < vh->mpeg_size)
+	if (vb2_plane_size(vb, 0) < vop_mpeg_size(vh))
 		return -EIO;
 
 	/* If this is a key frame, add extra header */
-	if (!vh->vop_type) {
+	if (!vop_type(vh)) {
 		sg_copy_from_buffer(vbuf->sglist, vbuf->num_pages,
 				solo_enc->vop,
 				solo_enc->vop_len);
@@ -482,16 +512,16 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 		skip = solo_enc->vop_len;
 
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
-		vb2_set_plane_payload(vb, 0, vh->mpeg_size + solo_enc->vop_len);
+		vb2_set_plane_payload(vb, 0, vop_mpeg_size(vh) + solo_enc->vop_len);
 	} else {
 		vb->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
-		vb2_set_plane_payload(vb, 0, vh->mpeg_size);
+		vb2_set_plane_payload(vb, 0, vop_mpeg_size(vh));
 	}
 
 	/* Now get the actual mpeg payload */
-	frame_off = (vh->mpeg_off + sizeof(*vh))
+	frame_off = (vop_mpeg_offset(vh) - SOLO_MP4E_EXT_ADDR(solo_dev) + sizeof(*vh))
 		% SOLO_MP4E_EXT_SIZE(solo_dev);
-	frame_size = (vh->mpeg_size + skip + (DMA_ALIGN - 1))
+	frame_size = (vop_mpeg_size(vh) + skip + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
 
 	dma_map_sg(&solo_dev->pdev->dev, vbuf->sglist, vbuf->num_pages,
@@ -507,7 +537,7 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 			    struct vb2_buffer *vb, struct solo_enc_buf *enc_buf)
 {
-	struct vop_header *vh = enc_buf->vh;
+	const vop_header *vh = enc_buf->vh;
 	int ret;
 
 	/* Check for motion flags */
@@ -531,8 +561,8 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 
 	if (!ret) {
 		vb->v4l2_buf.sequence = solo_enc->sequence++;
-		vb->v4l2_buf.timestamp.tv_sec = vh->sec;
-		vb->v4l2_buf.timestamp.tv_usec = vh->usec;
+		vb->v4l2_buf.timestamp.tv_sec = vop_sec(vh);
+		vb->v4l2_buf.timestamp.tv_usec = vop_usec(vh);
 	}
 
 	vb2_buffer_done(vb, ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
@@ -605,15 +635,13 @@ static void solo_handle_ring(struct solo_dev *solo_dev)
 
 		/* FAIL... */
 		if (enc_get_mpeg_dma(solo_dev, solo_dev->vh_dma, off,
-				     sizeof(struct vop_header)))
+				     sizeof(vop_header)))
 			continue;
 
-		enc_buf.vh = (struct vop_header *)solo_dev->vh_buf;
-		enc_buf.vh->mpeg_off -= SOLO_MP4E_EXT_ADDR(solo_dev);
-		enc_buf.vh->jpeg_off -= SOLO_JPEG_EXT_ADDR(solo_dev);
+		enc_buf.vh = solo_dev->vh_buf;
 
 		/* Sanity check */
-		if (enc_buf.vh->mpeg_off != off)
+		if (vop_mpeg_offset(enc_buf.vh) != SOLO_MP4E_EXT_ADDR(solo_dev) + off)
 			continue;
 
 		if (solo_motion_detected(solo_enc))
@@ -1329,7 +1357,7 @@ int solo_enc_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 
 	init_waitqueue_head(&solo_dev->ring_thread_wait);
 
-	solo_dev->vh_size = sizeof(struct vop_header);
+	solo_dev->vh_size = sizeof(vop_header);
 	solo_dev->vh_buf = pci_alloc_consistent(solo_dev->pdev,
 						solo_dev->vh_size,
 						&solo_dev->vh_dma);
