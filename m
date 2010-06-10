Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2249 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0FJGdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 02:33:19 -0400
Received: from tschai.localnet (cm-84.208.87.21.getinternet.no [84.208.87.21])
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id o5A6XHGT077175
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 10 Jun 2010 08:33:18 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Final agenda for the Helsinki mini-summit
Date: Thu, 10 Jun 2010 08:35:29 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006100835.29941.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the final version of the agenda for the Helsinki mini-summit on
June 14-16.

Please reply to this thread if you have comments or want to add topics. But
note that my internet access will be limited in the days leading up to the
summit: I'm moving and the new apartment doesn't have internet yet :-(

The overall layout of the summit is to use the first day to go through all
topics and either come to a conclusion quickly for the 'simple' topics, or
discuss enough so that everyone understands the problem for the more complex
issues.

The second day will be used for in-depth discussions on those complex topics
and on the third day we will go through all topics again and translate the
discussions into something concrete like a time-line, action items, etc.

We have a lot to discuss, so we almost certainly have to split the second day
into two tracks, each discussing different topics. If we do split up, then one
track will touch on the videobuf-related topics and the other on the remaining
topics.

The first day will also feature a few short presentations on various topics.
Presentations shouldn't be longer than, say, 10 minutes tops. Please keep them
as short and to the point as possible. These presentations are meant to get
everyone up to speed quickly. Most of us have an extensive background in video
hardware and the v4l subsystem, so you don't need to spend time explaining
things.

After each topic I've put the names of the main developers active in that area.
If you see your name, then make sure you know the status of that topic so you
can explain it to everyone else.

The topics below are in the order I want to go through them on the first and
last days. Of course, last minute changes are always possible...

1) Presentation on the Qualcomm video hw architecture. Most of us have no
   experience with Qualcomm hardware, so I've asked Jeff Zhong to give a short
   overview of their video hardware.

2) Presentation on the ST-Ericsson video hardware. Most of us have no
   experience with ST-Ericsson hardware, so I've asked Robert Fekete to give a
   short overview of their video hardware.

3) Removal of V4L1: status of driver conversion in the kernel, status of
   moving v4l1->v4l2 conversion into libv4l1. What needs to be done, when
   will it be done and who will do it. Driver conversion: Hans Verkuil,
   libv4l1 conversion: Hans de Goede.

4) Adopting old V4L1 programs and converting to V4L2. Hans de Goede.

5) Media Controller Roadmap. Laurent Pinchart has a presentation.

6) TO DO list regarding V4L2 core framework including the new control framework.
   Hans Verkuil. Will be a presentation.

7) soc-camera status. Particularly with regards to the remaining soc-camera
   dependencies in sensor drivers. Guennadi Liakhovetski.

8) Driver compliance. We need a framework for V4L2 driver compliance. Hans
   Verkuil.

9) Discuss list of 'reference' programs to test against. Mauro Carvalho Chehab.

10) Remote Controllers. Presentation by Mauro Carvalho Chehab.

11) V4L2 video output vs. framebuffer. Guennadi Liakhovetski.

12) A processing plugin API for libv4l. Hans de Goede.
    See: http://www.mail-archive.com/linux-media@vger.kernel.org/msg18993.html

13) Status of intel drivers. Xiaolin Zhang.

14) Status of the Texas Instruments drivers: omapX (Laurent Pinchart/Hiremath Vaibhav)
   and DMxxxx (Sergio Aguirre). Probably should be a short presentation.

15) Multi-planar support. Pawel Osciak.

16) videobuf/videobuf2: what are the shortcomings, what are the requirements for
   a 'proper' videobuf implementation, can the existing videobuf be fixed or do
   we need a videobuf2. If the latter, what would be needed to convert existing
   drivers over to a videobuf2. Related topics (custom/pluggable allocators,
   out-of-order buffer dequeuing and per-buffer wait queues) will also be part
   of this topic.
   Laurent Pinchart and Pawel Osciak with presentations.

It is my intention for the first day to spend no more than 5 hours on the first
15 topics and the remaining time on the last most complex topic. If we cannot
finish a topic on the first day then it is postponed until the Tuesday or
Wednesday. My hope is that for each topic we end up with an action list of
things to do. In some cases this may involve future brainstorming sessions:
I've found such sessions very useful in the past and I would like to see more
of them.

During the memory handling brainstorming session earlier this year we also
touched on creating some sort of a generic buffer model allowing for easy
exchange between v4l buffers, framebuffers, texture buffers, etc. It is my
opinion that we should not discuss this in Helsinki. The list of topics is
already quite long and I think it is too early to start working on that. We
probably need another brainstorming session first in order to come up with
a reasonable proposal.

It promises to be a very interesting summit. We are also completely 'sold-out'
with 23 participants so it is gratifying to see so much interest in video4linux.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
