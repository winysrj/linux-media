Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54968 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728219AbeIJTzP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 15:55:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] vicodec: check for valid format in v4l2_fwht_en/decode
Date: Mon, 10 Sep 2018 17:00:39 +0200
Message-Id: <20180910150040.39265-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These functions did not return an error if state->info was NULL
or an unsupported pixelformat was selected (should not happen,
but just to be on the safe side).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/codec-v4l2-fwht.c | 15 +++++++++++----
 drivers/media/platform/vicodec/codec-v4l2-fwht.h |  7 ++-----
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index cfcf84b8574d..1b86eb9868c3 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -51,8 +51,7 @@ const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx)
 	return v4l2_fwht_pixfmts + idx;
 }
 
-unsigned int v4l2_fwht_encode(struct v4l2_fwht_state *state,
-			      u8 *p_in, u8 *p_out)
+int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
 	unsigned int size = state->width * state->height;
 	const struct v4l2_fwht_pixfmt_info *info = state->info;
@@ -62,6 +61,8 @@ unsigned int v4l2_fwht_encode(struct v4l2_fwht_state *state,
 	u32 encoding;
 	u32 flags = 0;
 
+	if (!info)
+		return -EINVAL;
 	rf.width = state->width;
 	rf.height = state->height;
 	rf.luma = p_in;
@@ -137,6 +138,8 @@ unsigned int v4l2_fwht_encode(struct v4l2_fwht_state *state,
 		rf.cr = rf.cb + 2;
 		rf.luma++;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	cf.width = state->width;
@@ -180,8 +183,7 @@ unsigned int v4l2_fwht_encode(struct v4l2_fwht_state *state,
 	return cf.size + sizeof(*p_hdr);
 }
 
-int v4l2_fwht_decode(struct v4l2_fwht_state *state,
-		     u8 *p_in, u8 *p_out)
+int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
 	unsigned int size = state->width * state->height;
 	unsigned int chroma_size = size;
@@ -191,6 +193,9 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state,
 	struct fwht_cframe cf;
 	u8 *p;
 
+	if (!state->info)
+		return -EINVAL;
+
 	p_hdr = (struct fwht_cframe_hdr *)p_in;
 	cf.width = ntohl(p_hdr->width);
 	cf.height = ntohl(p_hdr->height);
@@ -320,6 +325,8 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state,
 			*p++ = 0;
 		}
 		break;
+	default:
+		return -EINVAL;
 	}
 	return 0;
 }
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 7794c186d905..22ae0e4d7315 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -41,10 +41,7 @@ struct v4l2_fwht_state {
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat);
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx);
 
-unsigned int v4l2_fwht_encode(struct v4l2_fwht_state *state,
-			      u8 *p_in, u8 *p_out);
-
-int v4l2_fwht_decode(struct v4l2_fwht_state *state,
-		     u8 *p_in, u8 *p_out);
+int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
+int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
 
 #endif
-- 
2.18.0
