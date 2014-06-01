Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59654 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaFADjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 23:39:23 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 03/18] v4l: Support extending the v4l2_pix_format structure
Date: Sun,  1 Jun 2014 05:39:22 +0200
Message-Id: <1401593977-30660-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_pix_format structure has no reserved field. It is embedded in
the v4l2_framebuffer structure which has no reserved fields either, and
in the v4l2_format structure which has reserved fields that were not
previously required to be zeroed out by applications.

To allow extending v4l2_pix_format, inline it in the v4l2_framebuffer
structure, and use the priv field as a magic value to indicate that the
application has set all v4l2_pix_format extended fields and zeroed all
reserved fields following the v4l2_pix_format field in the v4l2_format
structure.

The availability of this API extension is reported to userspace through
the new V4L2_CAP_EXT_PIX_FORMAT capability flag. Just checking that the
priv field is still set to the magic value at [GS]_FMT return wouldn't
be enough, as older kernels don't zero the priv field on return.

To simplify the internal API towards drivers zero the extended fields
and set the priv field to the magic value for applications not aware of
the extensions.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/Makefile               |  2 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         | 25 +++++++--
 Documentation/DocBook/media/v4l/v4l2.xml           |  8 +++
 .../DocBook/media/v4l/vidioc-querycap.xml          |  6 +++
 drivers/media/parport/bw-qcam.c                    |  2 -
 drivers/media/pci/cx18/cx18-ioctl.c                |  1 -
 drivers/media/pci/cx25821/cx25821-video.c          |  3 --
 drivers/media/pci/ivtv/ivtv-ioctl.c                |  3 --
 drivers/media/pci/meye/meye.c                      |  2 -
 drivers/media/pci/saa7134/saa7134-empress.c        |  3 --
 drivers/media/pci/saa7134/saa7134-video.c          |  2 -
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  1 -
 drivers/media/platform/coda.c                      |  2 -
 drivers/media/platform/davinci/vpif_display.c      |  1 -
 drivers/media/platform/mem2mem_testdev.c           |  1 -
 drivers/media/platform/omap/omap_vout.c            |  2 -
 drivers/media/platform/sh_veu.c                    |  2 -
 drivers/media/platform/vino.c                      |  5 --
 drivers/media/platform/vivi.c                      |  1 -
 drivers/media/usb/cx231xx/cx231xx-417.c            |  2 -
 drivers/media/usb/cx231xx/cx231xx-video.c          |  2 -
 drivers/media/usb/gspca/gspca.c                    |  8 +--
 drivers/media/usb/hdpvr/hdpvr-video.c              |  1 -
 drivers/media/usb/stkwebcam/stk-webcam.c           |  2 -
 drivers/media/usb/tlg2300/pd-video.c               |  1 -
 drivers/media/usb/tm6000/tm6000-video.c            |  2 -
 drivers/media/usb/zr364xx/zr364xx.c                |  3 --
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      | 19 +++++--
 drivers/media/v4l2-core/v4l2-ioctl.c               | 61 ++++++++++++++++++++--
 include/uapi/linux/videodev2.h                     | 15 +++++-
 30 files changed, 126 insertions(+), 62 deletions(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 1d27f0a..494da94 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -174,7 +174,7 @@ FILENAME = \
 DOCUMENTED = \
 	-e "s/\(enum *\)v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type\)/\1<link linkend=\"\2\">v4l2_mpeg_cx2341x_video_\2<\/link>/g" \
 	-e "s/\(\(enum\|struct\) *\)\(v4l2_[a-zA-Z0-9_]*\)/\1<link linkend=\"\3\">\3<\/link>/g" \
-	-e "s/\(V4L2_PIX_FMT_[A-Z0-9_]\+\) /<link linkend=\"\1\">\1<\/link> /g" \
+	-e "s/\(V4L2_PIX_FMT_[A-Z0-9_]\+\)\(\s\+v4l2_fourcc\)/<link linkend=\"\1\">\1<\/link>\2/g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
 	-e "s/v4l2\-mpeg\-vbi\-ITV0/v4l2-mpeg-vbi-itv0-1/g"
 
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 91dcbc8..8c56cacd 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -112,9 +112,28 @@ see <xref linkend="colorspaces" />.</entry>
 	<row>
 	  <entry>__u32</entry>
 	  <entry><structfield>priv</structfield></entry>
-	  <entry>Reserved for custom (driver defined) additional
-information about formats. When not used drivers and applications must
-set this field to zero.</entry>
+	  <entry><para>This field indicates whether the remaining fields of the
+<structname>v4l2_pix_format</structname> structure, also called the extended
+fields, are valid. When set to <constant>V4L2_PIX_FMT_PRIV_MAGIC</constant>, it
+indicates that the extended fields have been correctly initialized. When set to
+any other value it indicates that the extended fields contain undefined values.
+</para>
+<para>Applications that wish to use the pixel format extended fields must first
+ensure that the feature is supported by querying the device for the
+<link linkend="querycap"><constant>V4L2_CAP_EXT_PIX_FORMAT</constant></link>
+capability. If the capability isn't set the pixel format extended fields are not
+supported and using the extended fields will lead to undefined results.</para>
+<para>To use the extended fields, applications must set the
+<structfield>priv</structfield> field to
+<constant>V4L2_PIX_FMT_PRIV_MAGIC</constant>, initialize all the extended fields
+and zero the unused bytes of the <structname>v4l2_format</structname>
+<structfield>raw_data</structfield> field.</para>
+<para>When the <structfield>priv</structfield> field isn't set to
+<constant>V4L2_PIX_FMT_PRIV_MAGIC</constant> drivers must act as if all the
+extended fields were set to zero. On return drivers must set the
+<structfield>priv</structfield> field to
+<constant>V4L2_PIX_FMT_PRIV_MAGIC</constant> and all the extended field to
+applicable values.</para></entry>
 	</row>
       </tbody>
     </tgroup>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index b445161..d0a48be 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -152,6 +152,14 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.16</revnumber>
+	<date>2014-05-27</date>
+	<authorinitials>lp</authorinitials>
+	<revremark>Extended &v4l2-pix-format;.
+	</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>3.15</revnumber>
 	<date>2014-02-03</date>
 	<authorinitials>hv, ap</authorinitials>
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index 370d49d..d0c5e60 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -302,6 +302,12 @@ modulator programming see
 <link linkend="sdr">SDR Capture</link> interface.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CAP_EXT_PIX_FORMAT</constant></entry>
+	    <entry>0x00200000</entry>
+	    <entry>The device supports the &v4l2-pix-format; extended
+fields.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CAP_READWRITE</constant></entry>
 	    <entry>0x01000000</entry>
 	    <entry>The device supports the <link
diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index 416507a..67fff38 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -759,7 +759,6 @@ static int qcam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 	pix->sizeimage = pix->width * pix->height;
 	/* Just a guess */
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
-	pix->priv = 0;
 	return 0;
 }
 
