Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33040 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754207AbdHXR0P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 13:26:15 -0400
Received: by mail-pg0-f53.google.com with SMTP id t3so696771pgt.0
        for <linux-media@vger.kernel.org>; Thu, 24 Aug 2017 10:26:15 -0700 (PDT)
Date: Thu, 24 Aug 2017 10:26:09 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
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
        freude@de.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jth@kernel.org, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com,
        johan@kernel.org, elder@kernel.org, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, greybus-dev@lists.linaro.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 11/15] remoteproc: make device_type const
Message-ID: <20170824172609.GF20643@builder>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
 <1503130946-2854-12-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503130946-2854-12-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat 19 Aug 01:22 PDT 2017, Bhumika Goyal wrote:

> Make this const as it is only stored in the type field of a device
> structure, which is const.
> Done using Coccinelle.
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Applied, thanks.

Regards,
Bjorn

> ---
>  drivers/remoteproc/remoteproc_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
> index 364ef28..48b2c5d 100644
> --- a/drivers/remoteproc/remoteproc_core.c
> +++ b/drivers/remoteproc/remoteproc_core.c
> @@ -1360,7 +1360,7 @@ static void rproc_type_release(struct device *dev)
>  	kfree(rproc);
>  }
>  
> -static struct device_type rproc_type = {
> +static const struct device_type rproc_type = {
>  	.name		= "remoteproc",
>  	.release	= rproc_type_release,
>  };
> -- 
> 1.9.1
> 
