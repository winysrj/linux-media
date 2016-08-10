Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38205 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbcHJSu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:50:27 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OBO006X7L6Q1050@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2016 07:40:02 +0100 (BST)
Subject: Re: [PATCHv2] s5p-tv: remove obsolete driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <2e2aa6f8-9eb7-cee3-6182-600b7c090f37@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <68e8d4e9-769b-cf83-1ad3-133a8218ad80@samsung.com>
Date: Wed, 10 Aug 2016 08:40:01 +0200
MIME-version: 1.0
In-reply-to: <2e2aa6f8-9eb7-cee3-6182-600b7c090f37@xs4all.nl>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2016 03:38 PM, Hans Verkuil wrote:
> The s5p-tv driver has been replaced by the exynos drm driver for quite a
> long time now. Remove this driver to avoid having duplicate drivers,
> of which this one is considered dead code by Samsung.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Second version: forgot to update MAINTAINERS, rewrote the commit log,
> and remove the s5p-tv include from platform/Kconfig.
> ---
>  MAINTAINERS                                     |    8 -
>  drivers/gpu/drm/exynos/Kconfig                  |    3 +-
>  drivers/media/platform/Kconfig                  |    1 -
>  drivers/media/platform/Makefile                 |    1 -
>  drivers/media/platform/s5p-tv/Kconfig           |   88 --
>  drivers/media/platform/s5p-tv/Makefile          |   19 -
>  drivers/media/platform/s5p-tv/hdmi_drv.c        | 1059 ---------------------
>  drivers/media/platform/s5p-tv/hdmiphy_drv.c     |  324 -------
>  drivers/media/platform/s5p-tv/mixer.h           |  364 --------
>  drivers/media/platform/s5p-tv/mixer_drv.c       |  527 -----------
>  drivers/media/platform/s5p-tv/mixer_grp_layer.c |  270 ------
>  drivers/media/platform/s5p-tv/mixer_reg.c       |  551 -----------
>  drivers/media/platform/s5p-tv/mixer_video.c     | 1130 -----------------------
>  drivers/media/platform/s5p-tv/mixer_vp_layer.c  |  242 -----
>  drivers/media/platform/s5p-tv/regs-hdmi.h       |  146 ---
>  drivers/media/platform/s5p-tv/regs-mixer.h      |  122 ---
>  drivers/media/platform/s5p-tv/regs-sdo.h        |   63 --
>  drivers/media/platform/s5p-tv/regs-vp.h         |   88 --
>  drivers/media/platform/s5p-tv/sdo_drv.c         |  497 ----------
>  drivers/media/platform/s5p-tv/sii9234_drv.c     |  407 --------
>  20 files changed, 1 insertion(+), 5909 deletions(-)
>  delete mode 100644 drivers/media/platform/s5p-tv/Kconfig
>  delete mode 100644 drivers/media/platform/s5p-tv/Makefile
>  delete mode 100644 drivers/media/platform/s5p-tv/hdmi_drv.c
>  delete mode 100644 drivers/media/platform/s5p-tv/hdmiphy_drv.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer.h
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_drv.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_grp_layer.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_reg.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_video.c
>  delete mode 100644 drivers/media/platform/s5p-tv/mixer_vp_layer.c
>  delete mode 100644 drivers/media/platform/s5p-tv/regs-hdmi.h
>  delete mode 100644 drivers/media/platform/s5p-tv/regs-mixer.h
>  delete mode 100644 drivers/media/platform/s5p-tv/regs-sdo.h
>  delete mode 100644 drivers/media/platform/s5p-tv/regs-vp.h
>  delete mode 100644 drivers/media/platform/s5p-tv/sdo_drv.c
>  delete mode 100644 drivers/media/platform/s5p-tv/sii9234_drv.c

Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


