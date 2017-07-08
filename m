Return-path: <linux-media-owner@vger.kernel.org>
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3998 "EHLO
        esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbdGHJ4H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Jul 2017 05:56:07 -0400
Message-ID: <1499504311.3472.13.camel@petrovitsch.priv.at>
Subject: Re: [PATCH 2/2] staging: media: atomisp2: Replace kfree()/vfree()
 with kvfree()
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Jul 2017 10:58:31 +0200
In-Reply-To: <20170708004102.GA27161@amitoj-Inspiron-3542>
References: <20170708004102.GA27161@amitoj-Inspiron-3542>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-07-07 at 20:41 -0400, Amitoj Kaur Chawla wrote:
[...]
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> @@ -117,11 +117,7 @@ void *atomisp_kernel_zalloc(size_t bytes, bool
> zero_mem)
>   */
>  void atomisp_kernel_free(void *ptr)
>  {
> -	/* Verify if buffer was allocated by vmalloc() or kmalloc()
> */
> -	if (is_vmalloc_addr(ptr))
> -		vfree(ptr);
> -	else
> -		kfree(ptr);
> +	kvfree(ptr);
>  }
>  
>  /*

Why not get rid of the trivial wrapper function completely?

MfG,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at
