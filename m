Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:59882 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751334AbeCPOhV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 10:37:21 -0400
Subject: Re: [PATCH v2 17/21] scsi: hisi_sas: Remove depends on HAS_DMA in
 case of platform dependency
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mark Brown" <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Tejun Heo <tj@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Jonathan Cameron" <jic23@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Matias Bjorling <mb@lightnvm.io>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Richard Weinberger <richard@nod.at>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Bjorn Andersson" <bjorn.andersson@linaro.org>,
        Eric Anholt <eric@anholt.net>,
        "Stefan Wahren" <stefan.wahren@i2se.com>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <1521208314-4783-18-git-send-email-geert@linux-m68k.org>
CC: <alsa-devel@alsa-project.org>, <linux-iio@vger.kernel.org>,
        <linux-fpga@vger.kernel.org>, <linux-remoteproc@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        <linux1394-devel@lists.sourceforge.net>,
        <devel@driverdev.osuosl.org>, <linux-scsi@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-crypto@vger.kernel.org>
From: John Garry <john.garry@huawei.com>
Message-ID: <0786b588-f165-6f71-7ede-7c26a27becbc@huawei.com>
Date: Fri, 16 Mar 2018 14:36:46 +0000
MIME-Version: 1.0
In-Reply-To: <1521208314-4783-18-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/03/2018 13:51, Geert Uytterhoeven wrote:
> Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
> In most cases this other symbol is an architecture or platform specific
> symbol, or PCI.
>
> Generic symbols and drivers without platform dependencies keep their
> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
> cannot work anyway.
>
> This simplifies the dependencies, and allows to improve compile-testing.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: Robin Murphy <robin.murphy@arm.com>

Acked-by: John Garry <john.garry@huawei.com>
