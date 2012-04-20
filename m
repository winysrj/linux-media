Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52565 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab2DTJro (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 05:47:44 -0400
Message-ID: <4F9130BB.8060107@iki.fi>
Date: Fri, 20 Apr 2012 12:47:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com>, <201204152353103757288@gmail.com> <201204201601166255937@gmail.com>
In-Reply-To: <201204201601166255937@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20.04.2012 11:01, nibble.max wrote:
> 2012-04-20 15:56:27 nibble.max@gmail.com
> At first time, I check it exist so try to patch it.
> But with new m88ds3103 features to add and ts2022 tuner include, find it is hard to do simply patch.
> It is better to create a new driver for maintain.
>> Hi Max,
>>
>> Em 15-04-2012 12:53, nibble.max escreveu:
>>> Montage m88ds3103 demodulator and ts2022 tuner driver.
>>
>> It was pointed to me that this device were already discussed on:
>>
>>    http://www.mail-archive.com/linux-media@vger.kernel.org/msg43109.html
>>
>> If m88ds3103 demod is similar enough to ds3000, it should just add the needed
>> bits at the existing driver, and not creating a new driver.
>>
>> Thanks,
>> Mauro

The main problem of these all existing and upcoming Montage DVB-S/S2 
drivers are those are not split originally correct as a tuner and demod 
and now it causes problems.

I really suspect it should be:
* single demod driver that supports both DS3000 and DS3103
* single tuner driver that supports both TS2020 and TS2022

And now what we have is 2 drivers that contains both tuner and demod. 
And a lot of same code. :-(

But it is almost impossible to split it correctly at that phase if you 
don't have both hardware combinations, DS3000/TS2020 and DS3103/TS2022. 
I think it is best to leave old DS3000 as it is and make new driver for 
DS3103 *and* TS2022. Maybe after that someone could add DS3000 support 
to new DS3103 driver and TS2020 support to new TS2022 driver. After that 
it is possible to remove old DS3000 driver.

And we should really consider make simple rule not to accept any driver 
which is not split as logical parts: USB/PCI-interface + demodulator + 
tuner.

regards
Antti
-- 
http://palosaari.fi/
