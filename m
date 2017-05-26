Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33452 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944958AbdEZVAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 17:00:37 -0400
Received: by mail-pf0-f176.google.com with SMTP id e193so21449607pfh.0
        for <linux-media@vger.kernel.org>; Fri, 26 May 2017 14:00:37 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>,
        Alejandro Hernandez <ajhernandez@ti.com>
Subject: Re: [PATCH] davinci: vpif_capture: fix default pixel format for BT.656/BT.1120 video
References: <20170526105527.10522-1-nsekhar@ti.com>
Date: Fri, 26 May 2017 14:00:32 -0700
In-Reply-To: <20170526105527.10522-1-nsekhar@ti.com> (Sekhar Nori's message of
        "Fri, 26 May 2017 16:25:27 +0530")
Message-ID: <m2r2zb1ggf.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar Nori <nsekhar@ti.com> writes:

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

Acked-by: Kevin Hilman <khilman@baylibre.com>
