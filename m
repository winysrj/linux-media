Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43213 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdJRQH5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 12:07:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hyun Kwon <hyun.kwon@xilinx.com>
Subject: Re: [PATCH] dt-bindings: media: xilinx: fix typo in example
Date: Wed, 18 Oct 2017 19:08:17 +0300
Message-ID: <1546677.fKvj0pB9W9@avalon>
In-Reply-To: <1507824214-17744-1-git-send-email-akinobu.mita@gmail.com>
References: <1507824214-17744-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

Thank you for the patch.

On Thursday, 12 October 2017 19:03:34 EEST Akinobu Mita wrote:
> Fix typo s/:/;/
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Hyun Kwon <hyun.kwon@xilinx.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Good catch.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Should I take this patch in my tree ?

> ---
>  Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt
> b/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt index
> 9dd86b3..439351a 100644
> --- a/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt
> +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt
> @@ -66,6 +66,6 @@ Example:
>  				tpg1_out: endpoint {
>  					remote-endpoint = <&switch_in0>;
>  				};
> -			}:
> +			};
>  		};
>  	};


-- 
Regards,

Laurent Pinchart
