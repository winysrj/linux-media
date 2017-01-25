Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43284 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751639AbdAYNtG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 08:49:06 -0500
Date: Wed, 25 Jan 2017 15:48:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mark myself as mainainer for camera on N900
Message-ID: <20170125134831.GG7139@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161227092634.GK16630@valkosipuli.retiisi.org.uk>
 <20161227204558.GA23676@amd>
 <20161227205923.GA7859@amd>
 <20161227235721.xulzxdrwnb7feepn@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161227235721.xulzxdrwnb7feepn@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian and Pavel,

On Wed, Dec 28, 2016 at 12:57:21AM +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Tue, Dec 27, 2016 at 09:59:23PM +0100, Pavel Machek wrote:
> > Mark and Sakari as maintainers for Nokia N900 camera pieces.
> 
> ^^^ missing me after Mark. Otherwise Mark looks like a name :)
> 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > ---
> > 
> > Hi!
> > 
> > > Yeah, there was big flamewar about the permissions. In the end Linus
> > > decided that everyone knows the octal numbers, but the constants are
> > > tricky. It began with patch series with 1000 patches...
> > > 
> > > > Btw. should we update maintainers as well? Would you like to put yourself
> > > > there? Feel free to add me, too...
> > > 
> > > Ok, will do.
> > 
> > Something like this? Actually, I guess we could merge ADP1653 entry
> > there. Yes, it is random collection of devices, but are usually tested
> > "together", so I believe one entry makes sense.
> > 
> > (But I have no problem with having multiple entries, too.)
> > 
> > Thanks,
> > 								Pavel
> > 
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 63cefa6..1cb1d97 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8613,6 +8613,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2.git
> >  S:	Maintained
> >  F:	arch/nios2/
> >  
> > +NOKIA N900 CAMERA SUPPORT (ET8EK8 SENSOR, AD5820 FOCUS)
> > +M:	Pavel Machek <pavel@ucw.cz>
> > +M:	Sakari Ailus <sakari.ailus@iki.fi>
> > +L:	linux-media@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/media/i2c/et8ek8
> > +F:	drivers/media/i2c/ad5820.c
> 
> Not sure if this is useful information, but I solved it like this
> for N900 power supply drivers:
> 
> NOKIA N900 POWER SUPPLY DRIVERS
> R:	Pali Rohár <pali.rohar@gmail.com>
> F:	include/linux/power/bq2415x_charger.h
> F:	include/linux/power/bq27xxx_battery.h
> F:	include/linux/power/isp1704_charger.h
> F:	drivers/power/supply/bq2415x_charger.c
> F:	drivers/power/supply/bq27xxx_battery.c
> F:	drivers/power/supply/bq27xxx_battery_i2c.c
> F:	drivers/power/supply/isp1704_charger.c
> F:	drivers/power/supply/rx51_battery.c
> 
> TI BQ27XXX POWER SUPPLY DRIVER
> R:	Andrew F. Davis <afd@ti.com>
> F:	include/linux/power/bq27xxx_battery.h
> F:	drivers/power/supply/bq27xxx_battery.c
> F:	drivers/power/supply/bq27xxx_battery_i2c.c
> 
> POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
> M:	Sebastian Reichel <sre@kernel.org>
> L:	linux-pm@vger.kernel.org
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply.git
> S:	Maintained
> F:	Documentation/devicetree/bindings/power/supply/
> F:	include/linux/power_supply.h
> F:	drivers/power/supply/
> 
> This makes it quite easy to see who applies patches and who should
> be Cc'd for what reason:
> 
> $ ./scripts/get_maintainer.pl -f drivers/power/supply/bq27xxx_battery.c 
> "Pali Rohár" <pali.rohar@gmail.com> (reviewer:NOKIA N900 POWER SUPPLY DRIVERS)
> "Andrew F. Davis" <afd@ti.com> (reviewer:TI BQ27XXX POWER SUPPLY DRIVER)
> Sebastian Reichel <sre@kernel.org> (maintainer:POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS)
> linux-pm@vger.kernel.org (open list:POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS)
> linux-kernel@vger.kernel.org (open list)

I'm adding Pavel's patch to my tree and then send a pull req to Mauro. If
further changes are needed then let's write more patches.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
