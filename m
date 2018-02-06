Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12428 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751319AbeBFOI1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 09:08:27 -0500
Date: Tue, 6 Feb 2018 15:08:21 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing
 with a mask
In-Reply-To: <20180206135923.3zthazmsapuzfxra@mwanda>
Message-ID: <alpine.DEB.2.20.1802061506310.3306@hadrien>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com> <20180206131044.oso33fvv553trrd7@mwanda> <alpine.DEB.2.20.1802061414340.3306@hadrien> <20180206132335.luut6em3kut7f7ej@mwanda> <alpine.DEB.2.20.1802061439110.3306@hadrien>
 <20180206135923.3zthazmsapuzfxra@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 6 Feb 2018, Dan Carpenter wrote:

> That found 4 that I think Wolfram's grep missed.
>
>  arch/um/drivers/vector_user.h             |    2 --
>  drivers/gpu/drm/mxsfb/mxsfb_regs.h        |    2 --
>  drivers/video/fbdev/mxsfb.c               |    2 --
>  include/drm/drm_scdc_helper.h             |    3 ---
>
> But it didn't find the two bugs that Geert found where the right side
> wasn't a number literal.
>
> drivers/net/can/m_can/m_can.c:#define RXFC_FWM_MASK     (0x7f < RXFC_FWM_SHIFT)

OK, I can easily add this in - I've got rules to protect against reporting
it at the moment.  It may end up with false positives.

> drivers/usb/gadget/udc/goku_udc.h:#define INT_EPnNAK(n) (0x00100 < (n))         /* 0 < n < 4 */

This is indeed harder, because one has to look at the usage site.

julia
