Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56808 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751342AbdHDLZM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 07:25:12 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-compat-ioctl32.c: add capabilities field to,
 v4l2_input32
Message-ID: <ceb13f22-3772-aa07-58a1-9d312fe8f55b@xs4all.nl>
Date: Fri, 4 Aug 2017 13:25:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_input32 struct wasn't updated when this field was added.
It didn't cause a failure in the compat code, but it is better to
keep it in sync with v4l2_input to avoid confusion.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 6f52970f8b54..90827073066f 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -627,7 +627,8 @@ struct v4l2_input32 {
 	__u32        tuner;             /*  Associated tuner */
 	compat_u64   std;
 	__u32	     status;
-	__u32	     reserved[4];
+	__u32	     capabilities;
+	__u32	     reserved[3];
 };

 /* The 64-bit v4l2_input struct has extra padding at the end of the struct.
-- 
2.13.2
