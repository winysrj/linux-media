Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:38324 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIETqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Sep 2009 15:46:49 -0400
Received: by yxe5 with SMTP id 5so3864289yxe.33
        for <linux-media@vger.kernel.org>; Sat, 05 Sep 2009 12:46:51 -0700 (PDT)
Message-ID: <4AA2C043.3020107@gmail.com>
Date: Sun, 06 Sep 2009 05:47:15 +1000
From: Jed <jedi.theone@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: generic question
References: <4AA28EBB.5070401@gmail.com> <4AA290CF.5000806@gmail.com> <4AA2B63A.4060907@gmail.com>
In-Reply-To: <4AA2B63A.4060907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think I know why this was not working...
I was using main hg source tree instead of: http://www.jusst.de/hg/saa716x/
My bad, still quite a n00b I guess, but at least I'm learning! :-)

I will take it from there....


Jed wrote:
> The compile & install completed without issue then I rebooted but....
>
> jed@jed-desktop:/var/log$ sudo lsmod
> Module                  Size  Used by
> binfmt_misc            18572  1
> bridge                 63776  0
> stp                    11140  1 bridge
> bnep                   22912  2
> video                  29204  0
> output                 11648  1 video
> input_polldev          12688  0
> lp                     19588  0
> snd_hda_intel         557492  4
> snd_pcm_oss            52352  0
> snd_mixer_oss          24960  1 snd_pcm_oss
> snd_pcm                99464  2 snd_hda_intel,snd_pcm_oss
> snd_seq_dummy          11524  0
> snd_seq_oss            41984  0
> snd_seq_midi           15744  0
> snd_rawmidi            33920  1 snd_seq_midi
> snd_seq_midi_event     16512  2 snd_seq_oss,snd_seq_midi
> snd_seq                66272  6 
> snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
> snd_timer              34064  2 snd_pcm,snd_seq
> iTCO_wdt               21712  0
> snd_seq_device         16276  5 
> snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
> pcspkr                 11136  0
> ppdev                  16904  0
> iTCO_vendor_support    12420  1 iTCO_wdt
> snd                    78920  17 
> snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device 
>
> soundcore              16800  1 snd
> snd_page_alloc         18704  2 snd_hda_intel,snd_pcm
> parport_pc             45096  1
> parport                49584  3 lp,ppdev,parport_pc
> usbhid                 47040  0
> intel_agp              39408  0
> ohci1394               42164  0
> ieee1394              108288  1 ohci1394
> r8169                  46596  0
> mii                    14464  1 r8169
> fbcon                  49792  0
> tileblit               11264  1 fbcon
> font                   17024  1 fbcon
> bitblit                14464  1 fbcon
> softcursor             10368  1 bitblit
>
> ...Where's the module I need?
>
> And this is all that's in /etc/modules...
>
> lp
> rtc
>
> udev has not created any devices nodes for DVB & V4L:
>
> jed@jed-desktop:/var/log$ ls -l /dev/dvb
> ls: cannot access /dev/dvb: No such file or directory
> jed@jed-desktop:/var/log$ ls -l /dev/v4l
> ls: cannot access /dev/v4l: No such file or directory
>
> I can't see anything relating to 7162 devices here:
> http://linuxtv.org/hg/v4l-dvb?cmd=file;file=linux/Documentation/video4linux/CARDLIST.tuner;filenode=-1;style=raw 
>
> Perhaps the module for 7162 devices is not in the main source tree 
> yet? Admittedly I'm not quite sure what I'm looking for!
>
> I've got a copy of various logs from /var/log, many extraneous, but 
> just trying to cover all bases, lemme know & I can send!
> Any advice/help greatly appreciated.
>
> Cheers,
> Jed
>
>
> Jed wrote:
>> Actually I just realised...
>>
>> I think when the system reboots it will only load the modules it 
>> needs from /lib/modules/[kernel version]/kernel/drivers/media...
>> It won't load everything in that directory into the kernel/memory right?
>>
>> So the only reason one might want to use "make menuconfig"; is to 
>> prevent irrelevant compiled modules ending up in...
>> /lib/modules/[kernel version]/kernel/drivers/media
>>
>> Feel free to correct if this understanding is wrong.
>>
>> Cheers
>>
>> Jed wrote:
>>> I installed _all_ dvb-v4l modules after compiling latest source 
>>> because at the time I couldn't use "make menuconfig" (didn't have 
>>> ncurses installed)
>>> Is there a way I can retrospectively remove some compiled/installed 
>>> modules so that I'm only using the ones I need?
>>> I only need modules associated with: 
>>> http://www.linuxtv.org/wiki/index.php/Saa7162_devices#DNTV_PCI_Express_cards 
>>>
>>>
>>> Cheers,
>>> Jed
>>>
>>
>>
>
>

