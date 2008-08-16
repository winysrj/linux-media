Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7GDSxRm003971
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 09:28:59 -0400
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7GDSloF011997
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 09:28:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Michael Schimek <mschimek@gmx.at>
Date: Sat, 16 Aug 2008 15:28:46 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OYtpI2gNMNeMOSh"
Message-Id: <200808161528.46211.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>
Subject: V4L2 spec additions
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

--Boundary-00=_OYtpI2gNMNeMOSh
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Michael,

Attached is a patch that adds the documentation for some new MPEG stream 
types. These will appear in 2.6.28.

It also adds the documentation for the V4L2_CID_CHROMA_AGC and 
V4L2_CID_COLOR_KILLER user controls that appeared in 2.6.26.

Note that I did not update the videodev2.h that is Appendix A and I also 
did not update chapter 6.2 (the change history).

Regards,

	Hans

--Boundary-00=_OYtpI2gNMNeMOSh
Content-Type: text/x-diff;
  charset="utf-8";
  name="controls.sgml.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="controls.sgml.diff"

--- controls.sgml.orig	2008-08-16 15:03:54.000000000 +0200
+++ controls.sgml	2008-08-16 15:25:30.000000000 +0200
@@ -262,6 +262,16 @@
 minimum value disables backlight compensation.</entry>
           </row>
           <row>
+            <entry><constant>V4L2_CID_CHROMA_AGC</constant></entry>
+            <entry>boolean</entry>
+            <entry>Chroma automatic gain control.</entry>
+          </row>
+          <row>
+            <entry><constant>V4L2_CID_COLOR_KILLER</constant></entry>
+            <entry>boolean</entry>
+            <entry>Enable the color killer (i.e. force a black & white image).</entry>
+          </row>
+          <row>
             <entry><constant>V4L2_CID_LASTP1</constant></entry>
             <entry></entry>
             <entry>End of the predefined control IDs (currently
@@ -748,15 +758,23 @@
                   <tbody valign="top">
                     <row>
                       <entry><constant>V4L2_MPEG_AUDIO_ENCODING_LAYER_1</constant>&nbsp;</entry>
-                      <entry>MPEG Layer I encoding</entry>
+                      <entry>MPEG-1/2 Layer I encoding</entry>
                     </row>
                     <row>
                       <entry><constant>V4L2_MPEG_AUDIO_ENCODING_LAYER_2</constant>&nbsp;</entry>
-                      <entry>MPEG Layer II encoding</entry>
+                      <entry>MPEG-1/2 Layer II encoding</entry>
                     </row>
                     <row>
                       <entry><constant>V4L2_MPEG_AUDIO_ENCODING_LAYER_3</constant>&nbsp;</entry>
-                      <entry>MPEG Layer III encoding</entry>
+                      <entry>MPEG-1/2 Layer III encoding</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_ENCODING_AAC</constant>&nbsp;</entry>
+                      <entry>MPEG-2/4 AAC (Advanced Audio Coding)</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_ENCODING_AC3</constant>&nbsp;</entry>
+                      <entry>AC-3</entry>
                     </row>
                   </tbody>
                 </entrytbl>
@@ -765,7 +783,7 @@
               <row>
                 <entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_L1_BITRATE</constant>&nbsp;</entry>
                 <entry>enum</entry>
-              </row><row><entry spanname="descr">Layer I bitrate.
+              </row><row><entry spanname="descr">MPEG-1/2 Layer I bitrate.
 Possible values are:</entry>
               </row>
               <row>
@@ -833,7 +851,7 @@
               <row>
                 <entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_L2_BITRATE</constant>&nbsp;</entry>
                 <entry>enum</entry>
-              </row><row><entry spanname="descr">Layer II bitrate.
+              </row><row><entry spanname="descr">MPEG-1/2 Layer II bitrate.
 Possible values are:</entry>
               </row>
               <row>
@@ -902,7 +920,7 @@
               <row>
                 <entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_L3_BITRATE</constant>&nbsp;</entry>
                 <entry>enum</entry>
-              </row><row><entry spanname="descr">Layer III bitrate.
+              </row><row><entry spanname="descr">MPEG-1/2 Layer III bitrate.
 Possible values are:</entry>
               </row>
               <row>
@@ -969,6 +987,100 @@
               </row>
               <row><entry></entry></row>
               <row>
+                <entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_AAC_BITRATE</constant>&nbsp;</entry>
+                <entry>integer</entry>
+              </row><row><entry spanname="descr">AAC bitrate in bits per second.</entry>
+              </row>
+              <row><entry></entry></row>
+              <row>
+                <entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_AC3_BITRATE</constant>&nbsp;</entry>
+                <entry>enum</entry>
+              </row><row><entry spanname="descr">AC-3 bitrate.
+Possible values are:</entry>
+              </row>
+              <row>
+                <entrytbl spanname="descr" cols="2">
+                  <tbody valign="top">
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_32K</constant>&nbsp;</entry>
+                      <entry>32 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_40K</constant>&nbsp;</entry>
+                      <entry>40 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_48K</constant>&nbsp;</entry>
+                      <entry>48 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_56K</constant>&nbsp;</entry>
+                      <entry>56 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_64K</constant>&nbsp;</entry>
+                      <entry>64 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_80K</constant>&nbsp;</entry>
+                      <entry>80 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_96K</constant>&nbsp;</entry>
+                      <entry>96 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_112K</constant>&nbsp;</entry>
+                      <entry>112 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_128K</constant>&nbsp;</entry>
+                      <entry>128 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_160K</constant>&nbsp;</entry>
+                      <entry>160 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_192K</constant>&nbsp;</entry>
+                      <entry>192 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_224K</constant>&nbsp;</entry>
+                      <entry>224 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_256K</constant>&nbsp;</entry>
+                      <entry>256 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_320K</constant>&nbsp;</entry>
+                      <entry>320 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_384K</constant>&nbsp;</entry>
+                      <entry>384 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_448K</constant>&nbsp;</entry>
+                      <entry>448 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_512K</constant>&nbsp;</entry>
+                      <entry>512 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_576K</constant>&nbsp;</entry>
+                      <entry>576 kbit/s</entry>
+                    </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_AUDIO_AC3_BITRATE_640K</constant>&nbsp;</entry>
+                      <entry>640 kbit/s</entry>
+                    </row>
+                  </tbody>
+                </entrytbl>
+              </row>
+              <row>
                 <entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_MODE</constant>&nbsp;</entry>
                 <entry>enum</entry>
               </row><row><entry spanname="descr">MPEG Audio mode.
@@ -1101,6 +1213,10 @@
                       <entry><constant>V4L2_MPEG_VIDEO_ENCODING_MPEG_2</constant>&nbsp;</entry>
                       <entry>MPEG-2 Video encoding</entry>
                     </row>
+                    <row>
+                      <entry><constant>V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC</constant>&nbsp;</entry>
+                      <entry>MPEG-4 AVC (H.264) Video encoding</entry>
+                    </row>
                   </tbody>
                 </entrytbl>
               </row>

--Boundary-00=_OYtpI2gNMNeMOSh
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_OYtpI2gNMNeMOSh--
