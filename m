Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:49084 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1H1Snf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 14:43:35 -0400
Date: Sun, 28 Aug 2011 21:43:06 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] media i.MX27 camera: remove legacy dma support
Message-ID: <20110828184306.GA9157@tarshish>
References: <1314167073-11058-1-git-send-email-s.hauer@pengutronix.de>
 <Pine.LNX.4.64.1108240843001.8985@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108240843001.8985@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Aug 24, 2011 at 09:19:24AM +0200, Guennadi Liakhovetski wrote:
[snip]
> On Wed, 24 Aug 2011, Sascha Hauer wrote:
> > The i.MX27 dma support was introduced with the initial commit of
> > this driver and originally created by me. However, I never got
> > this stable due to the racy dma engine and used the EMMA engine
> > instead. As the DMA support is most probably unused and broken in
> > its current state, remove it. This also helps us to get rid of
> > another user of the legacy i.MX DMA support,
> > Also, remove the dependency on ARCH_MX* macros as these are scheduled
> > for removal.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Baruch Siach <baruch@tkos.co.il>
> > Cc: linux-media@vger.kernel.org
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---

[snip]

> Baruch, any comment?

No comment so far. Thanks for your continued maintenance. I wish I could do 
the videobuf2 migration of this driver.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
