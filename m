Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57722 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab1LCMh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Dec 2011 07:37:26 -0500
Received: by wgbdr13 with SMTP id dr13so3219891wgb.1
        for <linux-media@vger.kernel.org>; Sat, 03 Dec 2011 04:37:25 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH] Remove unneeded comments from the media API DocBook files
Date: Sat,  3 Dec 2011 13:37:06 +0100
Message-Id: <1322915826-3384-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This removes comment tags intended for emacs configuration from
67 files in the Media API DocBook. Such comments are not really
helpful and violate  the coding style rules.

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 Documentation/DocBook/media/v4l/biblio.xml         |    8 --------
 Documentation/DocBook/media/v4l/common.xml         |    8 --------
 Documentation/DocBook/media/v4l/compat.xml         |   10 +---------
 Documentation/DocBook/media/v4l/controls.xml       |    8 --------
 Documentation/DocBook/media/v4l/dev-capture.xml    |    8 --------
 Documentation/DocBook/media/v4l/dev-codec.xml      |    8 --------
 Documentation/DocBook/media/v4l/dev-effect.xml     |    8 --------
 Documentation/DocBook/media/v4l/dev-event.xml      |    8 --------
 Documentation/DocBook/media/v4l/dev-osd.xml        |    8 --------
 Documentation/DocBook/media/v4l/dev-output.xml     |    8 --------
 Documentation/DocBook/media/v4l/dev-overlay.xml    |    8 --------
 Documentation/DocBook/media/v4l/dev-radio.xml      |    8 --------
 Documentation/DocBook/media/v4l/dev-raw-vbi.xml    |    8 --------
 Documentation/DocBook/media/v4l/dev-rds.xml        |    8 --------
 Documentation/DocBook/media/v4l/dev-sliced-vbi.xml |    9 ---------
 Documentation/DocBook/media/v4l/dev-teletext.xml   |    8 --------
 Documentation/DocBook/media/v4l/driver.xml         |    8 --------
 Documentation/DocBook/media/v4l/func-close.xml     |    8 --------
 Documentation/DocBook/media/v4l/func-ioctl.xml     |    8 --------
 Documentation/DocBook/media/v4l/func-mmap.xml      |    8 --------
 Documentation/DocBook/media/v4l/func-munmap.xml    |    8 --------
 Documentation/DocBook/media/v4l/func-open.xml      |    8 --------
 Documentation/DocBook/media/v4l/func-poll.xml      |    8 --------
 Documentation/DocBook/media/v4l/func-read.xml      |    8 --------
 Documentation/DocBook/media/v4l/func-select.xml    |    8 --------
 Documentation/DocBook/media/v4l/func-write.xml     |    8 --------
 Documentation/DocBook/media/v4l/io.xml             |    8 --------
 Documentation/DocBook/media/v4l/libv4l.xml         |    7 -------
 Documentation/DocBook/media/v4l/pixfmt-grey.xml    |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-m420.xml    |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-nv12.xml    |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml   |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml  |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-nv16.xml    |    8 --------
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |    8 --------
 .../DocBook/media/v4l/pixfmt-packed-yuv.xml        |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml  |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml  |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml  |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-uyvy.xml    |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-vyuy.xml    |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-y16.xml     |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-y41p.xml    |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-yuv410.xml  |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-yuv420.xml  |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-yuyv.xml    |    8 --------
 Documentation/DocBook/media/v4l/pixfmt-yvyu.xml    |    8 --------
 Documentation/DocBook/media/v4l/pixfmt.xml         |    8 --------
 .../DocBook/media/v4l/vidioc-enum-dv-presets.xml   |    8 --------
 .../DocBook/media/v4l/vidioc-enum-fmt.xml          |    8 --------
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    8 --------
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    8 --------
 Documentation/DocBook/media/v4l/vidioc-enumstd.xml |    8 --------
 Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml  |    8 --------
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 -------
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    8 --------
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |    8 --------
 .../DocBook/media/v4l/vidioc-g-priority.xml        |    8 --------
 Documentation/DocBook/media/v4l/vidioc-g-std.xml   |    8 --------
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    8 --------
 .../DocBook/media/v4l/vidioc-querybuf.xml          |    8 --------
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |    8 --------
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    8 --------
 67 files changed, 1 insertions(+), 536 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index afc8a0d..cea6fd3 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -178,11 +178,3 @@ in the frequency range from 87,5 to 108,0 MHz</title>
     </biblioentry>

   </bibliography>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index a86f7a0..9d39198 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -1195,11 +1195,3 @@ separate parameters for input and output devices.</para>
     <para>These ioctls are optional, drivers need not implement
 them. If so, they return the &EINVAL;.</para>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index b68698f..8b44a43 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -1082,7 +1082,7 @@ until the time in the timestamp field has arrived. I would like to
 follow SGI's lead, and adopt a multimedia timestamping system like
 their UST (Unadjusted System Time). See
 http://web.archive.org/web/*/http://reality.sgi.com
