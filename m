Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:65045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2J3M3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 08:29:52 -0400
Date: Tue, 30 Oct 2012 13:29:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fabio Estevam <festevam@gmail.com>
cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, fabio.estevam@freescale.com
Subject: Re: [PATCH 1/4] media: mx2_camera: Remove i.mx25 support.
In-Reply-To: <CAOMZO5C0yvvXs38B4zt46zsjphif-tg=FoEjBeoLx7iQUut62Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1210301327090.29432@axis700.grange>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
 <1351599395-16833-2-git-send-email-javier.martin@vista-silicon.com>
 <CAOMZO5C0yvvXs38B4zt46zsjphif-tg=FoEjBeoLx7iQUut62Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Oct 2012, Fabio Estevam wrote:

> Javier,
> 
> On Tue, Oct 30, 2012 at 10:16 AM, Javier Martin
> <javier.martin@vista-silicon.com> wrote:
> > i.MX25 support has been broken for several releases
> > now and nobody seems to care about it.
> 
> I will work on fixing camera support for mx25. Please do not remove its support.

This is good to hear, thanks for doing this! But we also don't want to 
slow down Javier's work, if he works on features, only available on i.MX27 
or that he can only test there. How about separating parts of code, 
specific to each platform more cleanly? Maybe add an mx27_camera.c file to 
build the final driver from both files and mx27 and only from one on mx25? 
Or something similar? Would this be difficult or make sense at all?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
