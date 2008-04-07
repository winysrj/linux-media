Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.libero.it ([212.52.84.42])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sioux_it@libero.it>) id 1JiyaW-0005Yg-MD
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 23:09:14 +0200
Received: from MailRelay10.libero.it (192.168.32.119) by smtp-out2.libero.it
	(7.3.120) id 4688F31B1B092C50 for linux-dvb@linuxtv.org;
	Mon, 7 Apr 2008 23:08:38 +0200
Message-ID: <47FA8D34.6010900@libero.it>
Date: Mon, 07 Apr 2008 23:08:04 +0200
From: sioux <sioux_it@libero.it>
MIME-Version: 1.0
To: Christoph Honermann <Christoph.Honermann@web.de>
References: <1206652564.6924.22.camel@ubuntu> <47EC1668.5000608@t-online.de>
	<47FA70C3.5040808@web.de>
In-Reply-To: <47FA70C3.5040808@web.de>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: fixed pointer in tuner callback
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0914689873=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0914689873==
Content-Type: multipart/alternative;
 boundary="------------030505010900090908040902"

This is a multi-part message in MIME format.
--------------030505010900090908040902
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all!

here similar problem with 7134_alsa module:

saa7134_alsa: disagrees about version of symbol snd_ctl_add
saa7134_alsa: Unknown symbol snd_ctl_add
saa7134_alsa: disagrees about version of symbol snd_pcm_new
saa7134_alsa: Unknown symbol snd_pcm_new
saa7134_alsa: disagrees about version of symbol snd_card_register
saa7134_alsa: Unknown symbol snd_card_register
saa7134_alsa: disagrees about version of symbol snd_card_free
saa7134_alsa: Unknown symbol snd_card_free
saa7134_alsa: disagrees about version of symbol snd_pcm_stop
saa7134_alsa: Unknown symbol snd_pcm_stop
saa7134_alsa: disagrees about version of symbol snd_ctl_new1
saa7134_alsa: Unknown symbol snd_ctl_new1
saa7134_alsa: disagrees about version of symbol snd_card_new
saa7134_alsa: Unknown symbol snd_card_new
saa7134_alsa: disagrees about version of symbol snd_pcm_lib_ioctl
saa7134_alsa: Unknown symbol snd_pcm_lib_ioctl
saa7134_alsa: disagrees about version of symbol snd_pcm_set_ops
saa7134_alsa: Unknown symbol snd_pcm_set_ops
saa7134_alsa: disagrees about version of symbol 
snd_pcm_hw_constraint_integer
saa7134_alsa: Unknown symbol snd_pcm_hw_constraint_integer
saa7134_alsa: disagrees about version of symbol snd_pcm_period_elapsed
saa7134_alsa: Unknown symbol snd_pcm_period_elapsed
saa7134_alsa: disagrees about version of symbol snd_pcm_hw_constraint_step
saa7134_alsa: Unknown symbol snd_pcm_hw_constraint_step

This is my alsa version:
cat /proc/asound/version
advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Oct 16 
14:57:44 2007 UTC)

This is my kernel version:
uname -a
Linux sioux-desktop 2.6.22-14-rt #1 SMP PREEMPT RT Tue Feb 12 09:57:10 
UTC 2008 i686 GNU/Linux

This is my saa7134 version and card:

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:02:09.0, rev: 209, irq: 19, latency: 32, mmio: 
0xed000000
saa7133[0]: subsystem: 1822:0022, board: Twinhan Hybrid DTV-DVB 3056 PCI 
[card=131,autodetected]
saa7133[0]: board init: gpio is 40000
tuner' 0-0042: chip found @ 0x84 (saa7133[0])


Make rmmod do not solve the problem!

_______________________________________________________________

