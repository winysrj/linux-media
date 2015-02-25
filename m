Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33450 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbbBYPFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 10:05:20 -0500
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id F0C692A0099
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 16:05:12 +0100 (CET)
Message-ID: <54EDE4A9.7010605@xs4all.nl>
Date: Wed, 25 Feb 2015 16:05:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCHv3] media.h: mark alsa struct in media_entity_desc as TODO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The alsa struct in struct media_entity_desc is now marked as deprecated.
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
alsa struct as TODO and document the problems involved.

Updated the documentation as well to reflect this and to add the 'major'
and 'minor' field documentation.

Updated the documentation to clearly state that struct dev is to be used for
(sub-)devices that create a single device node. Other devices need their own
structure here.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  | 16 ++++++++++++-
 include/uapi/linux/media.h                         | 26 +++++++++++++++++-----
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index cbf307f..5872f8bb 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -145,7 +145,21 @@
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
 	  </row>
 	  <row>
 	    <entry></entry>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 52cc2a6..4e816be 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -91,6 +91,27 @@ struct media_entity_desc {

 #if 1
 		/*
+		 * TODO: this shouldn't have been added without
+		 * actual drivers that use this. When the first real driver
+		 * appears that sets this information, special attention
+		 * should be given whether this information is 1) enough, and
+		 * 2) can deal with udev rules that rename devices. The struct
+		 * dev would not be sufficient for this since that does not
+		 * contain the subdevice information. In addition, struct dev
+		 * can only refer to a single device, and not to multiple (e.g.
+		 * pcm and mixer devices).
+		 *
+		 * So for now mark this as a to do.
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

-- 
2.1.4

