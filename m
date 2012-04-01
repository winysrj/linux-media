Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35467 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab2DAPAY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 11:00:24 -0400
Message-ID: <4F786D86.90404@iki.fi>
Date: Sun, 01 Apr 2012 18:00:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <201204011227.18739.hfvogt@gmx.net> <4F784AB3.9070507@iki.fi> <201204011631.47333.hfvogt@gmx.net>
In-Reply-To: <201204011631.47333.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.04.2012 17:31, Hans-Frieder Vogt wrote:
> Antti,
>
> I could provide the SNR, BER and UCB implementation (simply porting from my
> draft driver to yours).
> But I first need to implement the support for my AverMedia A867R device so that
> I am able to test the implementation. Therefore it could take a few hours
> (maybe until tomorrow).

Aaah, OK, but I was just working with SNR. I see your driver SNR was 
just register scaled to 0-0xffff whilst we nowadays prefer dBs , most 
commonly unit of 0.1 dB. So if thats OK for you I will finish that, and 
you can do BER and UCB, OK?

regards

Antti


>
> Regards,
> Hans-Frieder
>
> Am Sonntag, 1. April 2012 schrieb Antti Palosaari:
>> On 01.04.2012 13:27, Hans-Frieder Vogt wrote:
>>> nice work! I'll try to port the features that I have in my implementation
>>> of an af9035 driver into yours.
>>
>> You are welcome! But please tell me what you are doing to avoid
>> duplicate work. My today plan was to implement af9033 SNR, BER, UCB, but
>> if you would like to then say it for me and I will jump back to IT9135
>> support.
>>
>> regards
>> Antti
>
>
> Hans-Frieder Vogt                       e-mail: hfvogt<at>  gmx .dot. net


-- 
http://palosaari.fi/
