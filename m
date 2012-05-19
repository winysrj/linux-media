Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41553 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2ESU16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 16:27:58 -0400
Received: by weyu7 with SMTP id u7so2450722wey.19
        for <linux-media@vger.kernel.org>; Sat, 19 May 2012 13:27:57 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v3] V4L: DocBook: Improve V4L2_CID_AUTO_N_WHITE_BALANCE control description
Date: Sat, 19 May 2012 22:27:08 +0200
Message-Id: <1337459228-32310-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1337118790-21572-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1337118790-21572-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the estimate color temperature range specification
for the white balance presets for which exact values heavily depend
on a particular camera specification.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8994132..8391107 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3174,29 +3174,27 @@ color temperature range.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant>&nbsp;</entry>
-		  <entry>White balance preset for fluorescent lighting.
-It corresponds approximately to 4000...5000 K color temperature.</entry>
+		  <entry>White balance preset for fluorescent lighting.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT_H</constant>&nbsp;</entry>
-		  <entry>With this setting the camera will compensate for
-fluorescent H lighting.</entry>
+		  <entry>Variant of <constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant>
+for fluorescent lamp lighting with spectral power distribution more similar
+to daylight.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_HORIZON</constant>&nbsp;</entry>
-		  <entry>White balance setting for horizon daylight.
-It corresponds approximately to 5000 K color temperature.</entry>
+		  <entry>White balance setting for horizon daylight.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_DAYLIGHT</constant>&nbsp;</entry>
-		  <entry>White balance preset for daylight (with clear sky).
+		  <entry>White balance preset for clear-sky daylight.
 It corresponds approximately to 5000...6500 K color temperature.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_FLASH</constant>&nbsp;</entry>
 		  <entry>With this setting the camera will compensate for the flash
-light. It slightly warms up the colors and corresponds roughly to 5000...5500 K
-color temperature.</entry>
+light.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_CLOUDY</constant>&nbsp;</entry>
@@ -3207,9 +3205,7 @@ range.</entry>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_SHADE</constant>&nbsp;</entry>
 		  <entry>White balance preset for shade or heavily overcast
-sky. It corresponds approximately to 9000...10000 K color temperature.
-</entry>
+sky.</entry>
 		</row>
 	      </tbody>
 	    </entrytbl>
--
1.7.4.1

