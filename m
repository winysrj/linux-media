Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9455 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753044AbdFPMpa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 08:45:30 -0400
Date: Fri, 16 Jun 2017 15:45:26 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 7/8] smiapp: Add support for flash, lens and EEPROM
 devices
Message-ID: <20170616124526.GM15419@paasikivi.fi.intel.com>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
 <20170616124242.GA8145@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616124242.GA8145@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Fri, Jun 16, 2017 at 02:42:42PM +0200, Pavel Machek wrote:
> Hi!
> 
> > These types devices aren't directly related to the sensor, but are
> > nevertheless handled by the smiapp driver due to the relationship of these
> > component to the main part of the camera module --- the sensor.
> > 
> > Additionally, for the async sub-device registration to work, the notifier
> > containing matching fwnodes will need to be registered. This is natural to
> > perform in a sensor driver as well.
> > 
> > This does not yet address providing the user space with information on how
> > to associate the sensor, lens or EEPROM devices but the kernel now has the
> > necessary information to do that.
> 
> Do I understand it correctly that basically every sensor driver (in my
> case et8ek8) needs to get this kind of support? I2c leds are cheap,
> and may be asociated with pretty much any sensor, AFAICT.

That's right.

> 
> This is quite a lot of boilerplate for that. Would it make sense to
> provide helper function at least for this?

Yes. I've been thinking of having helper functions for notifiers and
sub-notifiers. Most of the receiver drivers are implementing exactly the
same thing but with different twists (read: bugs).

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
