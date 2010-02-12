Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4635 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0BLOsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 09:48:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Proposal for a V4L2 Media Controller mini-summit
Date: Fri, 12 Feb 2010 15:50:08 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	"Gole, Anant" <anantgole@ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Sergio Rodriguez <saaguirre@ti.com>, molnar@ti.com,
	Magnus Damm <magnus.damm@gmail.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Jin-Sung Yang" <jsgood.yang@samsung.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	Kyungmin Park <kmpark@infradead.org>, mcharleb@qualcomm.com,
	hrao@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002121550.08706.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

During the Linux Plumbers Conference in September 2009 I organized a V4L-DVB
mini-summit. The focus of that summit was on discussing a framework through
which we could support all the functionality that the video hardware of modern
embedded devices provides.

It was a very successful summit and a lot of work has been done since that
time. See this posting for to get an idea of what was discussed for those
who were not present:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg10136.html

Since that time we have added a new API to support HDTV formats, a new
event API is almost ready, a lot of work is being done on the media
controller API with omap3 as guinea pig and Samsung has done work on the
memory handling of V4L2.

>From April 12th to 14th the CELF Embedded Linux Conference is held in
San Francisco, and it is co-located with the Linux Foundation Collaboration
Summit (April 14th-16th). Links to these conferences are here:

http://www.embeddedlinuxconference.com/elc_2010/index.html
http://events.linuxfoundation.org/events/collaboration-summit

I will be doing a presentation on the new framework during the ELC.

Since this conference is about 6 months after the mini-summit I consider this
a good time to organize a new V4L2 Media Controller mini-summit to discuss
progress and future work in this area. I think that particular attention
should be given to how we are going to do memory handling. The proposals
from Samsung have received very little attention and we should discuss those
in more detail.

I do not know on which dates exactly such a summit can take place. There
are three possibilities:

April 10-11/12
April 12-14 
April 14/15-16

I think that registering for the ELC gives to free access to the Collaboration
Summit, but I'm waiting for a confirmation on that.

I'm not keen on the center option (12-14 April) since that often means that
you don't see a lot of the conference itself. And the ELC is generally quite
interesting.

There is another alternative and that is that I organize a mini-summit in May
in Lysaker (near Oslo, Norway) at the Tandberg offices. But frankly I think
that it is more fun to do this during/before/after a conference. If only
because there are a lot of linux kernel experts on hand during such a
conference that you can ask for help if needed.

Please let me know asap if you are interested in attending such a mini-summit
and what dates are possible for you:

a: April 10-11 (or 12)
b: April 12-14 
c: April 14 (or 15)-16
d: Somewhere in May (suggestions for dates are welcome)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
