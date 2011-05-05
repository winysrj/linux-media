Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:52941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1EEKRO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 06:17:14 -0400
Date: Thu, 5 May 2011 12:17:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: omap3isp clock problems on Beagleboard xM.
In-Reply-To: <BANLkTinRqcFj5doua4r6d-vwPAym=JGvDw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1105051215340.29735@axis700.grange>
References: <BANLkTinRqcFj5doua4r6d-vwPAym=JGvDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 5 May 2011, javier Martin wrote:

> Hi,
> as you know I'm currently working on submitting mt9p031 driver to
> mainline, testing it with my Beagleboard xM.
> While I was trying to clean Guennadi's patches I ran into the attached
> patch which changes a call to "omap3isp_get(isp);" into
> "isp_enable_clocks(isp);".
> 
> I don't think this is clean since it would unbalance the number of
> omap3isp_get() vs omap3isp_put() and we probably don't want that.
> What seems clear is if we don't apply this patch the clock is not
> actually enabled.
> 
> According to my debugging results "isp_disable_clocks()" is never
> called, so, after the first call to "isp_enable_clocks()" there
> shouldn't be any need to enable the clocks again.
> 
> Guennadi, do you know what is the cause of the problem?

I don't remember exactly, but it didn't work without this patch. I know it 
is not clean and shouldn't be needed, so, if now it works also without it 
- perfect! You can start, stop, and restart streaming without this patch 
and it all works? Then certainly it should be dropped.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
