Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52158 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbbDHOk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 10:40:59 -0400
Date: Wed, 8 Apr 2015 11:40:49 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sifan Naeem <Sifan.Naeem@imgtec.com>
Cc: James Hogan <James.Hogan@imgtec.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] rc: img-ir: Add and enable sys clock for IR
Message-ID: <20150408114049.6470c5c0@recife.lan>
In-Reply-To: <A0E307549471DA4DBAF2DE2DE6CBFB7E495D1CED@hhmail02.hh.imgtec.org>
References: <1422984629-13313-1-git-send-email-sifan.naeem@imgtec.com>
	<20150408083217.5e1dee7a@recife.lan>
	<A0E307549471DA4DBAF2DE2DE6CBFB7E495D1CED@hhmail02.hh.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Apr 2015 13:56:14 +0000
Sifan Naeem <Sifan.Naeem@imgtec.com> escreveu:

> Hi Mauro,
> 
> I sent you a v2 of this patch on 4th February:
> 
> From: Sifan Naeem 
> Sent: 04 February 2015 16:48
> To: James Hogan; mchehab@osg.samsung.com
> Cc: linux-kernel@vger.kernel.org; linux-media@vger.kernel.org; Sifan Naeem
> Subject: [PATCH v2] rc: img-ir: Add and enable sys clock for img-ir
> 
> 
> Unfortunately, while trying to improve the commit message in v2 I had changed the last word of the patch name from IR to img-ir.
> 
> Do you want me to do a diff between the 2 patches and send you a new patch?

Yes, please do that, changing the patch name/description to reflect
what changed since v1.

Regards,
Mauro

> 
> Sifan
> 
> > -----Original Message-----
> > From: Mauro Carvalho Chehab [mailto:mchehab@osg.samsung.com]
> > Sent: 08 April 2015 12:32
> > To: Sifan Naeem
> > Cc: James Hogan; linux-kernel@vger.kernel.org; linux-
> > media@vger.kernel.org
> > Subject: Re: [PATCH] rc: img-ir: Add and enable sys clock for IR
> > 
> > Em Tue, 3 Feb 2015 17:30:29 +0000
> > Sifan Naeem <sifan.naeem@imgtec.com> escreveu:
> > 
> > > Gets a handle to the system clock, already described in the binding
> > > document, and calls the appropriate common clock framework functions
> > > to mark it prepared/enabled, the common clock framework initially
> > > enables the clock and doesn't disable it at least until the
> > > device/driver is removed.
> > > The system clock to IR is needed for the driver to communicate with
> > > the IR hardware via MMIO accesses on the system bus, so it must not be
> > > disabled during use or the driver will malfunction.
> > 
> > Hmm... patchwork has two versions of this patch, but I have only one on my
> > e-mail.
> > 
> > Could you please check if I applied the right one? If not, please send me an
> > email with a fixup patch.
> > 
> > Thanks!
> > Mauro
> > 
> > >
> > > Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
> > > ---
> > >  drivers/media/rc/img-ir/img-ir-core.c |   13 +++++++++----
> > >  drivers/media/rc/img-ir/img-ir.h      |    2 ++
> > >  2 files changed, 11 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/media/rc/img-ir/img-ir-core.c
> > > b/drivers/media/rc/img-ir/img-ir-core.c
> > > index 77c78de..783dd21 100644
> > > --- a/drivers/media/rc/img-ir/img-ir-core.c
> > > +++ b/drivers/media/rc/img-ir/img-ir-core.c
> > > @@ -60,6 +60,8 @@ static void img_ir_setup(struct img_ir_priv *priv)
> > >
> > >  	if (!IS_ERR(priv->clk))
> > >  		clk_prepare_enable(priv->clk);
> > > +	if (!IS_ERR(priv->sys_clk))
> > > +		clk_prepare_enable(priv->sys_clk);
> > >  }
> > >
> > >  static void img_ir_ident(struct img_ir_priv *priv) @@ -110,10 +112,11
> > > @@ static int img_ir_probe(struct platform_device *pdev)
> > >  	priv->clk = devm_clk_get(&pdev->dev, "core");
> > >  	if (IS_ERR(priv->clk))
> > >  		dev_warn(&pdev->dev, "cannot get core clock resource\n");
> > > -	/*
> > > -	 * The driver doesn't need to know about the system ("sys") or
> > power
> > > -	 * modulation ("mod") clocks yet
> > > -	 */
> > > +
> > > +	/* Get sys clock */
> > > +	priv->sys_clk = devm_clk_get(&pdev->dev, "sys");
> > > +	if (IS_ERR(priv->sys_clk))
> > > +		dev_warn(&pdev->dev, "cannot get sys clock resource\n");
> > >
> > >  	/* Set up raw & hw decoder */
> > >  	error = img_ir_probe_raw(priv);
> > > @@ -152,6 +155,8 @@ static int img_ir_remove(struct platform_device
> > > *pdev)
> > >
> > >  	if (!IS_ERR(priv->clk))
> > >  		clk_disable_unprepare(priv->clk);
> > > +	if (!IS_ERR(priv->sys_clk))
> > > +		clk_disable_unprepare(priv->sys_clk);
> > >  	return 0;
> > >  }
> > >
> > > diff --git a/drivers/media/rc/img-ir/img-ir.h
> > > b/drivers/media/rc/img-ir/img-ir.h
> > > index 2ddf560..f1387c0 100644
> > > --- a/drivers/media/rc/img-ir/img-ir.h
> > > +++ b/drivers/media/rc/img-ir/img-ir.h
> > > @@ -138,6 +138,7 @@ struct clk;
> > >   * @dev:		Platform device.
> > >   * @irq:		IRQ number.
> > >   * @clk:		Input clock.
> > > + * @sys_clk:		System clock.
> > >   * @reg_base:		Iomem base address of IR register block.
> > >   * @lock:		Protects IR registers and variables in this struct.
> > >   * @raw:		Driver data for raw decoder.
> > > @@ -147,6 +148,7 @@ struct img_ir_priv {
> > >  	struct device		*dev;
> > >  	int			irq;
> > >  	struct clk		*clk;
> > > +	struct clk		*sys_clk;
> > >  	void __iomem		*reg_base;
> > >  	spinlock_t		lock;
> > >
