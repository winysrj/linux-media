Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0044.outbound.protection.outlook.com ([104.47.0.44]:32157
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751084AbeCSF1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 01:27:25 -0400
From: Madalin-cristian Bucur <madalin.bucur@nxp.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Tejun Heo <tj@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Matias Bjorling <mb@lightnvm.io>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Richard Weinberger <richard@nod.at>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net"
        <linux1394-devel@lists.sourceforge.net>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 10/21] lightnvm: Remove depends on HAS_DMA in case of
 platform dependency
Date: Mon, 19 Mar 2018 05:27:16 +0000
Message-ID: <AM5PR04MB3267989AB6A81639F61AB165ECD40@AM5PR04MB3267.eurprd04.prod.outlook.com>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <1521208314-4783-11-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1521208314-4783-11-git-send-email-geert@linux-m68k.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Geert Uytterhoeven
> Sent: Friday, March 16, 2018 3:52 PM
> To: Christoph Hellwig <hch@lst.de>; Marek Szyprowski
> <m.szyprowski@samsung.com>; Robin Murphy <robin.murphy@arm.com>;
> Felipe Balbi <balbi@kernel.org>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; James E . J . Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K . Petersen
> <martin.petersen@oracle.com>; Andrew Morton <akpm@linux-
> foundation.org>; Mark Brown <broonie@kernel.org>; Liam Girdwood
> <lgirdwood@gmail.com>; Tejun Heo <tj@kernel.org>; Herbert Xu
> <herbert@gondor.apana.org.au>; David S . Miller <davem@davemloft.net>;
> Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>; Stefan Richter
> <stefanr@s5r6.in-berlin.de>; Alan Tull <atull@kernel.org>; Moritz Fischer
> <mdf@kernel.org>; Wolfram Sang <wsa@the-dreams.de>; Jonathan Cameron
> <jic23@kernel.org>; Joerg Roedel <joro@8bytes.org>; Matias Bjorling
> <mb@lightnvm.io>; Jassi Brar <jassisinghbrar@gmail.com>; Mauro Carvalho
> Chehab <mchehab@kernel.org>; Ulf Hansson <ulf.hansson@linaro.org>; David
> Woodhouse <dwmw2@infradead.org>; Brian Norris
> <computersforpeace@gmail.com>; Marek Vasut <marek.vasut@gmail.com>;
> Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>; Boris Brezillon
> <boris.brezillon@free-electrons.com>; Richard Weinberger <richard@nod.at>=
;
> Kalle Valo <kvalo@codeaurora.org>; Ohad Ben-Cohen <ohad@wizery.com>;
> Bjorn Andersson <bjorn.andersson@linaro.org>; Eric Anholt <eric@anholt.ne=
t>;
> Stefan Wahren <stefan.wahren@i2se.com>
> Cc: iommu@lists.linux-foundation.org; linux-usb@vger.kernel.org; linux-
> scsi@vger.kernel.org; alsa-devel@alsa-project.org; linux-ide@vger.kernel.=
org;
> linux-crypto@vger.kernel.org; linux-fbdev@vger.kernel.org; linux1394-
> devel@lists.sourceforge.net; linux-fpga@vger.kernel.org; linux-
> i2c@vger.kernel.org; linux-iio@vger.kernel.org; linux-block@vger.kernel.o=
rg;
> linux-media@vger.kernel.org; linux-mmc@vger.kernel.org; linux-
> mtd@lists.infradead.org; netdev@vger.kernel.org; linux-
> remoteproc@vger.kernel.org; linux-serial@vger.kernel.org; linux-
> spi@vger.kernel.org; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org; Geert Uytterhoeven <geert@linux-m68k.org>
> Subject: [PATCH v2 10/21] lightnvm: Remove depends on HAS_DMA in case of
> platform dependency
>=20
> Remove dependencies on HAS_DMA where a Kconfig symbol depends on
> another
> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
> In most cases this other symbol is an architecture or platform specific
> symbol, or PCI.
>=20
> Generic symbols and drivers without platform dependencies keep their
> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
> cannot work anyway.
>=20
> This simplifies the dependencies, and allows to improve compile-testing.
>=20
> Notes:
>   - FSL_FMAN keeps its dependency on HAS_DMA, as it calls set_dma_ops(),
>     which does not exist if HAS_DMA=3Dn (Do we need a dummy? The use of
>     set_dma_ops() in this driver is questionable),

Hi,

The set_dma_ops() is no longer required in the fsl/fman, I'll send a patch =
to remove it.

Thanks

>   - SND_SOC_LPASS_IPQ806X and SND_SOC_LPASS_PLATFORM loose their
>     dependency on HAS_DMA, as they are selected from
>     SND_SOC_APQ8016_SBC.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: Robin Murphy <robin.murphy@arm.com>
> ---
> v2:
>   - Add Reviewed-by, Acked-by,
>   - Drop RFC state,
>   - Split per subsystem.
> ---
>  drivers/lightnvm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/lightnvm/Kconfig b/drivers/lightnvm/Kconfig
> index 10c08982185a572f..9c03f35d9df113c6 100644
> --- a/drivers/lightnvm/Kconfig
> +++ b/drivers/lightnvm/Kconfig
> @@ -4,7 +4,7 @@
>=20
>  menuconfig NVM
>  	bool "Open-Channel SSD target support"
> -	depends on BLOCK && HAS_DMA && PCI
> +	depends on BLOCK && PCI
>  	select BLK_DEV_NVME
>  	help
>  	  Say Y here to get to enable Open-channel SSDs.
> --
> 2.7.4
