Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1995 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaAGNHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:07:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/6] DocBook media: update four more sections
Date: Tue,  7 Jan 2014 14:06:55 +0100
Message-Id: <1389100017-42855-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
References: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Updates sections "Querying Capabilities", "Application Priority",
"Video Inputs and Outputs" and "Audio Inputs and Outputs".

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml | 89 ++++++++++++------------------
 1 file changed, 35 insertions(+), 54 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index da08df9..f1e4307 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -186,15 +186,15 @@ methods</link> supported by the device.</para>
 
     <para>Starting with kernel version 3.1, VIDIOC-QUERYCAP will return the
 V4L2 API version used by the driver, with generally matches the Kernel version.
-There's no need of using &VIDIOC-QUERYCAP; to check if an specific ioctl is
-supported, the V4L2 core now returns ENOIOCTLCMD if a driver doesn't provide
+There's no need of using &VIDIOC-QUERYCAP; to check if a specific ioctl is
+supported, the V4L2 core now returns ENOTTY if a driver doesn't provide
 support for an ioctl.</para>
 
     <para>Other features can be queried
 by calling the respective ioctl, for example &VIDIOC-ENUMINPUT;
 to learn about the number, types and names of video connectors on the
 device. Although abstraction is a major objective of this API, the
-ioctl also allows driver specific applications to reliable identify
+&VIDIOC-QUERYCAP; ioctl also allows driver specific applications to reliably identify
 the driver.</para>
 
     <para>All V4L2 drivers must support
@@ -224,9 +224,7 @@ Applications requiring a different priority will usually call
 the &VIDIOC-QUERYCAP; ioctl.</para>
 
     <para>Ioctls changing driver properties, such as &VIDIOC-S-INPUT;,
-return an &EBUSY; after another application obtained higher priority.
-An event mechanism to notify applications about asynchronous property
-changes has been proposed but not added yet.</para>
+return an &EBUSY; after another application obtained higher priority.</para>
   </section>
 
   <section id="video">
@@ -234,9 +232,9 @@ changes has been proposed but not added yet.</para>
 
     <para>Video inputs and outputs are physical connectors of a
 device. These can be for example RF connectors (antenna/cable), CVBS
-a.k.a. Composite Video, S-Video or RGB connectors. Only video and VBI
-capture devices have inputs, output devices have outputs, at least one
-each. Radio devices have no video inputs or outputs.</para>
+a.k.a. Composite Video, S-Video or RGB connectors. Video and VBI
+capture devices have inputs. Video and VBI output devices have outputs,
+at least one each. Radio devices have no video inputs or outputs.</para>
 
     <para>To learn about the number and attributes of the
 available inputs and outputs applications can enumerate them with the
@@ -245,30 +243,13 @@ available inputs and outputs applications can enumerate them with the
 ioctl also contains signal status information applicable when the
 current video input is queried.</para>
 
-    <para>The &VIDIOC-G-INPUT; and &VIDIOC-G-OUTPUT; ioctl return the
+    <para>The &VIDIOC-G-INPUT; and &VIDIOC-G-OUTPUT; ioctls return the
 index of the current video input or output. To select a different
 input or output applications call the &VIDIOC-S-INPUT; and
-&VIDIOC-S-OUTPUT; ioctl. Drivers must implement all the input ioctls
+&VIDIOC-S-OUTPUT; ioctls. Drivers must implement all the input ioctls
 when the device has one or more inputs, all the output ioctls when the
 device has one or more outputs.</para>
 
-    <!--
-    <figure id=io-tree>
-      <title>Input and output enumeration is the root of most device properties.</title>
-      <mediaobject>
-	<imageobject>
-	  <imagedata fileref="links.pdf" format="ps" />
-	</imageobject>
-	<imageobject>
-	  <imagedata fileref="links.gif" format="gif" />
-	</imageobject>
-	<textobject>
-	  <phrase>Links between various device property structures.</phrase>
-	</textobject>
-      </mediaobject>
-    </figure>
-    -->
-
     <example>
       <title>Information about the current video input</title>
 
@@ -276,20 +257,20 @@ device has one or more outputs.</para>
 &v4l2-input; input;
 int index;
 
-if (-1 == ioctl (fd, &VIDIOC-G-INPUT;, &amp;index)) {
-	perror ("VIDIOC_G_INPUT");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-G-INPUT;, &amp;index)) {
+	perror("VIDIOC_G_INPUT");
+	exit(EXIT_FAILURE);
 }
 
