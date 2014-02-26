Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45942 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZHE3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 02:04:29 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [RFC v6,2/3] controls.xml : add addtional Flash fault bits
Date: Wed, 26 Feb 2014 16:04:10 +0900
Message-Id: <1393398251-5383-3-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1393398251-5383-1-git-send-email-gshark.jeong@gmail.com>
References: <1393398251-5383-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Descriptions for flash faluts.
 V4L2_FLASH_FAULT_UNDER_VOLTAGE,
 V4L2_FLASH_FAULT_INPUT_VOLTAGE,
 and V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a5a3188..16f8af3 100644
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
+    		  <entry>The flash current can't reach to the target current
+    		  because the input voltage is dropped below lower limit. 
+    		  and Flash controller have adjusted the flash current
+    		  not to occur under voltage event.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE</constant></entry>
+    		  <entry>The temperature of the LED has exceeded its
+    		  allowed upper limit.</entry>
+    		</row>
     	      </tbody>
     	    </entrytbl>
     	  </row>
-- 
1.7.9.5

