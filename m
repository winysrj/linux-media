Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53918 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0FGIox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 04:44:53 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Mon, 7 Jun 2010 14:14:45 +0530
Subject: RE: Version 2: Tentative agenda for Helsinki mini-summit
Message-ID: <19F8576C6E063C45BE387C64729E7394044E7A16AC@dbde02.ent.ti.com>
References: <201005301015.59776.hverkuil@xs4all.nl>
In-Reply-To: <201005301015.59776.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hans Verkuil
> Sent: Sunday, May 30, 2010 1:46 PM
> To: linux-media@vger.kernel.org
> Subject: Version 2: Tentative agenda for Helsinki mini-summit
> 
> Hi all,
> 
> This is the second version of a tentative agenda for the Helsinki mini-
> summit
> on June 14-16.
> 
> Please reply to this thread if you have comments or want to add topics.
> 
> If you want to attend the summit then contact Sakari Ailus
> (sakari.ailus@maxwell.research.nokia.com). We are very full already (over 20
> attendees), so I'm not sure if there is still room left.
> 
> The overall layout of the summit is to use the first day to go through all
> topics and either come to a conclusion quickly for the 'simple' topics, or
> discuss enough so that everyone understands the problem for the more complex
> issues.
> 
> The second day will be used for in-depth discussions on those complex topics
> and on the third day we will go through all topics again and translate the
> discussions into something concrete like a time-line, action items, etc.
> 
> We have a lot to discuss, so we almost certainly have to split the second
> day
> into two tracks, each discussing different topics. If we do split up, then
> one
> track will touch on the videobuf-related topics and the other on the
> remaining
> topics.
> 
> The first day will also feature a few short presentations on various topics.
> Presentations shouldn't be longer than, say, 10 minutes tops. Please keep
> them
> as short and to the point as possible. These presentations are meant to get
> everyone up to speed quickly. Most of us have an extensive background in
> video
> hardware and the v4l subsystem, so you don't need to spend time explaining
> things.
> 
> After each topic I've put the names of the main developers active in that
> area.
> If you see your name, then make sure you know the status of that topic so
> you
> can explain it to everyone else. If I think it warrants a presentation, then
> I
> will mention that. Of course, if you disagree, or want/don't want to do a
> presentation then just say so. It's a tentative agenda only.
> 
> The topics below are in no particular order except for the first one. I am
> very pleased that Qualcomm has joined this project so I think it would be
> nice to start the meeting off with a presentation on their HW architecture.
> 
> 1) Presentation on the Qualcomm video hw architecture. Most of us have no
>    experience with Qualcomm hardware, so I've asked Jeff Zhong to give a
> short
>    overview of their video hardware.
> 
> 2) Removal of V4L1: status of driver conversion in the kernel, status of
>    moving v4l1->v4l2 conversion into libv4l1. What needs to be done, when
>    will it be done and who will do it. Driver conversion: Hans Verkuil,
>    libv4l1 conversion: Hans de Goede.
> 
> 3) videobuf/videobuf2: what are the shortcomings, what are the requirements
> for
>    a 'proper' videobuf implementation, can the existing videobuf be fixed or
> do
>    we need a videobuf2. If the latter, what would be needed to convert
> existing
>    drivers over to a videobuf2. Related topics (custom/pluggable allocators,
>    out-of-order buffer dequeuing and per-buffer wait queues) will also be
> part
>    of this topic.
>    Laurent Pinchart and Pawel Osciak with presentations.
> 
> 4) Multi-planar support. Pawel Osciak.
> 
> 5) Media Controller Roadmap. Laurent Pinchart has a presentation.
> 
> 6) TO DO list regarding V4L2 core framework including the new control
> framework.
>    Hans Verkuil. Will be a presentation.
> 
> 7) Status of the Texas Instruments drivers: omapX (Laurent Pinchart/Hiremath
> Vaibhav)
>    and DMxxxx (Sergio Aguirre). Probably should be a short presentation.
> 
> 8) soc-camera status. Particularly with regards to the remaining soc-camera
>    dependencies in sensor drivers. Guennadi Liakhovetski.
> 
> 9) Driver compliance. We need a framework for V4L2 driver compliance. Hans
>    Verkuil.
> 
> 10) Discuss list of 'reference' programs to test against. Mauro Carvalho
> Chehab.
> 
> 11) Adopting old V4L1 programs and converting to V4L2. Hans de Goede?
> 
> 12) Status of intel drivers. Xiaolin Zhang.
> 
> 13) Remote Controllers. Presentation by Mauro Carvalho Chehab.
> 
> 14) V4L2 video output vs. framebuffer. Guennadi Liakhovetski.
> 
[Hiremath, Vaibhav] Guennadi,

Do you have anything in your mind on this? Are you preparing any slides for this? Do you want me to have something from OMAP side which we can use as a use-case?

I can make couple of slides on this.

Thanks,
Vaibhav

> 15) A processing plugin API for libv4l. Hans de Goede.
>     See: http://www.mail-archive.com/linux-
> media@vger.kernel.org/msg18993.html
> 
> It is my understanding that we will also have X11 and gstreamer experts on
> hand.
> Topics relating to that are welcome.
> 
> During the memory handling brainstorming session earlier this year we also
> touched on creating some sort of a generic buffer model allowing for easy
> exchange between v4l buffers, framebuffers, texture buffers, etc. It is my
> opinion that we should not discuss this in Helsinki. The list of topics is
> already quite long and I think it is too early to start working on that. We
> probably need another brainstorming session first in order to come up with
> a reasonable proposal.
> 
> Comments? Topics I missed?
> 
> Regards,
> 
>         Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
