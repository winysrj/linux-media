Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52560 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbeLDNNi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 08:13:38 -0500
Date: Tue, 4 Dec 2018 15:13:33 +0200
From: sakari.ailus@iki.fi
To: Chen-Yu Tsai <wens@csie.org>
Cc: Jagan Teki <jagan@amarulasolutions.com>,
        Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] media: dt-bindings: media: sun6i: Separate H3
 compatible from A31
Message-ID: <20181204131333.peobmjkksl2p3hvv@valkosipuli.retiisi.org.uk>
References: <20181130075849.16941-1-wens@csie.org>
 <20181130075849.16941-2-wens@csie.org>
 <CAMty3ZC-4hnVOx9AYhm7uUCUHF=n_NoH3xV-3SyUXWxb_X8TGg@mail.gmail.com>
 <CAGb2v67xoqV+QuVxDyBrUzzpab9vsbJRQBFPA0OS=h_bZ2H7Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v67xoqV+QuVxDyBrUzzpab9vsbJRQBFPA0OS=h_bZ2H7Tw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chen-Yu,

On Mon, Dec 03, 2018 at 05:48:31PM +0800, Chen-Yu Tsai wrote:
> On Mon, Dec 3, 2018 at 5:42 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
> >
> > On Fri, Nov 30, 2018 at 1:29 PM Chen-Yu Tsai <wens@csie.org> wrote:
> > >
> > > The CSI controller found on the H3 (and H5) is a reduced version of the
> > > one found on the A31. It only has 1 channel, instead of 4 channels for
> > > time-multiplexed BT.656. Since the H3 is a reduced version, it cannot
> > > "fallback" to a compatible that implements more features than it
> > > supports.
> > >
> > > Split out the H3 compatible as a separate entry, with no fallback.
> > >
> > > Fixes: b7eadaa3a02a ("media: dt-bindings: media: sun6i: Add A31 and H3
> > >                       compatibles")
> > > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >
> > "media" text appear two times on commit head.
> 
> Just following what previous commits did. :)

I understand Mauro has a  script prefixes everything going through the
media tree with "media: " unless it's already there. I'd drop the latter,
but perhaps elaborate a bit this is about CSI. Fine details... I think it's
fine as-is for now.

> 
> > Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
> 
> BTW, I know you've been trying to get CSI to work on the A64.
> I have it working for the Bananapi-M64. The CSI SCLK needs to
> be lowered to 300 MHz or the image gets corrupted.
> 
> ChenYu

-- 
Sakari Ailus
