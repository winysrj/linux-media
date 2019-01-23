Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EBCC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 22:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AD952184C
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 22:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="ryRRG+aG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfAWWFE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:05:04 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33947 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfAWWFE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 17:05:04 -0500
Received: by mail-wr1-f67.google.com with SMTP id f7so4325721wrp.1
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 14:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LHqGHOw+LpZ0WXq7RRAOsEKQr3EaLGfU4KkyfzwR194=;
        b=ryRRG+aGzvlRekcTqU9CUK09GEENWDE5z4yl+MZ/u2PnsTXImCAmysyrAPb/z44QQt
         AJUwa9BfUBYvCxQaR+b5JTjCXhuGQWkzOZNPSGcEFHbn1gruGv6YJJpOS56fAuSYEAtf
         u2f2oNgdLK+dpCEef88Kd/uVFzBqIALZAlPCLUWE80xv5xMQqI8qx/hw+5U7Z2xIEDgB
         XGzFXpS31VWv/Um9/KI3OSdl3DQ2BES9kMZhPyR5AozII6HHNlHIkIguzt6Xxvn8mGFf
         xsRyZnXc6VM4fhc3r3gJb1dVIWndDmQlUimpevIQWRrhu9QYDxj47YgcPamfQOCFEsbz
         vG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LHqGHOw+LpZ0WXq7RRAOsEKQr3EaLGfU4KkyfzwR194=;
        b=sKcQdQCdqmhTMOodEi7KmKkT/T1cstnXEX/5WBu5f1pux28Sz3c5qBFnTFP7RjmTBv
         VgCjL+nNHIS5qazLfHZCkcUvxOxDY0dPMLj7yEw+D8BrWl/NDQvHqBah7FTOGlo8KjiV
         i+++Wnih8zit39Rx/XlEfOwEuQJyVYTc1y1FXZNuVZv3rTepxeS38Lhic3fQfyXn8gvP
         pnNFeh3aCYsG8piwpflfueCpTQrqiNnaRoZPsUjQQfSdC5HVcnWdBvs/DZFRbAlSokrX
         HbEz23sUz/wrHZKwi+1/LOLsqYXZ+DlkOGuqctQoHGTQKHSLw0BeFjr3HTDVpYcOtFcB
         vh3g==
X-Gm-Message-State: AJcUukdFmjQunrUkzmsidfQ1E78g0cK8yRByju+QGlaZMVz+wxQm2sIM
        vfF81HvFfu4Vr7QS9vbxIJ5sEXOMYaG4Rqvk0OIRcg==
X-Google-Smtp-Source: ALg8bN4iPq6wjQFMKzs4iFl4l7dIaaQ4rDWn116B5Bs84wqm8yJjtXKWw6+qoJfuu6G1b96uGUSwMqVa6BS5yjzh1Y0=
X-Received: by 2002:adf:be8b:: with SMTP id i11mr4703715wrh.235.1548281101964;
 Wed, 23 Jan 2019 14:05:01 -0800 (PST)
MIME-Version: 1.0
References: <20190109183014.20466-1-slongerbeam@gmail.com> <20190109183014.20466-12-slongerbeam@gmail.com>
 <CAJ+vNU1r86n1=9gKDw-bTO0sWJL7NMjZcdKMQO23a+WOR1H9tw@mail.gmail.com>
 <6b4c3fb1-929b-8894-e2f9-aca2f392f0e5@gmail.com> <CAJ+vNU2827H8C3PN=v++XRjd0LP6Uf1KzMAs0bFTgbX93v7atg@mail.gmail.com>
 <aca68d5d-25ef-daef-c396-d32e4099c28f@gmail.com>
In-Reply-To: <aca68d5d-25ef-daef-c396-d32e4099c28f@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Wed, 23 Jan 2019 14:04:50 -0800
Message-ID: <CAJ+vNU242ezHfKUL+zOVi0Jr3mz9RXHFnLe25Qv3o3SQH+ob_Q@mail.gmail.com>
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

