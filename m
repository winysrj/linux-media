Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C112C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 19:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C350217F5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 19:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="uCygidDP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfAVTvx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 14:51:53 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:56285 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfAVTvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 14:51:53 -0500
Received: by mail-wm1-f52.google.com with SMTP id y139so15318306wmc.5
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 11:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=opdI1EmEC2n7v+vujysHElacdMej05sX9wLZpMPoehU=;
        b=uCygidDPofH5Wltenay604FBc3E+ZS7Ee9wDrIrhDHxYQirk1FPQyd+AFKIrvv/m6M
         OmLojoXOgmh1IBL6aBM1jwc6uvzMEYlZkgT2z5VAQGe8LqEoPYSTTMeLpJux+Kv+YeyW
         1apVgkxOX9zjL/94C0ZN44GDhm9lGNXtWTCU03q5aCYkz5kUekowM/xS2PXQLNI1xqS3
         84q5nylI5cJqIPcAHtDTcgnewkO+l1q7rsKQXVZBjsOt5BBmST20oMgcSqFOLvrmblRj
         8ZUXOfxeJoKJWhUG03CAdSTFoYv1CcvrIps3MP9+To+i0ZWBIu4uaYaMOMhutnN+C58w
         WOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=opdI1EmEC2n7v+vujysHElacdMej05sX9wLZpMPoehU=;
        b=LXElVlJ2O9VztC3eH2wOTbFf/gzwDsLHqSu16u2mYfdRS3rZ/GYxJU7sSgDeYRDvf6
         58egKnrH1VcvSK3yE94N8Z8XlQ1S1exmyEn6cxgYxUWG9L2vMlXNfrNIBLTj8dzGyLQ3
         wvkM0jiP5PcQ9Ze8GcEPTkf7SGyifYMxA1PbAacYL5rzO34Acz54QNX8bRqdUspmAHjo
         e4rULpgKm49mibvEl3bCWqnUURTg/CBMAJDQ+hEvdiWSsAvAIPElJhpdm3iq539yW8Jt
         aMtgioZ5v9g8fqRaakOEUvuZay7RIkekk57lEhqgioKQM8W8YFtTdQws6rhWefpsRfDG
         EkTw==
X-Gm-Message-State: AJcUukdlpLNpaXftyttGli3d+Odx8DC4wsoiFX+vzqJHpXrS9Pa6KMNE
        iZHrymNUwmUxram+fmL2kEIjtuWtJfVvCpjMwLwnbg==
X-Google-Smtp-Source: ALg8bN467cjntQ9dAYUs5DVryCCLN9ag1eh37b68bq+4+1WDmEu2P1eiYmIBgRq8azdGh+u7QNhnMXWsdODx7ZXiGjg=
X-Received: by 2002:a1c:8b09:: with SMTP id n9mr5060684wmd.38.1548186711185;
 Tue, 22 Jan 2019 11:51:51 -0800 (PST)
MIME-Version: 1.0
References: <20190109183014.20466-1-slongerbeam@gmail.com> <20190109183014.20466-12-slongerbeam@gmail.com>
 <CAJ+vNU1r86n1=9gKDw-bTO0sWJL7NMjZcdKMQO23a+WOR1H9tw@mail.gmail.com>
 <6b4c3fb1-929b-8894-e2f9-aca2f392f0e5@gmail.com> <CAJ+vNU2827H8C3PN=v++XRjd0LP6Uf1KzMAs0bFTgbX93v7atg@mail.gmail.com>
In-Reply-To: <CAJ+vNU2827H8C3PN=v++XRjd0LP6Uf1KzMAs0bFTgbX93v7atg@mail.gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 22 Jan 2019 11:51:39 -0800
Message-ID: <CAJ+vNU3+WiLd6h7efDmaU1nsqVENB-0W5pUsVD3D19doyScRnQ@mail.gmail.com>
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

