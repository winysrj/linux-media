Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35617 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750867AbdE3Jkk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 05:40:40 -0400
Received: by mail-ua0-f169.google.com with SMTP id y4so48008794uay.2
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 02:40:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170526105527.10522-1-nsekhar@ti.com>
References: <20170526105527.10522-1-nsekhar@ti.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 30 May 2017 10:40:09 +0100
Message-ID: <CA+V-a8tELUESQu4qtDhD95iV6DMZjV_eRvRS3TggB1=EFJF=sg@mail.gmail.com>
Subject: Re: [PATCH] davinci: vpif_capture: fix default pixel format for
 BT.656/BT.1120 video
To: Sekhar Nori <nsekhar@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Alejandro Hernandez <ajhernandez@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sekhar,

Thanks for the patch.

On Fri, May 26, 2017 at 11:55 AM, Sekhar Nori <nsekhar@ti.com> wrote:
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

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Can you also post a similar patch for vpif_display as well ?

Cheers,
--Prabhakar Lad
