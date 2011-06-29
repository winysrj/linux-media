Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:55759 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1F2MAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:00:48 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH] Add support for V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK
Date: Wed, 29 Jun 2011 14:00:37 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291400.37234.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

Second attempt: inverted the meaning of the flag as per Laurent's suggestion.

Regards,

	Hans



Normally no control events will go to the filehandle that called the
VIDIOC_S_CTRL/VIDIOC_S_EXT_CTRLS ioctls. This is to prevent a feedback
loop.

This can now be overridden by setting the new V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK
flag.

Based on suggestions from Mauro Carvalho Chehab <mchehab@redhat.com> and
Laurent Pinchart <laurent.pinchart@ideasonboard.com>.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   36 ++++++++++++++++----
 drivers/media/video/v4l2-ctrls.c                   |    3 +-
 include/linux/videodev2.h                          |    3 +-
 3 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 039a969..25471e8 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -114,25 +114,28 @@
 	  <row>
 	    <entry><constant>V4L2_EVENT_CTRL</constant></entry>
 	    <entry>3</entry>
-	    <entry>This event requires that the <structfield>id</structfield>
+	    <entry><para>This event requires that the <structfield>id</structfield>
 		matches the control ID from which you want to receive events.
 		This event is triggered if the control's value changes, if a
 		button control is pressed or if the control's flags change.
 	    	This event has a &v4l2-event-ctrl; associated with it. This struct
 		contains much of the same information as &v4l2-queryctrl; and
-		&v4l2-control;.
+		&v4l2-control;.</para>
 
-		If the event is generated due to a call to &VIDIOC-S-CTRL; or
-		&VIDIOC-S-EXT-CTRLS;, then the event will not be sent to
+		<para>If the event is generated due to a call to &VIDIOC-S-CTRL; or
+		&VIDIOC-S-EXT-CTRLS;, then the event will <emphasis>not</emphasis> be sent to
 		the file handle that called the ioctl function. This prevents
-		nasty feedback loops.
+		nasty feedback loops. If you <emphasis>do</emphasis> want to get the
+		event, then set the <constant>V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK</constant>
+		flag.
+		</para>
 
-		This event type will ensure that no information is lost when
+		<para>This event type will ensure that no information is lost when
 		more events are raised than there is room internally. In that
 		case the &v4l2-event-ctrl; of the second-oldest event is kept,
 		but the <structfield>changes</structfield> field of the
 		second-oldest event is ORed with the <structfield>changes</structfield>
-		field of the oldest event.
+		field of the oldest event.</para>
 	    </entry>
 	  </row>
 	  <row>
@@ -157,6 +160,25 @@
 		that are triggered by a status change such as <constant>V4L2_EVENT_CTRL</constant>.
 		Other events will ignore this flag.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK</constant></entry>
+	    <entry>0x0002</entry>
+	    <entry><para>If set, then events directly caused by an ioctl will also be sent to
+		the filehandle that called that ioctl. For example, changing a control using
+		&VIDIOC-S-CTRL; will cause a V4L2_EVENT_CTRL to be sent back to that same
+		filehandle. Normally such events are suppressed to prevent feedback loops
+		where an application changes a control to a one value and then another, and
+		then receives an event telling it that that control has changed to the first
+		value.</para>
+
+		<para>Since it can't tell whether that event was caused by another application
+		or by the &VIDIOC-S-CTRL; call it is hard to decide whether to set the
+		control to the value in the event, or ignore it.</para>
+
+		<para>Think carefully when you set this flag so you won't get into situations
+		like that.</para>
+	    </entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index bc08f86..bd2456d 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -590,7 +590,8 @@ static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 	fill_event(&ev, ctrl, changes);
 
 	list_for_each_entry(sev, &ctrl->ev_subs, node)
-		if (sev->fh && sev->fh != fh)
+		if (sev->fh && (sev->fh != fh ||
+				(sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))
 			v4l2_event_queue_fh(sev->fh, &ev);
 }
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index baafe2f..2c4e837 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1832,7 +1832,8 @@ struct v4l2_event {
 	__u32				reserved[8];
 };
 
-#define V4L2_EVENT_SUB_FL_SEND_INITIAL (1 << 0)
+#define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
+#define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK	(1 << 1)
 
 struct v4l2_event_subscription {
 	__u32				type;
-- 
1.7.1

