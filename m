Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:59397 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZIIQTX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 12:19:23 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1351492fge.1
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 09:19:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909091814.10092.animatrix30@gmail.com>
References: <200909091814.10092.animatrix30@gmail.com>
Date: Wed, 9 Sep 2009 12:19:25 -0400
Message-ID: <829197380909090919o613827d0ye00cbfe3bde888ed@mail.gmail.com>
Subject: Re: Invalid module format
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Edouard Marquez <animatrix30@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 12:14 PM, Edouard Marquez<animatrix30@gmail.com> wrote:
> Hello,
>
> I am using Gentoo with tuxonice-sources-2.6.3.0-r5 that is to say 2.6.30.5.
> The compilation of v4l-dvb works well (the kernel which is chosen is the
> right), but when I try to modprobe em28xx, I get this :
>
> WARNING: Error inserting videobuf_core (/lib/modules/2.6.30-tuxonice-
> r5/kernel/drivers/media/video/videobuf-core.ko): Invalid module format
> WARNING: Error inserting videobuf_vmalloc (/lib/modules/2.6.30-tuxonice-
> r5/kernel/drivers/media/video/videobuf-vmalloc.ko): Invalid module format
> WARNING: Error inserting v4l2_compat_ioctl32 (/lib/modules/2.6.30-tuxonice-
> r5/kernel/drivers/media/video/v4l2-compat-ioctl32.ko): Invalid module format
> WARNING: Error inserting v4l1_compat (/lib/modules/2.6.30-tuxonice-
> r5/kernel/drivers/media/video/v4l1-compat.ko): Invalid module format
> WARNING: Error inserting videodev (/lib/modules/2.6.30-tuxonice-
> r5/kernel/drivers/media/video/videodev.ko): Invalid module format
> WARNING: Error inserting v4l2_common (/lib/modules/2.6.30-tuxonice-
> r5/kernel/drivers/media/video/v4l2-common.ko): Invalid module format
> WARNING: Error inserting ir_common (/lib/modules/2.6.30-tuxonice-
> r5/kernel/drivers/media/common/ir-common.ko): Invalid module format
> FATAL: Error inserting em28xx (/lib/modules/2.6.30-tuxonice-
> r5/kernel/drivers/media/video/em28xx/em28xx.ko): Invalid module format
>
> I have this error in my dmesg :
>
> [ 3903.465920] tveeprom: disagrees about version of symbol module_layout
>
> I join my .config file.
>
> What do I need to do ?
> Thanks!
>

Usually this occurs when people are using the mrechberger version of
the em28xx driver, and the symbols are in conflict with the rest of
the v4l-dvb tree.

You need to either switch to the v4l-dvb version of the driver
(removing the .ko files for the mrec driver), or recompile and
reinstall the mrec driver *after* you've installed the latest v4l-dvb
code.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
