Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:45500 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934222AbdKQPCW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 10:02:22 -0500
Received: by mail-qt0-f193.google.com with SMTP id v41so6659263qtv.12
        for <linux-media@vger.kernel.org>; Fri, 17 Nov 2017 07:02:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171117125847.28004106@vento.lan>
References: <20171117141826.GC17880@kroah.com> <20171117125847.28004106@vento.lan>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 17 Nov 2017 16:01:41 +0100
Message-ID: <CAOFm3uE9NmPV6diYcTodBKRr0CXFYs7uvVPrLTyLaa_3VKV7rA@mail.gmail.com>
Subject: Re: [PATCH] media: usbvision: remove unneeded DRIVER_LICENSE #define
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 3:58 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Fri, 17 Nov 2017 15:18:26 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:
>
>> There is no need to #define the license of the driver, just put it in
>> the MODULE_LICENSE() line directly as a text string.
>>
>> This allows tools that check that the module license matches the source
>> code license to work properly, as there is no need to unwind the
>> unneeded dereference.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Johan Hovold <johan@kernel.org>
>> Cc: Davidlohr Bueso <dave@stgolabs.net>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Reported-by: Philippe Ombredanne <pombredanne@nexb.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/media/usb/usbvision/usbvision-video.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
>> index 960272d3c924..0f5954a1fea2 100644
>> --- a/drivers/media/usb/usbvision/usbvision-video.c
>> +++ b/drivers/media/usb/usbvision/usbvision-video.c
>> @@ -72,7 +72,6 @@
>>  #define DRIVER_NAME "usbvision"
>>  #define DRIVER_ALIAS "USBVision"
>>  #define DRIVER_DESC "USBVision USB Video Device Driver for Linux"
>> -#define DRIVER_LICENSE "GPL"
>>  #define USBVISION_VERSION_STRING "0.9.11"
>>
>>  #define      ENABLE_HEXDUMP  0       /* Enable if you need it */
>> @@ -141,7 +140,7 @@ MODULE_PARM_DESC(radio_nr, "Set radio device number (/dev/radioX).  Default: -1
>>  /* Misc stuff */
>>  MODULE_AUTHOR(DRIVER_AUTHOR);
>>  MODULE_DESCRIPTION(DRIVER_DESC);
>> -MODULE_LICENSE(DRIVER_LICENSE);
>> +MODULE_LICENSE("GPL");
>
> Makes sense to me, but, if we look at the header of this file:
>
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation; either version 2 of the License, or
>  * (at your option) any later version.
>
> Its license is actually GPL 2.0+
>
> So, I would actually change it to:
>
> MODULE_LICENSE("GPL v2");

Mauro:

actually even if it sounds weird the module.h doc [1] is clear on this topic:

 * "GPL" [GNU Public License v2 or later]
 * "GPL v2" [GNU Public License v2]

So it should be "GPL" IMHO.


[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/module.h?id=refs/tags/v4.10#n175

-- 
Cordially
Philippe Ombredanne
