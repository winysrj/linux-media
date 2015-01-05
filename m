Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63472 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbbAEXuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jan 2015 18:50:25 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 2/2] Fix data offset config option parsing
Date: Tue,  6 Jan 2015 01:50:15 +0200
Message-Id: <1420501815-3684-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1420501815-3684-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1420501815-3684-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The option itself was considered correctly, but a small but crucial break
statement was missing. --data-offset option does not take an argument
either.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 yavta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/yavta.c b/yavta.c
index 3bec0be..7c21db2 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1770,7 +1770,7 @@ static struct option opts[] = {
 	{"buffer-type", 1, 0, 'B'},
 	{"capture", 2, 0, 'c'},
 	{"check-overrun", 0, 0, 'C'},
-	{"data-prefix", 1, 0, OPT_DATA_PREFIX},
+	{"data-prefix", 0, 0, OPT_DATA_PREFIX},
 	{"delay", 1, 0, 'd'},
 	{"enum-formats", 0, 0, OPT_ENUM_FORMATS},
 	{"enum-inputs", 0, 0, OPT_ENUM_INPUTS},
@@ -2034,6 +2034,7 @@ int main(int argc, char *argv[])
 			break;
 		case OPT_DATA_PREFIX:
 			dev.write_data_prefix = true;
+			break;
 		default:
 			printf("Invalid option -%c\n", c);
 			printf("Run %s -h for help.\n", argv[0]);
-- 
2.1.0.231.g7484e3b

