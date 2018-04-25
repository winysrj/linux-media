Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:62396 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbeDYJeR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 05:34:17 -0400
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with
 COMPILE_TEST && DRM_OMAP
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        <dri-devel@lists.freedesktop.org>, <linux-fbdev@vger.kernel.org>
References: <cover.1524245455.git.mchehab@s-opensource.com>
 <20180423170955.13421017@vento.lan>
 <70b5e60f-346e-4b34-8235-ce62de720a99@ti.com> <1818588.4EAHIaV2gL@avalon>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <dce06ad8-0035-81e6-9ec9-15009d13e374@ti.com>
Date: Wed, 25 Apr 2018 12:33:53 +0300
MIME-Version: 1.0
In-Reply-To: <1818588.4EAHIaV2gL@avalon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/04/18 12:03, Laurent Pinchart wrote:

> Could we trim down omapfb to remove support for the devices supported by 
> omapdrm ?

I was thinking about just that. But, of course, it's not quite
straightforward either.

We've got DSI manual update functionality in OMAP3-OMAP5 SoCs, which
covers a lot of devices. And VRFB on OMAP2/3. Those need omapfb.

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
