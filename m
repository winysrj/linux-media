Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58357 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761477Ab2COMeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 08:34:07 -0400
Received: by bkcik5 with SMTP id ik5so2063211bkc.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 05:34:06 -0700 (PDT)
Message-ID: <4F61E1BC.1020807@googlemail.com>
Date: Thu, 15 Mar 2012 13:34:04 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Rui Salvaterra <rsalvaterra@gmail.com>,
	=?UTF-8?B?RXplcXVpZWwgR2FyY8Ot?= =?UTF-8?B?YQ==?=
	<elezegarcia@gmail.com>, linux-media@vger.kernel.org
Subject: Re: eMPIA EM2710 Webcam (em28xx) and LIRC
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com> <CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com> <CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com> <CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com> <CALjTZvYJZ32Red-UfZXubB-Lk503DWbHGTL_kEoV4DVDDYJ46w@mail.gmail.com> <4F61C79E.6090603@redhat.com>
In-Reply-To: <4F61C79E.6090603@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.03.2012 11:42, schrieb Mauro Carvalho Chehab:
> Em 14-03-2012 21:28, Rui Salvaterra escreveu:
>> 2012/3/14 Ezequiel García <elezegarcia@gmail.com>:
>>> Hi,
>>>
>>> 2012/3/14 Rui Salvaterra <rsalvaterra@gmail.com>:
>>>> Hi, Ezequiel. Thanks a lot for your reply.
>>>> I'm attaching a copy of my full dmesg, its a bit hard to spot exactly
>>>> where all modules are loaded (since the boot sequence became
>>>> asynchronous).
>>> Indeed.
>>>
>>>>
>>>> Sure, no problem at all. I booted with em28xx disable_ir=1 and got the
>>>> same result. Additionally:
>>>>
>>>> rui@wilykat:~$ lsmod | grep ir
>>>> ir_lirc_codec          12901  0
>>>> lirc_dev               19204  1 ir_lirc_codec
>>>> ir_mce_kbd_decoder     12724  0
>>>> ir_sanyo_decoder       12513  0
>>>> ir_sony_decoder        12510  0
>>>> ir_jvc_decoder         12507  0
>>>> ir_rc6_decoder         12507  0
>>>> ir_rc5_decoder         12507  0
>>>> ir_nec_decoder         12507  0
>>>> rc_core                26373  9
>>>> ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,em28xx,ir_rc5_decoder,ir_nec_decoder
>>>> rui@wilykat:~$
>>> Mmmm...
>>> Are you completely sure that em28xx driver is triggering the load of
>>> the ir related modules?
>> I'm positive, the LIRC modules aren't loaded at all if I boot with the
>> webcam disconnected. As soon as I plug it into an USB port, em28xx and
>> LIRC are loaded.
>>
>>> Perhaps you could disable the module (blacklist, or compile out the
>>> module, or erase em28xx.ko to make sure)
>>> so you can see that effectively em28xx doesn't load and the rest of
>>> the modules doesn't load either,
>>> do you follow my line of reasoning?
>> Ok, I did some more testing, here's what I found out. If I blacklist
>> em28xx, no modules are loaded. Afterwards, I allowed em28xx to load
>> and appended
>>
>> blacklist rc_core
>> blacklist ir_lirc_codec
>> blacklist lirc_dev
>> blacklist ir_mce_kbd_decoder
>> blacklist ir_sanyo_decoder
>> blacklist ir_sony_decoder
>> blacklist ir_jvc_decoder
>> blacklist ir_rc6_decoder
>> blacklist ir_rc5_decoder
>> blacklist ir_nec_decoder
>>
>> to /etc/modprobe.d/blacklist.conf (basically blacklisted all LIRC
>> stuff), but it also didn't work. And I still have em28xx disable_ir=1.
> The em28xx module requires IR support from rc_core, as most em28xx devices
> support it. It can be compiled without IR support, but, as the em28xx-input
> is not on a separate module, and it contains some calls to rc_core functions
> like rc_register_device, modprobe will load rc_core, and rc_core will load
> the decoders, including lirc_dev.
>
> Those modules are small and won't be running if all you have are the webcams.
> The optimization to not load those modules is not big, so nobody had time
> yet to do it.
>
> Anyway, if you want to fix it, there are two possible approaches:
>
> 1) change rc_core to not load the IR decoders at load time, postponing it
>    to load only if a RC_DRIVER_IR_RAW device is registered via rc_register_device.
>   
> A patch for it shouldn't be hard. All you need to do is to move ir_raw_init()
> to rc_register_device() and add a logic there to call it for the first
> raw device.
>
> With such patch, rc_core module will still be loaded.
>
> 2) change em28xx-input.c to be a separate module, called only when a device
> has IR. It will need to have a logic similar to em28xx-dvb and em28xx-alsa
> modules.
>
> It is not hard to write such patch, as most of the logic is already there,
> but it is not as trivial as approach (1).
>
> It probably makes sense for both approaches (1) and (2), as not all boards
> support "raw" devices. In the case of em28xx, there's no device using "raw"
> mode, as the em28xx chips provide a hardware IR decoder. So, up to now, we
> didn't find any em28xx device requiring a software decoder for IR.
>
> If you want to write patches for the above, they'll be welcome.
>
> I hope that helps.
>
> Regards,
> Mauro
>

I would like to bring up the question, if it wouldn't make sense to move
support for the em27xx/28xx webcams to a separate gspca-subdriver.

I'm currently working on adding support for the VAD Laplace webcam
(em2765 + OV2640) (http://linuxtv.org/wiki/index.php/VAD_Laplace).
Lots of modifications to the em28xx driver would be necessary to support
this device because of some significant differences:
- supports only bulk transfers
- uses proprietary I2C-writes
- em25xx-eeprom
- ov2640 sensor

Lots of changes concerning the USB-interface probing, button handling,
video controls, frame processing and more would be necessary, too.

For reverse engineering purposes, I decided to write a gspca subdriver
for this device (will send a patch for testing/discussion soon).

I have no strong opinion about this, but I somehow feel that the em28xx
driver gets bloated more and more...

Regards,
Frank Schäfer

