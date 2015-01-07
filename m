Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:25192 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbAGLqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 06:46:31 -0500
From: Tony K Nadackal <tony.kn@samsung.com>
To: 'Jacek Anaszewski' <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	mchehab@osg.samsung.com, kgene@kernel.org, k.debski@samsung.com,
	s.nawrocki@samsung.com, robh+dt@kernel.org, mark.rutland@arm.com,
	bhushan.r@samsung.com
References: <1418974680-5837-1-git-send-email-tony.kn@samsung.com>
 <1418974680-5837-2-git-send-email-tony.kn@samsung.com>
 <54AD058B.6070900@samsung.com>
In-reply-to: <54AD058B.6070900@samsung.com>
Subject: RE: [PATCH v2 1/2] [media] s5p-jpeg: Fix modification sequence of
 interrupt enable register
Date: Wed, 07 Jan 2015 17:16:44 +0530
Message-id: <000901d02a6f$b3ac62e0$1b0528a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wednesday, January 07, 2015 3:38 PM Jacek Anaszewski wrote,

> Hi Tony,
> 
> On 12/19/2014 08:37 AM, Tony K Nadackal wrote:
> > Fix the bug in modifying the interrupt enable register.
> 
> For Exynos4 this was not a bug as there are only five bit fields used in the
> EXYNOS4_INT_EN_REG - all of them enable related interrupt signal and
> EXYNOS4_INT_EN_ALL value is 0x1f which just sets these bit fields to 1.
> 

I agree that it is not a bug. 
I added the register read before modifying it to avoid any potential bugs in the
future.

> If for Exynos7 there are other bit fields in this register and it has to be
read prior
> setting to find out current state then I'd parametrize this function with
version
> argument as you do it in the patch adding support for Exynos7, but for Exynos4
> case I'd left the behaviour as it is currenlty, i.e.
> avoid reading the register and do it only for Exynos7 case.

Directly writing the value EXYNOS4_INT_EN_ALL (0x1B6 in Exynos7) to
EXYNOS4_INT_EN_REG works in case of Exynos7 too.
I  will parametrize this function with version to take care of the Exynos7 bit
fields.

> Effectively, this patch is not required, as it doesn't fix anything but adds
> redundant call to readl.
> 
> > Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> > ---
> >   drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > index e53f13a..a61ff7e 100644
> > --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > @@ -155,7 +155,10 @@ void exynos4_jpeg_set_enc_out_fmt(void __iomem
> > *base, unsigned int out_fmt)
> >
> >   void exynos4_jpeg_set_interrupt(void __iomem *base)
> >   {
> > -	writel(EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
> > +	unsigned int reg;
> > +
> > +	reg = readl(base + EXYNOS4_INT_EN_REG) & ~EXYNOS4_INT_EN_MASK;
> > +	writel(reg | EXYNOS4_INT_EN_ALL, base + EXYNOS4_INT_EN_REG);
> >   }
> >
> >   unsigned int exynos4_jpeg_get_int_status(void __iomem *base)
> >
> 
> 
> --
> Best Regards,
> Jacek Anaszewski

Thanks and Regards,
Tony

