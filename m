Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42492 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab2JPUEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 16:04:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris MacGregor <chris@cybermato.com>,
	linux-media@vger.kernel.org, Liu Ying <Ying.liu@freescale.com>,
	"Hans J. Koch" <hjk@linutronix.de>, Daniel Mack <daniel@zonque.org>
Subject: Re: hacking MT9P031 for i.mx
Date: Tue, 16 Oct 2012 22:04:57 +0200
Message-ID: <2180583.3hl5tPmpSx@avalon>
In-Reply-To: <1350043843.3730.32.camel@mars>
References: <ade8080d-dbbf-4b60-804c-333d7340c01e@googlegroups.com> <4301383.IPfSC38GGz@avalon> <1350043843.3730.32.camel@mars>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 October 2012 14:10:43 Christoph Fritz wrote:
> On Mon, 2012-07-02 at 14:48 +0200, Laurent Pinchart wrote:
> > On Thursday 28 June 2012 21:41:16 Chris MacGregor wrote:
> > > > Where did you get the Aptina board code patch from ?
> > >  
> > >  From here: https://github.com/Aptina/BeagleBoard-xM
> > 
> > That's definitely outdated, the code is based on a very old OMAP3 ISP
> > driver that was more or less broken by design. Nowadays anything other
> > than the mainline version isn't supported by the community.
> 
> Is there a current (kernel ~3.6) git tree which shows how to add mt9p031
> to platform code?

Yes, at 
http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
sensors-board

> I'm also curious if it's possible to glue mt9p031 to a freescale i.mx35
> platform. As far as I can see,
> drivers/media/platform/soc_camera/mx3_camera.c would need v4l2_subdev
> support?

-- 
Regards,

Laurent Pinchart
