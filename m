Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1535 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaAGNHO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:07:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/6] DocBook media: update three sections
Date: Tue,  7 Jan 2014 14:06:56 +0100
Message-Id: <1389100017-42855-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
References: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Updates for the "Tuners and Modulators", "Video Standards" and
"Digital Video (DV) Timings" sections.

Besides lots of trivial little fixes the main changes are:

- Remove two footnotes from "Video Standards": the first is a discussion
  of alternative methods of setting standards, which is pretty pointless
  since the standards API is effectively frozen anyway, and the second
  points to 'rationale' that makes little or no sense to me.

- Clarify a few things in the "Digital Video (DV) Timings" section.
  It was awkwardly formatted as well: there used to be a list with
  multiple bullets that has been reduced to a single item, so drop the
  list and rewrite that text.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml | 132 ++++++++++++-----------------
 1 file changed, 53 insertions(+), 79 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index f1e4307..48e8e76 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -395,7 +395,7 @@ the tuner.</para>
 video inputs.</para>
 
       <para>To query and change tuner properties applications use the
-&VIDIOC-G-TUNER; and &VIDIOC-S-TUNER; ioctl, respectively. The
+&VIDIOC-G-TUNER; and &VIDIOC-S-TUNER; ioctls, respectively. The
 &v4l2-tuner; returned by <constant>VIDIOC_G_TUNER</constant> also
 contains signal status information applicable when the tuner of the
 current video or radio input is queried. Note that
@@ -460,7 +460,7 @@ standards or variations of standards. Each video input and output may
 support another set of standards. This set is reported by the
 <structfield>std</structfield> field of &v4l2-input; and
 &v4l2-output; returned by the &VIDIOC-ENUMINPUT; and
-&VIDIOC-ENUMOUTPUT; ioctl, respectively.</para>
+&VIDIOC-ENUMOUTPUT; ioctls, respectively.</para>
 
     <para>V4L2 defines one bit for each analog video standard
 currently in use worldwide, and sets aside bits for driver defined
@@ -491,28 +491,10 @@ automatically.</para>
     <para>To query and select the standard used by the current video
 input or output applications call the &VIDIOC-G-STD; and
 &VIDIOC-S-STD; ioctl, respectively. The <emphasis>received</emphasis>
-standard can be sensed with the &VIDIOC-QUERYSTD; ioctl. Note that the parameter of all these ioctls is a pointer to a &v4l2-std-id; type (a standard set), <emphasis>not</emphasis> an index into the standard enumeration.<footnote>
-	<para>An alternative to the current scheme is to use pointers
-to indices as arguments of <constant>VIDIOC_G_STD</constant> and
-<constant>VIDIOC_S_STD</constant>, the &v4l2-input; and
-&v4l2-output; <structfield>std</structfield> field would be a set of
-indices like <structfield>audioset</structfield>.</para>
-	<para>Indices are consistent with the rest of the API
-and identify the standard unambiguously. In the present scheme of
-things an enumerated standard is looked up by &v4l2-std-id;. Now the
-standards supported by the inputs of a device can overlap. Just
-assume the tuner and composite input in the example above both
-exist on a device. An enumeration of "PAL-B/G", "PAL-H/I" suggests
-a choice which does not exist. We cannot merge or omit sets, because
-applications would be unable to find the standards reported by
-<constant>VIDIOC_G_STD</constant>. That leaves separate enumerations
-for each input. Also selecting a standard by &v4l2-std-id; can be
-ambiguous. Advantage of this method is that applications need not
-identify the standard indirectly, after enumerating.</para><para>So in
-summary, the lookup itself is unavoidable. The difference is only
-whether the lookup is necessary to find an enumerated standard or to
-switch to a standard by &v4l2-std-id;.</para>
-      </footnote> Drivers must implement all video standard ioctls
+standard can be sensed with the &VIDIOC-QUERYSTD; ioctl. Note that the
+parameter of all these ioctls is a pointer to a &v4l2-std-id; type
+(a standard set), <emphasis>not</emphasis> an index into the standard
+enumeration. Drivers must implement all video standard ioctls
 when the device has one or more video inputs or outputs.</para>
 
     <para>Special rules apply to devices such as USB cameras where the notion of video
@@ -531,17 +513,10 @@ to zero and the <constant>VIDIOC_G_STD</constant>,
 <constant>VIDIOC_S_STD</constant>,
 <constant>VIDIOC_QUERYSTD</constant> and
 <constant>VIDIOC_ENUMSTD</constant> ioctls shall return the
