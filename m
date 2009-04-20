Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43894 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZDTSCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 14:02:44 -0400
Date: Mon, 20 Apr 2009 15:02:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_13] Siano: move DVB_API and remove redundant code
Message-ID: <20090420150238.35d36f72@pedra.chehab.org>
In-Reply-To: <943396.95266.qm@web110808.mail.gq1.yahoo.com>
References: <943396.95266.qm@web110808.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 03:31:32 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1238755204 -10800
> # Node ID f65a29f0f9a66f82a91525ae0085a15f00ac91c2
> # Parent  897669fdeb3be75a2bde978557b5398a4a7d8914
> [PATCH] [0904_13] Siano: move DVB_API and remove redundant code
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> The DVB-API related information has been moved from the core header
> to the smsdvb, and the redundant code has been removed from the
> core header.
> 
> This code has been moved since it is used only by
> the smsdvb client component.

This patch depends on the previous patches that I asked some changes. Please
re-submit it together with the other patches that weren't committed. It is
probably not much valuable to commit the later patches, so I'll stop analysing
the code here.

The patch itself looks sane to my eyes.
> 
> Priority: normal
> 
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> 
> diff -r 897669fdeb3b -r f65a29f0f9a6 linux/drivers/media/dvb/siano/smscoreapi.h
> --- a/linux/drivers/media/dvb/siano/smscoreapi.h	Fri Apr 03 13:31:13 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Fri Apr 03 13:40:04 2009 +0300
> @@ -36,15 +36,6 @@ along with this program.  If not, see <h
>  #include <asm/page.h>
>  
>  /* #include "smsir.h" */
> -
> -#define SMS_DVB3_SUBSYS
> -#ifdef SMS_DVB3_SUBSYS
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -
> -#endif
>  
>  #define kmutex_init(_p_) mutex_init(_p_)
>  #define kmutex_lock(_p_) mutex_lock(_p_)
> diff -r 897669fdeb3b -r f65a29f0f9a6 linux/drivers/media/dvb/siano/smsdvb.c
> --- a/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 13:31:13 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 13:40:04 2009 +0300
> @@ -22,6 +22,11 @@ along with this program.  If not, see <h
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <asm/byteorder.h>
> +
> +#include "dmxdev.h"
> +#include "dvbdev.h"
> +#include "dvb_demux.h"
> +#include "dvb_frontend.h"
>  
>  #include "smscoreapi.h"
>  /*#include "smsendian.h"*/
> @@ -52,7 +57,7 @@ struct smsdvb_client_t {
>  	fe_status_t fe_status;
>  	int fe_ber, fe_snr, fe_unc, fe_signal_strength;
>  
> -	struct completion tune_done, stat_done;
> +	struct completion tune_done;
>  
>  	/* todo: save freq/band instead whole struct */
>  	struct dvb_frontend_parameters fe_params;
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
