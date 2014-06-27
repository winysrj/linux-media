Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3479 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaF0Nzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 09:55:40 -0400
Message-ID: <53AD77BE.9010703@xs4all.nl>
Date: Fri, 27 Jun 2014 15:55:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>, gregkh@linuxfoundation.org,
	m.chehab@samsung.com, olebowle@gmx.com, ttmesterr@gmail.com,
	dheitmueller@kernellabs.com, cb.xiong@samsung.com,
	yongjun_wei@trendmicro.com.cn, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, crope@iki.fi,
	wade_farnsworth@mentor.com, ricardo.ribalda@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/base: add managed token dev resource
References: <cover.1403652043.git.shuah.kh@samsung.com> <ae186e950b2719174354f9a2262a072571143a46.1403652043.git.shuah.kh@samsung.com>
In-Reply-To: <ae186e950b2719174354f9a2262a072571143a46.1403652043.git.shuah.kh@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/25/2014 01:57 AM, Shuah Khan wrote:
> Add a managed token resource that can be created at device level
> which can be used as a large grain lock by diverse group of drivers
> such as the media drivers that share a resource.
>
> Media devices often have hardware resources that are shared
> across several functions. These devices appear as a group of
> independent devices. Each device implements a function which
> could be shared by one or more functions supported by the same
> device. For example, tuner is shared by analog and digital TV
> functions.
>
> Media drivers that control a single media TV stick are a
> diversified group. Analog and digital TV function drivers have
> to coordinate access to their shared functions.
>
> Some media devices provide multiple almost-independent functions.
> USB and PCI core aids in allowing multiple drivers to handle these
> almost-independent functions. In this model, a media device could
> have snd-usb-audio driving the audio function.
>
> As a result, snd-usb-audio driver has to coordinate with the media
> driver analog and digital function drivers.
>
> A shared managed resource framework at drivers/base level will
> allow a media device to be controlled by drivers that don't
> fall under drivers/media and share functions with other media
> drivers.
>
> Token resource manages a unique named string resource which is
> derived from common bus_name, and hardware address fields from
> the struct device.
>
> Interfaces:
>      devm_token_create()
>      devm_token_destroy()
>      devm_token_lock()
>      devm_token_unlock()
> Usage:
>      Create token: Call devm_token_create() with a token id string.
>      Lock token: Call devm_token_lock() to lock or try lock a token.
>      Unlock token: Call devm_token_unlock().
>      Destroy token: Call devm_token_destroy() to delete the token.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   drivers/base/Makefile        |    2 +-
>   drivers/base/token_devres.c  |  134 ++++++++++++++++++++++++++++++++++++++++++
>   include/linux/token_devres.h |   19 ++++++
>   3 files changed, 154 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/base/token_devres.c
>   create mode 100644 include/linux/token_devres.h
>
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 04b314e..924665b 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
>   			   driver.o class.o platform.o \
>   			   cpu.o firmware.o init.o map.o devres.o \
>   			   attribute_container.o transport_class.o \
> -			   topology.o container.o
> +			   topology.o container.o token_devres.o
>   obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
>   obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
>   obj-y			+= power/
> diff --git a/drivers/base/token_devres.c b/drivers/base/token_devres.c
> new file mode 100644
> index 0000000..86bcd25
> --- /dev/null
> +++ b/drivers/base/token_devres.c
> @@ -0,0 +1,134 @@
> +/*
> + * drivers/base/token_devres.c - managed token resource
> + *
> + * Copyright (c) 2014 Shuah Khan <shuah.kh@samsung.com>
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.

Just a small one:

I don't know the Samsung guidelines, but I would expect that the copyright is
with Samsung, not with you as well. You are the author, but you most likely
do not have the copyright, that's with Samsung.

Regards,

	Hans
