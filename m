Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38600 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751614AbZBBHgc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 02:36:32 -0500
Date: Mon, 2 Feb 2009 08:36:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] sh_mobile_ceu: SOCAM flags are prepared at itself.
In-Reply-To: <uocxlzn8c.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902020832570.4218@axis700.grange>
References: <uvdrxm9sd.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0902012017230.17985@axis700.grange>
 <Pine.LNX.4.64.0902012335150.17985@axis700.grange> <uocxlzn8c.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Feb 2009, morimoto.kuninori@renesas.com wrote:

> > > Guys, are you both sure this should be SLAVE, not MASTER? Have you tested 
> > > it? Both tw9910 and ov772x register themselves as MASTER and from the 
> 
> Of course I tested it.

Yes, as I said, I have overseen the fact, that soc-camera doesn't 
currently check for master / slave mode, so it would work for you even 
with a wrong setting. Sorry again.

> > Ok, sorry, you, probably, did test it and it worked, but just because the 
> > SLAVE / MASTER flag is not tested in soc_camera_bus_param_compatible(), 
> > which I should fix with the next pull, but this does look wrong. Please, 
> > fix.
> 
> Hmm. I should have asked you what is MASTER/SLAVE before sending patch.
> I suspect it it about who generates the clock signal 
> either the camera or the host.
> Our CEU does not support any clock generation so it is always SLAVE.
> Therefore I didn't support MASTER for CEU.
> 
> But it seems wrong understanding...
> I would like ask you What MASTER/SLAVE means ?

MASTER / SLAVE means not the role of the respective device, but the mode. 
Master mode means the camera sensor / decoder / whatever other client is 
the master, i.e., generates the pixel clock and sync signals, the slave 
mode means, that the host generates all sync signals.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
