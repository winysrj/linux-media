Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:57016 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2LPWwe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 17:52:34 -0500
Date: Sun, 16 Dec 2012 15:55:03 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 15/15] [media] marvell-ccic: add 3 frame buffers
 support in DMA_CONTIG mode
Message-ID: <20121216155503.2ce60997@lwn.net>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D13C8CCE7@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-16-git-send-email-twang13@marvell.com>
	<20121216095601.4a086356@hpe.lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8CCE7@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 16 Dec 2012 14:34:31 -0800
Albert Wang <twang13@marvell.com> wrote:

> >What is the purpose of the "usebufs" field?  The code maintains it in
> >various places, but I don't see anywhere that actually uses that value for
> >anything.
> >  
> [Albert Wang] Two buffers mode doesn't need it.
> But Three buffers mode need it indicates which conditions we need set the single buffer flag.
> I used "tribufs" as the name in the previous version, but it looks it's a confused name when we merged
> Two buffers mode and Three buffers mode with same code by removing #ifdef based on your comments months ago. :)
> So we just changed the name with "usebufs".

OK, I misread the code a bit, sorry.  I do find the variable confusing
still, but it clearly does play a role.

I think that using three buffers by default would make sense.  I don't
think that increased overruns are an unbreakable ABI feature :)

Feel free to add my ack to this one.

Thanks,

jon
