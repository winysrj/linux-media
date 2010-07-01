Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:55964 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab0GAFAW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jul 2010 01:00:22 -0400
Date: Thu, 1 Jul 2010 08:00:03 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv4 1/3] mx2_camera: Add soc_camera support for
 i.MX25/i.MX27
Message-ID: <20100701050002.GB16981@jasper.tkos.co.il>
References: <cover.1277096909.git.baruch@tkos.co.il>
 <03d6e55c39690618e92a91a580ec34549a135c79.1277096909.git.baruch@tkos.co.il>
 <20100630070717.GA11746@pengutronix.de>
 <Pine.LNX.4.64.1006300918190.17489@axis700.grange>
 <20100630072808.GD11746@pengutronix.de>
 <Pine.LNX.4.64.1006301058170.17489@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006301058170.17489@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Jun 30, 2010 at 11:08:41AM +0200, Guennadi Liakhovetski wrote:

[snip]

> In any case, I'm fine with the patch as it is, so, here's
> 
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks for your thorough review and ack.

> I think, it would be better if you, Uwe, or Sascha pull all these 3 patches 
> via one of your tree, because patches 2/3 and 3/3 are ARM/MX2 stuff anyway 
> and this patch changes some files under arch/arm and collides with some mx2 
> changes.

Patches 2/3 and 3/3 are already in the imx-for-2.6.36 branch.

baruch

> Mauro, do you agree? Do we need your ack too? So, taking them all 
> via IMX/MXC would make synchronisation easier. However, if you change 
> anything under drivers/media (including Makefile / Kconfig) or 
> include/media, please let me know, so that I can ack it again.

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
