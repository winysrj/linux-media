Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:60048
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZHQOiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 10:38:01 -0400
Cc: linux-media@vger.kernel.org
Message-Id: <84CB1AA0-2C5D-4326-9240-11A38FC582DC@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: tfjellstrom@shaw.ca
In-Reply-To: <200908140903.29582.tfjellstrom@shaw.ca>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: KWorld UB435-Q support?
Date: Mon, 17 Aug 2009 10:37:57 -0400
References: <200908122253.12021.tfjellstrom@shaw.ca> <200908132312.50010.tfjellstrom@shaw.ca> <86D220D2-D88C-44F9-8650-D782CC5284EE@wilsonet.com> <200908140903.29582.tfjellstrom@shaw.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Aug 14, 2009, at 11:03 AM, Thomas Fjellstrom wrote:

> On Fri August 14 2009, Jarod Wilson wrote:
>> On Aug 14, 2009, at 1:12 AM, Thomas Fjellstrom wrote:
>>> On Thu August 13 2009, Jarod Wilson wrote:
>>>> On Aug 13, 2009, at 12:53 AM, Thomas Fjellstrom wrote:
>>>>> I stupidly bought the KWorld UB435-Q usb ATSC tuner thinking it  
>>>>> was
>>>>> supported
>>>>> under linux, and it turns out it isn't. I'm wondering what it  
>>>>> would
>>>>> take to
>>>>> get it supported. It seems like all of the main chips it uses are
>>>>> supported,
>>>>> but the glue code is missing.
>>>>>
>>>>> I have some C (10 years) programming experience, and have wanted  
>>>>> to
>>>>> contribute
>>>>> to the linux kernel for quite a while, now I have a good excuse ;)
>>>>>
>>>>> Would anyone be willing to point me in the right direction?
>>>>
>>>> The UB435-Q is a rebadge of the revision B 340U, which is an em2870
>>>> bridge, lgdt3304 demodulator and an nxp tda18271hd/c2 tuner. Its  
>>>> got
>>>> the same device ID and everything. I've got a rev A 340U, the only
>>>> difference being that it has an nxp tda18271hd/c1 tuner (also same
>>>> device ID). I *had* it working just fine until the stick up and  
>>>> died
>>>> on me, before I could push the code for merge, but its still  
>>>> floating
>>>> about. It wasn't quite working with a c2 device, but that could  
>>>> have
>>>> been a device problem (these are quite franky, cheap and poorly  
>>>> made
>>>> devices, imo). It could also be that the code ate both sticks and
>>>> will
>>>> pickle yours as well.
>>>>
>>>> With that caveat emptor, here's where the tree that should at least
>>>> get you 95% of the way there with that stick resides:
>>>>
>>>> http://www.kernellabs.com/hg/~mkrufky/lgdt3304-3/
>>>>
>>>> The last two patches are the relevant ones. They add lgdt3304 demod
>>>> support to the lgdt3305 driver (because the current lgdt3304 driver
>>>> is, um, lacking) and then add the bits to wire up the stick.
>>>
>>> Hi, thanks for the tips. I've applied the last two patches to v4l
>>> "tip", a few
>>> hunks failed, but I managed to apply them by hand, though possibly  
>>> not
>>> correctly as I can't seem to find a program that thinks the /dev/
>>> video0 device
>>> that pops up is valid. One app claims there is no input on /dev/
>>> video0, and
>>> others just get "select timeouts" and such (also errors regarding
>>> formats and
>>> whatnot).
>>
>> These sticks are digital-only. Its a driver shortcoming that the
>> *analog* /dev/video0 device is being created. You need to be  
>> hitting /
>> dev/dvb/adapterX/*, not /dev/video0. See
>> http://linuxtv.org/wiki/index.php/Testing_your_DVB_device
>
> Ah, thanks for that.
>
> So far I've noticed the lgdt driver is very NOT robust, or maybe its  
> one of
> the other drivers (em28xx?) causing it to die, but if the stick looses
> connection with usb at all, the driver locks up, spews a BUNCH of  
> errors to
> dmesg, and eventually the kernel complains:
>
> [  840.552148] INFO: task khubd:170 blocked for more than 120 seconds.
> [  840.552155] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"  
> disables
> this message.
> [  840.552162] khubd         D ffff8800010220c0     0   170      2
> [  840.552172]  ffff88003793a500 0000000000000046 ffff88007bd2f600
> 0000000000000286
> [  840.552182]  ffff88007a011900 00000000000120c0 000000000000e250
> ffff88007d13a3c0
> [  840.552191]  ffff88007d13a6b0 000000008034e421 ffff88007bd3d800
> ffffffffa046a7c8
> [  840.552200] Call Trace:
> [  840.552220]  [<ffffffff804b4810>] ? schedule+0x9/0x1d
> [  840.552243]  [<ffffffffa046d9ce>] ? dvb_dmxdev_release+0xd8/0x119
> [dvb_core]
> [  840.552253]  [<ffffffff80254736>] ? autoremove_wake_function 
> +0x0/0x2e
> [  840.552265]  [<ffffffffa00dd06e>] ? dvb_fini+0x5b/0x91 [em28xx_dvb]
> [  840.552289]  [<ffffffffa045b099>] ? em28xx_close_extension 
> +0x35/0x56
> [em28xx]
> [  840.552308]  [<ffffffffa0459654>] ? em28xx_usb_disconnect 
> +0xf4/0x120
> [em28xx]
> [  840.552319]  [<ffffffff803e3628>] ? usb_unbind_interface+0x5b/0xe1
> [  840.552329]  [<ffffffff803d2618>] ? __device_release_driver 
> +0x77/0x9e
> [  840.552336]  [<ffffffff803d26f7>] ? device_release_driver+0x1e/0x2a
> [  840.552344]  [<ffffffff803d1d7d>] ? bus_remove_device+0x8d/0xac
> [  840.552352]  [<ffffffff803d07ad>] ? device_del+0x130/0x198
> [  840.552359]  [<ffffffff803e0d91>] ? usb_disable_device+0x6c/0xe4
> [  840.552370]  [<ffffffff803dc9f4>] ? usb_disconnect+0x8c/0x10a
> [  840.552378]  [<ffffffff803dd9a1>] ? hub_thread+0x625/0x1040
> [  840.552387]  [<ffffffff80235f65>] ? dequeue_entity+0xf/0x11f
> [  840.552395]  [<ffffffff80254736>] ? autoremove_wake_function 
> +0x0/0x2e
> [  840.552403]  [<ffffffff803dd37c>] ? hub_thread+0x0/0x1040
> [  840.552410]  [<ffffffff803dd37c>] ? hub_thread+0x0/0x1040
> [  840.552418]  [<ffffffff803dd37c>] ? hub_thread+0x0/0x1040
> [  840.552427]  [<ffffffff8025437a>] ? kthread+0x54/0x80
> [  840.552435]  [<ffffffff80210aca>] ? child_rip+0xa/0x20
> [  840.552444]  [<ffffffff80254326>] ? kthread+0x0/0x80
> [  840.552450]  [<ffffffff80210ac0>] ? child_rip+0x0/0x20
>
> I'm assuming the only way to restore any kind of function is to reboot
> (rmmoding em28xx_dbv hangs, and rmmod is unkillable).
>
> I'll try working with this a bit more tomorrow (if I can figure out  
> why its
> hanging), as it is I'm off for some sleep :)


Huh, that looks nothing like anything I ever saw with my stick.  
However, I will note that mine seemed to have major issues keeping a  
solid physical connection to the usb bus, but it only manifested as  
huge amounts of packet loss. These are cheaply made devices that I  
have little faith in now...

-- 
Jarod Wilson
jarod@wilsonet.com



