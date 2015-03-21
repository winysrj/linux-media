Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50695 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbCUV34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 17:29:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: media-workshop@linuxtv.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] [ANN] Media Mini-Summit Draft Agenda for March 26th
Date: Sat, 21 Mar 2015 23:30:10 +0200
Message-ID: <47567947.bBC8Lg1D1r@avalon>
In-Reply-To: <CAL8zT=gg+b1DGyKjm9wL9zV_aCP9YMCkpS-KLqVORP_Qb6oV=A@mail.gmail.com>
References: <5506BDA8.3000700@xs4all.nl> <1539819.WFF67ZXgOp@avalon> <CAL8zT=gg+b1DGyKjm9wL9zV_aCP9YMCkpS-KLqVORP_Qb6oV=A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

On Saturday 21 March 2015 19:37:51 Jean-Michel Hautbois wrote:
> 2015-03-21 13:36 GMT+01:00 Laurent Pinchart:
> > On Monday 16 March 2015 12:25:28 Hans Verkuil wrote:
> > > This is the draft agenda for the media mini-summit in San Jose on March
> > > 26th.
> > > 
> > > Time: 9 AM to 5 PM (approximately)
> > > Room: TBC (Mauro, do you know this?)
> > > 
> > > Attendees:
> > > 
> > > Mauro Carvalho Chehab - mchehab@osg.samsung.com               - Samsung
> > > Laurent Pinchart      - laurent.pinchart@ideasonboard.com     - Ideas on
> > > board Hans Verkuil          - hverkuil@xs4all.nl                    -
> > > Cisco
> > > 
> > > Mauro, do you have a better overview of who else will attend?
> > > 
> > > Agenda:
> > > 
> > > Times are approximate and will likely change.
> > > 
> > > 9:00-9:15   Get everyone installed, laptops hooked up, etc.
> > > 9:15-9:30   Introduction
> > > 
> > > 9:30-10:30  Media Controller support for DVB (Mauro):
> > >               1) dynamic creation/removal of pipelines
> > >               2) change media_entity_pipeline_start to also define
> > >               
> > >                  the final entity
> > >               
> > >               3) how to setup pipelines that also envolve audio and DRM
> > >               4) how to lock the media controller pipeline between
> > >               enabling a
> > >               
> > >                  pipeline and starting it, in order to avoid race
> > >                  conditions
> > > 
> > > See this post for more detailed information:
> > > 
> > > https://www.mail-archive.com/linux-media@vger.kernel.org/msg85910.html
> > > 
> > > 10:30-10:45 Break
> > > 10:45-12:00 Continue discussion
> > > 12:00-13:00 Lunch (Mauro, do you have any idea whether there is a lunch
> > > organized, or if we are on our own?)
> > > 13:00-14:40 Continue discussion
> > > 14:40-15:00 Break
> > > 15:00-16:00 Subdev hotplug in the context of both FPGA dynamic
> > > reconfiguration and project Ara (http://www.projectara.com/) (Laurent).
> > 
> > To be precise, this will be both hot plug and hot unplug.
> > 
> > > 16:00-17:00 Update on ongoing projects (Hans):
> > >               - proposal for Android Camera v3-type requests (aka
> > >               configuration
> > >               stores)
> > 
> > I'm interested in this as well.
> > 
> > >               - work on colorspace improvements
> > >               - vivid & v4l2-compliance improvements
> > >               - removing duplicate subdev video ops and use pad ops
> > >               instead
> > >               - others?
> > 
> > There's also the topic of the media device controller registry that we
> > discussed during the FOSDEM, but as far as I know there has been no
> > progress in that area.
> 
> Unfortunately I can't be there, but am interested by a report on this
> particular question :).

Feel free to report your progress ;-)

-- 
Regards,

Laurent Pinchart

