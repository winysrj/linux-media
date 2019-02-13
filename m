Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74686C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 17:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A8CB2086C
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 17:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="ft0FkKUE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbfBMRWI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 12:22:08 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45113 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730684AbfBMRWI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 12:22:08 -0500
Received: by mail-qt1-f196.google.com with SMTP id e5so3428136qtr.12
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2019 09:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=SCqPoSPt97lV420yE1SAyEXuG+gMcBajh1cD2kdysQ8=;
        b=ft0FkKUEE+7RVE8XioWeFiiruqQGTd21uKAWPnRSZ4Hym2LdG1t51XSQKbSoQYjygF
         Y5zjg7c+wGMuPxh38Qwl6v1saBQTjBMLktL10pchZsTQdae9MpoX32PnUYjSTQXPP3q2
         8XC2UmmNSmSrGcc316XOl/AFPr/6HDOnbZG2sn8JMrCUH/98N2iCXWmICB3XC0H5vf1c
         2RmOe9/g6bEJzxaobEm9nrBT6obkl8jrf13kkaDDMvvdTwkmUOZeArv5N4BtuiM6oTGo
         3koXoT13bV5/9C0FSzib0MQiW3zcp3QtMjidQoZ6ng+lFjf7omm6hfA0Olx5D3r8oEJo
         d/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=SCqPoSPt97lV420yE1SAyEXuG+gMcBajh1cD2kdysQ8=;
        b=JYNmq43VKRANBfsiQogNOqHKyiOxV7QktQjuLFwK7czh0eTf8FD+PBQH7VKGvjo+tR
         AGEYnOveAg0coFOO7I/Uk7VgllDZG52FIRqlb0aruFOqTSkXXcXsPwNovQAfMXAVCnYl
         Gtg/5CH4PVEoj4I2E+uOqv+QsURbikAieCjlLSGSpi9v29u2RGFHIAJj2UaZ4ARZNFcr
         WP/hYxNL9SzHnPvuHb9uWCuWqFlE2cZyzqfdGWrhe66CLmycYG6QbX3YRetM0kJUcJ0i
         AAwMooq7tNfvd7/2ZmmhFJ1i6Am1mvQudLsc1DOcrLoM50b2lg46p/arXdY6IAoAh+3+
         bG1Q==
X-Gm-Message-State: AHQUAuaEYBKC4/XyaFS5ConZyrKHes7dCAPmDKsXDWYb14cYjCsNhLD7
        EIYsxGPXwUUCtmS5OuxN6D7pSQ==
X-Google-Smtp-Source: AHgI3IZ9QiHTesfTagm6jQ/hCVNRZCSiw/18rc3N9pLCR9izF6NIVN+FrCV53dqglwxS5nuVt70J7w==
X-Received: by 2002:ac8:2c92:: with SMTP id 18mr1264234qtw.269.1550078526450;
        Wed, 13 Feb 2019 09:22:06 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id b66sm21074405qkf.64.2019.02.13.09.22.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Feb 2019 09:22:05 -0800 (PST)
Message-ID: <40aa10039d00328796afb99c5b207babe39af3de.camel@ndufresne.ca>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Tim Harvey <tharvey@gateworks.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sascha Hauer <kernel@pengutronix.de>
Date:   Wed, 13 Feb 2019 12:22:04 -0500
In-Reply-To: <CAJ+vNU0HCBr2vz-D=Z8zC+JAmZ6bhsi7TCRhB827uPQj-8esDQ@mail.gmail.com>
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
         <CAJ+vNU0HCBr2vz-D=Z8zC+JAmZ6bhsi7TCRhB827uPQj-8esDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mardi 12 février 2019 à 11:01 -0800, Tim Harvey a écrit :
> On Thu, Jan 17, 2019 at 7:50 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Add a single imx-media mem2mem video device that uses the IPU IC PP
> > (image converter post processing) task for scaling and colorspace
> > conversion.
> > On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
> > 
> > The hardware only supports writing to destination buffers up to
> > 1024x1024 pixels in a single pass, arbitrary sizes can be achieved
> > by rendering multiple tiles per frame.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > [slongerbeam@gmail.com: use ipu_image_convert_adjust(), fix
> >  device_run() error handling, add missing media-device header,
> >  unregister and remove the mem2mem device in error paths in
> >  imx_media_probe_complete() and in imx_media_remove()]
> > Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> > ---
> > Changes since v6 [1]:
> >  - Change driver name in querycap to imx-media-csc-scaler
> >  - Drop V4L2_SEL_TGT_COMPOSE_PADDED from vidioc_g_selection
> >  - Simplify error handling in ipu_csc_scaler_init_controls
> > 
> > [1] https://patchwork.linuxtv.org/patch/53757/
> > ---
> 
> Hi Philipp,
> 
> Thanks for this driver - this is providing support that I need to
> overcome direct CSI->IC limitations.
> 
> Can you give me some examples on how your using this? I'm testing this
> on top of linux-media and trying the following gstreamer pipelines
> (gstreamer recent master) and running into trouble but it could very
> likely be me doing something wrong in my pipelines:
> 
> # upscale
> gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 !
> v4l2convert output-io-mode=dmabuf-import !

