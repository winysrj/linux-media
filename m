Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:40350 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdLLGJH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 01:09:07 -0500
MIME-Version: 1.0
In-Reply-To: <1766939.Rkg4NBiJVp@avalon>
References: <20171208123537.18718-1-dhaval23031987@gmail.com> <1766939.Rkg4NBiJVp@avalon>
From: Dhaval Shah <dhaval23031987@gmail.com>
Date: Tue, 12 Dec 2017 11:39:05 +0530
Message-ID: <CAOymtfLjf57-Utc+=99xCE3FBGGjySAO6JM3TE=crZ3MZUfzzA@mail.gmail.com>
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: hyun.kwon@xilinx.com, mchehab@kernel.org, michal.simek@xilinx.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent Pinchart,

Thanks a lot for the review.

On Mon, Dec 11, 2017 at 7:17 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Dhaval,
>
> Thank you for the patch.
>
> On Friday, 8 December 2017 14:35:37 EET Dhaval Shah wrote:
> > SPDX-License-Identifier is used for the Xilinx Video IP and
> > related drivers.
> >
> > Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
> > ---
> >  drivers/media/platform/xilinx/xilinx-dma.c  | 5 +----
> >  drivers/media/platform/xilinx/xilinx-dma.h  | 5 +----
> >  drivers/media/platform/xilinx/xilinx-tpg.c  | 5 +----
> >  drivers/media/platform/xilinx/xilinx-vip.c  | 5 +----
> >  drivers/media/platform/xilinx/xilinx-vip.h  | 5 +----
> >  drivers/media/platform/xilinx/xilinx-vipp.c | 5 +----
> >  drivers/media/platform/xilinx/xilinx-vipp.h | 5 +----
> >  drivers/media/platform/xilinx/xilinx-vtc.c  | 5 +----
> >  drivers/media/platform/xilinx/xilinx-vtc.h  | 5 +----
>
> How about addressing drivers/media/platform/xilinx/Makefile, drivers/media/
> platform/xilinx/Kconfig and include/dt-bindings/media/xilinx-vip.h as well ?
> If you're fine with that I can make the change when applying, there's no need
> to resubmit the patch.

Sorry, I forgot to update in those files. Thanks for that. I am fine
with what you said. Please do that change as you said.
>
> --
> Regards,
>
> Laurent Pinchart
>
