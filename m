Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:27030 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaIFMuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Sep 2014 08:50:05 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBH005S8CZFHA80@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 06 Sep 2014 08:50:03 -0400 (EDT)
Date: Sat, 06 Sep 2014 09:49:58 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend for
 APIv5
Message-id: <20140906094958.0c2d7d20.m.chehab@samsung.com>
In-reply-to: <540AE39E.1010402@iki.fi>
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
 <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi>
 <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi>
 <540059B5.8050100@gmail.com> <540A6CF3.4070401@iki.fi>
 <20140905235105.3ab6e7c4.m.chehab@samsung.com>
 <20140905235432.5eeab2a3.m.chehab@samsung.com> <540A7B09.2090300@iki.fi>
 <20140906001726.4929ba2f.m.chehab@samsung.com> <540A88DB.5020306@gmail.com>
 <540AE39E.1010402@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 06 Sep 2014 13:36:14 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 09/06/2014 07:08 AM, Akihiro TSUKADA wrote:
> > Moikka!,
> > thanks for the comments and advices.
> >
> > I had been updating my code and during that, I also found that
> > updating property cache in tuner_ops.get_signal_strength() was
> > simple and (seemed to me) better than using a kthread,
> > so the current implementation (under testing) is just like
> > what Mauro proposed, but,
> >
> >> In time: not implementing its own thread has one drawback: the driver needs
> >> to check if the minimal time needed to get a new stats were already archived.
> >
> > since I don't know the minimal time and
> > whether there's a limit in the first place,
> > I'd like to let users take the responsibility.

For RSSI measurements, in general there's no minimal time, but for measures
like BER, PER, UCB, you'll need to wait for a while before the stats to be
updated. So, you'll need to at least track those.

> You could add some simple jiffie (some kind of kernel global time) which 
> limits calls to some reasonable level.
> 
> if (jiffies > jiffies_previous + 1 sec)
>    return 0;
> else
>    jiffies_previous = jiffies;

Don't use jiffies like that. jiffies can be overflowed and the update
will never occur. The right way is to use the macros time_after() and
time_before(), or, alternatively, time_is_after_jiffies() and
time_is_before_jiffies().

> 
> ... continue
> 
> >>> ... I simply don't understand why you want hook that RF strength call
> >>> via demod? The frontend cache is shared between demod and tuner. We use
> >>> it for tuner drivr as well demod driver. Let the tuner driver make RSSI
> >>> calculation independently without any unneeded relation to demod driver.
> >
> > I think the main reason for the hook is because the dvb-core calls
> > ops.get_frontend() everytime before reading of any property cache,
> > so it is already a nice place to trigger property updates,
> > and reading any property involves demod (FE as a whole) anyway.
> 
> That must be changed 'resently'. IIRC originally get_frontend() was 
> called by dvb-core only once, just after demod lock was gained. Also 
> userspace could call it using some IOCTL (GET_FRONTEND?).

No, get_frontend() is not automatically called by the dvb kthread after
lock has gained. Just double-checked.

> But if it is not called periodically by dvb-core, you could not use it 
> for bit error measurements, as you will usually need to start 
> measurement, then wait complete, read values and return.

Probably, the application you're using for tests are calling it
periodically.

What the core calls periodically for sure is read_status(). That's why
most drivers that provide DVBv5 stats hook the cache update there.

> Signal strength and SNR are typically provided by chip without any waiting.
> 
> regards
> Antti
> 
