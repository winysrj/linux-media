Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52716 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2GHUE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jul 2012 16:04:27 -0400
Received: by bkwj10 with SMTP id j10so5492479bkw.19
        for <linux-media@vger.kernel.org>; Sun, 08 Jul 2012 13:04:25 -0700 (PDT)
Message-ID: <4FF9E7CA.3090302@googlemail.com>
Date: Sun, 08 Jul 2012 22:04:26 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [regression 3.4->3.5, bisected] kernel oops when starting capturing
 from gspca-sn9c20x webcams
References: <4FF9B492.7010705@googlemail.com> <4FF9C6AD.2050806@redhat.com>
In-Reply-To: <4FF9C6AD.2050806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.07.2012 19:43, schrieb Hans de Goede:
> Hi,
>
> Thanks for reporting this!
>
> On 07/08/2012 06:25 PM, Frank Schäfer wrote:
>> Hi,
>>
>> running kernel 3.5.rc6 with the two gspca-sn9c20x webcams
>>
>> 0c45:62b3 Microdia PC Camera with Microphone (SN9C202 + OV9655)
>> 0c45:6270 Microdia PC Camera (SN9C201 + MI0360/MT9V011 or
>> MI0360SOC/MT9V111) U-CAM PC Camera NE878, Whitcom WHC017, ...
>>
>> I'm getting the following kernel oops when I start capturing with qv4l2
>> (and also Kopete and others):
>>
>> [   81.719973] gspca_sn9c20x: Set 640x480
>> [   81.736805] BUG: unable to handle kernel NULL pointer dereference at
>> 0000002c
>> [   81.736877] IP: [<f7aebb59>] v4l2_ctrl_g_ctrl+0x9/0x50 [videodev]
>> [   81.736901] *pdpt = 000000002c4fa001 *pde = 0000000000000000
>> [   81.736922] Oops: 0000 [#1] PREEMPT SMP
>> [   81.737055]
>> [   81.737071] Pid: 4026, comm: qv4l2 Not tainted 3.4.0-0.1-desktop+ #19
>> System manufacturer System Product Name/M2N-VM DH
>> [   81.737101] EIP: 0060:[<f7aebb59>] EFLAGS: 00010292 CPU: 1
>> [   81.737130] EIP is at v4l2_ctrl_g_ctrl+0x9/0x50 [videodev]
>> [   81.737147] EAX: 00000000 EBX: 00000000 ECX: f6c000c0 EDX: 00000001
>> [   81.737165] ESI: 00000028 EDI: 00000028 EBP: f5af9c84 ESP: f5af9c7c
>> [   81.737183]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> [   81.737200] CR0: 80050033 CR2: 0000002c CR3: 2c941000 CR4: 000007f0
>> [   81.737219] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> [   81.737236] DR6: ffff0ff0 DR7: 00000400
>> [   81.737252] Process qv4l2 (pid: 4026, ti=f5af8000 task=f594c030
>> task.ti=f5af8000)
>> [   81.737271] Stack:
>> [   81.737290]  00000028 f61c2000 f5af9cd0 f7d1c74c 0000007f 00000000
>> f5af9ca4 c0586ba1
>> [   81.737318]  ef190444 0000007f 00000080 000001e0 00000280 00000002
>> 00000000 02000100
>> [   81.737346]  003c2800 00f000a0 f61c2000 00000000 00000000 f5af9d84
>> f7b682c0 f71d8bec
>> [   81.737366] Call Trace:
>> [   81.737390]  [<f7d1c74c>] sd_start+0x2dc/0x450 [gspca_sn9c20x]
>> [   81.737421]  [<c0586ba1>] ? usb_alloc_coherent+0x21/0x30
>> [   81.737448]  [<f7b682c0>] gspca_init_transfer+0x260/0x420
>> [gspca_main]
>> [   81.737479]  [<c02ea322>] ? __alloc_pages_nodemask+0x142/0x7b0
>> [   81.737504]  [<f7b6926b>] vidioc_streamon+0x9b/0xb0 [gspca_main]
>> [   81.737535]  [<f7ae4919>] __video_do_ioctl+0x2ba9/0x5780 [videodev]
>> [   81.737565]  [<c031b7ee>] ? alloc_pages_current+0x8e/0x100
>> [   81.737588]  [<c0230998>] ? kmap_atomic_prot+0xe8/0x110
>> [   81.737611]  [<c04824ea>] ? __copy_from_user_ll+0x1a/0x30
>> [   81.737630]  [<c0482530>] ? _copy_from_user+0x30/0x50
>> [   81.737656]  [<f7ae1b0e>] video_usercopy+0x1de/0x270 [videodev]
>> [   81.737679]  [<c0309fc8>] ? mmap_region+0x1e8/0x4b0
>> [   81.737706]  [<f7ae1bb2>] video_ioctl2+0x12/0x20 [videodev]
>> [   81.737725]  [<f7ae1d70>] ? v4l2_norm_to_name+0x50/0x50 [videodev]
>> [   81.737725]  [<f7ae064a>] v4l2_ioctl+0xca/0x190 [videodev]
>> [   81.737725]  [<c030a401>] ? do_mmap_pgoff+0x171/0x2e0
>> [   81.737725]  [<f7ae0580>] ? v4l2_open+0x120/0x120 [videodev]
>> [   81.737725]  [<c0344074>] do_vfs_ioctl+0x74/0x2e0
>> [   81.737725]  [<c0344347>] sys_ioctl+0x67/0x80
>> [   81.737725]  [<c07242dd>] syscall_call+0x7/0xb
>> [   81.737725] Code: 55 f0 89 02 8b 46 10 8b 40 14 e8 03 61 c3 c8 89 f8
>> 83 c4 04 5b 5e 5f 5d c3 89 f6 8d bc 27 00 00 00 00 55 89 e5 53 89 c3 83
>> ec 04 <8b> 40 2c c7 45 f8 00 00 00 00 8d 50 fb 83 fa 02 77 09 80 b8 d3
>> [   81.737725] EIP: [<f7aebb59>] v4l2_ctrl_g_ctrl+0x9/0x50 [videodev]
>> SS:ESP 0068:f5af9c7c
>> [   81.737725] CR2: 000000000000002c
>> [   81.743027] ---[ end trace 1c291740d69b151f ]---
>>
>>
>> This is a regression from kernel 3.4.x.
>> The causing commit seems to be
>>
>>
>> commit 63069da1c8ef0abcdb74b0ea1c461d23fb9181d9
>> Author: Hans Verkuil <hans.verkuil@cisco.com>
>> Date:   Sun May 6 09:28:29 2012 -0300
>>
>>      [media] gcpca_sn9c20x: Convert to the control framework
>>
>>      HdG: Small fix: don't register some controls for sensors which
>> don't
>>      have an implementation for them.
>>
>>      Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>      Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>      Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>
>> Should I open a bug report at bugzilla, too ?
>
> That won't be necessary, the attached patch should fix this, can you
> give it a try please?

Thank you Hans, I can confirm that your patch fixes the oops for both
devices.

Regards,
Frank



>
> Thanks,
>
> Hans


