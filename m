Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59247 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2AWJNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 04:13:34 -0500
Date: Mon, 23 Jan 2012 10:13:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Subject: Re: [PATCH v2] media i.MX27 camera: properly detect frame loss.
In-Reply-To: <CACKLOr1nemP0Wr5zEhGed7s+kGvTFq0t0NAfipRBwHPvVLB78g@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1201231005280.11184@axis700.grange>
References: <1326297664-19089-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1201211827381.16722@axis700.grange>
 <Pine.LNX.4.64.1201221939340.1075@axis700.grange>
 <CACKLOr1nemP0Wr5zEhGed7s+kGvTFq0t0NAfipRBwHPvVLB78g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Mon, 23 Jan 2012, javier Martin wrote:

> Hi Guennadi,
> thank you for your attention.
> 
> I've recently sent a new patch series on top of this patch:
> [PATCH 0/4] media i.MX27 camera: fix buffer handling and videobuf2
> support. (http://www.mail-archive.com/linux-media@vger.kernel.org/msg42255.html)
> 
> Among other things, it adds videobuf2 support and adds "stream_stop"
> and "stream_start" callbacks which allow to enable/disable capturing
> of buffers at the right moment.
> This also makes the sequence number trick disappear and a much cleaner
> approach is used instead.
> 
> I suggest you hold on this patch until the new series is accepted and
> then merge both at the same time.
> 
> What do you think?

Ok, I'll be reviewing that patch series hopefully soon, and in principle 
it is good, that the buffer counting will really be fixed in it, but in an 
ideal world it would be better to have this your patch merged into patch 
2/4 of the series, agree? Would I be asking too much of you if I suggest 
that? Feel free to explain why this wouldn't work or just reject if you're 
just too tight on schedule. I'll see ifI can swallow it that way or maybe 
merge myself :-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
