Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:52547 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3F2TM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Jun 2013 15:12:58 -0400
Message-ID: <51CF31B5.6020003@gmail.com>
Date: Sat, 29 Jun 2013 21:12:53 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: George Joseph <george.jp@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, a.hajda@samsung.com, ym.song@samsung.com
Subject: Re: [RFC PATCH 0/3] [media] s5p-jpeg: Add support for Exynos4x12
 and 5250
References: <1368532420-21555-1-git-send-email-george.jp@samsung.com>
In-Reply-To: <1368532420-21555-1-git-send-email-george.jp@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2013 01:53 PM, George Joseph wrote:
> From: George Joseph Palathingal<george.jp@samsung.com>
>
> This patch series refactors the JPEG driver to add code to support Exynos4x12
> and Exynos5250 JPEG IPs and makes the driver DT and CCF compliant.
>
> Exynos4210 JPEG driver supports only single planar image formats.
> The JPEG IP on Exynos4412 and 5250 supports multiplanar image formats as well.
> So the existing JPEG driver is refactored to support the JPEG h/w on all
> the three SoCs. The encoder/decoder functionalities are separated to
> two different files for better modularity.
>
> The encoder/decoder functionalities have been tested on Origen 4210, 4412 and SMDK 5250
> boards. There is currently an issue with the Exynos 4210 JPEG encoder which will be
> fixed in subsequent patches.
>
> The patch series is based on linux-next tree (20130514).

Hi,

Are you still working on it ? Are you planning to address my review
comments or are these works now abandoned ? I refrained from merging
my patch [1] that would at least allow to use the JPEG codec on
exynos4210 SoCs in mainline v3.11, as you guys indicated that you
were working on full support for the exynos4x12 and exynos5250 SoCs.
Now it's about v3.11 merge window and we are left with nothing. I'm
not happy. Please let me know if you're going to carry on with that
effort, if not someone from our team will complete that.
You seem to have already done most of the hard work, and I'm really
surprised it hasn't been completed, there was plenty time...

[1] https://patchwork.linuxtv.org/patch/18345/

Thanks,
Sylwester

> George Joseph Palathingal (2):
>    [media] s5p-jpeg: Add support for Exynos4x12 and 5250
>    [media] s5p-jpeg: Add DT support to JPEG driver
>
> Sylwester Nawrocki (1):
>    ARM: dts: Add documentation for Samsung JPEG driver bindings
>
>   .../devicetree/bindings/media/samsung-s5p-jpeg.txt |   21 +
>   drivers/media/platform/s5p-jpeg/Makefile           |    4 +-
>   drivers/media/platform/s5p-jpeg/jpeg-core.c        | 2041 +++++++++-----------
>   drivers/media/platform/s5p-jpeg/jpeg-core.h        |  428 ++--
>   drivers/media/platform/s5p-jpeg/jpeg-dec.c         |  489 +++++
>   drivers/media/platform/s5p-jpeg/jpeg-enc.c         |  521 +++++
>   drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h       |  528 +++++
>   drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c       |  614 ++++++
>   drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h       |   47 +
>   drivers/media/platform/s5p-jpeg/jpeg-hw.h          |  357 ----
>   drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h     |  171 ++
>   drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h     |  191 ++
>   drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  170 --
>   13 files changed, 3787 insertions(+), 1795 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/media/samsung-s5p-jpeg.txt
>   create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-dec.c
>   create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-enc.c
>   create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h
>   create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c
>   create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h
>   delete mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw.h
>   create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h
>   create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h
>   delete mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs.h
>
