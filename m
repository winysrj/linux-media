Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:52321 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbZJTULw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 16:11:52 -0400
Message-ID: <4ADE1985.1090300@crans.ens-cachan.fr>
Date: Tue, 20 Oct 2009 22:11:49 +0200
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, alex.betis@gmail.com
Subject: Re: S2API and DVB-T tuning [Solved]
References: <4AD30DFD.8080800@crans.ens-cachan.fr> <4AD3279A.6030907@crans.ens-cachan.fr>
In-Reply-To: <4AD3279A.6030907@crans.ens-cachan.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DUBOST Brice a écrit :
> DUBOST Brice a écrit :
>> Hello,
>>
>> I have some problems with DVB-T tuning under s2-api/DVB API 5
>>
>> To run these tests I use scan-s2-7effc68db255
>>
>> My machine runs the following kernel (uname -a)
>> Linux fixe_barcelone 2.6.31-13-generic #42-Ubuntu SMP Thu Oct 8 20:03:54
>> UTC 2009 x86_64 GNU/Linux
>>
>> And I own 3 DVB-T devices :
>> 1:
>> 01:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>> 	Subsystem: Technotrend Systemtechnik GmbH Device 1012
>> 	Flags: bus master, medium devsel, latency 64, IRQ 21
>> 	Memory at fa6ffc00 (32-bit, non-prefetchable) [size=512]
>> 	Kernel driver in use: budget_ci dvb
>> 	Kernel modules: budget-ci
>> 2:
>> Bus 001 Device 010: ID 2040:7070 Hauppauge
>>
>> 3:
>> Bus 001 Device 011: ID 07ca:a815 AVerMedia Technologies, Inc.
>>
>> All three devices tune well and work flawlessly with scan (dvb api v3)
>> But when I use scan-s2, only the AVerMedia is able to lock
>>
>> I use the dvb-t/es-Collserola as an initial tuning file.
>>
>> I thought the S2API shouldn't change the tuning behavior.
>>
>> I tried to search the Mailing list archives via google I unfortunately
>> found nothing. I'm sorry if this subject was discussed before.
>>
>> What can I do to investigate more on this issue ?
>>
> 
> Hello
> 
> One more information, if I change
> 
> 514000000 8MHz 2/3 AUTO QAM64 8k 1/4 NONE
> 
> by
> 
> 514000000 8MHz 2/3 AUTO AUTO 8k 1/4 NONE
> 
> it works with scan-s2
> 
> With "old" scan it works for both
> 
> Hope this will help to find the issue
> 


Hello

After playing a bit more with S2API, I understood that the S2API is
using DVB API v3 for DVB-T. So I investigated a bit more this issue.

The problem came from the fact that scan-s2 was not giving all the
parameters needed for DVB-T to the new API

By making scan-s2 setting the following parameters, it works
DTV_DELIVERY_SYSTEM
DTV_FREQUENCY
DTV_MODULATION
DTV_GUARD_INTERVAL
DTV_CODE_RATE_HP
DTV_CODE_RATE_LP
DTV_TRANSMISSION_MODE
DTV_HIERARCHY
DTV_BANDWIDTH_HZ


Problem solved :D

Best regards

-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?
