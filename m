Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:5242 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932638AbdHVNCE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 09:02:04 -0400
Date: Tue, 22 Aug 2017 15:55:17 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, bp@alien8.de, mchehab@kernel.org,
        daniel.vetter@intel.com, jani.nikula@linux.intel.com,
        seanpaul@chromium.org, airlied@linux.ie, g.liakhovetski@gmx.de,
        tomas.winkler@intel.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, boris.brezillon@free-electrons.com,
        marek.vasut@gmail.com, richard@nod.at, cyrille.pitchen@wedev4u.fr,
        peda@axentia.se, kishon@ti.com, bhelgaas@google.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        dvhart@infradead.org, andy@infradead.org, ohad@wizery.com,
        bjorn.andersson@linaro.org, freude@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        lduncan@suse.com, cleech@redhat.com, johan@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, greybus-dev@lists.linaro.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 15/15] usb: make device_type const
Message-ID: <20170822125517.GA27604@kuha.fi.intel.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
 <1503130946-2854-16-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503130946-2854-16-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 19, 2017 at 01:52:26PM +0530, Bhumika Goyal wrote:
> Make this const as it is only stored in the type field of a device
> structure, which is const.
> Done using Coccinelle.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/common/ulpi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
> index 930e8f3..4aa5195 100644
> --- a/drivers/usb/common/ulpi.c
> +++ b/drivers/usb/common/ulpi.c
> @@ -135,7 +135,7 @@ static void ulpi_dev_release(struct device *dev)
>  	kfree(to_ulpi_dev(dev));
>  }
>  
> -static struct device_type ulpi_dev_type = {
> +static const struct device_type ulpi_dev_type = {
>  	.name = "ulpi_device",
>  	.groups = ulpi_dev_attr_groups,
>  	.release = ulpi_dev_release,

Thanks,

-- 
heikki
