Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE09C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 17:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AE95218AC
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549043714;
	bh=Kt3WlSnFeKR6haN7rWioOpN8q9mcrzorvFIxREkisEQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Ak+glki9N3tVAIism6IHrsmTK+XSfJC1p4KKeNoqv+VCGSG199Sz6gy1AP7bMzg4i
	 B/1deJv7I8ZOH/wllQefsJoyC0imUBkqDqTXEcwRblOmnM9v4HQCCEZ+cUuOoahYBc
	 fLi09ww/8Y0lTqNj/qZCAC3qAAfVOwtLRYP7EF8w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbfBARzO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 12:55:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbfBARzN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 12:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aZkQiZVJdYM9gDP7bBbs6NxST63v2H3K6kYH1HWy5Ko=; b=QeY8r60j8JYiy+mHjfzSoyU0s
        VH7cOZ8ldSbaUr2LVwEdmJ2L036zwgPPO3fxY0pupYuEnZ/YNGLhw73LkzEccOBsLaGoaQZj1xUNb
        6+5szyhW57BfH+iFhx13czzXjzDFjkNEMlMdJsiwxrTZXjvIoLtc5aBs1vH7N4omKsK+4Kh/q5u8O
        uEQqz01vg8jgMD2NkQ62cNo3ML1jk41vcxw//VvSmbjO2WAY9JzNRo96UCi2ri9xkPG2v8AQ3H3/V
        zQ8Zs2DeU3Z11Lxu/tLzwvtl5XSQgAfXIpMLoRhxJ5Im6WMwINb0PzRCP2hF9NmavWIp+CTRNTQyD
        O8Fvod4vQ==;
Received: from 179.187.106.61.dynamic.adsl.gvt.net.br ([179.187.106.61] helo=silica.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gpd20-0007eJ-DV; Fri, 01 Feb 2019 17:55:12 +0000
Date:   Fri, 1 Feb 2019 15:55:06 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     linux-media@vger.kernel.org, gstreamer-devel@freedesktop.org
Subject: Re: Gstreamer and vim2m with bayer capture formats
Message-ID: <20190201155506.76354195@silica.lan>
In-Reply-To: <f253a1ac6af48b03e6e49ef46af3aef8e77a3186.camel@ndufresne.ca>
References: <20190201123239.7d4eacfb@silica.lan>
        <f253a1ac6af48b03e6e49ef46af3aef8e77a3186.camel@ndufresne.ca>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 01 Feb 2019 12:03:49 -0500
Nicolas Dufresne <nicolas@ndufresne.ca> escreveu:

> Le vendredi 01 f=C3=A9vrier 2019 =C3=A0 12:32 -0200, Mauro Carvalho Cheha=
b a
> =C3=A9crit :
> > Hi Nicolas,
> >=20
> > I just added a patch for the vim2m Kernel driver to also support bayer =
formats,
> > but only in capture mode:
> >=20
> > 	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=3Dvim2m&id=
=3D7fd6ccf110b7c167a2304ffd482e6c04252c4909
> >=20
> > The goal here is to be able to use vim2m to simulate a webcam. Creating
> > a bayer output is trivial, but converting from bayer to RGB is a way mo=
re
> > complex, and probably not too useful for this Kernel testing driver. So=
,=20
> > I opted to not implement bayer conversion only for the V4L2 output mode
> > (with is actually the m2m input).
> >=20
> > After such patch and the ones that I merged yesterday at the linux-media
> > development git tree, what we have is:
> >=20
> > 	$ v4l2-ctl --list-formats --list-formats-out
> > 	ioctl: VIDIOC_ENUM_FMT
> > 	Type: Video Capture
> >=20
> > 	[0]: 'RGBP' (16-bit RGB 5-6-5)
> > 	[1]: 'RGBR' (16-bit RGB 5-6-5 BE)
> > 	[2]: 'RGB3' (24-bit RGB 8-8-8)
> > 	[3]: 'BGR3' (24-bit BGR 8-8-8)
> > 	[4]: 'YUYV' (YUYV 4:2:2)
> > 	[5]: 'BA81' (8-bit Bayer BGBG/GRGR)
> > 	[6]: 'GBRG' (8-bit Bayer GBGB/RGRG)
> > 	[7]: 'GRBG' (8-bit Bayer GRGR/BGBG)
> > 	[8]: 'RGGB' (8-bit Bayer RGRG/GBGB)
> >=20
> > 	ioctl: VIDIOC_ENUM_FMT
> > 	Type: Video Output
> >=20
> > 	[0]: 'RGBP' (16-bit RGB 5-6-5)
> > 	[1]: 'RGBR' (16-bit RGB 5-6-5 BE)
> > 	[2]: 'RGB3' (24-bit RGB 8-8-8)
> > 	[3]: 'BGR3' (24-bit BGR 8-8-8)
> > 	[4]: 'YUYV' (YUYV 4:2:2)
> >=20
> > With that, I got two problems with gstreamer V4L2 plugin:
> >=20
> > 1) Right now, it only creates a v4l2video?convert source if a M2M device
> > is symmetric, e. g. exactly the same set of formats should be supported=
 by=20
