Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40674 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab2HGMup (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 08:50:45 -0400
Received: by lboi8 with SMTP id i8so76985lbo.19
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2012 05:50:43 -0700 (PDT)
Message-ID: <50210F15.4060407@iki.fi>
Date: Tue, 07 Aug 2012 15:50:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: help me, Kconfig problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I added Kernel GPIO interface for cxd2820r driver. What I understand I 
should select GPIOLIB in order to compile cxd2820r now. I am not sure if 
that problem comes from recent Media Kconfig re-arrangement or not, but 
for some reason I didn't saw it earlier.

What I should put for Kconfig in order to prevent these errors?

config DVB_CXD2820R
	tristate "Sony CXD2820R"
	depends on DVB_CORE && I2C && GPIOLIB
	default m if DVB_FE_CUSTOMISE
	help
	  Say Y when you want to support this frontend.

[crope@localhost linux]$ make silentoldconfig
scripts/kconfig/conf --silentoldconfig Kconfig
warning: (VIDEO_EM28XX_DVB && DVB_USB_ANYSEE) selects DVB_CXD2820R which 
has unmet direct dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && 
DVB_CORE && I2C && GPIOLIB)
warning: (VIDEO_EM28XX_DVB && DVB_USB_ANYSEE) selects DVB_CXD2820R which 
has unmet direct dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && 
DVB_CORE && I2C && GPIOLIB)

***************************************

config DVB_CXD2820R
	tristate "Sony CXD2820R"
	depends on DVB_CORE && I2C
	select GPIOLIB
	default m if DVB_FE_CUSTOMISE
	help
	  Say Y when you want to support this frontend.

[crope@localhost linux]$ make silentoldconfig
scripts/kconfig/conf --silentoldconfig Kconfig
drivers/usb/Kconfig:88:error: recursive dependency detected!
drivers/usb/Kconfig:88:	symbol USB is selected by MOUSE_APPLETOUCH
drivers/input/mouse/Kconfig:152:	symbol MOUSE_APPLETOUCH depends on 
USB_ARCH_HAS_HCD
drivers/usb/Kconfig:78:	symbol USB_ARCH_HAS_HCD depends on USB_ARCH_HAS_OHCI
drivers/usb/Kconfig:17:	symbol USB_ARCH_HAS_OHCI depends on MFD_TC6393XB
drivers/mfd/Kconfig:396:	symbol MFD_TC6393XB depends on GPIOLIB
drivers/gpio/Kconfig:35:	symbol GPIOLIB is selected by DVB_CXD2820R
drivers/media/dvb/frontends/Kconfig:422:	symbol DVB_CXD2820R is selected 
by VIDEO_EM28XX_DVB
drivers/media/video/em28xx/Kconfig:33:	symbol VIDEO_EM28XX_DVB depends 
on V4L_USB_DRIVERS
drivers/media/video/Kconfig:668:	symbol V4L_USB_DRIVERS depends on USB
#
# configuration written to .config
#

regards
Antti

-- 
http://palosaari.fi/
