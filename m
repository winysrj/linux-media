Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750784AbdDNIM4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 04:12:56 -0400
Date: Fri, 14 Apr 2017 10:12:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging/media: make atomisp vlv2_plat_clock explicitly
 non-modular
Message-ID: <20170414081242.GA5096@kroah.com>
References: <20170413015755.4533-1-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413015755.4533-1-paul.gortmaker@windriver.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 12, 2017 at 09:57:55PM -0400, Paul Gortmaker wrote:
> The Makefile / Kconfig currently controlling compilation of this code is:
> 
> clock/Makefile:obj-$(CONFIG_INTEL_ATOMISP)     += vlv2_plat_clock.o
> 
> atomisp/Kconfig:menuconfig INTEL_ATOMISP
> atomisp/Kconfig:        bool "Enable support to Intel MIPI camera drivers"
> 
> ...meaning that it currently is not being built as a module by anyone.
> 
> Lets remove the modular code that is essentially orphaned, so that
> when reading the driver there is no doubt it is builtin-only.
> 
> Since module_init was already not in use by this driver, the init
> ordering remains unchanged with this commit.
> 
> Also note that MODULE_DEVICE_TABLE is a no-op for non-modular code.
> 
> We also delete the MODULE_LICENSE tag etc. since all that information
> is already contained at the top of the file in the comments.
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: linux-media@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

I'm pretty sure we want this code to be built as a module, so maybe a
Kconfig change would resolve the issue instead?

Alan, any thoughts?

thanks,

greg k-h
