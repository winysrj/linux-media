Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49495 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab0EXLl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 07:41:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Tentative agenda for Helsinki mini-summit
Date: Mon, 24 May 2010 13:41:54 +0200
Cc: linux-media@vger.kernel.org, "Zhong, Jeff" <hzhong@quicinc.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	Sergio Rodriguez <saaguirre@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201005231236.49048.hverkuil@xs4all.nl>
In-Reply-To: <201005231236.49048.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005241341.55611.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 23 May 2010 12:36:48 Hans Verkuil wrote:
> Hi all,
> 
> This is a tentative agenda for the Helsinki mini-summit on June 14-16.
> 
> Please reply to this thread if you have comments or want to add topics.
> 
> The overall layout of the summit is to use the first day to go through all
> topics and either come to a conclusion quickly for the 'simple' topics, or
> discuss enough so that everyone understands the problem for the more
> complex issues.
> 
> The second day will be used for in-depth discussions on those complex
> topics and on the third day we will go through all topics again and
> translate the discussions into something concrete like a time-line, action
> items, etc.
> 
> We have a lot to discuss, so we may have to split the second day into two
> 'tracks', each discussing different topics. I hope it is not needed, but I
> fear we may have no choice. If we do split up, then one track will touch on
> the videobuf-related topics and the other on the remaining topics.
> 
> The first day will also feature a few short presentations on various
> topics. Presentations shouldn't be longer than, say, 10 minutes. These
> presentations are meant to get everyone up to speed quickly.
> 
> After each topic I've put the names of the main developers active in that
> area. If you see your name, then make sure you know the status of that
> topic so you can explain it to everyone else. If I think it warrants a
> presentation, then I will mention that. Of course, if you disagree, or
> want/don't want to do a presentation then just say so. It's a tentative
> agenda only.
> 
> The topics below are in no particular order except for the first one. I am
> very pleased that Qualcomm has joined this project so I think it would be
> nice to start the meeting off with a presentation on their HW architecture.
> 
> 1) Presentation on the Qualcomm video hw architecture. Most of us have no
>    experience with Qualcomm hardware, so I've asked Jeff Zhong to give a
> short overview of their video hardware.

Generic comment about platform overview presentations: please skip the small 
details (we don't need a list of registers :-)), but make sure the overall 
architecture is properly explained. A functional block diagram is very 
helpful, and platform-specific features or restrictions should be explained 
where useful (such as requirements on memory types, hardware ability to run 
several things in parallel, status of the current driver if any, ...).

> 2) Removal of V4L1: status of driver conversion in the kernel, status of
>    moving v4l1->v4l2 conversion into libv4l1. What needs to be done, when
>    will it be done and who will do it. Driver conversion: Hans Verkuil,
>    libv4l1 conversion: Hans de Goede.
> 
> 3) videobuf/videobuf2: what are the shortcomings, what are the requirements
> for a 'proper' videobuf implementation, can the existing videobuf be fixed
> or do we need a videobuf2. If the latter, what would be needed to convert
> existing drivers over to a videobuf2. Laurent Pinchart and Pawel Osciak.
> This I'm sure requires a presentation.

I will prepare a presentation on the current state of videobuf, highlighting 
the issues. I can also present the OMAP3 ISP video buffers handling code that 
I wrote to replace videobuf in that particular driver.

> 4) Multi-planar support. Pawel Osciak.
> 
> 5) Media Controller Roadmap. Laurent Pinchart. This probably warrants a
> short presentation.

There will be a presentation of the media controller concepts (to get 
everybody up to date) and on the current state of the implementation. I can 
also present our TODO list, but a proper roadmap is probably something we 
should discuss all together.

> 6) TO DO list regarding V4L2 core framework including the new control
> framework. Hans Verkuil. Will be a presentation.
> 
> 7) Status of the Texas Instruments drivers: omapX (Hiremath Vaibhav) and
> DMxxxx (Sergio Aguirre). Probably should be a short presentation.

For the OMAP3 platform I (or maybe Sakari :-)) can explain the status of the 
driver.

> 8) soc-camera status. Particularly with regards to the remaining soc-camera
>    dependencies in sensor drivers. Guennadi Liakhovetski.
> 
> 9) Driver compliance. We need a framework for V4L2 driver compliance. Hans
>    Verkuil.
> 
> 10) Discuss list of 'reference' programs to test against. Mauro?
> 
> 11) Adopting old V4L1 programs and converting to V4L2. Hans de Goede?
> 
> 12) Status of intel drivers. Xiaolin Zhang.
> 
> It is my understanding that we will also have X11 and gstreamer experts on
> hand. Topics relating to that are welcome.
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

-- 
Regards,

Laurent Pinchart
