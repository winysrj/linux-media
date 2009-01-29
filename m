Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39054 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751172AbZA2KAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 05:00:37 -0500
Date: Thu, 29 Jan 2009 11:00:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: morimoto.kuninori@renesas.com,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add support S_CROP operation.
In-Reply-To: <20090129075127.6dd3340c@caramujo.chehab.org>
Message-ID: <Pine.LNX.4.64.0901291057470.5474@axis700.grange>
References: <uskna4qh8.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901250245440.4969@axis700.grange> <uzlheep1l.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901260854010.4236@axis700.grange> <uk58hcp3k.wl%morimoto.kuninori@renesas.com>
 <alpine.DEB.2.00.0901270851280.4618@axis700.grange>
 <20090129075127.6dd3340c@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009, Mauro Carvalho Chehab wrote:

> On Tue, 27 Jan 2009 08:53:23 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> Hi Guennadi,
> 
> I'm understanding that you're reviewing this patch and other ones for
> soc_camera and will send me a PULL request after reviewing those stuff.

Yes, I'm (going to be) reviewing them, as soon as I find some time. Then 
I'll send you two pull requests - fixes for 2.6.29 and 2.6.30 material. 
AFAIK, unfortunately, mercurial doesn't support branches, so, I probably 
will end up first sending you a pull request with fixes, and after some 
time I'll also add 2.6.30 further development to the same tree and send 
another pull request. No idea what I do, if after that more 2.6.29 fixes 
come...

> I've updated patchwork to reflect this.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
