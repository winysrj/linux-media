Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab2IOPfH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 11:35:07 -0400
Date: Sat, 15 Sep 2012 12:35:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PATCHES FOR v3.7] V4L: Exynos5 SoC GScaler driver
Message-ID: <20120915123500.41e1ae03@redhat.com>
In-Reply-To: <5034FB67.5060401@samsung.com>
References: <5034FB67.5060401@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 22 Aug 2012 17:31:51 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> Hi Mauro,
> 
> 
> The following changes since commit 01b0c11a1ba49ac96f58b7bc92772c2b469d6caa:
> 
>   [media] Kconfig: Fix b2c2 common code selection (2012-08-21 08:38:31 -0300)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/users/kmpark/linux-samsung v4l-exynos-gsc
> 
> for you to fetch changes up to 231560807f44daf9d1c2913e749c8a8609fc3c66:
> 
>   gscaler: Add Makefile for G-Scaler Driver (2012-08-22 10:36:49 +0200)
> 
> 
> This is a mem-to-mem driver for Exynos5 SoC series GScaler devices
> and an addition of multi-planar YVU420 fourcc.
> 
> ----------------------------------------------------------------
> Shaik Ameer Basha (2):
>       v4l: Add new YVU420 multi planar fourcc definition
>       gscaler: Add Makefile for G-Scaler Driver
> 
> Sungchun Kang (3):
>       gscaler: Add new driver for generic scaler
>       gscaler: Add core functionality for the G-Scaler driver
>       gscaler: Add m2m functionality for the G-Scaler driver
> 
>  Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml |  154 ++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
>  drivers/media/platform/Kconfig                     |    8 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/exynos-gsc/gsc-core.c       | 1253 ++++++++++++++++++++++++++++++
>  drivers/media/platform/exynos-gsc/gsc-core.h       |  527 +++++++++++++
>  drivers/media/platform/exynos-gsc/gsc-m2m.c        |  771 ++++++++++++++++++
>  drivers/media/platform/exynos-gsc/gsc-regs.c       |  425 ++++++++++
>  drivers/media/platform/exynos-gsc/gsc-regs.h       |  172 ++++
>  include/linux/videodev2.h                          |    1 +
>  10 files changed, 3313 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml
>  create mode 100644 drivers/media/platform/exynos-gsc/gsc-core.c
>  create mode 100644 drivers/media/platform/exynos-gsc/gsc-core.h
>  create mode 100644 drivers/media/platform/exynos-gsc/gsc-m2m.c
>  create mode 100644 drivers/media/platform/exynos-gsc/gsc-regs.c
>  create mode 100644 drivers/media/platform/exynos-gsc/gsc-regs.h

Huh!

You missed the gsc Makefile under drivers/media/platform/exynos-gsc/!

As I only noticed after merging/pushing it, I'll mark it as BROKEN, 
until you fix it.

Regards,
Mauro
