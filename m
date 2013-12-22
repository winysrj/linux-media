Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37435 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab3LVQRz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 11:17:55 -0500
Message-ID: <52B710AE.2070606@iki.fi>
Date: Sun, 22 Dec 2013 18:17:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: LMML <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: em28xx list_add corruption reported by list debug
References: <52B615C9.8040806@iki.fi> <20131222130600.652f468a@samsung.com> <20131222135531.6af60f77@samsung.com>
In-Reply-To: <20131222135531.6af60f77@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.12.2013 17:55, Mauro Carvalho Chehab wrote:
> Em Sun, 22 Dec 2013 13:06:00 -0200
> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
>
>> Em Sun, 22 Dec 2013 00:27:21 +0200
>> Antti Palosaari <crope@iki.fi> escreveu:
>>
>>> I ran also this kind of bug. Device was PCTV 290e, which has that video
>>> unused. I have no any analog em28xx webcam to test if that happens here too.
>>>
>>> Fortunately I found one video device which does not crash nor dump debug
>>> bug warnings. It is some old gspca webcam. Have to look example how
>>> those videobuf callbacks are implemented there..
>>>
>>> regards
>>> Antti
>>>
>>>
>>> [crope@localhost linux]$ cat /dev/video0
>>> cat: /dev/video0: Invalid argument
>>> [crope@localhost linux]$ cat /dev/video0
>>> cat: /dev/video0: Device or resource busy
>>> [crope@localhost linux]$
>>>
>>>
>>> joulu 22 00:08:24 localhost.localdomain kernel: em28174 #0: no endpoint
>>> for analog mode and transfer type 0
>>
>> It seems that there's something bad on em28174 registration: it should not
>> be creating a v4l2 device, if the device is DVB only.
>>
>> The thing is that, when this driver was created, all devices were either
>> analog only or hybrid. Only very recently, pure DVB devices got added.
>>
>> It shouldn't be that hard to split em28xx_init_dev() into a few routines
>> that would only register v4l2 if the device has analog support.
>>
>> Again, this changeset:
>> 	https://patchwork.linuxtv.org/patch/17967/
>>
>> Seems to be part of such solution, as it already splits the v4l2
>> register logic into a separate function.
>
> Ok, if I didn't make any mistake, this changeset should do the trick:
> 	https://patchwork.linuxtv.org/patch/21282/
>
> Please notice that this is compile-tested only.

I started to testing that patch, but now I get following compilation 
errors:

WARNING: "em28xx_detect_sensor" [drivers/media/usb/em28xx/em28xx.ko] 
undefined!
WARNING: "em28xx_init_camera" [drivers/media/usb/em28xx/em28xx.ko] 
undefined!
WARNING: "em28xx_resolution_set" 
[drivers/media/usb/em28xx/em28xx-v4l.ko] undefined!
WARNING: "em28xx_colorlevels_set_default" 
[drivers/media/usb/em28xx/em28xx-v4l.ko] undefined!
WARNING: "em28xx_set_outfmt" [drivers/media/usb/em28xx/em28xx-v4l.ko] 
undefined!
WARNING: "em28xx_read_reg_req_len" 
[drivers/media/usb/em28xx/em28xx-v4l.ko] undefined!
WARNING: "em28xx_wake_i2c" [drivers/media/usb/em28xx/em28xx-v4l.ko] 
undefined!
WARNING: "em28xx_set_alternate" [drivers/media/usb/em28xx/em28xx-v4l.ko] 
undefined!
WARNING: "em28xx_vbi_supported" [drivers/media/usb/em28xx/em28xx-v4l.ko] 
undefined!
WARNING: "em28xx_release_resources" 
[drivers/media/usb/em28xx/em28xx-v4l.ko] undefined!
WARNING: "em28xx_boards" [drivers/media/usb/em28xx/em28xx-v4l.ko] undefined!

anyhow, I am not sure if those are related or not. I will re-compile 
whole kernel to see (build only media).

regards
Antti

-- 
http://palosaari.fi/
