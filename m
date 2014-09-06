Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49912 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaIFDei (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Sep 2014 23:34:38 -0400
Message-ID: <540A80C9.8040805@iki.fi>
Date: Sat, 06 Sep 2014 06:34:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi> <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi> <540059B5.8050100@gmail.com> <540A6CF3.4070401@iki.fi> <20140905235105.3ab6e7c4.m.chehab@samsung.com> <20140905235432.5eeab2a3.m.chehab@samsung.com> <540A7B09.2090300@iki.fi> <20140906001726.4929ba2f.m.chehab@samsung.com>
In-Reply-To: <20140906001726.4929ba2f.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2014 06:17 AM, Mauro Carvalho Chehab wrote:
> Em Sat, 06 Sep 2014 06:10:01 +0300
> Antti Palosaari <crope@iki.fi> escreveu:

>> ... I simply don't understand why you want hook that RF strength call
>> via demod? The frontend cache is shared between demod and tuner. We use
>> it for tuner driver as well demod driver. Let the tuner driver make RSSI
>> calculation independently without any unneeded relation to demod driver.
>
> Well, adding kthreads has a cost, with is a way higher than just
> calling a callback function.
>
> Also, it makes a way more complicated to implement several tasks.
>
> For example, devices with kthreads need to stop them during suspend,
> and restart them at resume time, or otherwise suspend and/or resume
> may not work.
>
> Also, the power consumption increases with kthread, as the CPU need
> to be periodically waken.
>
> I'm not saying we shouldn't use kthreads at driver level, but
> the best is to avoid when there are some other simpler ways of doing it.

And small reality check, how much you think one kthreads, that polls 
once per 2 second or so causes, in a case when you are *already 
streaming* 20-80 Mbit/sec data stream :) I think CPU does not need wake 
up to execute one thread as there is a lot of other interrupts happening 
in that use case anyway.

We have a remote controller which is polled often as 100ms and it 
happens even when device is "sleeping".

regards
Antti

-- 
http://palosaari.fi/
