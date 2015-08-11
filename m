Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48835 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbHKPSn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 11:18:43 -0400
Subject: Re: [PATCH 09/12] tda10071: use jiffies when poll firmware status
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
 <1436414792-9716-9-git-send-email-crope@iki.fi>
 <20150811072055.55eeb0d4@recife.lan>
Cc: linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55CA124F.9080507@iki.fi>
Date: Tue, 11 Aug 2015 18:18:39 +0300
MIME-Version: 1.0
In-Reply-To: <20150811072055.55eeb0d4@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2015 01:20 PM, Mauro Carvalho Chehab wrote:
> Em Thu,  9 Jul 2015 07:06:29 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Use jiffies to set timeout for firmware command status polling.
>> It is more elegant solution than poll X times with sleep.

>>   	/* wait cmd execution terminate */
>> -	for (i = 1000, uitmp = 1; i && uitmp; i--) {
>> +	#define CMD_EXECUTE_TIMEOUT 30
>> +	timeout = jiffies + msecs_to_jiffies(CMD_EXECUTE_TIMEOUT);
>> +	for (uitmp = 1; !time_after(jiffies, timeout) && uitmp;) {
>>   		ret = regmap_read(dev->regmap, 0x1f, &uitmp);
>>   		if (ret)
>>   			goto error;
>> -
>> -		usleep_range(200, 5000);
>
> Hmm... removing the usleep() doesn't sound a good idea. You'll be
> flooding the I2C bus with read commands and spending CPU cycles
> for 30ms spending more power than the previous code. That doesn't
> sound more "elegant solution than poll X times with sleep" for me.
>
> So, I would keep the usleep_range() here and add a better
> comment on the patch description.

First of all, polling firmware ready status is very common for chips 
having firmware. And there is 2 ways to implement it:
1) poll N times in a loop using X sleep, timeout = N * X
2) poll in a loop using jiffies as a timeout

IMHO 2 is more elegant solution and I have started using it recently.

What you now propose is add some throttle in order to slow down polling 
interval to reduce I2C I/O. Yes sure less I/O is better, but downside is 
that it makes some unneeded extra delay to code path. Usually these sort 
firmware ready polling ends rather quickly, in a loop or two.

Sure it eats some extra CPU cycles, but I think extra control messages 
are about nothing compared to I/O used for data streaming.

Which kind of throttle delay you think is suitable for polling command 
status over I2C bus?

regards
Antti

-- 
http://palosaari.fi/
