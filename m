Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:43927 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758611AbbDYIPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 04:15:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8ED052A0081
	for <linux-media@vger.kernel.org>; Sat, 25 Apr 2015 10:15:24 +0200 (CEST)
Message-ID: <553B4D1C.8050006@xs4all.nl>
Date: Sat, 25 Apr 2015 10:15:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook/media: attemps -> attempts
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix typo.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/DocBook/media/v4l/media-func-open.xml b/Documentation/DocBook/media/v4l/media-func-open.xml
index f7df034..122374a 100644
--- a/Documentation/DocBook/media/v4l/media-func-open.xml
+++ b/Documentation/DocBook/media/v4l/media-func-open.xml
@@ -44,7 +44,7 @@
     <para>To open a media device applications call <function>open()</function>
     with the desired device name. The function has no side effects; the device
     configuration remain unchanged.</para>
-    <para>When the device is opened in read-only mode, attemps to modify its
+    <para>When the device is opened in read-only mode, attempts to modify its
     configuration will result in an error, and <varname>errno</varname> will be
     set to <errorcode>EBADF</errorcode>.</para>
   </refsect1>
