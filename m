Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50190 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751304AbdBOIm1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 03:42:27 -0500
Subject: Re: next build: 9 warnings 0 failures (next/next-20170215)
To: Arnd Bergmann <arnd@arndb.de>
References: <58a40b01.0469630a.f0ee0.f7d5@mx.google.com>
 <CAK8P3a14eLrkaokSzCSOw7EqGzzyvn6GVymQbmv9Ree6f_6OHg@mail.gmail.com>
 <3794acc6-5e96-3614-6c64-2454df62de77@xs4all.nl>
 <CAK8P3a08cXifgb=cw=2j+03wG4FFNO_KfsFfwmZX6ha==Ksb-Q@mail.gmail.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
        Olof's autobuilder <build@lixom.net>,
        Olof Johansson <olof@lixom.net>,
        kernel-build-reports@lists.linaro.org, linux-media@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <28590438-9689-4b30-6988-da5a5ae2e26d@xs4all.nl>
Date: Wed, 15 Feb 2017 09:42:22 +0100
MIME-Version: 1.0
In-Reply-To: <CAK8P3a08cXifgb=cw=2j+03wG4FFNO_KfsFfwmZX6ha==Ksb-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/15/2017 09:39 AM, Arnd Bergmann wrote:
> On Wed, Feb 15, 2017 at 9:30 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/15/2017 09:24 AM, Arnd Bergmann wrote:
>>> On Wed, Feb 15, 2017 at 9:02 AM, Olof's autobuilder <build@lixom.net> wrote:
> 
>>>>       1 drivers/media/platform/coda/imx-vdoa.c:333:571: warning: passing argument 1 of 'platform_driver_unregister' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>>>>       1 drivers/media/platform/coda/imx-vdoa.c:333:625: warning: passing argument 1 of 'platform_driver_unregister' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>>>>       1 drivers/usb/gadget/udc/atmel_usba_udc.c:636:38: warning: 'ept_cfg' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>>>       2 drivers/media/platform/coda/imx-vdoa.c:333:181: warning: passing argument 1 of '__platform_driver_register' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>>>
>>> This was "[media] coda/imx-vdoa: platform_driver should not be const",
>>> https://patchwork.linuxtv.org/patch/39288/ Hans already marked this as
>>> 'merged', so I assume it's on its way in, but just hasn't appeared in
>>> linux-next as of today.
>>
>> It's part of a pull request for 4.12 for Mauro to pick up. If this should
>> go into 4.10 or 4.11, then Greg should take this particular patch. Mauro is moving
>> to a new house this week and won't have time (or quite possibly even network
>> connectivity).
> 
> Ok, good to know, thanks for your quick reply. I checked the commit
> that caused the
> warning, d2fe28feaebb ("[media] coda/imx-vdoa: constify structs"), and
> it is currently
> part of git://linuxtv.org/media_tree.git#master . My fix should go on
> top of this branch
> and picked up by whoever is going to send it during the merge window.
> As I'm reverting
> half of Mauro's patch, we can't merge it through any other tree at the moment.

OK, we'll take care of this in that case.

I hope I'll remember this :-)

Regards,

	Hans
