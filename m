Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49841 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaHHFhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 01:37:04 -0400
Received: by mail-pd0-f173.google.com with SMTP id w10so6429777pde.4
        for <linux-media@vger.kernel.org>; Thu, 07 Aug 2014 22:37:04 -0700 (PDT)
Date: Fri, 8 Aug 2014 13:37:08 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201408061236404537660@gmail.com>
Subject: Re: Re: [PATCH 3/4] support for DVBSky dvb-s2 usb: add dvb-usb-v2 driver for DVBSky dvb-s2 box
Message-ID: <201408081337062501153@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Olli,
>Hi Max,
>
>nibble.max <nibble.max <at> gmail.com> writes:
>> diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig
>b/drivers/media/usb/dvb-usb-v2/Kconfig
>> index 66645b0..8107c8d 100644
>> --- a/drivers/media/usb/dvb-usb-v2/Kconfig
>> +++ b/drivers/media/usb/dvb-usb-v2/Kconfig
>>  <at>  <at>  -141,3 +141,9  <at>  <at>  config DVB_USB_RTL28XXU
>>  	help
>>  	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
>> 
>> +config DVB_USB_DVBSKY
>> +	tristate "DVBSky USB support"
>> +	depends on DVB_USB_V2
>> +	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
>> +	help
>> +	  Say Y here to support the USB receivers from DVBSky.
>
>Shouldn't the MEDIA_TUNER_M88TS2022 also be selected in Kconfig?
Yes, I miss it. It should be selected in Kconfig.
Thanks.
>
>Cheers,
>-olli
>
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

