Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58733 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbbKQLlt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 06:41:49 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Subject: [v4l-utils 1/1] media-ctl: Fix bad long option crash
Date: Tue, 17 Nov 2015 13:40:58 +0200
Message-Id: <1447760458-8327-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The long options array has to be followed by an all-zero entry. There was
none.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/media-ctl/options.c b/utils/media-ctl/options.c
index ffaffcd..2751e6e 100644
--- a/utils/media-ctl/options.c
+++ b/utils/media-ctl/options.c
@@ -97,6 +97,7 @@ static struct option opts[] = {
 	{"print-topology", 0, 0, 'p'},
 	{"reset", 0, 0, 'r'},
 	{"verbose", 0, 0, 'v'},
+	{ },
 };
 
 int parse_cmdline(int argc, char **argv)
-- 
2.1.0.231.g7484e3b

