Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 5/5] media/Documentation: New flag EXECUTE_ON_WRITE
Date: Thu, 19 Mar 2015 16:21:26 +0100
Message-id: <1426778486-21807-6-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1426778486-21807-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1426778486-21807-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Document new flag V4L2_CTRL_FLAG_EXECUTE_ON_WRITE, and the new behavior
of CH_VALUE event on VOLATILE controls.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml   |  7 ++++---
 Documentation/DocBook/media/v4l/vidioc-queryctrl.xml | 15 +++++++++++++--
 Documentation/video4linux/v4l2-controls.txt          |  4 +++-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index b036f89..38d907e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -318,9 +318,10 @@
 	    <entry><constant>V4L2_EVENT_CTRL_CH_VALUE</constant></entry>
 	    <entry>0x0001</entry>
 	    <entry>This control event was triggered because the value of the control
-		changed. Special case: if a button control is pressed, then this
-		event is sent as well, even though there is not explicit value
-		associated with a button control.</entry>
+		changed. Special cases: Volatile controls do no generate this event;
+		If a button control is pressed, then this event is sent as well,
+		even though there is not explicit value associated with a button
+		control.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_EVENT_CTRL_CH_FLAGS</constant></entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index 2bd98fd..d389292 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -599,8 +599,11 @@ writing a value will cause the device to carry out a given action
 	    <entry>This control is volatile, which means that the value of the control
 changes continuously. A typical example would be the current gain value if the device
 is in auto-gain mode. In such a case the hardware calculates the gain value based on
-the lighting conditions which can change over time. Note that setting a new value for
-a volatile control will have no effect. The new value will just be ignored.</entry>
+the lighting conditions which can change over time. Another example would be an error
+flag (missed trigger, invalid voltage on the sensor). In those situations the user
+could write to the control to acknowledge the error, but that write will never
+generate a <constant>V4L2_EVENT_CTRL_CH_VALUE</constant> event and the flag
+<constant>V4L2_CTRL_FLAG_EXECUTE_ON_WRITE</constant> must be set.<entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant></entry>
@@ -610,6 +613,14 @@ using one of the pointer fields of &v4l2-ext-control;. This flag is set for cont
 that are an array, string, or have a compound type. In all cases you have to set a
 pointer to memory containing the payload of the control.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_FLAG_EXECUTE_ON_WRITE</constant></entry>
+	    <entry>0x0200</entry>
+	    <entry>The value provided to the control will be propagated to the driver
+even if remains constant. This is required when the controls represents an action
+on the hardware. For example: clearing an error flag or triggering the flash. All the
+controls of the type <constant>V4L2_CTRL_TYPE_BUTTON</constant> have this flag set.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 0f84ce8..5517db6 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -344,7 +344,9 @@ implement g_volatile_ctrl like this:
 	}
 
 Note that you use the 'new value' union as well in g_volatile_ctrl. In general
-controls that need to implement g_volatile_ctrl are read-only controls.
+controls that need to implement g_volatile_ctrl are read-only controls. If they
+are not, a V4L2_EVENT_CTRL_CH_VALUE will not be generated when the control
+changes.
 
 To mark a control as volatile you have to set V4L2_CTRL_FLAG_VOLATILE:
 
-- 
2.1.4
