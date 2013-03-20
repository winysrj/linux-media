Return-path: <linux-media-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:40397 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3CTDvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 23:51:39 -0400
Message-ID: <5149322E.6040409@asianux.com>
Date: Wed, 20 Mar 2013 11:51:10 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>, volokh84@gmail.com,
	hans.verkuil@cisco.com, dhowells@redhat.com, yamanetoshi@gmail.com
CC: Greg KH <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] drivers/staging/media/go7007: using strlcpy instead of strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


  better to treate them as NUL terminated string.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index cb9fe33..9050e19 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -637,7 +637,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fmt->flags = V4L2_FMT_FLAG_COMPRESSED;
 
-	strncpy(fmt->description, desc, sizeof(fmt->description));
+	strlcpy(fmt->description, desc, sizeof(fmt->description));
 
 	return 0;
 }
@@ -1181,7 +1181,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	if (inp->index >= go->board_info->num_inputs)
 		return -EINVAL;
 
-	strncpy(inp->name, go->board_info->inputs[inp->index].name,
+	strlcpy(inp->name, go->board_info->inputs[inp->index].name,
 			sizeof(inp->name));
 
 	/* If this board has a tuner, it will be the last input */
-- 
1.7.7.6
