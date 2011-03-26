Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([75.149.91.89]:40787 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1CZEfy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 00:35:54 -0400
Date: Fri, 25 Mar 2011 23:35:53 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Dan Carpenter <error27@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Mike Isely <isely@isely.net>
Subject: Re: [PATCH 5/5] [media] pvrusb2: delete generic_standards_cnt
In-Reply-To: <20110326015434.GJ2008@bicker>
Message-ID: <alpine.DEB.1.10.1103252335170.12072@ivanova.isely.net>
References: <20110326015434.GJ2008@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Are you actually serious about this?  Well it's a small change...

Acked-By: Mike Isely <isely@pobox.com>


On Sat, 26 Mar 2011, Dan Carpenter wrote:

> The generic_standards_cnt define is only used in one place and it's
> more readable to just call ARRAY_SIZE(generic_standards) directly.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c b/drivers/media/video/pvrusb2/pvrusb2-std.c
> index d5a679f..9bebc08 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-std.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
> @@ -287,13 +287,11 @@ static struct v4l2_standard generic_standards[] = {
>  	}
>  };
>  
> -#define generic_standards_cnt ARRAY_SIZE(generic_standards)
> -
>  static struct v4l2_standard *match_std(v4l2_std_id id)
>  {
>  	unsigned int idx;
>  
> -	for (idx = 0; idx < generic_standards_cnt; idx++) {
> +	for (idx = 0; idx < ARRAY_SIZE(generic_standards); idx++) {
>  		if (generic_standards[idx].id & id)
>  			return generic_standards + idx;
>  	}
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
