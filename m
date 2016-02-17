Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:42394 "EHLO
	v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220AbcBQVyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 16:54:54 -0500
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
To: Olli Salonen <olli.salonen@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1436697509.2446.14.camel@xs4all.nl>
 <1440352250.13381.3.camel@xs4all.nl> <55F332FE.7040201@mbox200.swipnet.se>
 <1442041326.2442.2.camel@xs4all.nl>
 <CAAZRmGxvrXjanCTcd0Ybk-qzHhqO5e6JhrpSWxNXSa+zzPsdUg@mail.gmail.com>
 <1454007436.13371.4.camel@xs4all.nl>
 <CAAZRmGwuinufZpCpTs8t+BRyTcfio-4z34PCKH7Ha3J+dxXNqw@mail.gmail.com>
 <56ADCBE4.6050609@mbox200.swipnet.se>
 <CAAZRmGy21S+qkrC9d0hz02J98woUc9p+LtnhK8Det=yWmb_myg@mail.gmail.com>
 <56C3ACF6.1030106@mbox200.swipnet.se>
 <CAAZRmGyfXKVJ4VNsdMDuLiRjX90S_3hWdXKO_ybmaWgYQXEoeA@mail.gmail.com>
 <CAAZRmGxJz8wiuvW-14+hGCgta_XTKe9n2+F6L_UHWX1_cOCtWA@mail.gmail.com>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <56C4EC2B.60400@mbox200.swipnet.se>
Date: Wed, 17 Feb 2016 22:54:51 +0100
MIME-Version: 1.0
In-Reply-To: <CAAZRmGxJz8wiuvW-14+hGCgta_XTKe9n2+F6L_UHWX1_cOCtWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

testing is likely to be a bit problematic because using the most recent 
code from media_tree results in the following during module load and 
after this the modules are not loaded properly (/dev/dvb missing)

i will retry with older code.


[    5.558524] WARNING: You are using an experimental version of the 
media stack.
                 As the driver is backported to an older kernel, it 
doesn't offer
                 enough quality for its usage in production.
                 Use it with care.
                Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
                 3d0ccad0dbbd51b64d307c64cc163002334afbfa [media] siano: 
use generic function to create MC device
                 dd47fbd40e6ea6884e295e13a2e50b0894258fdf [media] 
smsusb: don't sleep while atomic
                 21cf734c79e6c741dcdf383dbaef3b551b931568 [media] siano: 
