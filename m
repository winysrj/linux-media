Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60313 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbbEYRFv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 13:05:51 -0400
Date: Mon, 25 May 2015 19:05:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] media: atmel-isi: remove the useless code which
 disable isi
In-Reply-To: <55516CB5.5020601@atmel.com>
Message-ID: <Pine.LNX.4.64.1505251904450.26358@axis700.grange>
References: <1428570108-4961-1-git-send-email-josh.wu@atmel.com>
 <1428570108-4961-2-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1505112147540.12198@axis700.grange> <55516CB5.5020601@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Tue, 12 May 2015, Josh Wu wrote:

> Hi, Guennadi
> 
> On 5/12/2015 4:16 AM, Guennadi Liakhovetski wrote:
> > Hi Josh,
> > 
> > Thanks for the patch. I'm afraid I don't quite understand why it is
> > needed, could you maybe explain a bit more? Is it because
> > 
> > (1) during ISI configuration the pixel clock from the sensor is (usually)
> > anyway disabled, so, we don't have to additionally disable the ISI,
> > without the pixel clock the ISI is anyway already disabled.
> > 
> > or
> > 
> > (2) disabling the ISI at those locations below breaks something, because
> > when the ISI is disabled, the functionality, that's later used isn't
> > available.
> > 
> > I assume it's (1), but if that's the case, then this patch is just
> > cosmetic, right?
> Right, it is (1). This patch doesn't impact the function of isi.
> 
> The point is when we disable the ISI, we need make sure ISI peripheral clock
> and pixel clock is enabled. And also need to check the status register or irq
> to know whether the disable operation is successful. So best way to disable
> ISI is to call atmel_isi_wait_status(isi, WAIT_ISI_DISABLE).
> 
> From this point, the isi_write(isi, ISI_CTRL, ISI_CTRL_DIS) in
> atmel_isi_probe() is not useful as ISI peripheral clock is not enable yet.
> but the other two in configure_geometry(), isi_camera_set_bus_param() can work
> and may protect the case the ISI is not in off state.

Ok, thanks for the explanation.

> 
> > The ISI is anyway disabled, so, that operation simply has
> > no effect, but also doesn't hurt. OTOH, if some sensor keeps its master
> > clock running all the time, then switching the ISI off as in the current
> > version helps save some power, unless it breaks anything?
> So what about to keep the isi_write(isi, ISI_CTRL, ISI_CTRL_DIS) in
> configure_geometry() and isi_camera_set_bus_param().
> Only remove it from atmel_isi_probe()?

Good, let's do that.

Thanks
Guennadi

> 
> Best Regards,
> Josh Wu
> 
> > 
> > Thanks
> > Guennadi
> > 
> > On Thu, 9 Apr 2015, Josh Wu wrote:
> > 
> > > To program ISI control register, the pixel clock should be enabled.
> > > So without pixel clock (from sensor) enabled, disable ISI controller is
> > > not make sense. So this patch remove those code.
> > > 
> > > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > > ---
> > > 
> > > Changes in v2:
> > > - this file is new added.
> > > 
> > >   drivers/media/platform/soc_camera/atmel-isi.c | 5 -----
> > >   1 file changed, 5 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> > > b/drivers/media/platform/soc_camera/atmel-isi.c
> > > index c125b1d..31254b4 100644
> > > --- a/drivers/media/platform/soc_camera/atmel-isi.c
> > > +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> > > @@ -131,8 +131,6 @@ static int configure_geometry(struct atmel_isi *isi,
> > > u32 width,
> > >   		return -EINVAL;
> > >   	}
> > >   -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> > > -
> > >   	cfg2 = isi_readl(isi, ISI_CFG2);
> > >   	/* Set YCC swap mode */
> > >   	cfg2 &= ~ISI_CFG2_YCC_SWAP_MODE_MASK;
> > > @@ -843,7 +841,6 @@ static int isi_camera_set_bus_param(struct
> > > soc_camera_device *icd)
> > >     	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
> > >   -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> > >   	isi_writel(isi, ISI_CFG1, cfg1);
> > >     	return 0;
> > > @@ -1022,8 +1019,6 @@ static int atmel_isi_probe(struct platform_device
> > > *pdev)
> > >   	if (isi->pdata.data_width_flags & ISI_DATAWIDTH_10)
> > >   		isi->width_flags |= 1 << 9;
> > >   -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> > > -
> > >   	irq = platform_get_irq(pdev, 0);
> > >   	if (IS_ERR_VALUE(irq)) {
> > >   		ret = irq;
> > > -- 
> > > 1.9.1
> > > 
> 
