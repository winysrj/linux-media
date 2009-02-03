Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:36281 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbZBCIA7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 03:00:59 -0500
Subject: RE: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) / AF9015 -	Dual tuner enabled by default =Bad signal reception
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Tue, 3 Feb 2009 19:00:35 +1100
Message-ID: <546B4176F0487A4CBA62FC16EFC1D9D6026FC9@EXCHANGE.joratech.com>
Content-class: urn:content-classes:message
In-Reply-To: <4987568A.6060504@iki.fi>
References: <546B4176F0487A4CBA62FC16EFC1D9D6026FC2@EXCHANGE.joratech.com> <4987568A.6060504@iki.fi>
From: "Andrew Williams" <andrew.williams@joratech.com>
To: <linux-dvb@linuxtv.org>, "Antti Palosaari" <crope@iki.fi>
Cc: <linux-media@vger.kernel.org>, <lindsay.mathieson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



-----Original Message-----
From: Antti Palosaari [mailto:crope@iki.fi] 
Sent: Tuesday, 3 February 2009 07:25
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org; Andrew Williams
Subject: Re: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) /
AF9015 - Dual tuner enabled by default =Bad signal reception

Hello Andrew,
Andrew Williams wrote:
> In the past I have had problems with reception for the AF9015 if both
> tuners were enabled.
> It was disabled by default or I could manually enable dual tuners with
> dvb-usb-af9015 dual_mode=1 (modprobe.d/options)
> 
> If both tuners were enabled there was a lot of signal degradation,
> however, with only 1 tuner enabled the quality was VERY good.

Yes, it really looks like there is some sensitivity drop when both 
tuners are enabled. However in my understanding tuner #1 in dual mode 
have almost same performance than tuner #0 in single mode. Also current 
MXL5005S tuner driver has not best performance...

Could you test if that tuner driver performs any better for you:
http://linuxtv.org/hg/~anttip/af9015-mxl500x/

> I have just downloaded the latest drivers and it seems that both
tuners
> are enabled by default and there is no parameter that I can find to
> disable the second tuner.
> Now I am back to where I was before with bad signal degradation but no
> way to disable the second tuner.

Yes, I removed whole parameter. If there will be much negative feedback 
then I should consider add that parameter back - but probably dual mode 
enabled by default.

> With drivers dated 22 Dec 2008 the second tuner was still disabled by
> default. Also the driver from 22 December 2008 lit an LED on the Tuner
> to indicate that the firmware was loaded/stick was initialised.
> Something that I did not have before (the LED).
> 
> Now with the latest driver, the LED does not function anymore but more
> importantly, both tuners are enabled by default.

hmm, haven't changed LED controls. I should look that later.

> Is there any way that I can disable the second tuner without having to
> revert to the old drivers?

Not currently. I will wait some feedback and make decision about that.

Thank you for feedback.

regards
Antti
-- 
http://palosaari.fi/



Thanks Antti,

Thanks for your reply and suggestions.

I will reload the current latest driver and switch to Tuner 1 and test.

I will also install the suggested driver
http://linuxtv.org/hg/~anttip/af9015-mxl500x/
After testing I will get back to you.

Current dual tuner Signal degradation is uniform over all channels -
SBS/CH10/CH9/CH7/ABC here in Oz
Unit is powered from a signal amplifier with a 20db variable attenuator
(for testing so that I do not overdrive DVB).
Reception Quality is compared with a DVICO Dual Digital 4 (rev 2) on the
same splitter whenever I encounter a problem.
I have noticed that the DVICO does not exhibit the same problems on the
same machine as the AF9015.

Don't get me wrong, I would love to have both tuners working well on the
AF9015.

As for the me not being able to disable the second tuner: Played with
af9015.c and compared it to previous version that
Had the function dvb_usb_af9015_dual_mode and parsed 6 lines back in
into the 10day old driver. 


I added the following back into af9015.c in the right places, so no need
to bother you with that if I still need it after the testing above:

static int dvb_usb_af9015_dual_mode;
module_param_named(dual_mode, dvb_usb_af9015_dual_mode, int, 0644);
MODULE_PARM_DESC(dual_mode, "enable dual mode"); 


 /* disable dual mode by default because it is buggy */
 if (!dvb_usb_af9015_dual_mode)
 af9015_config.dual_mode = 0; 


Compiled. I can now disable the second tuner if I need in future.
Unfortunately I am not a programmer so these things took me a while. No
need for you to worry about that as I can solve dvb_usb_af9015_dual_mode
myself in future, thanks very much for your clearly marked code.

Any chance to stop a remote being detected for my af9015? It has no IR
sensor or remote - KWorld PlusTV Dual DVB-T Stick 
The drivers detect a remote. I can't see one on the unit. Is it ok to
leave it as is or is it better to disable (and how do I do that) remote
detection on the DVB?

Thanks for all your hard work.

Regards

Andrew



