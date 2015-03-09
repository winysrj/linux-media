Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:47826 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbbCIPp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:45:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/29] vivid: wrong top/bottom order for FIELD_ALTERNATE
Date: Mon,  9 Mar 2015 16:44:25 +0100
Message-Id: <1425915891-1017-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The condition to decide whether the current field is top or bottom
was inverted. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 39a67cf..9898072 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -427,7 +427,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 		 * standards.
 		 */
 		buf->vb.v4l2_buf.field = ((dev->vid_cap_seq_count & 1) ^ is_60hz) ?
-			V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM;
+			V4L2_FIELD_BOTTOM : V4L2_FIELD_TOP;
 		/*
 		 * The sequence counter counts frames, not fields. So divide
 		 * by two.
-- 
2.1.4

