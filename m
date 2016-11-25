Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38130 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750696AbcKYAnf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 19:43:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Fri, 25 Nov 2016 02:43:50 +0200
Message-ID: <2929151.g7xCm3YOsX@avalon>
In-Reply-To: <3671263.RFBLxrVu2U@wuerfel>
References: <1479477016-28450-1-git-send-email-sakari.ailus@linux.intel.com> <1883244.ZIXkBXos04@avalon> <3671263.RFBLxrVu2U@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

(CC'ing the linux-pm mailing list)

On Tuesday 22 Nov 2016 21:58:32 Arnd Bergmann wrote:
> On Tuesday, November 22, 2016 8:31:42 PM CET Laurent Pinchart wrote:
> >>> @@ -2915,7 +2906,11 @@ static int smiapp_probe(struct i2c_client
> >>> *client,
> >>> 
> >>>     pm_runtime_enable(&client->dev);
> >>> 
> >>> +#ifdef CONFIG_PM
> >>>     rval = pm_runtime_get_sync(&client->dev);
> >>> +#else
> >>> +   rval = smiapp_power_on(&client->dev);
> >>> +#endif
> >>>     if (rval < 0) {
> >>>             rval = -ENODEV;
> >>>             goto out_power_off;
> >> 
> >> I would suggest writing this as
> >> 
> >>       if (IS_ENABLED(CONFIG_PM))
> >>               rval = pm_runtime_get_sync(&client->dev);
> >>       else
> >>               rval = smiapp_power_on(&client->dev);
> >> 
> >> though that is a purely cosmetic change.
> > 
> > Are all drivers really supposed to code this kind of construct ? Shouldn't
> > this be handled in the PM core ? A very naive approach would be to call
> > .runtime_resume() and .runtime_suspend() from the non-CONFIG_PM versions
> > of pm_runtime_enable() and pm_runtime_disable() respectively. I assume
> > that would break things, but can't we implement something similar to that
> > that wouldn't require all drivers to open-code it ?
> 
> I know nothing about the details of how the suspend/resume code should
> do this, I was just commenting on the syntax above, preferring an
> IS_ENABLED() check over an #ifdef.

Dear linux-pm developers, what's the suggested way to ensure that a runtime-
pm-enabled driver can run fine on a system with CONFIG_PM disabled ?

-- 
Regards,

Laurent Pinchart

