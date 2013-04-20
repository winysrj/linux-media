Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3DTOwG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 10:52:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v1] Add SDR at V4L2 API
Date: Sat, 20 Apr 2013 11:51:39 -0300
Message-Id: <1366469499-31640-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the basic API bits for Software Digital Radio (SDR) at the V4L2 API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

This is a version 1 of the V4L2 API bits to support Software Digital
Radio (SDR).

This patch adds the very basic stuff for SDR:

	- a separate devnode;
	- an VIDIOC_QUERYCAP caps for SDR;
	- a fourcc group for SDR;
	- a few DocBook bits.

What's missing:
	- SDR specific controls;
	- Sample rate config;
	- a new type of capture (V4L2_BUF_TYPE_SDR_CAPTURE) for the
	  receiver samples.
	...

As discussing DocBook changes inside the patch is hard, I'm adding here
the DocBook formatted changes.

The DocBook changes add the following bits:

At Chapter 1. Common API Elements, it adds:

<text>
Software Digital Radio (SDR) Tuners and Modulators
==================================================

Those devices are special types of Radio devices that don't have any 
analog demodulator. Instead, it samples the radio IF or baseband and 
sends the samples for userspace to demodulate. 

Tuners
======

SDR receivers can have one or more tuners sampling RF signals. Each 
tuner is associated with one or more inputs, depending on the number of 
RF connectors on the tuner. The type field of the respective struct 
v4l2_input returned by the VIDIOC_ENUMINPUT ioctl is set to 
V4L2_INPUT_TYPE_TUNER and its tuner field contains the index number of 
the tuner input.

To query and change tuner properties applications use the VIDIOC_G_TUNER 
and VIDIOC_S_TUNER ioctl, respectively. The struct v4l2_tuner returned 
by VIDIOC_G_TUNER also contains signal status information applicable 
when the tuner of the current SDR input is queried. In order to change 
the SDR input, VIDIOC_S_TUNER with a new SDR index should be called. 
Drivers must support both ioctls and set the V4L2_CAP_SDR and 
V4L2_CAP_TUNER flags in the struct v4l2_capability returned by the 
VIDIOC_QUERYCAP ioctl.

Modulators
==========

To be defined.
</text>

At the end of Chapter 2. Image Formats, it adds:

<text>
SDR format struture
===================

Table 2.4. struct v4l2_sdr_format
=================================

__u32	sampleformat	The format of the samples used by the SDR device.
			This is a little endian four character code.

Table 2.5. SDR formats
======================

V4L2_SDR_FMT_I8Q8	Samples are given by a sequence of 8 bits in-phase(I)
			and 8 bits quadrature (Q) samples taken from a
			signal(t) represented by the following expression:
			signal(t) = I * cos(2π fc t) - Q * sin(2π fc t)
</text>

Of course, other formats will be needed at Table 2.5, as SDR could also 
be taken baseband samples, being, for example, a simple sequence of 
equally time-spaced digitalized samples of the signal in time.
SDR samples could also use other resolutions, use a non-linear
(A-law, u-law) ADC, or even compress the samples (with ADPCM, for 
example). So, this table will grow as newer devices get added, and an
userspace library may be required to convert them into some common
format.

At "Chapter 4. Interfaces", it adds the following text:

<text>
Software Digital Radio(SDR) Interface
=====================================

This interface is intended for Software Digital Radio (SDR) receivers 
and transmitters.

Conventionally V4L2 SDR devices are accessed through character device 
special files named /dev/sdr0 to/dev/radio255 and uses a dynamically 
allocated major/minor number.

Querying Capabilities
=====================

Devices supporting the radio interface set the V4L2_CAP_SDR and 
V4L2_CAP_TUNER or V4L2_CAP_MODULATOR flag in the capabilities field of 
struct v4l2_capability returned by the VIDIOC_QUERYCAP ioctl. Other 
combinations of capability flags are reserved for future extensions. 

Supplemental Functions
======================

SDR receivers should support tuner ioctls.

SDR transmitter ioctl's will be defined in the future.

