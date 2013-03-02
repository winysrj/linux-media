Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2239 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3CBXqD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:46:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 15/20] solo6x10: use monotonic timestamps.
Date: Sun,  3 Mar 2013 00:45:31 +0100
Message-Id: <82414c2026e0ec585f43110794bb474d9fbe6c00.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |    2 +-
 drivers/staging/media/solo6x10/v4l2.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 4fc8d84..fd9cf4f 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -814,7 +814,7 @@ void solo_enc_v4l2_isr(struct solo_dev *solo_dev)
 		enc_buf->jpeg_size = jpeg_size;
 		enc_buf->type = enc_type;
 
-		do_gettimeofday(&enc_buf->ts);
+		v4l2_get_timestamp(&enc_buf->ts);
 
 		solo_dev->enc_wr_idx = (solo_dev->enc_wr_idx + 1) %
 					SOLO_NR_RING_BUFS;
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 8900015..8a4194b 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -336,7 +336,7 @@ finish_buf:
 		vb2_set_plane_payload(vb, 0,
 			solo_vlines(solo_dev) * solo_bytesperline(solo_dev));
 		vb->v4l2_buf.sequence++;
-		do_gettimeofday(&vb->v4l2_buf.timestamp);
+		v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 	}
 
 	vb2_buffer_done(vb, error ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
-- 
1.7.10.4

