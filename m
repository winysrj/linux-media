Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2BPTGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 14:06:44 -0500
Date: Thu, 16 Feb 2012 20:06:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	javier.martin@vista-silicon.com,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] media: video: mx2_camera: Remove ifdef's
In-Reply-To: <20120216183320.GB3119@tarshish>
Message-ID: <Pine.LNX.4.64.1202162004060.6033@axis700.grange>
References: <1329416739-23566-1-git-send-email-fabio.estevam@freescale.com>
 <20120216183320.GB3119@tarshish>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Thu, 16 Feb 2012, Baruch Siach wrote:

> Hi Fabio,
> 
> On Thu, Feb 16, 2012 at 04:25:39PM -0200, Fabio Estevam wrote:
> > As we are able to build a same kernel that supports both mx27 and mx25, we should remove
> > the ifdef's for CONFIG_MACH_MX27 in the mx2_camera driver.
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Acked-by: Baruch Siach <baruch@tkos.co.il>

I'm still hoping to merge this

http://patchwork.linuxtv.org/patch/298/

patch, after it is suitably updated... Sascha, any progress?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
