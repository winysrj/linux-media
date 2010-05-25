Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:45220 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab0EYNVw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 09:21:52 -0400
Date: Tue, 25 May 2010 16:20:49 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] mx2_camera: Add soc_camera support for
 i.MX25/i.MX27
Message-ID: <20100525132049.GE27702@jasper.tkos.co.il>
References: <cover.1274706733.git.baruch@tkos.co.il>
 <4c15903511a5c4e6997b190d321b6fdf15bb6579.1274706733.git.baruch@tkos.co.il>
 <20100525131624.GM17272@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525131624.GM17272@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Tue, May 25, 2010 at 03:16:24PM +0200, Sascha Hauer wrote:
> On Mon, May 24, 2010 at 04:20:39PM +0300, Baruch Siach wrote:
> > This is the soc_camera support developed by Sascha Hauer for the i.MX27.  Alan
> > Carvalho de Assis modified the original driver to get it working on more recent
> > kernels. I modified it further to add support for i.MX25. This driver has been
> > tested on i.MX25 and i.MX27 based platforms.
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  arch/arm/plat-mxc/include/mach/memory.h  |    4 +-
> >  arch/arm/plat-mxc/include/mach/mx2_cam.h |   46 +
> >  drivers/media/video/Kconfig              |   13 +
> >  drivers/media/video/Makefile             |    1 +
> >  drivers/media/video/mx2_camera.c         | 1471 ++++++++++++++++++++++++++++++
> >  5 files changed, 1533 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/include/mach/mx2_cam.h
> >  create mode 100644 drivers/media/video/mx2_camera.c
> > 
> 
> [snip]
> 
> > +
> > +static int mclk_get_divisor(struct mx2_camera_dev *pcdev)
> > +{
> > +	dev_info(pcdev->dev, "%s not implemented. Running at max speed\n",
> > +			__func__);
> > +
> > +#if 0
> > +	unsigned int mclk = pcdev->pdata->clk_csi;
> > +	unsigned int pclk = clk_get_rate(pcdev->clk_csi);
> > +	int i;
> > +
> > +	dev_dbg(pcdev->dev, "%s: %ld %ld\n", __func__, mclk, pclk);
> > +
> > +	for (i = 0; i < 0xf; i++)
> > +		if ((i + 1) * 2 * mclk <= pclk)
> > +			break;
> > +	return i;
> > +#endif
> > +	return 0;
> > +}
> 
> This function, if implemented properly, can be used to add an additional
> divider for the sensors master clock. On i.MX27 we can adjust the master
> clock using the clk_set_rate below which is sufficient, so you can
> remove this function completely.

Very good. I'll do this in the next version of this driver.

I guess I can also remove the mclk_get_divisor call at mx2_camera_add_device 
and just leave:

csicr1 = CSICR1_MCLKEN;

Right?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
