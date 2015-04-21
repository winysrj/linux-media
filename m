Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36054 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbbDUNuj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:50:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 2/4] v4l2-pci-skeleton: drop format description
Date: Tue, 21 Apr 2015 15:49:59 +0200
Message-Id: <1429624201-44743-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
References: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The format description is now filled in by the core, so we can
drop this in this skeleton driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 7bd1b97..9c80c09 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -406,9 +406,7 @@ static int skeleton_enum_fmt_vid_cap(struct file *file, void *priv,
 	if (f->index != 0)
 		return -EINVAL;
 
-	strlcpy(f->description, "4:2:2, packed, YUYV", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_YUYV;
-	f->flags = 0;
 	return 0;
 }
 
-- 
2.1.4

