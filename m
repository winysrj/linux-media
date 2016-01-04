Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54805 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbcADMxM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 07:53:12 -0500
Subject: Re: [PATCH 09/10] [media] tvp5150: Initialize the chip on probe
To: kbuild test robot <lkp@intel.com>
References: <201601042006.Dk9Wav4W%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <568A6B31.1080603@osg.samsung.com>
Date: Mon, 4 Jan 2016 09:53:05 -0300
MIME-Version: 1.0
In-Reply-To: <201601042006.Dk9Wav4W%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 01/04/2016 09:40 AM, kbuild test robot wrote:
> Hi Javier,
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on v4.4-rc8 next-20151231]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Javier-Martinez-Canillas/tvp5150-add-MC-and-DT-support/20160104-203224
> base:   git://linuxtv.org/media_tree.git master
> config: x86_64-randconfig-x008-01040711 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/media/i2c/tvp5150.c: In function 'tvp5150_init':
>>> drivers/media/i2c/tvp5150.c:1206:13: error: implicit declaration of function 'devm_gpiod_get_optional' [-Werror=implicit-function-declaration]
>      pdn_gpio = devm_gpiod_get_optional(&c->dev, "powerdown", GPIOD_OUT_HIGH);
>                 ^
>>> drivers/media/i2c/tvp5150.c:1206:59: error: 'GPIOD_OUT_HIGH' undeclared (first use in this function)
>      pdn_gpio = devm_gpiod_get_optional(&c->dev, "powerdown", GPIOD_OUT_HIGH);
>                                                               ^
>    drivers/media/i2c/tvp5150.c:1206:59: note: each undeclared identifier is reported only once for each function it appears in
>>> drivers/media/i2c/tvp5150.c:1211:3: error: implicit declaration of function 'gpiod_set_value_cansleep' [-Werror=implicit-function-declaration]
>       gpiod_set_value_cansleep(pdn_gpio, 0);
>

Sigh, it's caused by a missing include for the <linux/gpio/consumer.h> header.

Thanks for reporting, I'll wait a couple of days to see if I get more feedback
and then post a v2 fixing this.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
