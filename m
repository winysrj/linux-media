Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4385 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0E3H6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 03:58:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: Tentative agenda for Helsinki mini-summit
Date: Sun, 30 May 2010 09:59:59 +0200
Cc: linux-media@vger.kernel.org, "'Zhong, Jeff'" <hzhong@quicinc.com>,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"'Zhang, Xiaolin'" <xiaolin.zhang@intel.com>,
	"'Sergio Rodriguez'" <saaguirre@ti.com>,
	"'Vaibhav Hiremath'" <hvaibhav@ti.com>,
	"'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
	"'Hans de Goede'" <hdegoede@redhat.com>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"'Kamil Debski'" <k.debski@samsung.com>
References: <201005231236.49048.hverkuil@xs4all.nl> <002201cafcea$93b06c00$bb114400$%osciak@samsung.com>
In-Reply-To: <002201cafcea$93b06c00$bb114400$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005300959.59316.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 26 May 2010 17:46:16 Pawel Osciak wrote:
> Hi Hans,
> 
> thank you for your work on this!
> 
> >Hans Verkuil wrote:
> 
> >3) videobuf/videobuf2: what are the shortcomings, what are the requirements
> >for a 'proper' videobuf implementation, can the existing videobuf be fixed or
> >do we need a videobuf2. If the latter, what would be needed to convert
> >existing drivers over to a videobuf2. Laurent Pinchart and Pawel Osciak. This I'm
> >sure requires a presentation.
> 
> As Laurent volunteered to prepare the "videobuf problems" presentation, I will
> hopefully make it before the summit with an initial (general) design for the new
> videobuf2 - requirements, API, things like that. So I'm thinking about a short
> presentation on this. What do you think?

That's OK.

> >4) Multi-planar support. Pawel Osciak.
> 
> Yes. Will provide a short status update. Is a presentation of the whole concept
> required? If so, I can conduct one as well.

I don't think a presentation is required.

> >9) Driver compliance. We need a framework for V4L2 driver compliance. Hans
> >   Verkuil.
> 
> I am very interested in this!
> 
> >10) Discuss list of 'reference' programs to test against. Mauro?
> >
> 
> Ditto.
> 
> >During the memory handling brainstorming session earlier this year we also
> >touched on creating some sort of a generic buffer model allowing for easy
> >exchange between v4l buffers, framebuffers, texture buffers, etc. It is my
> >opinion that we should not discuss this in Helsinki. The list of topics is
> >already quite long and I think it is too early to start working on that. We
> >probably need another brainstorming session first in order to come up with
> >a reasonable proposal.
> 
> I agree.
> 
> >Comments? Topics I missed?
> 
> It would be great to touch on the following subjects if we find some time
> (and if people would be interested, I had little feedback on the list):
> 
> 1) Custom/pluggable allocators
> As most of us are aware there are important problems with memory allocation
> in videobuf that most of us have already faced.
> For those unfamiliar with the topic, please see my recent RFC:
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/19581
> 
> I'd like to provide a design of an API:
> * for videobuf that would allow drivers to plug-in their own memory allocation
>   routines,
> * future-proof enough to be usable with videobuf2 as well.
> 
> Hoping for a (short-ish) discussion on that.
> 
> 2) Out-of-order buffer dequeuing and per-buffer wait queues in videobuf. See:
> RFC: http://www.mail-archive.com/linux-media@vger.kernel.org/msg17319.html
> Patches: http://www.mail-archive.com/linux-media@vger.kernel.org/msg17886.html

These topics should all be folded into the videobuf topic. Due to the importance
of videobuf I expect that a considerable amount of time will be spend on this.

On the first day I will probably put this topic last on the list and try to get
through the other topics fairly quickly so that we hopefully have 2-3 hours for
this topic.

What makes this a difficult topic is that you have this list of relatively
small sub-topics (like allocators, out-of-order dequeuing, videobuf improvements,
caching, etc. etc.), but it is not always easy to see the big picture: i.e.
what is the goal that you are working towards and what is the purpose for these
smaller sub-topics in the bigger picture.

I know that was difficult for me in the beginning, so I think it will probably
help people if you also provide the big picture and the context within which to
place these sub-topics. The 'big picture' also includes the memory pool idea.
Not that we will discuss this in Helsinki, but people should be aware that it
will be part of a next phase.

BTW, the videobuf presentation(s) can be longer than 10 minutes if needed.
This is the 'big topic' of the summit, so we will have more time for this.

Regards,

	Hans

> 
> 
> Please let me know what you think. Thanks!
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center
> 
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
