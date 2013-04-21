Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab3DUTAw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:00:52 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LJ0qPa016337
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 15:00:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3 04/10] [media] V4L2 sdr API: Add fields for VIDIOC_[G|S]_TUNER
Date: Sun, 21 Apr 2013 16:00:33 -0300
Message-Id: <1366570839-662-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-1-git-send-email-mchehab@redhat.com>
References: <1366570839-662-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed at:
	http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/63123

SDR radio require some other things at to set. VIDIOC_[G|S]_TUNER
is currently not enough.

I proposed there to create an extra ioctl for it, but the thing
is that VIDIOC_[G|S]_TUNER is meant to set what's needed to configure
the tuner. So, add there the missing bits to:
	- set/get the tuner sampling rate;
	- set/get the tuner low pass bandwidth filter;
	- get the tuner IF.

VIDIOC_[G|S]_TUNER already provides:
	- tuner input switch;
	- tuner input name;
	- tuner capability flags;
	- tuner range;
	- signal strength;
	- afc.

There are still 3 u32 reserved fields there that may be used for
SDR in the future, and may be neded at the final version.

For example, it may make sense to add a SDR flag with:
	- bandwidth inversion flag;
	- tuner PLL lock flag (or reuse signal strength for that).

It also makes sense to add sample_rate range there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml | 30 ++++++++++++++---
 drivers/media/tuners/tuner-xc2028.c                |  2 ++
 include/uapi/linux/videodev2.h                     | 38 ++++++++++++++++++++--
 3 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
index 6cc8201..b8a3bcf 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
@@ -200,9 +200,10 @@ audio</entry>
 <constant>_SAP</constant> flag is cleared in the
 <structfield>capability</structfield> field, the corresponding
 <constant>V4L2_TUNER_SUB_</constant> flag must not be set
-here.</para><para>This field is valid only if this is the tuner of the
+here.</para>
+<para>This field is valid only for if this is the tuner of the
 current video input, or when the structure refers to a radio
-tuner.</para></entry>
+tuner. This field is not used by SDR tuners.</para></entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -216,7 +217,7 @@ unless the requested mode is invalid or unsupported. See <xref
 the selected and received audio programs do not
 match.</para><para>Currently this is the only field of struct
 <structname>v4l2_tuner</structname> applications can
-change.</para></entry>
+change. This field is not used by SDR tuners.</para></entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -234,7 +235,28 @@ settles at zero, &ie; range is what? --></entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[4]</entry>
+	    <entry><structfield>sample_rate</structfield></entry>
+	    <entry spanname="hspan">Sampling rate used by a SDR tuner, in Hz.
+		    This value is valid only for SDR tuners.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>bandwidth</structfield></entry>
+	    <entry spanname="hspan">Bandwidth allowed by the SDR tuner
+		    low-pass saw filter, in Hz. This value is valid only for
+		    SDR tuners.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>int_freq</structfield></entry>
+	    <entry spanname="hspan">Intermediate Frequency (IF) used by
+	    the tuner, in Hz. This value is valid only for
+	    <constant>VIDIOC_G_TUNER</constant>, and it is valid only
+	    on SDR tuners.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[3]</entry>
 	    <entry spanname="hspan">Reserved for future extensions. Drivers and
 applications must set the array to zero.</entry>
 	  </row>
diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 878d2c4..c61163f 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1020,6 +1020,8 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 	 * Maybe this might also be needed for DTV.
 	 */
 	switch (new_type) {
+	default:			/* SDR currently not supported */
+		goto ret;
 	case V4L2_TUNER_ANALOG_TV:
 		rc = send_seq(priv, {0x00, 0x00});
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 974c49d..c002030 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -160,6 +160,22 @@ enum v4l2_tuner_type {
 	V4L2_TUNER_RADIO	     = 1,
 	V4L2_TUNER_ANALOG_TV	     = 2,
 	V4L2_TUNER_DIGITAL_TV	     = 3,
+/*
+ * Even not decoding the signal, SDR tuners may require to adjust IF,
+ * low pass filters, center frequency, etc based on the signal envelope,
+ * and its bandwidth. While we might be using here the V4L2_STD_*
+ * types, plus DVB delsys, that doesn't seem to be the better thing to
+ * do, as:
+ *	1) it would require 64 bits for V4L2 std + 32 bits for DVB std;
+ *	2) non-TV types of envelopes won't work.
+ *
+ * So, add a separate enum to describe the possible types of SDR envelopes.
+ */
+	V4L2_TUNER_SDR_RADIO = 10,	/* Generic non-optimized Radio range */
+	V4L2_TUNER_SDR_ATV,		/* Optimize for Analog TV */
+	V4L2_TUNER_SDR_DTV_ATSC,	/* Optimize for Digital TV, ATSC */
+	V4L2_TUNER_SDR_DTV_DVBT,	/* Optimize for Digital TV, DVB-T */
+	V4L2_TUNER_SDR_DTV_ISDBT,	/* Optimize for Digital TV, ISDB-T */
 };
 
 enum v4l2_memory {
@@ -1291,6 +1307,7 @@ struct v4l2_querymenu {
 /*
  *	T U N I N G
  */
+
 struct v4l2_tuner {
 	__u32                   index;
 	__u8			name[32];
@@ -1298,11 +1315,26 @@ struct v4l2_tuner {
 	__u32			capability;
 	__u32			rangelow;
 	__u32			rangehigh;
-	__u32			rxsubchans;
-	__u32			audmode;
+
+	union {
+		/* non-SDR tuners */
+		struct {
+			__u32	rxsubchans;
+			__u32	audmode;
+		};
+		/* SDR tuners - audio demod data makes no sense here */
+		struct {
+			__u32	sample_rate;	/* Sample rate, in Hz */
+			__u32	bandwidth;	/* Bandwidth, in Hz */
+		};
+	};
+
 	__s32			signal;
 	__s32			afc;
-	__u32			reserved[4];
+
+		__u32	int_freq;	/* Read Only - IF used, in Hz */
+	/* non-SDR tuners */
+	__u32		reserved[3];
 };
 
 struct v4l2_modulator {
-- 
1.8.1.4

