Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab1JRQnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 12:43:45 -0400
Date: Tue, 18 Oct 2011 18:43:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux-V4L2 <linux-media@vger.kernel.org>,
	Takashi.Namiki@renesas.com, phil.edworthy@renesas.com
Subject: Re: [PATCH 2/3] soc-camera: mt9t112: modify delay time after initialize
In-Reply-To: <87vcrtl9d7.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <Pine.LNX.4.64.1110181834570.7139@axis700.grange>
References: <uock8ky42.wl%morimoto.kuninori@renesas.com> <4E76149D.5050102@redhat.com>
 <Pine.LNX.4.64.1109181808410.9975@axis700.grange> <87aaa0njj0.wl%kuninori.morimoto.gx@renesas.com>
 <Pine.LNX.4.64.1109200931210.11274@axis700.grange>
 <Pine.LNX.4.64.1109301116130.1888@axis700.grange> <87vcrtl9d7.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

On Wed, 12 Oct 2011, Kuninori Morimoto wrote:

> Hi Guennadi
> 
> > There was a question at the bottom of this email, which you might have 
> > overseen:-) Could you give me an idea, which patche(es) exactly you meant?
> 
> sorry for my super late response.
> I losted this email.
> 
> 
> > > > > > Subject: [PATCH 2/3] soc-camera: mt9t112: modify delay time after initialize
> (snip)
> > > > > > Subject: [PATCH 3/3] soc-camera: mt9t112: The flag which control camera-init is removed
> 
> > > > This patch is needed for mt9t112 camera initialize.
> > > > I thought that it was already applied.
> > > 
> > > Which patch do you mean? Patch 2/3, or 3/3, or both are needed?
> 
> Both are needed.
> These are bug fix patches

I tried to capture several frames beginning with the very first one (as 
much as performance allowed), and I do see several black or wrongly 
coloured framed in the beginning, but none of those patches, including the 
proposed 300ms at the end of .s_stream() fixes the problem reliably. So, 
either this problems, that these patches fix, are specific to the Solution 
Engine board (is it the one, where the problems have been observed?), or 
one needs a different testing method. If they are SE-specific - I don't 
think, getting those fixes in the driver is very important, because 
mt9t112 data for SE is not in the mainline. If I was testing wrongly, 
please, tell me how exactly to reproduce those problems and see, how one 
or another patch fixes them.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
