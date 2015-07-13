Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35947 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbbGMDfx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 23:35:53 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: giometti@enneenne.com, corbet@lwn.net, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Doc: pps: Fix file name in pps.txt
Date: Mon, 13 Jul 2015 12:29:11 +0900
Message-Id: <1436758151-17073-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix a file name of example code.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/pps/pps.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/pps/pps.txt b/Documentation/pps/pps.txt
index c508cce..7cb7264 100644
--- a/Documentation/pps/pps.txt
+++ b/Documentation/pps/pps.txt
@@ -125,7 +125,7 @@ The same function may also run the defined echo function
 (pps_ktimer_echo(), passing to it the "ptr" pointer) if the user
 asked for that... etc..
 
-Please see the file drivers/pps/clients/ktimer.c for example code.
+Please see the file drivers/pps/clients/pps-ktimer.c for example code.
 
 
 SYSFS support
-- 
2.5.0.rc1

