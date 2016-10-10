Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:41098 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbcJJGii (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 02:38:38 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id C90D020B44
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 08:38:22 +0200 (CEST)
Date: Mon, 10 Oct 2016 08:38:18 +0200
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
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Sean Young <sean@mess.org>,
        Nicolas Sugino <nsugino@3way.com.ar>,
        Alejandro Torrado <aletorrado@gmail.com>
Subject: Re: [PATCH 07/26] dib0700: be sure that dib0700_ctrl_rd() users can
 do DMA
Message-ID: <20161010083818.2d937db6@posteo.de>
In-Reply-To: <30a00ca71aec4502905cbdf5d1ab11c2ae7b8562.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
        <30a00ca71aec4502905cbdf5d1ab11c2ae7b8562.1475860773.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  7 Oct 2016 14:24:17 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> dib0700_ctrl_rd() takes a RX and a TX pointer. Be sure that
> both will point to a memory allocated via kmalloc().
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/dvb-usb/dib0700_core.c    |  4 +++-
>  drivers/media/usb/dvb-usb/dib0700_devices.c | 25
> +++++++++++++------------ 2 files changed, 16 insertions(+), 13
> deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c
> b/drivers/media/usb/dvb-usb/dib0700_core.c index
> f3196658fb70..515f89dba199 100644 ---
> a/drivers/media/usb/dvb-usb/dib0700_core.c +++
> b/drivers/media/usb/dvb-usb/dib0700_core.c @@ -292,13 +292,15 @@
> static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap, 
>  			/* special thing in the current firmware:
> when length is zero the read-failed */ len = dib0700_ctrl_rd(d,
> st->buf, msg[i].len + 2,
> -					msg[i+1].buf, msg[i+1].len);
> +					      st->buf, msg[i +
> 1].len); if (len <= 0) {
>  				deb_info("I2C read failed on address
> 0x%02x\n", msg[i].addr);
>  				break;
>  			}
>  
> +			memcpy(msg[i + 1].buf, st->buf, msg[i +
> 1].len); +
>  			msg[i+1].len = len;
>  
>  			i++;
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c
> b/drivers/media/usb/dvb-usb/dib0700_devices.c index
> 0857b56e652c..ef1b8ee75c57 100644 ---
> a/drivers/media/usb/dvb-usb/dib0700_devices.c +++
> b/drivers/media/usb/dvb-usb/dib0700_devices.c @@ -508,8 +508,6 @@
> static int stk7700ph_tuner_attach(struct dvb_usb_adapter *adap) 
>  #define DEFAULT_RC_INTERVAL 50
>  
> -static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
> -
>  /*
>   * This function is used only when firmware is < 1.20 version. Newer
>   * firmwares use bulk mode, with functions implemented at
> dib0700_core, @@ -517,7 +515,6 @@ static u8 rc_request[] =
> { REQUEST_POLL_RC, 0 }; */
>  static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
>  {
> -	u8 key[4];
>  	enum rc_type protocol;
>  	u32 scancode;
>  	u8 toggle;
> @@ -532,39 +529,43 @@ static int dib0700_rc_query_old_firmware(struct
> dvb_usb_device *d) return 0;
>  	}
>  
> -	i = dib0700_ctrl_rd(d, rc_request, 2, key, 4);
> +	st->buf[0] = REQUEST_POLL_RC;
> +	st->buf[1] = 0;
> +
> +	i = dib0700_ctrl_rd(d, st->buf, 2, st->buf, 4);
>  	if (i <= 0) {
>  		err("RC Query Failed");
> -		return -1;
> +		return -EIO;
>  	}
>  
>  	/* losing half of KEY_0 events from Philipps rc5 remotes.. */
> -	if (key[0] == 0 && key[1] == 0 && key[2] == 0 && key[3] == 0)
> +	if (st->buf[0] == 0 && st->buf[1] == 0
> +	    && st->buf[2] == 0 && st->buf[3] == 0)
>  		return 0;
>  
> -	/* info("%d: %2X %2X %2X
> %2X",dvb_usb_dib0700_ir_proto,(int)key[3-2],(int)key[3-3],(int)key[3-1],(int)key[3]);
> */
> +	/* info("%d: %2X %2X %2X
> %2X",dvb_usb_dib0700_ir_proto,(int)st->buf[3 - 2],(int)st->buf[3 -
> 3],(int)st->buf[3 - 1],(int)st->buf[3]);  */ dib0700_rc_setup(d,
> NULL); /* reset ir sensor data to prevent false events */ 
>  	switch (d->props.rc.core.protocol) {
>  	case RC_BIT_NEC:
>  		/* NEC protocol sends repeat code as 0 0 0 FF */
> -		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
> -		    (key[3] == 0xff)) {
> +		if ((st->buf[3 - 2] == 0x00) && (st->buf[3 - 3] ==
> 0x00) &&
> +		    (st->buf[3] == 0xff)) {
>  			rc_repeat(d->rc_dev);
>  			return 0;
>  		}
>  
>  		protocol = RC_TYPE_NEC;
> -		scancode = RC_SCANCODE_NEC(key[3-2], key[3-3]);
> +		scancode = RC_SCANCODE_NEC(st->buf[3 - 2], st->buf[3
> - 3]); toggle = 0;
>  		break;
>  
>  	default:
>  		/* RC-5 protocol changes toggle bit on new keypress
> */ protocol = RC_TYPE_RC5;
> -		scancode = RC_SCANCODE_RC5(key[3-2], key[3-3]);
> -		toggle = key[3-1];
> +		scancode = RC_SCANCODE_RC5(st->buf[3 - 2], st->buf[3
> - 3]);
> +		toggle = st->buf[3 - 1];
>  		break;
>  	}
>  

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
