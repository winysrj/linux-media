Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43995 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965403AbcIHMEW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 21/47] [media] v4l2-ioctl.h: document the remaining functions
Date: Thu,  8 Sep 2016 09:03:43 -0300
Message-Id: <ba44af1297c92bfd4589bd41130f213b44ffe1e9.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several undocumented functions here; document them.

While here, make checkpatch.pl happy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/conf_nitpick.py |   1 +
 include/media/v4l2-ioctl.h          | 502 +++++++++++++++++++++---------------
 2 files changed, 301 insertions(+), 202 deletions(-)

diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index 1c7928abace5..1f3ef3ded2d4 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -96,5 +96,6 @@ nitpick_ignore = [
     ("c:type", "__user"),
     ("c:type", "usb_device"),
     ("c:type", "usb_interface"),
+    ("c:type", "v4l2_std_id"),
     ("c:type", "video_system_t"),
 ]
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 8b1d19bc9b0e..574ff2ae94be 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -287,273 +287,286 @@ struct v4l2_ioctl_ops {
 	/* ioctl callbacks */
 
 	/* VIDIOC_QUERYCAP handler */
-	int (*vidioc_querycap)(struct file *file, void *fh, struct v4l2_capability *cap);
+	int (*vidioc_querycap)(struct file *file, void *fh,
+			       struct v4l2_capability *cap);
 
 	/* VIDIOC_ENUM_FMT handlers */
-	int (*vidioc_enum_fmt_vid_cap)     (struct file *file, void *fh,
-					    struct v4l2_fmtdesc *f);
-	int (*vidioc_enum_fmt_vid_overlay) (struct file *file, void *fh,
-					    struct v4l2_fmtdesc *f);
-	int (*vidioc_enum_fmt_vid_out)     (struct file *file, void *fh,
-					    struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_vid_cap)(struct file *file, void *fh,
+				       struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_vid_overlay)(struct file *file, void *fh,
+					   struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_vid_out)(struct file *file, void *fh,
+				       struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_vid_cap_mplane)(struct file *file, void *fh,
 					      struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_vid_out_mplane)(struct file *file, void *fh,
 					      struct v4l2_fmtdesc *f);
-	int (*vidioc_enum_fmt_sdr_cap)     (struct file *file, void *fh,
-					    struct v4l2_fmtdesc *f);
-	int (*vidioc_enum_fmt_sdr_out)     (struct file *file, void *fh,
-					    struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_sdr_cap)(struct file *file, void *fh,
+				       struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_sdr_out)(struct file *file, void *fh,
+				       struct v4l2_fmtdesc *f);
 
 	/* VIDIOC_G_FMT handlers */
-	int (*vidioc_g_fmt_vid_cap)    (struct file *file, void *fh,
-					struct v4l2_format *f);
+	int (*vidioc_g_fmt_vid_cap)(struct file *file, void *fh,
+				    struct v4l2_format *f);
 	int (*vidioc_g_fmt_vid_overlay)(struct file *file, void *fh,
 					struct v4l2_format *f);
-	int (*vidioc_g_fmt_vid_out)    (struct file *file, void *fh,
-					struct v4l2_format *f);
+	int (*vidioc_g_fmt_vid_out)(struct file *file, void *fh,
+				    struct v4l2_format *f);
 	int (*vidioc_g_fmt_vid_out_overlay)(struct file *file, void *fh,
-					struct v4l2_format *f);
-	int (*vidioc_g_fmt_vbi_cap)    (struct file *file, void *fh,
-					struct v4l2_format *f);
-	int (*vidioc_g_fmt_vbi_out)    (struct file *file, void *fh,
-					struct v4l2_format *f);
+					    struct v4l2_format *f);
+	int (*vidioc_g_fmt_vbi_cap)(struct file *file, void *fh,
+				    struct v4l2_format *f);
+	int (*vidioc_g_fmt_vbi_out)(struct file *file, void *fh,
+				    struct v4l2_format *f);
 	int (*vidioc_g_fmt_sliced_vbi_cap)(struct file *file, void *fh,
-					struct v4l2_format *f);
+					   struct v4l2_format *f);
 	int (*vidioc_g_fmt_sliced_vbi_out)(struct file *file, void *fh,
-					struct v4l2_format *f);
+					   struct v4l2_format *f);
 	int (*vidioc_g_fmt_vid_cap_mplane)(struct file *file, void *fh,
 					   struct v4l2_format *f);
 	int (*vidioc_g_fmt_vid_out_mplane)(struct file *file, void *fh,
 					   struct v4l2_format *f);