On Mon, Jan 21, 2019 at 12:24 PM Tim Harvey <tharvey@gateworks.com> wrote:
>
> On Tue, Jan 15, 2019 at 3:54 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
> >
> > Hi Tim,
> >
> > On 1/15/19 1:58 PM, Tim Harvey wrote:
> > > On Wed, Jan 9, 2019 at 10:30 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
> > >> Also add an example pipeline for unconverted capture with interweave
> > >> on SabreAuto.
> > >>
> > >> Cleanup some language in various places in the process.
> > >>
> > >> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> > >> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> > >> ---
> > >> Changes since v4:
> > >> - Make clear that it is IDMAC channel that does pixel reordering and
> > >>    interweave, not the CSI. Caught by Philipp Zabel.
> > >> Changes since v3:
> > >> - none.
> > >> Changes since v2:
> > >> - expand on idmac interweave behavior in CSI subdev.
> > >> - switch second SabreAuto pipeline example to PAL to give
> > >>    both NTSC and PAL examples.
> > >> - Cleanup some language in various places.
> > >> ---
> > >>   Documentation/media/v4l-drivers/imx.rst | 103 +++++++++++++++---------
> > >>   1 file changed, 66 insertions(+), 37 deletions(-)
> > >>
> > > <snip>
> > >>   Capture Pipelines
> > >>   -----------------
> > >> @@ -516,10 +522,33 @@ On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
> > >>   parallel bus input on the internal video mux to IPU1 CSI0.
> > >>
> > >>   The following example configures a pipeline to capture from the ADV7180
> > >> -video decoder, assuming NTSC 720x480 input signals, with Motion
> > >> -Compensated de-interlacing. Pad field types assume the adv7180 outputs
> > >> -"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
> > >> -entity at its output pad:
> > >> +video decoder, assuming NTSC 720x480 input signals, using simple
> > >> +interweave (unconverted and without motion compensation). The adv7180
> > >> +must output sequential or alternating fields (field type 'seq-bt' for
> > >> +NTSC, or 'alternate'):
> > >> +
> > >> +.. code-block:: none
> > >> +
> > >> +   # Setup links
> > >> +   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
> > >> +   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
> > >> +   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> > >> +   # Configure pads
> > >> +   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> > >> +   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> > >> +   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
> > >> +   # Configure "ipu1_csi0 capture" interface (assumed at /dev/video4)
> > >> +   v4l2-ctl -d4 --set-fmt-video=field=interlaced_bt
> > >> +
> > >> +Streaming can then begin on /dev/video4. The v4l2-ctl tool can also be
> > >> +used to select any supported YUV pixelformat on /dev/video4.
> > >> +
> > > Hi Steve,
> > >
> > > I'm testing 4.20 with this patchset on top.
> > >
> > > I'm on a GW5104 which has an IMX6Q with the adv7180 on ipu1_csi0 like
> > > the SabeAuto example above I can't get the simple interveave example
> > > to work:
> > >
> > > media-ctl -r # reset all links
> > > # Setup links (ADV7180 IPU1_CSI0)
> > > media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
> > > media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
> > > media-ctl -l '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]' # /dev/video4
> > > # Configure pads
> > > media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
> > > media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480]"
> > > media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x480]"
> >
> > This is the reason. The adv7180 is only allowing to configure alternate
> > field mode, and thus it reports the field height on the mbus, not the
> > full frame height. Imx deals with alternate field mode by capturing a
> > full frame, so the CSI entity sets the output pad height to double the
> > height.
> >
> > So the CSI input pad needs to be configured with the field height:
> >
> > media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x240]"
> >
> > It should work for you after doing that. And better yet, don't bother
> > configuring the input pad, because media-ctl will propagate formats from
> > source to sink pads for you, so it's better to rely on the propagation,
> > and set the CSI output pad format instead (full frame height at output pad):
> >
> > media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/720x480]"
> >
>
> Steve,
>
> Thanks - that makes sense.
>
> I also noticed that if I setup one of the vdic pipelines first then
> went back after a 'media-ctl -r' and setup the example that failed it
> no longer failed. I'm thinking that this is because 'media-ctl -r'
> make reset all the links but does not reset all the V4L2 formats on
> pads?
>
> >
> > Final note: the imx.rst doc is technically correct even though it is
> > showing full frame heights being configured at the pads, because it is
> > expecting the adv7180 has accepted 'seq-bt'. But even the example given
> > in that doc works for alternate field mode, because the pad heights are
> > forced to the correct field height for alternate mode.
> >
>
> hmmm... I don't quite follow this statement. It sounds like the
> example would only be correct if you were setting 'field:alternate'
> but the example sets 'field:seq-bt' instead.
>
> I wonder if you should add some verbiage explaining the difference in
> format (resolution specifically) between the input and output pads
> and/or change the example to set the output pad format so people don't
> run into what I did trying to follow the example.
>

