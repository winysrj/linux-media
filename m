Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:49066 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdF0TIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 15:08:21 -0400
Subject: Re: [PATCH] rpmsg: Solve circular dependencies involving RPMSG_VIRTIO
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Pallardy <loic.pallardy@st.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-remoteproc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
References: <20170627064309.16507-1-bjorn.andersson@linaro.org>
From: Suman Anna <s-anna@ti.com>
Message-ID: <d5e30779-00c0-6e56-e99e-811afbe28932@ti.com>
Date: Tue, 27 Jun 2017 14:08:05 -0500
MIME-Version: 1.0
In-Reply-To: <20170627064309.16507-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bjorn,

Thanks for the patch.

On 06/27/2017 01:43 AM, Bjorn Andersson wrote:
> While it's very common to use RPMSG for communicating with firmware
> running on these remoteprocs there is no functional dependency on RPMSG.

This is not entirely accurate though. RPMSG is the IPC transport on
these remoteprocs, you seem to suggest that there are alternatives for
these remoteprocs. Without RPMSG, you can boot, but you will not be able
to talk to the remoteprocs, so I would call it a functional dependency.

> As such RPMSG should be selected by the system integrator and not
> automatically by the remoteproc drivers.
> 
> This does solve problems reported with circular Kconfig dependencies for
> Davinci and Keystone remoteproc drivers.

The Keystone one issue shows up on linux-next (and not on 4.12-rcX) due
to the differing options on RESET_CONTROLLER on VIDEO_QCOM_VENUS
(through QCOM_SCOM). This can also be resolved by changing the depends
on RESET_CONTROLLER to a select RESET_CONTROLLER or dropping the line.

The davinci one is tricky though, as I did change it from using a select
to a depends on dependency, and obviously ppc64_defconfig is something
that I would not check.

This patch definitely resolves both issues, but it is not obvious that
someone would also have to enable RPMSG_VIRTIO to have these remoteprocs
useful when looking at either of the menuconfig help.

regards
Suman

> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/media/platform/Kconfig |  2 +-
>  drivers/remoteproc/Kconfig     |  4 ----
>  drivers/rpmsg/Kconfig          | 20 +++++++++-----------
>  3 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 1313cd533436..cb2f31cd0088 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -382,10 +382,10 @@ config VIDEO_STI_DELTA_DRIVER
>  	tristate
>  	depends on VIDEO_STI_DELTA
>  	depends on VIDEO_STI_DELTA_MJPEG
> +	depends on RPMSG
>  	default VIDEO_STI_DELTA_MJPEG
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
> -	select RPMSG
>  
>  endif # VIDEO_STI_DELTA
>  
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index b950e6cd4ba2..3b16f422d30c 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -21,7 +21,6 @@ config OMAP_REMOTEPROC
>  	depends on REMOTEPROC
>  	select MAILBOX
>  	select OMAP2PLUS_MBOX
> -	select RPMSG_VIRTIO
>  	help
>  	  Say y here to support OMAP's remote processors (dual M3
>  	  and DSP on OMAP4) via the remote processor framework.
> @@ -53,7 +52,6 @@ config DA8XX_REMOTEPROC
>  	depends on ARCH_DAVINCI_DA8XX
>  	depends on REMOTEPROC
>  	depends on DMA_CMA
> -	select RPMSG_VIRTIO
>  	help
>  	  Say y here to support DA8xx/OMAP-L13x remote processors via the
>  	  remote processor framework.
> @@ -76,7 +74,6 @@ config KEYSTONE_REMOTEPROC
>  	depends on ARCH_KEYSTONE
>  	depends on RESET_CONTROLLER
>  	depends on REMOTEPROC
> -	select RPMSG_VIRTIO
>  	help
>  	  Say Y here here to support Keystone remote processors (DSP)
>  	  via the remote processor framework.
> @@ -133,7 +130,6 @@ config ST_REMOTEPROC
>  	depends on REMOTEPROC
>  	select MAILBOX
>  	select STI_MBOX
> -	select RPMSG_VIRTIO
>  	help
>  	  Say y here to support ST's adjunct processors via the remote
>  	  processor framework.
> diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
> index 2a5d2b446de2..46f3f2431d68 100644
> --- a/drivers/rpmsg/Kconfig
> +++ b/drivers/rpmsg/Kconfig
> @@ -1,8 +1,5 @@
> -menu "Rpmsg drivers"
> -
> -# RPMSG always gets selected by whoever wants it
> -config RPMSG
> -	tristate
> +menuconfig RPMSG
> +	tristate "Rpmsg drivers"
>  
>  config RPMSG_CHAR
>  	tristate "RPMSG device interface"
> @@ -15,7 +12,7 @@ config RPMSG_CHAR
>  
>  config RPMSG_QCOM_GLINK_RPM
>  	tristate "Qualcomm RPM Glink driver"
> -	select RPMSG
> +	depends on RPMSG
>  	depends on HAS_IOMEM
>  	depends on MAILBOX
>  	help
> @@ -26,16 +23,17 @@ config RPMSG_QCOM_GLINK_RPM
>  config RPMSG_QCOM_SMD
>  	tristate "Qualcomm Shared Memory Driver (SMD)"
>  	depends on QCOM_SMEM
> -	select RPMSG
> +	depends on RPMSG
>  	help
>  	  Say y here to enable support for the Qualcomm Shared Memory Driver
>  	  providing communication channels to remote processors in Qualcomm
>  	  platforms.
>  
>  config RPMSG_VIRTIO
> -	tristate
> -	select RPMSG
> +	tristate "Virtio remote processor messaging driver (RPMSG)"
> +	depends on RPMSG
>  	select VIRTIO
>  	select VIRTUALIZATION
> -
> -endmenu
> +	help
> +	  Say y here to enable support for the Virtio remote processor
> +	  messaging protocol (RPMSG).
> 
