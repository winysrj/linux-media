Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2J3O5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 10:57:17 -0400
Date: Tue, 30 Oct 2012 15:57:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Fabio Estevam <festevam@gmail.com>, linux-media@vger.kernel.org,
	fabio.estevam@freescale.com
Subject: Re: [PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
In-Reply-To: <CACKLOr0r2w-=f=PUU-s7x302Jvp3urBZcRQa3pjArZYx0BSjtg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1210301547300.29432@axis700.grange>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
 <1351599395-16833-2-git-send-email-javier.martin@vista-silicon.com>
 <CAOMZO5C0yvvXs38B4zt46zsjphif-tg=FoEjBeoLx7iQUut62Q@mail.gmail.com>
 <Pine.LNX.4.64.1210301327090.29432@axis700.grange>
 <CACKLOr0r2w-=f=PUU-s7x302Jvp3urBZcRQa3pjArZYx0BSjtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Oct 2012, javier Martin wrote:

> Hi Guennadi, Fabio,
> 
> On 30 October 2012 13:29, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Tue, 30 Oct 2012, Fabio Estevam wrote:
> >
> >> Javier,
> >>
> >> On Tue, Oct 30, 2012 at 10:16 AM, Javier Martin
> >> <javier.martin@vista-silicon.com> wrote:
> >> > i.MX25 support has been broken for several releases
> >> > now and nobody seems to care about it.
> >>
> >> I will work on fixing camera support for mx25. Please do not remove its support.
> >
> > This is good to hear, thanks for doing this! But we also don't want to
> > slow down Javier's work, if he works on features, only available on i.MX27
> > or that he can only test there. How about separating parts of code,
> > specific to each platform more cleanly? Maybe add an mx27_camera.c file to
> > build the final driver from both files and mx27 and only from one on mx25?
> > Or something similar? Would this be difficult or make sense at all?
> >
> 
> It's pretty good that you want to provide proper support for video
> capture on mx25 but I am still in favour of applying this patch for
> several reasons:

Fabio, I wasn't in favour of removing mx25 support initially and I still 
don't quite fancy it, but the delta is getting too large. If we remove it 
now you still have the git history, so, you'll be able to restore the 
latest state before removal. OTOH, it would be easier for me to review a 
50-line fix patch, than a 400-line revert-and-fix patch, so, this has an 
adbantage too. 

Let's try the following: I'm away the whole next week, so, I'll wait for 
your patches for almost 2 weeks until around 10.11. If you don't manage to 
fix the driver until then, we remove mx25 support to have it re-added 
later. What do you think?

Thanks
Guennadi

> 1. i.mx25 "support" is so broken now that it would be better to start
> from scratch IMHO.
> 2. AFAIK mx25 is not provided with an eMMa-PrP module. The current
> mx2_camera driver relies on this module to perform DMA transfers. If
> we added support for i.MX25 in this file, we'd have to use generic
> DMAs again, which is something we already removed in the past.
> 3. CSI provided in i.mx25 has more features than the one in the
> i.MX27, so the code they possibly share is even more reduced.
> 
> By the way, removal of all i.mx25 traces in this file was  announced
> several times in the past:
> 
> 9 Jul 2012
> [PATCH] [v3] i.MX27: Fix emma-prp clocks in mx2_camera.c
> 26 Jul 2012
> [PATCH 2/4] media: mx2_camera: Mark i.MX25 support as BROKEN.
> [PATCH 3/4] Schedule removal of i.MX25 support in mx2_camera.c
> 
> In my opinion. i.mx25 video capture support should be added in a
> separate file later. Though some CSI features are common, the lack of
> eMMa-PrP in i.mx25 will make the driver be very different.
> 
> Please, expect a v2 of this patch soon. I've just remembered that I
> missed removing i.MX25 traces from the Kconfig file too.
> 
> Regards.
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