Steve,

I'm able to link a sensor->mux->csi->vdic->ic_prp->ic_prpenc but not a
sensor->mux->csi->vdic->ic_prp->ic_prpvf pipeline:

- imx6q-gw54xx adv7180 2-0020 IPU2_CSI1 sensor->mux->csi->vdic->ic_prp->ic_prpvf
# sensor format
media-ctl --get-v4l2 '"adv7180 2-0020":0' #
fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m
# reset all links
media-ctl --reset
# setup links
media-ctl -l "'adv7180 2-0020':0 -> 'ipu2_csi1_mux':1[1]"
media-ctl -l "'ipu2_csi1_mux':2 -> 'ipu2_csi1':0[1]"
media-ctl -l "'ipu2_csi1':1 -> 'ipu2_vdic':0[1]"
media-ctl -l "'ipu2_vdic':2 -> 'ipu2_ic_prp':0[1]"
media-ctl -l "'ipu2_ic_prp':2 -> 'ipu2_ic_prpvf':0[1]"
media-ctl -l "'ipu2_ic_prpvf':1 -> 'ipu2_ic_prpvf capture':0[1]"
# configure pads
media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/720x480 field:seq-bt]"
media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x480]"
media-ctl -V "'ipu2_csi1':1 [fmt:AYUV32/720x480]"
media-ctl -V "'ipu2_vdic':2 [fmt:AYUV32/720x480 field:none]"
media-ctl -V "'ipu2_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
media-ctl -V "'ipu2_ic_prpvf':1 [fmt:AYUV32/720x480]"
# capture device
media-ctl -e 'ipu2_ic_prpvf capture' # /dev/video3
# capture 1 frame
v4l2-ctl --device /dev/video3 --stream-mmap --stream-to=x.raw --stream-count=1
^^^ works

- imx6q-gw54xx adv7180 2-0020 IPU2_CSI1
sensor->mux->csi->vdic->ic_prp->ic_prpenc
# sensor format
media-ctl --get-v4l2 '"adv7180 2-0020":0' #
fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m
# reset all links
media-ctl --reset
# setup links
media-ctl -l "'adv7180 2-0020':0 -> 'ipu2_csi1_mux':1[1]"
media-ctl -l "'ipu2_csi1_mux':2 -> 'ipu2_csi1':0[1]"
media-ctl -l "'ipu2_csi1':1 -> 'ipu2_vdic':0[1]"
media-ctl -l "'ipu2_vdic':2 -> 'ipu2_ic_prp':0[1]"
media-ctl -l "'ipu2_ic_prp':1 -> 'ipu2_ic_prpenc':0[1]"
Unable to setup formats: Invalid argument (22)

using Linux 4.20 + the following patch series:
  - media: imx-csi: Input connections to CSI should be optional
  - imx-media: Fixes for interlaced capture
v4l-utils 1.16.1

See http://dev.gateworks.com/docs/linux/media/imx6q-gw54xx-media.png

My understanding is that the ic_prpenc and ic_prpvf entities are
identical and it looks like I'm using the right pads. I'm also seeing
the same on a board that uses ipu1_csi0 instead.

Any ideas?

Regards,

Tim
