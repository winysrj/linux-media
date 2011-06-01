Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:48073 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab1FAKCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 06:02:15 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Antti Palosaari <crope@iki.fi>
Cc: Steve Kerrison <steve@stevekerrison.com>,
	linux-media@vger.kernel.org
Subject: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter() from em28xx-dvb.c creates a hard module dependency
Date: Wed, 01 Jun 2011 11:45:27 +0200
Message-ID: <87vcwpnavc.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I noticed this warning 

    WARNING: "cxd2820r_get_tuner_i2c_adapter" [/usr/local/src/git/linux-2.6/drivers/media/video/em28xx/em28xx-dvb.ko] undefined!

while building the driver in 2.6.32 with backported 290e support.  This
warning does not appear with 3.0.0-rc1, but the call still does cause a
hard dependency on cxd2820r even if you build with CONFIG_MEDIA_ATTACH=y:

bjorn@canardo:/usr/local/src/git/linux-2.6$ modinfo drivers/media/video/em28xx/em28xx-dvb.ko
filename:       drivers/media/video/em28xx/em28xx-dvb.ko
license:        GPL
author:         Mauro Carvalho Chehab <mchehab@infradead.org>
description:    driver for em28xx based DVB cards
depends:        cxd2820r,dvb-core,em28xx,usbcore
vermagic:       3.0.0-rc1+ SMP mod_unload modversions 
parm:           debug:enable debug messages [dvb] (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

I assume this is unwanted.  As you can see, cxd2820r is the only
frontend dependency....

Don't know the proper fix.  My naïve quick-fix was just to move struct
cxd2820r_priv into cxd2820r.h and making the function static inlined.
However, I do see that you may not want the struct in cxd2820r.h.  But I
trust that you have a brilliant solution to the problem :-)

Thanks for your great work on the cxd2820r driver and nanostick T2 290e
support!



Bjørn
