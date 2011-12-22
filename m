Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45362 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab1LVQ6Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 11:58:16 -0500
Message-ID: <4EF361A6.7080305@iki.fi>
Date: Thu, 22 Dec 2011 18:58:14 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Add tuner_type to zl10353 config and use it for reporting signal
 directly from tuner.
References: <CAEN_-SAuS1UTfLcJUpVP-WYeLVVj4-ycF0NyaEi=iQ0AnVbZEQ@mail.gmail.com>
In-Reply-To: <CAEN_-SAuS1UTfLcJUpVP-WYeLVVj4-ycF0NyaEi=iQ0AnVbZEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/21/2011 11:07 PM, Miroslav Slugeň wrote:
> XC4000 based cards are not using AGC control in normal way, so it is
> not possible to get signal level from AGC registres of zl10353
> demodulator, instead of this i send previous patch to implement signal
> level directly in xc4000 tuner and now sending patch for zl10353 to
> implement this future for digital mode. Signal reporting is very
> accurate and was well tested on 3 different Leadtek XC4000 cards.

I don't like that patch at all. My opinion is that you should put hacks 
like to the interface driver. Override demod .read_signal_strength() 
callback and route it to the tuner callback. No any changes for the 
demod driver should be done.

Estimation of the signal strength is a little bit hard when looking 
demod point of view. Demod gets IF as input signal and thus have mainly 
idea of IF AGC values. Estimating RF strength is thus very inaccurate 
from the IF AGC gain. And those IF AGC values are tuner/demod 
combination dependent too. Sometimes there is also RF AGC available for 
the demod. With both IF and RF AGC you could estimate more better - but 
still very inaccurate.


regards
Antti
-- 
http://palosaari.fi/
