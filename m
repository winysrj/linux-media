Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:35088 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757407Ab0HDJry (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Aug 2010 05:47:54 -0400
Date: Wed, 4 Aug 2010 11:48:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
In-Reply-To: <20100804085326.GA10780@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008041133440.29386@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de>
 <Pine.LNX.4.64.1008032016340.10845@axis700.grange> <20100803195727.GB12367@pengutronix.de>
 <Pine.LNX.4.64.1008040039550.10845@axis700.grange> <20100804070949.GR14113@pengutronix.de>
 <Pine.LNX.4.64.1008041020280.29386@axis700.grange> <20100804085326.GA10780@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Aug 2010, Michael Grzeschik wrote:

> No, sorry but this doesn't solve the problem. I tested it and get an
> "unable to get regulator: -19" when i hit on that. The problem is the
> device init order. The pcm970_baseboard_init_late comes first and
> then the regulator. So i think we should keep that patch.

Ok, you could register a bus-notifier on the soc-camera bus 
(http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/21364/focus=8520), 
watching out for a BUS_NOTIFY_ADD_DEVICE event. I think, that would be a 
more elegant solution, with it we still preserve the ability to clean up 
the probe function. Although, for that, I think, we'd need to make it 
__init instead of __devinit. In any case, I would prefer that solution, 
however, if for some reason you cannot or do not want to do it, I'll take 
this patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
