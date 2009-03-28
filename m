Return-path: <linux-media-owner@vger.kernel.org>
Received: from shire.gavlenet.com ([213.141.64.25]:36950 "EHLO
	shire.gavlenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZC1XCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 19:02:47 -0400
Received: from [192.168.0.29] (privat-4f8eddd0.gavlenet.com [79.142.221.208])
	by shire.gavlenet.com (Postfix) with ESMTP id 4F7461A1017C
	for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 00:02:34 +0100 (CET)
Message-ID: <49CEAC86.1090302@hansson.se>
Date: Sun, 29 Mar 2009 00:02:30 +0100
From: Lars Fredriksson <lf@hansson.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Can't load firmware - HVR4000
References: <49CEA0BC.4050107@hansson.se> <d9def9db0903281535n76d91619hdce82a24459f9960@mail.gmail.com>
In-Reply-To: <d9def9db0903281535n76d91619hdce82a24459f9960@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks a lot!

The firmware loads correctly now!

Markus Rechberger skrev:
> On Sat, Mar 28, 2009 at 11:12 PM, Lars Fredriksson <lf@hansson.se> wrote:
>   
>> Hi!
>>
>> I have recently moved my HVR4000 to a new machine, but now I can't load the
>> firmware :-(
>>
>> I'm running Gentoo 2008.0, kernel 2.6.29 and I've tried both with the
>> drivers included in the kernel and with v4l-drivers outside the kernel but I
>> get the same result :-(
>>
>> When the machine starts up it loads the correct modules and I get a
>> /dev/dvb/adapter0, but when I for example tries to do a scan I get an error
>> message that it can't load the firmware (see the end of this mail) - what
>> can I have done wrong, is there something with my kernel maybe? I have the
>> firmware in /lib/firmware and I've tried with two different firmwares, one
>> of them is the one I used eralier on the other installation ...
>>
>> Any hints?
>>
>>     
>
> disable i2c-dev in the kernel ... or blacklist it from loading.
>
> Markus
>
>   
>> Best regards, Lars Fredriksson
>>
>> dmesg output;
>> -----
>> [  743.541920] cx24116_firmware_ondemand: Waiting for firmware upload
>> (dvb-fe-cx24116.fw)...
>> [  743.541927] i2c-adapter i2c-2: firmware: requesting dvb-fe-cx24116.fw
>> [  743.541945] ------------[ cut here ]------------
>> [  743.541948] WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x2a/0x36()
>> [  743.541950] Hardware name: M61SME-S2L
>> [  743.541952] sysfs: duplicate filename 'i2c-2' can not be created
>> [  743.541954] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb
>> cx88_vp3054_i2c videobuf_dvb dvb_core wm8775 tuner_simple tuner_types
>> tda9887 tda8290 tuner cx8800 cx88_alsa cx8802 cx88xx ir_common v4l2_common
>> videodev v4l1_compat tveeprom videobuf_dma_sg videobuf_core btcx_risc
>> [  743.541972] Pid: 4043, comm: kdvb-ad-0-fe-0 Tainted: G        W  2.6.29
>> #1
>> [  743.541974] Call Trace:
>> [  743.541980]  [<c102580b>] warn_slowpath+0x74/0x8a
>> [  743.541985]  [<c114cc4d>] ? idr_get_empty_slot+0x155/0x230
>> [  743.541989]  [<c114cdfe>] ? ida_get_new_above+0xd6/0x153
>> [  743.541993]  [<c108ef1b>] ? wait_on_inode+0x24/0x2a
>> [  743.541996]  [<c108efd6>] ? ifind+0x45/0x57
>> [  743.542000]  [<c10bbbe1>] sysfs_add_one+0x2a/0x36
>> [  743.542014]  [<c10bc050>] create_dir+0x43/0x68
>> [  743.542017]  [<c10bc0a2>] sysfs_create_dir+0x2d/0x41
>> [  743.542021]  [<c114d772>] ? kobject_get+0x12/0x17
>> [  743.542024]  [<c114d827>] kobject_add_internal+0xb0/0x154
>> [  743.542027]  [<c114d976>] kobject_add_varg+0x35/0x41
>> [  743.542030]  [<c114dce8>] kobject_add+0x49/0x4f
>> [  743.542034]  [<c11d8669>] device_add+0x73/0x40d
>> [  743.542037]  [<c114d5a2>] ? kobject_init_internal+0x12/0x28
>> [  743.542040]  [<c114d60a>] ? kobject_init+0x35/0x5a
>> [  743.542043]  [<c11d8a15>] device_register+0x12/0x15
>> [  743.542046]  [<c11dddbb>] _request_firmware+0x177/0x346
>> [  743.542051]  [<c11de003>] request_firmware+0xa/0xc
>> [  743.542056]  [<f7d86525>] cx24116_cmd_execute+0xa5/0x528 [cx24116]
>> [  743.542063]  [<c12a8d59>] ? bit_xfer+0x391/0x39c
>> [  743.542067]  [<f7d870fd>] cx24116_sleep+0x40/0x82 [cx24116]
>> [  743.542071]  [<f7d8f0b6>] ? isl6421_set_voltage+0x5f/0x6c [isl6421]
>> [  743.542084]  [<f7d5e3bd>] dvb_frontend_thread+0x44c/0x480 [dvb_core]
>> [  743.542089]  [<c1035405>] ? autoremove_wake_function+0x0/0x33
>> [  743.542099]  [<f7d5df71>] ? dvb_frontend_thread+0x0/0x480 [dvb_core]
>> [  743.542103]  [<c1035331>] kthread+0x3b/0x62
>> [  743.542106]  [<c10352f6>] ? kthread+0x0/0x62
>> [  743.542110]  [<c10036cb>] kernel_thread_helper+0x7/0x10
>> [  743.542113] ---[ end trace 9ed00f8504e5c157 ]---
>> [  743.542118] kobject_add_internal failed for i2c-2 with -EEXIST, don't try
>> to register things with the same name in the same directory.
>> [  743.542122] Pid: 4043, comm: kdvb-ad-0-fe-0 Tainted: G        W  2.6.29
>> #1
>> [  743.542124] Call Trace:
>> [  743.542126]  [<c114d893>] kobject_add_internal+0x11c/0x154
>> [  743.542130]  [<c114d976>] kobject_add_varg+0x35/0x41
>> [  743.542133]  [<c114dce8>] kobject_add+0x49/0x4f
>> [  743.542135]  [<c11d8669>] device_add+0x73/0x40d
>> [  743.542138]  [<c114d5a2>] ? kobject_init_internal+0x12/0x28
>> [  743.542141]  [<c114d60a>] ? kobject_init+0x35/0x5a
>> [  743.542144]  [<c11d8a15>] device_register+0x12/0x15
>> [  743.542147]  [<c11dddbb>] _request_firmware+0x177/0x346
>> [  743.542151]  [<c11de003>] request_firmware+0xa/0xc
>> [  743.542155]  [<f7d86525>] cx24116_cmd_execute+0xa5/0x528 [cx24116]
>> [  743.542159]  [<c12a8d59>] ? bit_xfer+0x391/0x39c
>> [  743.542163]  [<f7d870fd>] cx24116_sleep+0x40/0x82 [cx24116]
>> [  743.542166]  [<f7d8f0b6>] ? isl6421_set_voltage+0x5f/0x6c [isl6421]
>> [  743.542175]  [<f7d5e3bd>] dvb_frontend_thread+0x44c/0x480 [dvb_core]
>> [  743.542179]  [<c1035405>] ? autoremove_wake_function+0x0/0x33
>> [  743.542188]  [<f7d5df71>] ? dvb_frontend_thread+0x0/0x480 [dvb_core]
>> [  743.542192]  [<c1035331>] kthread+0x3b/0x62
>> [  743.542195]  [<c10352f6>] ? kthread+0x0/0x62
>> [  743.542198]  [<c10036cb>] kernel_thread_helper+0x7/0x10
>> [  743.542201] i2c-adapter i2c-2: fw_register_device: device_register failed
>> [  743.542204] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
>> [  743.542206] cx24116_firmware_ondemand: No firmware uploaded (timeout or
>> file not found?)
>> [  743.542209] cx24116_cmd_execute(): Unable initialise the firmware
>> -----
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

