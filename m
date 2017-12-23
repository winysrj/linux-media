Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60160 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdLWNsc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Dec 2017 08:48:32 -0500
Date: Sat, 23 Dec 2017 14:48:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yisheng Xie <xieyisheng1@huawei.com>
Cc: linux-kernel@vger.kernel.org, ysxie@foxmail.com,
        ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        boris.brezillon@free-electrons.com, richard@nod.at,
        marek.vasut@gmail.com, cyrille.pitchen@wedev4u.fr,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        wim@iguana.be, linux@roeck-us.net, linux-watchdog@vger.kernel.org,
        b.zolnierkie@samsung.com, linux-fbdev@vger.kernel.org,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        ralf@linux-mips.org, linux-mips@linux-mips.org,
        lgirdwood@gmail.com, broonie@kernel.org, tglx@linutronix.de,
        jason@lakedaemon.net, marc.zyngier@arm.com, arnd@arndb.de,
        andriy.shevchenko@linux.intel.com,
        industrypack-devel@lists.sourceforge.net, wg@grandegger.com,
        mkl@pengutronix.de, linux-can@vger.kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, a.zummo@towertech.it,
        alexandre.belloni@free-electrons.com, linux-rtc@vger.kernel.org,
        daniel.vetter@intel.com, jani.nikula@linux.intel.com,
        seanpaul@chromium.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org,
        tj@kernel.org, linux-ide@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org, devel@driverdev.osuosl.org,
        dvhart@infradead.org, andy@infradead.org,
        platform-driver-x86@vger.kernel.org, jakub.kicinski@netronome.com,
        davem@davemloft.net, nios2-dev@lists.rocketboards.org,
        netdev@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        jslaby@suse.com
Subject: Re: [PATCH v3 00/27] kill devm_ioremap_nocache
Message-ID: <20171223134831.GB10103@kroah.com>
References: <1514026525-32538-1-git-send-email-xieyisheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514026525-32538-1-git-send-email-xieyisheng1@huawei.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 23, 2017 at 06:55:25PM +0800, Yisheng Xie wrote:
> Hi all,
> 
> When I tried to use devm_ioremap function and review related code, I found
> devm_ioremap and devm_ioremap_nocache is almost the same with each other,
> except one use ioremap while the other use ioremap_nocache.

For all arches?  Really?  Look at MIPS, and x86, they have different
functions.

> While ioremap's
> default function is ioremap_nocache, so devm_ioremap_nocache also have the
> same function with devm_ioremap, which can just be killed to reduce the size
> of devres.o(from 20304 bytes to 18992 bytes in my compile environment).
> 
> I have posted two versions, which use macro instead of function for
> devm_ioremap_nocache[1] or devm_ioremap[2]. And Greg suggest me to kill
> devm_ioremap_nocache for no need to keep a macro around for the duplicate
> thing. So here comes v3 and please help to review.

I don't think this can be done, what am I missing?  These functions are
not identical, sorry for missing that before.

thanks,

greg k-h
