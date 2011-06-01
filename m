Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab1FAULP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 16:11:15 -0400
Message-ID: <4DE69CD9.60304@redhat.com>
Date: Wed, 01 Jun 2011 17:11:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Hans Petter Selasky <hselasky@c2i.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Increase a timeout, so that bad scheduling does not accidentially
 cause a timeout.
References: <201105231622.30789.hselasky@c2i.net>
In-Reply-To: <201105231622.30789.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manu,

Another patch for your review.

Cheers,
Mauro

Em 23-05-2011 11:22, Hans Petter Selasky escreveu:
> --HPS
> 
> 
> dvb-usb-0015.patch
> 
> 
> From 18faaafc9cbbe478bb49023bbeae490149048560 Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 23 May 2011 16:21:47 +0200
> Subject: [PATCH] Increase a timeout, so that bad scheduling does not accidentially cause a timeout.
> 
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> ---
>  drivers/media/dvb/frontends/stb0899_drv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
> index 37a222d..ddb9141 100644
> --- a/drivers/media/dvb/frontends/stb0899_drv.c
> +++ b/drivers/media/dvb/frontends/stb0899_drv.c
> @@ -706,7 +706,7 @@ static int stb0899_send_diseqc_msg(struct dvb_frontend *fe, struct dvb_diseqc_ma
>  	stb0899_write_reg(state, STB0899_DISCNTRL1, reg);
>  	for (i = 0; i < cmd->msg_len; i++) {
>  		/* wait for FIFO empty	*/
> -		if (stb0899_wait_diseqc_fifo_empty(state, 10) < 0)
> +		if (stb0899_wait_diseqc_fifo_empty(state, 100) < 0)
>  			return -ETIMEDOUT;
>  
>  		stb0899_write_reg(state, STB0899_DISFIFO, cmd->msg[i]);
> -- 1.7.1.1

