Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2456 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaBJLJT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 06:09:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 4/5] vivi: drop unused field
Date: Mon, 10 Feb 2014 12:08:46 +0100
Message-Id: <1392030527-32661-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392030527-32661-1-git-send-email-hverkuil@xs4all.nl>
References: <1392030527-32661-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index eb09fe6..4114bb6 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -191,7 +191,6 @@ struct vivi_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct vb2_buffer	vb;
 	struct list_head	list;
-	const struct vivi_fmt  *fmt;
 };
 
 struct vivi_dmaqueue {
@@ -875,8 +874,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	vb2_set_plane_payload(&buf->vb, 0, size);
 
-	buf->fmt = dev->fmt;
-
 	precalculate_bars(dev);
 	precalculate_line(dev);
 
-- 
1.8.5.2