@@ -785,7 +784,6 @@ static int qcam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format
 	pix->sizeimage = pix->width * pix->height;
 	/* Just a guess */
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
-	pix->priv = 0;
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index fefb2cd..6f2b590 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -156,7 +156,6 @@ static int cx18_g_fmt_vid_cap(struct file *file, void *fh,
 	pixfmt->height = cx->cxhdl.height;
 	pixfmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pixfmt->field = V4L2_FIELD_INTERLACED;
-	pixfmt->priv = 0;
 	if (id->type == CX18_ENC_STREAM_TYPE_YUV) {
 		pixfmt->pixelformat = s->pixelformat;
 		pixfmt->sizeimage = s->vb_bytes_per_frame;
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index d270819..c7ae087 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -576,7 +576,6 @@ static int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = (chan->width * chan->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = chan->height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -615,7 +614,6 @@ static int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -867,7 +865,6 @@ static int cx25821_vidioc_try_fmt_vid_out(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
 	return 0;
 }
 
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index b3667a0..3e0cb77 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -351,7 +351,6 @@ static int ivtv_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 	pixfmt->height = itv->cxhdl.height;
 	pixfmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pixfmt->field = V4L2_FIELD_INTERLACED;
-	pixfmt->priv = 0;
 	if (id->type == IVTV_ENC_STREAM_TYPE_YUV) {
 		pixfmt->pixelformat = V4L2_PIX_FMT_HM12;
 		/* YUV size is (Y=(h*720) + UV=(h*(720/2))) */
@@ -418,7 +417,6 @@ static int ivtv_g_fmt_vid_out(struct file *file, void *fh, struct v4l2_format *f
 	pixfmt->height = itv->main_rect.height;
 	pixfmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pixfmt->field = V4L2_FIELD_INTERLACED;
-	pixfmt->priv = 0;
 	if (id->type == IVTV_DEC_STREAM_TYPE_YUV) {
 		switch (itv->yuv_info.lace_mode & IVTV_YUV_MODE_MASK) {
 		case IVTV_YUV_MODE_INTERLACED:
@@ -1384,7 +1382,6 @@ static int ivtv_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *fb)
 	fb->fmt.bytesperline = fb->fmt.width;
 	fb->fmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	fb->fmt.field = V4L2_FIELD_INTERLACED;
-	fb->fmt.priv = 0;
 	if (fb->fmt.pixelformat != V4L2_PIX_FMT_PAL8)
 		fb->fmt.bytesperline *= 2;
 	if (fb->fmt.pixelformat == V4L2_PIX_FMT_RGB32 ||
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 54d5c82..4e7fba0 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1166,7 +1166,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *fh,
 	f->fmt.pix.sizeimage = f->fmt.pix.height *
 			       f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -1232,7 +1231,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
 	f->fmt.pix.sizeimage = f->fmt.pix.height *
 			       f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = 0;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index e65c760..ab020fa 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -130,7 +130,6 @@ static int empress_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -148,7 +147,6 @@ static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -166,7 +164,6 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
 	f->fmt.pix.bytesperline = 0;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index d375999..0cfa2ca 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1235,7 +1235,6 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
 	return 0;
 }
 
@@ -1315,7 +1314,6 @@ static int saa7134_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index d2abd3b..e264460 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -640,7 +640,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.width * 2 * f->fmt.pix.height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
 	return 0;
 }
 
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index b178379..5488660 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -613,8 +613,6 @@ static int coda_try_fmt(struct coda_ctx *ctx, struct coda_codec *codec,
 		BUG();
 	}
 
-	f->fmt.pix.priv = 0;
-
 	return 0;
 }
 
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 5bb085b..042607a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -648,7 +648,6 @@ static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 	pixfmt->width = common->fmt.fmt.pix.width;
 	pixfmt->height = common->fmt.fmt.pix.height;
 	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height * 2;
-	pixfmt->priv = 0;
 
 	return 0;
 }
diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 0714070..c1b03cf 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -532,7 +532,6 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct m2mtest_fmt *fmt)
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 9a726ea..2d177fa 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -165,7 +165,6 @@ static int omap_vout_try_format(struct v4l2_pix_format *pix)
 
 	pix->pixelformat = omap_formats[ifmt].pixelformat;
 	pix->field = V4L2_FIELD_ANY;
-	pix->priv = 0;
 
 	switch (pix->pixelformat) {
 	case V4L2_PIX_FMT_YUYV:
@@ -1896,7 +1895,6 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 	pix->field = V4L2_FIELD_ANY;
 	pix->bytesperline = pix->width * 2;
 	pix->sizeimage = pix->bytesperline * pix->height;
-	pix->priv = 0;
 	pix->colorspace = V4L2_COLORSPACE_JPEG;
 
 	vout->bpp = RGB565_BPP;
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 744e43b..8dc279d 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -425,7 +425,6 @@ static int sh_veu_g_fmt(struct sh_veu_file *veu_file, struct v4l2_format *f)
 	pix->bytesperline	= vfmt->bytesperline;
 	pix->sizeimage		= vfmt->bytesperline * pix->height *
 		vfmt->fmt->depth / vfmt->fmt->ydepth;
-	pix->priv		= 0;
 	dev_dbg(veu->dev, "%s(): type: %d, size %u @ %ux%u, fmt %x\n", __func__,
 		f->type, pix->sizeimage, pix->width, pix->height, pix->pixelformat);
 
@@ -473,7 +472,6 @@ static int sh_veu_try_fmt(struct v4l2_format *f, const struct sh_veu_format *fmt
 
 	pix->pixelformat	= fmt->fourcc;
 	pix->colorspace		= sh_veu_4cc2cspace(pix->pixelformat);
-	pix->priv		= 0;
 
 	pr_debug("%s(): type: %d, size %u\n", __func__, f->type, pix->sizeimage);
 
diff --git a/drivers/media/platform/vino.c b/drivers/media/platform/vino.c
index 470d353..91d44ea1 100644
--- a/drivers/media/platform/vino.c
+++ b/drivers/media/platform/vino.c
@@ -3147,7 +3147,6 @@ static int vino_try_fmt_vid_cap(struct file *file, void *__fh,
 	pf->colorspace =
 		vino_data_formats[tempvcs.data_format].colorspace;
 
-	pf->priv = 0;
 	return 0;
 }
 
@@ -3175,8 +3174,6 @@ static int vino_g_fmt_vid_cap(struct file *file, void *__fh,
 	pf->colorspace =
 		vino_data_formats[vcs->data_format].colorspace;
 
-	pf->priv = 0;
-
 	spin_unlock_irqrestore(&vino_drvdata->input_lock, flags);
 	return 0;
 }
@@ -3219,8 +3216,6 @@ static int vino_s_fmt_vid_cap(struct file *file, void *__fh,
 	pf->colorspace =
 		vino_data_formats[vcs->data_format].colorspace;
 
-	pf->priv = 0;
-
 	spin_unlock_irqrestore(&vino_drvdata->input_lock, flags);
 	return 0;
 }
diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index d00bf3d..23480e7 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -1014,7 +1014,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	else
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
-	f->fmt.pix.priv = 0;
 	return 0;
 }
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 30a0c69..7982440 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1563,7 +1563,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width = dev->ts1.width;
 	f->fmt.pix.height = dev->ts1.height;
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
-	f->fmt.pix.priv = 0;
 	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d\n",
 		dev->ts1.width, dev->ts1.height);
 	dprintk(3, "exit vidioc_g_fmt_vid_cap()\n");
@@ -1582,7 +1581,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.sizeimage = mpeglines * mpeglinesize;
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.priv = 0;
 	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d\n",
 		dev->ts1.width, dev->ts1.height);
 	dprintk(3, "exit vidioc_try_fmt_vid_cap()\n");
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 1f87513..8f489fa 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -886,7 +886,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -931,7 +930,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index f3a7ace..1b3d7bf 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1102,8 +1102,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	fmt->fmt.pix = gspca_dev->pixfmt;
-	/* some drivers use priv internally, zero it before giving it to
-	   userspace */
+	/* some drivers use priv internally, zero it before giving it back to
+	   the core */
 	fmt->fmt.pix.priv = 0;
 	return 0;
 }