-/cpirazzi_engr/lg/time/intro.html.
+/cpirazzi_engr/lg/time/intro.html.
 UST uses timestamps that are 64-bit signed integers
 (not struct timeval's) and given in nanosecond units. The UST clock
 starts at zero when the system is booted and runs continuously and
@@ -2507,11 +2507,3 @@ interfaces and should not be implemented in new drivers.</para>
       </itemizedlist>
     </section>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 3bc5ee8..9e72f07 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3357,11 +3357,3 @@ interface and may change in the future.</para>

     </section>
 </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "common.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-capture.xml b/Documentation/DocBook/media/v4l/dev-capture.xml
index 2237c66..e1c5f94 100644
--- a/Documentation/DocBook/media/v4l/dev-capture.xml
+++ b/Documentation/DocBook/media/v4l/dev-capture.xml
@@ -108,11 +108,3 @@ linkend="mmap">memory mapping</link> or <link
 linkend="userp">user pointer</link>) I/O. See <xref
 linkend="io" /> for details.</para>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-codec.xml b/Documentation/DocBook/media/v4l/dev-codec.xml
index 6e156dc..dca0ecd 100644
--- a/Documentation/DocBook/media/v4l/dev-codec.xml
+++ b/Documentation/DocBook/media/v4l/dev-codec.xml
@@ -16,11 +16,3 @@ Applications send data to be converted to the driver through a
 I/O.</para>

   <para>[to do]</para>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-effect.xml b/Documentation/DocBook/media/v4l/dev-effect.xml
index 9c243be..2350a67 100644
--- a/Documentation/DocBook/media/v4l/dev-effect.xml
+++ b/Documentation/DocBook/media/v4l/dev-effect.xml
@@ -15,11 +15,3 @@ receive the result data either with &func-read; and &func-write;
 functions, or through the streaming I/O mechanism.</para>

   <para>[to do]</para>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-event.xml b/Documentation/DocBook/media/v4l/dev-event.xml
index f14ae3f..19f4bec 100644
--- a/Documentation/DocBook/media/v4l/dev-event.xml
+++ b/Documentation/DocBook/media/v4l/dev-event.xml
@@ -41,11 +41,3 @@ intermediate step leading up to that information. See the documentation for the
 event you want to subscribe to whether this is applicable for that event or not.</para>
 	</listitem>
       </orderedlist></para>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-osd.xml b/Documentation/DocBook/media/v4l/dev-osd.xml
index c9a68a2..479d943 100644
--- a/Documentation/DocBook/media/v4l/dev-osd.xml
+++ b/Documentation/DocBook/media/v4l/dev-osd.xml
@@ -154,11 +154,3 @@ data flow. For more information see <xref linkend="crop" />.</para>
 however the framebuffer interface of the driver may support the
 <constant>FBIOBLANK</constant> ioctl.</para>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-output.xml b/Documentation/DocBook/media/v4l/dev-output.xml
index 919e22c..9130a3d 100644
--- a/Documentation/DocBook/media/v4l/dev-output.xml
+++ b/Documentation/DocBook/media/v4l/dev-output.xml
@@ -104,11 +104,3 @@ linkend="mmap">memory mapping</link> or <link
 linkend="userp">user pointer</link>) I/O. See <xref
 linkend="io" /> for details.</para>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-overlay.xml b/Documentation/DocBook/media/v4l/dev-overlay.xml
