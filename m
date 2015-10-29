Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34908 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbbJ2KKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 06:10:46 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 6/6] Docbook: media: Document changes on struct v4l2_ext_controls
Date: Thu, 29 Oct 2015 11:10:32 +0100
Message-Id: <1446113432-27390-7-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vidioc-g-ext-ctrls can now be used to get the default value of the
controls.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           | 10 ++++++++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 22 ++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 7e61643358de..42e626d6c936 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -152,6 +152,16 @@ structs, ioctls) must be noted in more detail in the history chapter
 (compat.xml), along with the possible impact on existing drivers and
 applications. -->
       <revision>
+	<revnumber>4.5</revnumber>
+	<date>2015-10-29</date>
+	<authorinitials>rr</authorinitials>
+	<revremark>Extend vidioc-g-ext-ctrls;. Replace ctrl_class with a new
+union with ctrl_class and which. Which is used to select the current value of
+the control or the default value.
+	</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>4.4</revnumber>
 	<date>2015-05-26</date>
 	<authorinitials>ap</authorinitials>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 47f9fee91442..eb82f7e7d06b 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -223,7 +223,12 @@ Valid if <constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant> is set for this control
       <tgroup cols="3">
 	&cs-str;
 	<tbody valign="top">
+	 <row>
+	    <entry>union</entry>
+	    <entry>(anonymous)</entry>
+	  </row>
 	  <row>
+	    <entry></entry>
 	    <entry>__u32</entry>
 	    <entry><structfield>ctrl_class</structfield></entry>
 	    <entry>The control class to which all controls belong, see
@@ -235,6 +240,23 @@ with a <structfield>count</structfield> of 0. If that succeeds, then the driver
 supports this feature.</entry>
 	  </row>
 	  <row>
+	    <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>which</structfield></entry>
+	    <entry><para>Which value of the control to get/set/try. <constant>V4L2_CTRL_WHICH_CUR_VAL</constant>
+will return the current value of the control and <constant>V4L2_CTRL_WHICH_DEF_VAL</constant> will
+return the default value of the control. Please note that you can only get the default value of the
+control, you cannot set or try it.</para>
+<para>For backwards compatibility you can also use a control class here (see
+<xref linkend="ctrl-class" />). In that case all controls have to belong to that
+control class. This usage is deprecated, instead just use <constant>V4L2_CTRL_WHICH_CUR_VAL</constant>.
+There are some very old drivers that do not yet support <constant>V4L2_CTRL_WHICH_CUR_VAL</constant>
+and that require a control class here. You can test for such drivers by setting ctrl_class to
+<constant>V4L2_CTRL_WHICH_CUR_VAL</constant> and calling VIDIOC_TRY_EXT_CTRLS with a count of 0.
+If that fails, then the driver does not support <constant>V4L2_CTRL_WHICH_CUR_VAL</constant>.</para>
+</entry>
+	  </row>
+	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>count</structfield></entry>
 	    <entry>The number of controls in the controls array. May
-- 
2.6.1

