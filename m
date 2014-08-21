Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:64803 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaHUQBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 12:01:01 -0400
Received: by mail-ig0-f174.google.com with SMTP id c1so13531582igq.13
        for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 09:01:00 -0700 (PDT)
Date: Thu, 21 Aug 2014 17:00:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	SangYoung Son <hello.son@smasung.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v5 2/3] leds: Add support for max77693 mfd flash cell
Message-ID: <20140821160054.GQ4266@lee--X1>
References: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
 <1408542221-375-3-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408542221-375-3-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Aug 2014, Jacek Anaszewski wrote:

> This patch adds led-flash support to Maxim max77693 chipset.
> A device can be exposed to user space through LED subsystem
> sysfs interface or through V4L2 subdevice when the support
> for V4L2 Flash sub-devices is enabled. Device supports up to
> two leds which can work in flash and torch mode. Leds can
> be triggered externally or by software.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: SangYoung Son <hello.son@smasung.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/leds/Kconfig                 |    9 +
>  drivers/leds/Makefile                |    1 +
>  drivers/leds/leds-max77693.c         | 1048 ++++++++++++++++++++++++++++++++++
>  drivers/mfd/max77693.c               |    5 +-
>  include/linux/mfd/max77693-private.h |   59 ++
>  include/linux/mfd/max77693.h         |   40 ++

Please break the MFD changes out into a separate patch, I can't (at
first glace) see any reason why the changed need to be bundled
together like this.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
