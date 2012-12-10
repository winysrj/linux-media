Return-path: <linux-media-owner@vger.kernel.org>
Received: from [212.255.97.148] ([212.255.97.148]:34461 "EHLO
	neutronstar.dyndns.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab2LJWKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 17:10:14 -0500
Date: Mon, 10 Dec 2012 23:01:31 +0100
From: martin@neutronstar.dyndns.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: drivers without explicit MAINTAINERS entry - was: Re:
 [media-workshop] Tentative Agenda for the November workshop
Message-ID: <20121210220131.GH10025@neutronstar.dyndns.org>
References: <201210221035.56897.hverkuil@xs4all.nl>
 <20121102111310.755e38aa@gaivota.chehab>
 <11275936.PtJ8jrzDFv@avalon>
 <1424972.CmdJA1f2pQ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1424972.CmdJA1f2pQ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2012 at 10:53:17AM +0100, Laurent Pinchart wrote:
> Hi Martin,
> 
> On Thursday 08 November 2012 15:18:38 Laurent Pinchart wrote:
[ snip ]
> > 
> > These are 'Maintained' by me:
> > 
> > i2c/aptina-pll.ko              = i2c/aptina-pll.c
> > i2c/mt9p031.ko                 = i2c/mt9p031.c
> > i2c/mt9t001.ko                 = i2c/mt9t001.c
> > i2c/mt9v032.ko                 = i2c/mt9v032.c
> > 
> > I can maintain the following driver if needed:
> > 
> > i2c/mt9m032.ko                 = i2c/mt9m032.c
> 
> Do you plan to send a MAINTAINERS patch for this driver (and thus maintain the 
> driver :-)), or should I maintain it ?

I sadly neigher have time nor hardware to maintain this driver at the moment so i would
be more than happy if you can maintain it.

Thanks,
 - Martin Hostettler


> 
> > I could also take over maintenance the following driver, but I don't have
> > access to a hardware platform that uses it:
> > 
> > i2c/mt9v011.ko                 = i2c/mt9v011.c
> > 
> > These are, as far as I know, co-maintained by Sakari and me :-)
> > 
> > i2c/adp1653.ko                 = i2c/adp1653.c
> > i2c/as3645a.ko                 = i2c/as3645a.c
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
