Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35224 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbeJ3VH2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 17:07:28 -0400
Date: Tue, 30 Oct 2018 09:14:09 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, jacopo mondi <jacopo@jmondi.org>
Subject: Re: [PATCH 3/4] SoC camera: Remove the framework and the drivers
Message-ID: <20181030091409.76b07620@coco.lan>
In-Reply-To: <20181030064311.030b6a81@coco.lan>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
 <20181029232134.25831-1-sakari.ailus@linux.intel.com>
 <20181030064311.030b6a81@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Oct 2018 01:21:34 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> The SoC camera framework has been obsolete for some time and it is no
> longer functional. A few drivers have been converted to the V4L2
> sub-device API but for the rest the conversion has not taken place yet.
> 
> In order to keep the tree clean and to avoid keep maintaining
> non-functional and obsolete code, remove the SoC camera framework as well
> as the drivers that depend on it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Resending, this time with git format-patch -D .
> 
>  MAINTAINERS                                        |    8 -
>  drivers/media/i2c/Kconfig                          |    8 -
>  drivers/media/i2c/Makefile                         |    1 -
>  drivers/media/i2c/soc_camera/Kconfig               |   66 -
>  drivers/media/i2c/soc_camera/Makefile              |   10 -
>  drivers/media/i2c/soc_camera/ov9640.h              |  208 --
>  drivers/media/i2c/soc_camera/soc_mt9m001.c         |  757 -------
>  drivers/media/i2c/soc_camera/soc_mt9t112.c         | 1157 -----------
>  drivers/media/i2c/soc_camera/soc_mt9v022.c         | 1012 ---------
>  drivers/media/i2c/soc_camera/soc_ov5642.c          | 1087 ----------
>  drivers/media/i2c/soc_camera/soc_ov772x.c          | 1123 ----------
>  drivers/media/i2c/soc_camera/soc_ov9640.c          |  738 -------
>  drivers/media/i2c/soc_camera/soc_ov9740.c          |  996 ---------
>  drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c      | 1415 -------------
>  drivers/media/i2c/soc_camera/soc_tw9910.c          |  999 ---------  

I don't see why we should remove those. I mean, Jacopo is
actually converting those drivers to not depend on soc_camera,
and it is a way better to review those patches with the old
code in place.

So, at least while Jacopo is keep doing this work, I would keep
at Kernel tree, as it helps to see a diff when the driver changes
when getting rid of soc_camera dependencies.

So, IMO, the best would be to move those to /staging, eventually
depending on BROKEN.

Thanks,
Mauro
