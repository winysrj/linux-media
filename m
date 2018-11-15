Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52108 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbeKOVcR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 16:32:17 -0500
Received: by mail-wm1-f68.google.com with SMTP id w7-v6so18437596wmc.1
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 03:24:49 -0800 (PST)
From: Dafna Hirschfeld <dafna3@gmail.com>
To: helen.koike@collabora.com, hverkuil@xs4all.nl, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Dafna Hirschfeld <dafna3@gmail.com>,
        outreachy-kernel@googlegroups.com
Subject: [PATCH vicodec v4 3/3] media: vicodec: Add support for 4 planes formats
Date: Thu, 15 Nov 2018 13:23:32 +0200
Message-Id: <a2652e2d86ec5bcf212d4141e7b603c454537e80.1541451484.git.dafna3@gmail.com>
In-Reply-To: <cover.1541451484.git.dafna3@gmail.com>
References: <cover.1541451484.git.dafna3@gmail.com>
In-Reply-To: <cover.1541451484.git.dafna3@gmail.com>
References: <cover.1541451484.git.dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for formats with 4 planes: V4L2_PIX_FMT_ABGR32,
V4L2_PIX_FMT_ARGB32.
Also add alpha plane related flags to the header of the encoded file.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.c   | 15 +++++++++
 drivers/media/platform/vicodec/codec-fwht.h   |  2 ++
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 32 +++++++++++++++++++
 drivers/media/platform/vicodec/vicodec-core.c | 12 +++++--
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index 1af9af84163e..9513374e8f44 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -782,6 +782,17 @@ u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 			encoding |= FWHT_CR_UNENCODED;
 		encoding &= ~FWHT_FRAME_UNENCODED;
 	}
+
+	if (frm->components_num == 4) {
+		rlco_max = rlco + size / 2 - 256;
+		encoding = encode_plane(frm->alpha, ref_frm->alpha, &rlco, rlco_max, cf,
+				frm->height, frm->width,
+				frm->luma_alpha_step, is_intra, next_is_intra);
+		if (encoding & FWHT_FRAME_UNENCODED)
+			encoding |= FWHT_ALPHA_UNENCODED;
+		encoding &= ~FWHT_FRAME_UNENCODED;
+	}
+
 	cf->size = (rlco - cf->rlc_data) * sizeof(*rlco);
 	return encoding;
 }
@@ -860,4 +871,8 @@ void fwht_decode_frame(struct fwht_cframe *cf, struct fwht_raw_frame *ref,
 		decode_plane(cf, &rlco, ref->cr, h, w,
 			hdr_flags & FWHT_FL_CR_IS_UNCOMPRESSED);
 	}
+
+	if (components_num == 4)
+		decode_plane(cf, &rlco, ref->alpha, cf->height, cf->width,
+		     hdr_flags & FWHT_FL_ALPHA_IS_UNCOMPRESSED);
 }
diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index bde11fb93f26..90ff8962fca7 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -75,6 +75,7 @@
 #define FWHT_FL_CR_IS_UNCOMPRESSED	BIT(6)
 #define FWHT_FL_CHROMA_FULL_HEIGHT	BIT(7)
 #define FWHT_FL_CHROMA_FULL_WIDTH	BIT(8)
+#define FWHT_FL_ALPHA_IS_UNCOMPRESSED	BIT(9)
 
 /* A 4-values flag - the number of components - 1 */
 #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
@@ -119,6 +120,7 @@ struct fwht_raw_frame {
 #define FWHT_LUMA_UNENCODED	BIT(2)
 #define FWHT_CB_UNENCODED	BIT(3)
 #define FWHT_CR_UNENCODED	BIT(4)
+#define FWHT_ALPHA_UNENCODED	BIT(5)
 
 u32 fwht_encode_frame(struct fwht_raw_frame *frm,
 		      struct fwht_raw_frame *ref_frm,
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 7dc3918a017e..b53655a8cef6 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -33,6 +33,8 @@ static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
 	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3},
 	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3},
 	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3},
+	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4},
+	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4},
 
 };
 
@@ -146,6 +148,18 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 		rf.cr = rf.cb + 2;
 		rf.luma++;
 		break;
+	case V4L2_PIX_FMT_ARGB32:
+		rf.alpha = rf.luma;
+		rf.cr = rf.luma + 1;
+		rf.cb = rf.cr + 2;
+		rf.luma += 2;
+		break;
+	case V4L2_PIX_FMT_ABGR32:
+		rf.cb = rf.luma;
+		rf.cr = rf.cb + 2;
+		rf.luma++;
+		rf.alpha = rf.cr + 1;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -177,6 +191,8 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 		flags |= FWHT_FL_CB_IS_UNCOMPRESSED;
 	if (encoding & FWHT_CR_UNENCODED)
 		flags |= FWHT_FL_CR_IS_UNCOMPRESSED;
+	if (encoding & FWHT_ALPHA_UNENCODED)
+		flags |= FWHT_FL_ALPHA_IS_UNCOMPRESSED;
 	if (rf.height_div == 1)
 		flags |= FWHT_FL_CHROMA_FULL_HEIGHT;
 	if (rf.width_div == 1)
@@ -356,6 +372,22 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 			*p++ = 0;
 		}
 		break;
+	case V4L2_PIX_FMT_ARGB32:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = state->ref_frame.alpha[i];
+			*p++ = state->ref_frame.cr[i];
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cb[i];
+		}
+		break;
+	case V4L2_PIX_FMT_ABGR32:
+		for (i = 0, p = p_out; i < size; i++) {
+			*p++ = state->ref_frame.cb[i];
+			*p++ = state->ref_frame.luma[i];
+			*p++ = state->ref_frame.cr[i];
+			*p++ = state->ref_frame.alpha[i];
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 92bc68694a21..5ae876238e13 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -997,9 +997,11 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 
 	/*
 	 * we don't know ahead how many components are in the encoding type
-	 * V4L2_PIX_FMT_FWHT, so we will allocate space for 3 planes.
+	 * V4L2_PIX_FMT_FWHT, so we will allocate space for 4 planes.
 	 */
-	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num >= 3)
+	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num == 4)
+		total_planes_size = 2 * size + 2 * (size / chroma_div);
+	else if (info->components_num == 3)
 		total_planes_size = size + 2 * (size / chroma_div);
 	else
 		total_planes_size = size;
@@ -1028,6 +1030,12 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		state->ref_frame.cb = NULL;
 		state->ref_frame.cr = NULL;
 	}
+
+	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num == 4)
+		state->ref_frame.alpha = state->ref_frame.cr + size / chroma_div;
+	else
+		state->ref_frame.alpha = NULL;
+
 	ctx->last_src_buf = NULL;
 	ctx->last_dst_buf = NULL;
 	state->gop_cnt = 0;
-- 
2.17.1
