Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36987 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751361AbeA2LXH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 06:23:07 -0500
Subject: Re: [RFC PATCH] v4l2-event/dev: wakeup pending events when
 unregistering
To: Michael Walz <m.walz@digitalendoscopy.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <83e3318b-3f6e-7f27-6585-b5b69ddd9f65@xs4all.nl>
 <8ea3ba15-102a-4d61-f7fb-e6ccd527a32d@xs4all.nl>
 <88929923-8e9f-20ce-0ba8-7f9913b436c3@digitalendoscopy.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c7960c58-64b0-8548-f593-51c6d862dd4b@xs4all.nl>
Date: Mon, 29 Jan 2018 12:23:02 +0100
MIME-Version: 1.0
In-Reply-To: <88929923-8e9f-20ce-0ba8-7f9913b436c3@digitalendoscopy.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On 01/22/2018 02:52 PM, Michael Walz wrote:
> Hi Hans,
> 
> 
> On 18.01.2018 16:13, Hans Verkuil wrote:
>> Only apply the change to v4l2_dev.c, ignore the changes to
>> v4l2_event. I think it is sufficient to just apply that bit.
> 
> I tried both variants, with changes to v4l2_event and without. Both did
> not work out of the box. I think the problem is in the wake-up-condition in
> 
> ret = wait_event_interruptible(fh->wait, fh->navailable != 0);
> 
> As long as we will check only fh->navailable, the thread will continue
> to sleep. I inserted an abort-condition to the wait
> 
> !video_is_registered(fh->vdev)
> 
> and some printk messages. Is is a dirty hack, but now my VIDIOC_DQEVENT 
> ioctl returns. Instead I get a bunch of errors in dmesg. Can you have a 
> look, please?

This will take some time, I'm in the middle of something urgent and until
that's done this will be on hold. It's in my todo list, so I'll get to it
eventually (probably in 2-3 weeks).

Sorry about that.

Regards,

	Hans

