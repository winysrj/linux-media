Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58737 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759433AbaGSAwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 20:52:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/3] DocBook media: v4l2_sdr_format buffersize field
Date: Sat, 19 Jul 2014 03:52:11 +0300
Message-Id: <1405731133-12187-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New field buffersize was added to inform application maximum
buffer size used. Add it to documentation too.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/dev-sdr.xml | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
index dc14804..f890356 100644
--- a/Documentation/DocBook/media/v4l/dev-sdr.xml
+++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
@@ -72,9 +72,12 @@ To use the <link linkend="format">format</link> ioctls applications set the
 <constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant> and use the &v4l2-sdr-format;
 <structfield>sdr</structfield> member of the <structfield>fmt</structfield>
 union as needed per the desired operation.
-Currently only the <structfield>pixelformat</structfield> field of
-&v4l2-sdr-format; is used. The content of that field is the V4L2 fourcc code
-of the data format.
+Currently there is two fields, <structfield>pixelformat</structfield> and
+<structfield>buffersize</structfield>, of struct &v4l2-sdr-format; which are
+used. Content of the <structfield>pixelformat</structfield> is V4L2 FourCC
+code of the data format. The <structfield>buffersize</structfield> field is
+maximum buffer size in bytes required for data transfer, set by the driver in
+order to inform application.
     </para>
 
     <table pgwide="1" frame="none" id="v4l2-sdr-format">
@@ -92,8 +95,15 @@ V4L2 defines SDR formats in <xref linkend="sdr-formats" />.
            </entry>
           </row>
           <row>
+            <entry>__u32</entry>
+            <entry><structfield>buffersize</structfield></entry>
+            <entry>
+Maximum size in bytes required for data. Value is set by the driver.
+           </entry>
+          </row>
+          <row>
             <entry>__u8</entry>
-            <entry><structfield>reserved[28]</structfield></entry>
+            <entry><structfield>reserved[24]</structfield></entry>
             <entry>This array is reserved for future extensions.
 Drivers and applications must set it to zero.</entry>
           </row>
-- 
1.9.3

