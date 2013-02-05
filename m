Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36592 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab3BEDOR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Feb 2013 22:14:17 -0500
Date: Mon, 4 Feb 2013 20:14:16 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2
 parts for soc_camera support
Message-ID: <20130204201416.23485c28@lwn.net>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D14255139@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-11-git-send-email-twang13@marvell.com>
	<20121216093717.4be8feff@hpe.lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8CCE4@SC-VEXCH1.marvell.com>
	<20121217082832.7f363d05@lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8D0E3@SC-VEXCH1.marvell.com>
	<20121218121508.7a4de314@lwn.net>
	<477F20668A386D41ADCC57781B1F70430D14255139@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My apologies for the slow response...I'm running far behind.

On Thu, 31 Jan 2013 00:29:13 -0800
Albert Wang <twang13@marvell.com> wrote:

> As you know, we are working on adding B_DMA_SG support on soc_camera mode.
> 
> We found there is some code we can't understand in irq handler:
> >>>>>>  
> if (handled == IRQ_HANDLED) {
> 	set_bit(CF_DMA_ACTIVE, &cam->flags);
> 	if (cam->buffer_mode == B_DMA_sg)
> 		mcam_ctlr_stop(cam);
> }
> <<<<<<
> 
> The question is why we need stop ccic in irq handler when buffer mode is B_DMA_sg?

That's actually intended to be addressed by this comment in the DMA setup
code:

/*
 * Frame completion with S/G is trickier.  We can't muck with
 * a descriptor chain on the fly, since the controller buffers it
 * internally.  So we have to actually stop and restart; Marvell
 * says this is the way to do it.
 *

...and, indeed, at the time, I was told by somebody at Marvell that I
needed to stop the controller before I could store a new descriptor into
the chain.  I don't see how it could work otherwise, really?

I'd be happy to see this code go, it always felt a bit hacky.  But the
controller buffers the descriptor chain deep inside its unreachable guts,
so one has to mess with it carefully.

Thanks,

jon
