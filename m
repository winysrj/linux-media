Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52264 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaIJITq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 04:19:46 -0400
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHv3 1/3] [media] disable OMAP1 COMPILE_TEST
Date: Wed, 10 Sep 2014 10:19:41 +0200
Message-id: <1959112.4FzR3bzOGa@amdc1032>
In-reply-to: <3055703.v1cXzV8T6U@amdc1032>
References: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
 <3055703.v1cXzV8T6U@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, September 10, 2014 10:04:12 AM Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Tuesday, September 09, 2014 03:54:04 PM Mauro Carvalho Chehab wrote:
> > This driver depends on a legacy OMAP DMA API. So, it won't
> > compile-test on other archs.
> > 
> > While we might add stubs to the functions, this is not a
> > good idea, as the hole API should be replaced.
> 
> This is also not a good idea becaouse it would break the driver
> for OMAP1 once somebody enables COMPILE_TEST option while also
> having ARCH_OMAP1 enabled (which is perfectly fine and shouldn't
> cause the driver breakage).  In general COMPILE_TEST option is
> completely independent from the arch specific ones and it should
> not change behaviour of the existing code.

Small clarification:

I was of course referring to the original patch for the issue:

  https://lkml.org/lkml/2014/9/9/498

stubs can be added properly with using 

  #if defined(CONFIG_COMPILE_TEST) && !defined(CONFIG_ARCH_OMAP1)

similarly like it is handled for ARCH_QCOM in

  drivers/gpu/drm/msm/msm_drv.h

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

