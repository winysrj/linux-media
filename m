Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4860 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaCJN6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 09:58:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, k.debski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 3/7] mem2mem_testdev: set priv to 0
Date: Mon, 10 Mar 2014 14:58:25 +0100
Message-Id: <1394459909-36497-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394459909-36497-1-git-send-email-hverkuil@xs4all.nl>
References: <1394459909-36497-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

v4l2_compliance fix.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 104d863..c4b54f8 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -532,6 +532,7 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct m2mtest_fmt *fmt)
 	f->fmt.pix.width &= ~DIM_ALIGN_MASK;
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
-- 
1.9.0

