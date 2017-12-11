Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57114 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752841AbdLKNrX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 08:47:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dhaval Shah <dhaval23031987@gmail.com>
Cc: hyun.kwon@xilinx.com, mchehab@kernel.org, michal.simek@xilinx.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
Date: Mon, 11 Dec 2017 15:47:24 +0200
Message-ID: <1766939.Rkg4NBiJVp@avalon>
In-Reply-To: <20171208123537.18718-1-dhaval23031987@gmail.com>
References: <20171208123537.18718-1-dhaval23031987@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dhaval,

Thank you for the patch.

On Friday, 8 December 2017 14:35:37 EET Dhaval Shah wrote:
> SPDX-License-Identifier is used for the Xilinx Video IP and
> related drivers.
> 
> Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
> ---
>  drivers/media/platform/xilinx/xilinx-dma.c  | 5 +----
>  drivers/media/platform/xilinx/xilinx-dma.h  | 5 +----
>  drivers/media/platform/xilinx/xilinx-tpg.c  | 5 +----
>  drivers/media/platform/xilinx/xilinx-vip.c  | 5 +----
>  drivers/media/platform/xilinx/xilinx-vip.h  | 5 +----
>  drivers/media/platform/xilinx/xilinx-vipp.c | 5 +----
>  drivers/media/platform/xilinx/xilinx-vipp.h | 5 +----
>  drivers/media/platform/xilinx/xilinx-vtc.c  | 5 +----
>  drivers/media/platform/xilinx/xilinx-vtc.h  | 5 +----

How about addressing drivers/media/platform/xilinx/Makefile, drivers/media/
platform/xilinx/Kconfig and include/dt-bindings/media/xilinx-vip.h as well ? 
If you're fine with that I can make the change when applying, there's no need 
to resubmit the patch.

-- 
Regards,

Laurent Pinchart