-	int (*vidioc_g_fmt_sdr_cap)    (struct file *file, void *fh,
-					struct v4l2_format *f);
-	int (*vidioc_g_fmt_sdr_out)    (struct file *file, void *fh,
-					struct v4l2_format *f);
+	int (*vidioc_g_fmt_sdr_cap)(struct file *file, void *fh,
+				    struct v4l2_format *f);
+	int (*vidioc_g_fmt_sdr_out)(struct file *file, void *fh,
+				    struct v4l2_format *f);
 
 	/* VIDIOC_S_FMT handlers */
-	int (*vidioc_s_fmt_vid_cap)    (struct file *file, void *fh,
-					struct v4l2_format *f);
+	int (*vidioc_s_fmt_vid_cap)(struct file *file, void *fh,
+				    struct v4l2_format *f);
 	int (*vidioc_s_fmt_vid_overlay)(struct file *file, void *fh,
 					struct v4l2_format *f);
-	int (*vidioc_s_fmt_vid_out)    (struct file *file, void *fh,
-					struct v4l2_format *f);
+	int (*vidioc_s_fmt_vid_out)(struct file *file, void *fh,
+				    struct v4l2_format *f);
 	int (*vidioc_s_fmt_vid_out_overlay)(struct file *file, void *fh,
-					struct v4l2_format *f);
-	int (*vidioc_s_fmt_vbi_cap)    (struct file *file, void *fh,
-					struct v4l2_format *f);
-	int (*vidioc_s_fmt_vbi_out)    (struct file *file, void *fh,
-					struct v4l2_format *f);
+					    struct v4l2_format *f);
+	int (*vidioc_s_fmt_vbi_cap)(struct file *file, void *fh,
+				    struct v4l2_format *f);
+	int (*vidioc_s_fmt_vbi_out)(struct file *file, void *fh,
+				    struct v4l2_format *f);
 	int (*vidioc_s_fmt_sliced_vbi_cap)(struct file *file, void *fh,
-					struct v4l2_format *f);
+					   struct v4l2_format *f);
 	int (*vidioc_s_fmt_sliced_vbi_out)(struct file *file, void *fh,
-					struct v4l2_format *f);
+					   struct v4l2_format *f);
 	int (*vidioc_s_fmt_vid_cap_mplane)(struct file *file, void *fh,
 					   struct v4l2_format *f);
 	int (*vidioc_s_fmt_vid_out_mplane)(struct file *file, void *fh,
 					   struct v4l2_format *f);
-	int (*vidioc_s_fmt_sdr_cap)    (struct file *file, void *fh,
-					struct v4l2_format *f);
-	int (*vidioc_s_fmt_sdr_out)    (struct file *file, void *fh,
-					struct v4l2_format *f);
+	int (*vidioc_s_fmt_sdr_cap)(struct file *file, void *fh,
+				    struct v4l2_format *f);
+	int (*vidioc_s_fmt_sdr_out)(struct file *file, void *fh,
+				    struct v4l2_format *f);
 
 	/* VIDIOC_TRY_FMT handlers */
-	int (*vidioc_try_fmt_vid_cap)    (struct file *file, void *fh,
-					  struct v4l2_format *f);
+	int (*vidioc_try_fmt_vid_cap)(struct file *file, void *fh,
+				      struct v4l2_format *f);
 	int (*vidioc_try_fmt_vid_overlay)(struct file *file, void *fh,
 					  struct v4l2_format *f);
