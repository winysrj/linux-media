Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38982 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZDNJ77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 05:59:59 -0400
Date: Tue, 14 Apr 2009 11:59:57 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] pcm990 baseboard: add camera bus width switch
	setting
Message-ID: <20090414095957.GI14383@pengutronix.de>
References: <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de> <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de> <Pine.LNX.4.64.0903121405150.4896@axis700.grange> <20090312141819.GN425@pengutronix.de> <Pine.LNX.4.64.0904092339320.4841@axis700.grange> <Pine.LNX.4.64.0904141053230.1587@axis700.grange> <20090414091005.GA14383@pengutronix.de> <Pine.LNX.4.64.0904141115070.1587@axis700.grange> <20090414093820.GF14383@pengutronix.de> <Pine.LNX.4.64.0904141140460.1587@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904141140460.1587@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 14, 2009 at 11:53:54AM +0200, Guennadi Liakhovetski wrote:
> On Tue, 14 Apr 2009, Sascha Hauer wrote:
> 
> > On Tue, Apr 14, 2009 at 11:20:03AM +0200, Guennadi Liakhovetski wrote:
> > > 
> > > If you don't object, I'll just add a .free_bus method to soc_camera_link, 
> > > and switch pcm990 to only use two values: a negative value for a 
> > > non-allocated gpio - either before the first attempt or after an error, 
> > > thus re-trying every time if gpio is negative, in case a driver has been 
> > > loaded in the meantime.
> > 
> > For the sake of symmetry, shouldn't we have an init function aswell?
> 
> Well, for the sake of symmetry - yes, but I'm not sure we want to bloat 
> this simple API further just to make it symmetric... You think it's worth 
> it? Or do you have any "practical" reasons for that? Of course, we could 
> also add a void *bus_resource to soc_camera_link and get rid of the static 
> gpio_bus_switch and allocate it dynamically in .bus_init and free it in 
> .bus_release, but...

No, I have no practical use for it at the moment. My feeling says it's
better to add it, but just follow your feelings instead of mine ;)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
