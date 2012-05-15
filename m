Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:32998 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab2EOWFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 18:05:33 -0400
Received: by weyu7 with SMTP id u7so45169wey.19
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 15:05:32 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v2] V4L: DocBook: Improve V4L2_CID_AUTO_N_WHITE_BALANCE control description
Date: Wed, 16 May 2012 00:05:24 +0200
Message-Id: <1337119524-6921-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <20120514000234.GG3373@valkosipuli.retiisi.org.uk>
References: <20120514000234.GG3373@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the estimate color temperature range specification
for the white balance presets for which exact values heavily depend
on a particular camera specification.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---

Fixed typo in the patch summary line.

 Documentation/DocBook/media/v4l/controls.xml |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8994132..2ed82ee 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3174,8 +3174,7 @@ color temperature range.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant>&nbsp;</entry>
-		  <entry>White balance preset for fluorescent lighting.
-It corresponds approximately to 4000...5000 K color temperature.</entry>
+		  <entry>White balance preset for fluorescent lighting.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT_H</constant>&nbsp;</entry>
@@ -3184,19 +3183,17 @@ fluorescent H lighting.</entry>
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
@@ -3207,8 +3204,7 @@ range.</entry>
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