-	int (*vidioc_try_fmt_vid_out)    (struct file *file, void *fh,
-					  struct v4l2_format *f);
+	int (*vidioc_try_fmt_vid_out)(struct file *file, void *fh,
+				      struct v4l2_format *f);
 	int (*vidioc_try_fmt_vid_out_overlay)(struct file *file, void *fh,
-					  struct v4l2_format *f);
-	int (*vidioc_try_fmt_vbi_cap)    (struct file *file, void *fh,
-					  struct v4l2_format *f);
-	int (*vidioc_try_fmt_vbi_out)    (struct file *file, void *fh,
-					  struct v4l2_format *f);
+					     struct v4l2_format *f);
+	int (*vidioc_try_fmt_vbi_cap)(struct file *file, void *fh,
+				      struct v4l2_format *f);
+	int (*vidioc_try_fmt_vbi_out)(struct file *file, void *fh,
+				      struct v4l2_format *f);
 	int (*vidioc_try_fmt_sliced_vbi_cap)(struct file *file, void *fh,
-					  struct v4l2_format *f);
+					     struct v4l2_format *f);
 	int (*vidioc_try_fmt_sliced_vbi_out)(struct file *file, void *fh,
-					  struct v4l2_format *f);
+					     struct v4l2_format *f);
 	int (*vidioc_try_fmt_vid_cap_mplane)(struct file *file, void *fh,
 					     struct v4l2_format *f);
 	int (*vidioc_try_fmt_vid_out_mplane)(struct file *file, void *fh,
 					     struct v4l2_format *f);
-	int (*vidioc_try_fmt_sdr_cap)    (struct file *file, void *fh,
-					  struct v4l2_format *f);
-	int (*vidioc_try_fmt_sdr_out)    (struct file *file, void *fh,
-					  struct v4l2_format *f);
+	int (*vidioc_try_fmt_sdr_cap)(struct file *file, void *fh,
+				      struct v4l2_format *f);
+	int (*vidioc_try_fmt_sdr_out)(struct file *file, void *fh,
+				      struct v4l2_format *f);
 
 	/* Buffer handlers */
-	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
-	int (*vidioc_querybuf)(struct file *file, void *fh, struct v4l2_buffer *b);
-	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
-	int (*vidioc_expbuf)  (struct file *file, void *fh,
-				struct v4l2_exportbuffer *e);
-	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
+	int (*vidioc_reqbufs)(struct file *file, void *fh,
+			      struct v4l2_requestbuffers *b);
+	int (*vidioc_querybuf)(struct file *file, void *fh,
+			       struct v4l2_buffer *b);
+	int (*vidioc_qbuf)(struct file *file, void *fh,
+			   struct v4l2_buffer *b);
+	int (*vidioc_expbuf)(struct file *file, void *fh,
+			     struct v4l2_exportbuffer *e);
+	int (*vidioc_dqbuf)(struct file *file, void *fh,
+			    struct v4l2_buffer *b);
 
-	int (*vidioc_create_bufs)(struct file *file, void *fh, struct v4l2_create_buffers *b);
-	int (*vidioc_prepare_buf)(struct file *file, void *fh, struct v4l2_buffer *b);
+	int (*vidioc_create_bufs)(struct file *file, void *fh,
+				  struct v4l2_create_buffers *b);
+	int (*vidioc_prepare_buf)(struct file *file, void *fh,
+				  struct v4l2_buffer *b);
 
-	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
-	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
-				struct v4l2_framebuffer *a);
-	int (*vidioc_s_fbuf)   (struct file *file, void *fh,
-				const struct v4l2_framebuffer *a);
+	int (*vidioc_overlay)(struct file *file, void *fh, unsigned int i);
+	int (*vidioc_g_fbuf)(struct file *file, void *fh,
+			     struct v4l2_framebuffer *a);
+	int (*vidioc_s_fbuf)(struct file *file, void *fh,
+			     const struct v4l2_framebuffer *a);
 
 		/* Stream on/off */
-	int (*vidioc_streamon) (struct file *file, void *fh, enum v4l2_buf_type i);
-	int (*vidioc_streamoff)(struct file *file, void *fh, enum v4l2_buf_type i);
+	int (*vidioc_streamon)(struct file *file, void *fh,
+			       enum v4l2_buf_type i);
+	int (*vidioc_streamoff)(struct file *file, void *fh,
+				enum v4l2_buf_type i);
 
