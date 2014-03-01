Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46251 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753026AbaCAQPT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:15:19 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [yavta PATCH 8/9] Support copy timestamps
Date: Sat,  1 Mar 2014 18:18:09 +0200
Message-Id: <1393690690-5004-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/yavta.c b/yavta.c
index 224405d..5171024 100644
--- a/yavta.c
+++ b/yavta.c
@@ -454,6 +454,9 @@ static void get_ts_flags(uint32_t flags, const char **ts_type, const char **ts_s
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

