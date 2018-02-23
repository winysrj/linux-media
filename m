Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:38749 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751832AbeBWAm4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 19:42:56 -0500
Received: by mail-qk0-f195.google.com with SMTP id s198so8877495qke.5
        for <linux-media@vger.kernel.org>; Thu, 22 Feb 2018 16:42:56 -0800 (PST)
Message-ID: <1519346573.20954.10.camel@ndufresne.ca>
Subject: Re: [PATCH v2 0/3] Initial driver support for Xilinx M2M Video
 Scaler
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Rohit Athavale <rohit.athavale@xilinx.com>,
        devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org
Date: Thu, 22 Feb 2018 19:42:53 -0500
In-Reply-To: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
References: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 21 février 2018 à 14:43 -0800, Rohit Athavale a écrit :
> This patch series has three commits :
>  - Driver support for the Xilinx M2M Video Scaler IP
>  - TODO document
>  - DT binding doc
> 
> Changes in HW register map is expected as the IP undergoes changes.
> This is a first attempt at the driver as an early prototype.
> 
> This is a M2M Video Scaler IP that uses polyphases filters to perform
> video scaling. The driver will be used by an application like a
> gstreamer plugin.

I'm hoping you know all this already, but just in case, rebasing your
driver on videobuf2-v4l2.h interface would be automatically supported
by GStreamer, and likely a better proposal for upstreaming.

There few drivers already that could be use as an inspiration.

./drivers/media/platform/vim2m.c: Which demonstrate the API
./drivers/media/platform/exynos4-is/: Exynos4 imaging functions
./drivers/media/platform/exynos-gsc/: Exynos4 scaler (and more)
./drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c: MediaTek CSC/Scale
./drivers/media/platform/s5p-g2d/g2d.c: A 2D blitter iirc ?
. . .

I don't know them all, I have developped the GStreamer code with the
Exynos4/5 platform, but also had success report on IMX6 (not upstream
yet apparently). With the framework, you'll gain DMABuf with very
little code.

> 
> Change Log:
> 
> v2 
>  - Cc'ing linux-media mailing list as suggested by Dan Carpenter.
>    Dan wanted to see if someone from linux-media can review the 
>    driver interface in xm2m_vscale.c to see if it makes sense.
>  - Another question would be the right place to keep the driver,
>    in drivers/staging/media or drivers/staging/ 
>  - Dropped empty mmap_open, mmap_close ops.
>  - Removed incorrect DMA_SHARED_BUFFER select from Kconfig
> v1 - Initial version
> 
> 
> Rohit Athavale (3):
>   staging: xm2mvscale: Driver support for Xilinx M2M Video Scaler
>   staging: xm2mvscale: Add TODO for the driver
>   Documentation: devicetree: bindings: Add DT binding doc for xm2mvsc
>     driver
> 
>  drivers/staging/Kconfig                            |   2 +
>  drivers/staging/Makefile                           |   1 +
>  .../devicetree/bindings/xm2mvscaler.txt            |  25 +
>  drivers/staging/xm2mvscale/Kconfig                 |  11 +
>  drivers/staging/xm2mvscale/Makefile                |   3 +
>  drivers/staging/xm2mvscale/TODO                    |  18 +
>  drivers/staging/xm2mvscale/ioctl_xm2mvsc.h         | 134 +++
>  drivers/staging/xm2mvscale/scaler_hw_xm2m.c        | 945
> +++++++++++++++++++++
>  drivers/staging/xm2mvscale/scaler_hw_xm2m.h        | 152 ++++
>  drivers/staging/xm2mvscale/xm2m_vscale.c           | 768
> +++++++++++++++++
>  drivers/staging/xm2mvscale/xvm2mvsc_hw_regs.h      | 204 +++++
>  11 files changed, 2263 insertions(+)
>  create mode 100644
> drivers/staging/xm2mvscale/Documentation/devicetree/bindings/xm2mvsca
> ler.txt
>  create mode 100644 drivers/staging/xm2mvscale/Kconfig
>  create mode 100644 drivers/staging/xm2mvscale/Makefile
>  create mode 100644 drivers/staging/xm2mvscale/TODO
>  create mode 100644 drivers/staging/xm2mvscale/ioctl_xm2mvsc.h
>  create mode 100644 drivers/staging/xm2mvscale/scaler_hw_xm2m.c
>  create mode 100644 drivers/staging/xm2mvscale/scaler_hw_xm2m.h
>  create mode 100644 drivers/staging/xm2mvscale/xm2m_vscale.c
>  create mode 100644 drivers/staging/xm2mvscale/xvm2mvsc_hw_regs.h
> 
