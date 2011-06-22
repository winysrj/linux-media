Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:40804 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888Ab1FVWM6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 18:12:58 -0400
Date: Wed, 22 Jun 2011 16:12:56 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kassey Lee <kassey1216@gmail.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Drake <dsd@laptop.org>, ytang5@marvell.com,
	leiwen@marvell.com, qingx@marvell.com
Subject: Re: [PATCH 2/8] marvell-cam: Separate out the Marvell camera core
Message-ID: <20110622161256.57a663da@bike.lwn.net>
In-Reply-To: <BANLkTikO-oRJXgqkL557d9RZ6PMBFTzVCg@mail.gmail.com>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-3-git-send-email-corbet@lwn.net>
	<BANLkTikVeHLL6+T74tpmwmsL4_3h5f3PmA@mail.gmail.com>
	<20110614084948.2d158323@bike.lwn.net>
	<BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
	<BANLkTi=gLkmuheH0aCwx=7-DuxDH3q769w@mail.gmail.com>
	<20110616092726.024701c9@bike.lwn.net>
	<BANLkTikO-oRJXgqkL557d9RZ6PMBFTzVCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

[Sorry, I'm just now recovering from one of those
total-loss-of-inbox-control episodes...]

On Fri, 17 Jun 2011 11:11:33 +0800
Kassey Lee <kassey1216@gmail.com> wrote:

>      the problem is:
>      when we stop CCIC, and then switch to another format.
>      at this stage, actually, CCIC DMA is not stopped until the
> transferring frame is done. this will cause system hang if we start
> CCIC again with another format.

OK, I've never encountered that.  The use case I'm coding for (OLPC)
doesn't involve a whole lot of format changes; generally they pick a
format for their record activity based on what works best on the display
side and stick with it.

>      from your logic, when stop DMA, you are test the EOF/SOF, so I
> wonder why you want to do this ?
>      and is your test will stop CCIC and start CCIC frequently  ?

I wanted a way to know whether DMA was active or not; the idea was that an
SOF indicates that things are starting, EOF says that it's done.  Are you
saying that there can be DMA active in the period after an EOF when the
subsequent SOF has not been received?

Thanks,

jon
