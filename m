Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:48065 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754582AbdDNP5h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 11:57:37 -0400
Date: Fri, 14 Apr 2017 11:57:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>, <linux-media@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging/media: make atomisp vlv2_plat_clock explicitly
 non-modular
Message-ID: <20170414155726.GX16239@windriver.com>
References: <20170413015755.4533-1-paul.gortmaker@windriver.com>
 <20170414081242.GA5096@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20170414081242.GA5096@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Re: [PATCH] staging/media: make atomisp vlv2_plat_clock explicitly non-modular] On 14/04/2017 (Fri 10:12) Greg Kroah-Hartman wrote:

> On Wed, Apr 12, 2017 at 09:57:55PM -0400, Paul Gortmaker wrote:
> > The Makefile / Kconfig currently controlling compilation of this code is:
> > 
> > clock/Makefile:obj-$(CONFIG_INTEL_ATOMISP)     += vlv2_plat_clock.o
> > 
> > atomisp/Kconfig:menuconfig INTEL_ATOMISP
> > atomisp/Kconfig:        bool "Enable support to Intel MIPI camera drivers"
> > 
> > ...meaning that it currently is not being built as a module by anyone.

[...]

> I'm pretty sure we want this code to be built as a module, so maybe a
> Kconfig change would resolve the issue instead?

As always, I'm good with things being moved to tristate if there is a use case
for it.  I will note that in this case however, that the above Kconfig option
is not specific to this file/driver.  It is controlling the inclusion of
several dirs/files, and so a more fine grained Kconfig may be required if some
are to be built-in and some are to be tristate...

P.

~/git/linux-head/drivers/staging/media/atomisp$ git grep 'obj.*INTEL_ATOMISP'
Makefile:obj-$(CONFIG_INTEL_ATOMISP) += pci/
Makefile:obj-$(CONFIG_INTEL_ATOMISP) += i2c/
Makefile:obj-$(CONFIG_INTEL_ATOMISP) += platform/
platform/Makefile:obj-$(CONFIG_INTEL_ATOMISP) += clock/
platform/Makefile:obj-$(CONFIG_INTEL_ATOMISP) += intel-mid/
platform/clock/Makefile:obj-$(CONFIG_INTEL_ATOMISP)     += vlv2_plat_clock.o
platform/clock/Makefile:obj-$(CONFIG_INTEL_ATOMISP)     += platform_vlv2_plat_clk.o
platform/intel-mid/Makefile:obj-$(CONFIG_INTEL_ATOMISP) += intel_mid_pcihelpers.o
platform/intel-mid/Makefile:obj-$(CONFIG_INTEL_ATOMISP) += atomisp_gmin_platform.o

> 
> Alan, any thoughts?
> 
> thanks,
> 
> greg k-h
