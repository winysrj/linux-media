Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22399 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753130AbdFPM0d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 08:26:33 -0400
Date: Fri, 16 Jun 2017 15:26:29 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 7/8] smiapp: Add support for flash, lens and EEPROM
 devices
Message-ID: <20170616122629.GL15419@paasikivi.fi.intel.com>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
 <20170616120712.GA5774@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170616120712.GA5774@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Fri, Jun 16, 2017 at 02:07:13PM +0200, Pavel Machek wrote:
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
> Let me see... I guess this is going to be quite interesting for me,
> too, because I'll be able to remove similar code in omap3 isp driver.

Yes, indeed. And with this, we have the lens - sensor association
information as a bonus.

I'll drop EEPROM support in v2, I guess you wouldn't have needed it? I guess
we'll need to see examples that can be found in the wild. My current
understanding is that EEPROM could be a separate chip in the module as well
as integrated to the sensor.

SMIA++ supports EEPROM as well (it's accessible through the sensor) but not
all (more or less) compliant sensors implement it (instead it's a separate
I²C device).

> 
> I'm getting same error as the build bot... which is expected as you
> did mention it depends on some other series.

Yes, I missed half of the change. I'm pushing it again now... this will take
time until my server has SSDs.

> 
> (I'll take a look if I can test it easily.)
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
