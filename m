Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43700 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbcEYPTK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 11:19:10 -0400
Subject: Re: [PATCH v4 2/7] media: s5p-mfc: use generic reserved memory
 bindings
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-3-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <a14c4f45-64c9-f72d-532b-ad1ff53fa9eb@osg.samsung.com>
Date: Wed, 25 May 2016 11:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <1464096690-23605-3-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 05/24/2016 09:31 AM, Marek Szyprowski wrote:
> Use generic reserved memory bindings and mark old, custom properties
> as obsoleted.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  .../devicetree/bindings/media/s5p-mfc.txt          | 39 +++++++++++++++++-----
>  1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> index 2d5787e..92c94f5 100644
> --- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
> +++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> @@ -21,15 +21,18 @@ Required properties:
>    - clock-names : from common clock binding: must contain "mfc",
>  		  corresponding to entry in the clocks property.
>  
> -  - samsung,mfc-r : Base address of the first memory bank used by MFC
> -		    for DMA contiguous memory allocation and its size.
> -
> -  - samsung,mfc-l : Base address of the second memory bank used by MFC
> -		    for DMA contiguous memory allocation and its size.
> -
>  Optional properties:
>    - power-domains : power-domain property defined with a phandle
>  			   to respective power domain.
> +  - memory-region : from reserved memory binding: phandles to two reserved
> +	memory regions, first is for "left" mfc memory bus interfaces,
> +	second if for the "right" mfc memory bus, used when no SYSMMU
> +	support is available
> +
> +Obsolete properties:
> +  - samsung,mfc-r, samsung,mfc-l : support removed, please use memory-region
> +	property instead
> +
> 

I wonder if we should maintain backward compatibility for this driver
since s5p-mfc memory allocation won't work with an old FDT if support
for the old properties are removed.

Although I'm not a big fan of keeping backward compatibility just to
add dead code that will never be used and I don't know of any Exynos
machine where the DTB and kernel are not updated together so I agree
with this patch:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