Christoph Honermann ha scritto:
> Hi, Hartmund
>
>
> Hartmut Hackmann schrieb:
>> Hi, Christoph
>>
>> Christoph Honermann schrieb:
>>   
>>> Hi, Hartmund
>>>
>>> I have tested the following archives with my MD8800 und the DVB-S Card.
>>>
>>> v4l-dvb-912856e2a0ce.tar.bz2 --> The DVB-S Input 1 works.
>>> The module of the following archives are loaded with the option
>>> "use_frontend=1,1" at the Shell or automatically:
>>>     /etc/modprobe.d/saa7134-dvb   with the following line
>>>    "options saa7134-dvb use_frontend=1,1"
>>> v4l-dvb-1e295a94038e.tar.bz2;
>>>
>>>     FATAL: Error inserting saa7134_dvb
>>>     (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko):
>>>     Unknown symbol in module, or unknown parameter (see dmesg)
>>>
>>>     saa7134_dvb: disagrees about version of symbol saa7134_ts_register
>>>     saa7134_dvb: Unknown symbol saa7134_ts_register
>>>     saa7134_dvb: Unknown symbol videobuf_queue_sg_init
>>>     saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
>>>     saa7134_dvb: Unknown symbol saa7134_set_gpio
>>>     saa7134_dvb: disagrees about version of symbol saa7134_i2c_call_client
>>>     saa7134_dvb: Unknown symbol saa7134_i2c_call_clients
>>>     saa7134_dvb: disagrees about version of symbol saa7134_ts_unregister
>>>     saa7134_dvb: Unknown symbol saa7134_ts_unregister
>>>
>>>
>>> v4l-dvb-f98d28c21389.tar.bz2  and v4l-dvb-a06ac2bdeb3c.tar.bz2 -->
>>>
>>>     FATAL: Error inserting saa7134_dvb
>>>     (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko):
>>>     Unknown symbol in module, or unknown parameter (see dmesg)
>>>
>>>     dmesg | grep saa7134
>>>     saa7134_dvb: Unknown symbol saa7134_tuner_callback
>>>     saa7134_dvb: disagrees about version of symbol saa7134_ts_register
>>>     saa7134_dvb: Unknown symbol saa7134_ts_register
>>>     saa7134_dvb: Unknown symbol videobuf_queue_sg_init
>>>     saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
>>>     saa7134_dvb: Unknown symbol saa7134_set_gpio
>>>
>>> The Hardware ist working with Windows XP with both Input channels.
>>>
>>>     
>> This occurs when you mix modules of different driver versions. You need to
>> replace all modules of the v4l-dvb subsystem.
>> So after you compiled and installed with
>>   make; make install
>> you need to unload all modules of the subsystem either with
>>   make rmmod
>> or reboot.
>> Afterwards, you can unload and reload a single module as you tried to do.
>>
>> Hartmut
>>
>>   
> the second DVB-S Channel is working.
> But there is one thing that makes Problems.
> I have the effect that the devices /dev/dvb/adapter0/dvr0 and 
> /dev/dvb/adapter1/dvr0 are missed from kaffeine. Therefore it wont 
> work (no TV-picture, no sound, no channel scanning).
> If i look with Nautilus (file manager) therefore the whole Section 
> /dev/dvb is switching off.
> Can that be an effect of the module?
> The Problem is sometimes not there but i don't find the reason 
> (changing the Modules, reboots, ..). If I solve the Problem, should I 
> test the kombination between DVB-S and DVB-T?
>
> Best regards
> Christoph
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

--------------030505010900090908040902
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=UTF-8" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Hi all!<br>
<br>
here similar problem with 7134_alsa module:<br>
<br>
saa7134_alsa: disagrees about version of symbol snd_ctl_add<br>
saa7134_alsa: Unknown symbol snd_ctl_add<br>
saa7134_alsa: disagrees about version of symbol snd_pcm_new<br>
saa7134_alsa: Unknown symbol snd_pcm_new<br>
saa7134_alsa: disagrees about version of symbol snd_card_register<br>
saa7134_alsa: Unknown symbol snd_card_register<br>
saa7134_alsa: disagrees about version of symbol snd_card_free<br>
saa7134_alsa: Unknown symbol snd_card_free<br>
saa7134_alsa: disagrees about version of symbol snd_pcm_stop<br>
saa7134_alsa: Unknown symbol snd_pcm_stop<br>
saa7134_alsa: disagrees about version of symbol snd_ctl_new1<br>
saa7134_alsa: Unknown symbol snd_ctl_new1<br>
saa7134_alsa: disagrees about version of symbol snd_card_new<br>
saa7134_alsa: Unknown symbol snd_card_new<br>
saa7134_alsa: disagrees about version of symbol snd_pcm_lib_ioctl<br>
saa7134_alsa: Unknown symbol snd_pcm_lib_ioctl<br>
saa7134_alsa: disagrees about version of symbol snd_pcm_set_ops<br>
saa7134_alsa: Unknown symbol snd_pcm_set_ops<br>
saa7134_alsa: disagrees about version of symbol
snd_pcm_hw_constraint_integer<br>
saa7134_alsa: Unknown symbol snd_pcm_hw_constraint_integer<br>
saa7134_alsa: disagrees about version of symbol snd_pcm_period_elapsed<br>
saa7134_alsa: Unknown symbol snd_pcm_period_elapsed<br>
saa7134_alsa: disagrees about version of symbol
snd_pcm_hw_constraint_step<br>
saa7134_alsa: Unknown symbol snd_pcm_hw_constraint_step<br>
<br>
This is my alsa version:<br>
cat /proc/asound/version<br>
advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Oct 16
14:57:44 2007 UTC)<br>
<br>
This is my kernel version:<br>
uname -a<br>
Linux sioux-desktop 2.6.22-14-rt #1 SMP PREEMPT RT Tue Feb 12 09:57:10
UTC 2008 i686 GNU/Linux<br>
<br>
This is my saa7134 version and card:<br>
<br>
saa7130/34: v4l2 driver version 0.2.14 loaded<br>
saa7133[0]: found at 0000:02:09.0, rev: 209, irq: 19, latency: 32,
mmio: 0xed000000<br>
saa7133[0]: subsystem: 1822:0022, board: Twinhan Hybrid DTV-DVB 3056
PCI [card=131,autodetected]<br>
saa7133[0]: board init: gpio is 40000<br>
tuner' 0-0042: chip found @ 0x84 (saa7133[0])<br>
<br>
<br>
Make rmmod do not solve the problem!<br>
<br>
_______________________________________________________________<br>
<br>
Christoph Honermann ha scritto:
<blockquote cite="mid:47FA70C3.5040808@web.de" type="cite">
  <meta content="text/html;charset=UTF-8" http-equiv="Content-Type">
  <title></title>
