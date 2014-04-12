Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50701 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753878AbaDLNYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:18 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 10/11] Support copy timestamps
Date: Sat, 12 Apr 2014 16:24:02 +0300
Message-Id: <1397309043-8322-11-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/yavta.c b/yavta.c
index e81e058..c878c0d 100644
--- a/yavta.c
+++ b/yavta.c
@@ -726,6 +726,9 @@ static void get_ts_flags(uint32_t flags, const char **ts_type, const char **ts_s
 	case V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC:
 		*ts_type = "mono";
 		break;
+	case V4L2_BUF_FLAG_TIMESTAMP_COPY:
+		*ts_type = "copy";
+		break;
 	default:
 		*ts_type = "inv";
 	}
-- 
1.7.10.4

