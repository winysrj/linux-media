Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:50313 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbLUKIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 05:08:00 -0500
Subject: Re: [PATCH 2/3] mn88472: add work around for failing firmware loading
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Olli Salonen <olli.salonen@iki.fi>
References: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
 <1448763016-10527-2-git-send-email-benjamin@southpole.se>
 <56776983.8060905@iki.fi>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <5677CF7D.4060304@southpole.se>
Date: Mon, 21 Dec 2015 11:07:57 +0100
MIME-Version: 1.0
In-Reply-To: <56776983.8060905@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/21/2015 03:52 AM, Antti Palosaari wrote:
> Hello
> I am not sure if problem is I2C adapter/bus or that demodulator I2C
> slave. If it is demod, then that workaround is correct place, but if it
> is not, then that is wrong and I2C adapter repeating logic should be used.
>
> I did some testing again... Loading mn88472 firmware 1000 times, it failed:
> 61 times RC polling disabled
> 68 times RC polling enabled
> 83 times RC polling enabled, but repeated failed message due to that patch

At least this confirms there is an issue.

>
> I don't want apply that patch until I find some time myself to examine
> that problem - or someone else does some study to point out whats wrong.
> There is many things to test in order to get better understanding.
>
> regards
> Antti

I do have other hardware with with a mn88472 demod on it. A CX23102 
bridge and a dibcom (Xbox one tuner). I think that running the same test 
on those hardware will tell where the issue is.

I know that Olli have worked on the Xbox one tuner, do you have any 
support patches that could help testing this? And did you observe any 
issues with the mn88472 demod when working on the Xbox one tuner ?

I am quite sure that I saw this on the mn88473 version of this hardware 
also. I just haven't had the time to test it. But I will postpone that 
until the tests on the other bridges are done.

MvH
Benjamin Larsson
