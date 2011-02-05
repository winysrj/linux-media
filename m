Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.9]:53612 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1BEUEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 15:04:15 -0500
Date: Sat, 5 Feb 2011 21:04:57 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data
 in the irq handler
Message-ID: <20110205210457.7218ecdc@wker>
In-Reply-To: <Pine.LNX.4.64.1102051735270.11500@axis700.grange>
References: <1296031789-1721-3-git-send-email-agust@denx.de>
	<1296476549-10421-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1102031104090.21719@axis700.grange>
	<20110205143505.0b300a3a@wker>
	<Pine.LNX.4.64.1102051735270.11500@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 5 Feb 2011 17:36:37 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > > Verified with both capture.c and mplayer. Could you, please, verify 
> > > whether you get the same behaviour and what the problem could be?
> > 
> > Now I did some further testing with idmac patch applied and with
> > added debug print in the IDMAC interrupt handler. There is no problem.
> > Testing with capture.c (4 buffers used as default) shows that buffer
> > numbers toggle correctly for all 100 captured frames:
> 
> Hm, interesting, I'll have to look at my testing in more detail then 
> (once back from FOSDEM). Could you maybe try mplayer too?

I can't try mplayer since I don't have mplayer setup for this.
But looking at the mplayer source I don't see why it should
behave differently. Depending on mode mplayer queues 2 or 6
buffers. Testing with my test app with 6 queued buffers shows
no issues, here the buffer numbers toggle correctly, too.

Anatolij
