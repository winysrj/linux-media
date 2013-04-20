Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564Ab3DTRvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 13:51:24 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3KHpO2M031520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 13:51:24 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v2 3/3] [media] V4L2 api: Add a buffer capture type for SDR
Date: Sat, 20 Apr 2013 14:51:14 -0300
Message-Id: <1366480274-31255-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366480274-31255-1-git-send-email-mchehab@redhat.com>
References: <366469499-31640-1-git-send-email-mchehab@redhat.com>
 <1366480274-31255-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As SDR devices are not video, VBI or RDS devices, it needs
its own buffer type for capture. Add it at the V4L2 API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/v4l/dev-capture.xml | 26 ++++++++++++--------
 Documentation/DocBook/media/v4l/io.xml          |  6 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c            | 32 +++++++++++++++++++++++++
 include/media/v4l2-ioctl.h                      |  8 +++++++
 include/uapi/linux/videodev2.h                  |  3 ++-
 5 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-capture.xml b/Documentation/DocBook/media/v4l/dev-capture.xml
index e1c5f94..7797d2d 100644
--- a/Documentation/DocBook/media/v4l/dev-capture.xml
+++ b/Documentation/DocBook/media/v4l/dev-capture.xml
@@ -44,7 +44,7 @@ all video capture devices.</para>
   </section>
 
   <section>
-    <title>Image Format Negotiation</title>
+    <title>Streaming Format Negotiation</title>
 
     <para>The result of a capture operation is determined by
 cropping and image format parameters. The former select an area of the
@@ -65,13 +65,18 @@ linkend="crop" />.</para>
 
     <para>To query the current image format applications set the
 <structfield>type</structfield> field of a &v4l2-format; to
-<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant> or
-<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant> and call the
-&VIDIOC-G-FMT; ioctl with a pointer to this structure. Drivers fill
-the &v4l2-pix-format; <structfield>pix</structfield> or the
-&v4l2-pix-format-mplane; <structfield>pix_mp</structfield> member of the
+<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
+<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant> or
+<constant>V4L2_BUF_TYPE_VIDEO_SDR_CAPTURE</constant> or
+and call the &VIDIOC-G-FMT; ioctl with a pointer to this structure.</para>
+
+<para>Video drivers fill the &v4l2-pix-format; <structfield>pix</structfield>
+or the &v4l2-pix-format-mplane; <structfield>pix_mp</structfield> member of the
 <structfield>fmt</structfield> union.</para>
 
+<para>SDR drivers fill the &v4l2-sdr-format; <structfield>sdr</structfield>
+member of the <structfield>fmt</structfield> union.</para>
+
     <para>To request different parameters applications set the
 <structfield>type</structfield> field of a &v4l2-format; as above and
 initialize all fields of the &v4l2-pix-format;
@@ -87,8 +92,9 @@ adjust the parameters and finally return the actual parameters as
 without disabling I/O or possibly time consuming hardware
 preparations.</para>
 
-    <para>The contents of &v4l2-pix-format; and &v4l2-pix-format-mplane;
-are discussed in <xref linkend="pixfmt" />. See also the specification of the
+    <para>The contents of &v4l2-pix-format;, &v4l2-pix-format-mplane; and
+&v4l2-sdr-format; are discussed in <xref linkend="pixfmt" />.
+See also the specification of the
 <constant>VIDIOC_G_FMT</constant>, <constant>VIDIOC_S_FMT</constant>
 and <constant>VIDIOC_TRY_FMT</constant> ioctls for details. Video
 capture devices must implement both the
@@ -100,9 +106,9 @@ returns default parameters as <constant>VIDIOC_G_FMT</constant> does.
   </section>
 
   <section>
-    <title>Reading Images</title>
+    <title>Reading streams</title>
 
-    <para>A video capture device may support the <link
+    <para>A video capture device or an SDR device may support the <link
 linkend="rw">read() function</link> and/or streaming (<link
 linkend="mmap">memory mapping</link> or <link
 linkend="userp">user pointer</link>) I/O. See <xref
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 2c4c068..0e69d31 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1005,6 +1005,12 @@ should set this to 0.</entry>
 	    <entry>Buffer for video output overlay (OSD), see <xref
 		linkend="osd" />.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant></entry>
+	    <entry>8</entry>
+	    <entry>Buffer for Software Digital Radio (SDR) receivers, see <xref
+		linkend="sdr" />.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f81bda1..127a632 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -150,6 +150,7 @@ const char *v4l2_type_names[] = {
 	[V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY] = "vid-out-overlay",
 	[V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE] = "vid-cap-mplane",
 	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE] = "vid-out-mplane",
+	[V4L2_BUF_TYPE_SDR_CAPTURE] = "vid-out-mplane",
 };
 EXPORT_SYMBOL(v4l2_type_names);
 
