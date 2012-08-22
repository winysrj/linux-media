Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45159 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab2HVEvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 00:51:06 -0400
Message-ID: <50346534.4030107@ti.com>
Date: Wed, 22 Aug 2012 10:21:00 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libdvbv5: Fix byte swapping for embedded toolchains
References: <1345575502-3779-1-git-send-email-gjasny@googlemail.com> <1345575502-3779-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1345575502-3779-2-git-send-email-gjasny@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Thanks for the patch.

On Wednesday 22 August 2012 12:28 AM, Gregor Jasny wrote:
> Reported-by: "Lad, Prabhakar" <prabhakar.lad@ti.com>
> Signed-off-by: Gregor Jasny <gjasny@googlemail.com>

  Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>

Thx,
--Prabhakar

> ---
>  lib/include/descriptors.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
> index 9039014..a64370c 100644
> --- a/lib/include/descriptors.h
> +++ b/lib/include/descriptors.h
> @@ -25,7 +25,7 @@
>  #ifndef _DESCRIPTORS_H
>  #define _DESCRIPTORS_H
>  
> -#include <endian.h>
> +#include <arpa/inet.h>
>  #include <unistd.h>
>  #include <stdint.h>
>  
> @@ -46,11 +46,11 @@ extern char *default_charset;
>  extern char *output_charset;
>  
>  #define bswap16(b) do {\
> -	b = be16toh(b); \
> +	b = ntohs(b); \
>  } while (0)
>  
>  #define bswap32(b) do {\
> -	b = be32toh(b); \
> +	b = ntohl(b); \
>  } while (0)
>  
>  struct dvb_desc {
> 

