Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:50896 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728973AbeKEWcJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 17:32:09 -0500
Message-ID: <272b2d009e056f36bfb08206772eb40bcdff00b0.camel@v3.sk>
Subject: Re: [PATCH] [media] ov7670: make "xclk" clock optional
From: Lubomir Rintel <lkundrak@v3.sk>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Mon, 05 Nov 2018 14:12:18 +0100
In-Reply-To: <20181105105841.GJ20885@w540>
References: <20181004212903.364064-1-lkundrak@v3.sk>
         <20181105105841.GJ20885@w540>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Mon, 2018-11-05 at 11:58 +0100, jacopo mondi wrote:
> Hi Lubomir,
>    +Sakari in Cc
> 
> I just noticed this, and the patch is now in v4.20, but let me comment
> anyway on this.
> 
> On Thu, Oct 04, 2018 at 11:29:03PM +0200, Lubomir Rintel wrote:
> > When the "xclk" clock was added, it was made mandatory. This broke the
> > driver on an OLPC plaform which doesn't know such clock. Make it
> > optional.
> > 
> 
> I don't think this is correct. The sensor needs a clock to work.
>
> With this patch clock_speed which is used to calculate
> the framerate is defaulted to 30MHz, crippling all the calculations if
> that default value doesn't match what is actually installed on the
> board.

How come? I kept this:

+             info->clock_speed = clk_get_rate(info->clk) / 1000000;

> 
> If this patch breaks the OLPC, then might it be the DTS for said
> device needs to be fixed instead of working around the issue here?

No. Device tree is an ABI, and you can't just add mandatory properties.

There's no DTS for OLPC XO-1 either; it's an OpenFirmware machine.
You'd need to update all machines in the wild which is not realistic.

Alternatively, something else than DT could provide the clock. If this
gets in, then the OLPC would work even without the xclk patch:
https://lore.kernel.org/lkml/20181105073054.24407-12-lkundrak@v3.sk/

(I just got a kbuild failure message, so I'll surely be following up
with a v2.)

> Also, the DT bindings should be updated too if we decide this property
> can be omitted. At this point, with a follow-up patch.

Yes.

> 
> Thanks

Cheers
Lubo

>    j
> 
> > Tested on a OLPC XO-1 laptop.
> > 
> > Cc: stable@vger.kernel.org # 4.11+
> > Fixes: 0a024d634cee ("[media] ov7670: get xclk")
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > ---
> >  drivers/media/i2c/ov7670.c | 27 +++++++++++++++++----------
> >  1 file changed, 17 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> > index 31bf577b0bd3..64d1402882c8 100644
> > --- a/drivers/media/i2c/ov7670.c
> > +++ b/drivers/media/i2c/ov7670.c
> > @@ -1808,17 +1808,24 @@ static int ov7670_probe(struct i2c_client *client,
> >  			info->pclk_hb_disable = true;
> >  	}
> > 
> > -	info->clk = devm_clk_get(&client->dev, "xclk");
> > -	if (IS_ERR(info->clk))
> > -		return PTR_ERR(info->clk);
> > -	ret = clk_prepare_enable(info->clk);
> > -	if (ret)
> > -		return ret;
> > +	info->clk = devm_clk_get(&client->dev, "xclk"); /* optional */
> > +	if (IS_ERR(info->clk)) {
> > +		ret = PTR_ERR(info->clk);
> > +		if (ret == -ENOENT)
> > +			info->clk = NULL;
> > +		else
> > +			return ret;
> > +	}
> > +	if (info->clk) {
> > +		ret = clk_prepare_enable(info->clk);
> > +		if (ret)
> > +			return ret;
> > 
> > -	info->clock_speed = clk_get_rate(info->clk) / 1000000;
> > -	if (info->clock_speed < 10 || info->clock_speed > 48) {
> > -		ret = -EINVAL;
> > -		goto clk_disable;
> > +		info->clock_speed = clk_get_rate(info->clk) / 1000000;
> > +		if (info->clock_speed < 10 || info->clock_speed > 48) {
> > +			ret = -EINVAL;
> > +			goto clk_disable;
> > +		}
> >  	}
> > 
> >  	ret = ov7670_init_gpio(client, info);
> > --
> > 2.19.0
> > 
