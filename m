Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47209 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1GRXo6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 19:44:58 -0400
Message-ID: <4E24C576.40102@iki.fi>
Date: Tue, 19 Jul 2011 02:44:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
References: <201106070205.08118.jareguero@telefonica.net> <201107142200.52970.jareguero@telefonica.net> <4E249779.4000503@iki.fi> <201107190100.16802.jareguero@telefonica.net>
In-Reply-To: <201107190100.16802.jareguero@telefonica.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2011 02:00 AM, Jose Alberto Reguero wrote:
> On Lunes, 18 de Julio de 2011 22:28:41 Antti Palosaari escribió:
>> Hello
>> I did some review for this since I was interested of adding MFE for
>> Anysee driver which is rather similar (dvb-usb-framework).
>>
>> I found this patch have rather major issue(s) which should be fixed
>> properly.
>>
>> * it does not compile
>> drivers/media/dvb/dvb-usb/dvb-usb.h:24:21: fatal error: dvb-pll.h: No
>> such file or directory
>
> Perhaps you need to add:
> -Idrivers/media/dvb/frontends/
> in:
> drivers/media/dvb/frontends/Makefile
> I compile the driver with:
> git://linuxtv.org/mchehab/new_build.git
> and I not have this problem.

Maybe, I was running latest Git. Not big issue.

>> * it puts USB-bridge functionality to the frontend driver
>>
>> * 1st FE, TDA10023, is passed as pointer inside config to 2nd FE
>> TDA10048. Much of glue sleep, i2c etc, those calls are wrapped back to
>> to 1st FE...
>>
>> * no exclusive locking between MFEs. What happens if both are accessed
>> same time?
>>
>>
>> Almost all those are somehow chained to same issue, few calls to 2nd FE
>> are wrapped to 1st FE. Maybe IOCTL override callback could help if those
>> are really needed.
>
> There are two problems:
>
> First, the two frontends (tda10048 and tda10023)  use tda10023 i2c gate to
> talk with the tuner.

Very easy to implement correctly. Attach tda10023 first and after that 
tda10048. Override tda10048 .i2c_gate_ctrl() with tda10023 
.i2c_gate_ctrl() immediately after tda10048 attach inside ttusb2.c. Now 
you have both demods (FEs) .i2c_gate_ctrl() which will control 
physically tda10023 I2C-gate as tuner is behind it.

> The second is that with dvb-usb, there is only one frontend, and if you wake
> up the second frontend, the adapter is not wake up. That can be avoided the
> way I do in the patch, or mantaining the adapter alwais on.

I think that could be also avoided similarly overriding demod callbacks 
and adding some more logic inside ttusb2.c.

Proper fix that later problem is surely correct MFE support for 
DVB-USB-framework. I am now looking for it, lets see how difficult it 
will be.


regards
Antti


-- 
http://palosaari.fi/
