Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4180 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3JDOCG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 03/14] timblogiw: fix two sparse warnings
Date: Fri,  4 Oct 2013 16:01:41 +0200
Message-Id: <1380895312-30863-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/platform/timblogiw.c:763:43: warning: incorrect type in initializer (incompatible argument 3 (different signedness))
drivers/media/platform/timblogiw.c:764:43: warning: incorrect type in initializer (incompatible argument 3 (different signedness))

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
---
 drivers/media/platform/timblogiw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index b557caf..6a74ce0 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -403,7 +403,7 @@ static int timblogiw_s_input(struct file *file, void  *priv, unsigned int input)
 	return 0;
 }
 
-static int timblogiw_streamon(struct file *file, void  *priv, unsigned int type)
+static int timblogiw_streamon(struct file *file, void  *priv, enum v4l2_buf_type type)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
@@ -420,7 +420,7 @@ static int timblogiw_streamon(struct file *file, void  *priv, unsigned int type)
 }
 
 static int timblogiw_streamoff(struct file *file, void  *priv,
-	unsigned int type)
+	enum v4l2_buf_type type)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct timblogiw_fh *fh = priv;
-- 
1.8.3.2

