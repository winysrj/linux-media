Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:42248 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753086AbeDZGg6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:36:58 -0400
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with
 COMPILE_TEST && DRM_OMAP
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <dri-devel@lists.freedesktop.org>, <linux-fbdev@vger.kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
 <5379683.QunLsIS18Z@amdc3058> <d155af94-539b-699a-73cc-7eae72bd9efa@ti.com>
 <CGME20180425111319eucas1p163fa4f5f7f51bc854763ba3c3c87b605@eucas1p1.samsung.com>
 <2150137.NOxbZFYopW@amdc3058>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <3c2ec2ad-af4a-598d-7deb-660f259a222c@ti.com>
Date: Thu, 26 Apr 2018 09:36:29 +0300
MIME-Version: 1.0
In-Reply-To: <2150137.NOxbZFYopW@amdc3058>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/04/18 14:13, Bartlomiej Zolnierkiewicz wrote:
> 
> On Monday, April 23, 2018 05:11:14 PM Tomi Valkeinen wrote:
>> On 23/04/18 16:56, Bartlomiej Zolnierkiewicz wrote:
>>
>>> Ideally we should be able to build both drivers in the same kernel
>>> (especially as modules).
>>>
>>> I was hoping that it could be fixed easily but then I discovered
>>> the root source of the problem:
>>>
>>> drivers/gpu/drm/omapdrm/dss/display.o: In function `omapdss_unregister_display':
>>> display.c:(.text+0x2c): multiple definition of `omapdss_unregister_display'
>>> drivers/video/fbdev/omap2/omapfb/dss/display.o:display.c:(.text+0x198): first defined here
>>
>> The main problem is that omapdrm and omapfb are two different drivers
>> for the same HW. You need to pick one, even if we would change those
>> functions and fix the link issue.
> 
> With proper resource allocation in both drivers this shouldn't be
> a problem - the one which allocates resources first will be used
> (+ we can initialize omapdrm first in case it is built-in). This is
> how similar situations are handled in other kernel subsystems.

We have boot time code, which is always built-in, for both drivers which
adjusts device tree data. I imagine those could easily conflict. Maybe
there's something else too.

And it's not only about the main omapfb or omapdrm driver. We have
drivers for the encoders and panels. Those would conflict too. I guess
we could have the case where omapdrm probes, and then a panel driver
from omapfb probes.

Actually, many of the panel and encoder drivers probably have same
symbols too, which would prevent linking.

> It seems that the real root problem is commit f76ee892a99e ("omapfb:
> copy omapdss & displays for omapfb") from Dec 2015 which resulted in
> duplication of ~30 KLOC of code. The code in question seems to be
> both fbdev & drm independent:
> 
> "
>     * omapdss, located in drivers/video/fbdev/omap2/dss/. This is a driver for the
>       display subsystem IPs used on OMAP (and related) SoCs. It offers only a
>       kernel internal API, and does not implement anything for fbdev or drm.
>     
>     * omapdss panels and encoders, located in
>       drivers/video/fbdev/omap2/displays-new/. These are panel and external encoder
>       drivers, which use APIs offered by omapdss driver. These also don't implement
>       anything for fbdev or drm.
> "
> 
> While I understand some motives behind this change I'm not overall
> happy with it..

Neither was I, but I have to say it was a game-changer for omapdrm
development. Doing anything new on omapdrm meant trying to get it to
work on omapfb too (in the same commit, so cross-tree), and many changes
were just too complex to even try. After that commit we were free to
really start restructuring the code to fit the DRM world.

>> At some point in time we could compile both as modules (but not
>> built-in), but the only use for that was development/testing and in the
>> end made our life more difficult. So, now you must fully disable one of
>> them to enable the other. And, actually, we even have boot-time code,
>> not included in the module itself, which gets enabled when omapdrm is
>> enabled.
> 
> Do you mean some code in arch/arm/mach-omap2/ or something else?

That and the omapdss-boot-init.c we have for both omapfb and omapdrm.

>> While it's of course good to support COMPILE_TEST, if using COMPILE_TEST
>> with omapfb is problematic, I'm not sure if it's worth to spend time on
>> that. We should be moving away from omapfb to omapdrm.
> 
> Is there some approximate schedule for omapfb removal available?

Unfortunatey not. omapfb still has support for some legacy devices that
omapdrm doesn't support.

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
