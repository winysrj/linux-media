Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaHZTU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 15:20:57 -0400
Message-ID: <53FCDE16.1000205@infradead.org>
Date: Tue, 26 Aug 2014 12:20:54 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>,
	Peter Foley <pefoley2@pefoley.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
	linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] [media] v4l2-pci-skeleton: Only build if PCI is available
References: <1409073919-27336-1-git-send-email-broonie@kernel.org>
In-Reply-To: <1409073919-27336-1-git-send-email-broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/14 10:25, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Currently arm64 does not support PCI but it does support v4l2. Since the
> PCI skeleton driver is built unconditionally as a module with no dependency
> on PCI this causes build failures for arm64 allmodconfig. Fix this by
> defining a symbol VIDEO_PCI_SKELETON for the skeleton and conditionalising
> the build on that.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
> 
> The patch adding the Makefile was added to the Documentation tree,
> either it should be reverted or something like this added on top.
> 
>  Documentation/video4linux/Makefile | 2 +-
>  drivers/media/v4l2-core/Kconfig    | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/video4linux/Makefile b/Documentation/video4linux/Makefile
> index d58101e788fc..65a351d75c95 100644
> --- a/Documentation/video4linux/Makefile
> +++ b/Documentation/video4linux/Makefile
> @@ -1 +1 @@
> -obj-m := v4l2-pci-skeleton.o
> +obj-$(CONFIG_VIDEO_PCI_SKELETON) := v4l2-pci-skeleton.o
> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> index 9ca0f8d59a14..2b368f711c9e 100644
> --- a/drivers/media/v4l2-core/Kconfig
> +++ b/drivers/media/v4l2-core/Kconfig
> @@ -25,6 +25,13 @@ config VIDEO_FIXED_MINOR_RANGES
>  
>  	  When in doubt, say N.
>  
> +config VIDEO_PCI_SKELETON
> +	tristate "Skeleton PCI V4L2 driver"
> +	depends on PCI && COMPILE_TEST

	               && ??  No, don't require COMPILE_TEST.
		However, PCI || COMPILE_TEST would allow it to build on arm64
		if COMPILE_TEST is enabled, guaranteeing build errors.
		Is that what should happen?  I suppose so...


> +	---help---
> +	  Enable build of the skeleton PCI driver, used as a reference
> +	  when developign new drivers.
> +
>  # Used by drivers that need tuner.ko
>  config VIDEO_TUNER
>  	tristate
> 


-- 
~Randy
