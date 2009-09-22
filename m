Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46431 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZIVXnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 19:43:53 -0400
Received: by fxm18 with SMTP id 18so202087fxm.17
        for <linux-media@vger.kernel.org>; Tue, 22 Sep 2009 16:43:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <30353c3d0909211806q2cfbe4ecx3b6bd78ce2f13779@mail.gmail.com>
References: <4AAC656D.2070709@gmail.com>
	 <208cbae30909141209ge8095fi9f64a07ada0599c1@mail.gmail.com>
	 <208cbae30909211703i86af2c8w788bb53453ba5f23@mail.gmail.com>
	 <30353c3d0909211806q2cfbe4ecx3b6bd78ce2f13779@mail.gmail.com>
Date: Wed, 23 Sep 2009 03:43:55 +0400
Message-ID: <208cbae30909221643m5eb60702hc65ed97f4ea91d22@mail.gmail.com>
Subject: Re: [RFC/RFT 0/14] radio-mr800 patch series
From: Alexey Klimov <klimov.linux@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Cc: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 22, 2009 at 5:06 AM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> On Mon, Sep 21, 2009 at 8:03 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
>> Hello, David
>>
>> On Mon, Sep 14, 2009 at 11:09 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
>>> Hello David,
>>>
>>> On Sun, Sep 13, 2009 at 7:22 AM, David Ellingsworth
>>> <david@identd.dyndns.org> wrote:
>>>> What follow is a series of patches to clean up the radio-mr800 driver. I
>>>> do _not_ have access to this device so these patches need to be tested.
>>>> These patches should apply to Mauro's git tree and against the 2.6.31
>>>> release kernel. The patches in this series are as follows:
>>>>
>>>> 01. radio-mr800: implement proper locking
>>>> 02. radio-mr800: simplify video_device allocation
>>>> 03. radio-mr800: simplify error paths in usb probe callback
>>>> 04. radio-mr800: remove an unnecessary local variable
>>>> 05. radio-mr800: simplify access to amradio_device
>>>> 06. radio-mr800: simplify locking in ioctl callbacks
>>>> 07. radio-mr800: remove device-removed indicator
>>>> 08. radio-mr800: fix potential use after free
>>>> 09. radio-mr800: remove device initialization from open/close
>>>> 10. radio-mr800: ensure the radio is initialized to a consistent state
>>>> 11. radio-mr800: fix behavior of set_radio function
>>>> 12. radio-mr800: preserve radio state during suspend/resume
>>>> 13. radio-mr800: simplify device warnings
>>>> 14. radio-mr800: set radio frequency only upon success
>>>>
>>>> The first 7 in this series are the same as those submitted in my last series
>>>> and will not be resent. The remaining 7 patches in this series will be sent
>>>> separately for review.
>>
>> I applied your patches and tested radio device. Radio works fine, but
>> unfortunately sudden disconnect while playing radio with gnomeradio
>> creates troubles. I see such oops in dmesg:
>>
>> radio_mr800: version 0.11-david AverMedia MR 800 USB FM radio driver
>> usb 2-2: new low speed USB device using ohci_hcd and address 16
>> usb 2-2: New USB device found, idVendor=07ca, idProduct=b800
>> usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> usb 2-2: Product: AVerMedia USB Radio
>> usb 2-2: Manufacturer: AVerMedia Technologies
>> usb 2-2: configuration #1 chosen from 1 choice
>> radio-mr800 2-2:1.0: Non-NULL drvdata on register
>> usb 2-2: USB disconnect, address 16
>> BUG: unable to handle kernel NULL pointer dereference at 000000000000009f
>> IP: [<ffffffff8119222b>] dev_set_drvdata+0x25/0x30
>> PGD 3c0e1067 PUD 33b1d067 PMD 0
>> Oops: 0002 [#1] SMP
>> last sysfs file: /sys/devices/pci0000:00/0000:00:02.0/usb2/2-2/2-2:1.0/uevent
>> CPU 1
>> Modules linked in: radio_mr800 v4l2_common videodev v4l1_compat
>> v4l2_compat_ioctl32 nls_iso8859_1 nls_cp437 vfat fat usb_storage
>> nls_utf8 cifs ext2 ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
>> nf_conntrack nf_defrag_ipv4 ip_tables x_tables ppp_async crc_ccitt
>> ppp_generic slhc cpufreq_powersave powernow_k8 freq_table
>> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
>> snd_pcm_oss snd_mixer_oss reiserfs usbhid hid snd_hda_codec_analog
>> snd_hda_intel ohci_hcd ehci_hcd snd_hda_codec snd_hwdep snd_pcm
>> snd_timer nvidia(P) snd usbcore soundcore snd_page_alloc rtc_cmos sg
>> rtc_core rtc_lib i2c_nforce2 forcedeth e100 nls_base k8temp mii
>> i2c_core hwmon thermal button [last unloaded: v4l2_compat_ioctl32]
>> Pid: 11790, comm: gnomeradio Tainted: P           2.6.31 #12 System Product Name
>> RIP: 0010:[<ffffffff8119222b>]  [<ffffffff8119222b>] dev_set_drvdata+0x25/0x30
>> RSP: 0018:ffff880031741e28  EFLAGS: 00010206
>> RAX: 0000000000000017 RBX: ffff88003c3a4030 RCX: ffffffff8109458a
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003c3a4030
>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>> R10: ffff880029391e70 R11: 0000000000000246 R12: ffffffff81349ec0
>> R13: ffff880029391e70 R14: ffff8800173d7000 R15: ffff88003fac8300
>> FS:  00007fa0f88e3750(0000) GS:ffff880002900000(0000) knlGS:00000000f7327a10
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 000000000000009f CR3: 000000003165c000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process gnomeradio (pid: 11790, threadinfo ffff880031740000, task
>> ffff88003bcc5820)
>> Stack:
>>  ffff8800173d7000 ffff88003c3a5a60 ffff88003c3a5a60 ffffffffa0c603cb
>> <0> ffff88003c3a5800 ffffffffa0c603e5 ffff88003c3a5800 ffff88003e400890
>> <0> ffffffff81349ec0 ffffffffa000d5c7 ffff8800331593c0 ffffffff8118fb37
>> Call Trace:
>>  [<ffffffffa0c603cb>] ? v4l2_device_disconnect+0x13/0x1c [videodev]
>>  [<ffffffffa0c603e5>] ? v4l2_device_unregister+0x11/0x4b [videodev]
>>  [<ffffffffa000d5c7>] ? usb_amradio_video_device_release+0x11/0x26 [radio_mr800]
>>  [<ffffffff8118fb37>] ? device_release+0x41/0x6a
>>  [<ffffffff81118bf3>] ? kobject_release+0x48/0x5e
>>  [<ffffffff81118bab>] ? kobject_release+0x0/0x5e
>>  [<ffffffff811198ad>] ? kref_put+0x41/0x4a
>>  [<ffffffffa0c5c2f3>] ? v4l2_release+0x33/0x37 [videodev]
>>  [<ffffffff81092dfd>] ? __fput+0x100/0x1c9
>>  [<ffffffff81090538>] ? filp_close+0x5f/0x6a
>>  [<ffffffff810905d4>] ? sys_close+0x91/0xc4
>>  [<ffffffff8100ad6b>] ? system_call_fastpath+0x16/0x1b
>> Code: 00 00 c3 31 c0 c3 55 48 89 f5 53 48 89 fb 48 83 ec 08 48 85 ff
>> 74 1b 48 83 7f 08 00 75 09 e8 45 de ff ff 85 c0 75 0b 48 8b 43 08 <48>
>> 89 a8 88 00 00 00 58 5b 5d c3 53 48 8b 87 80 00 00 00 48 89
>> RIP  [<ffffffff8119222b>] dev_set_drvdata+0x25/0x30
>>  RSP <ffff880031741e28>
>> CR2: 000000000000009f
>> ---[ end trace 897762e94cb738ad ]---
>>
>> and lsmod shows that radio-mr800 module is in use. The problem doesn't
>> exist with current driver.
>> I'm trying to find patch that provides such behaviour and for this
>> moment i can say that first six patches(among 14) don't broke the
>> driver.
>>
>>
>> --
>> Best regards, Klimov Alexey
>>
>
> I think I see the problem.. I think it's with #8 of the series..
> instead of removing that line, place it before the call to
> video_unregister_device. It must not be placed after since
> video_unregister_device may cause the entire structure to be freed. My
> reasoning behind removing it was due to the fact that
> video_unregister_device can cause usb_amradio_video_device_release to
> be called which in turn calls v4l2_device_disconnect.
>
> Regards,
>
> David Ellingsworth

Hello David,

looks like [RFC/RFT 08/14] Version 2 makes things right :)
Driver is living okay on sudden disconnect now.
Thank you for your work.

I have good feelings about this patchset, so if there is no objections..

Mauro, Douglas, you can use my ack for this patchset:

Acked-by: Alexey Klimov <klimov.linux@gmail.com>

-- 
Best regards, Klimov Alexey
