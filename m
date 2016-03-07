Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36697 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbcCGOQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 09:16:53 -0500
Subject: Re: [PATCH v5 22/22] sound/usb: Use Media Controller API to share
 media resources
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1456937431-3794-1-git-send-email-shuahkh@osg.samsung.com>
 <20160305070055.6e17edcd@recife.lan>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi,
	ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com,
	k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	elfring@users.sourceforge.net, prabhakar.csengg@gmail.com,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com, labbott@fedoraproject.org,
	pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com,
	julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de,
	misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56DD8D4A.1070901@osg.samsung.com>
Date: Mon, 7 Mar 2016 07:16:42 -0700
MIME-Version: 1.0
In-Reply-To: <20160305070055.6e17edcd@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/2016 03:00 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  2 Mar 2016 09:50:31 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Change ALSA driver to use Media Controller API to
>> share media resources with DVB and V4L2 drivers
>> on a AU0828 media device. Media Controller specific
>> initialization is done after sound card is registered.
>> ALSA creates Media interface and entity function graph
>> nodes for Control, Mixer, PCM Playback, and PCM Capture
>> devices.
>>
>> snd_usb_hw_params() will call Media Controller enable
>> source handler interface to request the media resource.
>> If resource request is granted, it will release it from
>> snd_usb_hw_free(). If resource is busy, -EBUSY is returned.
>>
>> Media specific cleanup is done in usb_audio_disconnect().
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> Acked-by: Takashi Iwai <tiwai@suse.de>
> 
> Shuah, by looking at the produced graphs:
> 	https://mchehab.fedorapeople.org/mc-next-gen/au0828_test/
> 
> I'm noticing the lack of ALSA I/O entities in the diagram
> (MEDIA_ENT_F_AUDIO_CAPTURE). The mixer there is not connected.
> 
> Could you please check what's happening?

Mauro,

Did you pull in this patch that fixes the graph problem:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg95047.html

If you haven't, could you please pull this in.


> 
> Those are the relevant dmesg data:
> 
> [   19.017276] usbcore: registered new interface driver snd-usb-audio
> [  230.706102] Linux video capture interface: v2.00
> [  230.856983] au0828: au0828 driver loaded
> [  231.230612] au0828: i2c bus registered
> [  231.822006] tveeprom 5-0050: Hauppauge model 72001, rev E1H3, serial# 4035199481
> [  231.822991] tveeprom 5-0050: MAC address is 00:0d:fe:84:41:f9
> [  231.823955] tveeprom 5-0050: tuner model is Xceive XC5000C (idx 173, type 88)
> [  231.824782] tveeprom 5-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
> [  231.825272] tveeprom 5-0050: audio processor is AU8522 (idx 44)
> [  231.825276] tveeprom 5-0050: decoder processor is AU8522 (idx 42)
> [  231.825280] tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
> [  231.825283] au0828: hauppauge_eeprom: hauppauge eeprom: model=72001
> [  231.857567] au8522 5-0047: creating new instance
> [  231.857879] au8522_decoder creating new instance...
> [  231.910525] tuner 5-0061: Setting mode_mask to 0x06
> [  231.910532] tuner 5-0061: tuner 0x61: Tuner type absent
> [  231.910535] tuner 5-0061: Tuner -1 found with type(s) Radio TV.
> [  231.911343] tuner 5-0061: Calling set_type_addr for type=88, addr=0x61, mode=0x04, config=ffffffffa0e64100
> [  231.911347] tuner 5-0061: defining GPIO callback
> [  231.934896] xc5000 5-0061: creating new instance
> [  231.954664] xc5000: Successfully identified at address 0x61
> [  231.954987] xc5000: Firmware has not been loaded previously
> [  231.955327] tuner 5-0061: type set to Xceive XC5000
> [  231.955330] tuner 5-0061: au0828 tuner I2C addr 0xc2 with type 88 used for 0x04
> [  233.622614] au8522 5-0047: attaching existing instance
> [  233.636061] xc5000 5-0061: attaching existing instance
> [  233.645775] xc5000: Successfully identified at address 0x61
> [  233.646034] xc5000: Firmware has not been loaded previously
> [  233.646461] DVB: registering new adapter (au0828)
> [  233.647575] usb 2-3.3: DVB: registering adapter 0 frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
> [  233.648344] dvb_create_media_entity: media entity 'Auvitek AU8522 QAM/8VSB Frontend' registered.
> [  233.656105] dvb_create_media_entity: media entity 'dvb-demux' registered.
> [  234.166644] IR keymap rc-hauppauge not found
> [  234.166962] Registered IR keymap rc-empty
> [  234.178055] input: au0828 IR (Hauppauge HVR950Q) as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.3/rc/rc0/input14
> [  234.203311] rc rc0: au0828 IR (Hauppauge HVR950Q) as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3.3/rc/rc0
> [  234.207828] au0828: Remote controller au0828 IR (Hauppauge HVR950Q) initalized
> [  234.208270] au0828: Registered device AU0828 [Hauppauge HVR950Q]
> [  234.212073] usbcore: registered new interface driver au0828
> [  234.230371] lirc_dev: IR Remote Control driver registered, major 243 
> [  234.257555] rc rc0: lirc_dev: driver ir-lirc-codec (au0828-input) registered at minor = 0
> [  234.257960] IR LIRC bridge handler initialized
> 
> (as au0828 is blacklisted, snd-usb-audio was probed first)
> 
> ====xxxx====
> 
> I'm also getting some other weird behavior when removing/reinserting
> the modules a few times. OK, officially we don't support it, but,
> as devices can be bind/unbind all the times, removing modules is
> a way to simulate such things. Also, I use it a lot while testing
> USB drivers ;)

