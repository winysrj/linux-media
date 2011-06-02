Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:43848 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771Ab1FBJWh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2011 05:22:37 -0400
Date: Thu, 2 Jun 2011 03:24:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kassey Lee <ygli@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, qingx@marvell.com, ytang5@marvell.com,
	leiwen@marvell.com, jwan@marvell.com, hzhuang1@marvell.com,
	njun@marvell.com
Subject: Re: [PATCH V2] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
Message-ID: <20110602032437.3b911574@tpl.lwn.net>
In-Reply-To: <1306934205-15154-1-git-send-email-ygli@marvell.com>
References: <1306934205-15154-1-git-send-email-ygli@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed,  1 Jun 2011 21:16:45 +0800
Kassey Lee <ygli@marvell.com> wrote:

> This driver exports a video device node per each CCIC
> (CMOS Camera Interface Controller)
> device contained in Marvell Mobile PXA910 SoC
> The driver is based on soc-camera + videobuf2 frame
> work, and only USERPTR is supported.

This device looks awfully similar to the Cafe controller; you must
certainly have known that, since some of the code in your driver is
clearly copied (without attribution) from cafe_ccic.c.

As it happens, I've just written a driver for the Armada 610 SoC found
in the OLPC 1.75 system; I was planning to post it as early as next
week.  I took a different approach, though: rather than duplicating the
Cafe code, I split that driver into core and platform parts, then added
a new platform piece for the Armada 610.  I do believe that is a better
way of doing things.

That said, your driver has useful stuff that mine doesn't - MIPI
support, for example.

I'm traveling, but will be back next week.  I'll send out my work after
that; then I would really like to find a way to make all these pieces
work together with a common core for cafe-derived controllers.  Make
sense?

Thanks,

jon
