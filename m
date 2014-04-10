Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44121 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758550AbaDJWGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:06:51 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 8/9] Support copy timestamps
Date: Fri, 11 Apr 2014 01:06:44 +0300
Message-Id: <1397167605-29956-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
References: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/yavta.c b/yavta.c
index 9810dcf..124dd1d 100644
--- a/yavta.c
+++ b/yavta.c
@@ -668,6 +668,9 @@ static void get_ts_flags(uint32_t flags, const char **ts_type, const char **ts_s
 	case V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC:
 		*ts_type = "monotonic";
 		break;
+	case V4L2_BUF_FLAG_TIMESTAMP_COPY:
+		*ts_type = "copy";
+		break;
 	default:
 		*ts_type = "invalid";
 	}
-- 
1.7.10.4

