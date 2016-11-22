Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48117 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932657AbcKVScw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 13:32:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Tue, 22 Nov 2016 20:31:42 +0200
Message-ID: <1883244.ZIXkBXos04@avalon>
In-Reply-To: <3365592.8lQdWk1zFY@wuerfel>
References: <1479477016-28450-1-git-send-email-sakari.ailus@linux.intel.com> <3365592.8lQdWk1zFY@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Friday 18 Nov 2016 17:09:01 Arnd Bergmann wrote:
> On Friday, November 18, 2016 3:50:16 PM CET Sakari Ailus wrote:
> > Power on the sensor when the module is loaded and power it off when it is
> > removed.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Hi Arnd and others,
> > 
> > The patch is tested with CONFIG_PM set, as the system does I was testing
> > on did not boot with CONFIG_PM disabled. I'm not really too worried about
> > this though, the patch is very simple.
> > 
> >  static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
> >  {
> >  	struct smiapp_hwconfig *hwcfg;
> > @@ -2915,7 +2906,11 @@ static int smiapp_probe(struct i2c_client *client,
> > 
> >  	pm_runtime_enable(&client->dev);
> > 
> > +#ifdef CONFIG_PM
> >  	rval = pm_runtime_get_sync(&client->dev);
> > +#else
> > +	rval = smiapp_power_on(&client->dev);
> > +#endif
> > 
> >  	if (rval < 0) {
> >  		rval = -ENODEV;
> >  		goto out_power_off;
> 
> I would suggest writing this as
> 
> 	if (IS_ENABLED(CONFIG_PM))
> 		rval = pm_runtime_get_sync(&client->dev);
> 	else
> 		rval = smiapp_power_on(&client->dev);
> 
> though that is a purely cosmetic change.

Are all drivers really supposed to code this kind of construct ? Shouldn't 
this be handled in the PM core ? A very naive approach would be to call 
.runtime_resume() and .runtime_suspend() from the non-CONFIG_PM versions of 
pm_runtime_enable() and pm_runtime_disable() respectively. I assume that would 
break things, but can't we implement something similar to that that wouldn't 
require all drivers to open-code it ?

> I think you are missing one other warning: with CONFIG_PM=y and
> CONFIG_PM_SLEEP=n, the smiapp_suspend/smiapp_resume functions
> are now unused and need to be marked as __maybe_unused.

-- 
Regards,

Laurent Pinchart