-		/* Standard handling
-			ENUMSTD is handled by videodev.c
+		/*
+		 * Standard handling
+		 *
+		 * Note: ENUMSTD is handled by videodev.c
 		 */
-	int (*vidioc_g_std) (struct file *file, void *fh, v4l2_std_id *norm);
-	int (*vidioc_s_std) (struct file *file, void *fh, v4l2_std_id norm);
-	int (*vidioc_querystd) (struct file *file, void *fh, v4l2_std_id *a);
+	int (*vidioc_g_std)(struct file *file, void *fh, v4l2_std_id *norm);
+	int (*vidioc_s_std)(struct file *file, void *fh, v4l2_std_id norm);
+	int (*vidioc_querystd)(struct file *file, void *fh, v4l2_std_id *a);
 
 		/* Input handling */
 	int (*vidioc_enum_input)(struct file *file, void *fh,
 				 struct v4l2_input *inp);
-	int (*vidioc_g_input)   (struct file *file, void *fh, unsigned int *i);
-	int (*vidioc_s_input)   (struct file *file, void *fh, unsigned int i);
+	int (*vidioc_g_input)(struct file *file, void *fh, unsigned int *i);
+	int (*vidioc_s_input)(struct file *file, void *fh, unsigned int i);
 
 		/* Output handling */
