Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57456 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972AbbCOQmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 12:42:51 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 504842A0083
	for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 17:42:46 +0100 (CET)
Message-ID: <5505B686.4070704@xs4all.nl>
Date: Sun, 15 Mar 2015 17:42:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] vivid: sanatize selection rectangle
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handle values like ~0 as width, height, left or top fields.
Just strip off the top 16 bits will ensure that the calculations
remain OK.

Found with v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 283b2e8..53f0c1d 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -694,6 +694,9 @@ int vivid_vid_adjust_sel(unsigned flags, struct v4l2_rect *r)
 	unsigned w = r->width;
 	unsigned h = r->height;
 
+	/* sanitize w and h in case someone passes ~0 as the value */
+	w &= 0xffff;
+	h &= 0xffff;
 	if (!(flags & V4L2_SEL_FLAG_LE)) {
 		w++;
 		h++;
@@ -718,8 +721,9 @@ int vivid_vid_adjust_sel(unsigned flags, struct v4l2_rect *r)
 		r->top = 0;
 	if (r->left < 0)
 		r->left = 0;
-	r->left &= ~1;
-	r->top &= ~1;
+	/* sanitize left and top in case someone passes ~0 as the value */
+	r->left &= 0xfffe;
+	r->top &= 0xfffe;
 	if (r->left + w > MAX_WIDTH)
 		r->left = MAX_WIDTH - w;
 	if (r->top + h > MAX_HEIGHT)
-- 
2.1.4