-memset (&amp;input, 0, sizeof (input));
+memset(&amp;input, 0, sizeof(input));
 input.index = index;
 
-if (-1 == ioctl (fd, &VIDIOC-ENUMINPUT;, &amp;input)) {
-	perror ("VIDIOC_ENUMINPUT");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-ENUMINPUT;, &amp;input)) {
+	perror("VIDIOC_ENUMINPUT");
+	exit(EXIT_FAILURE);
 }
 
-printf ("Current input: %s\n", input.name);
+printf("Current input: %s\n", input.name);
       </programlisting>
     </example>
 
@@ -301,9 +282,9 @@ int index;
 
 index = 0;
 
-if (-1 == ioctl (fd, &VIDIOC-S-INPUT;, &amp;index)) {
-	perror ("VIDIOC_S_INPUT");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-S-INPUT;, &amp;index)) {
+	perror("VIDIOC_S_INPUT");
+	exit(EXIT_FAILURE);
 }
       </programlisting>
     </example>
@@ -343,7 +324,7 @@ available inputs and outputs applications can enumerate them with the
 also contains signal status information applicable when the current
 audio input is queried.</para>
 
-    <para>The &VIDIOC-G-AUDIO; and &VIDIOC-G-AUDOUT; ioctl report
+    <para>The &VIDIOC-G-AUDIO; and &VIDIOC-G-AUDOUT; ioctls report
 the current audio input and output, respectively. Note that, unlike
 &VIDIOC-G-INPUT; and &VIDIOC-G-OUTPUT; these ioctls return a structure
 as <constant>VIDIOC_ENUMAUDIO</constant> and
@@ -354,11 +335,11 @@ applications call the &VIDIOC-S-AUDIO; ioctl. To select an audio
 output (which presently has no changeable properties) applications
 call the &VIDIOC-S-AUDOUT; ioctl.</para>
 
-    <para>Drivers must implement all input ioctls when the device
-has one or more inputs, all output ioctls when the device has one
-or more outputs. When the device has any audio inputs or outputs the
-driver must set the <constant>V4L2_CAP_AUDIO</constant> flag in the
-&v4l2-capability; returned by the &VIDIOC-QUERYCAP; ioctl.</para>
+    <para>Drivers must implement all audio input ioctls when the device
+has multiple selectable audio inputs, all audio output ioctls when the
+device has multiple selectable audio outputs. When the device has any
+audio inputs or outputs the driver must set the <constant>V4L2_CAP_AUDIO</constant>
+flag in the &v4l2-capability; returned by the &VIDIOC-QUERYCAP; ioctl.</para>
 
     <example>
       <title>Information about the current audio input</title>
@@ -366,14 +347,14 @@ driver must set the <constant>V4L2_CAP_AUDIO</constant> flag in the
       <programlisting>
 &v4l2-audio; audio;
 
-memset (&amp;audio, 0, sizeof (audio));
+memset(&amp;audio, 0, sizeof(audio));
 
-if (-1 == ioctl (fd, &VIDIOC-G-AUDIO;, &amp;audio)) {
-	perror ("VIDIOC_G_AUDIO");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-G-AUDIO;, &amp;audio)) {
+	perror("VIDIOC_G_AUDIO");
+	exit(EXIT_FAILURE);
 }
 
-printf ("Current input: %s\n", audio.name);
+printf("Current input: %s\n", audio.name);
       </programlisting>
     </example>
 
@@ -383,13 +364,13 @@ printf ("Current input: %s\n", audio.name);
       <programlisting>
 &v4l2-audio; audio;
 
-memset (&amp;audio, 0, sizeof (audio)); /* clear audio.mode, audio.reserved */
+memset(&amp;audio, 0, sizeof(audio)); /* clear audio.mode, audio.reserved */
 
 audio.index = 0;
 
-if (-1 == ioctl (fd, &VIDIOC-S-AUDIO;, &amp;audio)) {
-	perror ("VIDIOC_S_AUDIO");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-S-AUDIO;, &amp;audio)) {
+	perror("VIDIOC_S_AUDIO");
+	exit(EXIT_FAILURE);
 }
       </programlisting>
     </example>
-- 
1.8.5.2

