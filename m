Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58741 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755664AbdDFOoJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 10:44:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Order the Makefile alphabetically
Date: Thu, 06 Apr 2017 17:44:54 +0300
Message-ID: <49731556.CDPzbN8maI@avalon>
In-Reply-To: <20170406144051.13008-1-maxime.ripard@free-electrons.com>
References: <20170406144051.13008-1-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch.

On Thursday 06 Apr 2017 16:40:51 Maxime Ripard wrote:
> The Makefiles were a free for all without a clear order defined. Sort all
> the options based on the Kconfig symbol.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

I like the approach.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

(I haven't reviewed the changes in detail though, I trust that you have 
double-checked through automated means that no Kconfig symbol was lost.)

> ---
> 
> Hi Mauro,
> 
> Here is my makefile ordering patch again, this time with all the Makefiles
> in drivers/media that needed ordering.
> 
> Since we're already pretty late in the release period, I guess there won't
> be any major conflicts between now and the merge window.
> 
> Maxime
> ---
>  drivers/media/common/Makefile        |   2 +-
>  drivers/media/dvb-frontends/Makefile | 220 +++++++++++++++----------------
>  drivers/media/i2c/Makefile           | 162 +++++++++++++-------------
>  drivers/media/pci/Makefile           |  34 +++---
>  drivers/media/platform/Makefile      |  92 +++++----------
>  drivers/media/radio/Makefile         |  62 +++++-----
>  drivers/media/rc/Makefile            |  74 ++++++------
>  drivers/media/tuners/Makefile        |  73 ++++++------
>  drivers/media/usb/Makefile           |  34 +++---
>  drivers/media/v4l2-core/Makefile     |  36 +++---
>  10 files changed, 381 insertions(+), 408 deletions(-)

-- 
Regards,

Laurent Pinchart
