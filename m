Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58163 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbDPF6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 01:58:21 -0400
Date: Thu, 16 Apr 2015 07:58:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 1/1] media: i2c/adp1653: Devicetree support for adp1653
Message-ID: <20150416055817.GA2749@amd>
References: <1429141034-29237-1-git-send-email-sakari.ailus@iki.fi>
 <20150416052442.GA31095@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150416052442.GA31095@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 2015-04-16 07:24:42, Sebastian Reichel wrote:
> Hi Sakari,
> 
> Since this driver won't make it into 4.1 anyways, I have one more
> comment:

Like this driver did not receive enough bikesheding.

> > +	} else {
> > +		gpiod_set_value(flash->platform_data->enable_gpio, on);
> > +		if (on)
> > +			/* Some delay is apparently required. */
> > +			udelay(20);
> > +	}
> 
> I suggest to remove the power callback from platform data. Instead
> you can require to setup a gpiod lookup table in the boardcode, if
> platform data based initialization is used (see for example si4713
> initialization in board-rx51-periphals.c).
> 
> This will reduce complexity in the driver and should be fairly easy
> to implement, since there is no adp1653 platform code user in the
> mainline kernel anyways.

I'd hate to break out of tree users for very little gain.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
