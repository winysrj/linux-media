Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26359C37120
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 20:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C515720844
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 20:24:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="EPRfLJWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfAUUYy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 15:24:54 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35376 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfAUUYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 15:24:54 -0500
Received: by mail-wr1-f54.google.com with SMTP id 96so24913964wrb.2
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 12:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+kNxBWcx9FlQtYo+QTClvu5wwFACfZ6lH7rIFaQJ/dA=;
        b=EPRfLJWBNnQ6sKNrd5Rg3vtNCWbJNFvXNvXET2uu5r2GX/7y0p3p0PSzXgm8W58VAr
         lAfhnL+sVx58kjvIsGE/vKfrZbvmzVb7CgS1A4CKEe/vl6TRl9ocSNB3mo+hSF+hymCB
         9KbZF3eV+ihm03Js53l80nHJxMDTIw6zDCcPQC08ukFsPtfYE86w4gcj0CRzZrV5zrz6
         2NJYBq7btGdZH3V3selQo4ZFHp+PiiY/4VqkA6IQngviFJLOP8tzp8hZSib9R8WmvGrF
         Dj76MCayhMpwHg9QcHhDExgYOXgmba78ItOyjlZOZJx2h1nG2LO8OcW/Tg6VcfsJRBlJ
         PjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+kNxBWcx9FlQtYo+QTClvu5wwFACfZ6lH7rIFaQJ/dA=;
        b=uZzC+hm9fjevtljbRACje1qYXI8jIUol3Epc2s0EHUZRRFRUbcpSnnIW91dPZH0hqS
         RyLVfib6MKgarIPW4hDAO9HPkXgqbsnxqWwvN9cO3Ot/ot2iVWI5ZGA+gqaaMUkh4any
         /YOpkyog+vPF12jlVIA5BgcYxAEWFkoL7x68MYT3F8e3iPk5OmQyt3UFgHeNPNVCKESk
         FwFcwwTFr6LkKd8YC5DuSsRUpiJ4Qw6NGanRHrDtVn7X0dJWdOz7VVBRy2yinhYe3GrR
         PqckRyFmDE7xh+LP866XKSVun2sLZRwM7Xc4xYO89SA2TMpIjYP66SjPAqGoCbnMxj0p
         YdLQ==
X-Gm-Message-State: AJcUukdZi+VZ8kCUKKatATQ8kU7HXhuVXOgxNDSJyvd4AaqyRD0Ny78i
        pXJZyi1jhFCjWiY0z2NqFTYnjk9jX7gpcYC4baWu/A==
X-Google-Smtp-Source: ALg8bN5CuUdNZ9TvCJun7Gu4xw6sRgJKIs5mTOxeUSPNaSOFmIRIBKN6ljoGRW+LcesO3hnY2iIeIlbSJgsFLZyv4TM=
X-Received: by 2002:adf:9b11:: with SMTP id b17mr30007249wrc.168.1548102291697;
 Mon, 21 Jan 2019 12:24:51 -0800 (PST)
MIME-Version: 1.0
References: <20190109183014.20466-1-slongerbeam@gmail.com> <20190109183014.20466-12-slongerbeam@gmail.com>
 <CAJ+vNU1r86n1=9gKDw-bTO0sWJL7NMjZcdKMQO23a+WOR1H9tw@mail.gmail.com> <6b4c3fb1-929b-8894-e2f9-aca2f392f0e5@gmail.com>
In-Reply-To: <6b4c3fb1-929b-8894-e2f9-aca2f392f0e5@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 21 Jan 2019 12:24:40 -0800
Message-ID: <CAJ+vNU2827H8C3PN=v++XRjd0LP6Uf1KzMAs0bFTgbX93v7atg@mail.gmail.com>
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

