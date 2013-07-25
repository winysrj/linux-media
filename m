Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:20693 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab3GYN0A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:26:00 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r6PDPtGO025835
	for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 13:25:57 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 1/5] qv4l2: move function ctrlEvent
Date: Thu, 25 Jul 2013 15:25:20 +0200
Message-Id: <0fd43d1af7343792f570f32251ad150735066f71.1374758669.git.bwinther@cisco.com>
In-Reply-To: <1374758724-3058-1-git-send-email-bwinther@cisco.com>
References: <1374758724-3058-1-git-send-email-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moved the ctrlEvent() function in qv4l2.cpp to be grouped with GUI function
and to group capFrame() and capVbiFrame() together.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/qv4l2.cpp | 94 +++++++++++++++++++++++++--------------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index de9b154..a8fcc65 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -202,6 +202,53 @@ void ApplicationWindow::openrawdev()
 		setDevice(d.selectedFiles().first(), true);
 }
 
+void ApplicationWindow::ctrlEvent()
+{
+	v4l2_event ev;
+
+	while (dqevent(ev)) {
+		if (ev.type != V4L2_EVENT_CTRL)
+			continue;
+		m_ctrlMap[ev.id].flags = ev.u.ctrl.flags;
+		m_ctrlMap[ev.id].minimum = ev.u.ctrl.minimum;
+		m_ctrlMap[ev.id].maximum = ev.u.ctrl.maximum;
+		m_ctrlMap[ev.id].step = ev.u.ctrl.step;
+		m_ctrlMap[ev.id].default_value = ev.u.ctrl.default_value;
+		m_widgetMap[ev.id]->setDisabled(m_ctrlMap[ev.id].flags & CTRL_FLAG_DISABLED);
+		switch (m_ctrlMap[ev.id].type) {
+		case V4L2_CTRL_TYPE_INTEGER:
+		case V4L2_CTRL_TYPE_INTEGER_MENU:
+		case V4L2_CTRL_TYPE_MENU:
+		case V4L2_CTRL_TYPE_BOOLEAN:
+		case V4L2_CTRL_TYPE_BITMASK:
+			setVal(ev.id, ev.u.ctrl.value);
+			break;
+		case V4L2_CTRL_TYPE_INTEGER64:
+			setVal64(ev.id, ev.u.ctrl.value64);
+			break;
+		default:
+			break;
+		}
+		if (m_ctrlMap[ev.id].type != V4L2_CTRL_TYPE_STRING)
+			continue;
+		queryctrl(m_ctrlMap[ev.id]);
+
+		struct v4l2_ext_control c;
+		struct v4l2_ext_controls ctrls;
+
+		c.id = ev.id;
+		c.size = m_ctrlMap[ev.id].maximum + 1;
+		c.string = (char *)malloc(c.size);
+		memset(&ctrls, 0, sizeof(ctrls));
+		ctrls.count = 1;
+		ctrls.ctrl_class = 0;
+		ctrls.controls = &c;
+		if (!ioctl(VIDIOC_G_EXT_CTRLS, &ctrls))
+			setString(ev.id, c.string);
+		free(c.string);
+	}
+}
+
 void ApplicationWindow::capVbiFrame()
 {
 	__u32 buftype = m_genTab->bufType();
@@ -305,53 +352,6 @@ void ApplicationWindow::capVbiFrame()
 		refresh();
 }
 
-void ApplicationWindow::ctrlEvent()
-{
-	v4l2_event ev;
-
-	while (dqevent(ev)) {
-		if (ev.type != V4L2_EVENT_CTRL)
-			continue;
-		m_ctrlMap[ev.id].flags = ev.u.ctrl.flags;
-		m_ctrlMap[ev.id].minimum = ev.u.ctrl.minimum;
-		m_ctrlMap[ev.id].maximum = ev.u.ctrl.maximum;
-		m_ctrlMap[ev.id].step = ev.u.ctrl.step;
-		m_ctrlMap[ev.id].default_value = ev.u.ctrl.default_value;
-		m_widgetMap[ev.id]->setDisabled(m_ctrlMap[ev.id].flags & CTRL_FLAG_DISABLED);
-		switch (m_ctrlMap[ev.id].type) {
-		case V4L2_CTRL_TYPE_INTEGER:
-		case V4L2_CTRL_TYPE_INTEGER_MENU:
-		case V4L2_CTRL_TYPE_MENU:
-		case V4L2_CTRL_TYPE_BOOLEAN:
-		case V4L2_CTRL_TYPE_BITMASK:
-			setVal(ev.id, ev.u.ctrl.value);
-			break;
-		case V4L2_CTRL_TYPE_INTEGER64:
-			setVal64(ev.id, ev.u.ctrl.value64);
-			break;
-		default:
-			break;
-		}
-		if (m_ctrlMap[ev.id].type != V4L2_CTRL_TYPE_STRING)
-			continue;
-		queryctrl(m_ctrlMap[ev.id]);
-
-		struct v4l2_ext_control c;
-		struct v4l2_ext_controls ctrls;
-
-		c.id = ev.id;
-		c.size = m_ctrlMap[ev.id].maximum + 1;
-		c.string = (char *)malloc(c.size);
-		memset(&ctrls, 0, sizeof(ctrls));
-		ctrls.count = 1;
-		ctrls.ctrl_class = 0;
-		ctrls.controls = &c;
-		if (!ioctl(VIDIOC_G_EXT_CTRLS, &ctrls))
-			setString(ev.id, c.string);
-		free(c.string);
-	}
-}
-
 void ApplicationWindow::capFrame()
 {
 	__u32 buftype = m_genTab->bufType();
-- 
1.8.3.2

