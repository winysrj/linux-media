Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49810 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbbCMLAQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:00:16 -0400
Message-ID: <5502C335.4080501@xs4all.nl>
Date: Fri, 13 Mar 2015 12:00:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] DocBook media: fix PIX_FMT_SGRBR8 example
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the example of the V4L2_PIX_FMT_SGRBG8 Bayer format.

The even lines should read BGBG, not RBRB.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml b/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
index 19727ab..7803b8c 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
@@ -38,10 +38,10 @@ columns and rows.</para>
 		    </row>
 		    <row>
 		      <entry>start&nbsp;+&nbsp;4:</entry>
-		      <entry>R<subscript>10</subscript></entry>
-		      <entry>B<subscript>11</subscript></entry>
-		      <entry>R<subscript>12</subscript></entry>
-		      <entry>B<subscript>13</subscript></entry>
+		      <entry>B<subscript>10</subscript></entry>
+		      <entry>G<subscript>11</subscript></entry>
+		      <entry>B<subscript>12</subscript></entry>
+		      <entry>G<subscript>13</subscript></entry>
 		    </row>
 		    <row>
 		      <entry>start&nbsp;+&nbsp;8:</entry>
@@ -52,10 +52,10 @@ columns and rows.</para>
 		    </row>
 		    <row>
 		      <entry>start&nbsp;+&nbsp;12:</entry>
-		      <entry>R<subscript>30</subscript></entry>
-		      <entry>B<subscript>31</subscript></entry>
-		      <entry>R<subscript>32</subscript></entry>
-		      <entry>B<subscript>33</subscript></entry>
+		      <entry>B<subscript>30</subscript></entry>
+		      <entry>G<subscript>31</subscript></entry>
+		      <entry>B<subscript>32</subscript></entry>
+		      <entry>G<subscript>33</subscript></entry>
 		    </row>
 		  </tbody>
 		</tgroup>
