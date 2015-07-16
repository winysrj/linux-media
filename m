Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52279 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbbGPHNU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 03:13:20 -0400
From: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 2/9] v4l2: add RF gain control
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1433592188-31748-1-git-send-email-crope@iki.fi>
 <1433592188-31748-2-git-send-email-crope@iki.fi> <55755A6A.9080300@xs4all.nl>
Message-ID: <55A7598D.9050004@iki.fi>
Date: Thu, 16 Jul 2015 10:13:17 +0300
MIME-Version: 1.0
In-Reply-To: <55755A6A.9080300@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2015 12:03 PM, Hans Verkuil wrote:
> On 06/06/2015 02:03 PM, Antti Palosaari wrote:
>> Add new RF tuner gain control named RF gain. That is aimed for
>> external LNA (amplifier) chip just right after antenna connector.
>
> I don't follow. Do you mean:
>
> This feeds into the external LNA...
>
> But if that's the case, then the LNA chip isn't right after the antenna connector,
> since there is a RF amplified in between.

On that case, there is amplifier between antenna and tuner chip. And I 
named it as a RF gain. It is quite same thing than LNA gain, but I would 
call LNA gain as a "RF gain" inside the tuner chip - integrated into 
tuner chip. These terms are not 100% established as LNA gain and RF gain 
are considered as a same thing very often.

The fact is that almost every silicon tuner nowadays has integrated 
RF/LNA amplifier, but there is devices having still separate amplifier 
between tuner and antenna. For DVB side there is multiple such devices, 
for example PCTV 290e and PCTV 292. HackRF SDR has separate RF amplifier 
and multiple other amplifiers.

So all in all, I needed second "LNA/RF" gain control and as LNA gain was 
already defined, I defined another as a RF gain.


  RF in   +----+     +-----+     +-------+     +----+  IF out
-------> | RF | --> | LNA | --> | Mixer | --> | IF | -------->
          +----+     +-----+     +-------+     +----+

Those boxes (RF/LNA/Mixer/IF) are gain controls and signal travels in 
order shown from gain to gain. In real life there is usually even more 
gains withing gain stage, eg. Mixer gain stage could contain 3 different 
amplifiers.


RF in = antenna input
IF out = connected to ADC (demod)


Hope the RF gain / LNA gain documentation is now a bit better.


regards
Antti

-- 
http://palosaari.fi/
