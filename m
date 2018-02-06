Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:63489 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750990AbeBFNlQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 08:41:16 -0500
Date: Tue, 6 Feb 2018 14:40:35 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing
 with a mask
In-Reply-To: <20180206132335.luut6em3kut7f7ej@mwanda>
Message-ID: <alpine.DEB.2.20.1802061439110.3306@hadrien>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com> <20180206131044.oso33fvv553trrd7@mwanda> <alpine.DEB.2.20.1802061414340.3306@hadrien> <20180206132335.luut6em3kut7f7ej@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 6 Feb 2018, Dan Carpenter wrote:

> On Tue, Feb 06, 2018 at 02:15:51PM +0100, Julia Lawall wrote:
> >
> >
> > On Tue, 6 Feb 2018, Dan Carpenter wrote:
> >
> > > On Mon, Feb 05, 2018 at 09:09:57PM +0100, Wolfram Sang wrote:
> > > > In one Renesas driver, I found a typo which turned an intended bit shift ('<<')
> > > > into a comparison ('<'). Because this is a subtle issue, I looked tree wide for
> > > > similar patterns. This small patch series is the outcome.
> > > >
> > > > Buildbot and checkpatch are happy. Only compile-tested. To be applied
> > > > individually per sub-system, I think. I'd think only the net: amd: patch needs
> > > > to be conisdered for stable, but I leave this to people who actually know this
> > > > driver.
> > > >
> > > > CCing Dan. Maybe he has an idea how to add a test to smatch? In my setup, only
> > > > cppcheck reported a 'coding style' issue with a low prio.
> > > >
> > >
> > > Most of these are inside macros so it makes it complicated for Smatch
> > > to warn about them.  It might be easier in Coccinelle.  Julia the bugs
> > > look like this:
> > >
> > > -			reissue_mask |= 0xffff < 4;
> > > +			reissue_mask |= 0xffff << 4;
> >
> > Thanks.  I'll take a look.  Do you have an example of the macro issue
> > handy?
> >
>
> It's the same:
>
> #define EXYNOS_CIIMGEFF_PAT_CBCR_MASK          ((0xff < 13) | (0xff < 0))
>
> Smatch only sees the outside of the macro (where it is used in the code)
> and the pre-processed code.

I wrote the following rule:

@@
constant int x,y;
identifier i;
type T;
@@

(
i < x
|
x < i
|
 (T)i < x
|
x < (T)i
|
* x < y
)

and got the results below.  I can make a version for the kernel shortly.

julia

diff -u -p /run/shm/linux-next/drivers/gpu/drm/exynos/regs-fimc.h /tmp/nothing/drivers/gpu/drm/exynos/regs-fimc.h
--- /run/shm/linux-next/drivers/gpu/drm/exynos/regs-fimc.h
+++ /tmp/nothing/drivers/gpu/drm/exynos/regs-fimc.h
@@ -569,7 +569,6 @@
 #define EXYNOS_CIIMGEFF_FIN_EMBOSSING		(4 << 26)
 #define EXYNOS_CIIMGEFF_FIN_SILHOUETTE		(5 << 26)
 #define EXYNOS_CIIMGEFF_FIN_MASK			(7 << 26)
-#define EXYNOS_CIIMGEFF_PAT_CBCR_MASK		((0xff < 13) | (0xff < 0))

 /* Real input DMA size register */
 #define EXYNOS_CIREAL_ISIZE_AUTOLOAD_ENABLE	(1 << 31)
diff -u -p /run/shm/linux-next/drivers/net/ethernet/amd/xgbe/xgbe-drv.c /tmp/nothing/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
--- /run/shm/linux-next/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ /tmp/nothing/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -595,7 +595,6 @@ isr_done:

 		reissue_mask = 1 << 0;
 		if (!pdata->per_channel_irq)
-			reissue_mask |= 0xffff < 4;

 		XP_IOWRITE(pdata, XP_INT_REISSUE_EN, reissue_mask);
 	}
diff -u -p /run/shm/linux-next/drivers/video/fbdev/mxsfb.c /tmp/nothing/drivers/video/fbdev/mxsfb.c
--- /run/shm/linux-next/drivers/video/fbdev/mxsfb.c
+++ /tmp/nothing/drivers/video/fbdev/mxsfb.c
@@ -133,8 +133,6 @@
 #define VDCTRL4_SYNC_SIGNALS_ON		(1 << 18)
 #define SET_DOTCLK_H_VALID_DATA_CNT(x)	((x) & 0x3ffff)

-#define DEBUG0_HSYNC			(1 < 26)
-#define DEBUG0_VSYNC			(1 < 25)

 #define MIN_XRES			120
 #define MIN_YRES			120
