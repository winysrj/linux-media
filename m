Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAB6C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 11:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3626C21B1A
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 11:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394015AbfBOLKX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:10:23 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46229 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389957AbfBOLKX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 06:10:23 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gubNu-0003Ps-0l; Fri, 15 Feb 2019 12:10:22 +0100
Message-ID: <1550229020.4531.12.camel@pengutronix.de>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Tim Harvey <tharvey@gateworks.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sascha Hauer <kernel@pengutronix.de>
Date:   Fri, 15 Feb 2019 12:10:20 +0100
In-Reply-To: <CAJ+vNU0HCBr2vz-D=Z8zC+JAmZ6bhsi7TCRhB827uPQj-8esDQ@mail.gmail.com>
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
         <CAJ+vNU0HCBr2vz-D=Z8zC+JAmZ6bhsi7TCRhB827uPQj-8esDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tim,

On Tue, 2019-02-12 at 11:01 -0800, Tim Harvey wrote:
> On Thu, Jan 17, 2019 at 7:50 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > 
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
> video/x-raw,width=640,height=480 ! kmssink

You can't have v4l2convert import dmabufs because videotestsrc doesn't
produce any. I used:

gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 ! v4l2video10convert ! video/x-raw,width=640,height=480 ! kmssink

That should work, passing dmabufs between v4l2 and kms automatically.

I usually use kmssink but waylandsink, glimagesink, or v4l2h264enc for
testing though.

> # downscale
> gst-launch-1.0 videotestsrc ! video/x-raw,width=640,height=480 !
> v4l2convert output-io-mode=dmabuf-import !
> video/x-raw,width=320,height=280 ! kmssink

Drop output-io-mode unless your source is capable of producing dmabufs.
I think kmssink is trying to scale in this case, which imx-drm doesn't
support. You may have to either keep aspect ratio, or give kmssink the
can-scale=false parameter.

> # downscale using videotstsrc defaults
> gst-launch-1.0 videotestsrc ! v4l2convert output-io-mode=dmabuf-import
> ! video/x-raw,width=100,height=200 ! kmssink
> ^^^ works

That will probably just negotiate 100x200 on the input side and bypass
conversion altogether.

> # rotation
> gst-launch-1.0 videotestsrc ! v4l2convert output-io-mode=dmabuf-import
> extra-controls=cid,rotate=90 ! kmssink

This will likely negotiate the same format and dimensions on both sides
and bypass conversion as well. GStreamer has no concept of the rotation
as of yet. Try:

gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 ! v4l2video10convert extra-controls=cid,rotate=90 ! video/x-raw,width=240,height=320 ! kmssink can-scale=false

> I'm also not sure how to specify hflip/vflip... I don't think
> extra-controls parses 'hflip', 'vflip' as ipu_csc_scaler_s_ctrl gets
> called with V4L2_CID_HFLIP/V4L2_CID_VFLIP but ctrl->val is always 0.

You can use v4l2-ctl -L to list the CID names, they are horizontal_flip
and vertical_flip, respectively. Again, the input and output formats
must be different because GStreamer doesn't know about the flipping yet:

gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 ! v4l2video10convert extra-controls=cid,horizontal_flip=1 ! video/x-raw,width=640,height=480 ! kmssink can-scale=false

We'd have to add actual properties for rotate/flip to v4l2convert,
instead of using theextra-controls workaround, probable something
similar to the video-direction property of the software videoflip
element.

regards
Philipp