On Tue, Jan 15, 2019 at 3:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
> Hi Tim,
>
> On 1/15/19 1:58 PM, Tim Harvey wrote:
> > On Wed, Jan 9, 2019 at 10:30 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
> >> Also add an example pipeline for unconverted capture with interweave
> >> on SabreAuto.
> >>
> >> Cleanup some language in various places in the process.
> >>
> >> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> >> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> >> ---
> >> Changes since v4:
> >> - Make clear that it is IDMAC channel that does pixel reordering and
> >>    interweave, not the CSI. Caught by Philipp Zabel.
> >> Changes since v3:
> >> - none.
> >> Changes since v2:
> >> - expand on idmac interweave behavior in CSI subdev.
> >> - switch second SabreAuto pipeline example to PAL to give
> >>    both NTSC and PAL examples.
> >> - Cleanup some language in various places.
> >> ---
> >>   Documentation/media/v4l-drivers/imx.rst | 103 +++++++++++++++---------
> >>   1 file changed, 66 insertions(+), 37 deletions(-)
> >>
> > <snip>
> >>   Capture Pipelines
> >>   -----------------
> >> @@ -516,10 +522,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
> >>   parallel bus input on the internal video mux to IPU1 CSI0.
> >>
> >>   The following example configures a pipeline to capture from the ADV7180
> >> -video decoder, assuming NTSC 720x480 input signals, with Motion
> >> -Compensated de-interlacing. Pad field types assume the adv7180 outputs
> >> -"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
> >> -entity at its output pad:
> >> +video decoder, assuming NTSC 720x480 input signals, using simple
> >> +interweave (unconverted and without motion compensation). The adv7180
> >> +must output sequential or alternating fields (field type 'seq-bt' for
> >> +NTSC, or 'alternate'):
> >> +
> >> +.. code-block:: none
> >> +
> >> +   # Setup links
> >> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
> >> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> >> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> >> +   # Configure pads
> >> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> >> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> >> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
> >> +   # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
> >> +   v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
> >> +
> >> +Streaming can then begin on /dev/video4. The v4l2-ctl tool can also be
> >> +used to select any supported YUV pixelformat on /dev/video4.
> >> +
> > Hi Steve,
> >
> > I'm testing 4.20 with this patchset on top.
> >
> > I'm on a GW5104 which has an IMX6Q with the adv7180 on ipu1_csi0 like
> > the SabeAuto example above I can't get the simple interveave example
> > to work:
> >
> > media-ctl -r # reset all links
> > # Setup links (ADV7180 IPU1_CSI0)
> > media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
> > media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
> > media-ctl -l '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]' # /dev/video4
> > # Configure pads
> > media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> > media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> > media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x480]"
>
> This is the reason. The adv7180 is only allowing to configure alternate
> field mode, and thus it reports the field height on the mbus, not the
> full frame height. Imx deals with alternate field mode by capturing a
> full frame, so the CSI entity sets the output pad height to double the
> height.
>
> So the CSI input pad needs to be configured with the field height:
>
> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x240]"
>
> It should work for you after doing that. And better yet, don't bother
> configuring the input pad, because media-ctl will propagate formats from
> source to sink pads for you, so it's better to rely on the propagation,
> and set the CSI output pad format instead (full frame height at output pad):
>
> media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
>

Steve,

Thanks - that makes sense.

I also noticed that if I setup one of the vdic pipelines first then
went back after a 'media-ctl -r' and setup the example that failed it
no longer failed. I'm thinking that this is because 'media-ctl -r'
make reset all the links but does not reset all the V4L2 formats on
pads?

>
> Final note: the imx.rst doc is technically correct even though it is
> showing full frame heights being configured at the pads, because it is
> expecting the adv7180 has accepted 'seq-bt'. But even the example given
> in that doc works for alternate field mode, because the pad heights are
> forced to the correct field height for alternate mode.
>

hmmm... I don't quite follow this statement. It sounds like the
example would only be correct if you were setting 'field:alternate'
but the example sets 'field:seq-bt' instead.

I wonder if you should add some verbiage explaining the difference in
format (resolution specifically) between the input and output pads
and/or change the example to set the output pad format so people don't
run into what I did trying to follow the example.

Tim
