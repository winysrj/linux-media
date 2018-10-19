Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54117 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbeJSTH4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 15:07:56 -0400
Message-ID: <1539946939.3688.58.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] media: mst3367: add support for mstar mst3367 HDMI
 RX
From: Lucas Stach <l.stach@pengutronix.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stoth@kernellabs.com,
        laurent.pinchart@ideasonboard.com, kernel@pengutronix.de,
        mchehab@kernel.org, davem@davemloft.net
Date: Fri, 19 Oct 2018 13:02:19 +0200
In-Reply-To: <20181019105439.27796-2-m.grzeschik@pengutronix.de>
References: <20181019105439.27796-1-m.grzeschik@pengutronix.de>
         <20181019105439.27796-2-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 19.10.2018, 12:54 +0200 schrieb Michael Grzeschik:
> > From: Steven Toth <stoth@kernellabs.com>
> 
> This patch is based on the work of Steven Toth. He reverse engineered
> the driver by tracing the windows driver.
> 
> https://github.com/stoth68000/hdcapm/
> 
> > Signed-off-by: Steven Toth <stoth@kernellabs.com>
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  MAINTAINERS                 |    6 +
>  drivers/media/i2c/Kconfig   |   10 +
>  drivers/media/i2c/Makefile  |    1 +
>  drivers/media/i2c/mst3367.c | 1104 +++++++++++++++++++++++++++++++++++
>  include/media/i2c/mst3367.h |   29 +
>  5 files changed, 1150 insertions(+)
>  create mode 100644 drivers/media/i2c/mst3367.c
>  create mode 100644 include/media/i2c/mst3367.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 556f902b3766..9c69b7f9b2f9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9787,6 +9787,12 @@ L:	linux-mtd@lists.infradead.org
> >  S:	Maintained
> >  F:	drivers/mtd/devices/docg3*
>  
> +MT9M032 APTINA SENSOR DRIVER
> > > +M:	Michael Grzeschik <m.grzeschik@pengutronix.de>
> > +S:	Maintained
> > +F:	drivers/media/i2c/mst3367.c
> > +F:	include/media/i2c/mst3367.h

Das sollte nicht in diesem Patch landen, oder?

Gruß
Lucas
