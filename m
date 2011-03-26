Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([75.149.91.89]:46362 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab1CZEhG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 00:37:06 -0400
Date: Fri, 25 Mar 2011 23:37:04 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Dan Carpenter <error27@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Mike Isely <isely@isely.net>
Subject: Re: [PATCH 6/6] [media] pvrusb2: replace !0 with 1
In-Reply-To: <20110326015530.GK2008@bicker>
Message-ID: <alpine.DEB.1.10.1103252335590.12072@ivanova.isely.net>
References: <20110326015530.GK2008@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


That's an opinion which I as the driver author disagree with.  Strongly.  
How hard is it to read "not false"?

Nacked-By: Mike Isely <isely@pobox.com>


On Sat, 26 Mar 2011, Dan Carpenter wrote:

> Using !0 is less readable than just saying 1.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c b/drivers/media/video/pvrusb2/pvrusb2-std.c
> index 9bebc08..ca4f67b 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-std.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
> @@ -158,7 +158,7 @@ int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *buf,
>  			cnt++;
>  			buf += cnt;
>  			buf_size -= cnt;
> -			mMode = !0;
> +			mMode = 1;
>  			cmsk = sp->id;
>  			continue;
>  		}
> @@ -190,7 +190,7 @@ int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *buf,
>  
>  	if (idPtr)
>  		*idPtr = id;
> -	return !0;
> +	return 1;
>  }
>  
>  unsigned int pvr2_std_id_to_str(char *buf, unsigned int buf_size,
> @@ -217,10 +217,10 @@ unsigned int pvr2_std_id_to_str(char *buf, unsigned int buf_size,
>  					buf_size -= c2;
>  					buf += c2;
>  				}
> -				cfl = !0;
> +				cfl = 1;
>  				c2 = scnprintf(buf, buf_size,
>  					       "%s-", gp->name);
> -				gfl = !0;
> +				gfl = 1;
>  			} else {
>  				c2 = scnprintf(buf, buf_size, "/");
>  			}
> @@ -315,7 +315,7 @@ static int pvr2_std_fill(struct v4l2_standard *std, v4l2_std_id id)
>  	std->name[bcnt] = 0;
>  	pvr2_trace(PVR2_TRACE_STD, "Set up standard idx=%u name=%s",
>  		   std->index, std->name);
> -	return !0;
> +	return 1;
>  }
>  
>  /*
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
