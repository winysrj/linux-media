Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44798 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab1KIUlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2011 15:41:40 -0500
Received: by wyh15 with SMTP id 15so2024320wyh.19
        for <linux-media@vger.kernel.org>; Wed, 09 Nov 2011 12:41:39 -0800 (PST)
Message-ID: <4EBAE577.5090603@gmail.com>
Date: Wed, 09 Nov 2011 20:41:27 +0000
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [RFC 1/2] dvb-core: add generic helper function for I2C register
References: <4EB9C13A.2060707@iki.fi> <4EBA4E3D.80105@redhat.com> <4EBA58E0.8080704@iki.fi> <20111109115204.401a8aa5@endymion.delvare>
In-Reply-To: <20111109115204.401a8aa5@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/11 10:52, Jean Delvare wrote:
> On Wed, 09 Nov 2011 12:41:36 +0200, Antti Palosaari wrote:
>> On 11/09/2011 11:56 AM, Mauro Carvalho Chehab wrote:
>>> Due to the way I2C locks are bound, doing something like the above and something like:
>>>
>>>       struct i2c_msg msg[2] = {
>>>           {
>>>               .addr = i2c_cfg->addr,
>>>               .flags = 0,
>>>               .buf = buf,
>>>           },
>>>           {
>>>               .addr = i2c_cfg->addr,
>>>               .flags = 0,
>>>               .buf = buf2,
>>>           }
>>>
>>>       };
>>>
>>>       ret = i2c_transfer(i2c_cfg->adapter, msg, 2);
>>>
>>> Produces a different result. In the latter case, I2C core avoids having any other
>>> transaction in the middle of the 2 messages.
>>
>> In my understanding adding more messages than one means those should be
>> handled as one I2C transaction using REPEATED START.
>> I see one big problem here, it is our adapters. I think again, for the
>> experience I have, most of our I2C-adapters can do only 3 different
>> types of I2C xfers;
>> * I2C write
>> * I2C write + I2C read (combined with REPEATED START)
>> * I2C read (I suspect many adapters does not support that)
>> That means, I2C REPEATED writes  are not possible.
>
> Also, some adapters _or slaves_ won't support more than one repeated
> start in a given transaction, so splitting block reads in continuous
> chunks won't always work either. Which makes some sense if you think
> about it: if both the slave and the controller supported larger blocks
> then there would be no need to split the transfer into multiple
> messages in the first place.
>

Yes, I can immediately think of the stv0288 which can receive up to 108 
bytes continuous write of its register map, but using the lme2510c 
controller won't write more than 16, probably beyond the limit of the 
firmwares buffer.

I think mostly, you are at the mercy of the controller firmware and not 
really the host i2c controller abilities.

Regards

Malcolm
