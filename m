Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51847 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1GVLc7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 07:32:59 -0400
Message-ID: <4E295FE5.7040905@iki.fi>
Date: Fri, 22 Jul 2011 14:32:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
References: <201106070205.08118.jareguero@telefonica.net> <201107190100.16802.jareguero@telefonica.net> <4E24C576.40102@iki.fi> <201107191025.49662.jareguero@telefonica.net> <4E260E4A.2020707@iki.fi>
In-Reply-To: <4E260E4A.2020707@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Have you had to time test these?

And about I2C adapter, I don't see why changes are needed. As far as I 
understand it is already working with TDA10023 and you have done changes 
for TDA10048 support. I compared TDA10048 and TDA10023 I2C functions and 
those are ~similar. Both uses most typical access, for reg write {u8 
REG, u8 VAL} and for reg read {u8 REG}/{u8 VAL}.

regards
Antti


On 07/20/2011 02:07 AM, Antti Palosaari wrote:
> On 07/19/2011 11:25 AM, Jose Alberto Reguero wrote:
>> On Martes, 19 de Julio de 2011 01:44:54 Antti Palosaari escribió:
>>> On 07/19/2011 02:00 AM, Jose Alberto Reguero wrote:
>>>> On Lunes, 18 de Julio de 2011 22:28:41 Antti Palosaari escribió:
>
>>>> There are two problems:
>>>>
>>>> First, the two frontends (tda10048 and tda10023) use tda10023 i2c gate
>>>> to talk with the tuner.
>>>
>>> Very easy to implement correctly. Attach tda10023 first and after that
>>> tda10048. Override tda10048 .i2c_gate_ctrl() with tda10023
>>> .i2c_gate_ctrl() immediately after tda10048 attach inside ttusb2.c. Now
>>> you have both demods (FEs) .i2c_gate_ctrl() which will control
>>> physically tda10023 I2C-gate as tuner is behind it.
>>>
>>
>> I try that, but don't work. I get an oops. Because the i2c gate
>> function of
>> the tda10023 driver use:
>>
>> struct tda10023_state* state = fe->demodulator_priv;
>>
>> to get the i2c adress. When called from tda10048, don't work.
>>
>> Jose Alberto
>>
>>>> The second is that with dvb-usb, there is only one frontend, and if you
>>>> wake up the second frontend, the adapter is not wake up. That can be
>>>> avoided the way I do in the patch, or mantaining the adapter alwais on.
>>>
>>> I think that could be also avoided similarly overriding demod callbacks
>>> and adding some more logic inside ttusb2.c.
>>>
>>> Proper fix that later problem is surely correct MFE support for
>>> DVB-USB-framework. I am now looking for it, lets see how difficult it
>>> will be.
>
>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
>
> Test attached patches and try to fix if they are not working. Most
> likely not working since I don't have HW to test... I tested MFE parts
> using Anysee, so it should be working. I changed rather much your ttusb2
> and tda10048 patches, size reduced something like 50% or more. Still
> ttusb2 I2C-adapter changes made looks rather complex. Try to double
> check if those can be done easier. There is many drivers to look example
> from.
>
> DVB USB MFE is something like RFC. I know FE exclusive lock is missing,
> no need to mention that :) But other comments are welcome! I left three
> old "unneeded" pointers to struct dvb_usb_adapter to reduce changing all
> the drivers.
>
>
> regards
> Antti
>


-- 
http://palosaari.fi/
