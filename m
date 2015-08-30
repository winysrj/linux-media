Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.aon.at ([195.3.96.77]:24261 "EHLO smtpout.aon.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbbH3PIA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 11:08:00 -0400
Message-ID: <55E31C40.6000409@a1.net>
Date: Sun, 30 Aug 2015 17:07:44 +0200
From: Johann Klammer <klammerj@a1.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: hverkuil@xs4all.nl, tvboxspy@gmail.com
Subject: Re: [BUG] STV0299 has bogus CAN_INVERSION_AUTO flag
References: <55DB3608.5010906@a1.net> <55E2D2A8.5010607@gmail.com>
In-Reply-To: <55E2D2A8.5010607@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 11:53 AM, Malcolm Priestley wrote:
> On 24/08/15 16:19, Johann Klammer wrote:
>> from gdb dump:
>> [...]
>> info = {
>>        name = "ST STV0299 DVB-S", '\000' <repeats 111 times>, type = FE_QPSK,
>>        frequency_min = 950000, frequency_max = 2150000,
>>        frequency_stepsize = 125, frequency_tolerance = 0,
>>        symbol_rate_min = 1000000, symbol_rate_max = 45000000,
>>        symbol_rate_tolerance = 500, notifier_delay = 0,
>>        caps = (FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO | FE_CAN_QPSK)},
>> [...]
>>
>> when tuning:
>> [...]
> Hi
> ..
>> [331020.207352] stv0299 does not support auto-inversion
>> [331020.507480] stv0299 does not support auto-inversion
>> [331020.807610] stv0299 does not support auto-inversion
>> [331021.107747] stv0299 does not support auto-inversion
>> [...]
>> (but how the heck should I know?)
> 
> I am using the stv0299 with no problems at all, the code hasn't changed much in years. I am using linux 4.2-rc6
> boot/vmlinuz-4.1.0-1-586

Something must have changed. I updated kernel and got those messages.
I did not get then before. The vmlinuz.old 
points to: boot/vmlinuz-3.14.15
vmlinuz points to: boot/vmlinuz-4.1.0-1-586
(debian testing binary .deb)

> You shouldn't be getting that message as dvb core does the auto inversion for the driver.
It may have been exposed by trying oneshot tuning mode... not sure... 
I had to try that 'coz I only got about 50% success on any tuning attempt on this card 
(has always been like that). 
got rid of that, it tunes reliably now if I set INVERSION to 0. 
and retry a few times instead of uning once, then polling for LOCK
(which often won't happen). 
It's entirely possible the bug was in there for a while. 
> 
> I looked through the code and can't find any fault.
> 
> 
They explicitly set the CAN_INVERSION_AUTO flag in the FE_GET_INFO ioctl, 
then fail -EINVAL when you try to tune with INVERSION_AUTO. 
At least that's where the error message comes from. 


> Regards
> 
> 
> Malcolm
> 
> 
> 
> 
> 
> 

