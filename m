Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49902 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2GEOXS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 10:23:18 -0400
Message-ID: <4FF5A350.9070509@iki.fi>
Date: Thu, 05 Jul 2012 17:23:12 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/05/2012 04:14 PM, Marx wrote:
> Maybe i did something wrong because I'm new to git, so below are steps i
> followed to compile new driver set:
> 1) git clone git://linuxtv.org/anttip/media_tree.git
> 2) git checkout -b pctv452e origin/pctv452e
> 3) copy config file from 3.4 kernel
> 4) make menuconfig, check everything seems ok, quit & save
> 5) build kernel Debian way, and install it, reboot
>
> wuwek:~# uname -a
> Linux wuwek 3.5.0-rc5+ #1 SMP Thu Jul 5 09:22:36 CEST 2012 i686 GNU/Linux
>
> wuwek:~# lsusb
> Bus 001 Device 002: ID 2304:021f Pinnacle Systems, Inc. PCTV Sat HDTV
> Pro BDA Device
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>
>
> wuwek:~/pctv/pctv452e/media_tree# ls /dev/dvb*
> ls: nie ma dostępu do /dev/dvb*: Nie ma takiego pliku ani katalogu
>
> So, while device is recognized, and a driver seems to recognize device,
> there is no /dev/dvb* devices, so something went wrong.
>
> What can I do more?
>
> Marx
>
> Ps. I'm attaching dmesg output. The second dvb card is internal Prof
> Revolution 8000.

I didn't load whole driver. Test load it manually first using modprobe 
dvb_usb_pctv452e

Check if those modules are enabled, in file .config
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_PCTV452E=m

use make menuconfig to enable if disabled. Then make && make 
install_modules && make install as usually.

regards
Antti


-- 
http://palosaari.fi/


