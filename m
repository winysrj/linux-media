Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46595
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942020AbcJSPIe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 11:08:34 -0400
Date: Wed, 19 Oct 2016 08:19:20 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux1394-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 53/58] firewire: don't break long lines
Message-ID: <20161019081920.15b97eb7@vento.lan>
In-Reply-To: <84c06fb2-d147-689d-8d42-ce6b1f400a1f@sakamocchi.jp>
References: <cover.1476822924.git.mchehab@s-opensource.com>
        <bce754e03eef20b560c05a33d7cf68f6030e68e7.1476822925.git.mchehab@s-opensource.com>
        <84c06fb2-d147-689d-8d42-ce6b1f400a1f@sakamocchi.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Oct 2016 08:03:01 +0900
Takashi Sakamoto <o-takashi@sakamocchi.jp> escreveu:

> From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> Date: Wed, 19 Oct 2016 07:53:35 +0900
> Subject: [PATCH] [media] firewire: use dev_dbg() instead of printk()
> 
> A structure for firedtv (struct firedtv) has a member for a pointer to
> struct device. In this case, we can use dev_dbg() for debug printing.
> This is more preferrable behaviour in device driver development.
> 
> Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> ---
>  drivers/media/firewire/firedtv-rc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/firewire/firedtv-rc.c
> b/drivers/media/firewire/firedtv-rc.c
> index f82d4a9..04dea2a 100644
> --- a/drivers/media/firewire/firedtv-rc.c
> +++ b/drivers/media/firewire/firedtv-rc.c
> @@ -184,8 +184,9 @@ void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code)
>  	else if (code >= 0x4540 && code <= 0x4542)
>  		code = oldtable[code - 0x4521];
>  	else {
> -		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
> -		       "from remote control\n", code);
> +		dev_dbg(fdtv->device,
> +			"invalid key code 0x%04x from remote control\n",
> +			code);
>  		return;
>  	}

Looks good to me. Applied to my development tree:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=printk&id=e0de6d90145753bf40415d670471fcc536b2a26c
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=printk&id=9532ba4af6a7619bb028ddd3b829e6f163917b79

Stefan,

Would the above be OK for you?

Thanks,
Mauro
