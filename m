Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:63102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1BVRIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 12:08:41 -0500
Date: Tue, 22 Feb 2011 18:08:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	saaguirre@ti.com
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <201102221800.49914.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1102221806280.1380@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com> <4D63D78E.3070000@mm-sol.com>
 <Pine.LNX.4.64.1102221719220.1380@axis700.grange> <201102221800.49914.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 22 Feb 2011, Hans Verkuil wrote:

> On Tuesday, February 22, 2011 17:27:47 Guennadi Liakhovetski wrote:
> > On Tue, 22 Feb 2011, Stan wrote:
> > 
> > > In principle I agree with this bus negotiation.
> > > 
> > >  - So. let's start thinking how this could be fit to the subdev sensor
> > > operations.
> > 
> > Well, I'm afraid not everyone is convinced yet, so, it is a bit early to 
> > start designing interfaces;)
> > 
> > >  - howto isolate your current work into some common place and reuse it,
> > > even on platform part.
> > >  - and is it possible.
> > > 
> > > The discussion becomes very emotional and this is not a good adviser :)
> > 
> > No, no emotions at least on this side:) But it's also not technical, 
> > unfortunately. I'm prepared to discuss technical benefits or drawbacks of 
> > each of these approaches, but these arguments - can we trust programmers 
> > or can we not? or will anyone at some time in the future break it or not? 
> > Sorry, I am not a psychologist:) Personally, I would _exclusively_ 
> > consider technical arguments. Of course, things like "clean and simple 
> > APIs," "proper separation / layering" etc. are also important, but even 
> > they already can become difficult to discuss and are already on the border 
> > between technical issues and personal preferences... So, don't know, in 
> > the end, I think, it will just come down to who is making decisions and 
> > who is implementing them:) I just expressed my opinion, we don't have to 
> > agree, eventually, the maintainer will decide whether to apply patches or 
> > not:)
> 
> In my view at least it *is* a technical argument. It makes perfect sense to
> me from a technical point of view to put static, board-specific configuration
> in platform_data. I don't think there would have been much, if any, discussion
> about this if it wasn't for the fact that soc-camera doesn't do this but instead
> negotiates it. Obviously, it isn't a pleasant prospect having to change all that.
> 
> Normally this would be enough of an argument for me to just negotiate it. The
> reason that I don't want this in this particular case is that I know from
> personal experience that incorrect settings can be extremely hard to find.
> 
> I also think that there is a reasonable chance that such bugs can happen. Take
> a scenario like this: someone writes a new host driver. Initially there is only
> support for positive polarity and detection on the rising edge, because that's
> what the current board on which the driver was developed supports. This is quite
> typical for an initial version of a driver.
> 
> Later someone adds support for negative polarity and falling edge. Suddenly the
> polarity negotiation on the previous board results in negative instead of positive
> which was never tested. Now that board starts producing pixel errors every so
> often. And yes, this type of hardware problems do happen as I know from painful
> experience.
> 
> Problems like this are next to impossible to debug without the aid of an
> oscilloscope, so this isn't like most other bugs that are relatively easy to
> debug.

Well, this is pretty simple to debug with the help of git bisect, as long 
as patches are sufficiently clean and properly broken down into single 
topics.

> It is so much easier just to avoid this by putting it in platform data. It's
> simple, unambiguous and above all, unchanging.

As I said, this all boils down to who does patches and who accepts them 
for mainlibe.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
