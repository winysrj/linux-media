Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35333 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932610AbeGDGJC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 02:09:02 -0400
Received: by mail-lf0-f65.google.com with SMTP id i15-v6so3430588lfc.2
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 23:09:01 -0700 (PDT)
Date: Wed, 4 Jul 2018 08:08:59 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 0/10] rcar-vin: Add support for parallel input on Gen3
Message-ID: <20180704060858.GA5237@bigcity.dyn.berto.se>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <20180702181104.GZ5237@bigcity.dyn.berto.se>
 <20180703180210.GB5611@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180703180210.GB5611@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 2018-07-03 20:02:10 +0200, Jacopo Mondi wrote:
> Hi Hans,
>    As the VIN driver went through your tree, could you please pick
> this series up now that all patches have been acked-by/reviewed-by and
> tested on several platforms?
> 
> Thank you...
> 
> On Mon, Jul 02, 2018 at 08:11:04PM +0200, Niklas Söderlund wrote:
> > Hi Jacopo,
> >
> > Nice work, I'm happy with the work you have done thanks!
> >
> > I have tested this series on M3-N to make sure it don't break anything
> > on existing Gen3. Tested on V3M to make sure you can switch between
> > CSI-2 and parallel input at runtime. And last I tested it on Koelsch to
> > make sure Gen2 still works. All tests looks good.
> >
> > Thanks for your effort!
> 
> Thanks for doing this Niklas...
> 
> With your recent testing this series has been tested on:
> 
> D3: parallel input
> M3W: parallel and CSI-2

Now I'm curious, how did you test parallel on M3-W ?

I would like to have one platform in my farm to always be ready to test 
parallel on Gen3. I have other GMSL related plans for my V3M so if this 
can be done on M3-W it would be a step in the right direction for me :-)

> M3N: CSI-2
> V3M: parallel and CSI-2
> Gen2 Koelsch: parallel
> 
> I guess is then good to go.
> 
> Thanks
>    j
> 
> 
> >
> > On 2018-06-12 11:43:22 +0200, Jacopo Mondi wrote:
> > > Hello,
> > >    this series adds support for parallel video input to the Gen3 version of
> > > rcar-vin driver.
> > >
> > > Few changes compared to v5, closing a few comments from Kieran and Niklas,
> > > and fixed the label names I forgot to change in previous version.
> > >
> > > Changlog in the individual patches when relevant.
> > >
> > > A few patches have not yet been acked-by, but things look smooth and we
> > > should be close to have this finalized.
> > >
> > > Thanks
> > >    j
> > >
> > > Jacopo Mondi (10):
> > >   media: rcar-vin: Rename 'digital' to 'parallel'
> > >   media: rcar-vin: Remove two empty lines
> > >   media: rcar-vin: Create a group notifier
> > >   media: rcar-vin: Cleanup notifier in error path
> > >   media: rcar-vin: Cache the mbus configuration flags
> > >   media: rcar-vin: Parse parallel input on Gen3
> > >   media: rcar-vin: Link parallel input media entities
> > >   media: rcar-vin: Handle parallel subdev in link_notify
> > >   media: rcar-vin: Rename _rcar_info to rcar_info
> > >   media: rcar-vin: Add support for R-Car R8A77995 SoC
> > >
> > >  drivers/media/platform/rcar-vin/rcar-core.c | 265 ++++++++++++++++++----------
> > >  drivers/media/platform/rcar-vin/rcar-dma.c  |  36 ++--
> > >  drivers/media/platform/rcar-vin/rcar-v4l2.c |  12 +-
> > >  drivers/media/platform/rcar-vin/rcar-vin.h  |  29 +--
> > >  4 files changed, 223 insertions(+), 119 deletions(-)
> > >
> > > --
> > > 2.7.4
> > >
> >
> > --
> > Regards,
> > Niklas Söderlund



-- 
Regards,
Niklas Söderlund
