Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2614 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaATMqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 07:46:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 20/21] DocBook media: update control section.
Date: Mon, 20 Jan 2014 13:46:13 +0100
Message-Id: <1390221974-28194-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the support for complex types in controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 185 +++++++++++++++++----------
 1 file changed, 118 insertions(+), 67 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a5a3188..85d78d4 100644
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
@@ -434,127 +444,152 @@ Drivers must implement <constant>VIDIOC_QUERYCTRL</constant>,
 controls, <constant>VIDIOC_QUERYMENU</constant> when it has one or
 more menu type controls.</para>
 
-    <example>
-      <title>Enumerating all controls</title>
+    <example id="enum_all_controls">
+      <title>Enumerating all user controls</title>
 
       <programlisting>
 &v4l2-queryctrl; queryctrl;
 &v4l2-querymenu; querymenu;
 
-static void
-enumerate_menu (void)
+static void enumerate_menu(void)
 {
-	printf ("  Menu items:\n");
+	printf("  Menu items:\n");
 
-	memset (&amp;querymenu, 0, sizeof (querymenu));
+	memset(&amp;querymenu, 0, sizeof(querymenu));
 	querymenu.id = queryctrl.id;
 
 	for (querymenu.index = queryctrl.minimum;
 	     querymenu.index &lt;= queryctrl.maximum;
-	      querymenu.index++) {
-		if (0 == ioctl (fd, &VIDIOC-QUERYMENU;, &amp;querymenu)) {
-			printf ("  %s\n", querymenu.name);
+	     querymenu.index++) {
+		if (0 == ioctl(fd, &VIDIOC-QUERYMENU;, &amp;querymenu)) {
+			printf("  %s\n", querymenu.name);
 		}
 	}
 }
 
-memset (&amp;queryctrl, 0, sizeof (queryctrl));
+memset(&amp;queryctrl, 0, sizeof(queryctrl));
 
 for (queryctrl.id = V4L2_CID_BASE;
      queryctrl.id &lt; V4L2_CID_LASTP1;
      queryctrl.id++) {
-	if (0 == ioctl (fd, &VIDIOC-QUERYCTRL;, &amp;queryctrl)) {
+	if (0 == ioctl(fd, &VIDIOC-QUERYCTRL;, &amp;queryctrl)) {
 		if (queryctrl.flags &amp; V4L2_CTRL_FLAG_DISABLED)
 			continue;
 
-		printf ("Control %s\n", queryctrl.name);
+		printf("Control %s\n", queryctrl.name);
 
 		if (queryctrl.type == V4L2_CTRL_TYPE_MENU)
-			enumerate_menu ();
+			enumerate_menu();
 	} else {
 		if (errno == EINVAL)
 			continue;
 
-		perror ("VIDIOC_QUERYCTRL");
-		exit (EXIT_FAILURE);
+		perror("VIDIOC_QUERYCTRL");
+		exit(EXIT_FAILURE);
 	}
 }
 
 for (queryctrl.id = V4L2_CID_PRIVATE_BASE;;
      queryctrl.id++) {
-	if (0 == ioctl (fd, &VIDIOC-QUERYCTRL;, &amp;queryctrl)) {
+	if (0 == ioctl(fd, &VIDIOC-QUERYCTRL;, &amp;queryctrl)) {
 		if (queryctrl.flags &amp; V4L2_CTRL_FLAG_DISABLED)
 			continue;
 
-		printf ("Control %s\n", queryctrl.name);
+		printf("Control %s\n", queryctrl.name);
 
 		if (queryctrl.type == V4L2_CTRL_TYPE_MENU)
-			enumerate_menu ();
+			enumerate_menu();
 	} else {
 		if (errno == EINVAL)
 			break;
 
-		perror ("VIDIOC_QUERYCTRL");
-		exit (EXIT_FAILURE);
+		perror("VIDIOC_QUERYCTRL");
+		exit(EXIT_FAILURE);
 	}
 }
 </programlisting>
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
 &v4l2-queryctrl; queryctrl;
 &v4l2-control; control;
 
-memset (&amp;queryctrl, 0, sizeof (queryctrl));
+memset(&amp;queryctrl, 0, sizeof(queryctrl));
 queryctrl.id = V4L2_CID_BRIGHTNESS;
 
-if (-1 == ioctl (fd, &VIDIOC-QUERYCTRL;, &amp;queryctrl)) {
+if (-1 == ioctl(fd, &VIDIOC-QUERYCTRL;, &amp;queryctrl)) {
 	if (errno != EINVAL) {
-		perror ("VIDIOC_QUERYCTRL");
-		exit (EXIT_FAILURE);
+		perror("VIDIOC_QUERYCTRL");
+		exit(EXIT_FAILURE);
 	} else {
-		printf ("V4L2_CID_BRIGHTNESS is not supported\n");
+		printf("V4L2_CID_BRIGHTNESS is not supported\n");
 	}
 } else if (queryctrl.flags &amp; V4L2_CTRL_FLAG_DISABLED) {
-	printf ("V4L2_CID_BRIGHTNESS is not supported\n");
+	printf("V4L2_CID_BRIGHTNESS is not supported\n");
 } else {
-	memset (&amp;control, 0, sizeof (control));
+	memset(&amp;control, 0, sizeof (control));
 	control.id = V4L2_CID_BRIGHTNESS;
 	control.value = queryctrl.default_value;
 
-	if (-1 == ioctl (fd, &VIDIOC-S-CTRL;, &amp;control)) {
-		perror ("VIDIOC_S_CTRL");
-		exit (EXIT_FAILURE);
+	if (-1 == ioctl(fd, &VIDIOC-S-CTRL;, &amp;control)) {
+		perror("VIDIOC_S_CTRL");
+		exit(EXIT_FAILURE);
 	}
 }
 
-memset (&amp;control, 0, sizeof (control));
+memset(&amp;control, 0, sizeof(control));
 control.id = V4L2_CID_CONTRAST;
 
-if (0 == ioctl (fd, &VIDIOC-G-CTRL;, &amp;control)) {
+if (0 == ioctl(fd, &VIDIOC-G-CTRL;, &amp;control)) {
 	control.value += 1;
 
 	/* The driver may clamp the value or return ERANGE, ignored here */
 
-	if (-1 == ioctl (fd, &VIDIOC-S-CTRL;, &amp;control)
+	if (-1 == ioctl(fd, &VIDIOC-S-CTRL;, &amp;control)
 	    &amp;&amp; errno != ERANGE) {
-		perror ("VIDIOC_S_CTRL");
-		exit (EXIT_FAILURE);
+		perror("VIDIOC_S_CTRL");
+		exit(EXIT_FAILURE);
 	}
 /* Ignore if V4L2_CID_CONTRAST is unsupported */
 } else if (errno != EINVAL) {
-	perror ("VIDIOC_G_CTRL");
-	exit (EXIT_FAILURE);
+	perror("VIDIOC_G_CTRL");
+	exit(EXIT_FAILURE);
 }
 
 control.id = V4L2_CID_AUDIO_MUTE;
-control.value = TRUE; /* silence */
+control.value = 1; /* silence */
 
 /* Errors ignored */
-ioctl (fd, VIDIOC_S_CTRL, &amp;control);
+ioctl(fd, VIDIOC_S_CTRL, &amp;control);
 </programlisting>
     </example>
   </section>
@@ -625,16 +660,32 @@ supported.</para>
 &v4l2-control;, except for the fact that it also allows for 64-bit
 values and pointers to be passed.</para>
 
+      <para>Since the &v4l2-ext-control; supports pointers it is now
+also possible to have controls with complex types such as arrays/matrices
+and/or structures. All such complex controls will have the
+<constant>V4L2_CTRL_FLAG_HIDDEN</constant> set since such controls cannot
+be displayed in control panel applications. Nor can they be used in the
+user class (for backwards compatibility reasons), and you need to specify
+the <constant>V4L2_CTRL_FLAG_NEXT_HIDDEN</constant> when enumerating controls
+to actually be able to see such hidden controls. In other words, these
+controls with complex types should only be used programmatically.</para>
+
+      <para>Since such complex controls need to expose more information
+about themselves than is possible with &VIDIOC-QUERYCTRL; the
+&VIDIOC-QUERY-EXT-CTRL; ioctl was added. In particular, this ioctl gives
+the size of the matrix if this control consists of more than
+one element.</para>
+
       <para>It is important to realize that due to the flexibility of
 controls it is necessary to check whether the control you want to set
 actually is supported in the driver and what the valid range of values
-is. So use the &VIDIOC-QUERYCTRL; and &VIDIOC-QUERYMENU; ioctls to
-check this. Also note that it is possible that some of the menu
-indices in a control of type <constant>V4L2_CTRL_TYPE_MENU</constant>
-may not be supported (<constant>VIDIOC_QUERYMENU</constant> will
-return an error). A good example is the list of supported MPEG audio
-bitrates. Some drivers only support one or two bitrates, others
-support a wider range.</para>
+is. So use the &VIDIOC-QUERYCTRL; (or &VIDIOC-QUERY-EXT-CTRL;) and
+&VIDIOC-QUERYMENU; ioctls to check this. Also note that it is possible
+that some of the menu indices in a control of type
+<constant>V4L2_CTRL_TYPE_MENU</constant> may not be supported
+(<constant>VIDIOC_QUERYMENU</constant> will return an error). A good
+example is the list of supported MPEG audio bitrates. Some drivers only
+support one or two bitrates, others support a wider range.</para>
 
       <para>
 	All controls use machine endianness.
@@ -675,12 +726,12 @@ control class is found:</para>
       <informalexample>
 	<programlisting>
 qctrl.id = V4L2_CTRL_CLASS_MPEG | V4L2_CTRL_FLAG_NEXT_CTRL;
-while (0 == ioctl (fd, &VIDIOC-QUERYCTRL;, &amp;qctrl)) {
-	if (V4L2_CTRL_ID2CLASS (qctrl.id) != V4L2_CTRL_CLASS_MPEG)
+while (0 == ioctl(fd, &VIDIOC-QUERYCTRL;, &amp;qctrl)) {
+	if (V4L2_CTRL_ID2CLASS(qctrl.id) != V4L2_CTRL_CLASS_MPEG)
 		break;
 		/* ... */
-		qctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
-	}
+	qctrl.id |= V4L2_CTRL_FLAG_NEXT_CTRL;
+}
 </programlisting>
       </informalexample>
 
@@ -700,7 +751,7 @@ ID based on a control ID.</para>
 <constant>VIDIOC_QUERYCTRL</constant> will fail when used in
 combination with <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant>. In
 that case the old method of enumerating control should be used (see
-1.8). But if it is supported, then it is guaranteed to enumerate over
+<xref linkend="enum_all_controls" />). But if it is supported, then it is guaranteed to enumerate over
 all controls, including driver-private controls.</para>
     </section>
 
-- 
1.8.5.2

