Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41589 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754127AbeEaIHb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 04:07:31 -0400
Date: Thu, 31 May 2018 10:07:30 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: v4l: cadence: add VIDEO_V4L2 dependency
Message-ID: <20180531080730.cfkxyt5gwo2lhrgw@flea.home>
References: <20180530220735.1651221-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20180530220735.1651221-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 31, 2018 at 12:07:10AM +0200, Arnd Bergmann wrote:
> The cadence media drivers can be built-in while the v4l2 core is a loadable
> module. This is a mistake and leads to link errors:
> 
> drivers/media/v4l2-core/v4l2-fwnode.o: In function `v4l2_async_register_subdev_sensor_common':
> v4l2-fwnode.c:(.text+0x12f0): undefined reference to `v4l2_async_subdev_notifier_register'
> v4l2-fwnode.c:(.text+0x1304): undefined reference to `v4l2_async_register_subdev'
> v4l2-fwnode.c:(.text+0x1318): undefined reference to `v4l2_async_notifier_unregister'
> v4l2-fwnode.c:(.text+0x1338): undefined reference to `v4l2_async_notifier_cleanup'
> cdns-csi2rx.c:(.text+0x9f8): undefined reference to `v4l2_subdev_init'
> cdns-csi2rx.c:(.text+0xa78): undefined reference to `v4l2_async_register_subdev'
> drivers/media/platform/cadence/cdns-csi2tx.o: In function `csi2tx_remove':
> cdns-csi2tx.c:(.text+0x88): undefined reference to `v4l2_async_unregister_subdev'
> drivers/media/platform/cadence/cdns-csi2tx.o: In function `csi2tx_probe':
> cdns-csi2tx.c:(.text+0x884): undefined reference to `v4l2_subdev_init'
> cdns-csi2tx.c:(.text+0xa9c): undefined reference to `v4l2_async_register_subdev'
> 
> An explicit Kconfig dependency on VIDEO_V4L2 avoids the problem.
> 
> Fixes: 1fc3b37f34f6 ("media: v4l: cadence: Add Cadence MIPI-CSI2 RX driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Thanks!
Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
