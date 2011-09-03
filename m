Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab1ICPnH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Sep 2011 11:43:07 -0400
Message-ID: <4E624B00.5040202@redhat.com>
Date: Sat, 03 Sep 2011 12:42:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] dvb-core, tda18271c2dd: define get_if_frequency()
 callback
References: <1315062777-12049-1-git-send-email-mchehab@redhat.com> <4E6246BB.8000500@iki.fi> <4E6249EF.9080702@iki.fi>
In-Reply-To: <4E6249EF.9080702@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-09-2011 12:38, Antti Palosaari escreveu:
> On 09/03/2011 06:24 PM, Antti Palosaari wrote:
>> On 09/03/2011 06:12 PM, Mauro Carvalho Chehab wrote:
>>> The DRX-K frontend needs to know the IF frequency in order to work,
>>> just like all other frontends. However, as it is a multi-standard
>>> FE, the IF may change if the standard is changed. So, the usual
>>> procedure of passing it via a config struct doesn't work.
>>>
>>> One might code it as two separate IF frequencies, one by each type
>>> of FE, but, as, on tda18271, the IF changes if the bandwidth for
>>> DVB-C changes, this also won't work.
>>>
>>> So, the better is to just add a new callback for it and require
>>> it for the tuners that can be used with MFE frontends like drx-k.
>>>
>>> It makes sense to add support for it on all existing tuners, and
>>> remove the IF parameter from the demods, cleaning up the code.
>>
>> Is it clear that only used tuner IC defines used IF?
>>
>> I have seen some cases where used IF is different depending on other
>> used hardware, even same tuner IC used. Very good example is to see all
>> configuration structs of old tda18271 driver. Those are mainly used for
>> setting different IF than tuner default...

Not sure if I understood your comments here.

There are two separate things here:

1) digital tuners like tda18271, xc3028, etc allow changing the IF frequency,
while others, like the analog tuners, have a fixed IF frequency. For digital
tuners, it makes sense to have ways to configure it, via the tuner's configuration
file, like the tda18271-fe driver.

This patch doesn't change anything with that regards.

2) Demods need to know what IF is used by the tuner. Currently, the bridge driver
needs to fill a per-demod configuration struct for it, or pass it via parameter.

This works fine, when the IF is fixed.

However, the tda18271 specs recommend different IF values for each bandwidth, and
between dvb-t and dvb-c.

It would be possible to workaround that and just use the same IF for everything
at tda18271, not obeying the recommended values, but this seems a bad idea, as
the chipset will be used on a non-tested configuration.

So, instead of fixing the same IF at the tuner, this patch allows the tuner to
change the IF as needed/desired, and letting the demod to change according with
the tuner changes.

I'll put the above comments at the committed patch.

> Hmm, I think that will actually only reduce defining same IFs to demod which are already set to tuner allowing to remove "redundant" demod definitions. OK, now it looks fine for me.
> 
> Acked-by: Antti Palosaari <crope@iki.fi>

Thanks!


> 
> 
> Antti

