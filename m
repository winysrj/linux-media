Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.233]:36815 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0I2MlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 08:41:11 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v11 4/4] Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags.
Date: Wed, 29 Sep 2010 15:40:39 +0300
Message-Id: <1285764039-5767-5-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1285764039-5767-4-git-send-email-matti.j.aaltonen@nokia.com>
References: <1285764039-5767-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1285764039-5767-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1285764039-5767-3-git-send-email-matti.j.aaltonen@nokia.com>
 <1285764039-5767-4-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a couple of words about the spacing field in the HW seek struct,
also a few words about the new RDS tuner capability flags
V4L2_TUNER_CAP_RDS_BLOCK-IO and V4L2_TUNER_CAP_RDS_CONTROLS.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 Documentation/DocBook/v4l/dev-rds.xml              |   10 +++++++++-
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 ++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/v4l/dev-rds.xml b/Documentation/DocBook/v4l/dev-rds.xml
index 0869d70..e7be392 100644
--- a/Documentation/DocBook/v4l/dev-rds.xml
+++ b/Documentation/DocBook/v4l/dev-rds.xml
@@ -28,6 +28,10 @@ returned by the &VIDIOC-QUERYCAP; ioctl.
 Any tuner that supports RDS will set the
 <constant>V4L2_TUNER_CAP_RDS</constant> flag in the <structfield>capability</structfield>
 field of &v4l2-tuner;.
+If the driver only passes RDS blocks without interpreting the data
+the <constant>V4L2_TUNER_SUB_RDS_BLOCK_IO</constant> flag has to be set. If the
+tuner is capable of handling RDS entities like program identication codes and radio
+text the flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> should be set.
 Whether an RDS signal is present can be detected by looking at
 the <structfield>rxsubchans</structfield> field of &v4l2-tuner;: the
 <constant>V4L2_TUNER_SUB_RDS</constant> will be set if RDS data was detected.</para>
@@ -40,7 +44,11 @@ Any modulator that supports RDS will set the
 <constant>V4L2_TUNER_CAP_RDS</constant> flag in the <structfield>capability</structfield>
 field of &v4l2-modulator;.
 In order to enable the RDS transmission one must set the <constant>V4L2_TUNER_SUB_RDS</constant>
-bit in the <structfield>txsubchans</structfield> field of &v4l2-modulator;.</para>
+bit in the <structfield>txsubchans</structfield> field of &v4l2-modulator;.
+If the driver only passes RDS blocks without interpreting the data
+the <constant>V4L2_TUNER_SUB_RDS_BLOCK_IO</constant> flag has to be set. If the
+tuner is capable of handling RDS entities like program identication codes and radio
+text the flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> should be set.</para>
 
   </section>
 
diff --git a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
index 14b3ec7..c30dcc4 100644
--- a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
@@ -51,7 +51,8 @@
 
     <para>Start a hardware frequency seek from the current frequency.
 To do this applications initialize the <structfield>tuner</structfield>,
-<structfield>type</structfield>, <structfield>seek_upward</structfield> and
+<structfield>type</structfield>, <structfield>seek_upward</structfield>,
+<structfield>spacing</structfield> and
 <structfield>wrap_around</structfield> fields, and zero out the
 <structfield>reserved</structfield> array of a &v4l2-hw-freq-seek; and
 call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl with a pointer
@@ -89,7 +90,12 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[8]</entry>
+	    <entry><structfield>spacing</structfield></entry>
+	    <entry>If non-zero, defines the hardware seek resolution in Hz. The driver selects the nearest value that is supported by the device. If spacing is zero a reasonable default value is used.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[7]</entry>
 	    <entry>Reserved for future extensions. Drivers and
 	    applications must set the array to zero.</entry>
 	  </row>
-- 
1.6.1.3

