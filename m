Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:64861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1BGLfv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 06:35:51 -0500
Date: Mon, 7 Feb 2011 12:35:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data
 in the irq handler
In-Reply-To: <20110207122147.4081f47d@wker>
Message-ID: <Pine.LNX.4.64.1102071232440.29036@axis700.grange>
References: <1296031789-1721-3-git-send-email-agust@denx.de>
 <1296476549-10421-1-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1102031104090.21719@axis700.grange> <20110205143505.0b300a3a@wker>
 <Pine.LNX.4.64.1102051735270.11500@axis700.grange> <20110205210457.7218ecdc@wker>
 <Pine.LNX.4.64.1102071205570.29036@axis700.grange> <20110207122147.4081f47d@wker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 7 Feb 2011, Anatolij Gustschin wrote:

> On Mon, 7 Feb 2011 12:09:15 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> ...
> > > I can't try mplayer since I don't have mplayer setup for this.
> > > But looking at the mplayer source I don't see why it should
> > > behave differently. Depending on mode mplayer queues 2 or 6
> > > buffers. Testing with my test app with 6 queued buffers shows
> > > no issues, here the buffer numbers toggle correctly, too.
> > 
> > Ok, I've done a couple more tests. With larger frames, and, therefore 
> > lower fps - yes, with your patch buffers toggle correctly. Whereas in my 
> > tests with smaller frames and higher fps either only one buffer is used, 
> > or one is used much more often, than the other, e.g., 0 0 0 1 0 0 0 1 0... 
> > Could you try to verify? Without your patch with any fps buffers toggle 
> > consistently.
> 
> How small are the frames in you test? What is the highest fps value in
> your test?

QVGA, don't know fps exactly, pretty high, between 20 and 60fps, I think. 
Just try different frams sizes, go down to 64x48 or something.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
