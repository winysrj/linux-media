Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3216 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2E0Luk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 07:50:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/5] v4l2 spec: document the new v4l2_tuner capabilities
Date: Sun, 27 May 2012 13:50:22 +0200
Message-Id: <b85301e88453a46256e0d2b9dcd1dbf10557d8c7.1338118975.git.hans.verkuil@cisco.com>
In-Reply-To: <1338119425-17274-1-git-send-email-hverkuil@xs4all.nl>
References: <1338119425-17274-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <04a877e6f6310b83c3980cd6963f52d3b9ae658f.1338118975.git.hans.verkuil@cisco.com>
References: <04a877e6f6310b83c3980cd6963f52d3b9ae658f.1338118975.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Update the spec with the new capabilities and specify new error codes for
S_HW_FREQ_SEEK.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-g-frequency.xml         |    6 ++++++
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml   |   12 ++++++++++++
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml      |   18 +++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
index 69c178a..40e58a4 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
@@ -135,6 +135,12 @@ bounds or the value in the <structfield>type</structfield> field is
 wrong.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
+	<listitem>
+	  <para>A hardware seek is in progress.</para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
index 62a1aa2..95d5371 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
@@ -276,6 +276,18 @@ can or must be switched. (B/G PAL tuners for example are typically not
       <constant>V4L2_TUNER_ANALOG_TV</constant> tuners can have this capability.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_TUNER_CAP_HWSEEK_BOUNDED</constant></entry>
+	    <entry>0x0004</entry>
+	    <entry>If set, then this tuner supports the hardware seek functionality
+	    where the seek stops when it reaches the end of the frequency range.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_TUNER_CAP_HWSEEK_WRAP</constant></entry>
+	    <entry>0x0008</entry>
+	    <entry>If set, then this tuner supports the hardware seek functionality
+	    where the seek wraps around when it reaches the end of the frequency range.</entry>
+	  </row>
+	  <row>
 	<entry><constant>V4L2_TUNER_CAP_STEREO</constant></entry>
 	<entry>0x0010</entry>
 	<entry>Stereo audio reception is supported.</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
index 407dfce..d58b648 100644
--- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
@@ -58,6 +58,9 @@ To do this applications initialize the <structfield>tuner</structfield>,
 call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl with a pointer
 to this structure.</para>
 
+    <para>If an error is returned, then the frequency original frequency will
+    be restored.</para>
+
     <para>This ioctl is supported if the <constant>V4L2_CAP_HW_FREQ_SEEK</constant> capability is set.</para>
 
     <table pgwide="1" frame="none" id="v4l2-hw-freq-seek">
@@ -87,7 +90,10 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>wrap_around</structfield></entry>
-	    <entry>If non-zero, wrap around when at the end of the frequency range, else stop seeking.</entry>
+	    <entry>If non-zero, wrap around when at the end of the frequency range, else stop seeking.
+	    The &v4l2-tuner; <structfield>capability</structfield> field will tell you what the
+	    hardware supports.
+	    </entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -118,9 +124,15 @@ wrong.</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
-	<term><errorcode>EAGAIN</errorcode></term>
+	<term><errorcode>ENODATA</errorcode></term>
+	<listitem>
+	  <para>The hardware seek found no channels.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
 	<listitem>
-	  <para>The ioctl timed-out. Try again.</para>
+	  <para>Another hardware seek is already in progress.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
1.7.10

