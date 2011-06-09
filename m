Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:48763 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab1FIOmz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 10:42:55 -0400
Date: Thu, 9 Jun 2011 08:42:53 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kassey Lee <kassey1216@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Kassey Lee <ygli@marvell.com>, linux-media@vger.kernel.org,
	ytang5@marvell.com, qingx@marvell.com, jwan@marvell.com,
	leiwen@marvell.com
Subject: Re: [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
Message-ID: <20110609084253.4a5af243@bike.lwn.net>
In-Reply-To: <BANLkTikbN87Yja-MxA4eu1z=1HJ6wU=-kA@mail.gmail.com>
References: <1307530660-25464-1-git-send-email-ygli@marvell.com>
	<Pine.LNX.4.64.1106081322590.24274@axis700.grange>
	<BANLkTikS1nhSnrvQv=s4Xe2_Juf1i-xwfg@mail.gmail.com>
	<Pine.LNX.4.64.1106091042100.17738@axis700.grange>
	<BANLkTikbN87Yja-MxA4eu1z=1HJ6wU=-kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 9 Jun 2011 16:46:47 +0800
Kassey Lee <kassey1216@gmail.com> wrote:

>         As Jon will convert cafe_ccic.c to videobuf2 too, I wish He
> can review this driver too, if it is useful for him.
>         and find the common ccic core. Just Mark it.

I do plan to take a close look at the driver; if nothing else, I want to
be sure that the core code can support it with minimal pain.  I tend to be
busy early in the week, but much of today is set aside for work in this
area.

Thanks,

jon
