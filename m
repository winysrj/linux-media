Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:18671 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdE3MPq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 08:15:46 -0400
Date: Tue, 30 May 2017 07:15:43 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Alejandro Hernandez <ajhernandez@ti.com>
Subject: Re: [PATCH] davinci: vpif_capture: fix default pixel format for
 BT.656/BT.1120 video
Message-ID: <20170530121543.GF4137@ti.com>
References: <20170526105527.10522-1-nsekhar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20170526105527.10522-1-nsekhar@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar Nori <nsekhar@ti.com> wrote on Fri [2017-May-26 16:25:27 +0530]:
> For both BT.656 and BT.1120 video, the pixel format
> used by VPIF is Y/CbCr 4:2:2 in semi-planar format
> (Luma in one plane and Chroma in another). This
> corresponds to NV16 pixel format.
> 
> This is documented in section 36.2.3 of OMAP-L138
> Technical Reference Manual, SPRUH77A.
> 
> The VPIF driver incorrectly sets the default format
> to V4L2_PIX_FMT_YUV422P. Fix it.
> 
> Reported-by: Alejandro Hernandez <ajhernandez@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 

Acked-by: Benoit Parrot <bparrot@ti.com>
