Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33028 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbZBBUYo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 15:24:44 -0500
Message-ID: <4987568A.6060504@iki.fi>
Date: Mon, 02 Feb 2009 22:24:42 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org,
	Andrew Williams <andrew.williams@joratech.com>
Subject: Re: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) / AF9015
 -	Dual tuner enabled by default =Bad signal reception
References: <546B4176F0487A4CBA62FC16EFC1D9D6026FC2@EXCHANGE.joratech.com>
In-Reply-To: <546B4176F0487A4CBA62FC16EFC1D9D6026FC2@EXCHANGE.joratech.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

> I have just downloaded the latest drivers and it seems that both tuners
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
