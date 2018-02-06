Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37572 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbeBFN7z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 08:59:55 -0500
Date: Tue, 6 Feb 2018 16:59:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing
 with a mask
Message-ID: <20180206135923.3zthazmsapuzfxra@mwanda>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
 <20180206131044.oso33fvv553trrd7@mwanda>
 <alpine.DEB.2.20.1802061414340.3306@hadrien>
 <20180206132335.luut6em3kut7f7ej@mwanda>
 <alpine.DEB.2.20.1802061439110.3306@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1802061439110.3306@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That found 4 that I think Wolfram's grep missed.

 arch/um/drivers/vector_user.h             |    2 --
 drivers/gpu/drm/mxsfb/mxsfb_regs.h        |    2 --
 drivers/video/fbdev/mxsfb.c               |    2 --
 include/drm/drm_scdc_helper.h             |    3 ---

But it didn't find the two bugs that Geert found where the right side
wasn't a number literal.

drivers/net/can/m_can/m_can.c:#define RXFC_FWM_MASK     (0x7f < RXFC_FWM_SHIFT)
drivers/usb/gadget/udc/goku_udc.h:#define INT_EPnNAK(n) (0x00100 < (n))         /* 0 < n < 4 */

regards,
dan carpenter