-	int (*vidioc_enum_output) (struct file *file, void *fh,
+	int (*vidioc_enum_output)(struct file *file, void *fh,
 				  struct v4l2_output *a);
-	int (*vidioc_g_output)   (struct file *file, void *fh, unsigned int *i);
-	int (*vidioc_s_output)   (struct file *file, void *fh, unsigned int i);
+	int (*vidioc_g_output)(struct file *file, void *fh, unsigned int *i);
+	int (*vidioc_s_output)(struct file *file, void *fh, unsigned int i);
 
 		/* Control handling */
-	int (*vidioc_queryctrl)        (struct file *file, void *fh,
-					struct v4l2_queryctrl *a);
-	int (*vidioc_query_ext_ctrl)   (struct file *file, void *fh,
-					struct v4l2_query_ext_ctrl *a);
-	int (*vidioc_g_ctrl)           (struct file *file, void *fh,
-					struct v4l2_control *a);
-	int (*vidioc_s_ctrl)           (struct file *file, void *fh,
-					struct v4l2_control *a);
-	int (*vidioc_g_ext_ctrls)      (struct file *file, void *fh,
-					struct v4l2_ext_controls *a);
-	int (*vidioc_s_ext_ctrls)      (struct file *file, void *fh,
-					struct v4l2_ext_controls *a);
-	int (*vidioc_try_ext_ctrls)    (struct file *file, void *fh,
-					struct v4l2_ext_controls *a);
-	int (*vidioc_querymenu)        (struct file *file, void *fh,
-					struct v4l2_querymenu *a);
+	int (*vidioc_queryctrl)(struct file *file, void *fh,
+				struct v4l2_queryctrl *a);
+	int (*vidioc_query_ext_ctrl)(struct file *file, void *fh,
+				     struct v4l2_query_ext_ctrl *a);
+	int (*vidioc_g_ctrl)(struct file *file, void *fh,
+			     struct v4l2_control *a);
+	int (*vidioc_s_ctrl)(struct file *file, void *fh,
+			     struct v4l2_control *a);
+	int (*vidioc_g_ext_ctrls)(struct file *file, void *fh,
+				  struct v4l2_ext_controls *a);
+	int (*vidioc_s_ext_ctrls)(struct file *file, void *fh,
+				  struct v4l2_ext_controls *a);
+	int (*vidioc_try_ext_ctrls)(struct file *file, void *fh,
+				    struct v4l2_ext_controls *a);
+	int (*vidioc_querymenu)(struct file *file, void *fh,
+				struct v4l2_querymenu *a);
 
 	/* Audio ioctls */
-	int (*vidioc_enumaudio)        (struct file *file, void *fh,
-					struct v4l2_audio *a);
-	int (*vidioc_g_audio)          (struct file *file, void *fh,
-					struct v4l2_audio *a);
-	int (*vidioc_s_audio)          (struct file *file, void *fh,
-					const struct v4l2_audio *a);
+	int (*vidioc_enumaudio)(struct file *file, void *fh,
+				struct v4l2_audio *a);
+	int (*vidioc_g_audio)(struct file *file, void *fh,
+			      struct v4l2_audio *a);
+	int (*vidioc_s_audio)(struct file *file, void *fh,
+			      const struct v4l2_audio *a);
 
 	/* Audio out ioctls */
-	int (*vidioc_enumaudout)       (struct file *file, void *fh,
-					struct v4l2_audioout *a);
-	int (*vidioc_g_audout)         (struct file *file, void *fh,
-					struct v4l2_audioout *a);
-	int (*vidioc_s_audout)         (struct file *file, void *fh,
-					const struct v4l2_audioout *a);
-	int (*vidioc_g_modulator)      (struct file *file, void *fh,
-					struct v4l2_modulator *a);
-	int (*vidioc_s_modulator)      (struct file *file, void *fh,
-					const struct v4l2_modulator *a);
+	int (*vidioc_enumaudout)(struct file *file, void *fh,
+				 struct v4l2_audioout *a);
+	int (*vidioc_g_audout)(struct file *file, void *fh,
+			       struct v4l2_audioout *a);
+	int (*vidioc_s_audout)(struct file *file, void *fh,
+			       const struct v4l2_audioout *a);
+	int (*vidioc_g_modulator)(struct file *file, void *fh,
+				  struct v4l2_modulator *a);
+	int (*vidioc_s_modulator)(struct file *file, void *fh,
+				  const struct v4l2_modulator *a);
 	/* Crop ioctls */
-	int (*vidioc_cropcap)          (struct file *file, void *fh,
-					struct v4l2_cropcap *a);
-	int (*vidioc_g_crop)           (struct file *file, void *fh,
-					struct v4l2_crop *a);
-	int (*vidioc_s_crop)           (struct file *file, void *fh,
-					const struct v4l2_crop *a);
-	int (*vidioc_g_selection)      (struct file *file, void *fh,
-					struct v4l2_selection *s);
-	int (*vidioc_s_selection)      (struct file *file, void *fh,
-					struct v4l2_selection *s);
+	int (*vidioc_cropcap)(struct file *file, void *fh,
+			      struct v4l2_cropcap *a);
+	int (*vidioc_g_crop)(struct file *file, void *fh,
+			     struct v4l2_crop *a);
+	int (*vidioc_s_crop)(struct file *file, void *fh,
+			     const struct v4l2_crop *a);
+	int (*vidioc_g_selection)(struct file *file, void *fh,
+				  struct v4l2_selection *s);
+	int (*vidioc_s_selection)(struct file *file, void *fh,
+				  struct v4l2_selection *s);
 	/* Compression ioctls */
-	int (*vidioc_g_jpegcomp)       (struct file *file, void *fh,
-					struct v4l2_jpegcompression *a);
-	int (*vidioc_s_jpegcomp)       (struct file *file, void *fh,
-					const struct v4l2_jpegcompression *a);
-	int (*vidioc_g_enc_index)      (struct file *file, void *fh,
-					struct v4l2_enc_idx *a);
-	int (*vidioc_encoder_cmd)      (struct file *file, void *fh,
-					struct v4l2_encoder_cmd *a);
-	int (*vidioc_try_encoder_cmd)  (struct file *file, void *fh,
-					struct v4l2_encoder_cmd *a);
-	int (*vidioc_decoder_cmd)      (struct file *file, void *fh,
-					struct v4l2_decoder_cmd *a);
-	int (*vidioc_try_decoder_cmd)  (struct file *file, void *fh,
-					struct v4l2_decoder_cmd *a);
+	int (*vidioc_g_jpegcomp)(struct file *file, void *fh,
+				 struct v4l2_jpegcompression *a);
+	int (*vidioc_s_jpegcomp)(struct file *file, void *fh,
+				 const struct v4l2_jpegcompression *a);
+	int (*vidioc_g_enc_index)(struct file *file, void *fh,
+				  struct v4l2_enc_idx *a);
+	int (*vidioc_encoder_cmd)(struct file *file, void *fh,
+				  struct v4l2_encoder_cmd *a);
+	int (*vidioc_try_encoder_cmd)(struct file *file, void *fh,
+				      struct v4l2_encoder_cmd *a);
+	int (*vidioc_decoder_cmd)(struct file *file, void *fh,
+				  struct v4l2_decoder_cmd *a);
+	int (*vidioc_try_decoder_cmd)(struct file *file, void *fh,
+				      struct v4l2_decoder_cmd *a);
 
 	/* Stream type-dependent parameter ioctls */
-	int (*vidioc_g_parm)           (struct file *file, void *fh,
-					struct v4l2_streamparm *a);
-	int (*vidioc_s_parm)           (struct file *file, void *fh,
-					struct v4l2_streamparm *a);
+	int (*vidioc_g_parm)(struct file *file, void *fh,
+			     struct v4l2_streamparm *a);
+	int (*vidioc_s_parm)(struct file *file, void *fh,
+			     struct v4l2_streamparm *a);
 
 	/* Tuner ioctls */
-	int (*vidioc_g_tuner)          (struct file *file, void *fh,
-					struct v4l2_tuner *a);
-	int (*vidioc_s_tuner)          (struct file *file, void *fh,
-					const struct v4l2_tuner *a);
-	int (*vidioc_g_frequency)      (struct file *file, void *fh,
-					struct v4l2_frequency *a);
-	int (*vidioc_s_frequency)      (struct file *file, void *fh,
-					const struct v4l2_frequency *a);
-	int (*vidioc_enum_freq_bands) (struct file *file, void *fh,
-				    struct v4l2_frequency_band *band);
+	int (*vidioc_g_tuner)(struct file *file, void *fh,
+			      struct v4l2_tuner *a);
+	int (*vidioc_s_tuner)(struct file *file, void *fh,
+			      const struct v4l2_tuner *a);
+	int (*vidioc_g_frequency)(struct file *file, void *fh,
+				  struct v4l2_frequency *a);
+	int (*vidioc_s_frequency)(struct file *file, void *fh,
+				  const struct v4l2_frequency *a);
+	int (*vidioc_enum_freq_bands)(struct file *file, void *fh,
+				      struct v4l2_frequency_band *band);
 
 	/* Sliced VBI cap */
-	int (*vidioc_g_sliced_vbi_cap) (struct file *file, void *fh,
-					struct v4l2_sliced_vbi_cap *a);
+	int (*vidioc_g_sliced_vbi_cap)(struct file *file, void *fh,
+				       struct v4l2_sliced_vbi_cap *a);
 
 	/* Log status ioctl */
-	int (*vidioc_log_status)       (struct file *file, void *fh);
+	int (*vidioc_log_status)(struct file *file, void *fh);
 
-	int (*vidioc_s_hw_freq_seek)   (struct file *file, void *fh,
-					const struct v4l2_hw_freq_seek *a);
+	int (*vidioc_s_hw_freq_seek)(struct file *file, void *fh,
+				     const struct v4l2_hw_freq_seek *a);
 
 	/* Debugging ioctls */
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	int (*vidioc_g_register)       (struct file *file, void *fh,
-					struct v4l2_dbg_register *reg);
-	int (*vidioc_s_register)       (struct file *file, void *fh,
-					const struct v4l2_dbg_register *reg);
+	int (*vidioc_g_register)(struct file *file, void *fh,
+				 struct v4l2_dbg_register *reg);
+	int (*vidioc_s_register)(struct file *file, void *fh,
+				 const struct v4l2_dbg_register *reg);
 
-	int (*vidioc_g_chip_info)      (struct file *file, void *fh,
-					struct v4l2_dbg_chip_info *chip);
+	int (*vidioc_g_chip_info)(struct file *file, void *fh,
+				  struct v4l2_dbg_chip_info *chip);
 #endif
 
-	int (*vidioc_enum_framesizes)   (struct file *file, void *fh,
-					 struct v4l2_frmsizeenum *fsize);
+	int (*vidioc_enum_framesizes)(struct file *file, void *fh,
+				      struct v4l2_frmsizeenum *fsize);
 
-	int (*vidioc_enum_frameintervals) (struct file *file, void *fh,
-					   struct v4l2_frmivalenum *fival);
+	int (*vidioc_enum_frameintervals)(struct file *file, void *fh,
+					  struct v4l2_frmivalenum *fival);
 
 	/* DV Timings IOCTLs */
-	int (*vidioc_s_dv_timings) (struct file *file, void *fh,
-				    struct v4l2_dv_timings *timings);
-	int (*vidioc_g_dv_timings) (struct file *file, void *fh,
-				    struct v4l2_dv_timings *timings);
-	int (*vidioc_query_dv_timings) (struct file *file, void *fh,
-				    struct v4l2_dv_timings *timings);
-	int (*vidioc_enum_dv_timings) (struct file *file, void *fh,
-				    struct v4l2_enum_dv_timings *timings);
-	int (*vidioc_dv_timings_cap) (struct file *file, void *fh,
-				    struct v4l2_dv_timings_cap *cap);
-	int (*vidioc_g_edid) (struct file *file, void *fh, struct v4l2_edid *edid);
-	int (*vidioc_s_edid) (struct file *file, void *fh, struct v4l2_edid *edid);
+	int (*vidioc_s_dv_timings)(struct file *file, void *fh,
+				   struct v4l2_dv_timings *timings);
+	int (*vidioc_g_dv_timings)(struct file *file, void *fh,
+				   struct v4l2_dv_timings *timings);
+	int (*vidioc_query_dv_timings)(struct file *file, void *fh,
+				       struct v4l2_dv_timings *timings);
+	int (*vidioc_enum_dv_timings)(struct file *file, void *fh,
+				      struct v4l2_enum_dv_timings *timings);
+	int (*vidioc_dv_timings_cap)(struct file *file, void *fh,
+				     struct v4l2_dv_timings_cap *cap);
+	int (*vidioc_g_edid)(struct file *file, void *fh,
+			     struct v4l2_edid *edid);
+	int (*vidioc_s_edid)(struct file *file, void *fh,
+			     struct v4l2_edid *edid);
 
-	int (*vidioc_subscribe_event)  (struct v4l2_fh *fh,
-					const struct v4l2_event_subscription *sub);
+	int (*vidioc_subscribe_event)(struct v4l2_fh *fh,
+				      const struct v4l2_event_subscription *sub);
 	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
 					const struct v4l2_event_subscription *sub);
 
 	/* For other private ioctls */
