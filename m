Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40927 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0EISev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 14:34:51 -0400
Received: by bwz19 with SMTP id 19so1387602bwz.21
        for <linux-media@vger.kernel.org>; Sun, 09 May 2010 11:34:50 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: stv090x vs stv0900
Date: Sun, 9 May 2010 21:34:34 +0300
Cc: Manu Abraham <abraham.manu@gmail.com>,
	"Igor M. Liplianin" <liplianin@netup.ru>,
	linux-media@vger.kernel.org
References: <1273135577.16031.11.camel@plop>
In-Reply-To: <1273135577.16031.11.camel@plop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201005092134.45226.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 мая 2010 11:46:17 Pascal Terjan wrote:
> Hi,
>
> I was adding support for a non working version of DVBWorld HD 2104
>
> It is listed on
> http://www.linuxtv.org/wiki/index.php/DVBWorld_HD_2104_FTA_USB_Box as :
>
> =====
> for new solution : 2104B (Sharp0169 Tuner)
>
>       * STV6110A tuner
>       * ST0903 demod
>       * Cyrix CY7C68013A USB controller
> =====
>
> The 2104A is supposed to be working and also have ST0903 but uses
> stv0900, so I tried using it too but did not manage to get it working.
But it working. I have the device and test it succesfully.

>
> I now have some working code by using stv090x + stv6110x (copied config
> from budget) but I am wondering why do we have 2 drivers for stv0900,
> and is stv0900 supposed to handle stv0903 devices or is either the code
> or the wki wrong about 2104A?
Code for stv0900 supposed to handle stv0903 devices as well. And it handles.
Feel free to add for stv0900. I don't impede.

>
> Also, are they both maintained ? I wrote a patch to add get_frontend to
> stv090x but stv0900 also does not have it and I don't know which one
> should get new code.
>
> And stv6110x seems to also handle stv6110 which also exists as a
> separate module...
In time when I commit stv0900(stv6110 as well) there wasn't any driver for stv0900/stv0903.
Now I'm wondering like you.

Look here:
root@useri:/etc/default# modinfo dvb-usb-dw2102
filename:       /lib/modules/2.6.34-rc6/kernel/drivers/media/dvb/dvb-usb/dvb-usb-dw2102.ko
license:        GPL
version:        0.1
description:    Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101 USB2.0, TeVii S600, 
S630, S650, S660 USB2.0, Prof 1100, 7500 USB2.0 devices
author:         Igor M. Liplianin (c) liplianin@me.by
srcversion:     496C3974FA3791E61D28672
alias:          usb:v3034p7500d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v9022pD660d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v3011pB012d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v9022pD630d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04B4p3101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0064d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v9022pD650d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04B4p2104d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04B4p2101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04B4p2102d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb,i2c-core
vermagic:       2.6.34-rc6 SMP mod_unload PENTIUM4 
parm:           debug:set debugging level (1=info 2=xfer 4=rc(or-able)). (int)
parm:           keymap:set keymap 0=default 1=dvbworld 2=tevii 3=tbs  ... (int)
parm:           demod:demod to probe (1=cx24116 2=stv0903+stv6110 4=stv0903+stb6100(or-able)). 
(int)
parm:           adapter_nr:DVB adapter numbers (array of short)

So modprobe dvb-usb-dw2102 demod=2 brings DVBWorld 2104A to you on golden plate.

Best Regards
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
