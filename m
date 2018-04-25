Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38596 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbeDYKCm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 06:02:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && DRM_OMAP
Date: Wed, 25 Apr 2018 13:02:51 +0300
Message-ID: <10529104.rM2F4eJv5O@avalon>
In-Reply-To: <dce06ad8-0035-81e6-9ec9-15009d13e374@ti.com>
References: <cover.1524245455.git.mchehab@s-opensource.com> <1818588.4EAHIaV2gL@avalon> <dce06ad8-0035-81e6-9ec9-15009d13e374@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Wednesday, 25 April 2018 12:33:53 EEST Tomi Valkeinen wrote:
> On 25/04/18 12:03, Laurent Pinchart wrote:
> > Could we trim down omapfb to remove support for the devices supported by
> > omapdrm ?
> 
> I was thinking about just that. But, of course, it's not quite
> straightforward either.
> 
> We've got DSI manual update functionality in OMAP3-OMAP5 SoCs, which
> covers a lot of devices.

Sebastian is working on getting that feature in omapdrm, isn't he ?

> And VRFB on OMAP2/3.

And that's something I'd really like to have in omapdrm too.

> Those need omapfb.

-- 
Regards,

Laurent Pinchart