-	long (*vidioc_default)	       (struct file *file, void *fh,
-					bool valid_prio, unsigned int cmd, void *arg);
+	long (*vidioc_default)(struct file *file, void *fh,
+			       bool valid_prio, unsigned int cmd, void *arg);
 };
 
 
@@ -573,38 +586,123 @@ struct v4l2_ioctl_ops {
 #define V4L2_DEV_DEBUG_POLL		0x10
 
 /*  Video standard functions  */
-extern const char *v4l2_norm_to_name(v4l2_std_id id);
-extern void v4l2_video_std_frame_period(int id, struct v4l2_fract *frameperiod);
-extern int v4l2_video_std_construct(struct v4l2_standard *vs,
+
+/**
+ * v4l2_norm_to_name - Ancillary routine to analog TV standard name from its ID.
+ *
+ * @id:	analog TV standard ID.
+ *
+ * Return: returns a string with the name of the analog TV standard.
+ * If the standard is not found or if @id points to multiple standard,
+ * it returns "Unknown".
+ */
+const char *v4l2_norm_to_name(v4l2_std_id id);
+
+/**
+ * v4l2_video_std_frame_period - Ancillary routine that fills a
+ *	struct &v4l2_fract pointer with the default framerate fraction.
+ *
+ * @id: analog TV sdandard ID.
+ * @frameperiod: struct &v4l2_fract pointer to be filled
+ *
+ */
+void v4l2_video_std_frame_period(int id, struct v4l2_fract *frameperiod);
+
+/**
+ * v4l2_video_std_construct - Ancillary routine that fills in the fields of
+ *	a &v4l2_standard structure according to the @id parameter.
+ *
+ * @vs: struct &v4l2_standard pointer to be filled
+ * @id: analog TV sdandard ID.
+ * @name: name of the standard to be used
+ *
+ * .. note::
+ *
+ *    This ancillary routine is obsolete. Shouldn't be used on newer drivers.
+ */
+int v4l2_video_std_construct(struct v4l2_standard *vs,
 				    int id, const char *name);
-/* Prints the ioctl in a human-readable format. If prefix != NULL,
-   then do printk(KERN_DEBUG "%s: ", prefix) first. */
-extern void v4l_printk_ioctl(const char *prefix, unsigned int cmd);
 
-/* Internal use only: get the mutex (if any) that we need to lock for the
-   given command. */
+/**
+ * v4l_printk_ioctl - Ancillary routine that prints the ioctl in a
+ *	human-readable format.
+ *
+ * @prefix: prefix to be added at the ioctl prints.
+ * @cmd: ioctl name
+ *
+ * .. note::
+ *
+ *    If prefix != %NULL, then it will issue a
+ *    ``printk(KERN_DEBUG "%s: ", prefix)`` first.
+ */
+void v4l_printk_ioctl(const char *prefix, unsigned int cmd);
+
 struct video_device;
-extern struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned cmd);
+
+
+/**
+ * v4l2_ioctl_get_lock - get the mutex (if any) that it is need to lock for
+ *	a given command.
+ *
+ * @vdev: Pointer to struct &video_device.
+ * @cmd: Ioctl name.
+ *
+ * .. note:: Internal use only. Should not be used outside V4L2 core.
+ */
+struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned int cmd);
 
 /* names for fancy debug output */
 extern const char *v4l2_field_names[];
 extern const char *v4l2_type_names[];
 
 #ifdef CONFIG_COMPAT
