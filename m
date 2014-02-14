Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37165 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBNJqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 04:46:01 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [RFC v3,2/3] controls.xml : add addtional Flash fault bits
Date: Fri, 14 Feb 2014 18:45:51 +0900
Message-Id: <1392371151-32644-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add addtional falult bits for FLASH
V4L2_FLASH_FAULT_UNDER_VOLTAGE	: UVLO
V4L2_FLASH_FAULT_INPUT_VOLTAGE	: input voltage is adjusted by IVFM
V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE : NTC Trip point is crossed.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a5a3188..8121f7e 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4370,6 +4370,22 @@ interface and may change in the future.</para>
     		  <entry>The flash controller has detected a short or open
     		  circuit condition on the indicator LED.</entry>
     		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_UNDER_VOLTAGE</constant></entry>
+    		  <entry>Flash controller voltage to the flash LED
+    		  has been below the minimum limit specific to the flash
+    		  controller.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_INPUT_VOLTAGE</constant></entry>
+    		  <entry>The flash controller has detected adjustment of input
+    		  voltage by Input Volage Flash Monitor(IVFM).</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE</constant></entry>
+    		  <entry>The flash controller has detected that TEMP input has
+    		  crossed NTC Trip Voltage.</entry>
+    		</row>
     	      </tbody>
     	    </entrytbl>
     	  </row>
-- 
1.7.9.5

