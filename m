Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:56994 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1FBJ6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 05:58:23 -0400
Date: Thu, 2 Jun 2011 11:58:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: Kassey Lee <ygli@marvell.com>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, qingx@marvell.com, ytang5@marvell.com,
	leiwen@marvell.com, jwan@marvell.com, hzhuang1@marvell.com,
	njun@marvell.com
Subject: Re: [PATCH V2] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
In-Reply-To: <20110602032437.3b911574@tpl.lwn.net>
Message-ID: <Pine.LNX.4.64.1106021132460.4067@axis700.grange>
References: <1306934205-15154-1-git-send-email-ygli@marvell.com>
 <20110602032437.3b911574@tpl.lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2 Jun 2011, Jonathan Corbet wrote:

> On Wed,  1 Jun 2011 21:16:45 +0800
> Kassey Lee <ygli@marvell.com> wrote:
> 
> > This driver exports a video device node per each CCIC
> > (CMOS Camera Interface Controller)
> > device contained in Marvell Mobile PXA910 SoC
> > The driver is based on soc-camera + videobuf2 frame
> > work, and only USERPTR is supported.
> 
> This device looks awfully similar to the Cafe controller; you must
> certainly have known that, since some of the code in your driver is
> clearly copied (without attribution) from cafe_ccic.c.

Yes, I noticed this, as I saw the cafe_ccic header being included in this 
driver.

> As it happens, I've just written a driver for the Armada 610 SoC found
> in the OLPC 1.75 system; I was planning to post it as early as next
> week.  I took a different approach, though: rather than duplicating the
> Cafe code, I split that driver into core and platform parts, then added
> a new platform piece for the Armada 610.  I do believe that is a better
> way of doing things.
> 
> That said, your driver has useful stuff that mine doesn't - MIPI
> support, for example.
> 
> I'm traveling, but will be back next week.  I'll send out my work after
> that; then I would really like to find a way to make all these pieces
> work together with a common core for cafe-derived controllers.  Make
> sense?

This is definitely the right direction! Thanks for your heads-up!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
