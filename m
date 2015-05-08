Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52781 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752911AbbEHKzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 06:55:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E3F9C2A0093
	for <linux-media@vger.kernel.org>; Fri,  8 May 2015 12:55:01 +0200 (CEST)
Message-ID: <554C9605.4050905@xs4all.nl>
Date: Fri, 08 May 2015 12:55:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook/media: improve timestamp documentation
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Explain which clock was used to make the timestamp.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 50ccd33..c9c3c77 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -133,7 +133,10 @@
 	    <entry>struct timespec</entry>
 	    <entry><structfield>timestamp</structfield></entry>
             <entry></entry>
-	    <entry>Event timestamp.</entry>
+	    <entry>Event timestamp. The timestamp has been taken from the
+	    <constant>CLOCK_MONOTONIC</constant> clock. To access the
+	    same clock outside V4L2, use <function>clock_gettime(2)</function>.
+	    </entry>
 	  </row>
 	  <row>
 	    <entry>u32</entry>
-- 
2.1.4

