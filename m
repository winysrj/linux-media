Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59949 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2GRLk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 07:40:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: workshop-2011@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media summit at the Kernel Summit - was: Fwd: Re: [Ksummit-2012-discuss] Organising Mini Summits within the Kernel Summit
Date: Wed, 18 Jul 2012 13:41:03 +0200
Message-ID: <2985984.7Bq2WeAKvo@avalon>
In-Reply-To: <Pine.LNX.4.64.1207181022060.8472@axis700.grange>
References: <20120713173708.GB17109@thunk.org> <1593236.AuB9FuYCQv@avalon> <Pine.LNX.4.64.1207181022060.8472@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 18 July 2012 10:30:28 Guennadi Liakhovetski wrote:
> On Wed, 18 Jul 2012, Laurent Pinchart wrote:
> > On Tuesday 17 July 2012 21:51:02 Guennadi Liakhovetski wrote:
> > > On Tue, 17 Jul 2012, Mauro Carvalho Chehab wrote:
> > > > As we did in 2012, we're planning to do a media summit again at
> > > > KS/2012.
> > > > 
> > > > The KS/2012 will happen in San Diego, CA, US, between Aug 26-28, just
> > > > before the LinuxCon North America.
> > > > 
> > > > In order to do it, I'd like to know who is interested on participate,
> > > > and to get proposals about what subjects will be discussed there,
> > > > in order to start planning the agenda.
> > > 
> > > I'd love to attend, especially since, as you have seen, I've started
> > > doing
> > > some work on V4L DT bindings,
> > 
> > As you already know, that's a topic I'm very interested in. DT bindings
> > will likely involve rethinking how the V4L2 core and V4L2 drivers
> > instantiate subdevices, a media summit would have been a good occasion to
> > discuss that. However, we probably need an RFC to start with.
> 
> You've certainly seen these two RFCs currently being discussed:
> 
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/50755

Sorry, I meant RFC patches. The devil (or part of it) will be in the details, 
solving race conditions and other similarly fun issues will require 
experimentation.

> http://thread.gmane.org/gmane.linux.kernel.samsung-soc/11143

I still need to review that one :-)

-- 
Regards,

Laurent Pinchart

