Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:60590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1BGNfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 08:35:10 -0500
Date: Mon, 7 Feb 2011 14:35:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Detlev Zundel <dzu@denx.de>
cc: Anatolij Gustschin <agust@denx.de>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data
 in the irq handler
In-Reply-To: <m24o8g80cj.fsf@ohwell.denx.de>
Message-ID: <Pine.LNX.4.64.1102071428470.29036@axis700.grange>
References: <1296031789-1721-3-git-send-email-agust@denx.de>
 <1296476549-10421-1-git-send-email-agust@denx.de>
 <Pine.LNX.4.64.1102031104090.21719@axis700.grange> <20110205143505.0b300a3a@wker>
 <Pine.LNX.4.64.1102051735270.11500@axis700.grange> <20110205210457.7218ecdc@wker>
 <Pine.LNX.4.64.1102071205570.29036@axis700.grange> <20110207122147.4081f47d@wker>
 <Pine.LNX.4.64.1102071232440.29036@axis700.grange> <m24o8g80cj.fsf@ohwell.denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Detlev

On Mon, 7 Feb 2011, Detlev Zundel wrote:

> Hi Guennadi,
> 
> >> How small are the frames in you test? What is the highest fps value in
> >> your test?
> >
> > QVGA, don't know fps exactly, pretty high, between 20 and 60fps, I think. 
> > Just try different frams sizes, go down to 64x48 or something.
> 
> Is this a "real" usage scenario?  It feels that this is not what most
> users will do and it certainly is not relevant for our application.  

QVGA at 25 / 50 / 60 fps is _certainly_ very much a real-life scenario.

> Is it possible that if you are interested in such a scenario that you do
> the testing?  We have spent quite a lot of time to fix the driver for
> real (well full frame) capturing already and I am relucatant to spend
> more time for corner cases.  Maybe we should document this as "known
> limitations" of the setup?  What do you think?  I'll much rather have a
> driver working for real world scenarios than for marginal test cases.

I am interested in avoiding regressions. In principle, this is a DMA 
driver, which I am not maintaining. Dan asked for my ack, so, I tested it 
and found an issue, which I would prefer to have resolved before 
committing. Of course, I don't have a decisive voice in this matter, so, 
the patch can also be merged without my ack. Otherwise - of course you 
don't have to continue testing, I will try to look at the issue as the 
time permits, and Dan will have to decide, whether he is prepared to 
commit this patch in its present form, or he would prefer this issue to be 
clarified.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
