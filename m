Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36511 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938553AbcJ0ONd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:13:33 -0400
Received: by mail-wm0-f42.google.com with SMTP id b80so36769095wme.1
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 07:13:32 -0700 (PDT)
Date: Thu, 27 Oct 2016 10:13:27 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] dvb: avoid warning in dvb_net
Message-ID: <20161027141327.GE42084@redhat.com>
References: <20161027140835.2345937-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161027140835.2345937-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 27, 2016 at 03:57:41PM +0200, Arnd Bergmann wrote:
> With gcc-5 or higher on x86, we can get a bogus warning in the
> dvb-net code:
> 
> drivers/media/dvb-core/dvb_net.c: In function ‘dvb_net_ule’:
> arch/x86/include/asm/string_32.h:77:14: error: ‘dest_addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/media/dvb-core/dvb_net.c:633:8: note: ‘dest_addr’ was declared here
> 
> The problem here is that gcc doesn't track all of the conditions
> to prove it can't end up copying uninitialized data.
> This changes the logic around so we zero out the destination
> address earlier when we determine that it is not set here.
> This allows the compiler to figure it out.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/dvb-core/dvb_net.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> index 088914c4623f..f1b416de9dab 100644
> --- a/drivers/media/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb-core/dvb_net.c
> @@ -688,6 +688,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
>  							      ETH_ALEN);
>  						skb_pull(priv->ule_skb, ETH_ALEN);
>  					}
> +				} else {
> +					 /* othersie use zero destination address */

I'm assuming you meant "otherwise" there instead of "othersie".

-- 
Jarod Wilson
jarod@redhat.com

