Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50929 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932308AbeFTIyP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 04:54:15 -0400
Message-ID: <1529484851.4008.1.camel@pengutronix.de>
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced
 scanning
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 20 Jun 2018 10:54:11 +0200
In-Reply-To: <20db0ee3-1202-67fd-84b9-d6e0255dec06@gmail.com>
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
         <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
         <1528708771.3818.7.camel@pengutronix.de>
         <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
         <2aff8f80-aa79-6718-6183-6e49088ae498@redhat.com>
         <f6e7eaa3-355e-a5d9-1be5-e5db08a99897@gmail.com>
         <m3h8m5yaeh.fsf@t19.piap.pl>
         <798b8ad7-2fce-8408-b1c4-c2954f524d23@gmail.com>
         <m336xoxxcd.fsf@t19.piap.pl>
         <20db0ee3-1202-67fd-84b9-d6e0255dec06@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Tue, 2018-06-19 at 18:30 -0700, Steve Longerbeam wrote:
> Hi Philipp, Krzysztof,
> 
> On 06/15/2018 01:33 AM, Krzysztof Hałasa wrote:
> > Steve Longerbeam <slongerbeam@gmail.com> writes:
> > 
> > > Right, the selection of interweave is moved to the capture devices,
> > > so the following will enable interweave:
> > > 
> > > v4l2-ctl -dN --set-fmt-video=field=interlaced_tb
> > 
> > and
> > 
> > > So the patch to adv7180 needs to be modified to report # field lines.
> > > 
> > > Try the following:
> > > 
> > > --- a/drivers/media/i2c/adv7180.c
> > > +++ b/drivers/media/i2c/adv7180.c
> > 
> > With this patch, fix-csi-interlaced.3 seems to work for me.
> > "ipu2_csi1":2 reports [fmt:AYUV32/720x576 field:seq-tb], but the
> > /dev/videoX shows (when requested) 720 x 576 NV12 interlaced, top field
> > first, and I'm getting valid output.
> > 
> > Thanks for your work.
> 
> I've found some time to diagnose the behavior of interweave with B/T line
> swapping (to support interlaced-bt) with planar formats.
> 
> There are a couple problems (one known and one unknown):
> 
> 1. This requires 32 pixel alignment to meet the IDMAC 8-byte alignment
>      of the planar U/V buffer offsets, and 32 pixel alignment precludes
>      capturing raw NTSC/PAL at 720 pixel line stride.

What needs to be aligned to multiples of 32 pixels?

I thought 8 pixel width alignment should be good enough for NV12/NV16,
for which luma and chroma strides are equal to the width in pixels, and
16 pixel alignment for YUV420/YVU420/YUV422P, where chroma stride is
half the width in pixels.

> 2. Even with 32 pixel aligned frames, for example by using the prpenc scaler
>      to generate 704 pixel strides from 720, the colors are still wrong when
>      capturing interlaced-bt.

As a side note, we can't properly scale seq-tb/bt direct input from the
CSI vertically with the IC, as the bottom line of the first field will
be blended with the top line of the second field...

>  I thought for sure this must be because we 
> also
>      need to double the SLUV line strides in addition to doubling SLY 
> line stride.
>      But I tried this and the results are that it works only for YUV 
> 4:2:2. For 4:2:0
>      it causes system hard lockups. (Aside note: interweave without line 
> swap
>      apparently has never worked for 4:2:2, even when doubling SLUV, so it's
>      quite bizarre to me why 4:2:2 interweave _with_ line swap _does_ work
>      after doubling SLUV).

When you say 4:2:2 you only mean YUV422P, not NV16 or YUYV/UYVY ?

> For these reasons I think we should disallow interlaced-bt with planar 
> formats.

Does that include NV12/NV16? Capturing to NV12 could be desirable if at
all possible, because the result can be encoded by the CODA. The other
formats are bandwidth inefficient anyway.

> If the user needs NTSC interlaced capture with planar, the fields can be 
> swapped at
> the CSI, by selecting seq-tb at the CSI source pad, which allows for 
> interlaced-tb
> at the capture interface, which doesn't require interweave line swapping.

regards
Philipp
