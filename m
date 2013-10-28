Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:29015 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3J1WLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 18:11:43 -0400
Date: Mon, 28 Oct 2013 20:11:36 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org,
	Grant Likely <grant.likely@linaro.org>
Subject: Re: [GIT PULL FOR 3.13] Exynos5 SoC FIMC-IS imaging subsystem driver
Message-id: <20131028201136.6f66d3f7@samsung.com>
In-reply-to: <5261967E.6010001@samsung.com>
References: <5261967E.6010001@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Em Fri, 18 Oct 2013 22:13:50 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> Hi Mauro,
> 
> This change set is V4L2 driver for the Exynos5 series camera subsystem.
> There is also included a minimal driver for the s5k4e5 image sensor.
> 
> The FIMC-IS driver is pretty huge, even though there are some hardware 
> similarities between FIMC-IS found on Exynos5 and Exynos4 SoCs, the firmwares
> are significantly different, which makes writing a common driver not quite
> sensible.
> Anyway some of the exynos4 subdevs are already reused and some further code 
> consolidation will likely be possible.
> 
> The following changes since commit 8ca5d2d8e58df7235b77ed435e63c484e123fede:
> 
>   [media] uvcvideo: Fix data type for pan/tilt control (2013-10-17 06:55:29 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/snawrocki/samsung.git for-v3.13-2
> 
> for you to fetch changes up to 6eb89d71b27e6731755ab5722f3cdc0f6e8273f2:
> 
>   V4L: Add s5k4e5 sensor driver (2013-10-18 21:36:42 +0200)
> 
> ----------------------------------------------------------------
> Arun Kumar K (12):
>       exynos5-fimc-is: Add Exynos5 FIMC-IS device tree bindings documentation

As agreed during KS, the subsystem maintainers should wait for a documentation
review on DT by the DT maintainers, at least for a while.

So, I'd like to see either their reviews on this patch:
	https://patchwork.linuxtv.org/patch/20439/

Or their ack for us to apply it.

>       exynos5-fimc-is: Add driver core files
>       exynos5-fimc-is: Add common driver header files
>       exynos5-fimc-is: Add register definition and context header
>       exynos5-fimc-is: Add isp subdev
>       exynos5-fimc-is: Add scaler subdev
>       exynos5-fimc-is: Add sensor interface
>       exynos5-fimc-is: Add the hardware pipeline control
>       exynos5-fimc-is: Add the hardware interface module
>       exynos5-is: Add Kconfig and Makefile
>       V4L: Add DT binding doc for s5k4e5 image sensor

Same applies to this patch:
	https://patchwork.linuxtv.org/patch/20448/

Grant,

I'd appreciate if you could fast track those, as there are lots of code
depending on them.

Regards,
Mauro

>       V4L: Add s5k4e5 sensor driver
> 
> Shaik Ameer Basha (1):
>       exynos5-is: Add media device driver for exynos5 SoCs camera subsystem
> 
>  .../devicetree/bindings/media/exynos5-fimc-is.txt  |   84 +
>  .../bindings/media/exynos5250-camera.txt           |  126 ++
>  .../devicetree/bindings/media/samsung-s5k4e5.txt   |   45 +
>  drivers/media/i2c/Kconfig                          |    8 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/s5k4e5.c                         |  344 ++++
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/exynos5-is/Kconfig          |   20 +
>  drivers/media/platform/exynos5-is/Makefile         |    7 +
>  drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1210 ++++++++++++++
>  drivers/media/platform/exynos5-is/exynos5-mdev.h   |  126 ++
>  drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 +++
>  drivers/media/platform/exynos5-is/fimc-is-core.c   |  410 +++++
>  drivers/media/platform/exynos5-is/fimc-is-core.h   |  132 ++
>  drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++
>  .../media/platform/exynos5-is/fimc-is-interface.c  |  810 ++++++++++
>  .../media/platform/exynos5-is/fimc-is-interface.h  |  124 ++
>  drivers/media/platform/exynos5-is/fimc-is-isp.c    |  534 ++++++
>  drivers/media/platform/exynos5-is/fimc-is-isp.h    |   90 ++
>  .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++
>  drivers/media/platform/exynos5-is/fimc-is-param.h  | 1159 +++++++++++++
>  .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1699 ++++++++++++++++++++
>  .../media/platform/exynos5-is/fimc-is-pipeline.h   |  129 ++
>  drivers/media/platform/exynos5-is/fimc-is-regs.h   |  105 ++
>  drivers/media/platform/exynos5-is/fimc-is-scaler.c |  476 ++++++
>  drivers/media/platform/exynos5-is/fimc-is-scaler.h |  106 ++
>  drivers/media/platform/exynos5-is/fimc-is-sensor.c |   45 +
>  drivers/media/platform/exynos5-is/fimc-is-sensor.h |   65 +
>  drivers/media/platform/exynos5-is/fimc-is.h        |  160 ++
>  30 files changed, 9228 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>  create mode 100644 Documentation/devicetree/bindings/media/exynos5250-camera.txt
>  create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k4e5.txt
>  create mode 100644 drivers/media/i2c/s5k4e5.c
>  create mode 100644 drivers/media/platform/exynos5-is/Kconfig
>  create mode 100644 drivers/media/platform/exynos5-is/Makefile
>  create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
>  create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-regs.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-scaler.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-scaler.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.h
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is.h
> 
> --
> Thanks,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Cheers,
Mauro
