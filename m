Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:40133 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752357AbcJJGim (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 02:38:42 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id CE53420B1F
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 08:38:40 +0200 (CEST)
Date: Mon, 10 Oct 2016 08:38:39 +0200
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
Subject: Re: [PATCH 06/26] cxusb: don't do DMA on stack
Message-ID: <20161010083839.3eb2808d@posteo.de>
In-Reply-To: <7727b11abd004f683589586082f1b00926d5dade.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
        <7727b11abd004f683589586082f1b00926d5dade.1475860773.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  7 Oct 2016 14:24:16 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/dvb-usb/cxusb.c | 20 +++++++-------------
>  drivers/media/usb/dvb-usb/cxusb.h |  5 +++++
>  2 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c
> b/drivers/media/usb/dvb-usb/cxusb.c index 907ac01ae297..f3615349de52
> 100644 --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -45,9 +45,6 @@
>  #include "si2168.h"
>  #include "si2157.h"
>  
> -/* Max transfer size done by I2C transfer functions */
> -#define MAX_XFER_SIZE  80
> -
>  /* debug */
>  static int dvb_usb_cxusb_debug;
>  module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
> @@ -61,23 +58,20 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  static int cxusb_ctrl_msg(struct dvb_usb_device *d,
>  			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int
> rlen) {
> +	struct cxusb_state *st = d->priv;
>  	int wo = (rbuf == NULL || rlen == 0); /* write-only */
> -	u8 sndbuf[MAX_XFER_SIZE];
>  
> -	if (1 + wlen > sizeof(sndbuf)) {
> -		warn("i2c wr: len=%d is too big!\n",
> -		     wlen);
> +	if (1 + wlen > MAX_XFER_SIZE) {
> +		warn("i2c wr: len=%d is too big!\n", wlen);
>  		return -EOPNOTSUPP;
>  	}
>  
> -	memset(sndbuf, 0, 1+wlen);
> -
> -	sndbuf[0] = cmd;
> -	memcpy(&sndbuf[1], wbuf, wlen);
> +	st->data[0] = cmd;
> +	memcpy(&st->data[1], wbuf, wlen);
>  	if (wo)
> -		return dvb_usb_generic_write(d, sndbuf, 1+wlen);
> +		return dvb_usb_generic_write(d, st->data, 1 + wlen);
>  	else
> -		return dvb_usb_generic_rw(d, sndbuf, 1+wlen, rbuf,
> rlen, 0);
> +		return dvb_usb_generic_rw(d, st->data, 1 + wlen,
> rbuf, rlen, 0); }
>  
>  /* GPIO */
> diff --git a/drivers/media/usb/dvb-usb/cxusb.h
> b/drivers/media/usb/dvb-usb/cxusb.h index 527ff7905e15..18acda19527a
> 100644 --- a/drivers/media/usb/dvb-usb/cxusb.h
> +++ b/drivers/media/usb/dvb-usb/cxusb.h
> @@ -28,10 +28,15 @@
>  #define CMD_ANALOG        0x50
>  #define CMD_DIGITAL       0x51
>  
> +/* Max transfer size done by I2C transfer functions */
> +#define MAX_XFER_SIZE  80
> +
>  struct cxusb_state {
>  	u8 gpio_write_state[3];
>  	struct i2c_client *i2c_client_demod;
>  	struct i2c_client *i2c_client_tuner;
> +
> +	unsigned char data[MAX_XFER_SIZE];
>  };
>  
>  #endif

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
