Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4503 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaBQQJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 11:09:51 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1HG9mU8037642
	for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 17:09:50 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 1E4312A00A9
	for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 17:09:14 +0100 (CET)
Message-ID: <53023429.6090708@xs4all.nl>
Date: Mon, 17 Feb 2014 17:09:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] vivi: fix ENUM_FRAMEINTERVALS implementation.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function never checked if width and height are correct. Add such
a check so the v4l2-compliance tool returns OK again for vivi.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 97428e2..ce9a4f2 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -1121,7 +1121,11 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 	if (!fmt)
 		return -EINVAL;
 
-	/* regarding width & height - we support any */
+	/* check for valid width/height */
+	if (fival->width < 48 || fival->width > MAX_WIDTH || (fival->width & 3))
+		return -EINVAL;
+	if (fival->height < 32 || fival->height > MAX_HEIGHT)
+		return -EINVAL;
 
 	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
 
-- 
1.8.5.1

