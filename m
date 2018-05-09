Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964972AbeEIT1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 15:27:23 -0400
Date: Wed, 9 May 2018 16:27:17 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [GIT PULL for 4.18] Cadence CSI-2 TX and RX drivers
Message-ID: <20180509162717.1ac86a29@vento.lan>
In-Reply-To: <20180507123543.nlcrl62nids2rirh@valkosipuli.retiisi.org.uk>
References: <20180507123543.nlcrl62nids2rirh@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 7 May 2018 15:35:43 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Here are the drivers for Cadence CSI-2 TX and RX hardware blocks.
> 
> Please pull.
> 
> 
> The following changes since commit f10379aad39e9da8bc7d1822e251b5f0673067ef:
> 
>   media: include/video/omapfb_dss.h: use IS_ENABLED() (2018-05-05 11:45:51 -0400)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git for-4.18-4
> 
> for you to fetch changes up to b2c23eb3e5f8ab0a54fc4aad875d12d127508f85:
> 
>   v4l: cadence: Add Cadence MIPI-CSI2 TX driver (2018-05-07 12:52:50 +0300)

Building it produce new warnings:

drivers/media/platform/cadence/cdns-csi2rx.c:177 csi2rx_start() warn: always true condition '(i >= 0) => (0-u32max >= 0)'
drivers/media/platform/cadence/cdns-csi2rx.c:177 csi2rx_start() warn: always true condition '(i >= 0) => (0-u32max >= 0)'
drivers/media/platform/cadence/cdns-csi2rx.c: In function 'csi2rx_start':
drivers/media/platform/cadence/cdns-csi2rx.c:177:11: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
  for (; i >= 0; i--)
           ^~

> 
> ----------------------------------------------------------------
> Maxime Ripard (4):
>       dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindings
>       v4l: cadence: Add Cadence MIPI-CSI2 RX driver
>       dt-bindings: media: Add Cadence MIPI-CSI2 TX Device Tree bindings
>       v4l: cadence: Add Cadence MIPI-CSI2 TX driver
> 
>  .../devicetree/bindings/media/cdns,csi2rx.txt      | 100 ++++
>  .../devicetree/bindings/media/cdns,csi2tx.txt      |  98 ++++
>  MAINTAINERS                                        |   7 +
>  drivers/media/platform/Kconfig                     |   1 +
>  drivers/media/platform/Makefile                    |   1 +
>  drivers/media/platform/cadence/Kconfig             |  34 ++
>  drivers/media/platform/cadence/Makefile            |   4 +
>  drivers/media/platform/cadence/cdns-csi2rx.c       | 498 ++++++++++++++++++
>  drivers/media/platform/cadence/cdns-csi2tx.c       | 563 +++++++++++++++++++++
>  9 files changed, 1306 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2rx.txt
>  create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2tx.txt
>  create mode 100644 drivers/media/platform/cadence/Kconfig
>  create mode 100644 drivers/media/platform/cadence/Makefile
>  create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c
>  create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c
> 



Thanks,
Mauro
