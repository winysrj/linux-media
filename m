Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64382 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053AbZLIQiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 11:38:24 -0500
Received: by fxm5 with SMTP id 5so7729332fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 08:38:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0912090823s23c3dd11xe7b56b66803720d7@mail.gmail.com>
References: <ad6681df0912090617k768b7f22p9abfb462ff32026f@mail.gmail.com>
	 <59cf47a80912090806j7f75c578g1fa5a638b2fd7c39@mail.gmail.com>
	 <ad6681df0912090823s23c3dd11xe7b56b66803720d7@mail.gmail.com>
Date: Wed, 9 Dec 2009 16:38:29 +0000
Message-ID: <59cf47a80912090838h61deade9y5bbf846e92027c85@mail.gmail.com>
Subject: Re: v4l-dvb from source on 2.6.31.5 opensuse kernel - not working
From: Paulo Assis <pj.assis@gmail.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/12/9 Valerio Bontempi <valerio.bontempi@gmail.com>:
> 2009/12/9 Paulo Assis <pj.assis@gmail.com>:
>> Hi,
>> I've just responded to a similar issue in the linux-uvc list:
>> https://lists.berlios.de/pipermail/linux-uvc-devel/2009-December/005391.html
>>
>> Do you also have insertion errors when modprobing the driver under opensuse?
>> If so just follow the instructions :D, they worked in the above case.
>>
>> Best regards,
>> Paulo
>>
>> 2009/12/9 Valerio Bontempi <valerio.bontempi@gmail.com>:
>>> Hi all,
>>>
>>> I am trying to install v4l-dvb drivers from source because my device
>>> (Terratec Cinergy T XS, usb device DVB only) isn't supported by
>>> official v4l-dvb released in last kernel version yet: it is simply
>>> detected with the wrong firmware, but modifing the source code of the
>>> driver is works fine, tested successfully on ubuntu 9.10 (I have
>>> already submitted the patch to v4l team).
>>>
>>> I compiled v4l-dvb drivers and installed them through make install,
>>> but then v4l-dvb driver is not working anymore: the video device is
>>> not created, and I don't find any information about my device in dmesg
>>> (neither the message about the wrong firmware). So I am supposing that
>>> v4l-dvb is not working at all.
>>>
>>> Does someone know how I can understand where is the problem?
>>>
>>> Best regards
>>>
>>> Valerio
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
> I checked I have no .gz file in whole /lib/modules dir and in its subdirectories
> but the ouput of 'modprobe em28xx' is
>
> #modprobe em28xx
> WARNING: Error inserting ir_common
> (/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/common/ir-common.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting v4l2_compat_ioctl32
> (/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/v4l2-compat-ioctl32.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting v4l1_compat
> (/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/v4l1-compat.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting videodev
> (/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/videodev.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting v4l2_common
> (/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/v4l2-common.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error inserting em28xx
> (/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx/em28xx.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
>
> and from dmesg
>
> [ 2080.998842] videobuf_vmalloc: disagrees about version of symbol
> videobuf_queue_core_init
> [ 2080.998864] videobuf_vmalloc: Unknown symbol videobuf_queue_core_init
> [ 2080.999053] videobuf_vmalloc: disagrees about version of symbol
> videobuf_queue_cancel
> [ 2080.999064] videobuf_vmalloc: Unknown symbol videobuf_queue_cancel
> [ 2476.403046] videobuf_vmalloc: disagrees about version of symbol
> videobuf_queue_core_init
> [ 2476.403066] videobuf_vmalloc: Unknown symbol videobuf_queue_core_init
> [ 2476.403277] videobuf_vmalloc: disagrees about version of symbol
> videobuf_queue_cancel
> [ 2476.403290] videobuf_vmalloc: Unknown symbol videobuf_queue_cancel
>

Valerio,
This is clearly caused by old modules still laying around.
In the case of Chris he just uninstalled then reinstalled everything
related to v4l then build v4l-dvb by following the instructions on the
v4l-dvb wiki (http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers):

# make distclean
# make menuconfig    [this is optional]
# make
# make install
# make unload
# modprobe em28xx

That solved is problem.

Best regards,
Paulo
