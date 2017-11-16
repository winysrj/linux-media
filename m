Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38207 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932884AbdKPL1L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 06:27:11 -0500
Date: Thu, 16 Nov 2017 09:27:06 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: =?UTF-8?B?UmFmYcOrbCBDYXJyw6k=?= <funman@videolan.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb_local_open(): strdup fname before calling
 dvb_fe_open_fname()
Message-ID: <20171116092706.5f14142f@vento.lan>
In-Reply-To: <20171114111526.5500-1-funman@videolan.org>
References: <20171114111526.5500-1-funman@videolan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Nov 2017 12:15:26 +0100
Rafaël Carré <funman@videolan.org> escreveu:

> Issue spotted by valgrind:
> 
> ==5290== Invalid free() / delete / delete[] / realloc()
> ==5290==    at 0x4C30D3B: free (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==5290==    by 0x4E54401: free_dvb_dev (dvb-dev.c:49)
> ==5290==    by 0x4E5449A: dvb_dev_free_devices (dvb-dev.c:94)
> ==5290==    by 0x4E547BA: dvb_dev_free (dvb-dev.c:121)
> ==5290==    by 0x10881A: main (leak.c:26)
> ==5290==  Address 0x5e55910 is 0 bytes inside a block of size 28 free'd
> ==5290==    at 0x4C30D3B: free (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==5290==    by 0x4E56504: dvb_v5_free (dvb-fe.c:85)
> ==5290==    by 0x4E547B2: dvb_dev_free (dvb-dev.c:119)
> ==5290==    by 0x10881A: main (leak.c:26)
> ==5290==  Block was alloc'd at
> ==5290==    at 0x4C2FB0F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==5290==    by 0x5119C39: strdup (strdup.c:42)
> ==5290==    by 0x4E55B42: handle_device_change (dvb-dev-local.c:137)
> ==5290==    by 0x4E561DA: dvb_local_find (dvb-dev-local.c:323)
> ==5290==    by 0x10880E: main (leak.c:10)

SOB?

> 
> Signed-off-by: Rafaël Carré <funman@videolan.org>
> ---
>  lib/libdvbv5/dvb-dev-local.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/libdvbv5/dvb-dev-local.c b/lib/libdvbv5/dvb-dev-local.c
> index 920e81fb..b50b61b4 100644
> --- a/lib/libdvbv5/dvb-dev-local.c
> +++ b/lib/libdvbv5/dvb-dev-local.c
> @@ -440,7 +440,7 @@ static struct dvb_open_descriptor
>  		 */
>  		flags &= ~O_NONBLOCK;
>  
> -		ret = dvb_fe_open_fname(parms, dev->path, flags);
> +		ret = dvb_fe_open_fname(parms, strdup(dev->path), flags);
>  		if (ret) {
>  			free(open_dev);
>  			return NULL;



Thanks,
Mauro
