Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52726 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbZLIRuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 12:50:05 -0500
Received: by fxm5 with SMTP id 5so7823228fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 09:50:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912090918n32ea33eq2658ea57b27dedaa@mail.gmail.com>
References: <ad6681df0912090617k768b7f22p9abfb462ff32026f@mail.gmail.com>
	<59cf47a80912090806j7f75c578g1fa5a638b2fd7c39@mail.gmail.com>
	<ad6681df0912090823s23c3dd11xe7b56b66803720d7@mail.gmail.com>
	<59cf47a80912090838h61deade9y5bbf846e92027c85@mail.gmail.com>
	<ad6681df0912090914o5e80c6fwa877ccb9580bc6d9@mail.gmail.com>
	<829197380912090918n32ea33eq2658ea57b27dedaa@mail.gmail.com>
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Wed, 9 Dec 2009 18:49:50 +0100
Message-ID: <ad6681df0912090949r108d1a81r481dc249d8f56868@mail.gmail.com>
Subject: Re: v4l-dvb from source on 2.6.31.5 opensuse kernel - not working
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Paulo Assis <pj.assis@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/12/9 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Wed, Dec 9, 2009 at 12:14 PM, Valerio Bontempi
>> Hi Paulo,
>>
>> no luck with your suggestion, I have no errors compiling and
>> installing the drivers but after rebooting it is not working at all.
>> Modprobe em28xx produces the same error already sent in the previous mail
>
> You're seeing an error when you modprobe?  What is the error?  Your
> dmesg did not show any errors, just that the driver didn't load.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Here is the error after modprobe

modprobe em28xx
WARNING: Error inserting ir_common
(/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/common/ir-common.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting v4l2_compat_ioctl32
(/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/v4l2-compat-ioctl32.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting v4l1_compat
(/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/v4l1-compat.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting videodev
(/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/videodev.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting v4l2_common
(/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/v4l2-common.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting em28xx
(/lib/modules/2.6.31.5-0.1-desktop/updates/kernel/drivers/media/video/em28xx/em28xx.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
