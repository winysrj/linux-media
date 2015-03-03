Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38243 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbbCCIrq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 03:47:46 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0372C2A008D
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2015 09:47:30 +0100 (CET)
Message-ID: <54F57521.4010402@xs4all.nl>
Date: Tue, 03 Mar 2015 09:47:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media: fix typos in YUV420M description
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NV12M -> YUV420M
YVU420M -> YUV420M

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
index 60308f1..e781cc6 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
@@ -29,12 +29,12 @@ and Cr planes have half as many pad bytes after their rows. In other
 words, two Cx rows (including padding) is exactly as long as one Y row
 (including padding).</para>
 
-	<para><constant>V4L2_PIX_FMT_NV12M</constant> is intended to be
+	<para><constant>V4L2_PIX_FMT_YUV420M</constant> is intended to be
 used only in drivers and applications that support the multi-planar API,
 described in <xref linkend="planar-apis"/>. </para>
 
 	<example>
-	  <title><constant>V4L2_PIX_FMT_YVU420M</constant> 4 &times; 4
+	  <title><constant>V4L2_PIX_FMT_YUV420M</constant> 4 &times; 4
 pixel image</title>
 
 	  <formalpara>
-- 
2.1.4

