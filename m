Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33313 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbcDZEWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2016 00:22:01 -0400
Received: by mail-wm0-f68.google.com with SMTP id r12so1081514wme.0
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 21:22:00 -0700 (PDT)
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Pavel Machek <pavel@ucw.cz>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425165848.GA10443@amd> <571E5134.10607@gmail.com>
 <20160425184016.GC10443@amd> <571E6D38.9050009@gmail.com>
 <20160425204110.GA2689@amd> <571E83B0.8020208@gmail.com>
 <20160425220751.GA26350@amd>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <571EECE5.8060100@gmail.com>
Date: Tue, 26 Apr 2016 07:21:57 +0300
MIME-Version: 1.0
In-Reply-To: <20160425220751.GA26350@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26.04.2016 01:07, Pavel Machek wrote:
> Hi!
>
>>> Hi!
>>>
>>>> All my testing so far was performed using modules, though it shouldn't make
>>>> difference.
>>>>
>>>>> https://lkml.org/lkml/2016/4/16/14
>>>>> https://lkml.org/lkml/2016/4/16/33
>>>>>
>>>>
>>>> More stuff is needed, all those twl4030 regulator patches (already in
>>>> linux-next) + DTS initial-mode patch
>>>> (https://lkml.org/lkml/2016/4/17/78).
>>>
>>> Aha, that explains a lot. Dealing with -next would be tricky, I guess;
>>> can I just pull from your camera branch?
>>>
>>> https://github.com/freemangordon/linux-n900/tree/camera
>>
>> I guess yes, though I am not sure all the patches there are compatible with
>> userland different from maemo, so be careful. Also, the correct branch is
>> v4.6-rc4-n900-camera.
>
> I tried v4.6-rc4-n900-camera, but got the same results: green mplayer
> window, if I try to use front or back camera. Assuming
> v4.6-rc4-n900-camera works for you, could I get your .config and list
> of modules loaded during the test?
>

.config is 'make rx51_defconfig' from v4.6-rc4-n900-camera branch, with 
added:

CONFIG_VIDEO_BUS_SWITCH=m
CONFIG_VIDEO_SMIAREGS=m
CONFIG_VIDEO_ET8EK8=m

For some reason I have to do 'modprobe smiapp' after every reboot, 
before using cameras.

After taking a nap, a question came to my mind - what is that device 
you're using? As some early board versions use VAUX3 for cameras as well.

awk '{ printf "%s ",$1 }' /proc/modules results in:

smiapp smiapp_pll sha256_generic hmac drbg ansi_cprng ctr ccm vfat fat 
rfcomm sd_mod scsi_mod bnep bluetooth omaplfb pvrsrvkm ipv6 
bq2415x_charger uinput radio_platform_si4713 joydev cmt_speech hsi_char 
video_bus_switch arc4 wl1251_spi isp1704_charger wl1251 gpio_keys 
mac80211 smc91x mii cfg80211 omap3_isp videobuf2_v4l2 omap_wdt 
videobuf2_dma_contig omap_sham crc7 videobuf2_memops videobuf2_core 
tsc2005 tsc200x_core leds_lp5523 bq27xxx_battery_i2c si4713 adp1653 
tsl2563 bq27xxx_battery leds_lp55xx_common twl4030_wdt rtc_twl et8ek8 
v4l2_common smiaregs videodev twl4030_vibra ff_memless lis3lv02d_i2c 
lis3lv02d media input_polldev omap_ssi_port ti_soc_thermal nokia_modem 
ssi_protocol omap_ssi hsi rx51_battery

Regards,
Ivo
