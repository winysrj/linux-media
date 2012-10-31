Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab2JaNyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 09:54:11 -0400
Date: Wed, 31 Oct 2012 14:53:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fabio Estevam <festevam@gmail.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, gcembed@gmail.com,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v4 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
In-Reply-To: <CAOMZO5CLxM41LYoLmPbfzSTF85Zk4B5SqHeVbGU4WjEOXw0eyg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1210311442310.12173@axis700.grange>
References: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
 <20121031095632.536d9362@infradead.org> <20121031131652.GM1641@pengutronix.de>
 <CAOMZO5CLxM41LYoLmPbfzSTF85Zk4B5SqHeVbGU4WjEOXw0eyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 31 Oct 2012, Fabio Estevam wrote:

> Hi Sascha,
> 
> On Wed, Oct 31, 2012 at 11:16 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > Quoting yourself:
> >
> >> Forgot to comment: as patch 2 relies on this change, the better, IMHO, is
> >> to send both via the same tree. If you decide to do so, please get arm
> >> maintainer's ack, instead, and we can merge both via my tree.
> >
> > That's why Fabio resent these patches with my Ack. You are free to take
> > these.
> 
> I have just realized that this patch (1/2) will not apply against
> media tree because it does not have commit 27b76486a3 (media:
> mx2_camera: remove cpu_is_xxx by using platform_device_id), which
> changes from mx2_camera.0 to imx27-camera.0.

This is exactly the reason why I wasn't able to merge it. The problem was, 
that this "media: mx2_camera: remove cpu_is_xxx by using 
platform_device_id" patch non-trivially touched both arch/arm/ and 
drivers/media/ directories. And being patch 27/34 I didn't feel like 
asking the author to redo it again:-) This confirms, that it's better to 
avoid such overlapping patches whenever possible.

> So it seems to be better to merge this via arm tree to avoid such conflict.

Thanks
Guennadi

> Regards,
> 
> Fabio Estevam

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