index 92513cf..40d1d76 100644
--- a/Documentation/DocBook/media/v4l/dev-overlay.xml
+++ b/Documentation/DocBook/media/v4l/dev-overlay.xml
@@ -369,11 +369,3 @@ reasons. <!-- video4linux-list@redhat.com on 22 Oct 2002 subject
     <para>To start or stop the frame buffer overlay applications call
 the &VIDIOC-OVERLAY; ioctl.</para>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-radio.xml b/Documentation/DocBook/media/v4l/dev-radio.xml
index 73aa90b..3e6ac73 100644
--- a/Documentation/DocBook/media/v4l/dev-radio.xml
+++ b/Documentation/DocBook/media/v4l/dev-radio.xml
@@ -47,11 +47,3 @@ depending on the selected frequency. The &VIDIOC-G-TUNER; or
 &VIDIOC-G-MODULATOR; ioctl
 reports the supported frequency range.</para>
   </section>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
- -->
diff --git a/Documentation/DocBook/media/v4l/dev-raw-vbi.xml b/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
index c5a70bd..b788c72 100644
--- a/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
+++ b/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
@@ -337,11 +337,3 @@ an &EBUSY; if the required hardware resources are temporarily
 unavailable, for example the device is already in use by another
 process.</para>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/dev-rds.xml b/Documentation/DocBook/media/v4l/dev-rds.xml
index 7644b2e..38883a4 100644
--- a/Documentation/DocBook/media/v4l/dev-rds.xml
+++ b/Documentation/DocBook/media/v4l/dev-rds.xml
@@ -194,11 +194,3 @@ as follows:</para>
       </tgroup>
     </table>
   </section>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
- -->
diff --git a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
index 69e789f..548f8ea 100644
--- a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
+++ b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
@@ -697,12 +697,3 @@ Sliced VBI services</link> for a description of the line payload.</entry>

   </section>
   </section>
-
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
- -->
diff --git a/Documentation/DocBook/media/v4l/dev-teletext.xml b/Documentation/DocBook/media/v4l/dev-teletext.xml
index 414b1cf..bd21c64 100644
--- a/Documentation/DocBook/media/v4l/dev-teletext.xml
+++ b/Documentation/DocBook/media/v4l/dev-teletext.xml
@@ -27,11 +27,3 @@ kernel 2.6.37.</para>

   <para>Modern devices all use the <link linkend="raw-vbi">raw</link> or
 <link linkend="sliced">sliced</link> VBI API.</para>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/driver.xml b/Documentation/DocBook/media/v4l/driver.xml
index 1f7eea5..eacafe3 100644
--- a/Documentation/DocBook/media/v4l/driver.xml
+++ b/Documentation/DocBook/media/v4l/driver.xml
@@ -198,11 +198,3 @@ devices with the videodev module.</para>
     <para>to do</para>
   </section>
 -->
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-close.xml b/Documentation/DocBook/media/v4l/func-close.xml
index dfb41cb..232920d 100644
--- a/Documentation/DocBook/media/v4l/func-close.xml
+++ b/Documentation/DocBook/media/v4l/func-close.xml
@@ -60,11 +60,3 @@ descriptor.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-ioctl.xml b/Documentation/DocBook/media/v4l/func-ioctl.xml
index 2de64be..4394184 100644
--- a/Documentation/DocBook/media/v4l/func-ioctl.xml
+++ b/Documentation/DocBook/media/v4l/func-ioctl.xml
@@ -69,11 +69,3 @@ their respective function and parameters are specified in <xref
     the parameter remains unmodified.</para>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-mmap.xml b/Documentation/DocBook/media/v4l/func-mmap.xml
