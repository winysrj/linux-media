Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33838 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdGEOWs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Jul 2017 10:22:48 -0400
Date: Wed, 5 Jul 2017 09:22:38 -0500
From: Rob Herring <robh@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] media: platform: rcar_imr: add IMR-LX3 support
Message-ID: <20170705142238.dopk2gsd7nt7jek4@rob-hp-laptop>
References: <20170628195909.167061456@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170628195909.167061456@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 28, 2017 at 10:58:44PM +0300, Sergei Shtylyov wrote:
> Add support for the image renderer light extended 3 (IMR-LX3) found only in
> the R-Car V2H (R8A7792) SoC. It's mostly the same as IMR-LSX3 but doesn't
> support video capture data as a source of 2D textures.
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch  is against the 'media_tree.git' repo's 'master' branch plus the
> latest version of  the Renesas IMR driver and the patch adding IMR-LSX3 support.
> 
> Changes in version 2:
> - refreshed the patch atop of the IMR driver patch (version 6) and IMR-LSX3
>   patch (version 3).
> 
>  Documentation/devicetree/bindings/media/rcar_imr.txt |    4 ++

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/platform/rcar_imr.c                    |   27 ++++++++++++-------
>  2 files changed, 22 insertions(+), 9 deletions(-)
