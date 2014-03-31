Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.comexp.ru ([78.110.60.213]:35338 "EHLO mail.comexp.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbaCaNuy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 09:50:54 -0400
Message-ID: <1396264443.4328.10.camel@localhost.localdomain>
Subject: [PATCH v2 2/3] videodev2: add new event type
 V4L2_EVENT_SIGNALCHANGED
From: Mikhail Domrachev <mihail.domrychev@comexp.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Aleksey Igonin <aleksey.igonin@comexp.ru>
Date: Mon, 31 Mar 2014 15:14:03 +0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applications subscribed for this event can be notified about
changes of TV standard.

Signed-off-by: Mikhail Domrachev <mihail.domrychev@comexp.ru>
---
 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml | 7 +++++++
 include/uapi/linux/videodev2.h                             | 1 +
 2 files changed, 8 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 5c70b61..dc7cb9f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -155,6 +155,13 @@
 	    </entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_EVENT_SIGNALCHANGED</constant></entry>
+	    <entry>5</entry>
+	    <entry>This event is triggered when TV standard of the input signal is changed.
+		   New detected standard of type &v4l2-std-id; placed to u.data[] field of &v4l2-event;
+	    </entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
 	    <entry>0x08000000</entry>
 	    <entry>Base event number for driver-private events.</entry>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e35ad6c..45094f2 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1765,6 +1765,7 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_FRAME_SYNC			4
+#define V4L2_EVENT_SIGNALCHANGED		5
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
 /* Payload for V4L2_EVENT_VSYNC */
-- 
1.8.5.3



