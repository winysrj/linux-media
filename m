Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:49686 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab3C0Cru (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 22:47:50 -0400
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: mchehab@redhat.com
Cc: andrew.smirnov@gmail.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 5/9] v4l2: Fix the type of V4L2_CID_TUNE_PREEMPHASIS in the documentation
Date: Tue, 26 Mar 2013 19:47:22 -0700
Message-Id: <1364352446-28572-6-git-send-email-andrew.smirnov@gmail.com>
In-Reply-To: <1364352446-28572-1-git-send-email-andrew.smirnov@gmail.com>
References: <1364352446-28572-1-git-send-email-andrew.smirnov@gmail.com>
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