SDR devices should also support one or more of the following I/O ioctls: 
read or write, memory mapped IO, user memory IO and/or DMA buffers.

SDR devices can also support controls ioctls.

The SDR Input/Output are A/D or D/A samples taken from a modulated 
signal, and can eventually be packed by the hardware. They are generally 
encoded using cartesian in-phase/quadrature (I/Q) samples, to make 
demodulation easier. The format of the samples should be according with 
SDR format.
</text>

Note: "SDR format" on the last paragraph is an hyperlink to
Chapter 2. Image Formats.

At "Appendix A. Function Reference - ioctl VIDIOC_QUERYCAP", it adds:

<text>
Table A.93. Device Capabilities Flags
...
V4L2_CAP_SDR	0x00100000	The device is a Software Digital Radio. 
				For more information about SDR programming
				see the section called “Software Digital 
				Radio (SDR) Tuners and Modulators”.
</text>

 Documentation/DocBook/media/v4l/common.xml         | 35 ++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         | 41 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |  1 +
 .../DocBook/media/v4l/vidioc-querycap.xml          |  7 ++++
 drivers/media/v4l2-core/v4l2-dev.c                 |  3 ++
 include/media/v4l2-dev.h                           |  3 +-
 include/uapi/linux/videodev2.h                     | 11 ++++++
 7 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 1ddf354..f59c67d 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -513,6 +513,41 @@ the &v4l2-capability; returned by the &VIDIOC-QUERYCAP; ioctl when the
 device has one or more modulators.</para>
     </section>
 
+  <section id="sdr_tuner">
+    <title>Software Digital Radio (SDR) Tuners and Modulators</title>
+
+    <para>Those devices are special types of Radio devices that don't
+have any analog demodulator. Instead, it samples the radio IF or baseband
+and sends the samples for userspace to demodulate.</para>
+    <section>
+      <title>Tuners</title>
+
+      <para>SDR receivers can have one or more tuners sampling RF signals.
+Each tuner is associated with one or more inputs, depending on the number
+of RF connectors on the tuner. The <structfield>type</structfield> field of
+the respective &v4l2-input; returned by the &VIDIOC-ENUMINPUT; ioctl is set to
+<constant>V4L2_INPUT_TYPE_TUNER</constant> and its
+<structfield>tuner</structfield> field contains the index number of
+the tuner input.</para>
+
+<para>To query and change tuner properties applications use the
+&VIDIOC-G-TUNER; and &VIDIOC-S-TUNER; ioctl, respectively. The
+&v4l2-tuner; returned by <constant>VIDIOC_G_TUNER</constant> also
+contains signal status information applicable when the tuner of the
+current SDR input is queried. In order to change the SDR input,
+<constant>VIDIOC_S_TUNER</constant> with a new SDR index should be called.
+Drivers must support both ioctls and set the
+<constant>V4L2_CAP_SDR</constant> and <constant>V4L2_CAP_TUNER</constant>
+flags in the &v4l2-capability; returned by the &VIDIOC-QUERYCAP; ioctl.</para>
+    </section>
+
+    <section>
+      <title>Modulators</title>
+      <para>To be defined.</para>
+    </section>
+  </section>
+
+
     <section>
       <title>Radio Frequency</title>
 
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 99b8d2a..e30075e 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -203,6 +203,47 @@ codes can be used.</entry>
   </table>
 </section>
 
