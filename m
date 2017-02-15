Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39769 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750800AbdBOIab (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 03:30:31 -0500
Subject: Re: next build: 9 warnings 0 failures (next/next-20170215)
To: Arnd Bergmann <arnd@arndb.de>, gregkh <gregkh@linuxfoundation.org>
References: <58a40b01.0469630a.f0ee0.f7d5@mx.google.com>
 <CAK8P3a14eLrkaokSzCSOw7EqGzzyvn6GVymQbmv9Ree6f_6OHg@mail.gmail.com>
Cc: Olof's autobuilder <build@lixom.net>,
        Olof Johansson <olof@lixom.net>,
        kernel-build-reports@lists.linaro.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com, Jonathan Cameron <jic23@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3794acc6-5e96-3614-6c64-2454df62de77@xs4all.nl>
Date: Wed, 15 Feb 2017 09:30:24 +0100
MIME-Version: 1.0
In-Reply-To: <CAK8P3a14eLrkaokSzCSOw7EqGzzyvn6GVymQbmv9Ree6f_6OHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/15/2017 09:24 AM, Arnd Bergmann wrote:
> On Wed, Feb 15, 2017 at 9:02 AM, Olof's autobuilder <build@lixom.net> wrote:
>> Here are the build results from automated periodic testing.
> 
>>
>>         Warnings:               9
> 
> It seems we're closing in on zero again, with just two build regressions
> against 4.10 in linux-next. I did patches for both, and they made it into
> maintainer trees but not yet into linux-next
> 
>> Warnings:
>>
>>       1 drivers/iio/adc/rcar-gyroadc.c:398:26: warning: 'adcmode' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>       1 drivers/iio/adc/rcar-gyroadc.c:426:22: warning: 'sample_width' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>       1 drivers/iio/adc/rcar-gyroadc.c:428:23: warning: 'channels' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>       1 drivers/iio/adc/rcar-gyroadc.c:429:27: warning: 'num_channels' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> This was "iio: adc: handle unknow of_device_id data",
> http://lkml.iu.edu/hypermail/linux/kernel/1702.0/02707.html
> 
> Jonathan applied it into 'fixes-togreg-post-rc1', which is probably
> enough, though I'd expect that Greg would take it earlier as it
> addresses a (harmless) regression in -next.
> 
>>       1 drivers/media/platform/coda/imx-vdoa.c:333:571: warning: passing argument 1 of 'platform_driver_unregister' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>>       1 drivers/media/platform/coda/imx-vdoa.c:333:625: warning: passing argument 1 of 'platform_driver_unregister' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>>       1 drivers/usb/gadget/udc/atmel_usba_udc.c:636:38: warning: 'ept_cfg' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>       2 drivers/media/platform/coda/imx-vdoa.c:333:181: warning: passing argument 1 of '__platform_driver_register' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
> 
> This was "[media] coda/imx-vdoa: platform_driver should not be const",
> https://patchwork.linuxtv.org/patch/39288/ Hans already marked this as
> 'merged', so I assume it's on its way in, but just hasn't appeared in
> linux-next as of today.

It's part of a pull request for 4.12 for Mauro to pick up. If this should
go into 4.10 or 4.11, then Greg should take this particular patch. Mauro is moving
to a new house this week and won't have time (or quite possibly even network
connectivity).

Regards,

	Hans