> 
> 
> diff -Naur drivers.orig/media/v4l2-core/v4l2-dev.c 
> drivers/media/v4l2-core/v4l2-dev.c
> --- drivers.orig/media/v4l2-core/v4l2-dev.c	2018-01-22 
> 13:22:47.881815404 +0100
> +++ drivers/media/v4l2-core/v4l2-dev.c	2018-01-22 13:23:18.541315363 +0100
> @@ -1015,6 +1015,9 @@
>    */
>   void video_unregister_device(struct video_device *vdev)
>   {
> +	unsigned long flags;
> +	struct v4l2_fh *fh;
> +
>   	/* Check if vdev was ever registered at all */
>   	if (!vdev || !video_is_registered(vdev))
>   		return;
> @@ -1025,7 +1028,15 @@
>   	 */
>   	clear_bit(V4L2_FL_REGISTERED, &vdev->flags);
>   	mutex_unlock(&videodev_lock);
> +
> +	printk("MWALZ wake threads\n");
> +        spin_lock_irqsave(&vdev->fh_lock, flags);
> +	list_for_each_entry(fh, &vdev->fh_list, list)
> +		wake_up_all(&fh->wait);
> +	spin_unlock_irqrestore(&vdev->fh_lock, flags);
> +
>   	device_unregister(&vdev->dev);
> +        printk("MWALZ unregistered devices\n");
>   }
>   EXPORT_SYMBOL(video_unregister_device);
> 
> diff -Naur drivers.orig/media/v4l2-core/v4l2-event.c 
> drivers/media/v4l2-core/v4l2-event.c
> --- drivers.orig/media/v4l2-core/v4l2-event.c	2018-01-22 
> 13:22:47.881815404 +0100
> +++ drivers/media/v4l2-core/v4l2-event.c	2018-01-22 13:23:14.301384509 +0100
> @@ -35,12 +35,18 @@
>   {
>   	struct v4l2_kevent *kev;
>   	unsigned long flags;
> +	int ret = 0;
> 
>   	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> 
> +	if (!video_is_registered(fh->vdev)) {
> +                printk("MWALZ device not registered!\n");
> +		ret = -ENODEV;
> +		goto err;
> +	}
>   	if (list_empty(&fh->available)) {
> -		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> -		return -ENOENT;
> +		ret = -ENOENT;
> +		goto err;
>   	}
> 
>   	WARN_ON(fh->navailable == 0);
> @@ -53,10 +59,10 @@
>   	*event = kev->event;
>   	kev->sev->first = sev_pos(kev->sev, 1);
>   	kev->sev->in_use--;
> -
> +err:
>   	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> 
> -	return 0;
> +	return ret;
>   }
> 
>   int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
> @@ -73,16 +79,20 @@
> 
>   	do {
>   		ret = wait_event_interruptible(fh->wait,
> -					       fh->navailable != 0);
> +					       (fh->navailable != 0) ||
> +                                     (!video_is_registered(fh->vdev)));
> +                printk("MWALZ woken up\n");
>   		if (ret < 0)
>   			break;
> 
>   		ret = __v4l2_event_dequeue(fh, event);
>   	} while (ret == -ENOENT);
> 
> +        printk("Try to get the lock\n");
>   	if (fh->vdev->lock)
>   		mutex_lock(fh->vdev->lock);
> 
> +        printk("MWALZ return event DQ\n");
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
> 
> 
> 
> 
> 
> 
> [ 1566.982359] usb 2-2.1: USB disconnect, device number 7
> [ 1566.982827] MWALZ wake threads
> [ 1566.983411] MWALZ woken up
> [ 1566.983421] MWALZ device not registered!
> [ 1566.983426] Try to get the lock
> [ 1566.983430] MWALZ return event DQ
> [ 1566.993157] MWALZ unregistered devices
> [ 1569.227177] sysfs group 'power' not found for kobject 'event8'
> [ 1569.227201] ------------[ cut here ]------------
> [ 1569.227214] WARNING: CPU: 1 PID: 2364 at 
> /kernel-source//fs/sysfs/group.c:237 sysfs_remove_group+0x46/0x7b
> [ 1569.227216] Modules linked in: bnep hid_sensor_gyro_3d 
> hid_sensor_accel_3d hid_sensor_trigger hid_sensor_iio_common 
> industrialio_triggered_buffer kfifo_buf hid_sensor_hub intel_ishtp_hid 
> hid_multitouch input_leds asus_nb_wmi asus_wmi gpio_keys 
> intel_powerclamp pcspkr btsdio brcmfmac brcmutil cfg80211 uvcvideo 
> videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 ax88179_178a 
> videobuf2_core usbnet videodev hid_generic mei_txe lpc_ich mei 
> intel_ish_ipc processor_thermal_device intel_ishtp intel_soc_dts_iosf 
> thermal wmi intel_hid sparse_keymap axp20x_i2c axp20x 
> intel_soc_pmic_bxtwc intel_pmc_ipc i2c_hid int3400_thermal 
> int3403_thermal battery soc_button_array int340x_thermal_zone 
> acpi_thermal_rel int3406_thermal ac acpi_pad efivarfs
> [ 1569.227341] CPU: 1 PID: 2364 Comm: TabletVP Tainted: G        W 
> 4.12.10-custom #3
> [ 1569.227343] Hardware name: ASUSTeK COMPUTER INC. T100HAN/T100HAN, 
> BIOS T100HAN.221 05/18/2016
> [ 1569.227348] task: ffff8800779b5040 task.stack: ffff880076124000
> [ 1569.227353] RIP: 0010:sysfs_remove_group+0x46/0x7b
> [ 1569.227355] RSP: 0018:ffff880076127c48 EFLAGS: 00010296
> [ 1569.227359] RAX: 0000000000000032 RBX: 0000000000000000 RCX: 
> 0000000000000000
> [ 1569.227362] RDX: ffff880079e94901 RSI: ffff880079e8cba8 RDI: 
> ffff880079e8cba8
> [ 1569.227365] RBP: ffff880076127c60 R08: 0000000000000000 R09: 
> ffffffff81ef625c
> [ 1569.227367] R10: ffff880076127ce0 R11: 071c71c71c71c71c R12: 
> ffffffff81cc3200
> [ 1569.227370] R13: ffff88006ddfc4b8 R14: ffff88006ddfc558 R15: 
> ffff880074825da0
> [ 1569.227374] FS:  00007ffff7198c00(0000) GS:ffff880079e80000(0000) 
> knlGS:0000000000000000
> [ 1569.227376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1569.227378] CR2: 00007fffec0050d8 CR3: 0000000077236000 CR4: 
> 00000000001006e0
> [ 1569.227380] Call Trace:
> [ 1569.227392]  dpm_sysfs_remove+0x50/0x55
> [ 1569.227398]  device_del+0xe2/0x2b0
> [ 1569.227406]  cdev_device_del+0x1a/0x30
> [ 1569.227412]  evdev_disconnect+0x2a/0x5a
> [ 1569.227417]  __input_unregister_device+0xa8/0x111
> [ 1569.227420]  input_unregister_device+0x48/0x5c
> [ 1569.227434]  uvc_status_cleanup+0x42/0x45 [uvcvideo]
> [ 1569.227442]  uvc_delete+0x18/0x101 [uvcvideo]
> [ 1569.227450]  uvc_release+0x22/0x25 [uvcvideo]
> [ 1569.227470]  v4l2_device_release+0xa1/0xb5 [videodev]
> [ 1569.227475]  device_release+0x59/0x84
> [ 1569.227481]  kobject_put+0x140/0x174
> [ 1569.227484]  put_device+0x17/0x1a
> [ 1569.227502]  v4l2_release+0x5e/0x68 [videodev]
> [ 1569.227508]  __fput+0xfc/0x18f
> [ 1569.227513]  ____fput+0xe/0x10
> [ 1569.227518]  task_work_run+0x75/0x99
> [ 1569.227524]  prepare_exit_to_usermode+0x5a/0x86
> [ 1569.227528]  syscall_return_slowpath+0xa4/0xad
> [ 1569.227534]  entry_SYSCALL_64_fastpath+0x92/0x94
> [ 1569.227538] RIP: 0033:0x362d21089c
> [ 1569.227540] RSP: 002b:00007fffffffe670 EFLAGS: 00000293 ORIG_RAX: 
> 0000000000000003
> [ 1569.227544] RAX: 0000000000000000 RBX: 0000000000ce20c0 RCX: 
> 000000362d21089c
> [ 1569.227546] RDX: 0000000000000000 RSI: 00007fffd0000b18 RDI: 
> 000000000000001e
> [ 1569.227548] RBP: 00007fffffffe6b0 R08: 00000000014429e0 R09: 
> 0000000000000000
> [ 1569.227551] R10: 0000000000000000 R11: 0000000000000293 R12: 
> 000000000079a9ba
> [ 1569.227553] R13: 0000000000000000 R14: 0000000000000000 R15: 
> 0000000000000000
> [ 1569.227556] Code: 74 2d 31 d2 49 89 fd 48 89 df e8 d0 ca ff ff 48 85 
> c0 48 89 c3 75 20 49 8b 55 00 48 c7 c7 45 3c a9 81 49 8b 34 24 e8 2c 2b 
> f5 ff <0f> ff eb 2a 48 89 df e8 a3 c3 ff ff 4c 89 e6 48 89 df e8 95 fa
> [ 1569.227633] ---[ end trace 453d5b8711046511 ]---
> [ 1569.238099] sysfs group 'power' not found for kobject 'input20'
> [ 1569.238126] ------------[ cut here ]------------
> [ 1569.238140] WARNING: CPU: 0 PID: 2364 at 
> /kernel-source//fs/sysfs/group.c:237 sysfs_remove_group+0x46/0x7b
> [ 1569.238142] Modules linked in: bnep hid_sensor_gyro_3d 
> hid_sensor_accel_3d hid_sensor_trigger hid_sensor_iio_common 
> industrialio_triggered_buffer kfifo_buf hid_sensor_hub intel_ishtp_hid 
> hid_multitouch input_leds asus_nb_wmi asus_wmi gpio_keys 
> intel_powerclamp pcspkr btsdio brcmfmac brcmutil cfg80211 uvcvideo 
> videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 ax88179_178a 
> videobuf2_core usbnet videodev hid_generic mei_txe lpc_ich mei 
> intel_ish_ipc processor_thermal_device intel_ishtp intel_soc_dts_iosf 
> thermal wmi intel_hid sparse_keymap axp20x_i2c axp20x 
> intel_soc_pmic_bxtwc intel_pmc_ipc i2c_hid int3400_thermal 
> int3403_thermal battery soc_button_array int340x_thermal_zone 
> acpi_thermal_rel int3406_thermal ac acpi_pad efivarfs
> [ 1569.238262] CPU: 0 PID: 2364 Comm: TabletVP Tainted: G        W 
> 4.12.10-custom #3
> [ 1569.238265] Hardware name: ASUSTeK COMPUTER INC. T100HAN/T100HAN, 
> BIOS T100HAN.221 05/18/2016
> [ 1569.238269] task: ffff8800779b5040 task.stack: ffff880076124000
> [ 1569.238275] RIP: 0010:sysfs_remove_group+0x46/0x7b
> [ 1569.238279] RSP: 0018:ffff880076127c90 EFLAGS: 00010286
> [ 1569.238283] RAX: 0000000000000033 RBX: 0000000000000000 RCX: 
> 0000000000000000
> [ 1569.238287] RDX: ffff880079e14901 RSI: ffff880079e0cba8 RDI: 
> ffff880079e0cba8
> [ 1569.238290] RBP: ffff880076127ca8 R08: 0000000000000000 R09: 
> ffffffff81ef7134
> [ 1569.238294] R10: ffff880076127c70 R11: 071c71c71c71c71c R12: 
> ffffffff81cc3200
> [ 1569.238297] R13: ffff88006decaa30 R14: ffff88006decaad0 R15: 
> ffff880074825da0
> [ 1569.238302] FS:  00007ffff7198c00(0000) GS:ffff880079e00000(0000) 
> knlGS:0000000000000000
> [ 1569.238306] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1569.238309] CR2: 00007fffec006050 CR3: 0000000077236000 CR4: 
> 00000000001006f0
> [ 1569.238312] Call Trace:
> [ 1569.238325]  dpm_sysfs_remove+0x50/0x55
> [ 1569.238332]  device_del+0xe2/0x2b0
> [ 1569.238339]  ? __wake_up+0x44/0x4b
> [ 1569.238346]  __input_unregister_device+0x10a/0x111
> [ 1569.238351]  input_unregister_device+0x48/0x5c
> [ 1569.238370]  uvc_status_cleanup+0x42/0x45 [uvcvideo]
> [ 1569.238382]  uvc_delete+0x18/0x101 [uvcvideo]
> [ 1569.238393]  uvc_release+0x22/0x25 [uvcvideo]
> [ 1569.238422]  v4l2_device_release+0xa1/0xb5 [videodev]
> [ 1569.238428]  device_release+0x59/0x84
> [ 1569.238436]  kobject_put+0x140/0x174
> [ 1569.238441]  put_device+0x17/0x1a
> [ 1569.238465]  v4l2_release+0x5e/0x68 [videodev]
> [ 1569.238473]  __fput+0xfc/0x18f
> [ 1569.238480]  ____fput+0xe/0x10
> [ 1569.238485]  task_work_run+0x75/0x99
> [ 1569.238492]  prepare_exit_to_usermode+0x5a/0x86
> [ 1569.238497]  syscall_return_slowpath+0xa4/0xad
> [ 1569.238504]  entry_SYSCALL_64_fastpath+0x92/0x94
> [ 1569.238508] RIP: 0033:0x362d21089c
> [ 1569.238511] RSP: 002b:00007fffffffe670 EFLAGS: 00000293 ORIG_RAX: 
> 0000000000000003
> [ 1569.238517] RAX: 0000000000000000 RBX: 0000000000ce20c0 RCX: 
> 000000362d21089c
> [ 1569.238520] RDX: 0000000000000000 RSI: 00007fffd0000b18 RDI: 
> 000000000000001e
> [ 1569.238523] RBP: 00007fffffffe6b0 R08: 00000000014429e0 R09: 
> 0000000000000000
> [ 1569.238526] R10: 0000000000000000 R11: 0000000000000293 R12: 
> 000000000079a9ba
> [ 1569.238529] R13: 0000000000000000 R14: 0000000000000000 R15: 
> 0000000000000000
> [ 1569.238534] Code: 74 2d 31 d2 49 89 fd 48 89 df e8 d0 ca ff ff 48 85 
> c0 48 89 c3 75 20 49 8b 55 00 48 c7 c7 45 3c a9 81 49 8b 34 24 e8 2c 2b 
> f5 ff <0f> ff eb 2a 48 89 df e8 a3 c3 ff ff 4c 89 e6 48 89 df e8 95 fa
> [ 1569.238640] ---[ end trace 453d5b8711046512 ]---
> [ 1569.238668] sysfs group 'id' not found for kobject 'input20'
> [ 1569.238690] ------------[ cut here ]------------
> [ 1569.238699] WARNING: CPU: 0 PID: 2364 at 
> /kernel-source//fs/sysfs/group.c:237 sysfs_remove_group+0x46/0x7b
> [ 1569.238701] Modules linked in: bnep hid_sensor_gyro_3d 
> hid_sensor_accel_3d hid_sensor_trigger hid_sensor_iio_common 
> industrialio_triggered_buffer kfifo_buf hid_sensor_hub intel_ishtp_hid 
> hid_multitouch input_leds asus_nb_wmi asus_wmi gpio_keys 
> intel_powerclamp pcspkr btsdio brcmfmac brcmutil cfg80211 uvcvideo 
> videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 ax88179_178a 
> videobuf2_core usbnet videodev hid_generic mei_txe lpc_ich mei 
> intel_ish_ipc processor_thermal_device intel_ishtp intel_soc_dts_iosf 
> thermal wmi intel_hid sparse_keymap axp20x_i2c axp20x 
> intel_soc_pmic_bxtwc intel_pmc_ipc i2c_hid int3400_thermal 
> int3403_thermal battery soc_button_array int340x_thermal_zone 
> acpi_thermal_rel int3406_thermal ac acpi_pad efivarfs
> [ 1569.238798] CPU: 0 PID: 2364 Comm: TabletVP Tainted: G        W 
> 4.12.10-custom #3
> [ 1569.238801] Hardware name: ASUSTeK COMPUTER INC. T100HAN/T100HAN, 
> BIOS T100HAN.221 05/18/2016
> [ 1569.238805] task: ffff8800779b5040 task.stack: ffff880076124000
> [ 1569.238809] RIP: 0010:sysfs_remove_group+0x46/0x7b
> [ 1569.238813] RSP: 0018:ffff880076127c58 EFLAGS: 00010292
> [ 1569.238817] RAX: 0000000000000030 RBX: 0000000000000000 RCX: 
> 0000000000000007
> [ 1569.238820] RDX: 0000000000000000 RSI: ffff880079e0cba0 RDI: 
> ffff880079e0cba0
> [ 1569.238824] RBP: ffff880076127c70 R08: 0000000000000000 R09: 
> ffffffff81ef7fdc
> [ 1569.238827] R10: ffff880076127c70 R11: 0000000000000228 R12: 
> ffffffff81cdfba0
> [ 1569.238831] R13: ffff88006decaa30 R14: ffffffff818c3b40 R15: 
> ffff880074825da0
> [ 1569.238835] FS:  00007ffff7198c00(0000) GS:ffff880079e00000(0000) 
> knlGS:0000000000000000
> [ 1569.238839] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1569.238842] CR2: 00007fffec006050 CR3: 0000000077236000 CR4: 
> 00000000001006f0
> [ 1569.238844] Call Trace:
> [ 1569.238853]  sysfs_remove_groups+0x32/0x3b
> [ 1569.238859]  device_remove_attrs+0x4e/0x68
> [ 1569.238864]  device_del+0x207/0x2b0
> [ 1569.238869]  ? __wake_up+0x44/0x4b
> [ 1569.238875]  __input_unregister_device+0x10a/0x111
> [ 1569.238880]  input_unregister_device+0x48/0x5c
> [ 1569.238894]  uvc_status_cleanup+0x42/0x45 [uvcvideo]
> [ 1569.238905]  uvc_delete+0x18/0x101 [uvcvideo]
> [ 1569.238916]  uvc_release+0x22/0x25 [uvcvideo]
> [ 1569.238944]  v4l2_device_release+0xa1/0xb5 [videodev]
> [ 1569.238950]  device_release+0x59/0x84
> [ 1569.238956]  kobject_put+0x140/0x174
> [ 1569.238961]  put_device+0x17/0x1a
> [ 1569.238985]  v4l2_release+0x5e/0x68 [videodev]
> [ 1569.238991]  __fput+0xfc/0x18f
> [ 1569.238997]  ____fput+0xe/0x10
> [ 1569.239003]  task_work_run+0x75/0x99
> [ 1569.239008]  prepare_exit_to_usermode+0x5a/0x86
> [ 1569.239014]  syscall_return_slowpath+0xa4/0xad
> [ 1569.239019]  entry_SYSCALL_64_fastpath+0x92/0x94
> [ 1569.239023] RIP: 0033:0x362d21089c
> [ 1569.239026] RSP: 002b:00007fffffffe670 EFLAGS: 00000293 ORIG_RAX: 
> 0000000000000003
> [ 1569.239031] RAX: 0000000000000000 RBX: 0000000000ce20c0 RCX: 
> 000000362d21089c
> [ 1569.239034] RDX: 0000000000000000 RSI: 00007fffd0000b18 RDI: 
> 000000000000001e
> [ 1569.239037] RBP: 00007fffffffe6b0 R08: 00000000014429e0 R09: 
> 0000000000000000
> [ 1569.239088] R10: 0000000000000000 R11: 0000000000000293 R12: 
> 000000000079a9ba
> [ 1569.239091] R13: 0000000000000000 R14: 0000000000000000 R15: 
> 0000000000000000
> [ 1569.239097] Code: 74 2d 31 d2 49 89 fd 48 89 df e8 d0 ca ff ff 48 85 
> c0 48 89 c3 75 20 49 8b 55 00 48 c7 c7 45 3c a9 81 49 8b 34 24 e8 2c 2b 
> f5 ff <0f> ff eb 2a 48 89 df e8 a3 c3 ff ff 4c 89 e6 48 89 df e8 95 fa
> [ 1569.239202] ---[ end trace 453d5b8711046513 ]---
> [ 1569.239208] sysfs group 'capabilities' not found for kobject 'input20'
> [ 1569.239230] ------------[ cut here ]------------
> [ 1569.239239] WARNING: CPU: 0 PID: 2364 at 
> /kernel-source//fs/sysfs/group.c:237 sysfs_remove_group+0x46/0x7b
> [ 1569.239241] Modules linked in: bnep hid_sensor_gyro_3d 
> hid_sensor_accel_3d hid_sensor_trigger hid_sensor_iio_common 
> industrialio_triggered_buffer kfifo_buf hid_sensor_hub intel_ishtp_hid 
> hid_multitouch input_leds asus_nb_wmi asus_wmi gpio_keys 
> intel_powerclamp pcspkr btsdio brcmfmac brcmutil cfg80211 uvcvideo 
> videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 ax88179_178a 
> videobuf2_core usbnet videodev hid_generic mei_txe lpc_ich mei 
> intel_ish_ipc processor_thermal_device intel_ishtp intel_soc_dts_iosf 
> thermal wmi intel_hid sparse_keymap axp20x_i2c axp20x 
> intel_soc_pmic_bxtwc intel_pmc_ipc i2c_hid int3400_thermal 
> int3403_thermal battery soc_button_array int340x_thermal_zone 
> acpi_thermal_rel int3406_thermal ac acpi_pad efivarfs
> [ 1569.239712] CPU: 0 PID: 2364 Comm: TabletVP Tainted: G        W 
> 4.12.10-custom #3
> [ 1569.239715] Hardware name: ASUSTeK COMPUTER INC. T100HAN/T100HAN, 
> BIOS T100HAN.221 05/18/2016
> [ 1569.239718] task: ffff8800779b5040 task.stack: ffff880076124000
> [ 1569.239723] RIP: 0010:sysfs_remove_group+0x46/0x7b
> [ 1569.239726] RSP: 0018:ffff880076127c58 EFLAGS: 00010292
> [ 1569.239731] RAX: 000000000000003a RBX: 0000000000000000 RCX: 
> 0000000000000007
> [ 1569.239734] RDX: 0000000000000000 RSI: ffff880079e0cba0 RDI: 
> ffff880079e0cba0
> [ 1569.239737] RBP: ffff880076127c70 R08: 0000000000000000 R09: 
> ffffffff81ef8eb4
> [ 1569.239741] R10: ffff880076127c70 R11: 0000000000000228 R12: 
> ffffffff81cdf9e0
> [ 1569.239744] R13: ffff88006decaa30 R14: ffffffff818c3b40 R15: 
> ffff880074825da0
> [ 1569.239749] FS:  00007ffff7198c00(0000) GS:ffff880079e00000(0000) 
> knlGS:0000000000000000
> [ 1569.239752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1569.239756] CR2: 00007fffec006050 CR3: 0000000077236000 CR4: 
> 00000000001006f0
> [ 1569.239758] Call Trace:
> [ 1569.239765]  sysfs_remove_groups+0x32/0x3b
> [ 1569.239771]  device_remove_attrs+0x4e/0x68
> [ 1569.239777]  device_del+0x207/0x2b0
> [ 1569.239782]  ? __wake_up+0x44/0x4b
> [ 1569.239788]  __input_unregister_device+0x10a/0x111
> [ 1569.239793]  input_unregister_device+0x48/0x5c
> [ 1569.239806]  uvc_status_cleanup+0x42/0x45 [uvcvideo]
> [ 1569.239817]  uvc_delete+0x18/0x101 [uvcvideo]
> [ 1569.239829]  uvc_release+0x22/0x25 [uvcvideo]
> [ 1569.239857]  v4l2_device_release+0xa1/0xb5 [videodev]
> [ 1569.239863]  device_release+0x59/0x84
> [ 1569.239870]  kobject_put+0x140/0x174
> [ 1569.239875]  put_device+0x17/0x1a
> [ 1569.239899]  v4l2_release+0x5e/0x68 [videodev]
> [ 1569.239907]  __fput+0xfc/0x18f
> [ 1569.239913]  ____fput+0xe/0x10
> [ 1569.239918]  task_work_run+0x75/0x99
> [ 1569.239924]  prepare_exit_to_usermode+0x5a/0x86
> [ 1569.239929]  syscall_return_slowpath+0xa4/0xad
> [ 1569.239934]  entry_SYSCALL_64_fastpath+0x92/0x94
> [ 1569.239939] RIP: 0033:0x362d21089c
> [ 1569.239942] RSP: 002b:00007fffffffe670 EFLAGS: 00000293 ORIG_RAX: 
> 0000000000000003
> [ 1569.239947] RAX: 0000000000000000 RBX: 0000000000ce20c0 RCX: 
> 000000362d21089c
> [ 1569.239950] RDX: 0000000000000000 RSI: 00007fffd0000b18 RDI: 
> 000000000000001e
> [ 1569.239953] RBP: 00007fffffffe6b0 R08: 00000000014429e0 R09: 
> 0000000000000000
> [ 1569.239956] R10: 0000000000000000 R11: 0000000000000293 R12: 
> 000000000079a9ba
> [ 1569.239959] R13: 0000000000000000 R14: 0000000000000000 R15: 
> 0000000000000000
> [ 1569.239964] Code: 74 2d 31 d2 49 89 fd 48 89 df e8 d0 ca ff ff 48 85 
> c0 48 89 c3 75 20 49 8b 55 00 48 c7 c7 45 3c a9 81 49 8b 34 24 e8 2c 2b 
> f5 ff <0f> ff eb 2a 48 89 df e8 a3 c3 ff ff 4c 89 e6 48 89 df e8 95 fa
> [ 1569.240130] ---[ end trace 453d5b8711046514 ]---
> 
> 
