Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:36696 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753881AbeDZIUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 04:20:36 -0400
Date: Thu, 26 Apr 2018 11:20:29 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Guillermo O. Freschi" <kedrot@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alan Cox <alan@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        devel@driverdev.osuosl.org,
        Rene Hickersberger <renehickersberger@gmx.net>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aishwarya Pant <aishpant@gmail.com>
Subject: Re: [PATCH 0/9] Do some atomisp cleanups
Message-ID: <20180426082029.hqiaigjxraz2gh4a@paasikivi.fi.intel.com>
References: <cover.1523896259.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1523896259.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 16, 2018 at 12:37:03PM -0400, Mauro Carvalho Chehab wrote:
> When I started building media subsystem with the atomisp driver,
> I ended by adding several hacks on their Makefiles, in order to
> get rid of thousands of warnings. I felt a little guty of hiding how
> broken is this driver, so I decided t remove two Makefile hacks that
> affect sensors and fix the warnings. 
> 
> Yet, there's still one such hack at 
> drivers/staging/media/atomisp/pci/atomisp2/Makefile, with:
> 
> # HACK! While this driver is in bad shape, don't enable several warnings
> #       that would be otherwise enabled with W=1
> ccflags-y += $(call cc-disable-warning, implicit-fallthrough)
> ccflags-y += $(call cc-disable-warning, missing-prototypes)
> ccflags-y += $(call cc-disable-warning, missing-declarations)
> ccflags-y += $(call cc-disable-warning, suggest-attribute=format)
> ccflags-y += $(call cc-disable-warning, unused-const-variable)
> ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
> 
> Getting his of those is a big task, as there are thousands of warnings
> hidden there. In order to seriously get rid of them, one should start
> getting rid of the several abstraction layers at the driver and have
> hardware for test.
> 
> As I don't have any hardware to test, nor any reason why
> dedicating myself to such task, I'll just leave this task for others
> to do.

Thanks. Feel free to add:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

And take the patches through your tree.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
