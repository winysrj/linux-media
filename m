Return-path: <mchehab@pedra>
Received: from canardo.mork.no ([148.122.252.1]:45631 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759257Ab1FARTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 13:19:05 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Antti Palosaari <crope@iki.fi>
Cc: Steve Kerrison <steve@stevekerrison.com>,
	linux-media@vger.kernel.org
Subject: Re: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter() from em28xx-dvb.c creates a hard module dependency
References: <87vcwpnavc.fsf@nemi.mork.no> <4DE60B36.9040507@iki.fi>
	<87mxi1n7ql.fsf@nemi.mork.no>
Date: Wed, 01 Jun 2011 19:18:58 +0200
In-Reply-To: <87mxi1n7ql.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Wed, 01
	Jun 2011 12:53:06 +0200")
Message-ID: <87tyc9lbb1.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Bjørn Mork <bjorn@mork.no> writes:

> diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
> index 7904ca4..d994592 100644
> --- a/drivers/media/video/em28xx/em28xx-dvb.c
> +++ b/drivers/media/video/em28xx/em28xx-dvb.c
> @@ -669,7 +669,8 @@ static int dvb_init(struct em28xx *dev)
>  			&em28xx_cxd2820r_config, &dev->i2c_adap, NULL);
>  		if (dvb->fe[0]) {
>  			struct i2c_adapter *i2c_tuner;
> -			i2c_tuner = cxd2820r_get_tuner_i2c_adapter(dvb->fe[0]);
> +			/* we don't really attach i2c_tuner.  Just reusing the symbol logic */
> +			i2c_tuner = dvb_attach(cxd2820r_get_tuner_i2c_adapter, dvb->fe[0]);

Except that this really messes up the reference count, and need to have
a matching symbol_put...  So you should probably code it with
symbol_request()/symbol_put() if you want to go this way instead of
the dvb_attach shortcut .


Bjørn 