On Tue, Jan 22, 2019 at 4:10 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>
>
> On 1/21/19 12:24 PM, Tim Harvey wrote:
> > On Tue, Jan 15, 2019 at 3:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
> >> Hi Tim,
> >>
> >> On 1/15/19 1:58 PM, Tim Harvey wrote:
> >>> On Wed, Jan 9, 2019 at 10:30 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
> >>>> Also add an example pipeline for unconverted capture with interweave
> >>>> on SabreAuto.
> >>>>
> >>>> Cleanup some language in various places in the process.
> >>>>
> >>>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> >>>> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> >>>> ---
> >>>> Changes since v4:
> >>>> - Make clear that it is IDMAC channel that does pixel reordering and
> >>>>     interweave, not the CSI. Caught by Philipp Zabel.
> >>>> Changes since v3:
> >>>> - none.
> >>>> Changes since v2:
> >>>> - expand on idmac interweave behavior in CSI subdev.
> >>>> - switch second SabreAuto pipeline example to PAL to give
> >>>>     both NTSC and PAL examples.
> >>>> - Cleanup some language in various places.
> >>>> ---
> >>>>    Documentation/media/v4l-drivers/imx.rst | 103 +++++++++++++++---------
> >>>>    1 file changed, 66 insertions(+), 37 deletions(-)
> >>>>
> >>> <snip>
> >>>>    Capture Pipelines
> >>>>    -----------------
> >>>> @@ -516,10 +522,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
> >>>>    parallel bus input on the internal video mux to IPU1 CSI0.
> >>>>
> >>>>    The following example configures a pipeline to capture from the ADV7180
> >>>> -video decoder, assuming NTSC 720x480 input signals, with Motion
> >>>> -Compensated de-interlacing. Pad field types assume the adv7180 outputs
> >>>> -"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
> >>>> -entity at its output pad:
> >>>> +video decoder, assuming NTSC 720x480 input signals, using simple
> >>>> +interweave (unconverted and without motion compensation). The adv7180
> >>>> +must output sequential or alternating fields (field type 'seq-bt' for
> >>>> +NTSC, or 'alternate'):
> >>>> +
> >>>> +.. code-block:: none
> >>>> +
> >>>> +   # Setup links
> >>>> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
> >>>> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> >>>> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> >>>> +   # Configure pads
> >>>> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> >>>> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> >>>> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
> >>>> +   # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
> >>>> +   v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
> >>>> +
> >>>> +Streaming can then begin on /dev/video4. The v4l2-ctl tool can also be
> >>>> +used to select any supported YUV pixelformat on /dev/video4.
> >>>> +
> >>> Hi Steve,
> >>>
> >>> I'm testing 4.20 with this patchset on top.
> >>>
> >>> I'm on a GW5104 which has an IMX6Q with the adv7180 on ipu1_csi0 like
> >>> the SabeAuto example above I can't get the simple interveave example
> >>> to work:
> >>>
> >>> media-ctl -r # reset all links
> >>> # Setup links (ADV7180 IPU1_CSI0)
> >>> media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
> >>> media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
> >>> media-ctl -l '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]' # /dev/video4
> >>> # Configure pads
> >>> media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> >>> media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> >>> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x480]"
> >> This is the reason. The adv7180 is only allowing to configure alternate
> >> field mode, and thus it reports the field height on the mbus, not the
> >> full frame height. Imx deals with alternate field mode by capturing a
> >> full frame, so the CSI entity sets the output pad height to double the
> >> height.
> >>
> >> So the CSI input pad needs to be configured with the field height:
> >>
> >> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x240]"
> >>
> >> It should work for you after doing that. And better yet, don't bother
> >> configuring the input pad, because media-ctl will propagate formats from
> >> source to sink pads for you, so it's better to rely on the propagation,
> >> and set the CSI output pad format instead (full frame height at output pad):
> >>
> >> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
> >>
> > Steve,
> >
> > Thanks - that makes sense.
> >
> > I also noticed that if I setup one of the vdic pipelines first then
> > went back after a 'media-ctl -r' and setup the example that failed it
> > no longer failed. I'm thinking that this is because 'media-ctl -r'
> > make reset all the links but does not reset all the V4L2 formats on
> > pads?
> >
> >> Final note: the imx.rst doc is technically correct even though it is
> >> showing full frame heights being configured at the pads, because it is
> >> expecting the adv7180 has accepted 'seq-bt'. But even the example given
> >> in that doc works for alternate field mode, because the pad heights are
> >> forced to the correct field height for alternate mode.
> >>
> > hmmm... I don't quite follow this statement. It sounds like the
> > example would only be correct if you were setting 'field:alternate'
> > but the example sets 'field:seq-bt' instead.
>
> The example is consistent for a sensor that sends seq-bt. Here is the
> example config from the imx.rst doc again, a (ntsc) height of 480 lines
> is correct for a seq-bt source:
>
>     # Setup links
>     media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
>     media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
>     media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
>     # Configure pads
>     media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
>     media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
>     media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
>     # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
>     v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
>
> > I wonder if you should add some verbiage explaining the difference in
> > format (resolution specifically) between the input and output pads
> > and/or change the example to set the output pad format so people don't
> > run into what I did trying to follow the example.
> >
>
> Well, the example *is* setting the output pad format (media-ctl -V
> "ipu1_csi0:2 ...").
>
> But I suppose wording could be added such as "this example assumes the
> sensor (adv7180) supports seq-bt".
>

Steve,

Your absolutely right - my usage which set the input pad wasn't even
following your example (by accident) so your example is good and makes
sense.

Your explanation for the failure of linking vdic->ic_prp->ic_prpenc in
the previous message makes sense also.

I'm testing again with the tda1997x HDMI receiver which provides a
wide variety of input's to test IMX6 capture with (resolutions,
progressive vs interlaced, bt656 fmt vs yuvsmp bus format) and running
into some issues but I'll post them in a new thread.

This series looks good and does fix several interlaced capture issues.

Acked-by: Tim Harvey <tharvey@gateworks.com>

Tested on GW5104/GW5404 with adv7180

Tested-by: Tim Harvey <tharvey@gateowrks.com>

Thanks,

Tim
