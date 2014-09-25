Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63816 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaIYUMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 16:12:12 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so9705024wiv.8
        for <linux-media@vger.kernel.org>; Thu, 25 Sep 2014 13:12:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WUQS3h9JEWvK66OEUB8LM68+wwFRvZZVmtKsp+AsG1EVA@mail.gmail.com>
References: <CAL9G6WWEocLTVeZSOtRaJYa6ieJyCzF9BiacZgrdWvKnt3P78Q@mail.gmail.com>
	<8A4AD82170F342C1BE0BB0383F79E0C4@ci5fish>
	<CAL9G6WVfSigCdA8kLC2yB9C7UwzFdxbKeiE7fEWU4xjHD4p1=g@mail.gmail.com>
	<4308AC0DD1384C2FBFF56C13F8A55955@ci5fish>
	<CAL9G6WUQS3h9JEWvK66OEUB8LM68+wwFRvZZVmtKsp+AsG1EVA@mail.gmail.com>
Date: Thu, 25 Sep 2014 22:12:11 +0200
Message-ID: <CAL9G6WVDKNQEk=YoN3xPtcBr+ur8jJUFHgwtRGdQwse8+-AaXg@mail.gmail.com>
Subject: Re: TeVii S480 in Debian Wheezy
From: Josu Lazkano <josu.lazkano@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,

I found this 2 source codes:

Debian 3.2 kernel module file: http://paste.debian.net/plain/123108
TeVii S482 official driver module file: http://paste.debian.net/plain/123109

And here is Igor commit to add S482 device to his tree:
https://bitbucket.org/liplianin/s2-liplianin-v39/commits/81e9bb4205865025fc34bf93aac18537f9147d65?at=default

Would it be possible to add a patch to my kernel source? I want to use
Debian kernel source in my machines.

Kind regards.

