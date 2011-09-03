Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33913 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1ICPYs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Sep 2011 11:24:48 -0400
Message-ID: <4E6246BB.8000500@iki.fi>
Date: Sat, 03 Sep 2011 18:24:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] dvb-core, tda18271c2dd: define get_if_frequency()
 callback
References: <1315062777-12049-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1315062777-12049-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2011 06:12 PM, Mauro Carvalho Chehab wrote:
> The DRX-K frontend needs to know the IF frequency in order to work,
> just like all other frontends. However, as it is a multi-standard
> FE, the IF may change if the standard is changed. So, the usual
> procedure of passing it via a config struct doesn't work.
>
> One might code it as two separate IF frequencies, one by each type
> of FE, but, as, on tda18271, the IF changes if the bandwidth for
> DVB-C changes, this also won't work.
>
> So, the better is to just add a new callback for it and require
> it for the tuners that can be used with MFE frontends like drx-k.
>
> It makes sense to add support for it on all existing tuners, and
> remove the IF parameter from the demods, cleaning up the code.

Is it clear that only used tuner IC defines used IF?

I have seen some cases where used IF is different depending on other 
used hardware, even same tuner IC used. Very good example is to see all 
configuration structs of old tda18271 driver. Those are mainly used for 
setting different IF than tuner default...

Antti
-- 
http://palosaari.fi/
