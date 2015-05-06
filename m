Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49807 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573AbbEFG5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:57:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 8/8] DocBook/media: document the new media_device_info fields.
Date: Wed,  6 May 2015 08:57:23 +0200
Message-Id: <1430895443-41839-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document major, minor and entity_id, and that MEDIA_IOC_DEVICE_INFO
can be called for other media devices as well, besides just the
media controller.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/media-ioc-device-info.xml    | 35 ++++++++++++++++++----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-device-info.xml b/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
index 2ce5214..9506cf6 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
@@ -49,11 +49,20 @@
   <refsect1>
     <title>Description</title>
 
-    <para>All media devices must support the <constant>MEDIA_IOC_DEVICE_INFO</constant>
-    ioctl. To query device information, applications call the ioctl with a
-    pointer to a &media-device-info;. The driver fills the structure and returns
-    the information to the application.
-    The ioctl never fails.</para>
+    <para>All media devices, both the media controller device itself and any
+    device node used to access a media entity, must support the
+    <constant>MEDIA_IOC_DEVICE_INFO</constant> ioctl. To query device information,
+    applications call the ioctl with a pointer to a &media-device-info;. The driver
+    fills the structure and returns the information to the application.
+    The ioctl never fails, unless it is not a media device, in which case an error
+    is returned, most likely the &ENOTTY;.</para>
+
+    <para>Besides getting the device information from the media controller device
+    itself, applications can use this ioctl as well to check if a device node is part
+    of a media controller. If the ioctl succeeds, then the <structfield>major</structfield>
+    and <structfield>minor</structfield> fields will give you the major and minor
+    numbers of the media controller device and the <structfield>entity_id</structfield>
+    field gives you the entity ID of the media device.</para>
 
     <table pgwide="1" frame="none" id="media-device-info">
       <title>struct <structname>media_device_info</structname></title>
@@ -110,6 +119,22 @@
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
+	    <entry><structfield>major</structfield></entry>
+	    <entry>The major number of the media device node.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>minor</structfield></entry>
+	    <entry>The minor number of the media device node.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>entity_id</structfield></entry>
+	    <entry>The entity ID if this ioctl was called for a device that is
+	    an entity. The media controller will set this to 0.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield>[31]</entry>
 	    <entry>Reserved for future extensions. Drivers and applications must
 	    set this array to zero.</entry>
-- 
2.1.4

