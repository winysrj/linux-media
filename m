Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:40734 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064Ab0GOLWy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 07:22:54 -0400
Date: Thu, 15 Jul 2010 14:22:34 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv6] mx2_camera: Add soc_camera support for i.MX25/i.MX27
Message-ID: <20100715112234.GC7690@jasper.tkos.co.il>
References: <40ccd21d0e857660038d193af3bb4cc6edd1067d.1278218817.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40ccd21d0e857660038d193af3bb4cc6edd1067d.1278218817.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Jul 04, 2010 at 07:55:10AM +0300, Baruch Siach wrote:
> This is the soc_camera support developed by Sascha Hauer for the i.MX27.  Alan
> Carvalho de Assis modified the original driver to get it working on more recent
> kernels. I modified it further to add support for i.MX25. This driver has been
> tested on i.MX25 and i.MX27 based platforms.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---

Ping?

I'm currently working on a series of some small fixes and tweaks, but first I 
want to see the main code getting into mainline.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
