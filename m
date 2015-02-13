Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbbBMW6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>, linux-doc@vger.kernel.org
Subject: [PATCHv4 03/25] [media] Docbook: Fix documentation for media controller devnodes
Date: Fri, 13 Feb 2015 20:57:46 -0200
Message-Id: <c696cf94283bdaf48a0efbc64fd84dd3f068b4cf.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media-ctl userspace application assumes that all device nodes
are uniquelly defined via major,minor, just like v4l and fb.

That's ok for those types of devices, but, as we're adding support
for DVB at the API, what's written there at the DocBook is wrong.

So, fix it.

While here, fix the size of the reserved space inside the union,
with is 184, and not 180.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 116c301656e0..19ab836b2651 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -143,86 +143,14 @@
 	  <row>
 	    <entry></entry>
 	    <entry>struct</entry>
-	    <entry><structfield>v4l</structfield></entry>
+	    <entry><structfield>dev</structfield></entry>
 	    <entry></entry>
-	    <entry>Valid for V4L sub-devices and nodes only.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry>__u32</entry>
-	    <entry><structfield>major</structfield></entry>
-	    <entry>V4L device node major number. For V4L sub-devices with no
-	    device node, set by the driver to 0.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry>__u32</entry>
-	    <entry><structfield>minor</structfield></entry>
-	    <entry>V4L device node minor number. For V4L sub-devices with no
-	    device node, set by the driver to 0.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry>struct</entry>
-	    <entry><structfield>fb</structfield></entry>
-	    <entry></entry>
-	    <entry>Valid for frame buffer nodes only.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry>__u32</entry>
-	    <entry><structfield>major</structfield></entry>
-	    <entry>Frame buffer device node major number.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry>__u32</entry>
-	    <entry><structfield>minor</structfield></entry>
-	    <entry>Frame buffer device node minor number.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry>struct</entry>
-	    <entry><structfield>alsa</structfield></entry>
-	    <entry></entry>
-	    <entry>Valid for ALSA devices only.</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry>__u32</entry>
-	    <entry><structfield>card</structfield></entry>
-	    <entry>ALSA card number</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry>__u32</entry>
-	    <entry><structfield>device</structfield></entry>
-	    <entry>ALSA device number</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry>__u32</entry>
-	    <entry><structfield>subdevice</structfield></entry>
-	    <entry>ALSA sub-device number</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry>int</entry>
-	    <entry><structfield>dvb</structfield></entry>
-	    <entry></entry>
-	    <entry>DVB card number</entry>
+	    <entry>Valid for (sub-)devices that create devnodes.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>__u8</entry>
-	    <entry><structfield>raw</structfield>[180]</entry>
+	    <entry><structfield>raw</structfield>[184]</entry>
 	    <entry></entry>
 	    <entry></entry>
 	  </row>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index ac0f8d9d2a49..3a16ac1f67d0 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -136,6 +136,7 @@ Remote Controller chapter.</contrib>
       <year>2012</year>
       <year>2013</year>
       <year>2014</year>
+      <year>2015</year>
       <holder>Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin
 Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab,
 	Pawel Osciak</holder>
@@ -152,6 +153,13 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.21</revnumber>
+	<date>2015-02-13</date>
+	<authorinitials>mcc</authorinitials>
+	<revremark>Fix documentation for media controller device nodes.
+	</revremark>
+      </revision>
+      <revision>
 	<revnumber>3.19</revnumber>
 	<date>2014-12-05</date>
 	<authorinitials>hv</authorinitials>
-- 
2.1.0

