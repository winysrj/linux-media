Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:49561 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbbCMLRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:17:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 35/39] DocBook media: clarify BGR666
Date: Fri, 13 Mar 2015 12:16:13 +0100
Message-Id: <1426245377-17704-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The documentation is not clear whether this is a three or four byte
format. Clarify this.

Also move the BGR666 format to the other 32 bit formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 79 +++++++++++-----------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 6ab4f0f..b60fb93 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -303,45 +303,6 @@ for a pixel lie next to each other in memory.</para>
 	    <entry>b<subscript>1</subscript></entry>
 	    <entry>b<subscript>0</subscript></entry>
 	  </row>
-	  <row id="V4L2-PIX-FMT-BGR666">
-	    <entry><constant>V4L2_PIX_FMT_BGR666</constant></entry>
-	    <entry>'BGRH'</entry>
-	    <entry></entry>
-	    <entry>b<subscript>5</subscript></entry>
-	    <entry>b<subscript>4</subscript></entry>
-	    <entry>b<subscript>3</subscript></entry>
-	    <entry>b<subscript>2</subscript></entry>
-	    <entry>b<subscript>1</subscript></entry>
-	    <entry>b<subscript>0</subscript></entry>
-	    <entry>g<subscript>5</subscript></entry>
-	    <entry>g<subscript>4</subscript></entry>
-	    <entry></entry>
-	    <entry>g<subscript>3</subscript></entry>
-	    <entry>g<subscript>2</subscript></entry>
-	    <entry>g<subscript>1</subscript></entry>
-	    <entry>g<subscript>0</subscript></entry>
-	    <entry>r<subscript>5</subscript></entry>
-	    <entry>r<subscript>4</subscript></entry>
-	    <entry>r<subscript>3</subscript></entry>
-	    <entry>r<subscript>2</subscript></entry>
-	    <entry></entry>
-	    <entry>r<subscript>1</subscript></entry>
-	    <entry>r<subscript>0</subscript></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	  </row>
 	  <row id="V4L2-PIX-FMT-BGR24">
 	    <entry><constant>V4L2_PIX_FMT_BGR24</constant></entry>
 	    <entry>'BGR3'</entry>
@@ -404,6 +365,46 @@ for a pixel lie next to each other in memory.</para>
 	    <entry>b<subscript>1</subscript></entry>
 	    <entry>b<subscript>0</subscript></entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-BGR666">
+	    <entry><constant>V4L2_PIX_FMT_BGR666</constant></entry>
+	    <entry>'BGRH'</entry>
+	    <entry></entry>
+	    <entry>b<subscript>5</subscript></entry>
+	    <entry>b<subscript>4</subscript></entry>
+	    <entry>b<subscript>3</subscript></entry>
+	    <entry>b<subscript>2</subscript></entry>
+	    <entry>b<subscript>1</subscript></entry>
+	    <entry>b<subscript>0</subscript></entry>
+	    <entry>g<subscript>5</subscript></entry>
+	    <entry>g<subscript>4</subscript></entry>
+	    <entry></entry>
+	    <entry>g<subscript>3</subscript></entry>
+	    <entry>g<subscript>2</subscript></entry>
+	    <entry>g<subscript>1</subscript></entry>
+	    <entry>g<subscript>0</subscript></entry>
+	    <entry>r<subscript>5</subscript></entry>
+	    <entry>r<subscript>4</subscript></entry>
+	    <entry>r<subscript>3</subscript></entry>
+	    <entry>r<subscript>2</subscript></entry>
+	    <entry></entry>
+	    <entry>r<subscript>1</subscript></entry>
+	    <entry>r<subscript>0</subscript></entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry></entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	    <entry>-</entry>
+	  </row>
 	  <row id="V4L2-PIX-FMT-ABGR32">
 	    <entry><constant>V4L2_PIX_FMT_ABGR32</constant></entry>
 	    <entry>'AR24'</entry>
-- 
2.1.4

