Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34190 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab1EEKWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 06:22:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: omap3isp clock problems on Beagleboard xM.
Date: Thu, 5 May 2011 12:23:17 +0200
Cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org
References: <BANLkTinRqcFj5doua4r6d-vwPAym=JGvDw@mail.gmail.com> <Pine.LNX.4.64.1105051215340.29735@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105051215340.29735@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105051223.17801.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Thursday 05 May 2011 12:17:12 Guennadi Liakhovetski wrote:
> On Thu, 5 May 2011, javier Martin wrote:
> > Hi,
> > as you know I'm currently working on submitting mt9p031 driver to
> > mainline, testing it with my Beagleboard xM.
> > While I was trying to clean Guennadi's patches I ran into the attached
> > patch which changes a call to "omap3isp_get(isp);" into
> > "isp_enable_clocks(isp);".
> > 
> > I don't think this is clean since it would unbalance the number of
> > omap3isp_get() vs omap3isp_put() and we probably don't want that.
> > What seems clear is if we don't apply this patch the clock is not
> > actually enabled.
> > 
> > According to my debugging results "isp_disable_clocks()" is never
> > called, so, after the first call to "isp_enable_clocks()" there
> > shouldn't be any need to enable the clocks again.
> > 
> > Guennadi, do you know what is the cause of the problem?
> 
> I don't remember exactly, but it didn't work without this patch. I know it
> is not clean and shouldn't be needed, so, if now it works also without it
> - perfect! You can start, stop, and restart streaming without this patch
> and it all works? Then certainly it should be dropped.

And otherwise you can work on a fix ;-) I unfortunately have no sensor module 
for the Beagleboard xM so I can't really test this.

-- 
Regards,

Laurent Pinchart
