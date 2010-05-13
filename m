Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:45411 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0EMFWM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 01:22:12 -0400
Date: Thu, 13 May 2010 08:21:05 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/3] mx2_camera: Add soc_camera support for
 i.MX25/i.MX27
Message-ID: <20100513052105.GA18678@jasper.tkos.co.il>
References: <cover.1273150585.git.baruch@tkos.co.il>
 <a029bab8fcb3273df4a1d98f779f110b127742bd.1273150585.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1005090045230.10524@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005090045230.10524@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
On Wed, May 12, 2010 at 09:02:29PM +0200, Guennadi Liakhovetski wrote:
> Thanks for eventually mainlining this driver! A couple of comments below.  
> Sascha, would be great, if you could get it tested on imx27 with and without 
> emma. BTW, if you say, that you use emma to avoid using the standard DMA 
> controller, why would anyone want not to use emma? Resource conflict? There 
> is also a question for you down in the comments, please, skim over.

Thank you very much for your detailed review and informative comments. I'll 
fix the problems that you've found, and post up updated patch after getting 
Sascha comments on the mx27 specific code.

baruch

> On Thu, 6 May 2010, Baruch Siach wrote:
> 
> > This is the soc_camera support developed by Sascha Hauer for the i.MX27.  Alan
> > Carvalho de Assis modified the original driver to get it working on more recent
> > kernels. I modified it further to add support for i.MX25. This driver has only
> > been tested on the i.MX25 platform.
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
