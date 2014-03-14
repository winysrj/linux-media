Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1413 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaCNL5b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 07:57:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH for v3.15 1/2] DocBook media: v4l2_format_sdr was renamed to v4l2_sdr_format
Date: Fri, 14 Mar 2014 12:57:06 +0100
Message-Id: <1394798227-3708-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394798227-3708-1-git-send-email-hverkuil@xs4all.nl>
References: <1394798227-3708-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Update the DocBook files accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/dev-sdr.xml      | 6 +++---
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
index 524b9c4..dc14804 100644
--- a/Documentation/DocBook/media/v4l/dev-sdr.xml
+++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
@@ -69,15 +69,15 @@ must be supported as well.
     <para>
 To use the <link linkend="format">format</link> ioctls applications set the
 <structfield>type</structfield> field of a &v4l2-format; to
-<constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant> and use the &v4l2-format-sdr;
+<constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant> and use the &v4l2-sdr-format;
 <structfield>sdr</structfield> member of the <structfield>fmt</structfield>
 union as needed per the desired operation.
 Currently only the <structfield>pixelformat</structfield> field of
-&v4l2-format-sdr; is used. The content of that field is the V4L2 fourcc code
+&v4l2-sdr-format; is used. The content of that field is the V4L2 fourcc code
 of the data format.
     </para>
 
-    <table pgwide="1" frame="none" id="v4l2-format-sdr">
+    <table pgwide="1" frame="none" id="v4l2-sdr-format">
       <title>struct <structname>v4l2_sdr_format</structname></title>
       <tgroup cols="3">
         &cs-str;
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
index f43f1a9..4fe19a7a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
@@ -172,7 +172,7 @@ capture and output devices.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
-	    <entry>&v4l2-format-sdr;</entry>
+	    <entry>&v4l2-sdr-format;</entry>
 	    <entry><structfield>sdr</structfield></entry>
 	    <entry>Definition of a data format, see
 <xref linkend="pixfmt" />, used by SDR capture devices.</entry>
-- 
1.9.0

