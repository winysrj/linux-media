Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([75.149.91.89]:40787 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1CZEfG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 00:35:06 -0400
Date: Fri, 25 Mar 2011 23:35:05 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Dan Carpenter <error27@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Mike Isely <isely@isely.net>
Subject: Re: [PATCH 4/6] [media] pvrusb2: fix camel case variables
In-Reply-To: <20110326015349.GI2008@bicker>
Message-ID: <alpine.DEB.1.10.1103252334040.12072@ivanova.isely.net>
References: <20110326015349.GI2008@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


It not worth this scale of source code disruption to the source code 
just to rename a bunch of variables.  I'm sorry, but...

Nacked-By: Mike Isely <isely@pobox.com>


On Sat, 26 Mar 2011, Dan Carpenter wrote:

> This patch renames some variables to bring them more in line with
> kernel CodingStyle.
> 
> arrPtr  => arr
> arrSize => arr_size
> bufPtr  => buf
> bufSize => buf_size
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c b/drivers/media/video/pvrusb2/pvrusb2-std.c
> index b214f77..d5a679f 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-std.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
> @@ -115,26 +115,26 @@ static const struct std_name std_items[] = {
>   * Search an array of std_name structures and return a pointer to the
>   * element with the matching name.
>   */
> -static const struct std_name *find_std_name(const struct std_name *arrPtr,
> -					    unsigned int arrSize,
> -					    const char *bufPtr,
> -					    unsigned int bufSize)
> +static const struct std_name *find_std_name(const struct std_name *arr,
> +					    unsigned int arr_size,
> +					    const char *buf,
> +					    unsigned int buf_size)
>  {
>  	unsigned int idx;
>  	const struct std_name *p;
>  
> -	for (idx = 0; idx < arrSize; idx++) {
> -		p = arrPtr + idx;
> -		if (strlen(p->name) != bufSize)
> +	for (idx = 0; idx < arr_size; idx++) {
> +		p = arr + idx;
> +		if (strlen(p->name) != buf_size)
>  			continue;
> -		if (!memcmp(bufPtr, p->name, bufSize))
> +		if (!memcmp(buf, p->name, buf_size))
>  			return p;
>  	}
>  	return NULL;
>  }
>  
> -int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *bufPtr,
> -		       unsigned int bufSize)
> +int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *buf,
> +		       unsigned int buf_size)
>  {
>  	v4l2_std_id id = 0;
>  	v4l2_std_id cmsk = 0;
> @@ -144,27 +144,27 @@ int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *bufPtr,
>  	char ch;
>  	const struct std_name *sp;
>  
> -	while (bufSize) {
> +	while (buf_size) {
>  		if (!mMode) {
>  			cnt = 0;
> -			while ((cnt < bufSize) && (bufPtr[cnt] != '-'))
> +			while ((cnt < buf_size) && (buf[cnt] != '-'))
>  				cnt++;
> -			if (cnt >= bufSize)
> +			if (cnt >= buf_size)
>  				return 0; /* No more characters */
>  			sp = find_std_name(std_groups, ARRAY_SIZE(std_groups),
> -					   bufPtr, cnt);
> +					   buf, cnt);
>  			if (!sp)
>  				return 0; /* Illegal color system name */
>  			cnt++;
> -			bufPtr += cnt;
> -			bufSize -= cnt;
> +			buf += cnt;
> +			buf_size -= cnt;
>  			mMode = !0;
>  			cmsk = sp->id;
>  			continue;
>  		}
>  		cnt = 0;
> -		while (cnt < bufSize) {
> -			ch = bufPtr[cnt];
> +		while (cnt < buf_size) {
> +			ch = buf[cnt];
>  			if (ch == ';') {
>  				mMode = 0;
>  				break;
> @@ -174,7 +174,7 @@ int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *bufPtr,
>  			cnt++;
>  		}
>  		sp = find_std_name(std_items, ARRAY_SIZE(std_items),
> -				   bufPtr, cnt);
> +				   buf, cnt);
>  		if (!sp)
>  			return 0; /* Illegal modulation system ID */
>  		t = sp->id & cmsk;
> @@ -182,10 +182,10 @@ int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *bufPtr,
>  			return 0; /* Specific color + modulation system
>  				     illegal */
>  		id |= t;
> -		if (cnt < bufSize)
> +		if (cnt < buf_size)
>  			cnt++;
> -		bufPtr += cnt;
> -		bufSize -= cnt;
> +		buf += cnt;
> +		buf_size -= cnt;
>  	}
>  
>  	if (idPtr)
> @@ -193,7 +193,7 @@ int pvr2_std_str_to_id(v4l2_std_id *idPtr, const char *bufPtr,
>  	return !0;
>  }
>  
> -unsigned int pvr2_std_id_to_str(char *bufPtr, unsigned int bufSize,
> +unsigned int pvr2_std_id_to_str(char *buf, unsigned int buf_size,
>  				v4l2_std_id id)
>  {
>  	unsigned int idx1, idx2;
> @@ -212,26 +212,26 @@ unsigned int pvr2_std_id_to_str(char *bufPtr, unsigned int bufSize,
>  				continue;
>  			if (!gfl) {
>  				if (cfl) {
> -					c2 = scnprintf(bufPtr, bufSize, ";");
> +					c2 = scnprintf(buf, buf_size, ";");
>  					c1 += c2;
> -					bufSize -= c2;
> -					bufPtr += c2;
> +					buf_size -= c2;
> +					buf += c2;
>  				}
>  				cfl = !0;
> -				c2 = scnprintf(bufPtr, bufSize,
> +				c2 = scnprintf(buf, buf_size,
>  					       "%s-", gp->name);
>  				gfl = !0;
>  			} else {
> -				c2 = scnprintf(bufPtr, bufSize, "/");
> +				c2 = scnprintf(buf, buf_size, "/");
>  			}
>  			c1 += c2;
> -			bufSize -= c2;
> -			bufPtr += c2;
> -			c2 = scnprintf(bufPtr, bufSize,
> +			buf_size -= c2;
> +			buf += c2;
> +			c2 = scnprintf(buf, buf_size,
>  				       ip->name);
>  			c1 += c2;
> -			bufSize -= c2;
> -			bufPtr += c2;
> +			buf_size -= c2;
> +			buf += c2;
>  		}
>  	}
>  	return c1;
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
