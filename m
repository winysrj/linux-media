Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37795 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3CNHSx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 03:18:53 -0400
Received: by mail-ee0-f45.google.com with SMTP id b57so835055eek.18
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2013 00:18:52 -0700 (PDT)
Message-ID: <51417899.2070201@gmail.com>
Date: Thu, 14 Mar 2013 08:13:29 +0100
From: Benjamin Schindler <beschindler@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: msp3400 problem in linux-3.7.0
References: <51410709.5040805@gmail.com> <201303140757.10555.hverkuil@xs4all.nl>
In-Reply-To: <201303140757.10555.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

Thank you for the prompt response. I will try this once I'm home again.
Which patch is responsible for fixing it? Just so I can track it once it
lands upstream.

I have one more question - the wiki states the the WinTV-HVR-5500 is not
yet supported (as of June 2011) - is there an update on this? It's the
only DVB-C card I can buy in the local stores here

Thank you
Benjamin

On 03/14/2013 07:57 AM, Hans Verkuil wrote:
> On Thu March 14 2013 00:08:57 Benjamin Schindler wrote:
>> Hi
>>
>> I recently upgraded from 3.2 to 3.7 and noticed, that I don't get any 
>> sound anymore from my TV-card. tvtime still works fine, just with no 
>> sound. As you can see from the snippet below, I have a hauppage WinTV 
>> card which uses msp3400 for sound
> Yes, the bttv driver broke around that time and nobody noticed for a long
> time :-(
>
> You can try to build the latest code using these instructions:
>
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>
> bttv should now be working again.
>
> Note that you may experience problems building cx231xx. Disable that driver
> for now (run 'make menuconfig' in media_build). Hopefully the fix for that
> cx231xx bug will be merged soon.
>
> Regards,
>
> 	Hans
>
>> Here are the relevant snippets from the dmesg:
>>
>> [    3.539144] bttv: driver version 0.9.19 loaded
>> [    3.539147] bttv: using 8 buffers with 2080k (520 pages) each for capture
>> [    3.539169] bttv: Bt8xx card found (0)
>> [    3.539184] bttv: 0: Bt878 (rev 2) at 0000:07:01.0, irq: 17, latency: 
>> 32, mmio: 0xfbcff000
>> [    3.539211] bttv: 0: detected: Hauppauge WinTV [card=10], PCI 
>> subsystem ID is 0070:13eb
>> [    3.539212] bttv: 0: using: Hauppauge (bt878) [card=10,autodetected]
>> [    3.541740] bttv: 0: Hauppauge/Voodoo msp34xx: reset line init [5]
>> [    3.570092] nvidia: module license 'NVIDIA' taints kernel.
>> [    3.570095] Disabling lock debugging due to kernel taint
>> [    3.574636] tveeprom 1-0050: Hauppauge model 61344, rev D221, serial# 
>> 3755413
>> [    3.574640] tveeprom 1-0050: tuner model is Philips FM1216 (idx 21, 
>> type 5)
>> [    3.574641] tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
>> [    3.574643] tveeprom 1-0050: audio processor is MSP3415 (idx 6)
>> [    3.574644] tveeprom 1-0050: has radio
>> [    3.574646] bttv: 0: Hauppauge eeprom indicates model#61344
>> [    3.574647] bttv: 0: tuner type=5
>> [    3.579460] vgaarb: device changed decodes: 
>> PCI:0000:02:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
>> [    2.790332] ACPI: Invalid Power Resource to register!
>> [    3.579550] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  313.26 
>> Wed Feb 27 13:04:31 PST 2013
>>
>> [    3.581267] alsactl (1392) used greatest stack depth: 5064 bytes left
>> [    3.587405] msp3400 1-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
>> [    3.587407] msp3400 1-0040: msp3400 supports nicam, mode is autodetect
>> [    3.594664] tuner 1-0061: Tuner -1 found with type(s) Radio TV.
>> [    3.594972] tuner-simple 1-0061: creating new instance
>> [    3.594974] tuner-simple 1-0061: type set to 5 (Philips PAL_BG 
>> (FI1216 and compatibles))
>> [    3.595734] bttv: 0: registered device video0
>> [    3.595756] bttv: 0: registered device vbi0
>> [    3.595790] bttv: 0: registered device radio0
>> [    3.597514] bttv: 0: Setting PLL: 28636363 => 35468950 (needs up to 
>> 100ms)
>> [    3.619339] bttv: PLL set ok
>>
>> I'm also attaching my kernel config (self compiled using gentoo). As 
>> this is my first message, I don't know whether I have all the info you 
>> need. If not, just let me know
>>
>> Regards
>> Benjamin
>>