-&ENOTTY;.<footnote>
-	<para>See <xref linkend="buffer" /> for a rationale.</para>
+&ENOTTY; or the &EINVAL;.</para>
 	<para>Applications can make use of the <xref linkend="input-capabilities" /> and
 <xref linkend="output-capabilities"/> flags to determine whether the video standard ioctls
-are available for the device.</para>
-
-	<para>See <xref linkend="buffer" /> for a rationale. Probably
-even USB cameras follow some well known video standard. It might have
-been better to explicitly indicate elsewhere if a device cannot live
-up to normal expectations, instead of this exception.</para>
-	    </footnote></para>
+can be used with the given input or output.</para>
 
     <example>
       <title>Information about the current video standard</title>
@@ -550,22 +525,22 @@ up to normal expectations, instead of this exception.</para>
 &v4l2-std-id; std_id;
 &v4l2-standard; standard;
 
-if (-1 == ioctl (fd, &VIDIOC-G-STD;, &amp;std_id)) {
+if (-1 == ioctl(fd, &VIDIOC-G-STD;, &amp;std_id)) {
 	/* Note when VIDIOC_ENUMSTD always returns ENOTTY this
 	   is no video device or it falls under the USB exception,
 	   and VIDIOC_G_STD returning ENOTTY is no error. */
 
-	perror ("VIDIOC_G_STD");
-	exit (EXIT_FAILURE);
+	perror("VIDIOC_G_STD");
+	exit(EXIT_FAILURE);
 }
 
-memset (&amp;standard, 0, sizeof (standard));
+memset(&amp;standard, 0, sizeof(standard));
 standard.index = 0;
 
-while (0 == ioctl (fd, &VIDIOC-ENUMSTD;, &amp;standard)) {
+while (0 == ioctl(fd, &VIDIOC-ENUMSTD;, &amp;standard)) {
 	if (standard.id &amp; std_id) {
-	       printf ("Current video standard: %s\n", standard.name);
-	       exit (EXIT_SUCCESS);
+	       printf("Current video standard: %s\n", standard.name);
+	       exit(EXIT_SUCCESS);
 	}
 
 	standard.index++;
@@ -575,8 +550,8 @@ while (0 == ioctl (fd, &VIDIOC-ENUMSTD;, &amp;standard)) {
    empty unless this device falls under the USB exception. */
 
 if (errno == EINVAL || standard.index == 0) {
-	perror ("VIDIOC_ENUMSTD");
-	exit (EXIT_FAILURE);
+	perror("VIDIOC_ENUMSTD");
+	exit(EXIT_FAILURE);
 }
       </programlisting>
     </example>
@@ -589,26 +564,26 @@ input</title>
 &v4l2-input; input;
 &v4l2-standard; standard;
 
-memset (&amp;input, 0, sizeof (input));
+memset(&amp;input, 0, sizeof(input));
 
-if (-1 == ioctl (fd, &VIDIOC-G-INPUT;, &amp;input.index)) {
-	perror ("VIDIOC_G_INPUT");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-G-INPUT;, &amp;input.index)) {
+	perror("VIDIOC_G_INPUT");
+	exit(EXIT_FAILURE);
 }
 
-if (-1 == ioctl (fd, &VIDIOC-ENUMINPUT;, &amp;input)) {
-	perror ("VIDIOC_ENUM_INPUT");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-ENUMINPUT;, &amp;input)) {
+	perror("VIDIOC_ENUM_INPUT");
+	exit(EXIT_FAILURE);
 }
 
-printf ("Current input %s supports:\n", input.name);
+printf("Current input %s supports:\n", input.name);
 
-memset (&amp;standard, 0, sizeof (standard));
+memset(&amp;standard, 0, sizeof(standard));
 standard.index = 0;
 
-while (0 == ioctl (fd, &VIDIOC-ENUMSTD;, &amp;standard)) {
+while (0 == ioctl(fd, &VIDIOC-ENUMSTD;, &amp;standard)) {
 	if (standard.id &amp; input.std)
-		printf ("%s\n", standard.name);
+		printf("%s\n", standard.name);
 
 	standard.index++;
 }
@@ -617,8 +592,8 @@ while (0 == ioctl (fd, &VIDIOC-ENUMSTD;, &amp;standard)) {
    empty unless this device falls under the USB exception. */
 
 if (errno != EINVAL || standard.index == 0) {
-	perror ("VIDIOC_ENUMSTD");
-	exit (EXIT_FAILURE);
+	perror("VIDIOC_ENUMSTD");
+	exit(EXIT_FAILURE);
 }
       </programlisting>
     </example>
@@ -630,21 +605,21 @@ if (errno != EINVAL || standard.index == 0) {
 &v4l2-input; input;
 &v4l2-std-id; std_id;
 
-memset (&amp;input, 0, sizeof (input));
+memset(&amp;input, 0, sizeof(input));
 
-if (-1 == ioctl (fd, &VIDIOC-G-INPUT;, &amp;input.index)) {
-	perror ("VIDIOC_G_INPUT");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-G-INPUT;, &amp;input.index)) {
+	perror("VIDIOC_G_INPUT");
+	exit(EXIT_FAILURE);
 }
 
-if (-1 == ioctl (fd, &VIDIOC-ENUMINPUT;, &amp;input)) {
-	perror ("VIDIOC_ENUM_INPUT");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-ENUMINPUT;, &amp;input)) {
+	perror("VIDIOC_ENUM_INPUT");
+	exit(EXIT_FAILURE);
 }
 
 if (0 == (input.std &amp; V4L2_STD_PAL_BG)) {
-	fprintf (stderr, "Oops. B/G PAL is not supported.\n");
-	exit (EXIT_FAILURE);
+	fprintf(stderr, "Oops. B/G PAL is not supported.\n");
+	exit(EXIT_FAILURE);
 }
 
 /* Note this is also supposed to work when only B
@@ -652,9 +627,9 @@ if (0 == (input.std &amp; V4L2_STD_PAL_BG)) {
 
 std_id = V4L2_STD_PAL_BG;
 
-if (-1 == ioctl (fd, &VIDIOC-S-STD;, &amp;std_id)) {
-	perror ("VIDIOC_S_STD");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-S-STD;, &amp;std_id)) {
+	perror("VIDIOC_S_STD");
+	exit(EXIT_FAILURE);
 }
       </programlisting>
     </example>
@@ -667,26 +642,25 @@ corresponding video timings. Today there are many more different hardware interf
 such as High Definition TV interfaces (HDMI), VGA, DVI connectors etc., that carry
 video signals and there is a need to extend the API to select the video timings
 for these interfaces. Since it is not possible to extend the &v4l2-std-id; due to
-the limited bits available, a new set of IOCTLs was added to set/get video timings at
-the input and output: </para><itemizedlist>
-	<listitem>
-	<para>DV Timings: This will allow applications to define detailed
-video timings for the interface. This includes parameters such as width, height,
-polarities, frontporch, backporch etc. The <filename>linux/v4l2-dv-timings.h</filename>
+the limited bits available, a new set of ioctls was added to set/get video timings at
+the input and output.</para>
+
+	<para>These ioctls deal with the detailed digital video timings that define
+each video format. This includes parameters such as the active video width and height,
+signal polarities, frontporches, backporches, sync widths etc. The <filename>linux/v4l2-dv-timings.h</filename>
 header can be used to get the timings of the formats in the <xref linkend="cea861" /> and
 <xref linkend="vesadmt" /> standards.
 	</para>
-	</listitem>
-	</itemizedlist>
-	<para>To enumerate and query the attributes of the DV timings supported by a device,
+
+	<para>To enumerate and query the attributes of the DV timings supported by a device
 	applications use the &VIDIOC-ENUM-DV-TIMINGS; and &VIDIOC-DV-TIMINGS-CAP; ioctls.
-	To set DV timings for the device, applications use the
+	To set DV timings for the device applications use the
 &VIDIOC-S-DV-TIMINGS; ioctl and to get current DV timings they use the
 &VIDIOC-G-DV-TIMINGS; ioctl. To detect the DV timings as seen by the video receiver applications
 use the &VIDIOC-QUERY-DV-TIMINGS; ioctl.</para>
 	<para>Applications can make use of the <xref linkend="input-capabilities" /> and
-<xref linkend="output-capabilities"/> flags to decide what ioctls are available to set the
-video timings for the device.</para>
+<xref linkend="output-capabilities"/> flags to determine whether the digital video ioctls
+can be used with the given input or output.</para>
   </section>
 
   &sub-controls;
-- 
1.8.5.2

