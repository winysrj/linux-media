Return-path: <mchehab@pedra>
Received: from gate2.ipvision.dk ([217.195.186.4]:37366 "EHLO
	gate2.ipvision.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1B1QEt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 11:04:49 -0500
From: Benny Amorsen <benny+usenet@amorsen.dk>
To: Antti Palosaari <crope@iki.fi>
Cc: Malte Gell <malte.gell@gmx.de>, linux-media@vger.kernel.org
Subject: Re: Well supported USB DVB-C device?
References: <201102280102.17852.malte.gell@gmx.de> <4D6AEC35.8000202@iki.fi>
Date: Mon, 28 Feb 2011 16:51:13 +0100
In-Reply-To: <4D6AEC35.8000202@iki.fi> (Antti Palosaari's message of "Mon, 28
	Feb 2011 02:28:37 +0200")
Message-ID: <m3pqqcyx72.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Antti Palosaari <crope@iki.fi> writes:

> On 02/28/2011 02:02 AM, Malte Gell wrote:
>> is there a DVB-C device with USB that is well supported by a recent kernel
>> (2.6.38)?
>
> Anysee E30 C Plus is supported as far as I know.

I can confirm that. The only downside so far is that it seems to need a
lot of hand-holding by the CPU, which in turn leads to increased power
consumption.

> Note that new revision of Anysee E30 Combo Plus is no longer supported
> since they changed to new NXP silicon tuner. E30 Combo Plus and E30 C
> Plus are different devices.

Ouch. I really wish vendors would stop using the same name for different
devices.


/Benny
