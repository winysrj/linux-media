Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:50202 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaIFCvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Sep 2014 22:51:11 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBG004U2L99M4A0@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 05 Sep 2014 22:51:09 -0400 (EDT)
Date: Fri, 05 Sep 2014 23:51:05 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend for
 APIv5
Message-id: <20140905235105.3ab6e7c4.m.chehab@samsung.com>
In-reply-to: <540A6CF3.4070401@iki.fi>
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
 <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi>
 <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi>
 <540059B5.8050100@gmail.com> <540A6CF3.4070401@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 06 Sep 2014 05:09:55 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Moro!
> 
> On 08/29/2014 01:45 PM, Akihiro TSUKADA wrote:
> > moikka,
> >
> >> Start polling thread, which polls once per 2 sec or so, which reads RSSI
> >> and writes value to struct dtv_frontend_properties. That it is, in my
> >> understanding. Same for all those DVBv5 stats. Mauro knows better as he
> >> designed that functionality.
> >
> > I understand that RSSI property should be set directly in the tuner driver,
> > but I'm afraid that creating a kthread just for updating RSSI would be
> > overkill and complicate matters.
> >
> > Would you give me an advice? >> Mauro
> 
> Now I know that as I implement it. I added kthread and it works 
> correctly, just I though it is aimed to work. In my case signal strength 
> is reported by demod, not tuner, because there is some logic in firmware 
> to calculate it.
> 
> Here is patches you would like to look as a example:
> 
> af9033: implement DVBv5 statistic for signal strength
> https://patchwork.linuxtv.org/patch/25748/

Actually, you don't need to add a separate kthread to collect the stats.
The DVB frontend core already has a thread that calls the frontend status
on every 3 seconds (the time can actually be different, depending on
the value for fepriv->delay. So, if the device doesn't have any issues
on getting stats on this period, it could just hook the DVBv5 stats logic
at ops.read_status().

>From the last time I reviewed the code, the PT3 driver seems to be using
this approach already at the demod.

Getting this value at the tuner makes it a little more trickier,
as you need to use some tuner callback to update the demod cache.
The .get_rf_strength ops is meant to get the signal strength from the
tuner, but it doesn't allow the tuner to return a value in dBm.

It shouldn't be the demod's task to convert a raw value on a tuner client
into dBm. 

After reading this thread and its comments, I think that the best would be
to not add a new callback.

Instead, change the implementation at the .get_rf_strength callback in
a way that it will return an integer from 0 to 65535 that would represent
a "percentage" level, where 100% means the maximum signal that the device
can measure.

Inside the tuner driver (mxl301rf), a call to .get_rf_strength will
directly update the FE stats cache to reflect the signal measurements in
dBm.

So, from the bridge driver, it will just call .get_rf_strength() without
using the returned results. If, latter, we use this tuner on some other
configuration (for example, on an hybrid analog/digital or SDR/digital
board), the V4L2 part will use the "percentage" level, as the V4L2 API
doesn't support returning values in dBm.

Regards,
Mauro

> af9033: implement DVBv5 statistic for CNR
> https://patchwork.linuxtv.org/patch/25744/
> 
> af9033: implement DVBv5 stat block counters
> https://patchwork.linuxtv.org/patch/25749/
> 
> af9033: implement DVBv5 post-Viterbi BER
> https://patchwork.linuxtv.org/patch/25750/
> 
> regards
> Antti
> 
