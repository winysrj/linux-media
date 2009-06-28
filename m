Return-path: <linux-media-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1113 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667AbZF1Q1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:35 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, ivtv-users@ivtvdriver.org,
	ivtv-devel@ivtvdriver.org
Subject: [PATCH 22/62] drivers/media/video/cx18/cx18-fileops.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:27 -0700
Message-Id: <7eeefbbba34fc477540566c6b1888cb7c871f4cd.1246173681.git.joe@perches.com>
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/cx18/cx18-fileops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
index 29969c1..04d9c25 100644
--- a/drivers/media/video/cx18/cx18-fileops.c
+++ b/drivers/media/video/cx18/cx18-fileops.c
@@ -690,7 +690,7 @@ int cx18_v4l2_open(struct file *filp)
 	int res;
 	struct video_device *video_dev = video_devdata(filp);
 	struct cx18_stream *s = video_get_drvdata(video_dev);
-	struct cx18 *cx = s->cx;;
+	struct cx18 *cx = s->cx;
 
 	mutex_lock(&cx->serialize_lock);
 	if (cx18_init_on_first_open(cx)) {
-- 
1.6.3.1.10.g659a0.dirty

