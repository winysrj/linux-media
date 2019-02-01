Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56172C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 17:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CA342086C
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 17:03:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="yIQke3iP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbfBARDy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 12:03:54 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41808 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730045AbfBARDy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 12:03:54 -0500
Received: by mail-qt1-f196.google.com with SMTP id l13so23278qtr.8
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2019 09:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=q5rIF+cdNhHqSLFgq+myvN5/Nndo9bzjCxFdIWOJ83A=;
        b=yIQke3iPe154R/T2VWPs7Zi+WfDREYIR8vjvsHF/MDznKrony8OEAidxjEN8f71nEw
         oyHLj7wPiRbR/4TiMsvCdPEGiKxG1fOQ4to7dR9TTAHncQ6VRXILcKnwY8Nv4xG1EHMD
         CKRKl6PlEpms7O7C5izfxi9f0BozK/f8FGQS5dsb1VMO19atIkp0ZFbAym8+89BTRgiX
         zbWXD9b4Q6gzhOw8YJrf/qMYfELuLTg0FGVW+ZbV/1vGMJJOPBbU9r4Hv/3M94s5laGs
         YxcWvv39iSPMKy2RugWGjwYZChFvIEdTQiAA/G4izXn9m3n8jE7YYNJEIn+eaKH+Ya58
         q84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=q5rIF+cdNhHqSLFgq+myvN5/Nndo9bzjCxFdIWOJ83A=;
        b=qwtvgjmyomBFHT7I0VB9r/D2rwL6aT+DQiipEycuvRPnjWbocJmXzyMU7MBvMueGrf
         MhJJ6A1ltaNmz33L/PPx4CLsk25kQHUAGXj7aiG9CU+fM91iKhl62RhN7t4n9sjML58i
         QNNPmjaWNy35ch7qA2eG+IrR4DbnYNDHVzLddIThkCpyzVCzpNHdgs9+gdVntDC3LShI
         dc/oYDI/ItMifg58oAk21XxJZLIg3s94IV7uISEi3iCO6uh/zlTkCul0bKEB5WNXfC8B
         qaX8kx/l3vEOlUUIIQtDyy7/3dnmmUf2SNO0z79LBz521tK8WmC/1Ppxtc/HCzGxqh8V
         zgOw==
X-Gm-Message-State: AJcUukdKEZFmCwknWYZHtWbw+M/CipgiwnqfO1hSWOSdD1turVj3KoAG
        zhPPLwsyuqkPay/j9bYO25D0JQ==
X-Google-Smtp-Source: ALg8bN4BOqYQJcHedP9V53j/YT9UAw6s73r7ONUSLF5Wu8gxV6/Wlr0c4u/ltKMPOohMRjiXoGF+pQ==
X-Received: by 2002:a0c:e751:: with SMTP id g17mr37964719qvn.160.1549040632330;
        Fri, 01 Feb 2019 09:03:52 -0800 (PST)
