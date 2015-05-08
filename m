Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:44815 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbbEHKyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 06:54:52 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 788912A0093
	for <linux-media@vger.kernel.org>; Fri,  8 May 2015 12:54:35 +0200 (CEST)
Message-ID: <554C95EB.2050902@xs4all.nl>
Date: Fri, 08 May 2015 12:54:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook/media: remove spurious space.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks ugly, a space before a period at the end of a sentence. Remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/io.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 1c17f80..aee91e7 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1155,7 +1155,7 @@ in which case caches have not been used.</entry>
 	    <entry>The buffer timestamp has been taken from the
 	    <constant>CLOCK_MONOTONIC</constant> clock. To access the
 	    same clock outside V4L2, use
-	    <function>clock_gettime(2)</function> .</entry>
+	    <function>clock_gettime(2)</function>.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
-- 
2.1.4

