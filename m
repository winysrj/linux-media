Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64412 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbaCCJwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 04:52:32 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [RFC v7,2/3] controls.xml : add addtional Flash fault bits
Date: Mon,  3 Mar 2014 18:52:09 +0900
Message-Id: <1393840330-11130-3-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1393840330-11130-1-git-send-email-gshark.jeong@gmail.com>
References: <1393840330-11130-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Descriptions for flash faluts.
 V4L2_FLASH_FAULT_UNDER_VOLTAGE,
 V4L2_FLASH_FAULT_INPUT_VOLTAGE,
 and V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE

v7 : Changed V4L2_FLASH_FAULT_UNDER_VOLTAGE description

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a5a3188..569861f 100644
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
+    		  <entry>The input voltage of the flash controller is below
+    		  the limit under which strobing the flash at full current
+    		  will not be possible.The condition persists until this flag
+    		  is no longer set.</entry>
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

