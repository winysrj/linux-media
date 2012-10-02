Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3292 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2JBGsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 02:48:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] v4l2-ioctl: fix W=1 warnings
Date: Tue,  2 Oct 2012 08:47:59 +0200
Message-Id: <b51aa59482fe5b81251592bb4d5b3c580a304d12.1349160401.git.hans.verkuil@cisco.com>
In-Reply-To: <1349160479-5314-1-git-send-email-hverkuil@xs4all.nl>
References: <1349160479-5314-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <10d7f0ff3a151454cd7cf21e59333544e40fc577.1349160401.git.hans.verkuil@cisco.com>
References: <10d7f0ff3a151454cd7cf21e59333544e40fc577.1349160401.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since the prt_names() macro is always called with an unsigned index the
((a) >= 0) condition is always true and gives a compiler warning when
compiling with W=1.

Rewrite the macro to avoid that warning, but cast the index to unsigned
just in case it is ever called with a signed argument.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index a9af6f8..df74898 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -157,8 +157,7 @@ static const char *v4l2_memory_names[] = {
 	[V4L2_MEMORY_OVERLAY] = "overlay",
 };
 
-#define prt_names(a, arr) ((((a) >= 0) && ((a) < ARRAY_SIZE(arr))) ? \
-			   arr[a] : "unknown")
+#define prt_names(a, arr) (((unsigned)(a)) < ARRAY_SIZE(arr) ? arr[a] : "unknown")
 
 /* ------------------------------------------------------------------ */
 /* debug help functions                                               */
-- 
1.7.10.4

