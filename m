Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52588 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751176AbdJ0KI0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 06:08:26 -0400
Date: Fri, 27 Oct 2017 13:08:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jacob chen <jacob2.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rockchip/rga: annotate PM functions as
 __maybe_unused
Message-ID: <20171027100823.ao3hytbe4kdfossy@valkosipuli.retiisi.org.uk>
References: <20171019093044.531871-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019093044.531871-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 19, 2017 at 11:30:34AM +0200, Arnd Bergmann wrote:
> The newly added driver has incorrect #ifdef annotations on its
> PM functions, leading to a harmless compile-time warning when
> CONFIG_PM is disabled:
> 
> drivers/media/platform/rockchip/rga/rga.c:760:13: error: 'rga_disable_clocks' defined but not used [-Werror=unused-function]
>  static void rga_disable_clocks(struct rockchip_rga *rga)
>              ^~~~~~~~~~~~~~~~~~
> drivers/media/platform/rockchip/rga/rga.c:728:12: error: 'rga_enable_clocks' defined but not used [-Werror=unused-function]
> 
> This removes the #ifdef and marks the functions as __maybe_unused,
> so gcc can silently drop all the unused code.
> 
> Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
