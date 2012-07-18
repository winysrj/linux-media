Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:33213 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab2GRPlo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 11:41:44 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id AABBEA5
	for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 15:41:37 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas3.st.com [10.75.90.18])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 5501D466B
	for <linux-media@vger.kernel.org>; Wed, 18 Jul 2012 15:41:37 +0000 (GMT)
From: Nicolas THERY <nicolas.thery@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 18 Jul 2012 17:41:36 +0200
Subject: [PATCH for 3.6] v4l: DocBook: VIDIOC_CREATE_BUFS: add hyperlink
Message-ID: <5006D930.3020102@st.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Nicolas Thery <nicolas.thery@st.com>
---
diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 5e73b1c..a8cda1a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -64,7 +64,7 @@ different sizes.</para>
     <para>To allocate device buffers applications initialize relevant fields of
 the <structname>v4l2_create_buffers</structname> structure. They set the
 <structfield>type</structfield> field in the
-<structname>v4l2_format</structname> structure, embedded in this
+&v4l2-format; structure, embedded in this
 structure, to the respective stream or buffer type.
 <structfield>count</structfield> must be set to the number of required buffers.
 <structfield>memory</structfield> specifies the required I/O method. The
@@ -114,7 +114,7 @@ information.</para>
 /></entry>
 	  </row>
 	  <row>
-	    <entry>struct&nbsp;v4l2_format</entry>
+	    <entry>&v4l2-format;</entry>
 	    <entry><structfield>format</structfield></entry>
 	    <entry>Filled in by the application, preserved by the driver.</entry>
 	  </row>