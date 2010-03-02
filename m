Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0CBPAQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 10:00:16 -0500
Message-ID: <4B8D27FA.6070904@infradead.org>
Date: Tue, 02 Mar 2010 12:00:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH firmware 6/6] Add firmware for lgs8g75
References: <1267306076.16186.103.camel@localhost> <1267306395.16186.110.camel@localhost>
In-Reply-To: <1267306395.16186.110.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ben Hutchings wrote:
> This is taken from the lgs8gxx driver as of 2.6.32-rc5.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> The binary changes are omitted from this message as they are impossible
> to review.

Hi Ben,

This patch can't be applied, as the firmware is missing on it.

Cheers,
Mauro.
> 
> Ben.
> 
>  WHENCE     |    9 +++++++++
>  lgs8g75.fw |  Bin 0 -> 262 bytes
>  2 files changed, 9 insertions(+), 0 deletions(-)
>  create mode 100644 lgs8g75.fw
> 
> diff --git a/WHENCE b/WHENCE
> index d62468e..659e255 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1184,3 +1184,12 @@ Found in hex form in kernel source.
>  
>  --------------------------------------------------------------------------
>  
> +Driver: lgs8gxx - Legend Silicon GB20600 demodulator driver
> +
> +File: lgs8g75.fw
> +
> +Licence: Unknown
> +
> +Found in hex form in kernel source.
> +
> +--------------------------------------------------------------------------
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
