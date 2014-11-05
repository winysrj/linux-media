Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43539 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbaKEJQq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 04:16:46 -0500
Date: Wed, 5 Nov 2014 07:16:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andreas Steinmetz <ast@domdv.de>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: linux-media@vger.kernel.org, Bob Liu <Bob@Turbosight.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: [PATCH 1/3] TBS USB drivers (DVB-S/S2) - basic driver
Message-ID: <20141105071640.2a22d094@recife.lan>
In-Reply-To: <1395865966.23074.60.camel@host028-server-9.lan.domdv.de>
References: <1395865966.23074.60.camel@host028-server-9.lan.domdv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

(c/c the others that are listed as the authors of the TBS driver)

Em Wed, 26 Mar 2014 21:32:46 +0100
Andreas Steinmetz <ast@domdv.de> escreveu:

> [Please CC me on replies, I'm not subscribed]
> 
> The patch adds a driver for TBS USB DVB-S/S2 devices for which complete
> GPLv2 code exists. Code was taken from:
> 
> http://www.tbsdtv.com/download/
> https://bitbucket.org/CrazyCat/linux-tbs-drivers/
> https://bitbucket.org/updatelee/v4l-updatelee

We have already a driver for the chipsets used on this driver.
So, instead of adding a new driver, you should work on adding support
on the existing ones.
> 
> Supported devices:
> ------------------
> 
> TBS5980 - complete open source by manufacturer, current device
> TBS5928 - complete open source by manufacturer, old device
> TBS5920 - complete open source by manufacturer, old device
> TBS5910 - complete open source by manufacturer, old device
> TBS5925 - open source by manufacturer except 13V/18V control,
>           voltage switching of TBS5980 however works,
>           current device
> TBS5921 - open source from CrazyCat's bitbucket repository,
>           old device
> 
> Unsupported devices:
> --------------------
> 
> TBS5922 - mostly closed source, current device
> TBS5990 - mostly closed source, current device
> TBS???? with USB PID 0x2601 - very old device for which the actual
> hardware used couldn't be determined.
> 
> General:
> --------
> 
> I do not have any manufacturer relationship. I'm just a user of TBS5980
> and TBS5925 which work quite well as far as the hardware is concerned.
> 
> I'm sufficiently annoyed, however, by the manufacturer's driver build
> system which actually is an old v4l tree replacing the kernel's current
> v4l tree. Thus I have reworked all available open source code for the
> TBS USB DVB-S/S2 hardware into a combined driver that is working with
> the current kernel.
> 
> Testing:
> --------
> 
> TBS5925 gets used daily and is working fine.
> TBS5980 gets used daily minus an actual CAM and is working fine without
> a CAM.
> 
> The old devices can't be tested by me, I don't own them and they are not
> sold anymore.
> 
> Maintenance:
> ------------
> 
> As a TBS5925/TBS5980 user I'm willing to maintain the driver as far as
> this is possible (see below).
> 
> Regarding the older devices I'm willing to fix bugs for owners of these
> devices as long as I did introduce them in my combined driver.
> 
> What I cannot do for any device is to fix any problems that would
> require manufacturer support or manufacturer documentation.
> 
> As the TBS5980 manufacturer sources on which this driver is based didn't
> change for more than one and a half years (since when I started to
> collect manufacturer source archives) I'm quite confident that not much
> maintenance will be necessary.
> 
> Firmware:
> ---------
> 
> All required firmware except for the TBS5921 is available at
> http://www.tbsdtv.com/download/ (manufacturer website). The tda10071
> firmware required additionally for the TBS5921 is already supported by
> the get_dvb_firmware script of the kernel.
> 
> Due to the way the manufacturer handles software distribution I can't
> include the TBS firmware in the get_dvb_firmware script (no archive url,
> archive files updated every few months under a different file name).
> 
> Notes:
> ------
> 
> The ifdefs in the driver will go away by a followup patch after a
> necessary patch to some frontends.
> 
> Please go on easy with me. I'm usually not writing kernel drivers. And
> I'm neither young nor healthy enough for flame wars.