index 786732b..f31ad71 100644
--- a/Documentation/DocBook/media/v4l/func-mmap.xml
+++ b/Documentation/DocBook/media/v4l/func-mmap.xml
@@ -181,11 +181,3 @@ complete the request.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-munmap.xml b/Documentation/DocBook/media/v4l/func-munmap.xml
index e2c4190..860d49c 100644
--- a/Documentation/DocBook/media/v4l/func-munmap.xml
+++ b/Documentation/DocBook/media/v4l/func-munmap.xml
@@ -74,11 +74,3 @@ mapped yet.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-open.xml b/Documentation/DocBook/media/v4l/func-open.xml
index 7595d07..cf64e20 100644
--- a/Documentation/DocBook/media/v4l/func-open.xml
+++ b/Documentation/DocBook/media/v4l/func-open.xml
@@ -111,11 +111,3 @@ system has been reached.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-poll.xml b/Documentation/DocBook/media/v4l/func-poll.xml
index ec3c718..85cad8b 100644
--- a/Documentation/DocBook/media/v4l/func-poll.xml
+++ b/Documentation/DocBook/media/v4l/func-poll.xml
@@ -117,11 +117,3 @@ than <constant>OPEN_MAX</constant>.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-read.xml b/Documentation/DocBook/media/v4l/func-read.xml
index a5089bf..e218bbf 100644
--- a/Documentation/DocBook/media/v4l/func-read.xml
+++ b/Documentation/DocBook/media/v4l/func-read.xml
@@ -179,11 +179,3 @@ type of device.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-select.xml b/Documentation/DocBook/media/v4l/func-select.xml
index b671362..e12a60d 100644
--- a/Documentation/DocBook/media/v4l/func-select.xml
+++ b/Documentation/DocBook/media/v4l/func-select.xml
@@ -128,11 +128,3 @@ zero or greater than <constant>FD_SETSIZE</constant>.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/func-write.xml b/Documentation/DocBook/media/v4l/func-write.xml
index 2c09c09..5752078 100644
--- a/Documentation/DocBook/media/v4l/func-write.xml
+++ b/Documentation/DocBook/media/v4l/func-write.xml
@@ -126,11 +126,3 @@ type of device.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 3f47df1..b815929 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1282,11 +1282,3 @@ line, top field first. The bottom field is transmitted first.</entry>
 	</mediaobject>
     </figure>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/libv4l.xml b/Documentation/DocBook/media/v4l/libv4l.xml
index 3cb10ec..d3b71e2 100644
--- a/Documentation/DocBook/media/v4l/libv4l.xml
+++ b/Documentation/DocBook/media/v4l/libv4l.xml
@@ -158,10 +158,3 @@ still don't use libv4l.</para>
 	</section>

 </section>
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-grey.xml b/Documentation/DocBook/media/v4l/pixfmt-grey.xml
index 3b72bc6..bee970d 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-grey.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-grey.xml
@@ -60,11 +60,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-m420.xml b/Documentation/DocBook/media/v4l/pixfmt-m420.xml
index ce4bc01..aadae92 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-m420.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-m420.xml
@@ -137,11 +137,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
index 873f670..84dd4fd 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
@@ -141,11 +141,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
index c9e166d..3fd3ce5 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
@@ -144,11 +144,3 @@ CbCr plane has as many pad bytes after its rows.</para>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml
index 7a2855a..2f82b1d 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml
@@ -64,11 +64,3 @@ layout of macroblocks</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv16.xml b/Documentation/DocBook/media/v4l/pixfmt-nv16.xml
index 2609403..8ae1f8a 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv16.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv16.xml
@@ -164,11 +164,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 4db272b..ba56536 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -930,11 +930,3 @@ See &v4l-dvb; for access instructions.</para>

   </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml
index 3cab5d0..33fa5a4 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml
@@ -234,11 +234,3 @@ linkend="osd">Video Output Overlay</link>.</para>

   </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
index 519a9ef..6494b05 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
@@ -81,11 +81,3 @@ pixel image</title>
     </example>
   </refsect1>
 </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml
index 5fe84ec..5eaf2b4 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml
@@ -65,11 +65,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml b/Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml
index d67a472..fee65dc 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml
@@ -65,11 +65,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml b/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
index 0cdf13b..19727ab 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
@@ -65,11 +65,3 @@ columns and rows.</para>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-uyvy.xml b/Documentation/DocBook/media/v4l/pixfmt-uyvy.xml
index 816c8d4..b1f6801 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-uyvy.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-uyvy.xml
@@ -118,11 +118,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-vyuy.xml b/Documentation/DocBook/media/v4l/pixfmt-vyuy.xml
index 61f12a5..8280340 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-vyuy.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-vyuy.xml
@@ -118,11 +118,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y16.xml b/Documentation/DocBook/media/v4l/pixfmt-y16.xml
index d584040..ff4f727 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-y16.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-y16.xml
@@ -79,11 +79,3 @@ pixel image</title>
     </example>
   </refsect1>
 </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-y41p.xml b/Documentation/DocBook/media/v4l/pixfmt-y41p.xml
index 73c8536..98dcb91 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-y41p.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-y41p.xml
@@ -147,11 +147,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv410.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv410.xml
index 8eb4a19..0869dce 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuv410.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv410.xml
@@ -131,11 +131,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml
index 00e0960..086dc73 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml
@@ -145,11 +145,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv420.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420.xml
index 42d7de5..48649fa 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuv420.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv420.xml
@@ -147,11 +147,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
index f5d8f57..9957863 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
@@ -152,11 +152,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml
index 4348bd9..4ce6463 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml
@@ -151,11 +151,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuyv.xml b/Documentation/DocBook/media/v4l/pixfmt-yuyv.xml
index bdb2ffa..5838409 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yuyv.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yuyv.xml
@@ -118,11 +118,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt-yvyu.xml b/Documentation/DocBook/media/v4l/pixfmt-yvyu.xml
index 40d17ae..bfffdc7 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-yvyu.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-yvyu.xml
@@ -118,11 +118,3 @@ pixel image</title>
 	</example>
       </refsect1>
     </refentry>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "pixfmt.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 2ff6b77..a33a4b2 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -997,11 +997,3 @@ the other bits are set to 0.</entry>
       </tgroup>
     </table>
   </section>
-
-  <!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
-  -->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
index 1d31427..0be17c2 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
@@ -228,11 +228,3 @@ is out of bounds.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
index 71d373b..347d142 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
@@ -156,11 +156,3 @@ bounds.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
index 476fe1d..9b8efcd 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
@@ -311,11 +311,3 @@ out of bounds.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
index a281d26..a64d5ef 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
@@ -196,11 +196,3 @@ is out of bounds.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumstd.xml b/Documentation/DocBook/media/v4l/vidioc-enumstd.xml
index 95803fe..3a5fc54 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumstd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumstd.xml
@@ -381,11 +381,3 @@ is out of bounds.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml b/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
index 5146d00..12b1d05 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
@@ -127,11 +127,3 @@ this control belongs to.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 5122ce8..6f1f9a6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -312,10 +312,3 @@ to store the payload and this error code is returned.</para>
   </refsect1>
 </refentry>

-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
index 062d720..1643181 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
@@ -135,11 +135,3 @@ wrong.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
index 15ce660..7f4ac7e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
@@ -236,11 +236,3 @@ mode.</entry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-priority.xml b/Documentation/DocBook/media/v4l/vidioc-g-priority.xml
index 8f5e3da..6a81b4f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-priority.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-priority.xml
@@ -133,11 +133,3 @@ priority.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-std.xml b/Documentation/DocBook/media/v4l/vidioc-g-std.xml
index 37996f2..99ff1a0 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-std.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-std.xml
@@ -88,11 +88,3 @@ standards.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
index b23a4b0..91ec2fb 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
@@ -535,11 +535,3 @@ out of bounds.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
index 5c104d4..6e414d7 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
@@ -100,11 +100,3 @@ supported, or the <structfield>index</structfield> is out of bounds.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index 0ac0057..36660d3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -443,11 +443,3 @@ or this particular menu item is not supported by the driver.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
index c30dcc4..e013da8 100644
--- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
@@ -125,11 +125,3 @@ wrong.</para>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
--
1.7.4.1