@@ -1139,8 +1139,8 @@ static int try_fmt_vid_cap(struct gspca_dev *gspca_dev,
 		fmt->fmt.pix.height = h;
 		gspca_dev->sd_desc->try_fmt(gspca_dev, fmt);
 	}
-	/* some drivers use priv internally, zero it before giving it to
-	   userspace */
+	/* some drivers use priv internally, zero it before giving it back to
+	   the core */
 	fmt->fmt.pix.priv = 0;
 	return mode;			/* used when s_fmt */
 }
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 0500c417..cf9a21e 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -1022,7 +1022,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *_fh,
 	f->fmt.pix.pixelformat	= V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage	= dev->bulk_in_size;
 	f->fmt.pix.bytesperline	= 0;
-	f->fmt.pix.priv		= 0;
 	if (f->fmt.pix.width == 720) {
 		/* SDTV formats */
 		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index be77482..adfa832 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -923,7 +923,6 @@ static int stk_vidioc_g_fmt_vid_cap(struct file *filp,
 		pix_format->bytesperline = 2 * pix_format->width;
 	pix_format->sizeimage = pix_format->bytesperline
 				* pix_format->height;
-	pix_format->priv = 0;
 	return 0;
 }
 
@@ -967,7 +966,6 @@ static int stk_try_fmt_vid_cap(struct file *filp,
 		fmtd->fmt.pix.bytesperline = 2 * fmtd->fmt.pix.width;
 	fmtd->fmt.pix.sizeimage = fmtd->fmt.pix.bytesperline
 		* fmtd->fmt.pix.height;
-	fmtd->fmt.pix.priv = 0;
 	return 0;
 }
 
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 8df668d..8cd7f02 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -1321,7 +1321,6 @@ static void init_video_context(struct running_context *context)
 				.bytesperline	= 720 * 2,
 				.sizeimage	= 720 * 576 * 2,
 				.colorspace	= V4L2_COLORSPACE_SMPTE170M,
-				.priv		= 0
 			};
 }
 
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index e6b3d5d..1626e9b 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -918,7 +918,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 		(f->fmt.pix.width * fh->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
-	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -959,7 +958,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width &= ~0x01;
 
 	f->fmt.pix.field = field;
-	f->fmt.pix.priv = 0;
 
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fmt->depth) >> 3;
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 74d56df..0f63954 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -806,7 +806,6 @@ static int zr364xx_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
-	f->fmt.pix.priv = 0;
 	DBG("%s: V4L2_PIX_FMT_%s (%d) ok!\n", __func__,
 	    decode_fourcc(f->fmt.pix.pixelformat, pixelformat_name),
 	    f->fmt.pix.field);
