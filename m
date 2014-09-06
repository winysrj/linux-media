Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59550 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaIFCKF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Sep 2014 22:10:05 -0400
Message-ID: <540A6CF3.4070401@iki.fi>
Date: Sat, 06 Sep 2014 05:09:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org,
	m.chehab@samsung.com
Subject: Re: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend
 for APIv5
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-2-git-send-email-tskd08@gmail.com> <53FE1EF5.5060007@iki.fi> <53FEF144.6060106@gmail.com> <53FFD1F0.9050306@iki.fi> <540059B5.8050100@gmail.com>
In-Reply-To: <540059B5.8050100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moro!

On 08/29/2014 01:45 PM, Akihiro TSUKADA wrote:
> moikka,
>
>> Start polling thread, which polls once per 2 sec or so, which reads RSSI
>> and writes value to struct dtv_frontend_properties. That it is, in my
>> understanding. Same for all those DVBv5 stats. Mauro knows better as he
>> designed that functionality.
>
> I understand that RSSI property should be set directly in the tuner driver,
> but I'm afraid that creating a kthread just for updating RSSI would be
> overkill and complicate matters.
>
> Would you give me an advice? >> Mauro

Now I know that as I implement it. I added kthread and it works 
correctly, just I though it is aimed to work. In my case signal strength 
is reported by demod, not tuner, because there is some logic in firmware 
to calculate it.

Here is patches you would like to look as a example:

af9033: implement DVBv5 statistic for signal strength
https://patchwork.linuxtv.org/patch/25748/

af9033: implement DVBv5 statistic for CNR
https://patchwork.linuxtv.org/patch/25744/

af9033: implement DVBv5 stat block counters
https://patchwork.linuxtv.org/patch/25749/

af9033: implement DVBv5 post-Viterbi BER
https://patchwork.linuxtv.org/patch/25750/

regards
Antti

-- 
http://palosaari.fi/