Something important to note, is that there is no stride adaptation done
in OUTPUT device dmabuf importation path (yet). This is a difficult
task with the V4L2 API, and the reason this need to be opt-in by user.
You need to make sure yourself (for now) that the stride and buffer
alignment matches between the two drivers, and the only way to fix it
if not is by modifying the respective drivers (for now). Some initial
work has been done the other way around, we are trying to make sure we
cover all cases before implementing the other side.

> video/x-raw,width=640,height=480 ! kmssink
> ^^^ fails with
> ERROR: from element
> /GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0/GstKMSSink:autovideosink0-actual-sink-kms:
> GStreamer encountered a general resource error.
> Additional debug info:
> gstkmssink.c(1529): gst_kms_sink_show_frame ():
> /GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0/GstKMSSink:autovideosink0-actual-sink-kms:
> drmModeSetPlane failed: No space left on device (-28)
> perhaps this is something strange with kmssink or is a buffer size not
> being set properly in the mem2mem scaler?

Note that this one can happen randomly as HW may have limitation that
isn't grammatically exposed to userspace. That being said, use
GST_DEBUG="kmssink:7" to enable related debug traces, that should help
to see what is being done. Matching against some kernel trace is always
useful.

> 
> # downscale
> gst-launch-1.0 videotestsrc ! video/x-raw,width=640,height=480 !
> v4l2convert output-io-mode=dmabuf-import !
> video/x-raw,width=320,height=280 ! kmssink
> (gst-launch-1.0:15493): GStreamer-CRITICAL **: 18:06:49.029:
> gst_buffer_resize_range: assertion 'bufmax >= bufoffs + offset + size'

Would be really nice if you could report this, mentioning the GStreamer
version you are running. GStreamer-CRITICAL means that crash avoidance
code (assert) has been reached. This means you have reached a code path
that wasn't expected by the developers. It's a bit like the kernel
BUG_ON.

https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/issues/new

> failed
> ERROR: from element
> /GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0: Internal data
> stream error.
> Additional debug info:
> gstbasesrc.c(3064): gst_base_src_loop ():
> /GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0:
> streaming stopped, reason error (-5)
> ERROR: pipeline doesn't want to preroll.
> Setting pipeline to NULL ...
> Freeing pipeline ...
> 
> # downscale using videotstsrc defaults
> gst-launch-1.0 videotestsrc ! v4l2convert output-io-mode=dmabuf-import
> ! video/x-raw,width=100,height=200 ! kmssink
> ^^^ works
> 
> # rotation
> gst-launch-1.0 videotestsrc ! v4l2convert output-io-mode=dmabuf-import
> extra-controls=cid,rotate=90 ! kmssink
> ^^^ shows no rotation in displayed video but kernel debugging shows
> ipu_csc_scaler_s_ctrl getting called with V4L2_CID_ROTATE,
> ctrl->val=90 and ipu_degrees_to_rot_mode sets rot_mode=IPU_ROT_BIT_90
> and returns no error. I also see that
> ipu_image_convert_adjust gets called with rot_mode=IPU_ROT_BIT_90

There is no support for 90 degree rotation in the GstV4l2Transform
class. 90 degree rotation must be implemented in the element to be
usable, as the capability negotiation must do the width/height
flipping.

There is also no support for arbitrary rotation, I believe one would
need to add code to suggest a large capture buffer size that fits the
rotated image. It's also ambiguous what would happen otherwise, and
that should be specified the Linux Media documentation in my opinion.

> 
> I'm also not sure how to specify hflip/vflip... I don't think
> extra-controls parses 'hflip', 'vflip' as ipu_csc_scaler_s_ctrl gets
> called with V4L2_CID_HFLIP/V4L2_CID_VFLIP but ctrl->val is always 0.

hflip/vflip was reported to work on vim2m by Mauro, not sure why it
wouldn't for your driver. Maybe both driver don't expose this the same
way ?

> 
> Thanks,
> 
> Tim

