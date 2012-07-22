Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39407 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2GVUiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jul 2012 16:38:05 -0400
Received: by wgbdr13 with SMTP id dr13so5198612wgb.1
        for <linux-media@vger.kernel.org>; Sun, 22 Jul 2012 13:38:03 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] v4l2-compliance: Add commas to increase readability of displayed result
Date: Sun, 22 Jul 2012 22:37:54 +0200
Message-Id: <1342989474-4178-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 utils/v4l2-compliance/v4l2-compliance.cpp |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-compliance.cpp b/utils/v4l2-compliance/v4l2-compliance.cpp
index 10b06f6..8083051 100644
--- a/utils/v4l2-compliance/v4l2-compliance.cpp
+++ b/utils/v4l2-compliance/v4l2-compliance.cpp
@@ -660,8 +660,7 @@ int main(int argc, char **argv)
 	test_close(node.fd);
 	if (node.node2)
 		test_close(node.node2->fd);
-	printf("Total: %d Succeeded: %d Failed: %d Warnings: %d\n",
+	printf("Total: %d, Succeeded: %d, Failed: %d, Warnings: %d\n",
 			tests_total, tests_ok, tests_total - tests_ok, warnings);
 	exit(app_result);
 }
--
1.7.4.1

