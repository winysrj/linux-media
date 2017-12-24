Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:11200 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750860AbdLXJFR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Dec 2017 04:05:17 -0500
Subject: Re: [PATCH v3 00/27] kill devm_ioremap_nocache
To: Greg KH <gregkh@linuxfoundation.org>,
        Yisheng Xie <xieyisheng1@huawei.com>
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
References: <1514026525-32538-1-git-send-email-xieyisheng1@huawei.com>
 <20171223134831.GB10103@kroah.com>
From: christophe leroy <christophe.leroy@c-s.fr>
Message-ID: <b8ff7f17-7f2c-f220-9833-7ae5bd7343d5@c-s.fr>
Date: Sun, 24 Dec 2017 10:05:08 +0100
MIME-Version: 1.0
In-Reply-To: <20171223134831.GB10103@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Le 23/12/2017 à 14:48, Greg KH a écrit :
> On Sat, Dec 23, 2017 at 06:55:25PM +0800, Yisheng Xie wrote:
>> Hi all,
>>
>> When I tried to use devm_ioremap function and review related code, I found
>> devm_ioremap and devm_ioremap_nocache is almost the same with each other,
>> except one use ioremap while the other use ioremap_nocache.
> 
> For all arches?  Really?  Look at MIPS, and x86, they have different
> functions.
> 
>> While ioremap's
>> default function is ioremap_nocache, so devm_ioremap_nocache also have the
>> same function with devm_ioremap, which can just be killed to reduce the size
>> of devres.o(from 20304 bytes to 18992 bytes in my compile environment).
>>
>> I have posted two versions, which use macro instead of function for
>> devm_ioremap_nocache[1] or devm_ioremap[2]. And Greg suggest me to kill
>> devm_ioremap_nocache for no need to keep a macro around for the duplicate
>> thing. So here comes v3 and please help to review.
> 
> I don't think this can be done, what am I missing?  These functions are
> not identical, sorry for missing that before.

devm_ioremap() and devm_ioremap_nocache() are quite similar, both use 
devm_ioremap_release() for the release, why not just defining:

static void __iomem *__devm_ioremap(struct device *dev, resource_size_t 
offset,
			   resource_size_t size, bool nocache)
{
[...]
	if (nocache)
		addr = ioremap_nocache(offset, size);
	else
		addr = ioremap(offset, size);
[...]
}

then in include/linux/io.h

static inline void __iomem *devm_ioremap(struct device *dev, 
resource_size_t offset,
			   resource_size_t size)
{return __devm_ioremap(dev, offset, size, false);}

static inline void __iomem *devm_ioremap_nocache(struct device *dev, 
resource_size_t offset,
				   resource_size_t size);
{return __devm_ioremap(dev, offset, size, true);}

Christophe

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