> > both capture and output types. That was never a V4L2 API requirement.  =
=20
>=20
> Not exactly a question of symmetry. The v4l2transform element is means
> for RAW video processors, so the classification heuristic is that all
> input and output formats must be RAW video.
>=20
> What I believe the bug might be is that the bayer formats may not have
> been classified as RAW video (they are not considered RAW in GStreamer
> at the moment).

Ah, I see. What happens if a single m2m device could convert from non-raw
and raw formats? As a large amount of m2m devices actually map into some
ISP, with is fimware-based, nothing really prevents someone to implement
a m2m device that would accept a wide range of formats as input and
output (both raw and non-raw).

So, it would be possible to have one of such devices doing weird
things like supporting, as input, RGB, YUV, Bayer, MJPEG, and H.264
and a similar set (probably not identical) as output.

So, one could set it, for example, to convert from MJPEG to H.264.

With the current model, V4L2 plugin won't be able to map it
(as it won't match the current concept of encoder, decoder or=20
transform).

IMO, it would make sense to keep encoders and decoders as is,
to be used only when it is clearly a simple format encoding or
decoding, using v4l2transform for anything else.

>=20
> >=20
> > Actually, vim2m capture driver had always asymmetric formats since when=
 m2m
> > support was introduced. It only became symmetric for a short period of
> > time (this week) when I added more formats to it. Yet, after my new pat=
ch
> > (planned to be merged next week), it will be asymmetric again. =20
>=20
> Again, it has nothing to do with symmetry.
>=20
> >=20
> > So, the enclosed patch is required (or something similar) in order to f=
ix
> > gstreamer with regards to V4L2 M2M API support.
> >=20
> > With such patch applied, and building it with --enable-v4l2-plugin, the
> > gst V4L2 plugin works with a pipeline like:
> >=20
> > 	$ gst-launch-1.0 videotestsrc ! video/x-raw,format=3DBGR ! v4l2video0c=
onvert disable-passthrough=3D1 extra-controls=3D"s,horizontal_flip=3D1,vert=
ical_flip=3D1" ! video/x-raw,format=3DBGR ! videoconvert ! fpsdisplaysink
> >=20
> > 2) I'm not sure how to use gstreamer to use a bayer format for capture =
type.
> >=20
> > I tried this:
> >=20
> > 	$ gst-launch-1.0 videotestsrc ! video/x-raw,format=3DBGR ! v4l2video0c=
onvert disable-passthrough=3D1 extra-controls=3D"s,horizontal_flip=3D1,vert=
ical_flip=3D1" ! video/x-bayer,format=3Dbggr ! bayer2rgb ! videoconvert ! f=
psdisplaysink
> >=20
> > But it failed:
> > 	Setting pipeline to PAUSED ...
> > 	failed to open /usr/lib64/dri/hybrid_drv_video.so
> > 	Not using hybrid_drv_video.so
> > 	failed to open /usr/lib64/dri/hybrid_drv_video.so
> > 	Not using hybrid_drv_video.so
> > 	Pipeline is PREROLLING ...
> > 	Got context from element 'fps-display-video_sink-actual-sink-vaapi': g=
st.vaapi.Display=3Dcontext, gst.vaapi.Display=3D(GstVaapiDisplay)"\(GstVaap=
iDisplayGLX\)\ vaapidisplayglx1";
> > 	ERROR: from element /GstPipeline:pipeline0/GstVideoTestSrc:videotestsr=
c0: Internal data stream error.
> > 	Additional debug info:
> > 	gstbasesrc.c(3055): gst_base_src_loop (): /GstPipeline:pipeline0/GstVi=
deoTestSrc:videotestsrc0:
> > 	streaming stopped, reason not-negotiated (-4)
> > 	ERROR: pipeline doesn't want to preroll.
> > 	Setting pipeline to NULL ...
> > 	Freeing pipeline ...
> >=20
> > PS.: I'm sure that the vim2m is working fine with bayer, as I tested it=
 with:
