Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40789 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab0ETFBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 01:01:34 -0400
Message-ID: <4BF4C228.7030100@gmail.com>
Date: Thu, 20 May 2010 02:01:28 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Vladis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: Re: [PATCH] input: fix error at the default input_get_keycode call
References: <4BF4C0D6.9030808@redhat.com>
In-Reply-To: <4BF4C0D6.9030808@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> [   76.376140] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   76.376670] IP: [<c138b6d0>] input_default_getkeycode_from_index+0x40/0x60
> [   76.376670] *pde = 00000000
> [   76.376670] Oops: 0002 [#1] SMP
> [   76.376670] last sysfs file: /sys/devices/virtual/block/dm-5/range
> [   76.376670] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log uinput snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm snd_timer snd ppdev sg parport_pc soundcore k8temp snd_page_alloc forcedeth pcspkr hwmon parport i2c_nforce2 sd_mod crc_t10dif sr_mod cdrom pata_acpi ata_generic pata_amd sata_nv floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core dm_mod [last unloaded: scsi_wait_scan]
> [   76.376670]
> [   76.376670] Pid: 6183, comm: getkeycodes Not tainted 2.6.34 #11 C51MCP51/
> [   76.376670] EIP: 0060:[<c138b6d0>] EFLAGS: 00210046 CPU: 0
> [   76.376670] EIP is at input_default_getkeycode_from_index+0x40/0x60
> [   76.376670] EAX: 00000000 EBX: 00000000 ECX: 00000002 EDX: f53ebdc8
> [   76.376670] ESI: f53ebdc8 EDI: f5daf794 EBP: f53ebdb8 ESP: f53ebdb4
> [   76.376670]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [   76.376670] Process getkeycodes (pid: 6183, ti=f53ea000 task=f53bd060 task.ti=f53ea000)
> [   76.376670] Stack:
> [   76.376670]  f5daf000 f53ebdec c138d233 f53ebe30 00200286 00000000 00000000 00000004
> [   76.376670] <0> 00000000 00000000 00000000 f53ebe2c f5da0340 c16c12cc f53ebdf8 c12f4148
> [   76.376670] <0> c12f4130 f53ebe24 c138d9f8 00000002 00000001 00000000 c138d980 c12f4130
> [   76.376670] Call Trace:
> [   76.376670]  [<c138d233>] ? input_get_keycode+0x73/0x90
> 
> input_default_getkeycode_from_index() returns the scancode at kt_entry.scancode
> pointer. Fill it with the scancode address at the function call.
> 
> Thanks-to: Vladis Kletnieks <Valdis.Kletnieks@vt.edu> for pointing the issue
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 3b63fad..7851d8e 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -838,6 +838,7 @@ int input_get_keycode(struct input_dev *dev,
>  		memset(&kt_entry, 0, sizeof(kt_entry));
>  		kt_entry.len = 4;
>  		kt_entry.index = scancode;
> +		kt_entry.scancode = &scancode;

In time:

-           kt_entry.scancode = &scancode;
+         kt_entry.scancode = (char *)&scancode;

Otherwise, a warning would be produced ;)

>  
>  		spin_lock_irqsave(&dev->event_lock, flags);
>  		retval = dev->getkeycodebig_from_index(dev, &kt_entry);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
