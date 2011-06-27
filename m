Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1782 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1F0PCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 11:02:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ANNOUNCE] Media subsystem workshop 2011 - Prague - Oct 24-26
Date: Mon, 27 Jun 2011 17:02:41 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <4E02357E.4060400@redhat.com> <201106270754.24770.hverkuil@xs4all.nl> <4E088C41.2070307@redhat.com>
In-Reply-To: <4E088C41.2070307@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271702.41411.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, June 27, 2011 15:57:21 Mauro Carvalho Chehab wrote:
> Em 27-06-2011 02:54, Hans Verkuil escreveu:
> > On Wednesday, June 22, 2011 20:33:34 Mauro Carvalho Chehab wrote:
> >> Media subsystem workshop 2011 - Prague - Oct 24-26
> >>
> >> Since 2007, we're doing annual mini-summits for the media subsystem,
> >> in order to plan the new features that will be introduced there.
> >>
> >> Last year, during the Kernel Summit 2010, it was decided that the Kernel 
> >> Summit 2011 format will be modified, in order to strength the interaction 
> >> between the several sub-system mini-summits and the main Kernel Summit. 
> >> If this idea works well, the next Kernel Summits will also follow the
> >> same format.
> >>
> >> So, some mini-summits were proposed to happen together with the Kernel
> >> Summit 2011. Among a few others, the Media subsystem was accepted to be
> >> held with this year's Kernel Summit.
> >>
> >> So, we'd like to announce that the Media subsystem workshop 2011 will
> >> happen together with the Kernel Summit 2011.
> > 
> > Great!
> > 
> >> The Media subsystem workshop is on early planning stages, but the idea
> >> is that we'll have an entire day to do the media discussions. We'll 
> >> also planning to have workshop presentations inside the Kernel Summit
> >> 2011 with the workshop and Kernel Summit attendants present, where 
> >> workshop results will be presented.
> >>
> >> So, I'd like to invite V4L, DVB and RC developers to submit proposals
> >> for the themes to be discussed. Please email me if you're interested
> >> on being invited for the event.
> 
> (as you've replied in priv, I'm not c/c the ML, but, IMO, the better would
> be if you could write it to the ML as well).

Added the ML.

> > 
> > It's terribly early for proposals (it's a fast moving subsystem), but I think
> > one theme for the workshop is to take a good look at our V4L2 Spec and decide
> > on and fix any ambiguities that remain.
> 
> Agreed. I'd say more: we should look not only at the V4L part of the spec, but also
> at the DVB part. I hope that we can get interests from some DVB developers to be
> there also.

Indeed.

> > I hope to continue my work on
> > v4l2-compliance and as part of that I keep a list of such problems.
> 
> Yes, a compliance tool is a good thing to do.

Too bad there isn't a single driver that complies :-)

> > Another, related, topic is to determine the overall state of the subsystem:
> > the good, the bad and the ugly :-) And to prioritize work accordingly.
> 
> Good point.
> 
> > One thing I hope to work on this year is to clean up drivers and use the
> > compliance tool to make them behave consistently. I'd be happy to present
> > results of testing for a wide range of hardware at the workshop.
> 
> Seems a good topic for me.

Regards,

	Hans
