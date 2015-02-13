Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56434 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbbBMKcc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 05:32:32 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D0EED2A002F
	for <linux-media@vger.kernel.org>; Fri, 13 Feb 2015 11:32:16 +0100 (CET)
Message-ID: <54DDD2B0.7020201@xs4all.nl>
Date: Fri, 13 Feb 2015 11:32:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media: fix validation error
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<tgroup> doesn't understand the 'border' attribute.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
index 30aa635..a8cc102 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
@@ -38,7 +38,7 @@
 	<title>Byte Order.</title>
 	<para>Each cell is one byte.
 	  <informaltable frame="topbot" colsep="1" rowsep="1">
-	    <tgroup cols="5" align="center" border="1">
+	    <tgroup cols="5" align="center">
 	      <colspec align="left" colwidth="2*" />
 	      <tbody valign="top">
 		<row>
-- 
2.1.4

