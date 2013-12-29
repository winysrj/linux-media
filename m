Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58044 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab3L2EF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:05:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v6 10/12] DocBook: document 1 Hz flag
Date: Sun, 29 Dec 2013 06:04:02 +0200
Message-Id: <1388289844-2766-11-git-send-email-crope@iki.fi>
In-Reply-To: <1388289844-2766-1-git-send-email-crope@iki.fi>
References: <1388289844-2766-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update documention to reflect 1 Hz frequency step flag.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml          |  8 +++++---
 Documentation/DocBook/media/v4l/vidioc-g-frequency.xml    |  5 +++--
 Documentation/DocBook/media/v4l/vidioc-g-modulator.xml    |  6 ++++--
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml        | 15 ++++++++++++---
 Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml |  8 ++++++--
 5 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml b/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
index 6541ba0..60ad9ea 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
@@ -100,7 +100,7 @@ See <xref linkend="v4l2-tuner-type" /></entry>
 	    <entry><structfield>capability</structfield></entry>
 	    <entry spanname="hspan">The tuner/modulator capability flags for
 this frequency band, see <xref linkend="tuner-capability" />. The <constant>V4L2_TUNER_CAP_LOW</constant>
-capability must be the same for all frequency bands of the selected tuner/modulator.
+or <constant>V4L2_TUNER_CAP_1HZ</constant> capability must be the same for all frequency bands of the selected tuner/modulator.
 So either all bands have that capability set, or none of them have that capability.</entry>
 	  </row>
 	  <row>
@@ -109,7 +109,8 @@ So either all bands have that capability set, or none of them have that capabili
 	    <entry spanname="hspan">The lowest tunable frequency in
 units of 62.5 kHz, or if the <structfield>capability</structfield>
 flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz, for this frequency band.</entry>
+Hz, for this frequency band. 1 Hz unit is used when <structfield>capability</structfield> flag
+<constant>V4L2_TUNER_CAP_1HZ</constant> is set.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -117,7 +118,8 @@ Hz, for this frequency band.</entry>
 	    <entry spanname="hspan">The highest tunable frequency in
 units of 62.5 kHz, or if the <structfield>capability</structfield>
 flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz, for this frequency band.</entry>
+Hz, for this frequency band. 1 Hz unit is used when <structfield>capability</structfield> flag
+<constant>V4L2_TUNER_CAP_1HZ</constant> is set.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
index c7a1c46..01870c4 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
@@ -109,9 +109,10 @@ See <xref linkend="v4l2-tuner-type" /></entry>
 	    <entry>__u32</entry>
 	    <entry><structfield>frequency</structfield></entry>
 	    <entry>Tuning frequency in units of 62.5 kHz, or if the
-&v4l2-tuner; or &v4l2-modulator; <structfield>capabilities</structfield> flag
+&v4l2-tuner; or &v4l2-modulator; <structfield>capability</structfield> flag
 <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz.</entry>
+Hz. 1 Hz unit is used when <structfield>capability</structfield> flag
+<constant>V4L2_TUNER_CAP_1HZ</constant> is set.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
index 7f4ac7e..7068b59 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
@@ -113,7 +113,8 @@ change for example with the current video standard.</entry>
 	    <entry>The lowest tunable frequency in units of 62.5
 KHz, or if the <structfield>capability</structfield> flag
 <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz.</entry>
+Hz, or if the <structfield>capability</structfield> flag
+<constant>V4L2_TUNER_CAP_1HZ</constant> is set, in units of 1 Hz.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -121,7 +122,8 @@ Hz.</entry>
 	    <entry>The highest tunable frequency in units of 62.5
 KHz, or if the <structfield>capability</structfield> flag
 <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz.</entry>
+Hz, or if the <structfield>capability</structfield> flag
+<constant>V4L2_TUNER_CAP_1HZ</constant> is set, in units of 1 Hz.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
index 6cc8201..b0d8659 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
@@ -134,7 +134,9 @@ the structure refers to a radio tuner the
 	    <entry spanname="hspan">The lowest tunable frequency in
 units of 62.5 kHz, or if the <structfield>capability</structfield>
 flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz. If multiple frequency bands are supported, then
+Hz, or if the <structfield>capability</structfield> flag
+<constant>V4L2_TUNER_CAP_1HZ</constant> is set, in units of 1 Hz.
+If multiple frequency bands are supported, then
 <structfield>rangelow</structfield> is the lowest frequency
 of all the frequency bands.</entry>
 	  </row>
@@ -144,7 +146,9 @@ of all the frequency bands.</entry>
 	    <entry spanname="hspan">The highest tunable frequency in
 units of 62.5 kHz, or if the <structfield>capability</structfield>
 flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz. If multiple frequency bands are supported, then
+Hz, or if the <structfield>capability</structfield> flag
+<constant>V4L2_TUNER_CAP_1HZ</constant> is set, in units of 1 Hz.
+If multiple frequency bands are supported, then
 <structfield>rangehigh</structfield> is the highest frequency
 of all the frequency bands.</entry>
 	  </row>
@@ -270,7 +274,7 @@ applications must set the array to zero.</entry>
 	    <entry><constant>V4L2_TUNER_CAP_LOW</constant></entry>
 	    <entry>0x0001</entry>
 	    <entry>When set, tuning frequencies are expressed in units of
-62.5&nbsp;Hz, otherwise in units of 62.5&nbsp;kHz.</entry>
+62.5 Hz instead of 62.5 kHz.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_TUNER_CAP_NORM</constant></entry>
@@ -360,6 +364,11 @@ radio tuners.</entry>
 	<entry>The range to search when using the hardware seek functionality
 	is programmable, see &VIDIOC-S-HW-FREQ-SEEK; for details.</entry>
 	  </row>
+	  <row>
+	<entry><constant>V4L2_TUNER_CAP_1HZ</constant></entry>
+	<entry>0x1000</entry>
+	<entry>When set, tuning frequencies are expressed in units of 1 Hz instead of 62.5 kHz.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
index 5b379e7..a5fc4c4 100644
--- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
@@ -121,7 +121,9 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
 	    <entry>If non-zero, the lowest tunable frequency of the band to
 search in units of 62.5 kHz, or if the &v4l2-tuner;
 <structfield>capability</structfield> field has the
-<constant>V4L2_TUNER_CAP_LOW</constant> flag set, in units of 62.5 Hz.
+<constant>V4L2_TUNER_CAP_LOW</constant> flag set, in units of 62.5 Hz or if the &v4l2-tuner;
+<structfield>capability</structfield> field has the
+<constant>V4L2_TUNER_CAP_1HZ</constant> flag set, in units of 1 Hz.
 If <structfield>rangelow</structfield> is zero a reasonable default value
 is used.</entry>
 	  </row>
@@ -131,7 +133,9 @@ is used.</entry>
 	    <entry>If non-zero, the highest tunable frequency of the band to
 search in units of 62.5 kHz, or if the &v4l2-tuner;
 <structfield>capability</structfield> field has the
-<constant>V4L2_TUNER_CAP_LOW</constant> flag set, in units of 62.5 Hz.
+<constant>V4L2_TUNER_CAP_LOW</constant> flag set, in units of 62.5 Hz or if the &v4l2-tuner;
+<structfield>capability</structfield> field has the
+<constant>V4L2_TUNER_CAP_1HZ</constant> flag set, in units of 1 Hz.
 If <structfield>rangehigh</structfield> is zero a reasonable default value
 is used.</entry>
 	  </row>
-- 
1.8.4.2

