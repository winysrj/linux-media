Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:39849 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1BGNoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 08:44:38 -0500
Date: Mon, 7 Feb 2011 14:45:30 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data
 in the irq handler
Message-ID: <20110207144530.70d9dab1@wker>
In-Reply-To: <Pine.LNX.4.64.1102071232440.29036@axis700.grange>
References: <1296031789-1721-3-git-send-email-agust@denx.de>
	<1296476549-10421-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1102031104090.21719@axis700.grange>
	<20110205143505.0b300a3a@wker>
	<Pine.LNX.4.64.1102051735270.11500@axis700.grange>
	<20110205210457.7218ecdc@wker>
	<Pine.LNX.4.64.1102071205570.29036@axis700.grange>
	<20110207122147.4081f47d@wker>
	<Pine.LNX.4.64.1102071232440.29036@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 7 Feb 2011 12:35:44 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Mon, 7 Feb 2011, Anatolij Gustschin wrote:
> 
> > On Mon, 7 Feb 2011 12:09:15 +0100 (CET)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > ...
> > > > I can't try mplayer since I don't have mplayer setup for this.
> > > > But looking at the mplayer source I don't see why it should
> > > > behave differently. Depending on mode mplayer queues 2 or 6
> > > > buffers. Testing with my test app with 6 queued buffers shows
> > > > no issues, here the buffer numbers toggle correctly, too.
> > > 
> > > Ok, I've done a couple more tests. With larger frames, and, therefore 
> > > lower fps - yes, with your patch buffers toggle correctly. Whereas in my 
> > > tests with smaller frames and higher fps either only one buffer is used, 
> > > or one is used much more often, than the other, e.g., 0 0 0 1 0 0 0 1 0... 
> > > Could you try to verify? Without your patch with any fps buffers toggle 
> > > consistently.
> > 
> > How small are the frames in you test? What is the highest fps value in
> > your test?
> 
> QVGA, don't know fps exactly, pretty high, between 20 and 60fps, I think. 
> Just try different frams sizes, go down to 64x48 or something.

Testing of 960x243 frames at 30 fps has been done during all my previous
tests. I didn't see any issues at 30 fps.

Anatolij
