Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39407 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108AbbBPML7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 07:11:59 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 70AD92A0080
	for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 13:11:39 +0100 (CET)
Message-ID: <54E1DE7B.1060106@xs4all.nl>
Date: Mon, 16 Feb 2015 13:11:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2] Partially revert 'Fix DVB devnode representation at media
 controller'
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Partially revert e31a0ba7df6ce21ac4ed58c4182ec12ca8fd78fb (media: Fix DVB devnode
representation at media controller) and 15d2042107f90f7ce39705716bc2c9a2ec1d5125
(Docbook: Fix documentation for media controller devnodes) commits.

Those commits mark the alsa struct in struct media_entity_desc as deprecated.
However, the alsa struct should remain as it is since it cannot be replaced
by a simple major/minor device node description. The alsa struct was designed
to be used as an alsa card description so V4L2 drivers could use this to expose
the alsa card that they create to carry the captured audio. Such a card is not
just a PCM device, but also needs to contain the alsa subdevice information,
and it may map to multiple devices, e.g. a PCM and a mixer device, such as the
au0828 usb stick creates.

This is exactly as intended and this cannot and should not be replaced by a
simple major/minor.

However, whether this information is in the right form for an ALSA device such
that it can handle udev renaming rules as well is another matter. So mark this
alsa struct as experimental and document the problems involved.

Updated the documentation as well to reflect this and to reinstate the 'major'
and 'minor' field documentation for the struct dev that was removed in the
original commit.

Updated the documentation to clearly state that struct dev is to be used for
(sub-)devices that create a single device node. Other devices need their own
structure here.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index cbf307f..a77c1de 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -145,7 +145,52 @@
 	    <entry>struct</entry>
 	    <entry><structfield>dev</structfield></entry>
 	    <entry></entry>
-	    <entry>Valid for (sub-)devices that create devnodes.</entry>
+	    <entry>Valid for (sub-)devices that create a single device node.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>major</structfield></entry>
+	    <entry>Device node major number.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>minor</structfield></entry>
+	    <entry>Device node minor number.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>struct</entry>
+	    <entry><structfield>alsa</structfield></entry>
+	    <entry></entry>
+	    <entry>Valid for ALSA devices only. This is an <link linkend="experimental">experimental</link>
+	    ALSA device specification. If you want to use this, please contact the
+	    linux-media mailing list (&v4l-ml;) first.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>card</structfield></entry>
+	    <entry>ALSA card number</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>device</structfield></entry>
+	    <entry>ALSA device number</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>subdevice</structfield></entry>
+	    <entry>ALSA sub-device number</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 52cc2a6..bcb2fe8a 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -91,6 +91,27 @@ struct media_entity_desc {
 
 #if 1
 		/*
+		 * EXPERIMENTAL: this shouldn't have been added without
+		 * actual drivers that use this. When the first real driver
+		 * appears that sets this information, special attention
+		 * should be given whether this information is 1) enough, and
+		 * 2) can deal with udev rules that rename devices. The struct
+		 * dev would not be sufficient for this since that does not
+		 * contain the subdevice information. In addition, struct dev
+		 * can only refer to a single device, and not to multiple (e.g.
+		 * pcm and mixer devices).
+		 *
+		 * So for now mark this as experimental.
+		 */
+		struct {
+			__u32 card;
+			__u32 device;
+			__u32 subdevice;
+		} alsa;
+#endif
+
+#if 1
+		/*
 		 * DEPRECATED: previous node specifications. Kept just to
 		 * avoid breaking compilation, but media_entity_desc.dev
 		 * should be used instead. In particular, alsa and dvb
@@ -106,11 +127,6 @@ struct media_entity_desc {
 			__u32 major;
 			__u32 minor;
 		} fb;
-		struct {
-			__u32 card;
-			__u32 device;
-			__u32 subdevice;
-		} alsa;
 		int dvb;
 #endif
 
