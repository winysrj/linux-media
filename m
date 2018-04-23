Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:27763 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755563AbeDWOLo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 10:11:44 -0400
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with
 COMPILE_TEST && DRM_OMAP
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <dri-devel@lists.freedesktop.org>, <linux-fbdev@vger.kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
 <c6ef815da57085bf7e98753463e551905f5d2706.1524245455.git.mchehab@s-opensource.com>
 <2542100.cElVns0SR0@amdc3058>
 <CGME20180423135655eucas1p1a935ce9c167e52cf1e76adcc0b4486e4@eucas1p1.samsung.com>
 <5379683.QunLsIS18Z@amdc3058>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <d155af94-539b-699a-73cc-7eae72bd9efa@ti.com>
Date: Mon, 23 Apr 2018 17:11:14 +0300
MIME-Version: 1.0
In-Reply-To: <5379683.QunLsIS18Z@amdc3058>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/04/18 16:56, Bartlomiej Zolnierkiewicz wrote:

> Ideally we should be able to build both drivers in the same kernel
> (especially as modules).
> 
> I was hoping that it could be fixed easily but then I discovered
> the root source of the problem:
> 
> drivers/gpu/drm/omapdrm/dss/display.o: In function `omapdss_unregister_display':
> display.c:(.text+0x2c): multiple definition of `omapdss_unregister_display'
> drivers/video/fbdev/omap2/omapfb/dss/display.o:display.c:(.text+0x198): first defined here

The main problem is that omapdrm and omapfb are two different drivers
for the same HW. You need to pick one, even if we would change those
functions and fix the link issue.

At some point in time we could compile both as modules (but not
built-in), but the only use for that was development/testing and in the
end made our life more difficult. So, now you must fully disable one of
them to enable the other. And, actually, we even have boot-time code,
not included in the module itself, which gets enabled when omapdrm is
enabled.

While it's of course good to support COMPILE_TEST, if using COMPILE_TEST
with omapfb is problematic, I'm not sure if it's worth to spend time on
that. We should be moving away from omapfb to omapdrm.

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
