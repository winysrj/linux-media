Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EEDC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 21:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2641220866
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 21:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="xPdDuYwJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbfAOV6d (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 16:58:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34988 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730622AbfAOV6c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 16:58:32 -0500
Received: by mail-wr1-f68.google.com with SMTP id 96so4748738wrb.2
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 13:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0zQGRhHmuQ24eZyF94rspF5Sd1MCXdctQKXRkMo0+80=;
        b=xPdDuYwJ4Z0FE3P8gDiR8Y1Lyw9aUsJXSDXAGlT8CdbUWBNRcuJg3Ee1d3i/CvXfk9
         byoqLaBV5HDtebbAbCT+7unmByVHJgCyDg7OjmB06LpugPuMtpUmNGSV2hHtf+abqRd1
         ef9PJgG32lSvpaA9hfnXnVGwTA1/9jZMiEWi6MQzQtQnwagRPrPlk7CXoPiRmVisTAIm
         7jsAiypuVPBW1bV48HU1smwLiULqcYNSbwAF8IqudJgnhD8yVdUZd6naREGYz0ApaG3p
         wjgX6tOr1fOuH5SWqm/i1p4b/6qjToKUZ8eJbE66SujoVioZGBEBm7IKTlnW2/ZNBRRv
         0U4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0zQGRhHmuQ24eZyF94rspF5Sd1MCXdctQKXRkMo0+80=;
        b=kFccZe0mtZv523NoK0EJkRx0ep4dS/kZ5q2xM3i/TKQ7/6tWNbt0927ZrZukJzAo5q
         KRQX6yMhbEBfM3/ZMlZJDflZMO9+WiDRowokkuIeyNQdOfVSsinkXyE5DvbNwhxMi0Vo
         t6jAuHr6DsfZLeVfymWixvhYcwE54F5hDYo4bexhE4V4mBtSFG1xFiICj2YGe7lhKRJF
         Fo6I9wa6by2EnQ3q0rkiW+tEFCS+p7UyXkz/QDzi3eRbDpH8urhrc+yVPjxdAUgXb98Y
         +NwqE7DGpcohQRP/znMjREv9wGcvmmZgfF2mBPiZBKOoQZVZh9U9+IAbr0A7XiUJiidr
         Jp4w==
X-Gm-Message-State: AJcUukeEWaEcdqeaiG2QvAGbMJTx1dSw3ErtaSDBPni0zXsSxNieZWaN
        pVqZm9MqqjL/Jjm2uUNEMPIkVrcbKewbygZaPluHWg==
X-Google-Smtp-Source: ALg8bN7izRK1RAwjh3wHK604mMpAbyMWJWyPtNT8NZ5P7S7nZZhQxZk/tFnbv4AdnXOkMBF1HABlhHScaGHpE5EDIaE=
X-Received: by 2002:a05:6000:108d:: with SMTP id y13mr4653891wrw.135.1547589510093;
 Tue, 15 Jan 2019 13:58:30 -0800 (PST)
MIME-Version: 1.0
References: <20190109183014.20466-1-slongerbeam@gmail.com> <20190109183014.20466-12-slongerbeam@gmail.com>
In-Reply-To: <20190109183014.20466-12-slongerbeam@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 15 Jan 2019 13:58:19 -0800
Message-ID: <CAJ+vNU1r86n1=9gKDw-bTO0sWJL7NMjZcdKMQO23a+WOR1H9tw@mail.gmail.com>
Subject: Re: [PATCH v8 11/11] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 9, 2019 at 10:30 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
> Also add an example pipeline for unconverted capture with interweave
> on SabreAuto.
>
> Cleanup some language in various places in the process.
>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v4:
> - Make clear that it is IDMAC channel that does pixel reordering and
>   interweave, not the CSI. Caught by Philipp Zabel.
> Changes since v3:
> - none.
> Changes since v2:
> - expand on idmac interweave behavior in CSI subdev.
> - switch second SabreAuto pipeline example to PAL to give
>   both NTSC and PAL examples.
> - Cleanup some language in various places.
> ---
>  Documentation/media/v4l-drivers/imx.rst | 103 +++++++++++++++---------
>  1 file changed, 66 insertions(+), 37 deletions(-)
>
<snip>
>  Capture Pipelines
>  -----------------
> @@ -516,10 +522,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
>  parallel bus input on the internal video mux to IPU1 CSI0.
>
>  The following example configures a pipeline to capture from the ADV7180
> -video decoder, assuming NTSC 720x480 input signals, with Motion
> -Compensated de-interlacing. Pad field types assume the adv7180 outputs
> -"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
> -entity at its output pad:
> +video decoder, assuming NTSC 720x480 input signals, using simple
> +interweave (unconverted and without motion compensation). The adv7180
> +must output sequential or alternating fields (field type 'seq-bt' for
> +NTSC, or 'alternate'):
> +
> +.. code-block:: none
> +
> +   # Setup links
> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> +   # Configure pads
> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
> +   # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
> +   v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
> +
> +Streaming can then begin on /dev/video4. The v4l2-ctl tool can also be
> +used to select any supported YUV pixelformat on /dev/video4.
> +

Hi Steve,

I'm testing 4.20 with this patchset on top.

I'm on a GW5104 which has an IMX6Q with the adv7180 on ipu1_csi0 like
the SabeAuto example above I can't get the simple interveave example
to work:

media-ctl -r # reset all links
# Setup links (ADV7180 IPU1_CSI0)
media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
media-ctl -l '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]' # /dev/video4
# Configure pads
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x480]"
# Configure 'ipu1_csi0 capture' interface (/dev/video4)
v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
# streaming can now begin on the raw capture device node at /dev/video4
v4l2-ctl -d4 --stream-mmap --stream-to=/x.raw --stream-count=1 # capture 1 frame
[ 5547.354460] ipu1_csi0: pipeline start failed with -32
VIDIOC_STREAMON: failed: Broken pipe

Any ideas what is causing this pipeline failure.

> +This example configures a pipeline to capture from the ADV7180
> +video decoder, assuming PAL 720x576 input signals, with Motion
> +Compensated de-interlacing. The adv7180 must output sequential or
> +alternating fields (field type 'seq-tb' for PAL, or 'alternate').
> +$outputfmt can be any format supported by the ipu1_ic_prpvf entity
> +at its output pad:
>
>  .. code-block:: none
>
> @@ -531,11 +560,11 @@ entity at its output pad:
>     media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
>     media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
>     # Configure pads
> -   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480]"
> -   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
> -   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480 field:interlaced]"
> -   media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480 field:none]"
> -   media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x576 field:seq-tb]"
> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x576]"
> +   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x576]"
> +   media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x576 field:none]"
> +   media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x576 field:none]"
>     media-ctl -V "'ipu1_ic_prpvf':1 [fmt:$outputfmt field:none]"
>
>  Streaming can then begin on the capture device node at

The above motion-compensation example pipeline does now work with this
patch series - thanks for addressing this!

Regards,

Tim
