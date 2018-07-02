Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38759 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753250AbeGBSLH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 14:11:07 -0400
Received: by mail-lj1-f196.google.com with SMTP id p6-v6so1863938ljc.5
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 11:11:06 -0700 (PDT)
Date: Mon, 2 Jul 2018 20:11:04 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 0/10] rcar-vin: Add support for parallel input on Gen3
Message-ID: <20180702181104.GZ5237@bigcity.dyn.berto.se>
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Nice work, I'm happy with the work you have done thanks!

I have tested this series on M3-N to make sure it don't break anything 
on existing Gen3. Tested on V3M to make sure you can switch between 
CSI-2 and parallel input at runtime. And last I tested it on Koelsch to 
make sure Gen2 still works. All tests looks good.

Thanks for your effort!

On 2018-06-12 11:43:22 +0200, Jacopo Mondi wrote:
> Hello,
>    this series adds support for parallel video input to the Gen3 version of
> rcar-vin driver.
> 
> Few changes compared to v5, closing a few comments from Kieran and Niklas,
> and fixed the label names I forgot to change in previous version.
> 
> Changlog in the individual patches when relevant.
> 
> A few patches have not yet been acked-by, but things look smooth and we
> should be close to have this finalized.
> 
> Thanks
>    j
> 
> Jacopo Mondi (10):
>   media: rcar-vin: Rename 'digital' to 'parallel'
>   media: rcar-vin: Remove two empty lines
>   media: rcar-vin: Create a group notifier
>   media: rcar-vin: Cleanup notifier in error path
>   media: rcar-vin: Cache the mbus configuration flags
>   media: rcar-vin: Parse parallel input on Gen3
>   media: rcar-vin: Link parallel input media entities
>   media: rcar-vin: Handle parallel subdev in link_notify
>   media: rcar-vin: Rename _rcar_info to rcar_info
>   media: rcar-vin: Add support for R-Car R8A77995 SoC
> 
>  drivers/media/platform/rcar-vin/rcar-core.c | 265 ++++++++++++++++++----------
>  drivers/media/platform/rcar-vin/rcar-dma.c  |  36 ++--
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  12 +-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  29 +--
>  4 files changed, 223 insertions(+), 119 deletions(-)
> 
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
