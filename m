Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52097 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbZLCQb3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 11:31:29 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - v1] V4L - Documentation:Adds EBUSY error code for S_STD and QUERYSTD ioctls
Date: Thu,  3 Dec 2009 11:31:30 -0500
Message-Id: <1259857890-570-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

During review of Video Timing API documentation, Hans Verkuil had a comment
on adding EBUSY error code for VIDIOC_S_STD and VIDIOC_QUERYSTD ioctls. This
patch updates the document for this.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
diff -uNr v4l-dvb-e0cd9a337600_master/linux/Documentation/DocBook/v4l/vidioc-g-std.xml v4l-dvb_patch1/linux/Documentation/DocBook/v4l/vidioc-g-std.xml
--- v4l-dvb-e0cd9a337600_master/linux/Documentation/DocBook/v4l/vidioc-g-std.xml	2009-12-01 17:02:04.000000000 -0500
+++ v4l-dvb_patch1/linux/Documentation/DocBook/v4l/vidioc-g-std.xml	2009-12-03 11:18:34.000000000 -0500
@@ -86,6 +86,12 @@
 <constant>VIDIOC_S_STD</constant> parameter was unsuitable.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
+	<listitem>
+	  <para>The device is busy and therefore can not change the standard</para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
diff -uNr v4l-dvb-e0cd9a337600_master/linux/Documentation/DocBook/v4l/vidioc-querystd.xml v4l-dvb_patch1/linux/Documentation/DocBook/v4l/vidioc-querystd.xml
--- v4l-dvb-e0cd9a337600_master/linux/Documentation/DocBook/v4l/vidioc-querystd.xml	2009-12-01 17:02:04.000000000 -0500
+++ v4l-dvb_patch1/linux/Documentation/DocBook/v4l/vidioc-querystd.xml	2009-12-03 11:18:44.000000000 -0500
@@ -70,6 +70,12 @@
 	  <para>This ioctl is not supported.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
+	<listitem>
+	  <para>The device is busy and therefore can not detect the standard</para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