Received: from tpx230-nicolas (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id w13sm6144031qkj.8.2019.02.01.09.03.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Feb 2019 09:03:51 -0800 (PST)
Message-ID: <f253a1ac6af48b03e6e49ef46af3aef8e77a3186.camel@ndufresne.ca>
Subject: Re: Gstreamer and vim2m with bayer capture formats
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org, gstreamer-devel@freedesktop.org
Date:   Fri, 01 Feb 2019 12:03:49 -0500
In-Reply-To: <20190201123239.7d4eacfb@silica.lan>
References: <20190201123239.7d4eacfb@silica.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-1ZPzsTSLM1tI3u3Dn8k3"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-1ZPzsTSLM1tI3u3Dn8k3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 01 f=C3=A9vrier 2019 =C3=A0 12:32 -0200, Mauro Carvalho Chehab =
a
=C3=A9crit :
> Hi Nicolas,
>=20
> I just added a patch for the vim2m Kernel driver to also support bayer fo=
rmats,
> but only in capture mode:
>=20
> 	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=3Dvim2m&id=3D=
7fd6ccf110b7c167a2304ffd482e6c04252c4909
>=20
> The goal here is to be able to use vim2m to simulate a webcam. Creating
> a bayer output is trivial, but converting from bayer to RGB is a way more
> complex, and probably not too useful for this Kernel testing driver. So,=
=20
> I opted to not implement bayer conversion only for the V4L2 output mode
> (with is actually the m2m input).
>=20
> After such patch and the ones that I merged yesterday at the linux-media
> development git tree, what we have is:
>=20
> 	$ v4l2-ctl --list-formats --list-formats-out
> 	ioctl: VIDIOC_ENUM_FMT
> 	Type: Video Capture
>=20
> 	[0]: 'RGBP' (16-bit RGB 5-6-5)
> 	[1]: 'RGBR' (16-bit RGB 5-6-5 BE)
> 	[2]: 'RGB3' (24-bit RGB 8-8-8)
> 	[3]: 'BGR3' (24-bit BGR 8-8-8)
> 	[4]: 'YUYV' (YUYV 4:2:2)
> 	[5]: 'BA81' (8-bit Bayer BGBG/GRGR)
> 	[6]: 'GBRG' (8-bit Bayer GBGB/RGRG)
> 	[7]: 'GRBG' (8-bit Bayer GRGR/BGBG)
> 	[8]: 'RGGB' (8-bit Bayer RGRG/GBGB)
>=20
> 	ioctl: VIDIOC_ENUM_FMT
> 	Type: Video Output
>=20
> 	[0]: 'RGBP' (16-bit RGB 5-6-5)
> 	[1]: 'RGBR' (16-bit RGB 5-6-5 BE)
> 	[2]: 'RGB3' (24-bit RGB 8-8-8)
> 	[3]: 'BGR3' (24-bit BGR 8-8-8)
> 	[4]: 'YUYV' (YUYV 4:2:2)
>=20
> With that, I got two problems with gstreamer V4L2 plugin:
>=20
> 1) Right now, it only creates a v4l2video?convert source if a M2M device
> is symmetric, e. g. exactly the same set of formats should be supported b=
y=20
> both capture and output types. That was never a V4L2 API requirement.=20

Not exactly a question of symmetry. The v4l2transform element is means
for RAW video processors, so the classification heuristic is that all
input and output formats must be RAW video.

What I believe the bug might be is that the bayer formats may not have
been classified as RAW video (they are not considered RAW in GStreamer
at the moment).

>=20
> Actually, vim2m capture driver had always asymmetric formats since when m=
2m
> support was introduced. It only became symmetric for a short period of
> time (this week) when I added more formats to it. Yet, after my new patch
> (planned to be merged next week), it will be asymmetric again.

Again, it has nothing to do with symmetry.

