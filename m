Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044DAC282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 19:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE74E222C0
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 19:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="CLK9lFX2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbfBLTCF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 14:02:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52234 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfBLTCE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 14:02:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id m1so4241001wml.2
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2019 11:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bFpFNCmHQUH+XHnRvw7+2FbduGFIWktyI7mg5P3s/tQ=;
        b=CLK9lFX2GdW4BTb2bnb8xFHyu+HyCKbPD1u1RB8c1CPUCDjbTk5K1gSZ0Zkbl5JuLc
         i6j7u5UB3LpV+Pl2kQGOfE0bNSgqVMVILJvlbmuTilqasUFwhxr9vUEqFAaRb0QScqof
         XcwI3qBmWJllm2XXTDkW2ErfJbG8+bp9ahgWb5EdJ9shmYD9e8WatKXLJA0m7lcHC3sI
         +Qxa0/WRY0DL6ZJPN5jBSH8lPRKnDbIpQpAegV7dJ9pVrrFVRWE3kyPJfS7PoEYbquTR
         QARQZmNwFar9c22jrpYo7L3ZU41dnK3seEbQ9LLi85slCLzcu8K/2yBEY5XSsWFgtE1P
         azKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bFpFNCmHQUH+XHnRvw7+2FbduGFIWktyI7mg5P3s/tQ=;
        b=kil/jwU1uSouIcZ5xhqYppOUGBQd8A+8GtlNMipS4aMXTmygZeb6utB5JHUYX6w2UY
         8Xxf0NWQCCbY71SlJz+aXBz1GS4oz5DxrVe9pGhOqHGoqwROh5cInCVYoBjt+wf6pHmf
         /RTxibdjqcH1gUQIFQpPATI7if+QXQuAP9AVWz+wQjGRuv/IWGq19TrAa95dto6i4D9T
         7l/rZyGxTb5OMVSuT5t1xz9zQBwwNmo5IBCuOMkfYNfU5Gl5ko+y02zesI5OOto03pxe
         zJvY8CmV9crxJ+jvuEj9q+ZK9FwCVmEgQiqfK/zavtzTMNLSHXnXCCoL06hHErWtlnx+
         cUwA==
X-Gm-Message-State: AHQUAuZPqCvjRSL8qhgZeboQaSLRAruG5ERMoYGW7lWCtyXtMn2oeqJ/
        wRpplBWjJ9HnfMhZbiJlKMAX2DX2dmW81cT7SRl+MA==
X-Google-Smtp-Source: AHgI3IYGaGW84mQTD2uskK2GNXYgXTy67elXpB9mr6+9d4gsqcBkcjjD/v1vz7Wt1FOGUE4XZtHdas9E8N4pTB9nkWI=
X-Received: by 2002:a1c:1fca:: with SMTP id f193mr234512wmf.65.1549998122131;
 Tue, 12 Feb 2019 11:02:02 -0800 (PST)
MIME-Version: 1.0
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
In-Reply-To: <20190117155032.3317-1-p.zabel@pengutronix.de>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 12 Feb 2019 11:01:49 -0800
Message-ID: <CAJ+vNU0HCBr2vz-D=Z8zC+JAmZ6bhsi7TCRhB827uPQj-8esDQ@mail.gmail.com>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 17, 2019 at 7:50 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> Add a single imx-media mem2mem video device that uses the IPU IC PP
> (image converter post processing) task for scaling and colorspace
> conversion.
> On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
>
> The hardware only supports writing to destination buffers up to
> 1024x1024 pixels in a single pass, arbitrary sizes can be achieved
> by rendering multiple tiles per frame.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> [slongerbeam@gmail.com: use ipu_image_convert_adjust(), fix
>  device_run() error handling, add missing media-device header,
>  unregister and remove the mem2mem device in error paths in
>  imx_media_probe_complete() and in imx_media_remove()]
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
> Changes since v6 [1]:
>  - Change driver name in querycap to imx-media-csc-scaler
>  - Drop V4L2_SEL_TGT_COMPOSE_PADDED from vidioc_g_selection
>  - Simplify error handling in ipu_csc_scaler_init_controls
>
> [1] https://patchwork.linuxtv.org/patch/53757/
> ---

Hi Philipp,

Thanks for this driver - this is providing support that I need to
overcome direct CSI->IC limitations.

Can you give me some examples on how your using this? I'm testing this
on top of linux-media and trying the following gstreamer pipelines
(gstreamer recent master) and running into trouble but it could very
likely be me doing something wrong in my pipelines:

# upscale
gst-launch-1.0 videotestsrc ! video/x-raw,width=320,height=240 !
v4l2convert output-io-mode=dmabuf-import !
video/x-raw,width=640,height=480 ! kmssink
^^^ fails with
ERROR: from element
/GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0/GstKMSSink:autovideosink0-actual-sink-kms:
GStreamer encountered a general resource error.
Additional debug info:
gstkmssink.c(1529): gst_kms_sink_show_frame ():
/GstPipeline:pipeline0/GstAutoVideoSink:autovideosink0/GstKMSSink:autovideosink0-actual-sink-kms:
drmModeSetPlane failed: No space left on device (-28)
perhaps this is something strange with kmssink or is a buffer size not
being set properly in the mem2mem scaler?

# downscale
gst-launch-1.0 videotestsrc ! video/x-raw,width=640,height=480 !
v4l2convert output-io-mode=dmabuf-import !
video/x-raw,width=320,height=280 ! kmssink
(gst-launch-1.0:15493): GStreamer-CRITICAL **: 18:06:49.029:
gst_buffer_resize_range: assertion 'bufmax >= bufoffs + offset + size'
failed
ERROR: from element
/GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0: Internal data
stream error.
Additional debug info:
gstbasesrc.c(3064): gst_base_src_loop ():
/GstPipeline:pipeline0/GstVideoTestSrc:videotestsrc0:
streaming stopped, reason error (-5)
ERROR: pipeline doesn't want to preroll.
Setting pipeline to NULL ...
Freeing pipeline ...

# downscale using videotstsrc defaults
gst-launch-1.0 videotestsrc ! v4l2convert output-io-mode=dmabuf-import
! video/x-raw,width=100,height=200 ! kmssink
^^^ works

# rotation
gst-launch-1.0 videotestsrc ! v4l2convert output-io-mode=dmabuf-import
extra-controls=cid,rotate=90 ! kmssink
^^^ shows no rotation in displayed video but kernel debugging shows
ipu_csc_scaler_s_ctrl getting called with V4L2_CID_ROTATE,
ctrl->val=90 and ipu_degrees_to_rot_mode sets rot_mode=IPU_ROT_BIT_90
and returns no error. I also see that
ipu_image_convert_adjust gets called with rot_mode=IPU_ROT_BIT_90

I'm also not sure how to specify hflip/vflip... I don't think
extra-controls parses 'hflip', 'vflip' as ipu_csc_scaler_s_ctrl gets
called with V4L2_CID_HFLIP/V4L2_CID_VFLIP but ctrl->val is always 0.

Thanks,

Tim
