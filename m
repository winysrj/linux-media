Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35791 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2CCMhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 07:37:32 -0500
Received: by eekc41 with SMTP id c41so917751eek.19
        for <linux-media@vger.kernel.org>; Sat, 03 Mar 2012 04:37:30 -0800 (PST)
Message-ID: <4F521088.5080409@gmail.com>
Date: Sat, 03 Mar 2012 13:37:28 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: =?EUC-KR?B?vNu/tbjx?= <ym.song@samsung.com>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	andrzej.p@samsung.com
Subject: Re: [PATCH] media: jpeg: add driver for a version 2.x of jpeg H/W
References: <002e01ccf805$8a5c2000$9f146000$%song@samsung.com>
In-Reply-To: <002e01ccf805$8a5c2000$9f146000$%song@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 价康格,

On 03/02/2012 12:46 AM, 价康格 wrote:
> This patch add a driver for a version 2.x of jpeg H/W

s/add/adds
> in ths Samsung Exynos5 Soc.

s/ths/the
> A jpeg H/W version of Exynos4 SoC is 3.0
> 
> 1. Encoding
>   - input format : V4L2_PIX_FMT_RGB565X and V4L2_PIX_FMT_YUYV
> 
> 2. Decoding
>   - output format : V4L2_PIX_FMT_YUYV and V4L2_PIX_FMT_YUV420

Please consider reworking this patch so it can be applied on the latest s5p-jpeg driver 
changes adding JPEG controls:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/media-for-next 

> Signed-off-by: youngmok song<ym.song@samsung.com>

Normally the full name starts with capital letters.

> ---
>   drivers/media/video/Kconfig                   |   17 +
>   drivers/media/video/s5p-jpeg/Makefile         |    5 +-
>   drivers/media/video/s5p-jpeg/jpeg-core.c      |  303 +-------------------
>   drivers/media/video/s5p-jpeg/jpeg-hw-common.h |   34 +++
>   drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h    |  387 +++++++++++++++++++++++++
>   drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h  |  150 ++++++++++
>   drivers/media/video/s5p-jpeg/jpeg-v2x.c       |  129 ++++++++
>   drivers/media/video/s5p-jpeg/jpeg-v3.c        |  340 ++++++++++++++++++++++
>   8 files changed, 1066 insertions(+), 299 deletions(-)
>   create mode 100644 drivers/media/video/s5p-jpeg/jpeg-hw-common.h
>   create mode 100644 drivers/media/video/s5p-jpeg/jpeg-hw-v2x.h
>   create mode 100644 drivers/media/video/s5p-jpeg/jpeg-regs-v2x.h
>   create mode 100644 drivers/media/video/s5p-jpeg/jpeg-v2x.c
>   create mode 100644 drivers/media/video/s5p-jpeg/jpeg-v3.c
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 9adada0..551f925 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -1167,6 +1167,23 @@ config VIDEO_SAMSUNG_S5P_JPEG
>   	select V4L2_MEM2MEM_DEV
>   	---help---
>   	  This is a v4l2 driver for Samsung S5P and EXYNOS4 JPEG codec
> +choice
> +	prompt "JPEG V4L2 Driver"
> +	default S5P_JPEG_V3
> +	depends on VIDEO_SAMSUNG_S5P_JPEG
> +	---help---
> +	  Select version of MFC driver

MFC  ?

> +config S5P_JPEG_V3
> +	bool "JPEG 3.x"
> +	---help---
> +	  Use JPEG 3.x V4L2 Driver
> +
> +config S5P_JPEG_V2
> +	bool "JPEG 2.x"
> +	---help---
> +	  Use JPEG 2.x V4L2 Driver
> +endchoice

How the user is supposed to know which JPEG IP version applies to which SoC ?

Generally, resolving the hardware differences at compile time is not something that
we would want. I suggest using struct platform_device_id for handling different H/W 
variants, like it is done for example in drivers/dma/imx-sdma.c (see sdma_devtypes 
table). It will ease the driver's adaptation to instantiation from the device tree, which
is important, since the exynos5 is supposed to be a DT only platform.

Probably even function pointers at the variant data structure wouldn't hurt, if there
is too many differences to handle them through single flags. From a quick review it 
feels like the code could be consolidated more, but I'm going to leave commenting
on the details for Andrzej.

Please have a look at the JPEG controls:
http://git.infradead.org/users/kmpark/linux-samsung/commitdiff/e0122eabd2be3f0a3a9ff635df81e5c2509c4700
and feel free to propose anything you think is missing there (the Huffman and the 
quantization tables will need their own ioctl(s)).

As a side note, please don't use Korean characters in the patch message. This implies
the character set other than ascii/utf-8 and and makes patches impossible to apply.

 --

Regards,
Sylwester
