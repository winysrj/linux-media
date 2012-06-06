Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab2FFQEc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 12:04:32 -0400
Date: Wed, 6 Jun 2012 18:04:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fabio Estevam <festevam@gmail.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de,
	shawn.guo@freescale.com,
	Fabio Estevam <fabio.estevam@freescale.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 06/15] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
In-Reply-To: <CAOMZO5DrVWNKscMdXORTJo+fss+O5Lykc+5hJ1d33Ae7M1mcHg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1206061759010.12739@axis700.grange>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
 <1337987696-31728-6-git-send-email-festevam@gmail.com>
 <20120529092030.GI30400@pengutronix.de> <CAOMZO5DrVWNKscMdXORTJo+fss+O5Lykc+5hJ1d33Ae7M1mcHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 6 Jun 2012, Fabio Estevam wrote:

> Guennadi,
> 
> On Tue, May 29, 2012 at 6:20 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Fri, May 25, 2012 at 08:14:47PM -0300, Fabio Estevam wrote:
> >> From: Fabio Estevam <fabio.estevam@freescale.com>
> >>
> >> Prepare the clock before enabling it.
> >>
> >> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> Cc: <linux-media@vger.kernel.org>
> >> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> >
> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Can patches 6, 7 and 8 be applied?

Yes, I'll pick up #6 and 7. #8 is not for me - mx2_emmaprp is not an 
soc-camera driver, I'm not maintaining it. I understand, these patches are 
not really bug-fixes (is clk_prepare() a NOP on mx*?) and can wait until 
3.6? Or should they be considered correctness fixes and go into 3.5?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
