Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56963 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab2EOVxV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 17:53:21 -0400
Received: by wibhj8 with SMTP id hj8so3298964wib.1
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 14:53:20 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] V4L: DocBook: Improve V4L2_AUTO_N_WHITE_BALANCE control description
Date: Tue, 15 May 2012 23:53:10 +0200
Message-Id: <1337118790-21572-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <20120514000234.GG3373@valkosipuli.retiisi.org.uk>
References: <20120514000234.GG3373@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the estimate color temperature range specification
for white balance presets for which exact values heavily depend on
a particular camera specification.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8994132..1cef967 100644
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
@@ -3184,8 +3183,7 @@ fluorescent H lighting.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_HORIZON</constant>&nbsp;</entry>
-		  <entry>White balance setting for horizon daylight.
-It corresponds approximately to 5000 K color temperature.</entry>
+		  <entry>White balance setting for horizon daylight.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_DAYLIGHT</constant>&nbsp;</entry>
@@ -3195,8 +3193,7 @@ It corresponds approximately to 5000...6500 K color temperature.</entry>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_FLASH</constant>&nbsp;</entry>
 		  <entry>With this setting the camera will compensate for the flash
-light. It slightly warms up the colors and corresponds roughly to 5000...5500 K
-color temperature.</entry>
+light.</entry>
 		</row>
 		<row>
 		  <entry><constant>V4L2_WHITE_BALANCE_CLOUDY</constant>&nbsp;</entry>
@@ -3207,9 +3204,7 @@ range.</entry>
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

