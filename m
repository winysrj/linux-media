Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3577 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0EWKfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 06:35:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Tentative agenda for Helsinki mini-summit
Date: Sun, 23 May 2010 12:36:48 +0200
Cc: "Zhong, Jeff" <hzhong@quicinc.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	Sergio Rodriguez <saaguirre@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231236.49048.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is a tentative agenda for the Helsinki mini-summit on June 14-16.

Please reply to this thread if you have comments or want to add topics.

The overall layout of the summit is to use the first day to go through all
topics and either come to a conclusion quickly for the 'simple' topics, or
discuss enough so that everyone understands the problem for the more complex
issues.

The second day will be used for in-depth discussions on those complex topics
and on the third day we will go through all topics again and translate the
discussions into something concrete like a time-line, action items, etc.

We have a lot to discuss, so we may have to split the second day into two
'tracks', each discussing different topics. I hope it is not needed, but I
fear we may have no choice. If we do split up, then one track will touch on
the videobuf-related topics and the other on the remaining topics.

The first day will also feature a few short presentations on various topics.
Presentations shouldn't be longer than, say, 10 minutes. These presentations
are meant to get everyone up to speed quickly.

After each topic I've put the names of the main developers active in that area.
If you see your name, then make sure you know the status of that topic so you
can explain it to everyone else. If I think it warrants a presentation, then I
will mention that. Of course, if you disagree, or want/don't want to do a
presentation then just say so. It's a tentative agenda only.

The topics below are in no particular order except for the first one. I am
very pleased that Qualcomm has joined this project so I think it would be
nice to start the meeting off with a presentation on their HW architecture.

1) Presentation on the Qualcomm video hw architecture. Most of us have no
   experience with Qualcomm hardware, so I've asked Jeff Zhong to give a short
   overview of their video hardware.

2) Removal of V4L1: status of driver conversion in the kernel, status of
   moving v4l1->v4l2 conversion into libv4l1. What needs to be done, when
   will it be done and who will do it. Driver conversion: Hans Verkuil,
   libv4l1 conversion: Hans de Goede.

3) videobuf/videobuf2: what are the shortcomings, what are the requirements for
   a 'proper' videobuf implementation, can the existing videobuf be fixed or do
   we need a videobuf2. If the latter, what would be needed to convert existing
   drivers over to a videobuf2. Laurent Pinchart and Pawel Osciak. This I'm sure
   requires a presentation.

4) Multi-planar support. Pawel Osciak.

5) Media Controller Roadmap. Laurent Pinchart. This probably warrants a short
   presentation.

6) TO DO list regarding V4L2 core framework including the new control framework.
   Hans Verkuil. Will be a presentation.

7) Status of the Texas Instruments drivers: omapX (Hiremath Vaibhav) and DMxxxx
   (Sergio Aguirre). Probably should be a short presentation.

8) soc-camera status. Particularly with regards to the remaining soc-camera
   dependencies in sensor drivers. Guennadi Liakhovetski.

9) Driver compliance. We need a framework for V4L2 driver compliance. Hans
   Verkuil.

10) Discuss list of 'reference' programs to test against. Mauro?

11) Adopting old V4L1 programs and converting to V4L2. Hans de Goede?

12) Status of intel drivers. Xiaolin Zhang.

It is my understanding that we will also have X11 and gstreamer experts on hand.
Topics relating to that are welcome.

During the memory handling brainstorming session earlier this year we also
touched on creating some sort of a generic buffer model allowing for easy
exchange between v4l buffers, framebuffers, texture buffers, etc. It is my
opinion that we should not discuss this in Helsinki. The list of topics is
already quite long and I think it is too early to start working on that. We
probably need another brainstorming session first in order to come up with
a reasonable proposal.

Comments? Topics I missed?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
