Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45852 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab2DFJ23 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 05:28:29 -0400
Message-ID: <4F7EB739.9070506@iki.fi>
Date: Fri, 06 Apr 2012 12:28:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] af9033: implement ber and ucb functions
References: <201204032259.43658.hfvogt@gmx.net> <4F7B79F0.7010707@iki.fi> <201204061034.56132.hfvogt@gmx.net>
In-Reply-To: <201204061034.56132.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.04.2012 11:34, Hans-Frieder Vogt wrote:
> Am Mittwoch, 4. April 2012 schrieb Antti Palosaari:
>> On 03.04.2012 23:59, Hans-Frieder Vogt wrote:
>>> af9033: implement read_ber and read_ucblocks functions.
>>>
>>> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>
>>
>> For my quick test UCB counter seems to reset every query. That is
>> violation of API. See http://www.kernel.org/doc/htmldocs/media.html>
>
> Indeed, interesting.
> I quickly checked the behaviour with a dibcom based stick (dib7000p
> demodulator) and the uncorrected block number reduces there as well. It seems,
> other demodulator drivers ignore this detail as well. But that's not meant to
> be an excuse.....

Some demod drivers follows API better than others. There is also some 
problems with current API which makes implementations in practise a 
little bit different than API.
At least all demod drivers I have written should follow API on case of 
UCB counter reset. For a quick test here zl10353 demod seems to follow 
also. You can likely found out those who are following API just looking 
whether those stores UCB counter value to state and then increase it 
every query.

>> Current API does not even define anymore units for BER and UCB, so those
>> calculations are not necessary. Anyhow, you can add some calculations if
>> you wish.

I tried to calculate what you were doing there but did not understood. 
Looks like those values read from register are packets and then after 
all you finally converted those as a bits. 204 * 8 looks like that, 204 
is common MPEG TS packet size including parity (without parity 188), and 
8 is bits in one byte. But why abort_cnt, which is UCB I think, goes 
multiplied to 8 * 8 = 64 (in order to convert to bits?)?

And the resulting value is some amount of bits, unit is?

And current IT9035 and AF9013 seems to contain very simply UCB & BER 
implementation.

regards
Antti
-- 
http://palosaari.fi/
