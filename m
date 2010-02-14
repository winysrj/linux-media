Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52715 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0BNXhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 18:37:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Proposal for a V4L2 Media Controller mini-summit
Date: Mon, 15 Feb 2010 00:37:04 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
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
References: <201002121550.08706.hverkuil@xs4all.nl>
In-Reply-To: <201002121550.08706.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002150037.17533.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 12 February 2010 15:50:08 Hans Verkuil wrote:
> Hi all,
> 
> During the Linux Plumbers Conference in September 2009 I organized a
> V4L-DVB mini-summit. The focus of that summit was on discussing a
> framework through which we could support all the functionality that the
> video hardware of modern embedded devices provides.
> 
> It was a very successful summit and a lot of work has been done since that
> time. See this posting for to get an idea of what was discussed for those
> who were not present:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg10136.html
> 
> Since that time we have added a new API to support HDTV formats, a new
> event API is almost ready, a lot of work is being done on the media
> controller API with omap3 as guinea pig and Samsung has done work on the
> memory handling of V4L2.
> 
> From April 12th to 14th the CELF Embedded Linux Conference is held in
> San Francisco, and it is co-located with the Linux Foundation Collaboration
> Summit (April 14th-16th). Links to these conferences are here:
> 
> http://www.embeddedlinuxconference.com/elc_2010/index.html
> http://events.linuxfoundation.org/events/collaboration-summit
> 
> I will be doing a presentation on the new framework during the ELC.
> 
> Since this conference is about 6 months after the mini-summit I consider
> this a good time to organize a new V4L2 Media Controller mini-summit to
> discuss progress and future work in this area. I think that particular
> attention should be given to how we are going to do memory handling. The
> proposals from Samsung have received very little attention and we should
> discuss those in more detail.
> 
> I do not know on which dates exactly such a summit can take place. There
> are three possibilities:
> 
> April 10-11/12
> April 12-14
> April 14/15-16
> 
> I think that registering for the ELC gives to free access to the
> Collaboration Summit, but I'm waiting for a confirmation on that.
> 
> I'm not keen on the center option (12-14 April) since that often means that
> you don't see a lot of the conference itself. And the ELC is generally
> quite interesting.
> 
> There is another alternative and that is that I organize a mini-summit in
> May in Lysaker (near Oslo, Norway) at the Tandberg offices. But frankly I
> think that it is more fun to do this during/before/after a conference. If
> only because there are a lot of linux kernel experts on hand during such a
> conference that you can ask for help if needed.
> 
> Please let me know asap if you are interested in attending such a
> mini-summit and what dates are possible for you:
> 
> a: April 10-11 (or 12)
> b: April 12-14
> c: April 14 (or 15)-16
> d: Somewhere in May (suggestions for dates are welcome)

I'm not keen on the B option either. C is definitely impossible for me, 
leaving only A and D. My preference currently goes for D as I'm not sure yet 
if I will be able to attend the ELC. I should have more information in the 
next few days.

-- 
Regards,

Laurent Pinchart
