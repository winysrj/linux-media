Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57207 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaBUEtj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 23:49:39 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [RFC v5,2/3] controls.xml : add addtional Flash fault bits
Date: Fri, 21 Feb 2014 13:49:26 +0900
Message-Id: <1392958166-4614-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added more comment about Input voltage flash monitor and external temp function.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a5a3188..145a127 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4370,6 +4370,24 @@ interface and may change in the future.</para>
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
+    		  <entry>The flash controller has detected adjustment by IVFM
+    		  (Input Voltage Flash Monitor) block.
+		  If during the flash current turn-on, the input voltage falls
+		  below the threshold input voltage, IVFM adjust level</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE</constant></entry>
+    		  <entry>The flash controller has detected that TEMP input has
+    		  crossed threshold by external temperature sensor.</entry>
+    		</row>
     	      </tbody>
     	    </entrytbl>
     	  </row>
-- 
1.7.9.5

