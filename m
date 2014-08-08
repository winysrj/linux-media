Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46394 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaHHFKG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Aug 2014 01:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1XFcRH-0008Vt-Ul
	for linux-media@vger.kernel.org; Fri, 08 Aug 2014 07:10:04 +0200
Received: from nautilus.laiva.org ([62.142.120.74])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 07:10:03 +0200
Received: from olli.salonen by nautilus.laiva.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 07:10:03 +0200
To: linux-media@vger.kernel.org
From: Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH 3/4] support for DVBSky dvb-s2 usb: add dvb-usb-v2 driver for DVBSky dvb-s2 box
Date: Fri, 8 Aug 2014 05:02:46 +0000 (UTC)
Message-ID: <loom.20140808T065921-607@post.gmane.org>
References: <201408061236404537660@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Max,

nibble.max <nibble.max <at> gmail.com> writes:
> diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig
b/drivers/media/usb/dvb-usb-v2/Kconfig
> index 66645b0..8107c8d 100644
> --- a/drivers/media/usb/dvb-usb-v2/Kconfig
> +++ b/drivers/media/usb/dvb-usb-v2/Kconfig
>  <at>  <at>  -141,3 +141,9  <at>  <at>  config DVB_USB_RTL28XXU
>  	help
>  	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
> 
> +config DVB_USB_DVBSKY
> +	tristate "DVBSky USB support"
> +	depends on DVB_USB_V2
> +	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  Say Y here to support the USB receivers from DVBSky.

Shouldn't the MEDIA_TUNER_M88TS2022 also be selected in Kconfig?

Cheers,
-olli



