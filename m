Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3581 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbaFLLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 19/34] DocBook media: fix coding style in the control example code
Date: Thu, 12 Jun 2014 13:52:51 +0200
Message-Id: <363d7bc73eb94f48c2415005f66f38bdb0ab6281.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the proper kernel coding style in these examples.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 81 ++++++++++++++--------------
 1 file changed, 40 insertions(+), 41 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 47198ee..00cf0a7 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -441,61 +441,60 @@ more menu type controls.</para>
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
@@ -508,53 +507,53 @@ for (queryctrl.id = V4L2_CID_PRIVATE_BASE;;
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
@@ -675,12 +674,12 @@ control class is found:</para>
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
 
-- 
2.0.0.rc0

