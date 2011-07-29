Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38632 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061Ab1G2NDo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 09:03:44 -0400
Message-ID: <4E32AFAE.6020000@iki.fi>
Date: Fri, 29 Jul 2011 16:03:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org,
	Benjamin Larsson <benjamin@southpole.se>
Subject: Re: Trying to support for HAUPPAUGE HVR-930C
References: <CAKdnbx5DQe+c1+ZD6tEJqgSfv6CRV18s2YGv=Z3cOT=wEOyF7g@mail.gmail.com> <4E31526F.3060608@southpole.se> <CAKdnbx6O8JgMM37e28q1g9dt=AdJpAAjWHqxBnTXHZrcyBMKyQ@mail.gmail.com>
In-Reply-To: <CAKdnbx6O8JgMM37e28q1g9dt=AdJpAAjWHqxBnTXHZrcyBMKyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/29/2011 02:15 PM, Eddi De Pieri wrote:
> 2011/7/28 Benjamin Larsson <benjamin@southpole.se>:
>> 0x82 is the address of the chip handling the analog signals(?) Micronas
>> AVF 4910BA1 maybe.
> 
> I don't have the schematic of hauppauge card, so I can't say you if
> 082 is the AVF 4910

Rather few Linux devels have those but generally it is rather easy to guess. Just look addresses from sniff, then you have driver working you can read and write to chip and try to see what happens.

>> I'm not sure I understand the I2C addressing but my tuner is at 0xc2 and
>> the demod at 0x52.
> 
> I hate binary operation however if you shift the address you should
> get same value...
> 0x52 = 0x29 << 1
> 0x29 = 0x52 >> 1

I2C uses 7 bit addressing and thus 0x29 is correct. Many times address like 0x52 is called as 8 bit I2C address even in chip documents. Anyhow, 0x29 is correct, also (0x52 >> 1) can be used.

I encourage to use

.i2c_addr = 0x29; /* 0x52 >> 1 */

to make clear which is 8 bit since 8bit is almost always seen in usb logs.

regards
Antti

-- 
http://palosaari.fi/
