Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:45373 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbaBGSeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 13:34:22 -0500
Received: from [24.206.66.147] (helo=[192.168.1.7])
	by elasmtp-masked.atl.sa.earthlink.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.67)
	(envelope-from <thebitpit@earthlink.net>)
	id 1WBq5W-0003FA-HZ
	for linux-media@vger.kernel.org; Fri, 07 Feb 2014 13:23:42 -0500
Message-ID: <52F524A8.9000008@earthlink.net>
Date: Fri, 07 Feb 2014 12:23:36 -0600
From: The Bit Pit <thebitpit@earthlink.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Driver for KWorld UB435Q Version 3 (ATSC)  USB id: 1b80:e34c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Last May I started writing a driver for a KWorld UB435Q Version 3
tuner.  I was able to make the kernel recognize the device, light it's
LED, and try to enable the decoder and tuner.

I was unable to locate any information for the tda18272 tuner chip until
last week.  I received an email at another address with a pointer to a
GPL driver that used a tda18272 in a pcie based tuner.  It appears that
a bit of refactoring has been done to v4l2 since it was written.  I want
to try to incorporate it into the kernel tree properly while making the
KWorld UB435Q Version 3 usable under linux.

Would the tda18271 be a good model?

The tda18271 organized with part in tuners and part in dvb-frontends. 
What is the dvb-frontends stuff used for?

The tda18271 files in kernel are:

./media/tuners/tda18271-maps.c
./media/tuners/tda18271-fe.c
./media/tuners/tda18271.h
./media/tuners/tda18271-priv.h
./media/tuners/tda18271-common.c
./media/dvb-frontends/tda18271c2dd.c
./media/dvb-frontends/tda18271c2dd.h
./media/dvb-frontends/tda18271c2dd_maps.h

The tda18272 files I located are:

./media/dvb/frontends/tda18272_reg.h
./media/dvb/frontends/tda18272.h
./media/dvb/frontends/tda18272.c

The tuner is only used in digital mode with KWorld UB435Q Version 3. 
The tda18272 supports both digital and analog.  Should I include the
analog support in the tda18272 files without testing it?


