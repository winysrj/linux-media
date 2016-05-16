Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52758 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbcEPKCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 06:02:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org
Subject: [PATCH 4/4] Support setting control from values stored in a file
Date: Mon, 16 May 2016 13:02:12 +0300
Message-Id: <1463392932-28307-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1463392932-28307-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1463392932-28307-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/yavta.c b/yavta.c
index 4b531a0360fe..d0bcf7f19c7b 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1225,6 +1225,30 @@ static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
 
 	for ( ; isspace(*val); ++val) { };
 
+	if (*val == '<') {
+		/* Read the control value from the given file. */
+		ssize_t size;
+		int fd;
+
+		val++;
+		fd = open(val, O_RDONLY);
+		if (fd < 0) {
+			printf("unable to open control file `%s'\n", val);
+			return -EINVAL;
+		}
+
+		size = read(fd, ctrl->ptr, ctrl->size);
+		if (size != (ssize_t)ctrl->size) {
+			printf("error reading control file `%s' (%s)\n", val,
+			       strerror(errno));
+			close(fd);
+			return -EINVAL;
+		}
+
+		close(fd);
+		return 0;
+	}
+
 	if (*val++ != '{')
 		return -EINVAL;
 
-- 
2.7.3

