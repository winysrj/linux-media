Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:23029 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750778AbdGGKrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 06:47:48 -0400
Message-ID: <1499424463.5590.12.camel@linux.intel.com>
Subject: Re: [PATCH] staging: atomisp: gc0310: constify acpi_device_id.
From: Alan Cox <alan@linux.intel.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, mchehab@kernel.org,
        gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Jul 2017 11:47:43 +0100
In-Reply-To: <7d7e1a0d6e7f90a9f8b4545fec2077ea3b351cb6.1499357881.git.arvind.yadav.cs@gmail.com>
References: <7d7e1a0d6e7f90a9f8b4545fec2077ea3b351cb6.1499357881.git.arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-07-06 at 21:50 +0530, Arvind Yadav wrote:
> acpi_device_id are not supposed to change at runtime. All functions
> working with acpi_device_id provided by <acpi/acpi_bus.h> work with
> const acpi_device_id. So mark the non-const structs as const.
> 
> File size before:
>    text	   data	    bss	    dec	    hex	
> filename
>   10297	   1888	      0	  12185	   2f99
> drivers/staging/media/atomisp/i2c/gc0310.o
> 
> File size After adding 'const':
>    text	   data	    bss	    dec	    hex	
> filename
>   10361	   1824	      0	  12185	   2f99
> drivers/staging/media/atomisp/i2c/gc0310.o
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  drivers/staging/media/atomisp/i2c/gc0310.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c
> b/drivers/staging/media/atomisp/i2c/gc0310.c
> index 1ec616a..c8162bb 100644
> --- a/drivers/staging/media/atomisp/i2c/gc0310.c
> +++ b/drivers/staging/media/atomisp/i2c/gc0310.c
> @@ -1453,7 +1453,7 @@ static int gc0310_probe(struct i2c_client
> *client,
>  	return ret;
>  }
>  
> -static struct acpi_device_id gc0310_acpi_match[] = {
> +static const struct acpi_device_id gc0310_acpi_match[] = {
>  	{"XXGC0310"},
>  	{},
>  };

(All four)

Acked-by: Alan Cox <alan@linux.intel.com>
