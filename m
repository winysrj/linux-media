Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout10.t-online.de ([194.25.134.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1Jjgvo-0007AO-Ry
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 22:30:09 +0200
Message-ID: <47FD2748.7080203@t-online.de>
Date: Wed, 09 Apr 2008 22:30:00 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: sioux <sioux_it@libero.it>
References: <1206652564.6924.22.camel@ubuntu> <47EC1668.5000608@t-online.de>
	<47FA70C3.5040808@web.de> <47FA8D34.6010900@libero.it>
	<47FBD252.3090701@t-online.de> <47FD1C72.8050208@libero.it>
In-Reply-To: <47FD1C72.8050208@libero.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: fixed pointer in tuner callback
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

sioux schrieb:
> 
> 
> Hartmut Hackmann ha scritto:
>> Hi,
>>
>> sioux schrieb:
>>> Hi all!
>>>
>>> here similar problem with 7134_alsa module:
>>>
>>> saa7134_alsa: disagrees about version of symbol snd_ctl_add
>>> saa7134_alsa: Unknown symbol snd_ctl_add
>>> saa7134_alsa: disagrees about version of symbol snd_pcm_new
>>> saa7134_alsa: Unknown symbol snd_pcm_new
>>> saa7134_alsa: disagrees about version of symbol snd_card_register
>>> saa7134_alsa: Unknown symbol snd_card_register
>>> saa7134_alsa: disagrees about version of symbol snd_card_free
>>> saa7134_alsa: Unknown symbol snd_card_free
>>> saa7134_alsa: disagrees about version of symbol snd_pcm_stop
>>> saa7134_alsa: Unknown symbol snd_pcm_stop
>>> saa7134_alsa: disagrees about version of symbol snd_ctl_new1
>>> saa7134_alsa: Unknown symbol snd_ctl_new1
>>> saa7134_alsa: disagrees about version of symbol snd_card_new
>>> saa7134_alsa: Unknown symbol snd_card_new
>>> saa7134_alsa: disagrees about version of symbol snd_pcm_lib_ioctl
>>> saa7134_alsa: Unknown symbol snd_pcm_lib_ioctl
>>> saa7134_alsa: disagrees about version of symbol snd_pcm_set_ops
>>> saa7134_alsa: Unknown symbol snd_pcm_set_ops
>>> saa7134_alsa: disagrees about version of symbol 
>>> snd_pcm_hw_constraint_integer
>>> saa7134_alsa: Unknown symbol snd_pcm_hw_constraint_integer
>>> saa7134_alsa: disagrees about version of symbol snd_pcm_period_elapsed
>>> saa7134_alsa: Unknown symbol snd_pcm_period_elapsed
>>> saa7134_alsa: disagrees about version of symbol 
>>> snd_pcm_hw_constraint_step
>>> saa7134_alsa: Unknown symbol snd_pcm_hw_constraint_step
>>>
>>> This is my alsa version:
>>> cat /proc/asound/version
>>> advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Oct 16 
>>> 14:57:44 2007 UTC)
>>>
>>> This is my kernel version:
>>> uname -a
>>> Linux sioux-desktop 2.6.22-14-rt #1 SMP PREEMPT RT Tue Feb 12 
>>> 09:57:10 UTC 2008 i686 GNU/Linux
>>>
>>> This is my saa7134 version and card:
>>>
>>> saa7130/34: v4l2 driver version 0.2.14 loaded
>>> saa7133[0]: found at 0000:02:09.0, rev: 209, irq: 19, latency: 32, 
>>> mmio: 0xed000000
>>> saa7133[0]: subsystem: 1822:0022, board: Twinhan Hybrid DTV-DVB 3056 
>>> PCI [card=131,autodetected]
>>> saa7133[0]: board init: gpio is 40000
>>> tuner' 0-0042: chip found @ 0x84 (saa7133[0])
>>>
>>>
>>> Make rmmod do not solve the problem!
>>>
>> <snip> _______________________________________________________________
>>
>> A "make rmmod" does *not* always work: If a device is in use, the 
>> kernel will
>> refuse to remove the module. You should find an appropriate error 
>> message.
>> You can have i.e. this situation:
>> If you load the modules a boot time and you run kde, the mixer desktop 
>> applet
>> will open the mixer of the saa7134-alsa device.
>> So you will not be able to unload and thus update the driver before 
>> you closed
>> the kmix applet.
>> There are many other possibilities.
>>
>> Hartmut
>>
> sudo killall mixer_applet2
> sudo rmmod saa7134 saa7134_alsa saa7134_dvb
> 
> and than sudo make rmmod
> 
> does not solve the problem!
> 
> sioux
> 
> 
> 
Does anybody else have an idea what the reason might be?
The handling of kernel symbol versions is tricky, i have no idea
what sioux might have done wrong.
But the patch in question does not even touch the sound code...

Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
