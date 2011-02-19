Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39257 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab1BSLFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 06:05:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Leopardimaging SoC Camera
Date: Sat, 19 Feb 2011 12:05:37 +0100
Cc: Juliano Valentini <juliano@pinaculo.com.br>,
	linux-media@vger.kernel.org
References: <AANLkTimMhMyz8E1K8__wGFC8xNeh5hVRyfOUfzsWYwiG@mail.gmail.com> <AANLkTindyMGE+LgtDR7kM-GDSmJO3SF98QYs+zAe04MD@mail.gmail.com> <Pine.LNX.4.64.1102181331060.1851@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102181331060.1851@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102191205.37939.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Friday 18 February 2011 21:53:32 Guennadi Liakhovetski wrote:
> On Fri, 18 Feb 2011, Juliano Valentini wrote:
> > Dears,
> > 
> > I'm trying to apply Guennadi's patch
> > (http://download.open-technology.de/BeagleBoard_xM-MT9P031/linux-2.6-omap
> > 3isp-bbxm-mt9p031.gitdiff) to official 2.6.37.1 Kernel version.
> 
> No, this cannot work. That kernel patch requires media-controller and
> omap3isp, so, it is based on the omap3isp branch of the development tree
> by Laurent Pinchart:
> 
> git://linuxtv.org/pinchartl/media.git
> 
> But that tree has been rebased since then, so, I wouldn't expect that
> patch to apply cleanly, porting it to the current kernel would require a
> non-zero development effort.

FYI, when the media controller patches will be merged in Mauro's tree I plan 
to start working on sensor drivers.

> > I suppose that kernel version is wrong or missing previous patches
> > (see result at the end).
> > I have to make it work:  MT9P031 SoC camera module on Beagleboard Xm.
> > Could somebody help me? Where/how can I get the right kernel version?

-- 
Regards,

Laurent Pinchart