>=20
> So, the enclosed patch is required (or something similar) in order to fix
> gstreamer with regards to V4L2 M2M API support.
>=20
> With such patch applied, and building it with --enable-v4l2-plugin, the
> gst V4L2 plugin works with a pipeline like:
>=20
> 	$ gst-launch-1.0 videotestsrc ! video/x-raw,format=3DBGR ! v4l2video0con=
vert disable-passthrough=3D1 extra-controls=3D"s,horizontal_flip=3D1,vertic=
al_flip=3D1" ! video/x-raw,format=3DBGR ! videoconvert ! fpsdisplaysink
>=20
> 2) I'm not sure how to use gstreamer to use a bayer format for capture ty=
pe.
>=20
> I tried this:
>=20
> 	$ gst-launch-1.0 videotestsrc ! video/x-raw,format=3DBGR ! v4l2video0con=
vert disable-passthrough=3D1 extra-controls=3D"s,horizontal_flip=3D1,vertic=
al_flip=3D1" ! video/x-bayer,format=3Dbggr ! bayer2rgb ! videoconvert ! fps=
displaysink
>=20
> But it failed:
> 	Setting pipeline to PAUSED ...
> 	failed to open /usr/lib64/dri/hybrid_drv_video.so
> 	Not using hybrid_drv_video.so
> 	failed to open /usr/lib64/dri/hybrid_drv_video.so
> 	Not using hybrid_drv_video.so
> 	Pipeline is PREROLLING ...
> 	Got context from element 'fps-display-video_sink-actual-sink-vaapi': gst=
.vaapi.Display=3Dcontext, gst.vaapi.Display=3D(GstVaapiDisplay)"\(GstVaapiD=
isplayGLX\)\ vaapidisplayglx1";
> 	ERROR: from element /GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0=
: Internal data stream error.
> 	Additional debug info:
> 	gstbasesrc.c(3055): gst_base_src_loop (): /GstPipeline:pipeline0/GstVide=
oTestSrc:videotestsrc0:
> 	streaming stopped, reason not-negotiated (-4)
> 	ERROR: pipeline doesn't want to preroll.
> 	Setting pipeline to NULL ...
> 	Freeing pipeline ...
>=20
> PS.: I'm sure that the vim2m is working fine with bayer, as I tested it w=
ith:
>=20
> 	$ qvidcap -p &
> 	$ for i in BA81 GBRRG GRBG RGGB; do v4l2-ctl --stream-mmap --stream-out-=
mmap --stream-to-host localhost --stream-lossless --stream-out-hor-speed 1 =
-v pixelformat=3D$i --stream-count 40; done
>=20
> Cheers,
> Mauro
>=20
> diff --git a/sys/v4l2/gstv4l2.c b/sys/v4l2/gstv4l2.c
> index 2674d9cd3449..9031de657d71 100644
> --- a/sys/v4l2/gstv4l2.c
> +++ b/sys/v4l2/gstv4l2.c
> @@ -204,7 +204,7 @@ gst_v4l2_probe_and_register (GstPlugin * plugin)
>        if (gst_v4l2_is_vp9_enc (sink_caps, src_caps))
>          gst_v4l2_vp9_enc_register (plugin, basename, it->device_path,
>              sink_caps, src_caps);
> -    } else if (gst_v4l2_is_transform (sink_caps, src_caps)) {
> +    } else {
>        gst_v4l2_transform_register (plugin, basename, it->device_path,
>            sink_caps, src_caps);

Of course this by-pass the classification. The intention is not that
v4l2convert becomes a fallthrough, the reason is that the caps
negotiation has semantic related to the expected functions the m2m
driver will do (right now we support csc and scaling). So the intention
is that GstV4l2Transform becomes an abstract class, and GstV4l2Convert
would subclass it to implement csc and scaling. And then other
specialized subclass can be made to support other type of hardware.

But before this can happen, proper API for HW function classification
will be needed. Right now, this is all base on guessing. For the vim2m
case, we should simply properly classify bayer format as RAW video, and
that should solve your issue.

If my change you have resources or time to work on a proper patch, be
aware that patch submissions works through gitlab.freedesktop.org Merge
Request (basically pushing a branch on a fork there and doing couple of
webui clicks).

>      }
> diff --git a/sys/v4l2/gstv4l2transform.c b/sys/v4l2/gstv4l2transform.c
> index e92f984ff40a..487b7750d17b 100644
> --- a/sys/v4l2/gstv4l2transform.c
> +++ b/sys/v4l2/gstv4l2transform.c
> @@ -1171,17 +1171,6 @@ gst_v4l2_transform_subclass_init (gpointer g_class=
, gpointer data)
>  }
> =20
>  /* Probing functions */
> -gboolean
> -gst_v4l2_is_transform (GstCaps * sink_caps, GstCaps * src_caps)
> -{
> -  gboolean ret =3D FALSE;
> -
> -  if (gst_caps_is_subset (sink_caps, gst_v4l2_object_get_raw_caps ())
> -      && gst_caps_is_subset (src_caps, gst_v4l2_object_get_raw_caps ()))
> -    ret =3D TRUE;
> -
> -  return ret;
> -}
> =20
>  void
>  gst_v4l2_transform_register (GstPlugin * plugin, const gchar * basename,
> diff --git a/sys/v4l2/gstv4l2transform.h b/sys/v4l2/gstv4l2transform.h
> index 29f3f3c655b7..afdc289db545 100644
> --- a/sys/v4l2/gstv4l2transform.h
> +++ b/sys/v4l2/gstv4l2transform.h
> @@ -73,7 +73,6 @@ struct _GstV4l2TransformClass
> =20
>  GType gst_v4l2_transform_get_type (void);
> =20
> -gboolean gst_v4l2_is_transform       (GstCaps * sink_caps, GstCaps * src=
_caps);
>  void     gst_v4l2_transform_register (GstPlugin * plugin,
>                                        const gchar *basename,
>                                        const gchar *device_path,
>=20

--=-1ZPzsTSLM1tI3u3Dn8k3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXFR79QAKCRBxUwItrAao
HHYWAJ930rFP8TfKpOQ0oe7+uu81XeJQpACgguzyf00hkOHeIg1udyCWgW7LRA8=
=SvsW
-----END PGP SIGNATURE-----

--=-1ZPzsTSLM1tI3u3Dn8k3--