firmware buffer is too small
[    5.750834] usb 1-2: dvb_usb_v2: found a 'TechnoTrend TT-connect 
CT2-4650 CI v1.1' in warm state
[    5.751737] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[    5.751754] DVB: registering new adapter (TechnoTrend TT-connect 
CT2-4650 CI v1.1)
[    5.751799] usb 1-2: media controller created
[    5.754172] usb 1-2: dvb_usb_v2: MAC address: bc:ea:2b:65:06:6f
[    5.754527] dvb_create_media_entity: media entity 'dvb-demux' registered.
[    5.761734] i2c i2c-1: Added multiplexed i2c bus 2
[    5.761738] si2168 1-0064: Silicon Labs Si2168 successfully attached
[    5.767308] si2157 2-0060: Silicon Labs Si2147/2148/2157/2158 
successfully attached
[    5.776422] dvb_create_media_entity: media entity 'dvb-ca-en50221' 
registered.
[    5.777199] sp2 1-0040: CIMaX SP2 successfully attached
[    5.777211] usb 1-2: DVB: registering adapter 0 frontend 0 (Silicon 
Labs Si2168)...
[    5.777214] dvb_create_media_entity: media entity 'Silicon Labs 
Si2168' registered.
[    5.780048] ------------[ cut here ]------------
[    5.780059] WARNING: CPU: 1 PID: 568 at lib/idr.c:1051 
ida_remove+0xef/0x120()
[    5.780060] ida_remove called for id=512 which is not allocated.
[    5.780061] Modules linked in: sp2(OE) si2157(OE) si2168(OE) 
dvb_usb_dvbsky(OE+) m88ds3103(OE) dvb_usb_v2(OE) i2c_mux dvb_core(OE) 
rc_core(OE) videodev(OE) media(OE) iosf_mbi ppdev crct10dif_pclmul 
crc32_pclmul crc32c_intel snd_hda_codec_generic snd_hda_intel 
snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm 
parport_pc joydev snd_timer snd parport virtio_balloon soundcore pvpanic 
i2c_piix4 acpi_cpufreq tpm_tis tpm qxl 8021q drm_kms_helper garp stp llc 
mrp virtio_blk ttm virtio_net virtio_console drm serio_raw virtio_pci 
virtio_ring ata_generic virtio pata_acpi
[    5.780086] CPU: 1 PID: 568 Comm: systemd-udevd Tainted: G 
OE   4.3.4-200.fc22.x86_64 #1
[    5.780087] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.780089]  0000000000000000 0000000069734069 ffff88007c23b6f8 
ffffffff813a625f
[    5.780090]  ffff88007c23b740 ffff88007c23b730 ffffffff810a07c2 
ffff88003680ac08
[    5.780092]  ffff88003680ac08 0000000000000206 ffff88007b7a4500 
ffff88007b43e158
[    5.780094] Call Trace:
[    5.780097]  [<ffffffff813a625f>] dump_stack+0x44/0x55
[    5.780100]  [<ffffffff810a07c2>] warn_slowpath_common+0x82/0xc0
[    5.780102]  [<ffffffff810a085c>] warn_slowpath_fmt+0x5c/0x80
[    5.780107]  [<ffffffff813bab85>] ? find_next_bit+0x15/0x20
[    5.780109]  [<ffffffff813a73ff>] ida_remove+0xef/0x120
[    5.780110]  [<ffffffff813a7e7b>] ida_simple_remove+0x2b/0x50
[    5.780114]  [<ffffffffa022404d>] 
__media_device_unregister_entity+0x2d/0xd0 [media]
[    5.780116]  [<ffffffffa022411c>] 
media_device_unregister_entity+0x2c/0x40 [media]
[    5.780119]  [<ffffffffa02770ff>] dvb_media_device_free+0x1f/0x130 
[dvb_core]
[    5.780122]  [<ffffffffa0277252>] dvb_unregister_device+0x42/0x80 
[dvb_core]
[    5.780125]  [<ffffffffa027da05>] dvb_ca_en50221_release+0x75/0xb0 
[dvb_core]
[    5.780127]  [<ffffffffa02af289>] sp2_remove+0x49/0xa0 [sp2]
[    5.780134]  [<ffffffff815dc18b>] i2c_device_remove+0x4b/0xa0
[    5.780137]  [<ffffffff814d9501>] __device_release_driver+0xa1/0x150
[    5.780141]  [<ffffffff814d95d3>] device_release_driver+0x23/0x30
[    5.780143]  [<ffffffff814d8c21>] bus_remove_device+0x101/0x170
[    5.780145]  [<ffffffff814d4ec9>] device_del+0x139/0x260
[    5.780147]  [<ffffffff813a8647>] ? kobject_put+0x27/0x50
[    5.780149]  [<ffffffff815dc680>] ? __unregister_dummy+0x30/0x30
[    5.780151]  [<ffffffff814d500e>] device_unregister+0x1e/0x60
[    5.780153]  [<ffffffff815dc6be>] __unregister_client+0x3e/0x50
[    5.780154]  [<ffffffff814d4970>] device_for_each_child+0x50/0x90
[    5.780156]  [<ffffffff815de99e>] i2c_del_adapter+0x20e/0x300
[    5.780166]  [<ffffffff81203ed8>] ? kfree+0x128/0x130
[    5.780169]  [<ffffffffa025c974>] dvb_usbv2_exit+0x1c4/0x3c0 [dvb_usb_v2]
[    5.780171]  [<ffffffffa025d44f>] dvb_usbv2_probe+0xff/0x1200 
[dvb_usb_v2]
[    5.780174]  [<ffffffff814e4619>] ? __pm_runtime_set_status+0x189/0x230
[    5.780182]  [<ffffffff81570282>] usb_probe_interface+0x1b2/0x2d0
[    5.780184]  [<ffffffff814d9b82>] driver_probe_device+0x222/0x480
[    5.780185]  [<ffffffff814d9e64>] __driver_attach+0x84/0x90
[    5.780187]  [<ffffffff814d9de0>] ? driver_probe_device+0x480/0x480
[    5.780188]  [<ffffffff814d765c>] bus_for_each_dev+0x6c/0xc0
[    5.780190]  [<ffffffff814d933e>] driver_attach+0x1e/0x20
[    5.780191]  [<ffffffff814d8e7b>] bus_add_driver+0x1eb/0x280
[    5.780193]  [<ffffffff814da6b0>] driver_register+0x60/0xe0
[    5.780195]  [<ffffffff8156eb24>] usb_register_driver+0x84/0x140
[    5.780196]  [<ffffffffa00bb000>] ? 0xffffffffa00bb000
[    5.780199]  [<ffffffffa00bb01e>] dvbsky_usb_driver_init+0x1e/0x1000 
[dvb_usb_dvbsky]
[    5.780202]  [<ffffffff81002123>] do_one_initcall+0xb3/0x200
[    5.780206]  [<ffffffff8177d99e>] ? preempt_schedule_common+0x1e/0x40
[    5.780208]  [<ffffffff8177d9dc>] ? _cond_resched+0x1c/0x30
[    5.780210]  [<ffffffff8120427e>] ? kmem_cache_alloc_trace+0x19e/0x220
[    5.780214]  [<ffffffff811a4947>] ? do_init_module+0x27/0x1e5
[    5.780215]  [<ffffffff811a497f>] do_init_module+0x5f/0x1e5
[    5.780221]  [<ffffffff811254fe>] load_module+0x201e/0x2630
[    5.780223]  [<ffffffff811219c0>] ? __symbol_put+0x60/0x60
[    5.780229]  [<ffffffff81229830>] ? kernel_read+0x50/0x80
[    5.780231]  [<ffffffff81125d59>] SyS_finit_module+0xb9/0xf0
[    5.780237]  [<ffffffff8178182e>] entry_SYSCALL_64_fastpath+0x12/0x71
[    5.780239] ---[ end trace 944e313bd83469d2 ]---
[    5.783508] dvb_usb_dvbsky: probe of 1-2:1.0 failed with error -12
[    5.783524] usbcore: registered new interface driver dvb_usb_dvbsky




