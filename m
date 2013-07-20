Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback5.mail.ru ([94.100.176.59]:51127 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3GTFr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jul 2013 01:47:26 -0400
Received: from smtp30.i.mail.ru (smtp30.i.mail.ru [94.100.177.90])
	by fallback5.mail.ru (mPOP.Fallback_MX) with ESMTP id 2C7CFEE819A0
	for <linux-media@vger.kernel.org>; Sat, 20 Jul 2013 09:47:23 +0400 (MSK)
Date: Sat, 20 Jul 2013 09:46:33 +0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND] media: coda: Fix DT-driver data pointer for
 i.MX27
Message-Id: <20130720094633.d18f5915dab9587598d8782a@mail.ru>
In-Reply-To: <1371799814.4320.3.camel@pizza.hi.pengutronix.de>
References: <1371746796-16123-1-git-send-email-shc_work@mail.ru>
	<1371799814.4320.3.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 21 Jun 2013 09:30:14 +0200
Philipp Zabel <p.zabel@pengutronix.de> wrote:

> Am Donnerstag, den 20.06.2013, 20:46 +0400 schrieb Alexander Shiyan:
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/media/platform/coda.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index 48b8d7a..1c77781 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -1924,7 +1924,7 @@ MODULE_DEVICE_TABLE(platform, coda_platform_ids);
> >  
> >  #ifdef CONFIG_OF
> >  static const struct of_device_id coda_dt_ids[] = {
> > -	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
> > +	{ .compatible = "fsl,imx27-vpu", .data = &coda_devdata[CODA_IMX27] },
> >  	{ .compatible = "fsl,imx53-vpu", .data = &coda_devdata[CODA_IMX53] },
> >  	{ /* sentinel */ }
> >  };
> 
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

Ping.

-- 
Alexander Shiyan <shc_work@mail.ru>
