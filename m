Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44111 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753800AbaDJWGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:06:49 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 3/9] Use int for buffer queue type
Date: Fri, 11 Apr 2014 01:06:39 +0300
Message-Id: <1397167605-29956-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
References: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes comparisons nicer.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/yavta.c b/yavta.c
index 18e1709..5a35bab 100644
--- a/yavta.c
+++ b/yavta.c
@@ -64,7 +64,7 @@ struct device
 {
 	int fd;
 
-	enum v4l2_buf_type type;
+	int type; /* buffer queue type */
 	enum v4l2_memory memtype;
 	unsigned int nbufs;
 	struct buffer *buffers;
-- 
1.7.10.4

