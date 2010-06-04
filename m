Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:53492 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab0FDM0J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 08:26:09 -0400
Message-ID: <4C08F0DD.50702@bfs.de>
Date: Fri, 04 Jun 2010 14:26:05 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] V4L/DVB: dvb_ca_en50221: return -EFAULT on copy_to_user
 errors
References: <20100604103629.GC5483@bicker>
In-Reply-To: <20100604103629.GC5483@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Dan Carpenter schrieb:
> copy_to_user() returns the number of bytes remaining to be copied which
> isn't the right thing to return here.  The comments say that these 
> functions in dvb_ca_en50221.c should return the number of bytes copied or
> an error return.  I've changed it to return -EFAULT.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> index ef259a0..aa7a298 100644
> --- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
> @@ -1318,8 +1318,10 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
>  
>  		fragbuf[0] = connection_id;
>  		fragbuf[1] = ((fragpos + fraglen) < count) ? 0x80 : 0x00;
> -		if ((status = copy_from_user(fragbuf + 2, buf + fragpos, fraglen)) != 0)
> +		if ((status = copy_from_user(fragbuf + 2, buf + fragpos, fraglen)) != 0) {
> +			status = -EFAULT;
>  			goto exit;
> +		}
>  
>  		timeout = jiffies + HZ / 2;
>  		written = 0;
> @@ -1494,8 +1496,10 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
>  
>  	hdr[0] = slot;
>  	hdr[1] = connection_id;
> -	if ((status = copy_to_user(buf, hdr, 2)) != 0)
> +	if ((status = copy_to_user(buf, hdr, 2)) != 0) {
> +		status = -EFAULT;
>  		goto exit;
> +	}
>  	status = pktlen;
>  
>  exit:
> --


Doint to many things at once is bad. IMHO it is more readable to do so:

+status = copy_to_user(buf, hdr, 2);
+if ( status  != 0) {

Maybe the maintainer has different ideas but especialy lines like will gain.

-if ((status = copy_from_user(fragbuf + 2, buf + fragpos, fraglen)) != 0)
+status = copy_from_user(fragbuf + 2, buf + fragpos, fraglen):
+if ( status  != 0) {

just my 2 cents,
 wh
