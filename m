Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:52692 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZINWGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 18:06:23 -0400
Received: by fg-out-1718.google.com with SMTP id 22so687830fge.1
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 15:06:26 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV9640 sensor
Date: Tue, 15 Sep 2009 00:06:00 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200908220850.07435.marek.vasut@gmail.com> <200909142315.14697.marek.vasut@gmail.com> <Pine.LNX.4.64.0909142319240.4359@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909142319240.4359@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909150006.00150.marek.vasut@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne Po 14. září 2009 23:21:33 Guennadi Liakhovetski napsal(a):
> On Mon, 14 Sep 2009, Marek Vasut wrote:
> > Dne Po 14. září 2009 22:30:41 Guennadi Liakhovetski napsal(a):
> > > On Mon, 14 Sep 2009, Marek Vasut wrote:
> > > > Dne Po 14. září 2009 21:29:26 Guennadi Liakhovetski napsal(a):
> > > > > From: Marek Vasut <marek.vasut@gmail.com>
> > > > >
> > > > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > > ---
> > > > >
> > > > > Marek, please confirm, that this version is ok. I'll push it
> > > > > upstream for 2.6.32 then.
> > > >
> > > > No, it's not OK. You removed the RGB part. Either enclose those parts
> > > > into ifdef OV9640_RGB_BUGGY or preserve it in some other way. Someone
> > > > will certainly want to re-add RGB parts later and will have to figure
> > > > it out all over again.
> > >
> > > Ok, make a proposal, how you would like to see it. But - I do not want
> > > commented out code, including "#ifdef MACRO_THAT_DOESNT_GET_DEFINED." I
> > > think, I described it in sufficient detail, so that re-adding that code
> > > should not take longer than 10 minutes for anyone sufficiently familiar
> > > with the code. Referencing another driver also has an advantage, that
> > > if we switch to imagebus or any other API, you don't get stale
> > > commented out code, but you look up updated code in a functional
> > > driver. But I am open to your ideas / but no commented out code,
> > > please.
> >
> > The RGB is broken only in a way where it swaps colours, the color matrix
> > coeficients and register configurations are OK (which is what other
> > people who will want to add it will need to figure out again from scratch
> > if you remove the code).
> 
> Excuse me, have you looked at my patch? Have you compared it to yours? I
> only removed your RGB code entries from the list of supported formats, I
> haven't removed any implementation details, thus effectively just
> disabling it.

Just briefly skimmed over it. Ok then, that diff seems fine. I assume the imagebus 
will fix the rgb issues anyway.
> 
> > I dont want this merged before this is solved in some way where those
> > values are preserved.
> 
> Sure, let's have it fixed and submit it in time for 2.6.33.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
