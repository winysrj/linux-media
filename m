Return-path: <mchehab@pedra>
Received: from mgw-da02.ext.nokia.com ([147.243.128.26]:52437 "EHLO
	mgw-da02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1AQOOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 09:14:43 -0500
Subject: Re: [PATCH 8/8] [media] saa7134: Kworld SBTVD: make both analog
 and digital to work
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20110115160424.4b474921@pedra>
References: <cover.1295114145.git.mchehab@redhat.com>
	 <20110115160424.4b474921@pedra>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 16:14:26 +0200
Message-ID: <1295273667.25951.41.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-15 at 16:04 -0200, ext Mauro Carvalho Chehab wrote:
> There are some weird bugs at tda8290/tda18271 initialization, as it
> insits do do analog initialization during DVB frontend attach:
> 
> diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
> index 419d064..bc6a677 100644
> --- a/drivers/media/common/tuners/tda8290.c
> +++ b/drivers/media/common/tuners/tda8290.c
> @@ -232,6 +232,7 @@ static void tda8290_set_params(struct dvb_frontend *fe,
>  		tuner_i2c_xfer_send(&priv->i2c_props, pll_bw_nom, 2);
>  	}
>  
> +
>  	tda8290_i2c_bridge(fe, 1);

Don't add a second empty line here...

Cheers,
Matti

 


