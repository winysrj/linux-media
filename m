Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NMigEB018788
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:42 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2NMi4Nc019489
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:06 -0400
Received: by fg-out-1718.google.com with SMTP id e12so2174159fga.7
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 15:43:58 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <patchbomb.1206312199@liva.fdsoft.se>
Date: Sun, 23 Mar 2008 23:43:19 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 0 of 6] cx88: Enable additional cx2388x features. Version 3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

The cx2388x family of broadcast decoders all have features not enabled
by the standard cx88 driver. This revised patch series adds two new
pre-defined control IDs: V4L2_CID_CHROMA_AGC and V4L2_CID_COLOR_KILLER
(patch 1+4).

Patches 2 and 5 respectively implement these controls for cx88.

Patches 3 and 6 enable these controls by default as the enabled
features will not degrade picture quality when used with high quality
input and will improve quality with marginal input.

The patches applies cleanly to 7400:9a2af878cbd5 of
http://linuxtv.org/hg/v4l-dvb/ and have been tested an a HVR-1300. The
patches should be applied in order, but patches 3 and 6 can be
omitted.

Below is a patch to version 0.24 of the v4l2-spec docbook source
documenting V4L2_CID_CHROMA_AGC and V4L2_CID_COLOR_KILLER. This patch
is untested as building the unmodified spec fails on my system and
build requirements are undocumented.

diff -ur v4l2spec-0.24-original/compat.sgml v4l2spec-0.24/compat.sgml
--- v4l2spec-0.24-original/compat.sgml	2008-03-06 16:42:11.000000000 +0100
+++ v4l2spec-0.24/compat.sgml	2008-03-22 23:48:47.000000000 +0100
@@ -2202,6 +2202,17 @@
 	 </listitem>
        </orderedlist>
      </section>
+
+    <section>
+      <title>V4L2 in Linux 2.6.2x</title>
+      <orderedlist>
+        <listitem>
+          <para>New <link linkend="control">controls</link>
+<constant>V4L2_CID_CHROMA_AGC</constant>,
+<constant>V4L2_CID_COLOR_KILLER</constant>were added.
+        </listitem>
+       </orderedlist>
+     </section>
    </section>
 
    <section id="other">
diff -ur v4l2spec-0.24-original/controls.sgml v4l2spec-0.24/controls.sgml
--- v4l2spec-0.24-original/controls.sgml	2008-03-06 16:42:11.000000000 +0100
+++ v4l2spec-0.24/controls.sgml	2008-03-22 23:16:26.000000000 +0100
@@ -261,11 +261,21 @@
             <entry>Adjusts the backlight compensation in a camera. The
 minimum value disables backlight compensation.</entry>
           </row>
+	  <row>
+            <entry><constant>V4L2_CID_CHROMA_AGC</constant></entry>
+            <entry>boolean</entry>
+            <entry>Enables automatic gain control for the chroma channel.</entry>
+          </row>
+	  <row>
+            <entry><constant>V4L2_CID_COLOR_KILLER</constant></entry>
+            <entry>boolean</entry>
+            <entry>Enables color killer functionality.</entry>
+          </row>
           <row>
             <entry><constant>V4L2_CID_LASTP1</constant></entry>
             <entry></entry>
             <entry>End of the predefined control IDs (currently
-<constant>V4L2_CID_BACKLIGHT_COMPENSATION</constant> + 1).</entry>
+<constant>V4L2_CID_COLOR_KILLER</constant> + 1).</entry>
           </row>
           <row>
             <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
