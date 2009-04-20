Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZDTTpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 15:45:03 -0400
Date: Mon, 20 Apr 2009 16:44:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH -next] cx231xx: fix SND dependency build error
Message-ID: <20090420164449.34942436@pedra.chehab.org>
In-Reply-To: <49DB7861.5050606@oracle.com>
References: <20090407140717.a7f0b07c.sfr@canb.auug.org.au>
	<49DB7861.5050606@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 07 Apr 2009 08:59:29 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Don't select VIDEO_CX231XX_ALSA when SND is not enabled since selecting it
> won't cause SND to be enabled.

Sorry for being late with this issue. I was fixing some upstream scripts, and
we had a few holydays.

The better is just to trop the select for -alsa module. I have already a fix on
my tree. I'll push it later today to my linux-next git repository.
> 
> ERROR: "snd_pcm_period_elapsed" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> ERROR: "snd_card_create" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> ERROR: "snd_pcm_hw_constraint_integer" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> ERROR: "snd_pcm_set_ops" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> ERROR: "snd_pcm_lib_ioctl" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> ERROR: "snd_card_free" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> ERROR: "snd_card_register" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> ERROR: "snd_pcm_new" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/media/video/cx231xx/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20090407.orig/drivers/media/video/cx231xx/Kconfig
> +++ linux-next-20090407/drivers/media/video/cx231xx/Kconfig
> @@ -6,7 +6,7 @@ config VIDEO_CX231XX
>         select VIDEO_IR
>         select VIDEOBUF_VMALLOC
>         select VIDEO_CX25840
> -       select VIDEO_CX231XX_ALSA
> +       select VIDEO_CX231XX_ALSA if SND
>  
>  	---help---
>  	  This is a video4linux driver for Conexant 231xx USB based TV cards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
