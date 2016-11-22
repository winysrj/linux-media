Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:64772 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756962AbcKVU6j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 15:58:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Tue, 22 Nov 2016 21:58:32 +0100
Message-ID: <3671263.RFBLxrVu2U@wuerfel>
In-Reply-To: <1883244.ZIXkBXos04@avalon>
References: <1479477016-28450-1-git-send-email-sakari.ailus@linux.intel.com> <3365592.8lQdWk1zFY@wuerfel> <1883244.ZIXkBXos04@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, November 22, 2016 8:31:42 PM CET Laurent Pinchart wrote:
> > > @@ -2915,7 +2906,11 @@ static int smiapp_probe(struct i2c_client *client,
> > > 
> > >     pm_runtime_enable(&client->dev);
> > > 
> > > +#ifdef CONFIG_PM
> > >     rval = pm_runtime_get_sync(&client->dev);
> > > +#else
> > > +   rval = smiapp_power_on(&client->dev);
> > > +#endif
> > > 
> > >     if (rval < 0) {
> > >             rval = -ENODEV;
> > >             goto out_power_off;
> > 
> > I would suggest writing this as
> > 
> >       if (IS_ENABLED(CONFIG_PM))
> >               rval = pm_runtime_get_sync(&client->dev);
> >       else
> >               rval = smiapp_power_on(&client->dev);
> > 
> > though that is a purely cosmetic change.
> 
> Are all drivers really supposed to code this kind of construct ? Shouldn't 
> this be handled in the PM core ? A very naive approach would be to call 
> .runtime_resume() and .runtime_suspend() from the non-CONFIG_PM versions of 
> pm_runtime_enable() and pm_runtime_disable() respectively. I assume that would 
> break things, but can't we implement something similar to that that wouldn't 
> require all drivers to open-code it ?

I know nothing about the details of how the suspend/resume code should
do this, I was just commenting on the syntax above, preferring an
IS_ENABLED() check over an #ifdef.

	Arnd
