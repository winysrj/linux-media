Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35654 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbcFNWvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:25 -0400
Received: by mail-pf0-f194.google.com with SMTP id t190so302311pfb.2
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:25 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 28/38] v4l: Add signal lock status to source change events
Date: Tue, 14 Jun 2016 15:49:24 -0700
Message-Id: <1465944574-15745-29-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a signal lock status change to the source changes bitmask.
This indicates there was a signal lock or unlock event detected
at the input of a video decoder.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 12 ++++++++++--
 include/uapi/linux/videodev2.h                     |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index c9c3c77..7758ad7 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -233,8 +233,9 @@
 	    <entry>
 	      <para>This event is triggered when a source parameter change is
 	       detected during runtime by the video device. It can be a
-	       runtime resolution change triggered by a video decoder or the
-	       format change happening on an input connector.
+	       runtime resolution change or signal lock status change
+	       triggered by a video decoder, or the format change happening
+	       on an input connector.
 	       This event requires that the <structfield>id</structfield>
 	       matches the input index (when used with a video device node)
 	       or the pad index (when used with a subdevice node) from which
@@ -461,6 +462,13 @@
 	    from a video decoder.
 	    </entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_SRC_CH_LOCK_STATUS</constant></entry>
+	    <entry>0x0002</entry>
+	    <entry>This event gets triggered when there is a signal lock or
+	    unlock detected at the input of a video decoder.
+	    </entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 8f95191..2eba5da 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2076,6 +2076,7 @@ struct v4l2_event_frame_sync {
 };
 
 #define V4L2_EVENT_SRC_CH_RESOLUTION		(1 << 0)
+#define V4L2_EVENT_SRC_CH_LOCK_STATUS		(1 << 1)
 
 struct v4l2_event_src_change {
 	__u32 changes;
-- 
1.9.1

