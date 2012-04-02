Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:42882 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751656Ab2DBRCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 13:02:44 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH][GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 support for AverTV A867R (mxl5007t), version 2
Date: Mon, 2 Apr 2012 19:02:37 +0200
Cc: linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <201204012307.31742.hfvogt@gmx.net> <4F78C957.2080102@iki.fi>
In-Reply-To: <4F78C957.2080102@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204021902.37469.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

I am currently working with a simple standalone test environment and therefore 
have manually (!) included the paths. Well, this went terribly wrong... Sorry.

Am Sonntag, 1. April 2012 schrieb Antti Palosaari:
> On 02.04.2012 00:07, Hans-Frieder Vogt wrote:
> > Support of AVerMedia AVerTV HD Volar, with tuner MxL5007t, second version
> > of patch (usage of clock_adc_lut instead of adc config variable)
> > 
> > Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>
> 
> Patch does not apply.
> wget -O - http://patchwork.linuxtv.org/patch/10536/mbox/ | git am -s
> [...]
> Applying: AF9035/AF9033/TUA9001 support for AverTV A867R (mxl5007t),
> version 2
> error: drivers/media/dvb/dvb-usb/af9033.c: does not exist in index
> error: drivers/media/dvb/dvb-usb/af9033.h: does not exist in index
> error: drivers/media/dvb/dvb-usb/af9033_priv.h: does not exist in index
> 
> How is it possible you have the af9033 demod driver inside dvb-usb
> directory? Demod drivers are inside drivers/media/dvb/frontends/. DVB
> USB interface drivers are inside drivers/media/dvb/dvb-usb/.
> 
> Now it looks still much better than first version.
> 
> Here are still some comments of quick visual review:
> > +		for (i = 0; i<  ARRAY_SIZE(clock_adc_lut); i++) {
> > +			if (clock_adc_lut[i].clock == state->cfg.clock)
> > +				break;
> > +		}
> > +		if (i>= ARRAY_SIZE(clock_adc_lut)) {
> > +			ret = -EINVAL;
> > +			goto err;
> > +		}
I included this as a sanity check. It should not be needed if it can be 
ensured that the lookup tables clock_lut (in af9035.h) and clock_adc_lut (in 
af9033_priv.h) always contain the same Xtal frequencies. Maybe these two 
tables coule be merged...

> That error check is useless in my understanding. It is never taken.
> Likely some Kernel semantic error checker will report it later...
> 
> > +		adc_freq = clock_adc_lut[i].adc;
> > 
> > 
> > -	for (i = 0; i<  af9035_properties[0].num_adapters; i++)
> > +	for (i = 0; i<  af9035_properties[0].num_adapters; i++) {
> > 
> >   		af9035_af9033_config[i].clock = clock_lut[tmp];
> > 
> > +	}
> 
> No braces allowed here as it is single line. You did not ran
> checkpatch.pl as it will report those.
> 
> Hans-Frieder, fix those findings and remember ran also Kernel
> checkpatch.pl - it may report some more findings.
> 
> You can ran it like that:
> git diff drivers/media/dvb/frontends/af9033.c | ./scripts/checkpatch.pl -
> 
thanks very much. I'll send an updated patch soon...

> Or if you have already added those files as git add then you can:
> git diff --cached | ./scripts/checkpatch.pl -
> 
> Good work still! Next try should be OK :)
> 
> regards
> Antti

regards,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
