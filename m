Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:56377 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZL2KIV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 05:08:21 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: [patch] fix weird array index in zl10036.c
Date: Tue, 29 Dec 2009 11:08:16 +0100
Cc: Dan Carpenter <error27@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20091227131529.GJ6075@bicker> <200912271802.46083.zzam@gentoo.org> <20091228174849.GG17645@bicker>
In-Reply-To: <20091228174849.GG17645@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912291108.16880.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Montag, 28. Dezember 2009, Dan Carpenter wrote:
> I was initially concerned about the weird array index (the 2 bumps
> into the next row of the array).  Matthias Schwarzott look at the
> datasheet and it turns out it should be zl10036_init_tab[1][0] |= 0x01;
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

It may be better to add "linux/" path component to make it apply easier.

Matthias

> 
> --- orig/drivers/media/dvb/frontends/zl10036.c	2009-12-28
>  19:04:51.000000000 +0200 +++
>  devel/drivers/media/dvb/frontends/zl10036.c	2009-12-28 19:07:18.000000000
>  +0200 @@ -411,7 +411,7 @@ static int zl10036_init_regs(struct zl10
>  	state->bf = 0xff;
> 
>  	if (!state->config->rf_loop_enable)
> -		zl10036_init_tab[1][2] |= 0x01;
> +		zl10036_init_tab[1][0] |= 0x01;
> 
>  	deb_info("%s\n", __func__);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