@@ -829,7 +828,6 @@ static int zr364xx_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
-	f->fmt.pix.priv = 0;
 	return 0;
 }
 
@@ -866,7 +864,6 @@ static int zr364xx_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
-	f->fmt.pix.priv = 0;
 	cam->vb_vidq.field = f->fmt.pix.field;
 
 	if (f->fmt.pix.width == 160 && f->fmt.pix.height == 120)
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 7e2411c..5470484 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -540,7 +540,16 @@ struct v4l2_framebuffer32 {
 	__u32			capability;
 	__u32			flags;
 	compat_caddr_t 		base;
-	struct v4l2_pix_format	fmt;
+	struct {
+		__u32		width;
+		__u32		height;
+		__u32		pixelformat;
+		__u32		field;
+		__u32		bytesperline;
+		__u32		sizeimage;
+		__u32		colorspace;
+		__u32		priv;
+	} fmt;
 };
 
 static int get_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_framebuffer32 __user *up)
@@ -550,10 +559,10 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_framebuffer32)) ||
 		get_user(tmp, &up->base) ||
 		get_user(kp->capability, &up->capability) ||
-		get_user(kp->flags, &up->flags))
+		get_user(kp->flags, &up->flags) ||
+		copy_from_user(&kp->fmpt, &up->fmt, sizeof(up->fmt)))
 			return -EFAULT;
 	kp->base = compat_ptr(tmp);
