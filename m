Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59193 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbbLQOzK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 09:55:10 -0500
Date: Thu, 17 Dec 2015 12:55:05 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: Automatic device driver back-porting with media_build
Message-ID: <20151217125505.0abc4b40@recife.lan>
In-Reply-To: <5672C713.6090101@free.fr>
References: <5672A6F0.6070003@free.fr>
	<20151217105543.13599560@recife.lan>
	<5672BE15.9070006@free.fr>
	<20151217120830.0fc27f01@recife.lan>
	<5672C713.6090101@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Dec 2015 15:30:43 +0100
Mason <slash.tmp@free.fr> escreveu:

> On 17/12/2015 15:08, Mauro Carvalho Chehab wrote:
> 
> > Then I guess you're not using vanilla 3.4 Kernel, but some heavily
> > modified version. You're on your own here.
> 
> #ifdef NEED_KVFREE
> #include <linux/mm.h>
> static inline void kvfree(const void *addr)
> {
> 	if (is_vmalloc_addr(addr))
> 		vfree(addr);
> 	else
> 		kfree(addr);
> }
> #endif
> 
> /tmp/sandbox/media_build/v4l/compat.h: In function 'kvfree':
> /tmp/sandbox/media_build/v4l/compat.h:1631:3: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
>    vfree(addr);
>    ^
> 
> vfree is declared in linux/vmalloc.h
> 
> The fix is trivial:
> 
> diff --git a/v4l/compat.h b/v4l/compat.h
> index c225c07d6caa..7f3f1d5f9d11 100644
> --- a/v4l/compat.h
> +++ b/v4l/compat.h
> @@ -1625,6 +1625,7 @@ static inline void eth_zero_addr(u8 *addr)
>  
>  #ifdef NEED_KVFREE
>  #include <linux/mm.h>
> +#include <linux/vmalloc.h>
>  static inline void kvfree(const void *addr)
>  {
>         if (is_vmalloc_addr(addr))
> 
> 

Well, it doesn't hurt to add it to the media_build tree, since
vmalloc.h exists at least since 2.6.11.

Added upstream.

Did the driver compile fine?

Regards,
Mauro
