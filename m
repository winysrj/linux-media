Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35017 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932989AbdHVPVY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 11:21:24 -0400
Received: by mail-wr0-f193.google.com with SMTP id p8so20533366wrf.2
        for <linux-media@vger.kernel.org>; Tue, 22 Aug 2017 08:21:24 -0700 (PDT)
Date: Tue, 22 Aug 2017 17:21:16 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org, jasmin@anw.at
Subject: Re: [PATCH] [media] ddbridge: add IOCTLs
Message-ID: <20170822172116.3e039209@audiostation.wuest.de>
In-Reply-To: <22940.14881.588623.414208@morden.metzler>
References: <20170820110855.7127-1-d.scheller.oss@gmail.com>
        <20170820085356.0aa87e66@vento.lan>
        <20170820141126.17b24bf1@audiostation.wuest.de>
        <22940.14881.588623.414208@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Tue, 22 Aug 2017 16:05:21 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > Am Sun, 20 Aug 2017 08:53:56 -0300
>  > schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>  >   
>  > > Em Sun, 20 Aug 2017 13:08:55 +0200
>  > > Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
>  > >   
>  > > > From: Daniel Scheller <d.scheller@gmx.net>
>  > > > 
>  > > > This patch adds back the IOCTL API/functionality which is
>  > > > present in the upstream dddvb driver package. In comparison,
>  > > > the IOCTL handler has been factored to a separate object (and
>  > > > with that, some functionality from -core has been moved there
>  > > > aswell), the IOCTLs are defined in an include in the uAPI, and
>  > > > ioctl-number.txt is updated to document that there are IOCTLs
>  > > > present in this driver.
>  > > > 
>  > > > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
>  > > > ---
>  > > > This patch depends on the ddbridge-0.9.29 bump, see [1]. The
>  > > > functionality was part of the driver before.
>  > > > 
>  > > > [1] http://www.spinics.net/lists/linux-media/msg119911.html
>  > > > 
>  > > >  Documentation/ioctl/ioctl-number.txt        |   1 +
>  > > >  MAINTAINERS                                 |   1 +
>  > > >  drivers/media/pci/ddbridge/Makefile         |   2 +-
>  > > >  drivers/media/pci/ddbridge/ddbridge-core.c  | 111 +--------
>  > > >  drivers/media/pci/ddbridge/ddbridge-ioctl.c | 334
>  > > > ++++++++++++++++++++++++++++
>  > > > drivers/media/pci/ddbridge/ddbridge-ioctl.h |  32 +++
>  > > > include/uapi/linux/ddbridge-ioctl.h         | 110 +++++++++ 7
>  > > > files changed, 481 insertions(+), 110 deletions(-) create mode
>  > > > 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.c create mode
>  > > > 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.h create mode
>  > > > 100644 include/uapi/linux/ddbridge-ioctl.h
>  > > > 
>  > > > diff --git a/Documentation/ioctl/ioctl-number.txt
>  > > > b/Documentation/ioctl/ioctl-number.txt index
>  > > > 3e3fdae5f3ed..d78d1cd092d2 100644 ---
>  > > > a/Documentation/ioctl/ioctl-number.txt +++
>  > > > b/Documentation/ioctl/ioctl-number.txt @@ -215,6 +215,7 @@ Code
>  > > > Seq#(hex)	Include File		Comments 'c'
>  > > > A0-AF   arch/x86/include/asm/msr.h	conflict! 'd'
>  > > > 00-FF	linux/char/drm/drm.h	conflict! 'd'
>  > > > 02-40	pcmcia/ds.h		conflict! +'d'
>  > > > 00-0B	linux/ddbridge-ioctl.h	conflict!    
>  > > 
>  > > That's where the problem with this patch starts: we don't add
>  > > conflicts here :-)
>  > > 
>  > > We need more discussions with regards to the features added by
>  > > this patchset.  
>  > 
>  > Understood. The "good" thing is that this isn't a requirement to
>  > drive any tuner boards (at the moment), however we shouldn't lose
>  > track on this. Since this is the only complaint for now:
>  > 
>  > - We need to clear with Ralph if changing the MAGIC to something
>  >   different is an option. In the end, if we change the userspace
>  > apps to include the uAPI header from mainline if available (else
>  > fallback to what ie. dddvb carries), I don't see an issue with
>  > this. But if userspace apps keep on using private stuff, this will
>  > break ofc.
>  > - Other option: Fork dddvb and change userspace apps accordingly,
>  > and keep them in sync with upstream. Since we already have to care
>  > about the kernel part, this option is rather suboptimal.
>  > 
>  > Ralph, Ping :-)  
> 
> Changing to something different from 'd' should be fine.
> Is there anything still free?

We could use 0xDD (for *D*igital *D*evices :-) ), subrange 0xc0-0xff or
so, that isn't declared "in use" in ioctl-number.txt (0xDD/0x00-0x3f
is used by some ZFCP driver). Other options would be ie. 0xD0-0xDA,
0xDC, 0xDE-0xE4. There are also other single values and value-ranges
free, all according to ioctl-number.txt ofcourse.

Still yet not sure if this is everything that needs changing to be
accepted though.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
