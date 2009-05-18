Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48519 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbZERHCn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 03:02:43 -0400
Date: Mon, 18 May 2009 04:02:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0905_19] Siano: smscards - fix wrong firmware
 assignment
Message-ID: <20090518040240.293b159a@pedra.chehab.org>
In-Reply-To: <886941.10625.qm@web110805.mail.gq1.yahoo.com>
References: <886941.10625.qm@web110805.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 May 2009 12:33:37 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> escreveu:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242327843 -10800
> # Node ID ccbe8d7a70064b1552f2034b958551b8fc294d8e
> # Parent  fdfd103426e8aeabb18aaa1e117238e3ca450d0e
> [0905_19] Siano: smscards - fix wrong firmware assignment
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> Remove wrong firmware assignments for Nova, Stellar

This patch reminds me something very important:

We need Siano's ack for firmware distribution, and the firmware files.

Please send me a tarball or a zip file with the firmwares, plus Siano's
authorization for firmware distribution for me to add it at the proper places.

Cheers,
Mauro.
> 
> Priority: normal
> 
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> 
> diff -r fdfd103426e8 -r ccbe8d7a7006 linux/drivers/media/dvb/siano/sms-cards.c
> --- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:00:53 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 22:04:03 2009 +0300
> @@ -81,17 +81,14 @@ static struct sms_board sms_boards[] = {
>  	[SMS1XXX_BOARD_SIANO_STELLAR] = {
>  		.name	= "Siano Stellar Digital Receiver",
>  		.type	= SMS_STELLAR,
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-stellar-dvbt-01.fw",
>  	},
>  	[SMS1XXX_BOARD_SIANO_NOVA_A] = {
>  		.name	= "Siano Nova A Digital Receiver",
>  		.type	= SMS_NOVA_A0,
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-a-dvbt-01.fw",
>  	},
>  	[SMS1XXX_BOARD_SIANO_NOVA_B] = {
>  		.name	= "Siano Nova B Digital Receiver",
>  		.type	= SMS_NOVA_B0,
> -		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
>  	},
>  	[SMS1XXX_BOARD_SIANO_VEGA] = {
>  		.name	= "Siano Vega Digital Receiver",
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
