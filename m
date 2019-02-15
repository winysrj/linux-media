Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897F3C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 23:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F63D206B6
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 23:34:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="W4RNLL0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfBOXeR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 18:34:17 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52513 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbfBOXeR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 18:34:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id m1so11695813wml.2
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 15:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qHneIOe8fWjIs0KoyZKJ0VqkQhXx5TXtwO4lMm3JHvc=;
        b=W4RNLL0+BLC1mvKjJNLN9kQsMgnrww8zly5kHZRwVw8TysH89BoHC9AJDMzyixGZTp
         dKFA/L/WTwUNKTws4z92BPBzGCJ6T3DIELXln28Qplks2aHp1HuVWhK0SgcX3Llcl2DS
         4ShbcD5UJfGRPAuzpEk5sVI3G0w65qZ4DcDemqnvm4N4TEAZB0jjAWKNbPQgx/Jfh4uy
         HslOk4xNh5hbOuRqaZy/cMXkXf5sNZN8gGF2Vr0tiPxo1WG3kDLRWB8IPBfcO0+tL+6/
         9dBM8CHUCehEWzoQX5v7rNqksUxH59dk+wPDCoMQHEiJRfddNExvjEp/nKSg2UsH+aEF
         fRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qHneIOe8fWjIs0KoyZKJ0VqkQhXx5TXtwO4lMm3JHvc=;
        b=sKILT5xKDuEOqX4MDUFi9kNanmg6feiUVvN/TXlUwFXzqxIsmJx7DQ6v6z6rD0qYqJ
         9usp+qrAHb9wC+dXmJJJonJkSJILc5g4w+IZ4ytfWNY75Q9pGL97WdE0r6H5havzCOry
         53a7K/7EzsudX2wHLxpVVi6hpsD5TEoyRf7tRyuUkEMjKbdf9CQkNBu+9e9I5/MRZbZq
         GBKmOIM+c863lAMbHGd/nBamqen3iiX8J4HuQ7DHKmviboMUHSGGbOkysmY+EVS0JVsE
         uisopWfbvP9dsUQQtZcuYypnMI7S5EOd4p/RM/qkMNsAO7ACKCDOoJM1lwCQAtOCv1hH
         MCwA==
X-Gm-Message-State: AHQUAuZESG9We/H3ZCJJf7sOYTMwp+XsjG5NxLzf2ixLAK7Ecs+WEgbA
        L/PVelW53cawJ8JOkuJPcbZIiU0gZDDXpYQAA50ZTQ==
X-Google-Smtp-Source: AHgI3IbsPEzPuCsgRbe6hsLi4gZ2ImVr5O5oP6jn1enIhbj1kCuYgMOOCxrrsX2wwDFAdkp63KqHMPxDN8PttoNqd7M=
X-Received: by 2002:a1c:e715:: with SMTP id e21mr5232347wmh.122.1550273654607;
 Fri, 15 Feb 2019 15:34:14 -0800 (PST)
MIME-Version: 1.0
References: <20190117155032.3317-1-p.zabel@pengutronix.de> <CAJ+vNU0HCBr2vz-D=Z8zC+JAmZ6bhsi7TCRhB827uPQj-8esDQ@mail.gmail.com>
 <1550229020.4531.12.camel@pengutronix.de>
In-Reply-To: <1550229020.4531.12.camel@pengutronix.de>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 15 Feb 2019 15:34:03 -0800
Message-ID: <CAJ+vNU107uXhOJ7iL1mW8__A+-YAi5G-JcpZ=y59LqrPQ36zVg@mail.gmail.com>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 15, 2019 at 3:10 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> Hi Tim,
>
> On Tue, 2019-02-12 at 11:01 -0800, Tim Harvey wrote:
> > On Thu, Jan 17, 2019 at 7:50 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > >
> > > Add a single imx-media mem2mem video device that uses the IPU IC PP
> > > (image converter post processing) task for scaling and colorspace
> > > conversion.
> > > On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
> > >
> > > The hardware only supports writing to destination buffers up to
> > > 1024x1024 pixels in a single pass, arbitrary sizes can be achieved
> > > by rendering multiple tiles per frame.
> > >
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > [slongerbeam@gmail.com: use ipu_image_convert_adjust(), fix
> > >  device_run() error handling, add missing media-device header,
> > >  unregister and remove the mem2mem device in error paths in
> > >  imx_media_probe_complete() and in imx_media_remove()]
> > > Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> > > ---
> > > Changes since v6 [1]:
> > >  - Change driver name in querycap to imx-media-csc-scaler
> > >  - Drop V4L2_SEL_TGT_COMPOSE_PADDED from vidioc_g_selection
> > >  - Simplify error handling in ipu_csc_scaler_init_controls
> > >
> > > [1] https://patchwork.linuxtv.org/patch/53757/
> > > ---
> >
> > Hi Philipp,
> >
> > Thanks for this driver - this is providing support that I need to
> > overcome direct CSI->IC limitations.
> >
> > Can you give me some examples on how your using this? I'm testing this
> > on top of linux-media and trying the following gstreamer pipelines
> > (gstreamer recent master) and running into trouble but it could very
> > likely be me doing something wrong in my pipelines:
> >
> > # upscale
> > gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 !
> > v4l2convert output-io-mode=dmabuf-import !
> > video/x-raw,width=640,height=480 ! kmssink
>
> You can't have v4l2convert import dmabufs because videotestsrc doesn't
> produce any. I used:
>
> gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 ! v4l2video10convert ! video/x-raw,width=640,height=480 ! kmssink
>
> That should work, passing dmabufs between v4l2 and kms automatically.
>
> I usually use kmssink but waylandsink, glimagesink, or v4l2h264enc for
> testing though.
>

