Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KuYF6-0003JV-SC
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 20:59:13 +0100
Message-ID: <49061D88.1040305@gmail.com>
Date: Mon, 27 Oct 2008 23:59:04 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <200810272023.23513.zzam@gentoo.org> <49061983.3070800@gmail.com>
	<200810272050.43535.zzam@gentoo.org>
In-Reply-To: <200810272050.43535.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] commit 9344:aa3a67b658e8 (DVB-Core update) breaks
	tuning of cx24123
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Matthias Schwarzott wrote:
> On Montag, 27. Oktober 2008, Manu Abraham wrote:
>> Hi Mathias,
>>
> Hi Manu!
> 
>> Matthias Schwarzott wrote:
>>> Hi Manu, hi Steven!
>>>
>>> It seems an update of dvb-core breaks tuning of cx24123.
>>> After updating to latest v4l-dvb the nova-s plus card just did no longer
>>> lock to any channel. So I bisected it, and found this commit:
>>>
>>> changeset:   9344:aa3a67b658e8
>>> parent:      9296:e2a8b9b9c294
>>> user:        Manu Abraham <manu@linuxtv.org>
>>> date:        Tue Oct 14 23:34:07 2008 +0400
>>> summary:     DVB-Core update
>>>
>>> http://linuxtv.org/hg/v4l-dvb/rev/aa3a67b658e8
>>>
>>> It basically did update the dvb-kernel-thread and enhanced the code using
>>> get_frontend_algo.
>>>
>>> The codepath when get_frontend_algo returns *_ALGO_HW stayed the same,
>>> only one line got removed: params = &fepriv->parameter
>>>
>>> Just re-adding that line made my card working again. Either this was
>>> lost, or the last two lines using "params" should also be converted to
>>> directly use "&fepriv->parameters".
>> True. In the port, the one line got missed out. Thanks for taking the
>> time to look at it.
>>
>> BTW, i don't see any reason why cx24123 should be using HW_ALGO as it is
>> a standard demodulator. When we have a dedicated microcontroller
>> employed to do that check, we might like to use HW_ALGO, since it would
>> simply handle it. Not in the case of standard demodulators. As an
>> example i could say cinergyT2, dst etc would be candidates for HW_ALGO,
>> where tuning is offloaded to a onboard microcontroller.
>>
> I dont have much insight in what these algo settings do. Only idea I have 
> about this is: cx24123 may not need software zigzag.

Ok, should be fine, if that's the case. software zigzag is one thing,
another is lock monitoring, ie: if LOCK fails, it should autotune by
itself; similar to FE_CAN_RECOVER.

Though it brings the disadvantge to the cx24123 driver that it will not
try to reacquire a LOCK when LOCK fails for some unreason such as a
signal dropuot etc, when using HW_ALGO: might cause not to regain a
LOCK, would be a side effect, if it is incapable of doing a hardware
based LOCK monitor.

> If that gives a larger gain in lock-speed, then mt312 may also be a candidate 
> for ALGO_HW as it can lock to signals not exactly centered to the IF.
> But I doubt, as that hw then should lock at the first try and not even trigger 
> zigzag steps.

I don't think the MT312 does support either of the mentioned. Or does it
? Didn't take the time to look at the datasheet.


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
