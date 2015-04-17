Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47260 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbbDQI30 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2015 04:29:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B8AD82A009F
	for <linux-media@vger.kernel.org>; Fri, 17 Apr 2015 10:29:08 +0200 (CEST)
Message-ID: <5530C454.6090808@xs4all.nl>
Date: Fri, 17 Apr 2015 10:29:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook/media: fix typo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix copy-and-paste errors:

Source -> Process

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 4e9462f..6e1667b 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4863,7 +4863,7 @@ interface and may change in the future.</para>
       </note>
 
       <para>
-	The Image Source control class is intended for low-level control of
+	The Image Process control class is intended for low-level control of
 	image processing functions. Unlike
 	<constant>V4L2_CID_IMAGE_SOURCE_CLASS</constant>, the controls in
 	this class affect processing the image, and do not control capturing
@@ -4871,7 +4871,7 @@ interface and may change in the future.</para>
       </para>
 
       <table pgwide="1" frame="none" id="image-process-control-id">
-      <title>Image Source Control IDs</title>
+      <title>Image Process Control IDs</title>
 
       <tgroup cols="4">
 	<colspec colname="c1" colwidth="1*" />