-/* 32 Bits compatibility layer for 64 bits processors */
-extern long v4l2_compat_ioctl32(struct file *file, unsigned int cmd,
-				unsigned long arg);
+/**
+ * v4l2_compat_ioctl32 -32 Bits compatibility layer for 64 bits processors
+ *
+ * @file: Pointer to struct &file.
+ * @cmd: Ioctl name.
+ * @arg: Ioctl argument.
+ */
+long int v4l2_compat_ioctl32(struct file *file, unsigned int cmd,
+			     unsigned long arg);
 #endif
 
-typedef long (*v4l2_kioctl)(struct file *file,
-		unsigned int cmd, void *arg);
+/**
+ * typedef v4l2_kioctl - Typedef used to pass an ioctl handler.
+ *
+ * @file: Pointer to struct &file.
+ * @cmd: Ioctl name.
+ * @arg: Ioctl argument.
+ */
+typedef long (*v4l2_kioctl)(struct file *file, unsigned int cmd, void *arg);
 
-/* Include support for obsoleted stuff */
-extern long video_usercopy(struct file *file, unsigned int cmd,
-				unsigned long arg, v4l2_kioctl func);
+/**
+ * video_usercopy - copies data from/to userspace memory when an ioctl is
+ *	issued.
+ *
+ * @file: Pointer to struct &file.
+ * @cmd: Ioctl name.
+ * @arg: Ioctl argument.
+ * @func: function that will handle the ioctl
+ *
+ * .. note::
+ *
+ *    This routine should be used only inside the V4L2 core.
+ */
+long int video_usercopy(struct file *file, unsigned int cmd,
+			unsigned long int arg, v4l2_kioctl func);
 
-/* Standard handlers for V4L ioctl's */
-extern long video_ioctl2(struct file *file,
-			unsigned int cmd, unsigned long arg);
+/**
+ * video_ioctl2 - Handles a V4L2 ioctl.
+ *
+ * @file: Pointer to struct &file.
+ * @cmd: Ioctl name.
+ * @arg: Ioctl argument.
+ *
+ * Method used to hancle an ioctl. Should be used to fill the
+ * &v4l2_ioctl_ops.unlocked_ioctl on all V4L2 drivers.
+ */
+long int video_ioctl2(struct file *file,
+		      unsigned int cmd, unsigned long int arg);
 
 #endif /* _V4L2_IOCTL_H */
-- 
2.7.4


