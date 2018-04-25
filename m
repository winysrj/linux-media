Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:57222 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbeDYGYm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 02:24:42 -0400
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with
 COMPILE_TEST && DRM_OMAP
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <dri-devel@lists.freedesktop.org>, <linux-fbdev@vger.kernel.org>
References: <cover.1524245455.git.mchehab@s-opensource.com>
 <5379683.QunLsIS18Z@amdc3058> <20180423112227.61fbc02b@vento.lan>
 <2458408.nymfr4Soza@avalon> <20180423170955.13421017@vento.lan>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <70b5e60f-346e-4b34-8235-ce62de720a99@ti.com>
Date: Wed, 25 Apr 2018 09:24:14 +0300
MIME-Version: 1.0
In-Reply-To: <20180423170955.13421017@vento.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/04/18 23:09, Mauro Carvalho Chehab wrote:

>> I don't think it's worth it renaming the common symbols. They will change over 
>> time as omapdrm is under heavy rework, and it's painful enough without having 
>> to handle cross-tree changes.
> 
> It could just rename the namespace-conflicting FB_OMAP2 functions,
> keeping the DRM ones as-is.

Yes, I'm fine with renaming omapfb functions if that helps. But still,
if omapdrm is enabled in the kernel as module or built-in, omapfb will
not work. So even if we get them to compile and link, it'll break at
runtime one way or another.

>> Let's just live with the fact that both drivers 
>> can't be compiled at the same time, given that omapfb is deprecated.
> 
> IMO, a driver that it is deprecated, being in a state where it
> conflicts with a non-deprecated driver that is under heavy rework
> is a very good candidate to go to drivers/staging or even to /dev/null.

The problem is that it supports old devices which are not supported by
omapdrm. But both omapfb and omapdrm support many of the same devices.

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
