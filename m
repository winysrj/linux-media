Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60622 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752273AbdK2H5g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 02:57:36 -0500
Date: Wed, 29 Nov 2017 09:57:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: ov13858: select V4L2_FWNODE
Message-ID: <20171129075733.6tkw4aipit7e6kui@valkosipuli.retiisi.org.uk>
References: <20171128103841.490119-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128103841.490119-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 28, 2017 at 11:38:00AM +0100, Arnd Bergmann wrote:
> v4l2_async_register_subdev_sensor_common() is only provided when
> CONFIG_V4L2_FWNODE is enabled, otherwise we get a link failure:
> 
> drivers/media/i2c/ov13858.o: In function `ov13858_probe':
> ov13858.c:(.text+0xf74): undefined reference to `v4l2_async_register_subdev_sensor_common'
> 
> This adds a Kconfig 'select' statement like all the other users of
> this interface have.
> 
> Fixes: 2e8a9fbb7950 ("media: ov13858: Add support for flash and lens devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This is the same patch I submitted for et8ek8 earlier. Both
> are needed for 4.15.

Hi Arnd,

Thanks for the patch. There's already a patch with the same change queued
up, so I'll use that instead.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