@@ -242,6 +243,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 	const struct v4l2_pix_format_mplane *mp;
 	const struct v4l2_vbi_format *vbi;
 	const struct v4l2_sliced_vbi_format *sliced;
+	const struct v4l2_sdr_format *sdr;
 	const struct v4l2_window *win;
 	const struct v4l2_clip *clip;
 	unsigned i;
@@ -323,6 +325,14 @@ static void v4l_print_format(const void *arg, bool write_only)
 				sliced->service_lines[0][i],
 				sliced->service_lines[1][i]);
 		break;
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		sdr = &p->fmt.sdr;
+		pr_cont("format=%c%c%c%c\n",
+			(sdr->sampleformat & 0xff),
+			(sdr->sampleformat >>  8) & 0xff,
+			(sdr->sampleformat >> 16) & 0xff,
+			(sdr->sampleformat >> 24) & 0xff);
+		break;
 	}
 }
 
@@ -898,6 +908,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -947,6 +958,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 		if (is_vbi && is_tx && ops->vidioc_g_fmt_sliced_vbi_out)
 			return 0;
 		break;
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (is_sdr && is_rx && ops->vidioc_g_fmt_sdr_cap)
+			return 0;
+		break;
 	default:
 		break;
 	}
@@ -1066,6 +1081,10 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || !ops->vidioc_enum_fmt_vid_out_mplane))
 			break;
 		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_sdr_cap))
+			break;
+		return ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1120,6 +1139,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_out))
 			break;
 		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (unlikely(!is_rx || !ops->vidioc_g_fmt_sdr_cap))
+			break;
+		return ops->vidioc_g_fmt_sdr_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1184,6 +1207,10 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (unlikely(!is_rx || !ops->vidioc_s_fmt_sdr_cap))
+			break;
+		return ops->vidioc_s_fmt_sdr_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1194,6 +1221,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_format *p = arg;
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
+	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -1248,6 +1276,10 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sliced);
 		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SDR_CAPTURE:
+		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_try_fmt_sdr_cap))
+			break;
+		return ops->vidioc_try_fmt_sdr_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 931652f..731120a 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -40,6 +40,8 @@ struct v4l2_ioctl_ops {
 					      struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_vid_out_mplane)(struct file *file, void *fh,
 					      struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_sdr_cap)(struct file *file, void *fh,
+				       struct v4l2_fmtdesc *f);
 
 	/* VIDIOC_G_FMT handlers */
 	int (*vidioc_g_fmt_vid_cap)    (struct file *file, void *fh,
@@ -62,6 +64,8 @@ struct v4l2_ioctl_ops {
 					   struct v4l2_format *f);
 	int (*vidioc_g_fmt_vid_out_mplane)(struct file *file, void *fh,
 					   struct v4l2_format *f);
+	int (*vidioc_g_fmt_sdr_cap)(struct file *file, void *fh,
+				    struct v4l2_fmtdesc *f);
 
 	/* VIDIOC_S_FMT handlers */
 	int (*vidioc_s_fmt_vid_cap)    (struct file *file, void *fh,
@@ -84,6 +88,8 @@ struct v4l2_ioctl_ops {
 					   struct v4l2_format *f);
 	int (*vidioc_s_fmt_vid_out_mplane)(struct file *file, void *fh,
 					   struct v4l2_format *f);
+	int (*vidioc_s_fmt_sdr_cap)(struct file *file, void *fh,
+				    struct v4l2_fmtdesc *f);
 
 	/* VIDIOC_TRY_FMT handlers */
 	int (*vidioc_try_fmt_vid_cap)    (struct file *file, void *fh,
@@ -106,6 +112,8 @@ struct v4l2_ioctl_ops {
 					     struct v4l2_format *f);
 	int (*vidioc_try_fmt_vid_out_mplane)(struct file *file, void *fh,
 					     struct v4l2_format *f);
+	int (*vidioc_try_fmt_sdr_cap)(struct file *file, void *fh,
+				      struct v4l2_fmtdesc *f);
 
 	/* Buffer handlers */
 	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 5d8ee92..974c49d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -139,6 +139,7 @@ enum v4l2_buf_type {
 #endif
 	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
 	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
+	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
 	/* Deprecated, do not use */
 	V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
@@ -1707,7 +1708,7 @@ struct v4l2_format {
 		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
 		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
 		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
-		struct v4l2_sdr_format		fmt;	 /* V4L2_BUF_TYPE_SDR_CAPTURE */
+		struct v4l2_sdr_format		sdr;	 /* V4L2_BUF_TYPE_SDR_CAPTURE */
 		__u8	raw_data[200];                   /* user-defined */
 	} fmt;
 };
-- 
1.8.1.4