-	get_v4l2_pix_format(&kp->fmt, &up->fmt);
 	return 0;
 }
 
@@ -564,9 +573,9 @@ static int put_v4l2_framebuffer32(struct v4l2_framebuffer *kp, struct v4l2_frame
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_framebuffer32)) ||
 		put_user(tmp, &up->base) ||
 		put_user(kp->capability, &up->capability) ||
-		put_user(kp->flags, &up->flags))
+		put_user(kp->flags, &up->flags) ||
+		copy_to_user(&up->fmt, &kp->fmt, sizeof(up->fmt)))
 			return -EFAULT;
-	put_v4l2_pix_format(&kp->fmt, &up->fmt);
 	return 0;
 }
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 16bffd8..01b4588 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -959,13 +959,48 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	return -EINVAL;
 }
 
+static void v4l_sanitize_format(struct v4l2_format *fmt)
+{
+	unsigned int offset;
+
+	/*
+	 * The v4l2_pix_format structure has been extended with fields that were
+	 * not previously required to be set to zero by applications. The priv
+	 * field, when set to a magic value, indicates the the extended fields
+	 * are valid. Otherwise they will contain undefined values. To simplify
+	 * the API towards drivers zero the extended fields and set the priv
+	 * field to the magic value when the extended pixel format structure
+	 * isn't used by applications.
+	 */
+
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    fmt->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return;
+
+	if (fmt->fmt.pix.priv == V4L2_PIX_FMT_PRIV_MAGIC)
+		return;
+
+	fmt->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+
+	offset = offsetof(struct v4l2_pix_format, priv)
+	       + sizeof(fmt->fmt.pix.priv);
+	memset(((void *)&fmt->fmt.pix) + offset, 0,
+	       sizeof(fmt->fmt.pix) - offset);
+}
+
 static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
