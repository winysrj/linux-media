Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:54632 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab0G0Nko (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 09:40:44 -0400
Date: Tue, 27 Jul 2010 08:40:44 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely at pobox <isely@pobox.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] media: video: pvrusb2: remove custom hex_to_bin()
In-Reply-To: <39e0be58882d4d5fd84e2b70a8fdc38bc1b4fc41.1280233873.git.andy.shevchenko@gmail.com>
Message-ID: <alpine.DEB.1.10.1007270836210.20891@cnc.isely.net>
References: <aaffa1b668767c4bf7ce9baf2d5c5dfb11784c19.1280233873.git.andy.shevchenko@gmail.com> <39e0be58882d4d5fd84e2b70a8fdc38bc1b4fc41.1280233873.git.andy.shevchenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Andy:

Acked-By: Mike Isely <isely@pobox.com>

  -Mike


On Tue, 27 Jul 2010, Andy Shevchenko wrote:

> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Mike Isely <isely@pobox.com>
> ---
>  drivers/media/video/pvrusb2/pvrusb2-debugifc.c |   14 ++------------
>  1 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c b/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
> index e9b11e1..4279ebb 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
> @@ -94,8 +94,6 @@ static int debugifc_parse_unsigned_number(const char *buf,unsigned int count,
>  					  u32 *num_ptr)
>  {
>  	u32 result = 0;
> -	u32 val;
> -	int ch;
>  	int radix = 10;
>  	if ((count >= 2) && (buf[0] == '0') &&
>  	    ((buf[1] == 'x') || (buf[1] == 'X'))) {
> @@ -107,17 +105,9 @@ static int debugifc_parse_unsigned_number(const char *buf,unsigned int count,
>  	}
>  
>  	while (count--) {
> -		ch = *buf++;
> -		if ((ch >= '0') && (ch <= '9')) {
> -			val = ch - '0';
> -		} else if ((ch >= 'a') && (ch <= 'f')) {
> -			val = ch - 'a' + 10;
> -		} else if ((ch >= 'A') && (ch <= 'F')) {
> -			val = ch - 'A' + 10;
> -		} else {
> +		int val = hex_to_bin(*buf++);
> +		if (val < 0 || val >= radix)
>  			return -EINVAL;
> -		}
> -		if (val >= radix) return -EINVAL;
>  		result *= radix;
>  		result += val;
>  	}
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
