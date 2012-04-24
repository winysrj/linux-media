Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:7222 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2DXNsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 09:48:35 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFCv3 PATCH 4/6] V4L2 spec: document the new V4L2 DV timings ioctls.
Date: Tue, 24 Apr 2012 15:48:03 +0200
Message-Id: <bed2437f5cec1e6a1d5c760f35507d04e1e71f51.1335274503.git.hans.verkuil@cisco.com>
In-Reply-To: <1335275285-13333-1-git-send-email-hans.verkuil@cisco.com>
References: <1335275285-13333-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <c5dd21524394247c53a2d58797c64f974f4bd6ca.1335274503.git.hans.verkuil@cisco.com>
References: <c5dd21524394247c53a2d58797c64f974f4bd6ca.1335274503.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           |    3 +
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |  121 ++++++++++++++++++--
 2 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index fbf808d..4d19826 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -511,10 +511,12 @@ and discussions on the V4L mailing list.</revremark>
     &sub-dbg-g-register;
     &sub-decoder-cmd;
     &sub-dqevent;
+    &sub-dv-timings-cap;
     &sub-encoder-cmd;
     &sub-enumaudio;
     &sub-enumaudioout;
     &sub-enum-dv-presets;
+    &sub-enum-dv-timings;
     &sub-enum-fmt;
     &sub-enum-framesizes;
     &sub-enum-frameintervals;
@@ -549,6 +551,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-querycap;
     &sub-queryctrl;
     &sub-query-dv-preset;
+    &sub-query-dv-timings;
     &sub-querystd;
     &sub-prepare-buf;
     &sub-reqbufs;
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index 4a8648a..1b3ba41 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -83,12 +83,13 @@ or the timing values are not correct, the driver returns &EINVAL;.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>width</structfield></entry>
-	    <entry>Width of the active video in pixels</entry>
+	    <entry>Width of the active video in pixels.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>height</structfield></entry>
-	    <entry>Height of the active video in lines</entry>
+	    <entry>Height of the active video frame in lines. So for interlaced formats the
+	    height of the active video in each field is <structfield>height</structfield>/2.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -125,32 +126,52 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>vfrontporch</structfield></entry>
-	    <entry>Vertical front porch in lines</entry>
+	    <entry>Vertical front porch in lines. For interlaced formats this refers to the
+	    odd field (aka field 1).</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>vsync</structfield></entry>
-	    <entry>Vertical sync length in lines</entry>
+	    <entry>Vertical sync length in lines. For interlaced formats this refers to the
+	    odd field (aka field 1).</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>vbackporch</structfield></entry>
-	    <entry>Vertical back porch in lines</entry>
+	    <entry>Vertical back porch in lines. For interlaced formats this refers to the
+	    odd field (aka field 1).</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vfrontporch</structfield></entry>
-	    <entry>Vertical front porch in lines for bottom field of interlaced field formats</entry>
+	    <entry>Vertical front porch in lines for the even field (aka field 2) of
+	    interlaced field formats.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vsync</structfield></entry>
-	    <entry>Vertical sync length in lines for bottom field of interlaced field formats</entry>
+	    <entry>Vertical sync length in lines for the even field (aka field 2) of
+	    interlaced field formats.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vbackporch</structfield></entry>
-	    <entry>Vertical back porch in lines for bottom field of interlaced field formats</entry>
+	    <entry>Vertical back porch in lines for the even field (aka field 2) of
+	    interlaced field formats.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>standards</structfield></entry>
+	    <entry>The video standard(s) this format belongs to. This will be filled in by
+	    the driver. Applications must set this to 0. See <xref linkend="dv-bt-standards"/>
+	    for a list of standards.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Several flags giving more information about the format.
+	    See <xref linkend="dv-bt-flags"/> for a description of the flags.
+	    </entry>
 	  </row>
 	</tbody>
       </tgroup>
@@ -211,6 +232,90 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
 	</tbody>
       </tgroup>
     </table>
+    <table pgwide="1" frame="none" id="dv-bt-standards">
+      <title>DV BT Timing standards</title>
+      <tgroup cols="2">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>Timing standard</entry>
+	    <entry>Description</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_STD_CEA861</entry>
+	    <entry>The timings follow the CEA-861 Digital TV Profile standard</entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_STD_DMT</entry>
+	    <entry>The timings follow the VESA Discrete Monitor Timings standard</entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_STD_CVT</entry>
+	    <entry>The timings follow the VESA Coordinated Video Timings standard</entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_STD_GTF</entry>
+	    <entry>The timings follow the VESA Generalized Timings Formula standard</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+    <table pgwide="1" frame="none" id="dv-bt-flags">
+      <title>DV BT Timing flags</title>
+      <tgroup cols="2">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>Flag</entry>
+	    <entry>Description</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_REDUCED_BLANKING</entry>
+	    <entry>CVT/GTF specific: the timings use reduced blanking (CVT) or the 'Secondary
+GTF' curve (GTF). In both cases the horizontal and/or vertical blanking
+intervals are reduced, allowing a higher resolution over the same
+bandwidth. This is a read-only flag, applications must not set this.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_CAN_REDUCE_FPS</entry>
+	    <entry>CEA-861 specific: set for CEA-861 formats with a framerate that is a multiple
+of six. These formats can be optionally played at 1 / 1.001 speed to
+be compatible with 60 Hz based standards such as NTSC and PAL-M that use a framerate of
+29.97 frames per second. If the transmitter can't generate such frequencies, then the
+flag will also be cleared. This is a read-only flag, applications must not set this.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_REDUCED_FPS</entry>
+	    <entry>CEA-861 specific: only valid for video transmitters, the flag is cleared
+by receivers. It is also only valid for formats with the V4L2_DV_FL_CAN_REDUCE_FPS flag
+set, for other formats the flag will be cleared by the driver.
+
+If the application sets this flag, then the pixelclock used to set up the transmitter is
+divided by 1.001 to make it compatible with NTSC framerates. If the transmitter
+can't generate such frequencies, then the flag will also be cleared.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_HALF_LINE</entry>
+	    <entry>Specific to interlaced formats: if set, then field 1 (aka the odd field)
+is really one half-line longer and field 2 (aka the even field) is really one half-line
+shorter, so each field has exactly the same number of half-lines. Whether half-lines can be
+detected or used depends on the hardware.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
   </refsect1>
   <refsect1>
     &return-value;
-- 
1.7.9.5

