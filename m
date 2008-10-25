Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9P7FNAF022083
	for <video4linux-list@redhat.com>; Sat, 25 Oct 2008 03:15:23 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9P7EV6H023832
	for <video4linux-list@redhat.com>; Sat, 25 Oct 2008 03:14:31 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Tony Lindgren <tony@atomide.com>
Date: Sat, 25 Oct 2008 12:44:14 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D6297A8C@dbde02.ent.ti.com>
In-Reply-To: <20081024191325.GF16354@atomide.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-fbdev-devel@lists.sourceforge.net"
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: RE: [Linux-fbdev-devel] [PATCHv2 1/4] OMAP 2/3 DSS Library
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



> -----Original Message-----
> From: Tony Lindgren [mailto:tony@atomide.com]
> Sent: Saturday, October 25, 2008 12:43 AM
> To: Shah, Hardik
> Cc: linux-omap@vger.kernel.org; linux-fbdev-devel@lists.sourceforge.net;
> video4linux-list@redhat.com
> Subject: Re: [Linux-fbdev-devel] [PATCHv2 1/4] OMAP 2/3 DSS Library
> 
> Hi,
> 
> * Hardik Shah <hardik.shah@ti.com> [081024 03:16]:
> > Cleaned up the DSS Library according to open source comments
> >
> > Removed unused #ifdefs
> > Removed unused #defines
> > Minor cleanups done
> > Removed Architecture specific #ifdefs
> >
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > 		Hari Nagalla <hnagalla@ti.com>
> > 		Hardik Shah <hardik.shah@ti.com>
> > 		Manjunath Hadli <mrh@ti.com>
> > 		R Sivaraj <sivaraj@ti.com>
> > 		Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > ---
> >  arch/arm/plat-omap/Kconfig                 |    7 +
> >  arch/arm/plat-omap/Makefile                |    2 +-
> >  arch/arm/plat-omap/include/mach/io.h       |    2 +-
> >  arch/arm/plat-omap/include/mach/omap-dss.h |  921 ++++++++++++
> >  arch/arm/plat-omap/omap-dss.c              | 2248
> ++++++++++++++++++++++++++++
> >  5 files changed, 3178 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/arm/plat-omap/include/mach/omap-dss.h
> >  create mode 100644 arch/arm/plat-omap/omap-dss.c
> >
> > diff --git a/arch/arm/plat-omap/include/mach/io.h b/arch/arm/plat-
> omap/include/mach/io.h
> > index ea55267..2495656 100644
> > --- a/arch/arm/plat-omap/include/mach/io.h
> > +++ b/arch/arm/plat-omap/include/mach/io.h
> > @@ -142,11 +142,11 @@
> >  #define OMAP343X_SDRC_VIRT	0xFD000000
> >  #define OMAP343X_SDRC_SIZE	SZ_1M
> >
> > -
> >  #define IO_OFFSET		0x90000000
> >  #define __IO_ADDRESS(pa)	((pa) + IO_OFFSET)/* Works for L3 and L4 */
> >  #define __OMAP2_IO_ADDRESS(pa)	((pa) + IO_OFFSET)/* Works for L3 and L4
> */
> >  #define io_v2p(va)		((va) - IO_OFFSET)/* Works for L3 and L4 */
> > +#define io_p2v(pa)		__IO_ADDRESS(pa)/* Works for L3 and L4 */
> >
> >  /* DSP */
> >  #define DSP_MEM_34XX_PHYS	OMAP34XX_DSP_MEM_BASE	/* 0x58000000 */
> 
> NAK for adding back io_p2v(). See below.
> 
> 
> > diff --git a/arch/arm/plat-omap/include/mach/omap-dss.h b/arch/arm/plat-
> omap/include/mach/omap-dss.h
> > new file mode 100644
> > index 0000000..d9a33bd
> > --- /dev/null
> > +++ b/arch/arm/plat-omap/include/mach/omap-dss.h
> > @@ -0,0 +1,921 @@
> > +/*
> > + * arch/arm/plat-omap/include/mach/omap-dss.h
> > + *
> > + * Copyright (C) 2004-2005 Texas Instruments.
> > + * Copyright (C) 2006 Texas Instruments.
> > + *
> > + * This file is licensed under the terms of the GNU General Public License
> > + * version 2. This program is licensed "as is" without any warranty of any
> > + * kind, whether express or implied.
> > +
> > + * Leveraged from original Linux 2.6 framebuffer driver for OMAP24xx
> > + * Author: Andy Lowe (source@mvista.com)
> > + * Copyright (C) 2004 MontaVista Software, Inc.
> > + *
> > + */
> > +
> > +#ifndef	__ASM_ARCH_OMAP_DISP_H
> > +#define	__ASM_ARCH_OMAP_DISP_H
> > +
> > +/* 16 bit uses LDRH/STRH, base +/- offset_8 */
> > +typedef struct {
> > +	volatile u16 offset[256];
> > +} __regbase16;
> > +#define __REGV16(vaddr)		(((__regbase16 *)((vaddr)&~0xff)) \
> > +					->offset[((vaddr)&0xff)>>1])
> > +#define __REG16(paddr)		 __REGV16(io_p2v(paddr))
> > +
> > +/* 8/32 bit uses LDR/STR, base +/- offset_12 */
> > +typedef struct {
> > +	volatile u8 offset[4096];
> > +} __regbase8;
> > +#define __REGV8(vaddr)		(((__regbase8  *)((vaddr)&~4095)) \
> > +					->offset[((vaddr)&4095)>>0])
> > +#define __REG8(paddr)		 __REGV8(io_p2v(paddr))
> > +
> > +typedef struct {
> > +	volatile u32 offset[4096];
> > +} __regbase32;
> > +#define __REGV32(vaddr)		(((__regbase32 *)((vaddr)&~4095)) \
> > +					->offset[((vaddr)&4095)>>2])
> > +#define __REG32(paddr)		__REGV32(io_p2v(paddr))
> > +
> 
> NAK for adding back the __REG stuff. We've just spent quite a bit of
> effort to remove these. The __REG stuff is not portable.
> 
> Please use ioremap and then __raw_read/write instead.
> 
[Shah, Hardik] Hi Tony,
Please let me know if there are any other obvious issues you can see for pushing onto git.  I will clear this all the send you the final version for pushing.

Regards,
Hardik 

> Regards,
> 
> Tony


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
