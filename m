Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33174 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2ADJzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 04:55:04 -0500
Received: by wgbdr13 with SMTP id dr13so28797760wgb.1
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 01:55:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F032AD7.7090003@gmail.com>
References: <CAL9G6WVycJpFsCJEWDk_V-RbJ=_1Q42mMJy5cb+tw9MBfke9JA@mail.gmail.com>
	<4F032AD7.7090003@gmail.com>
Date: Wed, 4 Jan 2012 10:55:02 +0100
Message-ID: <CAL9G6WWXp=sqiv3a42gyK34kznNL0wBLXu3ObhujQTnUpZbDOg@mail.gmail.com>
Subject: Re: More adapters on v4l
From: Josu Lazkano <josu.lazkano@gmail.com>
To: gennarone@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/1/3 Gianluca Gennari <gennarone@gmail.com>:
> Il 03/01/2012 17:09, Josu Lazkano ha scritto:
>> Hello, I am trying to compile the v4l drivers, I make this way:
>>
>> mkdir /usr/local/src/dvb
>> cd /usr/local/src/dvb
>> git clone git://linuxtv.org/media_build.git
>> cd media_build
>> ./build
>>
>> I got this message on the end:
>>
>> **********************************************************
>> * Compilation finished. Use 'make install' to install them
>> **********************************************************
>>
>> But before the "make" I want to add more adapters changing the
>> "v4l/scripts/make_kconfig.pl" file to this:
>>
>> .config:CONFIG_DVB_MAX_ADAPTERS=16
>>
>> When I execute the "./build" it compile and I can not change the source.
>>
>> On the s2-liplianin branch I had no problem because I change it before
>> the "make" this way:
>>
>> mkdir /usr/local/src/dvb
>> cd /usr/local/src/dvb
>> wget http://mercurial.intuxication.org/hg/s2-liplianin/archive/tip.zip
>> unzip s2-liplianin-0b7d3cc65161.zip
>> cd s2-liplianin-0b7d3cc65161
>> ##change the adapter number###
>> make
>> make install
>>
>> Is possible to do the same with the v4l source?
>>
>> Thanks and best regards.
>>
>
> Hi Josu,
> you can do this way:
>
> git clone git://linuxtv.org/media_build.git
> cd media_build
> ./build
> ## you can ctrl-C as soon as it starts compiling the drivers, or wait
> until the end ##
> make menuconfig
> ## change all the options you like and save ##
> cd linux
> make
> cd ..
> make install
>
> Best regards,
> Gianluca Gennari

Thanks!

I comment the "make" line on the "build" script.

Best regards.

-- 
Josu Lazkano
