Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33490 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751038AbdJRUxd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 16:53:33 -0400
Date: Wed, 18 Oct 2017 23:53:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v1 00/13] staging: atomisp: clean up bomb
Message-ID: <20171018205330.rjvlri6u4l6ntxzj@valkosipuli.retiisi.org.uk>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 27, 2017 at 09:24:55PM +0300, Andy Shevchenko wrote:
> The driver has been submitted with a limitation to few platforms and
> sensors which it does support. Even though two sensor drivers have no
> users neither on ACPI-enabled platforms, nor in current Linux kernel
> code. Patches 1 and 2 removes those drivers for now.
> 
> It seems new contributors follow cargo cult programming done by the
> original driver developers. It's neither good for code, nor for
> reviewing process. To avoid such issues in the future here are few clean
> up patches, i.e. patches 3, 4, 6. 13.
> 
> On top of this here are clean ups with regard to GPIO use. One may
> consider this as an intermediate clean up. This part toughly related to
> removal of unused sensor drivers in patches 1 and 2.
> 
> Patch series has been partially compile tested. It would be nice to see
> someone with hardware to confirm it doesn't break anything.
> 
> Andy Shevchenko (13):
>   staging: atomisp: Remove IMX sensor support
>   staging: atomisp: Remove AP1302 sensor support
>   staging: atomisp: Use module_i2c_driver() macro
>   staging: atomisp: Switch i2c drivers to use ->probe_new()
>   staging: atomisp: Do not set GPIO twice
>   staging: atomisp: Remove unneeded gpio.h inclusion
>   staging: atomisp: Remove ->gpio_ctrl() callback
>   staging: atomisp: Remove ->power_ctrl() callback
>   staging: atomisp: Remove unused members of camera_sensor_platform_data
>   staging: atomisp: Remove Gmin dead code #1
>   staging: atomisp: Remove Gmin dead code #2
>   staging: atomisp: Remove duplicate declaration in header
>   staging: atomisp: Remove FSF snail address

After chatting with Andy we figured out the first patch was actually
missing from the set, both on the mailing list and Patchwork. I've uploaded
it to the same branch, and the patch itself is here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=atomisp-andy&id=5ef68fbdbb80e72f3239363289fbf12f673988a1>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