diff -u -p /run/shm/linux-next/include/drm/drm_scdc_helper.h /tmp/nothing/include/drm/drm_scdc_helper.h
--- /run/shm/linux-next/include/drm/drm_scdc_helper.h
+++ /tmp/nothing/include/drm/drm_scdc_helper.h
@@ -50,9 +50,6 @@
 #define  SCDC_READ_REQUEST_ENABLE (1 << 0)

 #define SCDC_STATUS_FLAGS_0 0x40
-#define  SCDC_CH2_LOCK (1 < 3)
-#define  SCDC_CH1_LOCK (1 < 2)
-#define  SCDC_CH0_LOCK (1 < 1)
 #define  SCDC_CH_LOCK_MASK (SCDC_CH2_LOCK | SCDC_CH1_LOCK | SCDC_CH0_LOCK)
 #define  SCDC_CLOCK_DETECT (1 << 0)

diff -u -p /run/shm/linux-next/arch/um/drivers/vector_user.h /tmp/nothing/arch/um/drivers/vector_user.h
--- /run/shm/linux-next/arch/um/drivers/vector_user.h
+++ /tmp/nothing/arch/um/drivers/vector_user.h
@@ -61,8 +61,6 @@ struct vector_fds {
 };

 #define VECTOR_READ	1
-#define VECTOR_WRITE	(1 < 1)
-#define VECTOR_HEADERS	(1 < 2)

 extern struct arglist *uml_parse_vector_ifspec(char *arg);

diff -u -p /run/shm/linux-next/drivers/gpu/drm/mxsfb/mxsfb_regs.h /tmp/nothing/drivers/gpu/drm/mxsfb/mxsfb_regs.h
--- /run/shm/linux-next/drivers/gpu/drm/mxsfb/mxsfb_regs.h
+++ /tmp/nothing/drivers/gpu/drm/mxsfb/mxsfb_regs.h
@@ -91,8 +91,6 @@
 #define VDCTRL4_SYNC_SIGNALS_ON		(1 << 18)
 #define SET_DOTCLK_H_VALID_DATA_CNT(x)	((x) & 0x3ffff)

-#define DEBUG0_HSYNC			(1 < 26)
-#define DEBUG0_VSYNC			(1 < 25)

 #define MXSFB_MIN_XRES			120
 #define MXSFB_MIN_YRES			120
diff -u -p /run/shm/linux-next/drivers/media/platform/vsp1/vsp1_regs.h /tmp/nothing/drivers/media/platform/vsp1/vsp1_regs.h
--- /run/shm/linux-next/drivers/media/platform/vsp1/vsp1_regs.h
+++ /tmp/nothing/drivers/media/platform/vsp1/vsp1_regs.h
@@ -225,7 +225,6 @@
 #define VI6_RPF_MULT_ALPHA_P_MMD_RATIO	(1 << 8)
 #define VI6_RPF_MULT_ALPHA_P_MMD_IMAGE	(2 << 8)
 #define VI6_RPF_MULT_ALPHA_P_MMD_BOTH	(3 << 8)
-#define VI6_RPF_MULT_ALPHA_RATIO_MASK	(0xff < 0)
 #define VI6_RPF_MULT_ALPHA_RATIO_SHIFT	0

 /* -----------------------------------------------------------------------------
diff -u -p /run/shm/linux-next/drivers/media/dvb-frontends/stb0899_reg.h /tmp/nothing/drivers/media/dvb-frontends/stb0899_reg.h
--- /run/shm/linux-next/drivers/media/dvb-frontends/stb0899_reg.h
+++ /tmp/nothing/drivers/media/dvb-frontends/stb0899_reg.h
@@ -374,22 +374,18 @@

 #define STB0899_OFF0_IF_AGC_GAIN		0xf30c
 #define STB0899_BASE_IF_AGC_GAIN		0x00000000
-#define STB0899_IF_AGC_GAIN			(0x3fff < 0)
 #define STB0899_OFFST_IF_AGC_GAIN		0
 #define STB0899_WIDTH_IF_AGC_GAIN		14

 #define STB0899_OFF0_BB_AGC_GAIN		0xf310
 #define STB0899_BASE_BB_AGC_GAIN		0x00000000
-#define STB0899_BB_AGC_GAIN			(0x3fff < 0)
 #define STB0899_OFFST_BB_AGC_GAIN		0
 #define STB0899_WIDTH_BB_AGC_GAIN		14

 #define STB0899_OFF0_DC_OFFSET			0xf314
 #define STB0899_BASE_DC_OFFSET			0x00000000
-#define STB0899_I				(0xff < 8)
 #define STB0899_OFFST_I				8
 #define STB0899_WIDTH_I				8
-#define STB0899_Q				(0xff < 0)
 #define STB0899_OFFST_Q				8
 #define STB0899_WIDTH_Q				8
