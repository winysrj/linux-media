Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:49536 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752161AbcJJGg7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 02:36:59 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id D592820B13
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 08:36:57 +0200 (CEST)
Date: Mon, 10 Oct 2016 08:36:56 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Subject: Re: [PATCH 11/26] digitv: don't do DMA on stack
Message-ID: <20161010083656.4fa6610e@posteo.de>
In-Reply-To: <0ab236ba1bfe2935b2cda329b706fcc1ef55edeb.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
        <0ab236ba1bfe2935b2cda329b706fcc1ef55edeb.1475860773.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  7 Oct 2016 14:24:21 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/dvb-usb/digitv.c | 20 +++++++++++---------
>  drivers/media/usb/dvb-usb/digitv.h |  3 +++
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/digitv.c
> b/drivers/media/usb/dvb-usb/digitv.c index 63134335c994..09f8c28bd4db
> 100644 --- a/drivers/media/usb/dvb-usb/digitv.c
> +++ b/drivers/media/usb/dvb-usb/digitv.c
> @@ -28,20 +28,22 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  static int digitv_ctrl_msg(struct dvb_usb_device *d,
>  		u8 cmd, u8 vv, u8 *wbuf, int wlen, u8 *rbuf, int
> rlen) {
> +	struct digitv_state *st = d->priv;
>  	int wo = (rbuf == NULL || rlen == 0); /* write-only */
> -	u8 sndbuf[7],rcvbuf[7];
> -	memset(sndbuf,0,7); memset(rcvbuf,0,7);
>  
> -	sndbuf[0] = cmd;
> -	sndbuf[1] = vv;
> -	sndbuf[2] = wo ? wlen : rlen;
> +	memset(st->sndbuf, 0, 7);
> +	memset(st->rcvbuf, 0, 7);
> +
> +	st->sndbuf[0] = cmd;
> +	st->sndbuf[1] = vv;
> +	st->sndbuf[2] = wo ? wlen : rlen;
>  
>  	if (wo) {
> -		memcpy(&sndbuf[3],wbuf,wlen);
> -		dvb_usb_generic_write(d,sndbuf,7);
> +		memcpy(&st->sndbuf[3], wbuf, wlen);
> +		dvb_usb_generic_write(d, st->sndbuf, 7);
>  	} else {
> -		dvb_usb_generic_rw(d,sndbuf,7,rcvbuf,7,10);
> -		memcpy(rbuf,&rcvbuf[3],rlen);
> +		dvb_usb_generic_rw(d, st->sndbuf, 7, st->rcvbuf, 7,
> 10);
> +		memcpy(rbuf, &st->rcvbuf[3], rlen);
>  	}
>  	return 0;
>  }
> diff --git a/drivers/media/usb/dvb-usb/digitv.h
> b/drivers/media/usb/dvb-usb/digitv.h index 908c09f4966b..cf104689bdff
> 100644 --- a/drivers/media/usb/dvb-usb/digitv.h
> +++ b/drivers/media/usb/dvb-usb/digitv.h
> @@ -6,6 +6,9 @@
>  
>  struct digitv_state {
>      int is_nxt6000;
> +
> +    unsigned char sndbuf[7];
> +    unsigned char rcvbuf[7];
>  };
>  
>  /* protocol (from usblogging and the SDK:

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
