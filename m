Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1HAKzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 06:55:32 -0400
Date: Mon, 1 Aug 2011 12:55:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Pawel Osciak <pawel@osciak.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <201107301550.53638.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1108011225230.30975@axis700.grange>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
 <201107280856.55731.hverkuil@xs4all.nl> <CAMm-=zCU1B1zXNK7hp_B8hAW0YfcrN9V8M_uSDva8TbXL2AKbQ@mail.gmail.com>
 <201107301550.53638.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 30 Jul 2011, Hans Verkuil wrote:

[snip]

> No. We do not have a mechanism (yet) to tie a pipeline configuration to
> a queued buffer (to be discussed in next week in Cambourne).
> 
> It is my understanding that you change the current streaming format, and
> then queue the large (prepared) buffer and switch back afterwards.

As far as I understand, currently we have 2 unclarified points with this 
patch:

1. size of the reserved field. Sakari proposed 19 32-bit words for 
possible per-plane extensions with a max of 8 planes. That would make up 
to 2 32-bit words per plane plus 3 words for the common part. So, although 
reserving 76 bytes "just in case" seems like a huge overkill to me, I 
kinda can see the reasoning... We could also do with 10 reserved words - 1 
word per plane + 2 common. What do others think?

2. as in the above quote - we do not know yet, how to tell the user, when 
the format changes.

AFAIU, the problem is the following:

(a) we prepare buffers of two sizes, say - small for preview and large for 
snapshot
(b) S_FMT(preview)
(c) QBUF(preview)...
(d) STREAMON
(e) capture for some time...
(f) S_FMT(snapshot)
(g) now, we do not yet necessarily want to queue our big buffers, because 
the hardware will not switch immediately
(h) when the hardware has switch we QBUF(snapshor)
...

Currently, there's no way to find out when the hardware switched to the 
new frame format. Maybe an event is needed?

Besides, the TRY_FMT idea is nice, but it doesn't give us an ultimate 
solution either. What if a TRY_FMT now returns different plane sizes, than 
when we actually perform S_FMT? E.g., if the user also issues an S_CROP 
between those and that also changes the output format because of driver 
limitations?

So, my question is: shall I prepare a new version of this RFC now, also 
providing examples for vb2 and a hardware driver, or we're waiting for the 
brainstorming and following ML discussion results on the above?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
