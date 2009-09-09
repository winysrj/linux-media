Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36193 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZIITIF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 15:08:05 -0400
Received: by ewy2 with SMTP id 2so4001846ewy.17
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 12:08:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d9def9db0909091202x64b54600s4c499f0f4042a8e6@mail.gmail.com>
References: <200909091814.10092.animatrix30@gmail.com>
	 <829197380909090919o613827d0ye00cbfe3bde888ed@mail.gmail.com>
	 <d9def9db0909091202x64b54600s4c499f0f4042a8e6@mail.gmail.com>
Date: Wed, 9 Sep 2009 21:08:04 +0200
Message-ID: <d9def9db0909091208w7bf93248p56d983aa6bfcbbf2@mail.gmail.com>
Subject: Re: Invalid module format
From: Markus Rechberger <mrechberger@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Edouard Marquez <animatrix30@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 9:02 PM, Markus Rechberger<mrechberger@gmail.com> wrote:
> On Wed, Sep 9, 2009 at 6:19 PM, Devin
> Heitmueller<dheitmueller@kernellabs.com> wrote:
>> On Wed, Sep 9, 2009 at 12:14 PM, Edouard Marquez<animatrix30@gmail.com> wrote:
>>> Hello,
>>>
>>> I am using Gentoo with tuxonice-sources-2.6.3.0-r5 that is to say 2.6.30.5.
>>> The compilation of v4l-dvb works well (the kernel which is chosen is the
>>> right), but when I try to modprobe em28xx, I get this :
>>>
>>> WARNING: Error inserting videobuf_core (/lib/modules/2.6.30-tuxonice-
>>> r5/kernel/drivers/media/video/videobuf-core.ko): Invalid module format
>>> WARNING: Error inserting videobuf_vmalloc (/lib/modules/2.6.30-tuxonice-
>>> r5/kernel/drivers/media/video/videobuf-vmalloc.ko): Invalid module format
>>> WARNING: Error inserting v4l2_compat_ioctl32 (/lib/modules/2.6.30-tuxonice-
>>> r5/kernel/drivers/media/video/v4l2-compat-ioctl32.ko): Invalid module format
>>> WARNING: Error inserting v4l1_compat (/lib/modules/2.6.30-tuxonice-
>>> r5/kernel/drivers/media/video/v4l1-compat.ko): Invalid module format
>>> WARNING: Error inserting videodev (/lib/modules/2.6.30-tuxonice-
>>> r5/kernel/drivers/media/video/videodev.ko): Invalid module format
>>> WARNING: Error inserting v4l2_common (/lib/modules/2.6.30-tuxonice-
>>> r5/kernel/drivers/media/video/v4l2-common.ko): Invalid module format
>>> WARNING: Error inserting ir_common (/lib/modules/2.6.30-tuxonice-
>>> r5/kernel/drivers/media/common/ir-common.ko): Invalid module format
>>> FATAL: Error inserting em28xx (/lib/modules/2.6.30-tuxonice-
>>> r5/kernel/drivers/media/video/em28xx/em28xx.ko): Invalid module format
>>>
>>> I have this error in my dmesg :
>>>
>>> [ 3903.465920] tveeprom: disagrees about version of symbol module_layout
>>>
>>> I join my .config file.
>>>
>>> What do I need to do ?
>>> Thanks!
>>>
>>
>> Usually this occurs when people are using the mrechberger version of
>> the em28xx driver, and the symbols are in conflict with the rest of
>> the v4l-dvb tree.
>>
>
> this is not true my old driver which is not available anymore did not
> ship any other modules aside the em28xx driver itself.
> This is a video4linux issue and has nothing to do with it.
>

Just a note aside of that it is not recommended to use any non
manufacturer certified driver.
The linux driver will decrease the lifetime of nearly any em28xx based
device or damage it permanently (as seen with the ATSC devices
recently). This is more or less the outcome of static reverse
engineered values from the windows driver which are not correct for
all devices and device modes. Although the GPL takes over that no
involved developer has any responsibility.

Best Regards,
Markus