On 2016-02-17 14:42, Olli Salonen wrote:
> Hi Torbjörn,
>
> Try commenting out this line in si2168.c and let me know if that changes things.
>
>          if (c->delivery_system == SYS_DVBT2) {
>                  /* select PLP */
>                  cmd.args[0] = 0x52;
>                  cmd.args[1] = c->stream_id & 0xff;
> //              cmd.args[2] = c->stream_id == NO_STREAM_ID_FILTER ? 0 : 1;
>                  cmd.wlen = 3;
>                  cmd.rlen = 1;
>                  ret = si2168_cmd_execute(s, &cmd);
>                  if (ret)
>                          goto err;
>          }
>
>
> Cheers,
> -olli
>
> On 17 February 2016 at 08:24, Olli Salonen <olli.salonen@iki.fi> wrote:
>> Hi Torbjörn,
>>
>> I connected my old v1 CT2-4650CI to my test PC and indeed, it seems
>> that there's something wrong with tuning to T2 channels.
>>
>> Here's first a tune with the CT2-4500CI (same as DVBSky T980C) and
>> then with the CT2-4650CI.
>>
>> olli@dl160:~$ dvbv5-zap -a 1 "Yle Teema HD" -c dvb_channel.conf -o
>> teema.ts -t 10
>> using demux '/dev/dvb/adapter1/demux0'
>> reading channels from file 'dvb_channel.conf'
>> service has pid type 06:  50
>> tuning to 184500000 Hz
>> video pid 316
>>    dvb_set_pesfilter 316
>> audio pid 880
>>    dvb_set_pesfilter 880
>>         (0x00)
>> Lock   (0x1f) Signal= -72.00dBm C/N= 26.75dB
>> Lock   (0x1f) Signal= -72.00dBm C/N= 26.50dB
>> Record to file 'teema.ts' started
>> copied 6478856 bytes (632 Kbytes/sec)
>> Lock   (0x1f) Signal= -72.00dBm C/N= 26.50dB
>>
>> olli@dl160:~$ dvbv5-zap -a 0 "Yle Teema HD" -c dvb_channel.conf -o teema.ts -t 3
>> using demux '/dev/dvb/adapter0/demux0'
>> reading channels from file 'dvb_channel.conf'
>> service has pid type 06:  50
>> tuning to 184500000 Hz
>> video pid 316
>>    dvb_set_pesfilter 316
>> audio pid 880
>>    dvb_set_pesfilter 880
>>         (0x00)
>>         (0x00) Signal= -104.00dBm
>>         (0x00) Signal= -104.00dBm
>>
>> frontend doesn't lock
>>
>> I'll try to look into that...
>>
>> Cheers,
>> -olli
>>
>> On 17 February 2016 at 01:12, Torbjorn Jansson
>> <torbjorn.jansson@mbox200.swipnet.se> wrote:
>>> Perfect.
>>> Looks like i have some more testing to do in the next few days.
>>>
>>> something else, when testing my 4650 card i cant get it to tune properly to
>>> dvb-t2 muxes.
>>> but i'm not yet sure if this is a driver issue or if i made a mistake with
>>> the tuning parameters since the file i use that came with the dvbv5 programs
>>> was missing the t2 mux so i had to put that one in manually.
>>>
>>> so more testing is needed first and with your patch for the T980C card i can
>>> probably test both things at the same time.
>>>
>>>
>>> On 2016-02-16 21:20, Olli Salonen wrote:
>>>>
>>>> Hi all,
>>>>
>>>> Found the issue and submitted a patch.
>>>>
>>>> The I2C buses for T980C/T2-4500CI were crossed when CI registration
>>>> was moved to its own function.
>>>>
>>>> Cheers,
>>>> -olli
>>>>
>>>> On 31 January 2016 at 10:55, Torbjorn Jansson
>>>> <torbjorn.jansson@mbox200.swipnet.se> wrote:
>>>>>
>>>>> this ci problem is the reason i decided to buy the CT2-4650 usb based
>>>>> device
>>>>> instead.
>>>>> but the 4650 was a slightly newer revision needing a patch i submitted
>>>>> earlier.
>>>>> and also this 4650 device does not have auto switching between dvb-t and
>>>>> t2
>>>>> like the dvbsky card have, so i also need an updated version of mythtv.
>>>>>
>>>>> my long term wish is to not have to patch things or build custom kernels
>>>>> or
>>>>> modules.
>>>>> so anything done to improve the dvbsky card or the 4650 is much
>>>>> appreciated.
>>>>>
>>>>>
>>>>> On 2016-01-28 20:42, Olli Salonen wrote:
>>>>>>
>>>>>>
>>>>>> Hi Jürgen & Mauro,
>>>>>>
>>>>>> I did bisect this and it seems this rather big patch broke it:
>>>>>>
>>>>>> 2b0aac3011bc7a9db27791bed4978554263ef079 is the first bad commit
>>>>>> commit 2b0aac3011bc7a9db27791bed4978554263ef079
>>>>>> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>> Date:   Tue Dec 23 13:48:07 2014 -0200
>>>>>>
>>>>>>        [media] cx23885: move CI/MAC registration to a separate function
>>>>>>
>>>>>>        As reported by smatch:
>>>>>>            drivers/media/pci/cx23885/cx23885-dvb.c:2080 dvb_register()
>>>>>> Function too hairy.  Giving up.
>>>>>>
>>>>>>        This is indeed a too complex function, with lots of stuff inside.
>>>>>>        Breaking this into two functions makes it a little bit less hairy.
>>>>>>
>>>>>>        Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>>
>>>>>> It's getting a bit late, so I'll call it a day now and have a look at
>>>>>> the patch to see what goes wrong there.
>>>>>>
>>>>>> Cheers,
>>>>>> -olli
>>>>>>
>>>>>> On 28 January 2016 at 20:57, Jurgen Kramer <gtmkramer@xs4all.nl> wrote:
>>>>>>>
>>>>>>>
>>>>>>> Hi Olli,
>>>>>>>
>>>>>>> On Thu, 2016-01-28 at 19:26 +0200, Olli Salonen wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> Hi Jürgen,
>>>>>>>>
>>>>>>>> Did you get anywhere with this?
>>>>>>>>
>>>>>>>> I have a clone of your card and was just starting to look at this
>>>>>>>> issue. Kernel 3.19 seems to work ok, but 4.3 not. Did you have any
>>>>>>>> time to try to pinpoint this more?
>>>>>>>
>>>>>>>
>>>>>>> No, unfortunately not. I have spend a few hours adding printk's but it
>>>>>>> did not get me any closer what causes the issue. This really needs
>>>>>>> investigation from someone who is more familiar with linux media.
>>>>>>>
>>>>>>> Last thing I tried was the latest (semi open) drivers from dvbsky on a
>>>>>>> 4.3 kernel. Here the CI and CAM registered successfully.
>>>>>>>
>>>>>>> Greetings,
>>>>>>> Jurgen
>>>>>>>
>>>>>>>> Cheers,
>>>>>>>> -olli
>>>>>>>>
>>>>>>>> On 12 September 2015 at 10:02, Jurgen Kramer <gtmkramer@xs4all.nl>
>>>>>>>> wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On Fri, 2015-09-11 at 22:01 +0200, Torbjorn Jansson wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 2015-08-23 19:50, Jurgen Kramer wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> On Sun, 2015-07-12 at 12:38 +0200, Jurgen Kramer wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> I have been running a couple of DVBSky T980C's with CIs with
>>>>>>>>>>>> success
>>>>>>>>>>>> using an older kernel (3.17.8) with media-build and some
>>>>>>>>>>>> added patches
>>>>>>>>>>>> from the mailing list.
>>>>>>>>>>>>
>>>>>>>>>>>> I thought lets try a current 4.0 kernel to see if I no longer
>>>>>>>>>>>> need to be
>>>>>>>>>>>> running a custom kernel. Everything works just fine except
>>>>>>>>>>>> the CAM
>>>>>>>>>>>> module. I am seeing these:
>>>>>>>>>>>>
>>>>>>>>>>>> [  456.574969] dvb_ca adapter 0: Invalid PC card inserted :(
>>>>>>>>>>>> [  456.626943] dvb_ca adapter 1: Invalid PC card inserted :(
>>>>>>>>>>>> [  456.666932] dvb_ca adapter 2: Invalid PC card inserted :(
>>>>>>>>>>>>
>>>>>>>>>>>> The normal 'CAM detected and initialised' messages to do show
>>>>>>>>>>>> up with
>>>>>>>>>>>> 4.0.8
>>>>>>>>>>>>
>>>>>>>>>>>> I am not sure what changed in the recent kernels, what is
>>>>>>>>>>>> needed to
>>>>>>>>>>>> debug this?
>>>>>>>>>>>>
>>>>>>>>>>>> Jurgen
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Retest. I've isolated one T980C on another PC with kernel
>>>>>>>>>>> 4.1.5, still the same 'Invalid PC card inserted :(' message.
>>>>>>>>>>> Even after installed today's media_build from git no
>>>>>>>>>>> improvement.
>>>>>>>>>>>
>>>>>>>>>>> Any hints where to start looking would be appreciated!
>>>>>>>>>>>
>>>>>>>>>>> cimax2.c|h do not seem to have changed. There are changes to
>>>>>>>>>>> dvb_ca_en50221.c
>>>>>>>>>>>
>>>>>>>>>>> Jurgen
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> did you get it to work?
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> No, it needs a thorough debug session. So far no one seems able to
>>>>>>>>> help...
>>>>>>>>>
>>>>>>>>>> i got a dvbsky T980C too for dvb-t2 reception and so far the only
>>>>>>>>>> drivers that have worked at all is the ones from dvbsky directly.
>>>>>>>>>>
>>>>>>>>>> i was very happy when i noticed that recent kernels have support
>>>>>>>>>> for it
>>>>>>>>>> built in but unfortunately only the modules and firmware loads
>>>>>>>>>> but then
>>>>>>>>>> nothing actually works.
>>>>>>>>>> i use mythtv and it complains a lot about the signal, running
>>>>>>>>>> femon also
>>>>>>>>>> produces lots of errors.
>>>>>>>>>>
>>>>>>>>>> so i had to switch back to kernel 4.0.4 with mediabuild from
>>>>>>>>>> dvbsky.
>>>>>>>>>>
>>>>>>>>>> if there were any other dvb-t2 card with ci support that had
>>>>>>>>>> better
>>>>>>>>>> drivers i would change right away.
>>>>>>>>>>
>>>>>>>>>> one problem i have with the mediabuilt from dvbsky is that at
>>>>>>>>>> boot the
>>>>>>>>>> cam never works and i have to first tune a channel, then remove
>>>>>>>>>> and
>>>>>>>>>> reinstert the cam to get it to work.
>>>>>>>>>> without that nothing works.
>>>>>>>>>>
>>>>>>>>>> and finally a problem i ran into when i tried mediabuilt from
>>>>>>>>>> linuxtv.org.
>>>>>>>>>> fedora uses kernel modules with .ko.xz extension so when you
>>>>>>>>>> install the
>>>>>>>>>> mediabuilt modulels you get one modulename.ko and one
>>>>>>>>>> modulename.ko.xz
>>>>>>>>>>
>>>>>>>>>> before a make install from mediabuild overwrote the needed
>>>>>>>>>> modules.
>>>>>>>>>> any advice on how to handle this now?
>>>>>>>>>>
>>>>>>>>>>

