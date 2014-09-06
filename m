Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58507 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaIFKgT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 06:36:19 -0400
Message-ID: <540AE39E.1010402@iki.fi>
Date: Sat, 06 Sep 2014 13:36:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi> <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi> <540059B5.8050100@gmail.com> <540A6CF3.4070401@iki.fi> <20140905235105.3ab6e7c4.m.chehab@samsung.com> <20140905235432.5eeab2a3.m.chehab@samsung.com> <540A7B09.2090300@iki.fi> <20140906001726.4929ba2f.m.chehab@samsung.com> <540A88DB.5020306@gmail.com>
In-Reply-To: <540A88DB.5020306@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2014 07:08 AM, Akihiro TSUKADA wrote:
> Moikka!,
> thanks for the comments and advices.
>
> I had been updating my code and during that, I also found that
> updating property cache in tuner_ops.get_signal_strength() was
> simple and (seemed to me) better than using a kthread,
> so the current implementation (under testing) is just like
> what Mauro proposed, but,
>
>> In time: not implementing its own thread has one drawback: the driver needs
>> to check if the minimal time needed to get a new stats were already archived.
>
> since I don't know the minimal time and
> whether there's a limit in the first place,
> I'd like to let users take the responsibility.

You could add some simple jiffie (some kind of kernel global time) which 
limits calls to some reasonable level.

if (jiffies > jiffies_previous + 1 sec)
   return 0;
else
   jiffies_previous = jiffies;

... continue

>>> ... I simply don't understand why you want hook that RF strength call
>>> via demod? The frontend cache is shared between demod and tuner. We use
>>> it for tuner drivr as well demod driver. Let the tuner driver make RSSI
>>> calculation independently without any unneeded relation to demod driver.
>
> I think the main reason for the hook is because the dvb-core calls
> ops.get_frontend() everytime before reading of any property cache,
> so it is already a nice place to trigger property updates,
> and reading any property involves demod (FE as a whole) anyway.

That must be changed 'resently'. IIRC originally get_frontend() was 
called by dvb-core only once, just after demod lock was gained. Also 
userspace could call it using some IOCTL (GET_FRONTEND?).

But if it is not called periodically by dvb-core, you could not use it 
for bit error measurements, as you will usually need to start 
measurement, then wait complete, read values and return.

Signal strength and SNR are typically provided by chip without any waiting.

regards
Antti

-- 
http://palosaari.fi/
