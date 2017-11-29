Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32938 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750849AbdK2Ign (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 03:36:43 -0500
Date: Wed, 29 Nov 2017 10:36:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-pci@vger.kernel.org, timur@codeaurora.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        intel-gfx@lists.freedesktop.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Valentin Vidic <Valentin.Vidic@CARNet.hr>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)"
        <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 22/29] [media] atomisp: deprecate
 pci_get_bus_and_slot()
Message-ID: <20171129083639.meuue7eooybr5u7o@valkosipuli.retiisi.org.uk>
References: <1511801886-6753-1-git-send-email-okaya@codeaurora.org>
 <1511801886-6753-23-git-send-email-okaya@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511801886-6753-23-git-send-email-okaya@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sinan,

On Mon, Nov 27, 2017 at 11:57:59AM -0500, Sinan Kaya wrote:
> diff --git a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
> index 4631b1d..51dcef57 100644
> --- a/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
> +++ b/drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
> @@ -39,7 +39,7 @@ static inline int platform_is(u8 model)
>  
>  static int intel_mid_msgbus_init(void)
>  {
> -	pci_root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
> +	pci_root = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
>  	if (!pci_root) {
>  		pr_err("%s: Error: msgbus PCI handle NULL\n", __func__);
>  		return -ENODEV;

This file has been removed, I'm applying the rest of the patch.

Please use the media tree as the base in the future. Thanks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
