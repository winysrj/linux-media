Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52550 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab2GXWMd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 18:12:33 -0400
Message-ID: <500F1DC5.1000608@iki.fi>
Date: Wed, 25 Jul 2012 01:12:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: tda18271 driver power consumption
References: <500C5B9B.8000303@iki.fi> <CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com>
In-Reply-To: <CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2012 12:55 AM, Michael Krufky wrote:
> On Sun, Jul 22, 2012 at 3:59 PM, Antti Palosaari <crope@iki.fi> wrote:
>> Moi Michael,
>> I just realized tda18271 driver eats 160mA too much current after attach.
>> This means, there is power management bug.
>>
>> When I plug my nanoStick it eats total 240mA, after tda18271 sleep is called
>> it eats only 80mA total which is reasonable. If I use Digital Devices
>> tda18271c2dd driver it is total 110mA after attach, which is also quite OK.
>
> Thanks for the report -- I will take a look at it.
>
> ...patches are welcome, of course :-)

I suspect it does some tweaking on attach() and chip leaves powered (I 
saw demod debugs at calls I2C-gate control quite many times thus this 
suspicion). When chip is powered-up it is usually in some sleep state by 
default. Also, on attach() there should be no I/O unless very good 
reason. For example chip ID is allowed to read and download firmware in 
case it is really needed to continue - like for tuner communication.


What I found quickly testing few DVB USB sticks there seems to be very 
much power management problems... I am now waiting for new multimeter in 
order to make better measurements and likely return fixing these issues 
later.

regards
Antti

-- 
http://palosaari.fi/