Hi, Hartmund<br>
  <br>
  <br>
Hartmut Hackmann schrieb:
  <blockquote cite="mid:47EC1668.5000608@t-online.de" type="cite">
    <pre wrap="">Hi, Christoph

Christoph Honermann schrieb:
  </pre>
    <blockquote type="cite">
      <pre wrap="">Hi, Hartmund

I have tested the following archives with my MD8800 und the DVB-S Card.

v4l-dvb-912856e2a0ce.tar.bz2 --&gt; The DVB-S Input 1 works.
The module of the following archives are loaded with the option
"use_frontend=1,1" at the Shell or automatically:
    /etc/modprobe.d/saa7134-dvb   with the following line
   "options saa7134-dvb use_frontend=1,1"
v4l-dvb-1e295a94038e.tar.bz2;

    FATAL: Error inserting saa7134_dvb
    (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko):
    Unknown symbol in module, or unknown parameter (see dmesg)

    saa7134_dvb: disagrees about version of symbol saa7134_ts_register
    saa7134_dvb: Unknown symbol saa7134_ts_register
    saa7134_dvb: Unknown symbol videobuf_queue_sg_init
    saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
    saa7134_dvb: Unknown symbol saa7134_set_gpio
    saa7134_dvb: disagrees about version of symbol saa7134_i2c_call_client
    saa7134_dvb: Unknown symbol saa7134_i2c_call_clients
    saa7134_dvb: disagrees about version of symbol saa7134_ts_unregister
    saa7134_dvb: Unknown symbol saa7134_ts_unregister


v4l-dvb-f98d28c21389.tar.bz2  and v4l-dvb-a06ac2bdeb3c.tar.bz2 --&gt;

    FATAL: Error inserting saa7134_dvb
    (/lib/modules/2.6.22-14-generic/kernel/drivers/media/video/saa7134/saa7134-dvb.ko):
    Unknown symbol in module, or unknown parameter (see dmesg)

    dmesg | grep saa7134
    saa7134_dvb: Unknown symbol saa7134_tuner_callback
    saa7134_dvb: disagrees about version of symbol saa7134_ts_register
    saa7134_dvb: Unknown symbol saa7134_ts_register
    saa7134_dvb: Unknown symbol videobuf_queue_sg_init
    saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
    saa7134_dvb: Unknown symbol saa7134_set_gpio

The Hardware ist working with Windows XP with both Input channels.

    </pre>
    </blockquote>
    <pre wrap=""><!---->This occurs when you mix modules of different driver versions. You need to
replace all modules of the v4l-dvb subsystem.
So after you compiled and installed with
  make; make install
you need to unload all modules of the subsystem either with
  make rmmod
or reboot.
Afterwards, you can unload and reload a single module as you tried to do.

Hartmut

  </pre>
  </blockquote>
the second DVB-S Channel is working.<br>
But there is one thing that makes Problems.<br>
I have the effect that the devices /dev/dvb/adapter0/dvr0 and
/dev/dvb/adapter1/dvr0 are missed from kaffeine. Therefore it wont
work (no TV-picture, no sound, no channel scanning).<br>
If i look with Nautilus (file manager) therefore the whole Section
/dev/dvb is switching off.<br>
Can that be an effect of the module?<br>
The Problem is sometimes not there but i don't find the reason
(changing the Modules, reboots, ..). If I solve the Problem, should I
test the kombination between DVB-S and DVB-T?<br>
  <br>
Best regards<br>
Christoph<br>
  <br>
  <pre wrap="">
<hr size="4" width="90%">
_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></pre>
</blockquote>
</body>
</html>

--------------030505010900090908040902--


--===============0914689873==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0914689873==--
