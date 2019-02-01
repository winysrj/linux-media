Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C6FC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B123F218AC
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 14:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549031564;
	bh=AbMZTHrjBX5gXghFKqsvzl6Mc3sAJTGG5JqiWQ6gbP4=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=Er0lQIT6/+5GWoVkdSkmvoAUGGWjJ7NdmaWDDUIHUpSm1dsyBXFTHmVs84pMKOVXd
	 Vs45r573k/hS8jwps06hkVwMfwXtQjeIK9aizQ8XD3AlOWoOM+FGYXO9+5WT/vDA0A
	 yM+ZJRdUMRw08vGuXhToQjLI0NimT2l16BW86Xzw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfBAOco (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 09:32:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfBAOco (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 09:32:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QHupHoMEiqezdDAryBC6kROxPIqCTk7WxaqF0Wdj7EY=; b=GALZe6kI50vnRoFrDYfAfUucp
        I6z7haOscA/wDDNsMZI4SrIcmDde1RZ7FTsFYUKKk2IgQy3ov6HazYDdxBd5a/Kq88OboqPWVPWpV
        uhgWMS7a7RLNtG/qP+TkRZHdtlFJN7uWcuhVxnIS68dYlDF8CJG4nVIFx43VhNWZPZbvd2xSp71Td
        AlfqMRormZN4TUqqgTUid0v+7HA9knsggStYmwCtzrJ+Z3Xpdjv/reLIashcPhrj1Qfz8UrNWrfCE
        K3LAVPYF2VFx2EiOPR1p436acy0iUquXCvmzDjHM8mb162Fi3chSWps3475i8+dZTDA1nJE4oI7EC
        cpLh7MuPg==;
Received: from 179.187.106.61.dynamic.adsl.gvt.net.br ([179.187.106.61] helo=silica.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gpZs2-0001yP-RS; Fri, 01 Feb 2019 14:32:43 +0000
Date:   Fri, 1 Feb 2019 12:32:39 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     linux-media@vger.kernel.org, gstreamer-devel@freedesktop.org
Subject: Gstreamer and vim2m with bayer capture formats
Message-ID: <20190201123239.7d4eacfb@silica.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Nicolas,

I just added a patch for the vim2m Kernel driver to also support bayer formats,
but only in capture mode:

	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=vim2m&id=7fd6ccf110b7c167a2304ffd482e6c04252c4909

The goal here is to be able to use vim2m to simulate a webcam. Creating
a bayer output is trivial, but converting from bayer to RGB is a way more
complex, and probably not too useful for this Kernel testing driver. So, 
I opted to not implement bayer conversion only for the V4L2 output mode
(with is actually the m2m input).

After such patch and the ones that I merged yesterday at the linux-media
development git tree, what we have is:

	$ v4l2-ctl --list-formats --list-formats-out
	ioctl: VIDIOC_ENUM_FMT
	Type: Video Capture

	[0]: 'RGBP' (16-bit RGB 5-6-5)
	[1]: 'RGBR' (16-bit RGB 5-6-5 BE)
	[2]: 'RGB3' (24-bit RGB 8-8-8)
	[3]: 'BGR3' (24-bit BGR 8-8-8)
	[4]: 'YUYV' (YUYV 4:2:2)
	[5]: 'BA81' (8-bit Bayer BGBG/GRGR)
	[6]: 'GBRG' (8-bit Bayer GBGB/RGRG)
	[7]: 'GRBG' (8-bit Bayer GRGR/BGBG)
	[8]: 'RGGB' (8-bit Bayer RGRG/GBGB)

	ioctl: VIDIOC_ENUM_FMT
	Type: Video Output

	[0]: 'RGBP' (16-bit RGB 5-6-5)
	[1]: 'RGBR' (16-bit RGB 5-6-5 BE)
	[2]: 'RGB3' (24-bit RGB 8-8-8)
	[3]: 'BGR3' (24-bit BGR 8-8-8)
	[4]: 'YUYV' (YUYV 4:2:2)

With that, I got two problems with gstreamer V4L2 plugin:

1) Right now, it only creates a v4l2video?convert source if a M2M device
is symmetric, e. g. exactly the same set of formats should be supported by 
both capture and output types. That was never a V4L2 API requirement. 

Actually, vim2m capture driver had always asymmetric formats since when m2m
support was introduced. It only became symmetric for a short period of
time (this week) when I added more formats to it. Yet, after my new patch
(planned to be merged next week), it will be asymmetric again.

So, the enclosed patch is required (or something similar) in order to fix
gstreamer with regards to V4L2 M2M API support.

With such patch applied, and building it with --enable-v4l2-plugin, the
gst V4L2 plugin works with a pipeline like:

	$ gst-launch-1.0 videotestsrc ! video/x-raw,format=BGR ! v4l2video0convert disable-passthrough=1 extra-controls="s,horizontal_flip=1,vertical_flip=1" ! video/x-raw,format=BGR ! videoconvert ! fpsdisplaysink

2) I'm not sure how to use gstreamer to use a bayer format for capture type.

I tried this:

	$ gst-launch-1.0 videotestsrc ! video/x-raw,format=BGR ! v4l2video0convert disable-passthrough=1 extra-controls="s,horizontal_flip=1,vertical_flip=1" ! video/x-bayer,format=bggr ! bayer2rgb ! videoconvert ! fpsdisplaysink

But it failed:
	Setting pipeline to PAUSED ...
	failed to open /usr/lib64/dri/hybrid_drv_video.so
	Not using hybrid_drv_video.so
	failed to open /usr/lib64/dri/hybrid_drv_video.so
	Not using hybrid_drv_video.so
	Pipeline is PREROLLING ...
	Got context from element 'fps-display-video_sink-actual-sink-vaapi': gst.vaapi.Display=context, gst.vaapi.Display=(GstVaapiDisplay)"\(GstVaapiDisplayGLX\)\ vaapidisplayglx1";
	ERROR: from element /GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0: Internal data stream error.
	Additional debug info:
	gstbasesrc.c(3055): gst_base_src_loop (): /GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0:
	streaming stopped, reason not-negotiated (-4)
	ERROR: pipeline doesn't want to preroll.
	Setting pipeline to NULL ...
	Freeing pipeline ...

PS.: I'm sure that the vim2m is working fine with bayer, as I tested it with:

	$ qvidcap -p &
	$ for i in BA81 GBRRG GRBG RGGB; do v4l2-ctl --stream-mmap --stream-out-mmap --stream-to-host localhost --stream-lossless --stream-out-hor-speed 1 -v pixelformat=$i --stream-count 40; done

Cheers,
Mauro

diff --git a/sys/v4l2/gstv4l2.c b/sys/v4l2/gstv4l2.c
index 2674d9cd3449..9031de657d71 100644
--- a/sys/v4l2/gstv4l2.c
+++ b/sys/v4l2/gstv4l2.c
@@ -204,7 +204,7 @@ gst_v4l2_probe_and_register (GstPlugin * plugin)
       if (gst_v4l2_is_vp9_enc (sink_caps, src_caps))
         gst_v4l2_vp9_enc_register (plugin, basename, it->device_path,
             sink_caps, src_caps);
-    } else if (gst_v4l2_is_transform (sink_caps, src_caps)) {
+    } else {
       gst_v4l2_transform_register (plugin, basename, it->device_path,
           sink_caps, src_caps);
     }
