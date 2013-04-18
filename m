Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47013 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967434Ab3DRQ7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 12:59:11 -0400
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: sameo@linux.intel.com
Cc: mchehab@redhat.com, andrew.smirnov@gmail.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] v4l2: Fix the type of V4L2_CID_TUNE_PREEMPHASIS in the documentation
Date: Thu, 18 Apr 2013 09:58:31 -0700
Message-Id: <1366304318-29620-6-git-send-email-andrew.smirnov@gmail.com>
In-Reply-To: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the type of V4L2_CID_TUNE_PREEMPHASIS from 'integer' to 'enum
v4l2_preemphasis'

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9e8f854..1ad20cc 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3848,7 +3848,7 @@ in Hz. The range and step are driver-specific.</entry>
 	  </row>
 	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_TUNE_PREEMPHASIS</constant>&nbsp;</entry>
-	    <entry>integer</entry>
+	    <entry>enum v4l2_preemphasis</entry>
 	  </row>
 	  <row id="v4l2-preemphasis"><entry spanname="descr">Configures the pre-emphasis value for broadcasting.
 A pre-emphasis filter is applied to the broadcast to accentuate the high audio frequencies.
-- 
1.7.10.4