I will do more testing on this. I didn't see any problems when
I fixed the graph patch above - I will do more on the latest
media branch today.

thanks,
-- Shuah

> 
> This one is after removing both the media drivers and snd-usb-audio, 
> and then modprobing snd-usb-audio:
> 
> [ 1839.510587] BUG: sleeping function called from invalid context at mm/slub.c:1289
> [ 1839.510881] in_atomic(): 1, irqs_disabled(): 0, pid: 3479, name: modprobe
> [ 1839.511157] 4 locks held by modprobe/3479:
> [ 1839.511415]  #0:  (&dev->mutex){......}, at: [<ffffffff81ce8933>] __driver_attach+0xa3/0x160
> [ 1839.512381]  #1:  (&dev->mutex){......}, at: [<ffffffff81ce8941>] __driver_attach+0xb1/0x160
> [ 1839.512388]  #2:  (register_mutex#5){+.+.+.}, at: [<ffffffffa10596c7>] usb_audio_probe+0x257/0x1c90 [snd_usb_audio]
> [ 1839.512401]  #3:  (&(&mdev->lock)->rlock){+.+.+.}, at: [<ffffffffa0e6051b>] media_device_register_entity+0x1cb/0x700 [media]
> [ 1839.512412] CPU: 2 PID: 3479 Comm: modprobe Not tainted 4.5.0-rc3+ #49
> [ 1839.512415] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
> [ 1839.512417]  0000000000000000 ffff8803b3f6f288 ffffffff81933901 ffff8803c4bae000
> [ 1839.512422]  ffff8803c4bae5c8 ffff8803b3f6f2b0 ffffffff811c6af5 ffff8803c4bae000
> [ 1839.512427]  ffffffff8285d7f6 0000000000000509 ffff8803b3f6f2f0 ffffffff811c6ce5
> [ 1839.512432] Call Trace:
> [ 1839.512436]  [<ffffffff81933901>] dump_stack+0x85/0xc4
> [ 1839.512440]  [<ffffffff811c6af5>] ___might_sleep+0x245/0x3a0
> [ 1839.512443]  [<ffffffff811c6ce5>] __might_sleep+0x95/0x1a0
> [ 1839.512446]  [<ffffffff8155aade>] kmem_cache_alloc_trace+0x20e/0x300
> [ 1839.512451]  [<ffffffffa0e66e3d>] ? media_add_link+0x4d/0x140 [media]
> [ 1839.512455]  [<ffffffffa0e66e3d>] media_add_link+0x4d/0x140 [media]
> [ 1839.512459]  [<ffffffffa0e69931>] media_create_pad_link+0xa1/0x600 [media]
> [ 1839.512463]  [<ffffffffa0fe11b3>] au0828_media_graph_notify+0x173/0x360 [au0828]
> [ 1839.512467]  [<ffffffffa0e68a6a>] ? media_gobj_create+0x1ba/0x480 [media]
> [ 1839.512471]  [<ffffffffa0e606fb>] media_device_register_entity+0x3ab/0x700 [media]
> [ 1839.512475]  [<ffffffffa0e60350>] ? media_device_release_devres+0x10/0x10 [media]
> [ 1839.512479]  [<ffffffff8124068d>] ? trace_hardirqs_on+0xd/0x10
> [ 1839.512482]  [<ffffffff8159f992>] ? create_object+0x5a2/0x940
> [ 1839.512485]  [<ffffffff8159f3f0>] ? kmemleak_disable+0x90/0x90
> [ 1839.512489]  [<ffffffff8159f3f0>] ? kmemleak_disable+0x90/0x90
> [ 1839.512497]  [<ffffffffa109722c>] ? media_snd_mixer_init+0x16c/0x500 [snd_usb_audio]
> [ 1839.512501]  [<ffffffff8155f696>] ? kasan_unpoison_shadow+0x36/0x50
> [ 1839.512504]  [<ffffffff8155f70e>] ? kasan_kmalloc+0x5e/0x70
> [ 1839.512511]  [<ffffffffa1097352>] media_snd_mixer_init+0x292/0x500 [snd_usb_audio]
> [ 1839.512519]  [<ffffffffa1097693>] media_snd_device_create+0xd3/0x2e0 [snd_usb_audio]
> [ 1839.512525]  [<ffffffffa1059b05>] usb_audio_probe+0x695/0x1c90 [snd_usb_audio]
> [ 1839.512529]  [<ffffffff8128b217>] ? debug_lockdep_rcu_enabled+0x77/0x90
> [ 1839.512536]  [<ffffffffa1059470>] ? snd_usb_create_stream+0x4e0/0x4e0 [snd_usb_audio]
> [ 1839.512540]  [<ffffffff812404fa>] ? trace_hardirqs_on_caller+0x40a/0x590
> [ 1839.512543]  [<ffffffff8124068d>] ? trace_hardirqs_on+0xd/0x10
> [ 1839.512546]  [<ffffffff81dbb1dd>] usb_probe_interface+0x45d/0x940
> [ 1839.512550]  [<ffffffff81ce7e7a>] driver_probe_device+0x21a/0xc30
> [ 1839.512553]  [<ffffffff81ce8890>] ? driver_probe_device+0xc30/0xc30
> [ 1839.512556]  [<ffffffff81ce89b1>] __driver_attach+0x121/0x160
> [ 1839.512559]  [<ffffffff81ce21bf>] bus_for_each_dev+0x11f/0x1a0
> [ 1839.512562]  [<ffffffff81ce20a0>] ? subsys_dev_iter_exit+0x10/0x10
> [ 1839.512565]  [<ffffffff822e7be7>] ? _raw_spin_unlock+0x27/0x40
> [ 1839.512568]  [<ffffffff81ce6cdd>] driver_attach+0x3d/0x50
> [ 1839.512571]  [<ffffffff81ce5df9>] bus_add_driver+0x4c9/0x770
> [ 1839.512575]  [<ffffffff81cea39c>] driver_register+0x18c/0x3b0
> [ 1839.512578]  [<ffffffff81250f92>] ? __raw_spin_lock_init+0x32/0x100
> [ 1839.512581]  [<ffffffff81db6e98>] usb_register_driver+0x1f8/0x440
> [ 1839.512584]  [<ffffffff810021a1>] ? do_one_initcall+0x131/0x300
> [ 1839.512587]  [<ffffffffa10d8000>] ? 0xffffffffa10d8000
> [ 1839.512594]  [<ffffffffa10d801e>] usb_audio_driver_init+0x1e/0x1000 [snd_usb_audio]
> [ 1839.512597]  [<ffffffff810021b1>] do_one_initcall+0x141/0x300
> [ 1839.512600]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
> [ 1839.512603]  [<ffffffff8155f696>] ? kasan_unpoison_shadow+0x36/0x50
> [ 1839.512606]  [<ffffffff8155f696>] ? kasan_unpoison_shadow+0x36/0x50
> [ 1839.512609]  [<ffffffff8155f7a7>] ? __asan_register_globals+0x87/0xa0
> [ 1839.512613]  [<ffffffff8144d8eb>] do_init_module+0x1d0/0x5ad
> [ 1839.512617]  [<ffffffff812f27b6>] load_module+0x6666/0x9ba0
> [ 1839.512620]  [<ffffffff812e9e20>] ? symbol_put_addr+0x50/0x50
> [ 1839.512627]  [<ffffffff812ec150>] ? module_frob_arch_sections+0x20/0x20
> [ 1839.512630]  [<ffffffff815be010>] ? open_exec+0x50/0x50
> [ 1839.512634]  [<ffffffff8116716b>] ? ns_capable+0x5b/0xd0
> [ 1839.512637]  [<ffffffff812f5fe8>] SyS_finit_module+0x108/0x130
> [ 1839.512640]  [<ffffffff812f5ee0>] ? SyS_init_module+0x1f0/0x1f0
> [ 1839.512643]  [<ffffffff81004044>] ? lockdep_sys_exit_thunk+0x12/0x14
> [ 1839.512647]  [<ffffffff822e8636>] entry_SYSCALL_64_fastpath+0x16/0x76
> [ 1839.514027] usbcore: registered new interface driver snd-usb-audio
> 
> And an extra kmemleak issue:
> 
> unreferenced object 0xffff8803bcbacf30 (size 128):
>   comm "modprobe", pid 2625, jiffies 4294950803 (age 1715.788s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff822cf76e>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff8155ab06>] kmem_cache_alloc_trace+0x236/0x300
>     [<ffffffff81937eb2>] ida_pre_get+0x1a2/0x250
>     [<ffffffff81938005>] ida_simple_get+0xa5/0x170
>     [<ffffffffa0f1469a>] 0xffffffffa0f1469a
>     [<ffffffffa0fe6951>] au0828_dvb_register+0xe21/0x12c0 [au0828]
>     [<ffffffffa0fd1d92>] vb2_thread+0xbb2/0xc10 [videobuf2_core]
>     [<ffffffff81dbb1dd>] usb_probe_interface+0x45d/0x940
>     [<ffffffff81ce7e7a>] driver_probe_device+0x21a/0xc30
>     [<ffffffff81ce89b1>] __driver_attach+0x121/0x160
>     [<ffffffff81ce21bf>] bus_for_each_dev+0x11f/0x1a0
>     [<ffffffff81ce6cdd>] driver_attach+0x3d/0x50
>     [<ffffffff81ce5df9>] bus_add_driver+0x4c9/0x770
>     [<ffffffff81cea39c>] driver_register+0x18c/0x3b0
>     [<ffffffff81db6e98>] usb_register_driver+0x1f8/0x440
>     [<ffffffffa0fb80b7>] au8522_get_frontend+0xb7/0x160 [au8522_dig]
> 
> I did one extra module removal/reinsert, and this time, I got lots
> of bugs. Full dmesg is at:
> 	http://pastebin.com/LEX5LD5K
> 
> The Kernel hanged after a while with (at the serial console - with
> kind of explain why the message is truncated):
> 
> [ 2117.282666] kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#2] SMP KASAN
> [ 2117.284074] Modules linked in: videobuf2_v4l2 videobuf2_core tveeprom dvb_core rc_core v4l2_common videodev snd_usb_audio media cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt iTCO_vendor_support kvm irqbypass crct10dif_pclmul crc32_
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
