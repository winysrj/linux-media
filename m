Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38704 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388297AbeGXOaV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 10:30:21 -0400
Date: Tue, 24 Jul 2018 16:23:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/2] media: i2c: Add driver for Aptina MT9V111
Message-ID: <20180724132351.dvxgbd6o6ch2nium@valkosipuli.retiisi.org.uk>
References: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528730253-25135-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180723142835.xl6qrj35lcv2e3vg@valkosipuli.retiisi.org.uk>
 <20180724130845.GM6784@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180724130845.GM6784@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Tue, Jul 24, 2018 at 03:08:45PM +0200, jacopo mondi wrote:
> > > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > > index 341452f..0bd867d 100644
> > > --- a/drivers/media/i2c/Kconfig
> > > +++ b/drivers/media/i2c/Kconfig
> > > @@ -841,6 +841,18 @@ config VIDEO_MT9V032
> > >  	  This is a Video4Linux2 sensor-level driver for the Micron
> > >  	  MT9V032 752x480 CMOS sensor.
> > >
> > > +config VIDEO_MT9V111
> > > +	tristate "Aptina MT9V111 sensor support"
> > > +	depends on I2C && VIDEO_V4L2
> > > +	depends on MEDIA_CAMERA_SUPPORT
> > > +	depends on OF
> >
> > Why OF? I see no effective OF dependencies in the driver.
> >
> 
> Isn't the driver probing through OF?

It may, but the driver is otherwise not technically limited to OF. ACPI
could be used as well, for instance.

> 
> > > +	help
> > > +	  This is a Video4Linux2 sensor-level driver for the Aptina/Micron
> 
> I'll change sensor-level to sensor, has you've been doing lately on
> all other Kconfig entries

Ack.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
