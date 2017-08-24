Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55744 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753905AbdHXQgt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 12:36:49 -0400
Date: Thu, 24 Aug 2017 18:31:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bhumika Goyal <bhumirks@gmail.com>
cc: julia.lawall@lip6.fr, bp@alien8.de, mchehab@kernel.org,
        daniel.vetter@intel.com, jani.nikula@linux.intel.com,
        seanpaul@chromium.org, airlied@linux.ie, tomas.winkler@intel.com,
        dwmw2@infradead.org, computersforpeace@gmail.com,
        boris.brezillon@free-electrons.com, marek.vasut@gmail.com,
        richard@nod.at, cyrille.pitchen@wedev4u.fr, peda@axentia.se,
        kishon@ti.com, bhelgaas@google.com, thierry.reding@gmail.com,
        jonathanh@nvidia.com, dvhart@infradead.org, andy@infradead.org,
        ohad@wizery.com, bjorn.andersson@linaro.org, freude@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        lduncan@suse.com, cleech@redhat.com, johan@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, greybus-dev@lists.linaro.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 03/15] [media] i2c: make device_type const
In-Reply-To: <1503130946-2854-4-git-send-email-bhumirks@gmail.com>
Message-ID: <Pine.LNX.4.64.1708241830240.3709@axis700.grange>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
 <1503130946-2854-4-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 19 Aug 2017, Bhumika Goyal wrote:

> Make this const as it is only stored in the type field of a device
> structure, which is const.
> Done using Coccinelle.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/i2c/soc_camera/mt9t031.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
> index 714fb35..4802d30 100644
> --- a/drivers/media/i2c/soc_camera/mt9t031.c
> +++ b/drivers/media/i2c/soc_camera/mt9t031.c
> @@ -592,7 +592,7 @@ static int mt9t031_runtime_resume(struct device *dev)
>  	.runtime_resume		= mt9t031_runtime_resume,
>  };
>  
> -static struct device_type mt9t031_dev_type = {
> +static const struct device_type mt9t031_dev_type = {
>  	.name	= "MT9T031",
>  	.pm	= &mt9t031_dev_pm_ops,
>  };
> -- 
> 1.9.1
> 