2014-09-25 21:25 GMT+02:00 Josu Lazkano <josu.lazkano@gmail.com>:
> Thanks again,
>
> I just write to Tevvi an email.
>
> I notice that in the module information there is nothing about the
> S482, and yes about S480:
>
> # modinfo dvb_usb_dw2102
> filename:
> /lib/modules/3.2.0-4-amd64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dw2102.ko
> license:        GPL
> version:        0.1
> description:    Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,
> DVB-C 3101 USB2.0, TeVii S600, S630, S650, S660, S480, Prof 1100, 7500
> USB2.0, Geniatech SU3000 devices
> author:         Igor M. Liplianin (c) liplianin@me.by
> srcversion:     C68A41BC4053618B662E6B1
> alias:          usb:v1F4Dp3100d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v9022pD482d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v9022pD481d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0CCDp00A8d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1F4Dp3000d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v3034p7500d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v9022pD660d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v3011pB012d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v9022pD630d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04B4p3101d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0CCDp0064d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v9022pD650d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04B4p2104d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04B4p2101d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04B4p2102d*dc*dsc*dp*ic*isc*ip*
> depends:        dvb-usb,i2c-core,usbcore
> intree:         Y
> vermagic:       3.2.0-4-amd64 SMP mod_unload modversions
> parm:           debug:set debugging level (1=info 2=xfer
> 4=rc(or-able)). (debugging is not enabled) (int)
> parm:           keymap:set keymap 0=default 1=dvbworld 2=tevii 3=tbs
> ... 256=none (int)
> parm:           demod:demod to probe (1=cx24116 2=stv0903+stv6110
> 4=stv0903+stb6100(or-able)). (int)
> parm:           adapter_nr:DVB adapter numbers (array of short)
>
> So maybe I need to add some code in the kernel module. Here is my
> kernel module code:
>
> /usr/src/linux-source-3.2/drivers/media/dvb/dvb-usb/dw2102.c:
> http://paste.debian.net/plain/123100
>
> I have no idea how to fix it, could someone help with this? I will
> really appreciate it.
>
> Kind regards.
>
> 2014-09-25 21:03 GMT+02:00 René <poisson.rene@neuf.fr>:
>> I think S470 and S660 are old enough to be maintained in the main stream
>> media driver tree...
>>
>> I can't help with your compile errors, the last time I used TeVii devices
>> (S482) I was running kernel version 3.11  ....
>> There are a lot of message about minimum version of kernel in your output
>> while you are running 3.2.0.
>>
>> Try to contact support at sales@tevii.com with [support] in the subject they
>> will redirect you to the maintainer
>>
>> René
>> --------------------------------------------------
>> From: "Josu Lazkano" <josu.lazkano@gmail.com>
>> Sent: Thursday, September 25, 2014 8:35 PM
>> To: "René" <poisson.rene@neuf.fr>
>> Cc: "linux-media" <linux-media@vger.kernel.org>
>> Subject:  Re: TeVii S480 in Debian Wheezy
>>
>>
>>> Thanks René,
>>>
>>> I have more TeVii devices (S470 and S660) running in other machine
>>> with no problems, just copying the firmware work out of the box.
>>>
>>> Is really necessary to compile the Tevii driver? I have more DVB
>>> device and want to use Debian kernels.
>>>
>>> I try to compile it:
>>>
>>> wget
>>> http://www.tevii.com/Tevii_Product_20140428_media_build_b6.tar.bz2.rar
>>> tar -xjvf Tevii_Product_20140428_media_build_b6.tar.bz2.rar
>>> cd b6/media_build/
>>> make (output: http://paste.debian.net/plain/123090)
>>>
>>> But there are errors, could you help with the driver compilation? I
>>> prefer to use the Debian kernel/modules in a clean way.
>>>
>>> Regards.
>>>
>>> 2014-09-25 19:45 GMT+02:00 René <poisson.rene@neuf.fr>:
>>>>
>>>> Hi Josu,
>>>>
>>>> TeVii still have their own version of media tree (may be some day they
>>>> will
>>>> make their way through main stream ...)
>>>>
>>>> The drivers are available here
>>>> http://www.tevii.com/Tevii_Release_v5192_20140915.rar but you have to be
>>>> aware of the following :
>>>> - rar files are not necessarily rar ! It's sometimes just tar files or
>>>> tar.gz
>>>> - you have to compile the drivers so you need at least kernel headers and
>>>> tools to build drivers from sources (don't know which packages for
>>>> Debian)
>>>> - once you have built with "make" and before you "make install" you need
>>>> to
>>>> remove the actual media tree from your kernel with "rm -Rf
>>>> /lib/modules/`uname -r`/kernel/drivers/media" in order to have no symbols
>>>> discrepencies. Be sure you have no error during make !
>>>> - I have used TeVii products both at work and at home  and found poor
>>>> reliability (and poor support).
>>>>
>>>> Good luck,
>>>>
>>>> René
>>>>
>>>> --------------------------------------------------
>>>> From: "Josu Lazkano" <josu.lazkano@gmail.com>
>>>> Sent: Thursday, September 25, 2014 5:12 PM
>>>> To: "linux-media" <linux-media@vger.kernel.org>
>>>> Subject:  TeVii S480 in Debian Wheezy
>>>>
>>>>> Hello all,
>>>>>
>>>>> I want to use a new dual DVB-S2 device, TeVii S480.
>>>>>
>>>>> I am using Debian Wheezy with 3.2 kernel, I copy the firmware files:
>>>>>
>>>>> # md5sum /lib/firmware/dvb-*
>>>>> a32d17910c4f370073f9346e71d34b80  /lib/firmware/dvb-fe-ds3000.fw
>>>>> 2946e99fe3a4973ba905fcf59111cf40  /lib/firmware/dvb-usb-s660.fw
>>>>>
>>>>> The device is listed as 2 USB devices:
>>>>>
>>>>> # lsusb | grep TeVii
>>>>> Bus 006 Device 002: ID 9022:d483 TeVii Technology Ltd.
>>>>> Bus 007 Device 002: ID 9022:d484 TeVii Technology Ltd.
>>>>>
>>>>> But there is no any device in /dev/dvb/:
>>>>>
>>>>> # ls -l /dev/dvb/
>>>>> ls: cannot access /dev/dvb/: No such file or directory
>>>>>
>>>>> Need I install any other driver or piece of software?
>>>>>
>>>>> I will appreciate any help.
>>>>>
>>>>> Best regards.
>>>>>
>>>>> --
>>>>> Josu Lazkano
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>> --
>>> Josu Lazkano
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Josu Lazkano



-- 
Josu Lazkano
