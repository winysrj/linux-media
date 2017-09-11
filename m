Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53520 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750987AbdIKO7R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 10:59:17 -0400
Date: Mon, 11 Sep 2017 17:59:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Branislav Radocaj <branislav@radocaj.org>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@llwyncelyn.cymru, hans.verkuil@cisco.com,
        rvarsha016@gmail.com, singhalsimran0@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: atomisp: fix alloc_cast.cocci warnings
Message-ID: <20170911145914.ytwsiei5jqvjujsf@valkosipuli.retiisi.org.uk>
References: <20170907162642.2195-1-branislav@radocaj.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907162642.2195-1-branislav@radocaj.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Branislav,

On Thu, Sep 07, 2017 at 06:26:42PM +0200, Branislav Radocaj wrote:
> Remove casting the values returned by memory allocation functions
> like kmalloc, kzalloc, kmem_cache_alloc, kmem_cache_zalloc etc.
> 
> Semantic patch information:
> This makes an effort to find cases of casting of values returned by
> kmalloc, kzalloc, kcalloc, kmem_cache_alloc, kmem_cache_zalloc,
> kmem_cache_alloc_node, kmalloc_node and kzalloc_node and removes
> the casting as it is not required. The result in the patch case may
> need some reformatting.
> 
> Generated by: scripts/coccinelle/api/alloc/alloc_cast.cocci
> 
> Signed-off-by: Branislav Radocaj <branislav@radocaj.org>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> index eecd8cf71951..56765d6a0498 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> @@ -133,7 +133,7 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
>  		char *namebuffer;
>  		int namelength = (int)strlen(name);
>  
> -		namebuffer = (char *) kmalloc(namelength + 1, GFP_KERNEL);
> +		namebuffer = kmalloc(namelength + 1, GFP_KERNEL);

This chunk no longer applies, I'm applying the one that does. The kmalloc
has been replaced by kstrdup.

>  		if (namebuffer == NULL)
>  			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
>  
> @@ -149,7 +149,7 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
>  		size_t configstruct_size = sizeof(struct ia_css_config_memory_offsets);
>  		size_t statestruct_size = sizeof(struct ia_css_state_memory_offsets);
>  
> -		char *parambuf = (char *)kmalloc(paramstruct_size + configstruct_size + statestruct_size,
> +		char *parambuf = kmalloc(paramstruct_size + configstruct_size + statestruct_size,
>  							GFP_KERNEL);
>  		if (parambuf == NULL)
>  			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
