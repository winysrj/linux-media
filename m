Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:57536 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbbDUNum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:50:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 3/4] vim2m: drop format description
Date: Tue, 21 Apr 2015 15:50:00 +0200
Message-Id: <1429624201-44743-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
References: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The format description is now filled in by the core, so we can
drop this in this virtual m2m driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 4d6b4cc..cecfd75 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -80,7 +80,6 @@ static struct platform_device vim2m_pdev = {
 };
 
 struct vim2m_fmt {
-	char	*name;
 	u32	fourcc;
 	int	depth;
 	/* Types the format can be used for */
@@ -89,14 +88,12 @@ struct vim2m_fmt {
 
 static struct vim2m_fmt formats[] = {
 	{
-		.name	= "RGB565 (BE)",
 		.fourcc	= V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
 		.depth	= 16,
 		/* Both capture and output format */
 		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	},
 	{
-		.name	= "4:2:2, packed, YUYV",
 		.fourcc	= V4L2_PIX_FMT_YUYV,
 		.depth	= 16,
 		/* Output-only format */
@@ -458,7 +455,6 @@ static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 	if (i < NUM_FORMATS) {
 		/* Format found */
 		fmt = &formats[i];
-		strncpy(f->description, fmt->name, sizeof(f->description) - 1);
 		f->pixelformat = fmt->fourcc;
 		return 0;
 	}
-- 
2.1.4

