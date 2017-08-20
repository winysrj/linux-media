Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34624 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752783AbdHTMLa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 08:11:30 -0400
Received: by mail-wr0-f195.google.com with SMTP id p14so7865186wrg.1
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 05:11:29 -0700 (PDT)
Date: Sun, 20 Aug 2017 14:11:26 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: rjkm@metzlerbros.de, linux-media@vger.kernel.org,
        mchehab@kernel.org, jasmin@anw.at
Subject: Re: [PATCH] [media] ddbridge: add IOCTLs
Message-ID: <20170820141126.17b24bf1@audiostation.wuest.de>
In-Reply-To: <20170820085356.0aa87e66@vento.lan>
References: <20170820110855.7127-1-d.scheller.oss@gmail.com>
        <20170820085356.0aa87e66@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun, 20 Aug 2017 08:53:56 -0300
schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Sun, 20 Aug 2017 13:08:55 +0200
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > This patch adds back the IOCTL API/functionality which is present
> > in the upstream dddvb driver package. In comparison, the IOCTL
> > handler has been factored to a separate object (and with that, some
> > functionality from -core has been moved there aswell), the IOCTLs
> > are defined in an include in the uAPI, and ioctl-number.txt is
> > updated to document that there are IOCTLs present in this driver.
> > 
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > ---
> > This patch depends on the ddbridge-0.9.29 bump, see [1]. The
> > functionality was part of the driver before.
> > 
> > [1] http://www.spinics.net/lists/linux-media/msg119911.html
> > 
> >  Documentation/ioctl/ioctl-number.txt        |   1 +
> >  MAINTAINERS                                 |   1 +
> >  drivers/media/pci/ddbridge/Makefile         |   2 +-
> >  drivers/media/pci/ddbridge/ddbridge-core.c  | 111 +--------
> >  drivers/media/pci/ddbridge/ddbridge-ioctl.c | 334
> > ++++++++++++++++++++++++++++
> > drivers/media/pci/ddbridge/ddbridge-ioctl.h |  32 +++
> > include/uapi/linux/ddbridge-ioctl.h         | 110 +++++++++ 7 files
> > changed, 481 insertions(+), 110 deletions(-) create mode 100644
> > drivers/media/pci/ddbridge/ddbridge-ioctl.c create mode 100644
> > drivers/media/pci/ddbridge/ddbridge-ioctl.h create mode 100644
> > include/uapi/linux/ddbridge-ioctl.h
> > 
> > diff --git a/Documentation/ioctl/ioctl-number.txt
> > b/Documentation/ioctl/ioctl-number.txt index
> > 3e3fdae5f3ed..d78d1cd092d2 100644 ---
> > a/Documentation/ioctl/ioctl-number.txt +++
> > b/Documentation/ioctl/ioctl-number.txt @@ -215,6 +215,7 @@ Code
> > Seq#(hex)	Include File		Comments 'c'
> > A0-AF   arch/x86/include/asm/msr.h	conflict! 'd'
> > 00-FF	linux/char/drm/drm.h	conflict! 'd'
> > 02-40	pcmcia/ds.h		conflict! +'d'
> > 00-0B	linux/ddbridge-ioctl.h	conflict!  
> 
> That's where the problem with this patch starts: we don't add
> conflicts here :-)
> 
> We need more discussions with regards to the features added by this
> patchset.

Understood. The "good" thing is that this isn't a requirement to drive
any tuner boards (at the moment), however we shouldn't lose track on
this. Since this is the only complaint for now:

- We need to clear with Ralph if changing the MAGIC to something
  different is an option. In the end, if we change the userspace apps
  to include the uAPI header from mainline if available (else fallback
  to what ie. dddvb carries), I don't see an issue with this. But if
  userspace apps keep on using private stuff, this will break ofc.
- Other option: Fork dddvb and change userspace apps accordingly, and
  keep them in sync with upstream. Since we already have to care about
  the kernel part, this option is rather suboptimal.

Ralph, Ping :-)

> Anyway, I applied today the ddbridge patches we had. I solved a few
> conflicts while merging some things, so I'd appreciate if you could
> check if everything is ok. If not, please send patches :-)

Wohoooo! Thanks very much, especially for the mxl5xx! Looks like 4.14
will be a hell of a kernel for all DD card owners! :)

Will check if something's wrong now (saw you missed the stv0910
constify patch from Colin King) and shove out patches _today_ if
neccessary.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
