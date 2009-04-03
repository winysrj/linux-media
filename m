Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60001 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761030AbZDCKy0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 06:54:26 -0400
Date: Fri, 3 Apr 2009 12:54:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius Augulis <augulis.darius@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V3] Add camera (CSI) driver for MX1
In-Reply-To: <49D5E8A5.1080608@gmail.com>
Message-ID: <Pine.LNX.4.64.0904031252210.4729@axis700.grange>
References: <20090403080923.3222.80609.stgit@localhost.localdomain>
 <Pine.LNX.4.64.0904031204280.4729@axis700.grange> <49D5E8A5.1080608@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 3 Apr 2009, Darius Augulis wrote:

> Guennadi Liakhovetski wrote:
> > Ok, we're almost there:-) Should be the last iteration.
> > 
> > On Fri, 3 Apr 2009, Darius Augulis wrote:
> > 
> >   
> > > From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> > > 
> > > Changelog since V2:
> > > - My signed-off line added
> > > - Makefile updated
> > > - .init and .exit removed from pdata
> > > - includes sorted
> > > - Video memory limit added
> > > - Pointers in free_buffer() fixed
> > > - Indentation fixed
> > > - Spinlocks added
> > > - PM implementation removed
> > > - Added missed clk_put()
> > > - pdata test added
> > > - CSI device renamed
> > > - Platform flags fixed
> > > - "i.MX" replaced by "MX1" in debug prints
> > >     
> > 
> > I usually put such changelogs below the "---" line, so it doesn't appear in
> > the git commit message, and here you just put a short description of the
> > patch.
> > 
> >   
> > > Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> > > Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> > > ---
> > >     
> > 
> > [snip]
> > 
> >   
> > > diff --git a/arch/arm/plat-mxc/include/mach/memory.h
> > > b/arch/arm/plat-mxc/include/mach/memory.h
> > > index e0783e6..7113b3e 100644
> > > --- a/arch/arm/plat-mxc/include/mach/memory.h
> > > +++ b/arch/arm/plat-mxc/include/mach/memory.h
> > > @@ -24,4 +24,12 @@
> > >  #define PHYS_OFFSET		UL(0x80000000)
> > >  #endif
> > >  +#if defined(CONFIG_MX1_VIDEO)
> > >     
> > 
> > This #ifdef is not needed any more now, the file is not compiled if
> > CONFIG_MX1_VIDEO is not defined.
> >   
> this header file is included by arch/arm/include/asm/memory.h
> By default dma bufer size is only 2Mbytes. If we remove this ifdef, this bufer
> will be increased to re-defined size.
> Therefore I suggest to leave this ifdef.

Ouch, sorry, I meant this one:

diff --git a/arch/arm/mach-mx1/ksym_mx1.c b/arch/arm/mach-mx1/ksym_mx1.c
new file mode 100644
index 0000000..9f1116b
--- /dev/null
+++ b/arch/arm/mach-mx1/ksym_mx1.c
@@ -0,0 +1,20 @@
+/*
+ * Exported ksyms of ARCH_MX1
+ *
+ * Copyright (C) 2008, Darius Augulis <augulis.darius@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+
+#if defined(CONFIG_MX1_VIDEO)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
