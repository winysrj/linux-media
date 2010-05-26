Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58355 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0EZPrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 11:47:01 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L31008T8AIA8T@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 May 2010 16:46:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L3100FJ1AI9S9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 May 2010 16:46:58 +0100 (BST)
Date: Wed, 26 May 2010 17:46:16 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Tentative agenda for Helsinki mini-summit
In-reply-to: <201005231236.49048.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: "'Zhong, Jeff'" <hzhong@quicinc.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	"'Zhang, Xiaolin'" <xiaolin.zhang@intel.com>,
	'Sergio Rodriguez' <saaguirre@ti.com>,
	'Vaibhav Hiremath' <hvaibhav@ti.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Hans de Goede' <hdegoede@redhat.com>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Kamil Debski' <k.debski@samsung.com>
Message-id: <002201cafcea$93b06c00$bb114400$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <201005231236.49048.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thank you for your work on this!

>Hans Verkuil wrote:

>3) videobuf/videobuf2: what are the shortcomings, what are the requirements
>for a 'proper' videobuf implementation, can the existing videobuf be fixed or
>do we need a videobuf2. If the latter, what would be needed to convert
>existing drivers over to a videobuf2. Laurent Pinchart and Pawel Osciak. This I'm
>sure requires a presentation.

As Laurent volunteered to prepare the "videobuf problems" presentation, I will
hopefully make it before the summit with an initial (general) design for the new
videobuf2 - requirements, API, things like that. So I'm thinking about a short
presentation on this. What do you think?

>4) Multi-planar support. Pawel Osciak.

Yes. Will provide a short status update. Is a presentation of the whole concept
required? If so, I can conduct one as well.

>9) Driver compliance. We need a framework for V4L2 driver compliance. Hans
>   Verkuil.

I am very interested in this!

>10) Discuss list of 'reference' programs to test against. Mauro?
>

Ditto.

>During the memory handling brainstorming session earlier this year we also
>touched on creating some sort of a generic buffer model allowing for easy
>exchange between v4l buffers, framebuffers, texture buffers, etc. It is my
>opinion that we should not discuss this in Helsinki. The list of topics is
>already quite long and I think it is too early to start working on that. We
>probably need another brainstorming session first in order to come up with
>a reasonable proposal.

I agree.

>Comments? Topics I missed?

It would be great to touch on the following subjects if we find some time
(and if people would be interested, I had little feedback on the list):

1) Custom/pluggable allocators
As most of us are aware there are important problems with memory allocation
in videobuf that most of us have already faced.
For those unfamiliar with the topic, please see my recent RFC:
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/19581

I'd like to provide a design of an API:
* for videobuf that would allow drivers to plug-in their own memory allocation
  routines,
* future-proof enough to be usable with videobuf2 as well.

Hoping for a (short-ish) discussion on that.

2) Out-of-order buffer dequeuing and per-buffer wait queues in videobuf. See:
RFC: http://www.mail-archive.com/linux-media@vger.kernel.org/msg17319.html
Patches: http://www.mail-archive.com/linux-media@vger.kernel.org/msg17886.html


Please let me know what you think. Thanks!

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



