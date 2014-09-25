Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64620 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaIYSgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 14:36:00 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so8530466wgg.32
        for <linux-media@vger.kernel.org>; Thu, 25 Sep 2014 11:35:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8A4AD82170F342C1BE0BB0383F79E0C4@ci5fish>
References: <CAL9G6WWEocLTVeZSOtRaJYa6ieJyCzF9BiacZgrdWvKnt3P78Q@mail.gmail.com>
	<8A4AD82170F342C1BE0BB0383F79E0C4@ci5fish>
Date: Thu, 25 Sep 2014 20:35:58 +0200
Message-ID: <CAL9G6WVfSigCdA8kLC2yB9C7UwzFdxbKeiE7fEWU4xjHD4p1=g@mail.gmail.com>
Subject: Re: TeVii S480 in Debian Wheezy
From: Josu Lazkano <josu.lazkano@gmail.com>
To: =?UTF-8?B?UmVuw6k=?= <poisson.rene@neuf.fr>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks René,

I have more TeVii devices (S470 and S660) running in other machine
with no problems, just copying the firmware work out of the box.

Is really necessary to compile the Tevii driver? I have more DVB
device and want to use Debian kernels.

I try to compile it:

wget http://www.tevii.com/Tevii_Product_20140428_media_build_b6.tar.bz2.rar
tar -xjvf Tevii_Product_20140428_media_build_b6.tar.bz2.rar
cd b6/media_build/
make (output: http://paste.debian.net/plain/123090)

But there are errors, could you help with the driver compilation? I
prefer to use the Debian kernel/modules in a clean way.

Regards.

2014-09-25 19:45 GMT+02:00 René <poisson.rene@neuf.fr>:
> Hi Josu,
>
> TeVii still have their own version of media tree (may be some day they will
> make their way through main stream ...)
>
> The drivers are available here
> http://www.tevii.com/Tevii_Release_v5192_20140915.rar but you have to be
> aware of the following :
> - rar files are not necessarily rar ! It's sometimes just tar files or
> tar.gz
> - you have to compile the drivers so you need at least kernel headers and
> tools to build drivers from sources (don't know which packages for Debian)
> - once you have built with "make" and before you "make install" you need to
> remove the actual media tree from your kernel with "rm -Rf
> /lib/modules/`uname -r`/kernel/drivers/media" in order to have no symbols
> discrepencies. Be sure you have no error during make !
> - I have used TeVii products both at work and at home  and found poor
> reliability (and poor support).
>
> Good luck,
>
> René
>
> --------------------------------------------------
> From: "Josu Lazkano" <josu.lazkano@gmail.com>
> Sent: Thursday, September 25, 2014 5:12 PM
> To: "linux-media" <linux-media@vger.kernel.org>
> Subject:  TeVii S480 in Debian Wheezy
>
>> Hello all,
>>
>> I want to use a new dual DVB-S2 device, TeVii S480.
>>
>> I am using Debian Wheezy with 3.2 kernel, I copy the firmware files:
>>
>> # md5sum /lib/firmware/dvb-*
>> a32d17910c4f370073f9346e71d34b80  /lib/firmware/dvb-fe-ds3000.fw
>> 2946e99fe3a4973ba905fcf59111cf40  /lib/firmware/dvb-usb-s660.fw
>>
>> The device is listed as 2 USB devices:
>>
>> # lsusb | grep TeVii
>> Bus 006 Device 002: ID 9022:d483 TeVii Technology Ltd.
>> Bus 007 Device 002: ID 9022:d484 TeVii Technology Ltd.
>>
>> But there is no any device in /dev/dvb/:
>>
>> # ls -l /dev/dvb/
>> ls: cannot access /dev/dvb/: No such file or directory
>>
>> Need I install any other driver or piece of software?
>>
>> I will appreciate any help.
>>
>> Best regards.
>>
>> --
>> Josu Lazkano
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Josu Lazkano