Philipp,

That makes sense and jives with what Nicolas was saying about alignment.

I'm currently testing linux-media/master with your v7 mem2mem patch
and 'gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 !
v4l2video10convert ! video/x-raw,width=640,height=480 ! kmssink' hangs
the system. Do you have some other patches queued up?

> > # downscale
> > gst-launch-1.0 videotestsrc ! video/x-raw,width=640,height=480 !
> > v4l2convert output-io-mode=dmabuf-import !
> > video/x-raw,width=320,height=280 ! kmssink
>
> Drop output-io-mode unless your source is capable of producing dmabufs.
> I think kmssink is trying to scale in this case, which imx-drm doesn't
> support. You may have to either keep aspect ratio, or give kmssink the
> can-scale=false parameter.
>
> > # downscale using videotstsrc defaults
> > gst-launch-1.0 videotestsrc ! v4l2convert output-io-mode=dmabuf-import
> > ! video/x-raw,width=100,height=200 ! kmssink
> > ^^^ works
>
> That will probably just negotiate 100x200 on the input side and bypass
> conversion altogether.
>
> > # rotation
> > gst-launch-1.0 videotestsrc ! v4l2convert output-io-mode=dmabuf-import
> > extra-controls=cid,rotate=90 ! kmssink
>
> This will likely negotiate the same format and dimensions on both sides
> and bypass conversion as well. GStreamer has no concept of the rotation
> as of yet. Try:
>
> gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 ! v4l2video10convert extra-controls=cid,rotate=90 ! video/x-raw,width=240,height=320 ! kmssink can-scale=false
>
> > I'm also not sure how to specify hflip/vflip... I don't think
> > extra-controls parses 'hflip', 'vflip' as ipu_csc_scaler_s_ctrl gets
> > called with V4L2_CID_HFLIP/V4L2_CID_VFLIP but ctrl->val is always 0.
>
> You can use v4l2-ctl -L to list the CID names, they are horizontal_flip
> and vertical_flip, respectively. Again, the input and output formats
> must be different because GStreamer doesn't know about the flipping yet:
>
> gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 ! v4l2video10convert extra-controls=cid,horizontal_flip=1 ! video/x-raw,width=640,height=480 ! kmssink can-scale=false
>
> We'd have to add actual properties for rotate/flip to v4l2convert,
> instead of using theextra-controls workaround, probable something
> similar to the video-direction property of the software videoflip
> element.
>

Philipp,

Removing the dmabuf options makes sense along with what Nicolas was
saying about the dma buffer alignment.

The fact that Gstreamer doesn't understand flip/rotate also makes
complete sense - it bypasses the conversion completely unless you
change the format.

All of these work perfectly:
# upscale
gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 !
v4l2convert ! video/x-raw,width=640,height=480 ! kmssink
can-scale=false
# downscale
gst-launch-1.0 videotestsrc ! video/x-raw,width=640,height=480 !
v4l2convert ! video/x-raw,width=320,height=240 ! kmssink
can-scale=false
# rotate
gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 !
v4l2convert extra-controls=cid,rotate=90 !
video/x-raw,width=240,height=320 ! kmssink can-scale=false
# flip
gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 !
v4l2convert extra-controls=cid,horizontal_flip=1 !
video/x-raw,width=640,height=480 ! kmssink can-scale=false
gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 !
v4l2convert extra-controls=cid,vertical_flip=1 !
video/x-raw,width=640,height=480 ! kmssink can-scale=false

As well as the following using an imx-media capture pipeline (480p
source on the sensor) where we can now use aligned dmabuf's:
# encode
gst-launch-1.0 v4l2src device=/dev/video4 ! v4l2convert
output-io-mode=dmabuf-import ! v4l2h264enc
output-io-mode=dmabuf-import ! rtph264pay ! udpsink host=172.24.20.19
port=5001
# scale/encode
gst-launch-1.0 v4l2src device=/dev/video4 ! v4l2convert
output-io-mode=dmabuf-import ! video/x-raw,width=1440,height=960 !
v4l2h264enc output-io-mode=dmabuf-import ! rtph264pay ! udpsink
host=172.24.20.19 port=5001
# scale/flip/encode
gst-launch-1.0 v4l2src device=/dev/video4 ! v4l2convert
output-io-mode=dmabuf-import extra-controls=cid,horizontal_flip=1 !
video/x-raw,width=1440,height=960 ! v4l2h264enc
output-io-mode=dmabuf-import ! rtph264pay ! udpsink host=172.24.20.19
port=5001
# scale/rotate/encode
gst-launch-1.0 v4l2src device=/dev/video4 ! v4l2convert
output-io-mode=dmabuf-import extra-controls=cid,rotate=90 !
video/x-raw,width=1440,height=960 ! v4l2h264enc
output-io-mode=dmabuf-import ! rtph264pay ! udpsink host=172.24.20.19
port=5001

Many thanks - hoping to see this merged soon!

Tim
