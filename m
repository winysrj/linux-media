Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:38161 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751034AbdGHA6e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 20:58:34 -0400
Message-ID: <1499475510.20988.12.camel@perches.com>
Subject: Re: [PATCH 1/2] staging: media: atomisp2: css2400: Replace
 kfree()/vfree() with kvfree()
From: Joe Perches <joe@perches.com>
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Jul 2017 17:58:30 -0700
In-Reply-To: <20170708004054.GA27142@amitoj-Inspiron-3542>
References: <20170708004054.GA27142@amitoj-Inspiron-3542>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-07-07 at 20:40 -0400, Amitoj Kaur Chawla wrote:
> Conditionally calling kfree()/vfree() can be replaced by a call to 
> kvfree() which handles both kmalloced memory and vmalloced memory.
[]
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
[]
> @@ -2029,10 +2029,7 @@ void *sh_css_calloc(size_t N, size_t size)
> 
>  void sh_css_free(void *ptr)
>  {
> -	if (is_vmalloc_addr(ptr))
> -		vfree(ptr);
> -	else
> -		kfree(ptr);
> +	kvfree(ptr);
>  }

Why not just get rid of sh_css_free and use kvfree directly?

Why not get rid of all the sh_css_<alloc/free> functions?
