Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43000 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758337AbaDBPSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Apr 2014 11:18:32 -0400
Date: Wed, 2 Apr 2014 18:17:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Bryan Wu <cooloney@gmail.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	milo kim <milo.kim@ti.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	Richard Purdie <rpurdie@rpsys.net>, linux-media@vger.kernel.org
Subject: Re: brightness units
Message-ID: <20140402151754.GG4522@valkosipuli.retiisi.org.uk>
References: <533A6905.3010600@samsung.com>
 <CAK5ve-LNU_BGUB_HxsbgiO4baM-39C7PWHRVx0DL=JTYfJGSuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-LNU_BGUB_HxsbgiO4baM-39C7PWHRVx0DL=JTYfJGSuA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

On Tue, Apr 01, 2014 at 03:09:55PM -0700, Bryan Wu wrote:
> On Tue, Apr 1, 2014 at 12:21 AM, Jacek Anaszewski
> <j.anaszewski@samsung.com> wrote:
> > I am currently integrating LED subsystem and V4L2 Flash API.
> > V4L2 Flash API defines units of torch and flash intensity
> > in milliampers. In the LED subsystem documentation I can't
> > find any reference to the brightness units. On the other
> > hand there is led_brightness enum defined in the <linux/leds.h>
> > header, with LED_FULL = 255, but not all leds drivers use it.
> > I am aware that there are LEDs that can be only turned on/off
> > without any possibility to set the current and in such cases
> > LED_FULL doesn't reflect the current set.
> >
> 
> Actually led_brightness is an logic concept not like milliampers,
> since different led drivers has different implementation which is
> hardware related. Like PWM led driver, it will be converted to duty
> cycles.
> 
> For current control I do see some specific driver like LP55xx have it
> but not for every one.
> 
> > So far I've assumed that brightness is expressed in milliampers
> > and I don't stick to the LED_FULL limit. It allows for passing
> > flash/torch intensity from V4L2 controls to the leds API
> > without conversion. I am not sure if the units should be
> > fixed to milliampers in the LED subsystem or not. It would
> > clarify the situation, but if the existing LED drivers don't
> > stick to this unit then it would make a confusion.
> >
> 
> We probably need to convert those intensity to brightness numbers, for
> example mapping the intensity value to 0 ~ 255 brightness level and
> pass it to LED subsystem.

I think for some devices it wouldn't matter much, but on those that
generally are used as flash the current is known, and thus it should also be
visible in the interface. The conversion from mA to native units could be
done directly, or indirectly through the LED API.

There are a few things to consider though: besides minimum and maximum
values for the current, the V4L2 controls have a step parameter that would
still need to be passed to the control handler when creating the control.
That essentially tells the user space how many levels does the control have.

Care must be taken if converting to LED API units in between mA and native
units so that the values will get through unchanged. On the other hand, I
don't expect to get more levels than 256 either. But even this assumes that
the current selection would be linear.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
