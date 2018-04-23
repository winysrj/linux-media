Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44259 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754857AbeDWMrf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:47:35 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20180423124733euoutp01a1da1e47e1bc4adcb89f5da44b7e85d5~oEXGXFSFd1394213942euoutp01c
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:47:33 +0000 (GMT)
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with
 COMPILE_TEST && DRM_OMAP
Date: Mon, 23 Apr 2018 14:47:28 +0200
Message-ID: <2542100.cElVns0SR0@amdc3058>
In-Reply-To: <c6ef815da57085bf7e98753463e551905f5d2706.1524245455.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
References: <cover.1524245455.git.mchehab@s-opensource.com>
        <CGME20180420174303epcas3p14e08a828d2547e3365085f43b165d34b@epcas3p1.samsung.com>
        <c6ef815da57085bf7e98753463e551905f5d2706.1524245455.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, April 20, 2018 01:42:51 PM Mauro Carvalho Chehab wrote:
> Add stubs for omapfb_dss.h, in the case it is included by
> some driver when CONFIG_FB_OMAP2 is not defined, with can
> happen on ARM when DRM_OMAP is not 'n'.
> 
> That allows building such driver(s) with COMPILE_TEST.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

This patch should be dropped (together with patch #6/7) as it was
superseded by a better solution suggested by Laurent:

https://patchwork.kernel.org/patch/10325193/

ACK-ed by Tomi:

https://www.spinics.net/lists/dri-devel/msg171918.html

and already merged by you (commit 7378f1149884 "media: omap2:
omapfb: allow building it with COMPILE_TEST")..

> ---
>  include/video/omapfb_dss.h | 54 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 2 deletions(-)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
