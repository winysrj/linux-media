Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1854 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbaFLLyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 20/34] DocBook media: improve control section.
Date: Thu, 12 Jun 2014 13:52:52 +0200
Message-Id: <d6eaed1379937affcbdf0366c9a3d4ddb065d5f7.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Improve the control section:

- Clarify the handling of private controls
- Explain the V4L2_CTRL_FLAG_INACTIVE flag
- Remove obsolete text regarding missing control event (we have them
  today) and the incorrect V4L2_CTRL_FLAG_DISABLED reference.
- Add a code example on how to enumerate over user controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 74 +++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 19 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 00cf0a7..73bae13 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -13,6 +13,19 @@ correctly with any device.</para>
     <para>All controls are accessed using an ID value. V4L2 defines
 several IDs for specific purposes. Drivers can also implement their
 own custom controls using <constant>V4L2_CID_PRIVATE_BASE</constant>
+<footnote><para>The use of <constant>V4L2_CID_PRIVATE_BASE</constant>
+is problematic because different drivers may use the same
+<constant>V4L2_CID_PRIVATE_BASE</constant> ID for different controls.
+This makes it hard to programatically set such controls since the meaning
+of the control with that ID is driver dependent. In order to resolve this
+drivers use unique IDs and the <constant>V4L2_CID_PRIVATE_BASE</constant>
+IDs are mapped to those unique IDs by the kernel. Consider these
+<constant>V4L2_CID_PRIVATE_BASE</constant> IDs as aliases to the real
+IDs.</para>
+<para>Many applications today still use the <constant>V4L2_CID_PRIVATE_BASE</constant>
+IDs instead of using &VIDIOC-QUERYCTRL; with the <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant>
+flag to enumerate all IDs, so support for <constant>V4L2_CID_PRIVATE_BASE</constant>
+is still around.</para></footnote>
 and higher values. The pre-defined control IDs have the prefix
 <constant>V4L2_CID_</constant>, and are listed in <xref
 linkend="control-id" />. The ID is used when querying the attributes of
@@ -31,25 +44,22 @@ the current video input or output, tuner or modulator, or audio input
 or output. Different in the sense of other bounds, another default and
 current value, step size or other menu items. A control with a certain
 <emphasis>custom</emphasis> ID can also change name and
-type.<footnote>
-	<para>It will be more convenient for applications if drivers
-make use of the <constant>V4L2_CTRL_FLAG_DISABLED</constant> flag, but
-that was never required.</para>
-      </footnote> Control values are stored globally, they do not
+type.</para>
+
+    <para>If a control is not applicable to the current configuration
+of the device (for example, it doesn't apply to the current video input)
+drivers set the <constant>V4L2_CTRL_FLAG_INACTIVE</constant> flag.</para>
+
+    <para>Control values are stored globally, they do not
 change when switching except to stay within the reported bounds. They
 also do not change &eg; when the device is opened or closed, when the
 tuner radio frequency is changed or generally never without
-application request. Since V4L2 specifies no event mechanism, panel
-applications intended to cooperate with other panel applications (be
-they built into a larger application, as a TV viewer) may need to
-regularly poll control values to update their user
-interface.<footnote>
-	<para>Applications could call an ioctl to request events.
-After another process called &VIDIOC-S-CTRL; or another ioctl changing
-shared properties the &func-select; function would indicate
-readability until any ioctl (querying the properties) is
-called.</para>
-      </footnote></para>
+application request.</para>
+
+    <para>V4L2 specifies an event mechanism to notify applications
+when controls change value (see &VIDIOC-SUBSCRIBE-EVENT;, event
+<constant>V4L2_EVENT_CTRL</constant>), panel applications might want to make
+use of that in order to always reflect the correct control value.</para>
 
     <para>
       All controls use machine endianness.
@@ -434,8 +444,8 @@ Drivers must implement <constant>VIDIOC_QUERYCTRL</constant>,
 controls, <constant>VIDIOC_QUERYMENU</constant> when it has one or
 more menu type controls.</para>
 
-    <example>
-      <title>Enumerating all controls</title>
+    <example id="enum_all_controls">
+      <title>Enumerating all user controls</title>
 
       <programlisting>
 &v4l2-queryctrl; queryctrl;
@@ -501,6 +511,32 @@ for (queryctrl.id = V4L2_CID_PRIVATE_BASE;;
     </example>
 
     <example>
+      <title>Enumerating all user controls (alternative)</title>
+	<programlisting>
+memset(&amp;queryctrl, 0, sizeof(queryctrl));
+
+queryctrl.id = V4L2_CTRL_CLASS_USER | V4L2_CTRL_FLAG_NEXT_CTRL;
+while (0 == ioctl(fd, &VIDIOC-QUERYCTRL;, &amp;queryctrl)) {
+	if (V4L2_CTRL_ID2CLASS(queryctrl.id) != V4L2_CTRL_CLASS_USER)
+		break;
+	if (queryctrl.flags &amp; V4L2_CTRL_FLAG_DISABLED)
+		continue;
+
+	printf("Control %s\n", queryctrl.name);
+
+	if (queryctrl.type == V4L2_CTRL_TYPE_MENU)
+		enumerate_menu();
+
+	queryctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
+}
+if (errno != EINVAL) {
+	perror("VIDIOC_QUERYCTRL");
+	exit(EXIT_FAILURE);
+}
+</programlisting>
+    </example>
+
+    <example>
       <title>Changing controls</title>
 
       <programlisting>
@@ -699,7 +735,7 @@ ID based on a control ID.</para>
 <constant>VIDIOC_QUERYCTRL</constant> will fail when used in
 combination with <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant>. In
 that case the old method of enumerating control should be used (see
-1.8). But if it is supported, then it is guaranteed to enumerate over
+<xref linkend="enum_all_controls" />). But if it is supported, then it is guaranteed to enumerate over
 all controls, including driver-private controls.</para>
     </section>
 
-- 
2.0.0.rc0

