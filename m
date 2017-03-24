Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33985 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754242AbdCXCQf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 22:16:35 -0400
Date: Thu, 23 Mar 2017 21:16:32 -0500
From: Rob Herring <robh@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] media: platform: rcar_imr: add IMR-LSX3 support
Message-ID: <20170324021632.xp3xnrgklqdeixq6@rob-hp-laptop>
References: <20170316190000.216761731@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170316190000.216761731@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 16, 2017 at 09:59:50PM +0300, Sergei Shtylyov wrote:
> Add support for the image renderer light SRAM extended 3 (IMR-LSX3) found
> only in the R-Car V2H (R8A7792) SoC.  It differs  from IMR-LX4 in that it
> supports only planar video formats but can use the video capture data for
> the textures.
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch  is against the 'media_tree.git' repo's 'master' branch plus the
> latest version of  the Renesas IMR driver...
> 
> Changes in version 2:
> - renamed *enum* 'imr_gen' to 'imr_type' and the *struct* field of this type
>   from 'gen' to 'type';
> - rename *struct* 'imr_type' to 'imr_info' and the fields/variables of this type
>   from 'type' to 'info';
> - added comments to IMR-LX4 only CMRCR2 bits;
> - added IMR type check to the WTS instruction writing to CMRCCR2.
> 
>  Documentation/devicetree/bindings/media/rcar_imr.txt |   11 +

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/platform/rcar_imr.c                    |  106 +++++++++++++++----
>  2 files changed, 97 insertions(+), 20 deletions(-)