+<section>
+  <title>SDR format struture</title>
+  <table pgwide="1" frame="none" id="v4l2-sdr-format">
+    <title>struct <structname>v4l2_sdr_format</structname></title>
+    <tgroup cols="3">
+      &cs-str;
+      <tbody valign="top">
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>sampleformat</structfield></entry>
+	  <entry>The format of the samples used by the SDR device.
+		 This is a little endian
+		 <link linkend="v4l2-sdr-fourcc">
+		 four character code</link>.</entry>
+	</row>
+      </tbody>
+    </tgroup>
+  </table>
+  <table pgwide="1" frame="none" id="v4l2-sdr-fourcc">
+    <title>SDR formats</title>
+    <tgroup cols="2">
+      &cs-str;
+      <tbody valign="top">
+	<row>
+	  <entry><constant>V4L2_SDR_FMT_I8Q8</constant></entry>
+	  <entry>Samples are given by a sequence of 8 bits in-phase(I) and
+		  8 bits quadrature (Q) samples taken from a
+		  <emphasis>signal(t)</emphasis> represented by the following
+		 expression:
+		 <informalequation>
+		 <alt>signal(t) = I cos(2&pi; f t) - Q sin(2&pi; f t)</alt>
+		 <mathphrase><emphasis>signal(t) = I * cos(2&pi; f<subscript>c</subscript> t) - Q * sin(2&pi; f<subscript>c</subscript> t)</emphasis></mathphrase>
+		 </informalequation>
+	  </entry>
+	</row>
+      </tbody>
+    </tgroup>
+  </table>
+
+</section>
+
   <section>
     <title>Standard Image Formats</title>
 
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index bfc93cd..b53a5cf 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -521,6 +521,7 @@ and discussions on the V4L mailing list.</revremark>
     <section id="ttx"> &sub-dev-teletext; </section>
     <section id="radio"> &sub-dev-radio; </section>
     <section id="rds"> &sub-dev-rds; </section>
+    <section id="sdr"> &sub-dev-sdr; </section>
     <section id="event"> &sub-dev-event; </section>
     <section id="subdev"> &sub-dev-subdev; </section>
   </chapter>
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index d5a3c97..97bb25a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -296,6 +296,13 @@ modulator programming see
 <xref linkend="tuner" />.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CAP_SDR</constant></entry>
+	    <entry>0x00100000</entry>
+	    <entry>The device is a Software Digital Radio.
+		    For more information about SDR programming see
+<xref linkend="sdr_tuner" />.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CAP_READWRITE</constant></entry>
 	    <entry>0x01000000</entry>
 	    <entry>The device supports the <link
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 5923c5d..a48e070 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -796,6 +796,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	case VFL_TYPE_SUBDEV:
 		name_base = "v4l-subdev";
 		break;
+	case VFL_TYPE_SDR:
+		name_base = "sdr";
+		break;
 	default:
 		printk(KERN_ERR "%s called with unknown type: %d\n",
 		       __func__, type);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 95d1c91..95863bb 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -24,7 +24,8 @@
 #define VFL_TYPE_VBI		1
 #define VFL_TYPE_RADIO		2
 #define VFL_TYPE_SUBDEV		3
-#define VFL_TYPE_MAX		4
+#define VFL_TYPE_SDR		4
+#define VFL_TYPE_MAX		5
 
 /* Is this a receiver, transmitter or mem-to-mem? */
 /* Ignored for VFL_TYPE_SUBDEV. */
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 97fb392..d22c1fa 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -284,6 +284,7 @@ struct v4l2_capability {
 #define V4L2_CAP_AUDIO			0x00020000  /* has audio support */
 #define V4L2_CAP_RADIO			0x00040000  /* is a radio device */
 #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
+#define V4L2_CAP_SDR			0x00100000  /* is a SDR device */
 
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
@@ -1700,6 +1701,15 @@ struct v4l2_pix_format_mplane {
 	__u8				reserved[11];
 } __attribute__ ((packed));
 
+
+struct v4l2_sdr_format {
+	__u32				sampleformat;
+}
+
+/*      Sample format						Description  */
+
+#define V4L2_SDR_FMT_I8Q8	v4l2_fourcc('I', '8', 'Q', '8') /* I 8bits, Q 8bits  */
+
 /**
  * struct v4l2_format - stream data format
  * @type:	enum v4l2_buf_type; type of the data stream
@@ -1718,6 +1728,7 @@ struct v4l2_format {
 		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
 		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
 		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
+		struct v4l2_sdr_format		fmt;	 /* V4L2_BUF_TYPE_SDR_CAPTURE */
 		__u8	raw_data[200];                   /* user-defined */
 	} fmt;
 };
-- 
1.8.1.4

