Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34109 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZIGEq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 00:46:29 -0400
Received: by bwz19 with SMTP id 19so1345131bwz.37
        for <linux-media@vger.kernel.org>; Sun, 06 Sep 2009 21:46:31 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
Date: Mon, 7 Sep 2009 06:46:04 +0200
Cc: Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	"Russell King - ARM Linux" <linux@arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Rapoport <mike@compulab.co.il>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	linux-arm-kernel@lists.infradead.org
References: <200908031031.00676.marek.vasut@gmail.com> <200909061951.44629.marek.vasut@gmail.com> <Pine.LNX.4.64.0909062004160.10484@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909062004160.10484@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909070646.04642.marek.vasut@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne Ne 6. září 2009 20:15:17 Guennadi Liakhovetski napsal(a):
> On Sun, 6 Sep 2009, Marek Vasut wrote:
> > Dne Ne 6. září 2009 18:52:55 Guennadi Liakhovetski napsal(a):
> > > On Sun, 6 Sep 2009, Marek Vasut wrote:
> > > > Ah damn, I see what you mean. What the camera does is it swaps the
> > > > RED and BLUE channel:
> > > > 15  14  13  12  11  10  09  08  07  06  05  04  03  02  01  00
> > > > B4  B3  B2  B1  B0  G4  G3  G2  G1  G1  R4  R3  R2  R1  R1  --
> > > > so it's more a BGR555/565 then. I had to patch fswebcam for this.
> > >
> > > Ok, this is, of course, something different. In this case you,
> > > probably, could deceive the PXA to handle blue as red and the other way
> > > round, but still, I would prefer not to do that. Hence my suggestion
> > > remains - pass these formats as raw data.
> >
> > Which is bogus from the camera point of view.
>
> Not at all. This just means: the subdevice provides a pixel format, that
> the bridge (PXA) knows nothing specific about, but it can just pass it
> one-to-one (as raw data) to the user - don't see anything bogus in this.
> Different bridges have support for different pixel colour formats, but, I
> think, all bridges can pass data as raw (pass-through). Some bridges can
> _only_ do this, so, this is actually the default video-capture mode.

But then you'll have to tell your software how to process the raw data (in what 
format they are). If there was this RGB565X passthrough support, the software 
could at least check if you are not forcing it to process nonsense.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
