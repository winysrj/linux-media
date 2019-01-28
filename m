Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CDFC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 07:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D75320881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 07:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="aZiP/Q52"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfA1Huv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 02:50:51 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:34476 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbfA1Huv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 02:50:51 -0500
Received: by mail-it1-f194.google.com with SMTP id x124so10319291itd.1
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 23:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HICkapWg27iyhgzEsEbJrxhO+P32hzzqXI53DO57g7Q=;
        b=aZiP/Q52ZYJbsTu24TjWMph8AsnVGR+U91sP95ylnU+HUICiVhKEPwBBcu0VoBrl3f
         WKDcbpdN7bGXCZ6zO4s+5htCF874lpfqU9FZSNY0mpM8i6EwjduK2QrLHtsilXGUaCHl
         ZJrIA9BdE478hq4yYY9LHeiqSYGrru2MLHS8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HICkapWg27iyhgzEsEbJrxhO+P32hzzqXI53DO57g7Q=;
        b=ZFcR4wl/hMX3QaQcU9b+c9fr6wDPUVvIrmBiGpcvBAvzypG83qz1xNCoudHp5+OcBb
         AOlK0W+tseaYImIoMow4Yv2aZSSRlcYngGaMaCmpcHiPaMfdM8ZBlME2WZVj1+sNyw1t
         2KHS5SImJ+lUsaS72JUfJ1R/RkChaYGs+JM4+qXCiMSJIqD5tsOLaRP1sXhAMidZY4He
         B+ORKjBF/jym8KPtvDHW8VNUb22eK9OlmiaIEqhgnEcNe6lzjSGGlnWZ/0SjgM091tsF
         NUdhAnuF+rafUydXm5EATnIkgVX4pWlbVDnTmPBuWqBlKncprP7HOSaEHvJzM1TSd1+L
         LlnQ==
X-Gm-Message-State: AJcUukeH1qhsCPilxMQ+3i50SfGphjEqpcxECUQLOia2xIYE3tcvRXPV
        H0AqKNS1sVGTXu9rLGuGGJHh0RVH+bXZLNV+Oe0nhQ==
X-Google-Smtp-Source: ALg8bN4jrWPGadFPjiDRwASFBWBR5LYM8fa/gJvlWaTThQlLFKgpetch1Q8BIPmJKXj9J0sv8V+oMgq0ga/DtPGjYGY=
X-Received: by 2002:a24:4f07:: with SMTP id c7mr9844892itb.107.1548661849682;
 Sun, 27 Jan 2019 23:50:49 -0800 (PST)
MIME-Version: 1.0
References: <20190124175801.28018-1-jagan@amarulasolutions.com> <20190125153958.3aertsxgdzjldlzd@flea>
In-Reply-To: <20190125153958.3aertsxgdzjldlzd@flea>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Mon, 28 Jan 2019 13:20:37 +0530
Message-ID: <CAMty3ZCuBqiOGAixWhy5bYqUHk0_=NvX08zp2F+MT4GgVEo+Rw@mail.gmail.com>
Subject: Re: [PATCH] media: ov5640: Fix set 15fps regression
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 25, 2019 at 9:10 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> On Thu, Jan 24, 2019 at 11:28:01PM +0530, Jagan Teki wrote:
> > The ov5640_try_frame_interval operation updates the FPS as per user
> > input based on default ov5640_frame_rate, OV5640_30_FPS which is failed
> > to update when user trigger 15fps.
> >
> > So, initialize the default ov5640_frame_rate to OV5640_15_FPS so-that
> > it can satisfy to update all fps.
> >
> > Fixes: 5a3ad937bc78 ("media: ov5640: Make the return rate type more explicit")
> > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
>
> I'm pretty sure I tested this and it was working fine. You're
> mentionning a regression, but what regression is there exactly (ie,
> what was working before that commit that doesn't work anymore?). What
> tools/commands are you using to see this behaviour?

In fact I have mentioned this on your v9 [1], may be you missed it.

I have reproduced with media-ctl, below is the full log. let me know
if I still miss anything.

Before this change:
# media-ctl -p
Media controller API version 5.0.0

Media device information
------------------------
driver          sun6i-csi
model           Allwinner Video Capture Device
serial
bus info
hw revision     0x0
driver version  5.0.0

Device topology
- entity 1: sun6i-csi (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0: Sink
                <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]

- entity 5: ov5640 1-003c (1 pad, 1 link)
            type V4L2 subdev subtype Sensor flags 0
            device node name /dev/v4l-subdev0
        pad0: Source
                [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb
xfer:srgb ycbcr:601 quantization:full-range]
                -> "sun6i-csi":0 [ENABLED,IMMUTABLE]

# media-ctl --set-v4l2 "'ov5640 1-003c':0[fmt:UYVY8_2X8/640x480@1/15 field:none]
"
# media-ctl -p
Media controller API version 5.0.0

Media device information
------------------------
driver          sun6i-csi
model           Allwinner Video Capture Device
serial
bus info
hw revision     0x0
driver version  5.0.0

Device topology
- entity 1: sun6i-csi (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0: Sink
                <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]

- entity 5: ov5640 1-003c (1 pad, 1 link)
            type V4L2 subdev subtype Sensor flags 0
            device node name /dev/v4l-subdev0
        pad0: Source
                [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb
xfer:srgb ycbcr:601 quantization:full-range]
                -> "sun6i-csi":0 [ENABLED,IMMUTABLE]


After this change:
# media-ctl -p
Media controller API version 5.0.0

Media device information
------------------------
driver          sun6i-csi
model           Allwinner Video Capture Device
serial
bus info
hw revision     0x0
driver version  5.0.0

Device topology
- entity 1: sun6i-csi (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0: Sink
                <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]

- entity 5: ov5640 1-003c (1 pad, 1 link)
            type V4L2 subdev subtype Sensor flags 0
            device node name /dev/v4l-subdev0
        pad0: Source
                [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb
xfer:srgb ycbcr:601 quantization:full-range]
                -> "sun6i-csi":0 [ENABLED,IMMUTABLE]

# media-ctl --set-v4l2 "'ov5640 1-003c':0[fmt:UYVY8_2X8/640x480@1/15 field:none]
"
# media-ctl -p
Media controller API version 5.0.0

Media device information
------------------------
driver          sun6i-csi
model           Allwinner Video Capture Device
serial
bus info
hw revision     0x0
driver version  5.0.0

Device topology
- entity 1: sun6i-csi (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0: Sink
                <- "ov5640 1-003c":0 [ENABLED,IMMUTABLE]

- entity 5: ov5640 1-003c (1 pad, 1 link)
            type V4L2 subdev subtype Sensor flags 0
            device node name /dev/v4l-subdev0
        pad0: Source
                [fmt:UYVY8_2X8/640x480@1/15 field:none colorspace:srgb
xfer:srgb ycbcr:601 quantization:full-range]
                -> "sun6i-csi":0 [ENABLED,IMMUTABLE]

[1] https://patchwork.kernel.org/patch/10708931/
