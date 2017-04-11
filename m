Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51705 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752805AbdDKP0m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 11:26:42 -0400
Date: Tue, 11 Apr 2017 16:26:40 +0100
From: Sean Young <sean@mess.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Kevin Hilman <khilman@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] media: rc: meson-ir: remove irq from struct meson_ir
Message-ID: <20170411152640.GA19451@gofer.mess.org>
References: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
 <b550b154-400e-2aea-b863-c217bcb730ad@gmail.com>
 <0ef141e3-0eec-fb2f-c575-e236c5dfc9ae@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ef141e3-0eec-fb2f-c575-e236c5dfc9ae@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 11, 2017 at 11:50:45AM +0200, Neil Armstrong wrote:
> On 04/11/2017 07:53 AM, Heiner Kallweit wrote:
> > The irq number is used in the probe function only, therefore just use
> > a local variable.
> > 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > ---
> >  drivers/media/rc/meson-ir.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
> > index 5576dbd6..a4128d7c 100644
> > --- a/drivers/media/rc/meson-ir.c
> > +++ b/drivers/media/rc/meson-ir.c
> > @@ -68,7 +68,6 @@
> >  struct meson_ir {
> >  	void __iomem	*reg;
> >  	struct rc_dev	*rc;
> > -	int		irq;
> >  	spinlock_t	lock;
> >  };
> >  
> > @@ -112,7 +111,7 @@ static int meson_ir_probe(struct platform_device *pdev)
> >  	struct resource *res;
> >  	const char *map_name;
> >  	struct meson_ir *ir;
> > -	int ret;
> > +	int irq, ret;
> >  
> >  	ir = devm_kzalloc(dev, sizeof(struct meson_ir), GFP_KERNEL);
> >  	if (!ir)
> > @@ -125,10 +124,10 @@ static int meson_ir_probe(struct platform_device *pdev)
> >  		return PTR_ERR(ir->reg);
> >  	}
> >  
> > -	ir->irq = platform_get_irq(pdev, 0);
> > -	if (ir->irq < 0) {
> > +	irq = platform_get_irq(pdev, 0);
> > +	if (irq < 0) {
> >  		dev_err(dev, "no irq resource\n");
> > -		return ir->irq;
> > +		return irq;
> >  	}
> >  
> >  	ir->rc = rc_allocate_device(RC_DRIVER_IR_RAW);
> > @@ -158,7 +157,7 @@ static int meson_ir_probe(struct platform_device *pdev)
> >  		goto out_free;
> >  	}
> >  
> > -	ret = devm_request_irq(dev, ir->irq, meson_ir_irq, 0, "ir-meson", ir);
> > +	ret = devm_request_irq(dev, irq, meson_ir_irq, 0, "ir-meson", ir);
> >  	if (ret) {
> >  		dev_err(dev, "failed to request irq\n");
> >  		goto out_unreg;
> > 
> 
> Hi Heiner,
> 
> I'm not really convinced this is useful, if somehow for future enhancements we need the IRQ
> number, this will need to be reverted...

It's bad form having unused members in a struct, and if it really is needed
in some future enhancement, it is easily reintroduced in that future
enhancement patch.


Sean