> >=20
> > 	$ qvidcap -p &
> > 	$ for i in BA81 GBRRG GRBG RGGB; do v4l2-ctl --stream-mmap --stream-ou=
t-mmap --stream-to-host localhost --stream-lossless --stream-out-hor-speed =
1 -v pixelformat=3D$i --stream-count 40; done
> >=20
> > Cheers,
> > Mauro
> >=20
> > diff --git a/sys/v4l2/gstv4l2.c b/sys/v4l2/gstv4l2.c
> > index 2674d9cd3449..9031de657d71 100644
> > --- a/sys/v4l2/gstv4l2.c
> > +++ b/sys/v4l2/gstv4l2.c
> > @@ -204,7 +204,7 @@ gst_v4l2_probe_and_register (GstPlugin * plugin)
> >        if (gst_v4l2_is_vp9_enc (sink_caps, src_caps))
> >          gst_v4l2_vp9_enc_register (plugin, basename, it->device_path,
> >              sink_caps, src_caps);
> > -    } else if (gst_v4l2_is_transform (sink_caps, src_caps)) {
> > +    } else {
> >        gst_v4l2_transform_register (plugin, basename, it->device_path,
> >            sink_caps, src_caps); =20
>=20
> Of course this by-pass the classification. The intention is not that
> v4l2convert becomes a fallthrough, the reason is that the caps
> negotiation has semantic related to the expected functions the m2m
> driver will do (right now we support csc and scaling). So the intention
> is that GstV4l2Transform becomes an abstract class, and GstV4l2Convert
> would subclass it to implement csc and scaling. And then other
> specialized subclass can be made to support other type of hardware.

The problem I see is that the sky is the limit. In practice, a m2m
device maps into an entry point to an Image Signal Processor firmware,
sending them a video stream and receiving another video stream.=20

It can do multiple things at one. I mean, a single m2m device could=20
potentially do all sorts of transformation at the same time: format
changes, encoding, decoding, colorspace conversion, scaling, cropping,
frame rate interpolation/decimation, image enhancements, 3A, etc.

What a m2m device does basically depends on the imagination of the
hardware vendor, and the V4L2 API limits. Also, what it will actually
do depends on the firmware it is currently using[1].

[1] There are some already existing m2m drivers that accept different
firmwares, and depending on its version (or at the hardware release),
it exposes a different set of controls and formats.

So, I would try to stick with "just" encoding, decoding, having a generic
"transform" for all the rest.

> But before this can happen, proper API for HW function classification
> will be needed. Right now, this is all base on guessing. For the vim2m
> case, we should simply properly classify bayer format as RAW video, and
> that should solve your issue.

For the vim2m case, this would work. Yet, as vim2m was the first m2m
driver merged, and the gstreamer's issue with it is still present at
gst 1.14.4 [2], I suspect that there could be other cases where
the v4l2 plugin could not be exposing a m2m device, because it won't
fit at the simple csc/scaling use case.

[2] granted, this is not a real hardware-based m2m device, so nobody=20
should use vim2m in production, as the Kernel is not the right place
for conversions - also, the conversion logic there was broken. That
may explain why nobody fixed gstream support for it so far.

> If my change you have resources or time to work on a proper patch, be
> aware that patch submissions works through gitlab.freedesktop.org Merge
> Request (basically pushing a branch on a fork there and doing couple of
> webui clicks).

Ah, ok. Well, the intention here was just to do a RFC and check with
you about the proper solution.

While I do have a limited amount of time, due to my kernel duties,
I could try to write a different patch for it once I understand
better what should be done.

While that doesn't happen, IMHO, the best is to send RFC patches via
e-mail, as it allows c/c the discussions to the linux-media ML.

>=20
> >      }
> > diff --git a/sys/v4l2/gstv4l2transform.c b/sys/v4l2/gstv4l2transform.c
> > index e92f984ff40a..487b7750d17b 100644
> > --- a/sys/v4l2/gstv4l2transform.c
> > +++ b/sys/v4l2/gstv4l2transform.c
> > @@ -1171,17 +1171,6 @@ gst_v4l2_transform_subclass_init (gpointer g_cla=
ss, gpointer data)
> >  }
> > =20
> >  /* Probing functions */
> > -gboolean
> > -gst_v4l2_is_transform (GstCaps * sink_caps, GstCaps * src_caps)
> > -{
> > -  gboolean ret =3D FALSE;
> > -
> > -  if (gst_caps_is_subset (sink_caps, gst_v4l2_object_get_raw_caps ())
> > -      && gst_caps_is_subset (src_caps, gst_v4l2_object_get_raw_caps ()=
))
> > -    ret =3D TRUE;
> > -
> > -  return ret;
> > -}
> > =20
> >  void
> >  gst_v4l2_transform_register (GstPlugin * plugin, const gchar * basenam=
e,
> > diff --git a/sys/v4l2/gstv4l2transform.h b/sys/v4l2/gstv4l2transform.h
> > index 29f3f3c655b7..afdc289db545 100644
> > --- a/sys/v4l2/gstv4l2transform.h
> > +++ b/sys/v4l2/gstv4l2transform.h
> > @@ -73,7 +73,6 @@ struct _GstV4l2TransformClass
> > =20
> >  GType gst_v4l2_transform_get_type (void);
> > =20
> > -gboolean gst_v4l2_is_transform       (GstCaps * sink_caps, GstCaps * s=
rc_caps);
> >  void     gst_v4l2_transform_register (GstPlugin * plugin,
> >                                        const gchar *basename,
> >                                        const gchar *device_path,
> >  =20




Cheers,
Mauro
