Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55836 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbbAFUWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 15:22:23 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so219159wiw.16
        for <linux-media@vger.kernel.org>; Tue, 06 Jan 2015 12:22:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WUXhv+b+oVYL6XMnyvQnj7+=gVPw2Z-0ZchNtNtS4cXrg@mail.gmail.com>
References: <CAL9G6WUXhv+b+oVYL6XMnyvQnj7+=gVPw2Z-0ZchNtNtS4cXrg@mail.gmail.com>
Date: Tue, 6 Jan 2015 21:22:22 +0100
Message-ID: <CAL9G6WUFK0Wu-J96Sag=jE=ZSF873fmO+4SdqZhUEopAehqAbQ@mail.gmail.com>
Subject: Re: TeVii S482 dual DVB-S2
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-10-13 8:33 GMT+02:00 Josu Lazkano <josu.lazkano@gmail.com>:
> Hello,
>
> I have TeVii S482 dual DVB-S2 device, is similar to the S480, but it
> doesn't work with same driver.
>
> The problem is that my device is not ported to the Linux kernel, there
> is a source code in tevii website and liplianin tree:
>
> http://www.tevii.com/Tevii_Product_20140428_media_build_b6.tar.bz2.rar
>
> https://bitbucket.org/liplianin/s2-liplianin-v39
>
> Is it possible to add this code to the linux-media tree? And to the
> Linux kernel?
>
> Any developer with this device? I am not developer, but I could make some test.
>
> Thanks and best regards.

Hello again,

I create wiki page in the linuxtv web:
http://www.linuxtv.org/wiki/index.php/TeVii_S482

I try to add all the information I have about the device. I can
compile Liplianin driver in Debian Wheezy (not in Jessie) but the
image and audio is bad in some channels, I get this output when it
occurs:

# dmesg
...
[  373.556033] ts2022_set_params: offset -500khz
[  373.556038] ts2022_set_params:  1256000khz  1255500khz
[ 1670.824033] ts2022_set_params: offset 571khz
[ 1670.824038] ts2022_set_params:  1847000khz  1847571khz
[ 2176.212034] ts2022_set_params: offset -500khz
[ 2176.212039] ts2022_set_params:  1256000khz  1255500khz
[ 2256.228031] ts2022_set_params: offset 571khz
[ 2256.228036] ts2022_set_params:  1847000khz  1847571khz
[ 2321.128038] ts2022_set_params: offset -500khz
[ 2321.128043] ts2022_set_params:  1256000khz  1255500khz
[ 2342.896034] ts2022_set_params: offset 571khz
[ 2342.896039] ts2022_set_params:  1847000khz  1847571khz
[ 2455.744057] ts2022_set_params: offset 357khz
[ 2455.744062] ts2022_set_params:  1178000khz  1178357khz

Anyone with this device?

Thanks and best regards.

-- 
Josu Lazkano
