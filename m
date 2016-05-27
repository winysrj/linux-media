Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:33188 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbcE0WCO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 18:02:14 -0400
Received: by mail-wm0-f48.google.com with SMTP id s131so6084747wme.0
        for <linux-media@vger.kernel.org>; Fri, 27 May 2016 15:02:13 -0700 (PDT)
Subject: Re: [PATCH] remove lots of IS_ERR_VALUE abuses
To: Arnd Bergmann <arnd@arndb.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1464384685-347275-1-git-send-email-arnd@arndb.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrzej Hajda <a.hajda@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	David Airlie <airlied@linux.ie>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Russell King <linux@armlinux.org.uk>,
	Bob Peterson <rpeterso@redhat.com>, linux-acpi@vger.kernel.org,
	iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	v9fs-developer@lists.sourceforge.net
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <5748C3E1.2060004@linaro.org>
Date: Fri, 27 May 2016 23:02:09 +0100
MIME-Version: 1.0
In-Reply-To: <1464384685-347275-1-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27/05/16 22:23, Arnd Bergmann wrote:
>   drivers/acpi/acpi_dbg.c                          | 22 +++++++++++-----------
>   drivers/ata/sata_highbank.c                      |  2 +-
>   drivers/clk/tegra/clk-tegra210.c                 |  2 +-
>   drivers/cpufreq/omap-cpufreq.c                   |  2 +-
>   drivers/crypto/caam/ctrl.c                       |  2 +-
>   drivers/dma/sun4i-dma.c                          | 16 ++++++++--------
>   drivers/gpio/gpio-xlp.c                          |  2 +-
>   drivers/gpu/drm/sti/sti_vtg.c                    |  4 ++--
>   drivers/gpu/drm/tilcdc/tilcdc_tfp410.c           |  2 +-
>   drivers/gpu/host1x/hw/intr_hw.c                  |  2 +-
>   drivers/iommu/arm-smmu-v3.c                      | 18 +++++++++---------
...
>   drivers/mmc/host/sdhci-of-at91.c                 |  2 +-
>   drivers/mmc/host/sdhci.c                         |  4 ++--
>   drivers/net/ethernet/freescale/fman/fman.c       |  2 +-
>   drivers/net/ethernet/freescale/fman/fman_muram.c |  4 ++--
>   drivers/net/ethernet/freescale/fman/fman_muram.h |  4 ++--
>   drivers/net/wireless/ti/wlcore/spi.c             |  4 ++--
>   drivers/nvmem/core.c                             | 22 +++++++++++-----------

For nvmem part,

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

>   drivers/tty/serial/amba-pl011.c                  |  2 +-
>   drivers/tty/serial/sprd_serial.c                 |  2 +-
>   drivers/video/fbdev/da8xx-fb.c                   |  4 ++--
>   fs/afs/write.c                                   |  4 ----
>   fs/binfmt_flat.c                                 |  6 +++---
>   fs/gfs2/dir.c                                    | 15 +++++++++------
>   kernel/pid.c                                     |  2 +-
>   net/9p/client.c                                  |  4 ++--
>   sound/soc/qcom/lpass-platform.c                  |  4 ++--
There is already a patch for this in Mark Brown's sound tree,

https://git.kernel.org/cgit/linux/kernel/git/broonie/sound.git/commit/?h=for-linus&id=cef794f76485f4a4e6affd851ae9f9d0eb4287a5

Thanks,
srini
>   38 files changed, 100 insertions(+), 101 deletions(-)
