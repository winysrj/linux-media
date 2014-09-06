Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:34882 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaIFWhe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Sep 2014 18:37:34 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBI0098J46LFT30@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 06 Sep 2014 18:37:33 -0400 (EDT)
Date: Sat, 06 Sep 2014 19:37:28 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, Akihiro TSUKADA <tskd08@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend for
 APIv5
Message-id: <20140906193728.13b0f725.m.chehab@samsung.com>
In-reply-to: <540B7E91.5000700@gmail.com>
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
 <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi>
 <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi>
 <540059B5.8050100@gmail.com> <540A6CF3.4070401@iki.fi>
 <20140905235105.3ab6e7c4.m.chehab@samsung.com> <540B3551.9060003@gmail.com>
 <540B7E91.5000700@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 06 Sep 2014 22:37:21 +0100
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> On 06/09/14 17:24, Malcolm Priestley wrote:
> > On 06/09/14 03:51, Mauro Carvalho Chehab wrote:
> >> Em Sat, 06 Sep 2014 05:09:55 +0300
> >> Antti Palosaari <crope@iki.fi> escreveu:
> >>
> >>> Moro!
> >>>
> >>> On 08/29/2014 01:45 PM, Akihiro TSUKADA wrote:
> >>>> moikka,
> >>>>
> >>>>> Start polling thread, which polls once per 2 sec or so, which reads
> >>>>> RSSI
> >>>>> and writes value to struct dtv_frontend_properties. That it is, in my
> >>>>> understanding. Same for all those DVBv5 stats. Mauro knows better
> >>>>> as he
> >>>>> designed that functionality.
> >>>>
> >>>> I understand that RSSI property should be set directly in the tuner
> >>>> driver,
> >>>> but I'm afraid that creating a kthread just for updating RSSI would be
> >>>> overkill and complicate matters.
> >>>>
> >>>> Would you give me an advice? >> Mauro
> >>>
> >>> Now I know that as I implement it. I added kthread and it works
> >>> correctly, just I though it is aimed to work. In my case signal strength
> >>> is reported by demod, not tuner, because there is some logic in firmware
> >>> to calculate it.
> >>>
> >>> Here is patches you would like to look as a example:
> >>>
> >>> af9033: implement DVBv5 statistic for signal strength
> >>> https://patchwork.linuxtv.org/patch/25748/
> >>
> >> Actually, you don't need to add a separate kthread to collect the stats.
> >> The DVB frontend core already has a thread that calls the frontend status
> >> on every 3 seconds (the time can actually be different, depending on
> >> the value for fepriv->delay. So, if the device doesn't have any issues
> >> on getting stats on this period, it could just hook the DVBv5 stats logic
> >> at ops.read_status().
> >>
> >
> > Hmm, fepriv->delay missed that one, 3 seconds is far too long for lmedm04.
> 
> The only way change this is by using algo DVBFE_ALGO_HW using the 
> frontend ops tune.
> 
> As most frontends are using dvb_frontend_swzigzag it could be 
> implemented by patching the frontend ops tune code at the lock
> return in this function or in dvb_frontend_swzigzag_update_delay.

Well, if a different value is needed, it shouldn't be hard to add a
way to customize it, letting the demod to specify it, in the same way
as fe->ops.info.frequency_stepsize (and other similar demot properties)
are passed through the core.

Regards,
Mauro