+	int ret;
 
 	cap->version = LINUX_VERSION_CODE;
-	return ops->vidioc_querycap(file, fh, cap);
+
+	ret = ops->vidioc_querycap(file, fh, cap);
+
+	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
+
+	return ret;
 }
 
 static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
@@ -1089,12 +1124,17 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
+	int ret;
+
+	v4l_sanitize_format(p);
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
 			break;
-		return ops->vidioc_g_fmt_vid_cap(file, fh, arg);
+		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
+		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap_mplane))
 			break;
@@ -1114,7 +1154,9 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out))
 			break;
-		return ops->vidioc_g_fmt_vid_out(file, fh, arg);
+		ret = ops->vidioc_g_fmt_vid_out(file, fh, arg);
+		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out_mplane))
 			break;
@@ -1502,7 +1544,18 @@ static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_create_buffers *create = arg;
 	int ret = check_fmt(file, create->format.type);
 
-	return ret ? ret : ops->vidioc_create_bufs(file, fh, create);
+	if (ret)
+		return ret;
+
+	v4l_sanitize_format(&create->format);
+
+	ret = ops->vidioc_create_bufs(file, fh, create);
+
+	if (create->format.type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    create->format.type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		create->format.fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+
+	return ret;
 }
 
 static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 0125f4d..2656a94 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -268,6 +268,7 @@ struct v4l2_capability {
 #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
 
 #define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
+#define V4L2_CAP_EXT_PIX_FORMAT		0x00200000  /* Supports the extended pixel format */
 
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
@@ -448,6 +449,9 @@ struct v4l2_pix_format {
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
 #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6') /* IQ u16le */
 
+/* priv field value to indicates that subsequent fields are valid. */
+#define V4L2_PIX_FMT_PRIV_MAGIC		0xdeadbeef
+
 /*
  *	F O R M A T   E N U M E R A T I O N
  */
@@ -752,7 +756,16 @@ struct v4l2_framebuffer {
 /* FIXME: in theory we should pass something like PCI device + memory
  * region + offset instead of some physical address */
 	void                    *base;
-	struct v4l2_pix_format	fmt;
+	struct {
+		__u32		width;
+		__u32		height;
+		__u32		pixelformat;
+		__u32		field;		/* enum v4l2_field */
+		__u32		bytesperline;	/* for padding, zero if unused */
+		__u32		sizeimage;
+		__u32		colorspace;	/* enum v4l2_colorspace */
+		__u32		priv;		/* private data, depends on pixelformat */
+	} fmt;
 };
 /*  Flags for the 'capability' field. Read only */
 #define V4L2_FBUF_CAP_EXTERNOVERLAY	0x0001
-- 
1.8.5.5

