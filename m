Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47382 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750883AbZDNJxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 05:53:44 -0400
Date: Tue, 14 Apr 2009 11:53:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] pcm990 baseboard: add camera bus width switch setting
In-Reply-To: <20090414093820.GF14383@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0904141140460.1587@axis700.grange>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de>
 <Pine.LNX.4.64.0903121405150.4896@axis700.grange> <20090312141819.GN425@pengutronix.de>
 <Pine.LNX.4.64.0904092339320.4841@axis700.grange>
 <Pine.LNX.4.64.0904141053230.1587@axis700.grange> <20090414091005.GA14383@pengutronix.de>
 <Pine.LNX.4.64.0904141115070.1587@axis700.grange> <20090414093820.GF14383@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 14 Apr 2009, Sascha Hauer wrote:

> On Tue, Apr 14, 2009 at 11:20:03AM +0200, Guennadi Liakhovetski wrote:
> > 
> > If you don't object, I'll just add a .free_bus method to soc_camera_link, 
> > and switch pcm990 to only use two values: a negative value for a 
> > non-allocated gpio - either before the first attempt or after an error, 
> > thus re-trying every time if gpio is negative, in case a driver has been 
> > loaded in the meantime.
> 
> For the sake of symmetry, shouldn't we have an init function aswell?

Well, for the sake of symmetry - yes, but I'm not sure we want to bloat 
this simple API further just to make it symmetric... You think it's worth 
it? Or do you have any "practical" reasons for that? Of course, we could 
also add a void *bus_resource to soc_camera_link and get rid of the static 
gpio_bus_switch and allocate it dynamically in .bus_init and free it in 
.bus_release, but...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
