Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62674 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab2COA2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 20:28:18 -0400
Received: by ghrr11 with SMTP id r11so2480517ghr.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 17:28:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com>
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com>
	<CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com>
	<CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com>
	<CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com>
Date: Thu, 15 Mar 2012 00:28:17 +0000
Message-ID: <CALjTZvYJZ32Red-UfZXubB-Lk503DWbHGTL_kEoV4DVDDYJ46w@mail.gmail.com>
Subject: Re: eMPIA EM2710 Webcam (em28xx) and LIRC
From: Rui Salvaterra <rsalvaterra@gmail.com>
To: =?UTF-8?Q?Ezequiel_Garc=C3=ADa?= <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/14 Ezequiel García <elezegarcia@gmail.com>:
> Hi,
>
> 2012/3/14 Rui Salvaterra <rsalvaterra@gmail.com>:
>>
>> Hi, Ezequiel. Thanks a lot for your reply.
>> I'm attaching a copy of my full dmesg, its a bit hard to spot exactly
>> where all modules are loaded (since the boot sequence became
>> asynchronous).
>
> Indeed.
>
>>
>>
>> Sure, no problem at all. I booted with em28xx disable_ir=1 and got the
>> same result. Additionally:
>>
>> rui@wilykat:~$ lsmod | grep ir
>> ir_lirc_codec          12901  0
>> lirc_dev               19204  1 ir_lirc_codec
>> ir_mce_kbd_decoder     12724  0
>> ir_sanyo_decoder       12513  0
>> ir_sony_decoder        12510  0
>> ir_jvc_decoder         12507  0
>> ir_rc6_decoder         12507  0
>> ir_rc5_decoder         12507  0
>> ir_nec_decoder         12507  0
>> rc_core                26373  9
>> ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,em28xx,ir_rc5_decoder,ir_nec_decoder
>> rui@wilykat:~$
>
> Mmmm...
> Are you completely sure that em28xx driver is triggering the load of
> the ir related modules?

I'm positive, the LIRC modules aren't loaded at all if I boot with the
webcam disconnected. As soon as I plug it into an USB port, em28xx and
LIRC are loaded.

> Perhaps you could disable the module (blacklist, or compile out the
> module, or erase em28xx.ko to make sure)
> so you can see that effectively em28xx doesn't load and the rest of
> the modules doesn't load either,
> do you follow my line of reasoning?

Ok, I did some more testing, here's what I found out. If I blacklist
em28xx, no modules are loaded. Afterwards, I allowed em28xx to load
and appended

blacklist rc_core
blacklist ir_lirc_codec
blacklist lirc_dev
blacklist ir_mce_kbd_decoder
blacklist ir_sanyo_decoder
blacklist ir_sony_decoder
blacklist ir_jvc_decoder
blacklist ir_rc6_decoder
blacklist ir_rc5_decoder
blacklist ir_nec_decoder

to /etc/modprobe.d/blacklist.conf (basically blacklisted all LIRC
stuff), but it also didn't work. And I still have em28xx disable_ir=1.

>
> I'm also no kernel expert, just trying to be helpful.
>
> Hope it helps,
> Ezequiel.

Every bit of help is appreciated, thanks a lot! :)
