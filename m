Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:39129 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbaLFKaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 05:30:11 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 979E92A0081
	for <linux-media@vger.kernel.org>; Sat,  6 Dec 2014 11:30:03 +0100 (CET)
Message-ID: <5482DAAB.9080001@xs4all.nl>
Date: Sat, 06 Dec 2014 11:30:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for 3.19] vivid: fix CROP_BOUNDS typo for video output
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An error was returned if composing was not supported, instead of if
cropping was not supported.

A classic copy-and-paste bug. Found with v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v3.18
---
 drivers/media/platform/vivid/vivid-vid-out.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index ee5c399..39ff79f 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -625,7 +625,7 @@ int vivid_vid_out_g_selection(struct file *file, void *priv,
 		sel->r = dev->fmt_out_rect;
 		break;
 	case V4L2_SEL_TGT_CROP_BOUNDS:
-		if (!dev->has_compose_out)
+		if (!dev->has_crop_out)
 			return -EINVAL;
 		sel->r = vivid_max_rect;
 		break;
-- 
2.1.3

