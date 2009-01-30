Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58972 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754499AbZA3JET (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 04:04:19 -0500
Date: Fri, 30 Jan 2009 10:04:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] ov772x: add support S_CROP operation.
In-Reply-To: <uzlh9maun.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901301002180.4617@axis700.grange>
References: <uskna4qh8.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901250245440.4969@axis700.grange> <uzlheep1l.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901260854010.4236@axis700.grange> <uk58hcp3k.wl%morimoto.kuninori@renesas.com>
 <alpine.DEB.2.00.0901270851280.4618@axis700.grange> <u3af1o8zz.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901300829070.4617@axis700.grange> <uzlh9maun.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jan 2009, morimoto.kuninori@renesas.com wrote:

> On my opinion, not only calling set_bus_param but also
> try_fmt is important for tw9910.
> Because tw9910 needs "INTERLACE" mode, and sh_mobile_ceu
> sets "is_interlace flag" in try_fmt.

Ooh, this is wrong. As we discussed before - try_fmt shall not perform any 
configuration, it only "tries," i.e., tests, whether the specified 
configuration is possible. This has to be moved to S_FMT.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