diff --git a/sys/v4l2/gstv4l2transform.c b/sys/v4l2/gstv4l2transform.c
index e92f984ff40a..487b7750d17b 100644
--- a/sys/v4l2/gstv4l2transform.c
+++ b/sys/v4l2/gstv4l2transform.c
@@ -1171,17 +1171,6 @@ gst_v4l2_transform_subclass_init (gpointer g_class, gpointer data)
 }
 
 /* Probing functions */
-gboolean
-gst_v4l2_is_transform (GstCaps * sink_caps, GstCaps * src_caps)
-{
-  gboolean ret = FALSE;
-
-  if (gst_caps_is_subset (sink_caps, gst_v4l2_object_get_raw_caps ())
-      && gst_caps_is_subset (src_caps, gst_v4l2_object_get_raw_caps ()))
-    ret = TRUE;
-
-  return ret;
-}
 
 void
 gst_v4l2_transform_register (GstPlugin * plugin, const gchar * basename,
diff --git a/sys/v4l2/gstv4l2transform.h b/sys/v4l2/gstv4l2transform.h
index 29f3f3c655b7..afdc289db545 100644
--- a/sys/v4l2/gstv4l2transform.h
+++ b/sys/v4l2/gstv4l2transform.h
@@ -73,7 +73,6 @@ struct _GstV4l2TransformClass
 
 GType gst_v4l2_transform_get_type (void);
 
-gboolean gst_v4l2_is_transform       (GstCaps * sink_caps, GstCaps * src_caps);
 void     gst_v4l2_transform_register (GstPlugin * plugin,
                                       const gchar *basename,
                                       const gchar *device_path,

