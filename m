Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout08.sul.t-online.de ([194.25.134.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JbMnH-0007oq-VX
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 22:22:56 +0100
Message-ID: <47DEE11F.6060301@t-online.de>
Date: Mon, 17 Mar 2008 22:22:39 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: timf <timf@iinet.net.au>
References: <1204893775.10536.4.camel@ubuntu> <47D1A65B.3080900@t-online.de>
	<1205480517.5913.8.camel@ubuntu>
In-Reply-To: <1205480517.5913.8.camel@ubuntu>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
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

Hi, Tim

timf schrieb:
> On Fri, 2008-03-07 at 21:32 +0100, Hartmut Hackmann wrote:
>> Hi, Tim
>>
>> timf schrieb:
>>> Hi Hartmut,
>>> I noticed you had a bit to do with implementing this card.
>>>
>>> With a fresh install of ubuntu 7.10 (kernel i386 2.6.22-14-generic),
>>> the card is auto recognised as: Kworld DVB-T 210 (card=114)
>>>
>>> However, tda1004 firmware does not load.
>>> Used download-firmware, placed dvb-fe-tda10046.fw
>>> into /lib/firmware/2.6.22-14-generic
>>>
>>> Rebooted.
>>>
>>> Now, again card is recognised, firmware recognised as version 20.
>>> Here is the strange part:
>>> - using dvb-utils scan, each time I run that I get a different result in
>>> channels.
>>> - I try to scan with Kaffeine - nothing
>>> - I try to scan with Me-tv - nothing
>>> - I try to scan with tvtime - all channels obtained ( no audio).
>>>
>>> Now, after reboot, if I first start tvtime (analog tv), view a channel,
>>> turn tvtime off, and then :
>>> - if I place a previously good channels.dvb in Kaffeine - it plays all
>>> channels.
>>> - if I place a previously good channels.conf in Me-tv - it plays all
>>> channels. 
>>>
>>> Would it be correct to say that the "switch" is not working for DVB
>>> after boot?
>>>
>>> I have studied the code, but I need your help to point me in the right
>>> direction.
>>>
>>> Thanks,
>>> Tim
>>>
>> Hermann reported something similar. I have an idea what the reason could
>> be. Please let me check.
>> Best regards
>>   Hartmut
> 
> Hi Hartmut,
> 
> Further to this, is the Remote Control meant to work for this card?
> 
<snip>
Looks like the Remote is not supported. I can't help here since i don't have access
to this card.


In my personal Repository:
  http://linuxtv.org/hg/~hhackmann/v4l-dvb/
the problems with the tuning code should be fixed.
Can you please give it a try?

Best Regards
  Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
