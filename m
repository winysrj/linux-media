Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49878 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1I3Ksc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 06:48:32 -0400
Message-ID: <4E859E74.7080900@infradead.org>
Date: Fri, 30 Sep 2011 07:48:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.com>
CC: LMML <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	devin heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner)
 - workaround hack included
References: <201109281350.52099.simon.farnsworth@onelan.com>
In-Reply-To: <201109281350.52099.simon.farnsworth@onelan.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-09-2011 09:50, Simon Farnsworth escreveu:
> (note - the CC list is everyone over 50% certainty from get_maintainer.pl)
> 
> I'm having problems getting a Hauppauge HVR-1110 card to successfully
> tune PAL-D at 85.250 MHz vision frequency; by experimentation, I've
> determined that the tda18271 is tuning to a frequency 1.25 MHz lower
> than the vision frequency I've requested, so the following workaround
> "fixes" it for me.
> 
> diff --git a/drivers/media/common/tuners/tda18271-fe.c 
> b/drivers/media/common/tuners/tda18271-fe.c
> index 63cc400..1a94e1a 100644
> --- a/drivers/media/common/tuners/tda18271-fe.c
> +++ b/drivers/media/common/tuners/tda18271-fe.c
> @@ -1031,6 +1031,7 @@ static int tda18271_set_analog_params(struct 
> dvb_frontend *fe,
>  		mode = "I";
>  	} else if (params->std & V4L2_STD_DK) {
>  		map = &std_map->atv_dk;
> +                freq += 1250000;
>  		mode = "DK";
>  	} else if (params->std & V4L2_STD_SECAM_L) {
>  		map = &std_map->atv_l;

If I am to fix this bug, instead of a hack like that, it seems to be better
to split the .atv_dk line at the struct tda18271_std_map maps on
drivers/media/common/tuners/tda18271-maps.c.

Looking at the datasheet, on page 43, available at:
	http://www.nxp.com/documents/data_sheet/TDA18271HD.pdf

The offset values for IF seem ok, but maybe your device is using some variant
of this chip that requires a different maps table.

> 
> I've checked with a signal analyser, and confirmed that my signal
> generator is getting the spectrum right - I am seeing vision peaking
> at 85.25 MHz, with one sideband going down to 84.5 MHz, and the other
> going up to 90.5MHz. I also see an audio carrier at 91.75 MHz.
> 
> I'm going to run with this hack in place, but I'd appreciate it if
> someone who knew more about the TDA18271 looked at this, and either
> gave me a proper fix for testing, or confirmed that what I'm doing is
> right.
> --
> Simon Farnsworth
> Software Engineer
> ONELAN Limited
> http://www.onelan.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

