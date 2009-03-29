Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:16407
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbZC2WZe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 18:25:34 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 3/4] Document the orientation flags in ENUMINPUT
Date: Sun, 29 Mar 2009 23:25:16 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>
References: <200903292309.31267.linux@baker-net.org.uk> <200903292317.10249.linux@baker-net.org.uk> <200903292322.08660.linux@baker-net.org.uk>
In-Reply-To: <200903292322.08660.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903292325.16499.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for the flags that have been added to VIDIOC_ENUMINPUT
to specify the sensor orientation.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>

---
diff -r d8d701594f71 v4l2-spec/vidioc-enuminput.sgml
--- a/v4l2-spec/vidioc-enuminput.sgml	Sun Mar 29 08:45:36 2009 +0200
+++ b/v4l2-spec/vidioc-enuminput.sgml	Sun Mar 29 22:59:44 2009 +0100
@@ -119,7 +119,7 @@
 	    <entry><structfield>status</structfield></entry>
 	    <entry>This field provides status information about the
 input. See <xref linkend="input-status"> for flags.
-<structfield>status</structfield> is only valid when this is the
+With the exception of the sensor orientation bits <structfield>status</structfield> is only valid when this is the
 current input.</entry>
 	  </row>
 	  <row>
@@ -188,6 +188,23 @@
 detect color modulation in the signal.</entry>
 	  </row>
 	  <row>
+	    <entry spanname="hspan">Sensor Orientation</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_IN_ST_HFLIP</constant></entry>
+	    <entry>0x00000010</entry>
+	    <entry>The input is connected to a device that produces a signal
+that is flipped horizontally and does not correct this before passing the
+signal to userspace.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_IN_ST_VFLIP</constant></entry>
+	    <entry>0x00000020</entry>
+	    <entry>The input is connected to a device that produces a signal
+that is flipped vertically and does not correct this before passing the
+signal to userspace. Note that a 180 degree rotation is the same as HFLIP | VFLIP</entry>
+	  </row>
+	  <row>
 	    <entry spanname="hspan">Analog Video</entry>
 	  </row>
 	  <row>

