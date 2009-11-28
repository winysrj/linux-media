Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:35959 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbZK1Lp1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 06:45:27 -0500
Message-ID: <4B110D58.40304@crans.ens-cachan.fr>
Date: Sat, 28 Nov 2009 12:45:28 +0100
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
CC: linux-media@vger.kernel.org, Benedict bdc091 <bdc091@gmail.com>
Subject: Re: how to get a registered adapter name
References: <746d58780909140842o8952bf1g8f7851eee9ec0093@mail.gmail.com> <4B0FDD66.9090903@crans.org> <200911271856.48877.zzam@gentoo.org>
In-Reply-To: <200911271856.48877.zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Matthias Schwarzott a écrit :
> On Freitag, 27. November 2009, Brice Dubost wrote:
>> Benedict bdc091 wrote:
>>> Hi list,
>>>
>>> I'd like to enumerate connected DVB devices from my softawre, based on
>>> DVB API V3.
> 
>>> So, I tried to figure out a way to get "ASUS My Cinema U3000 Mini DVBT
>>> Tuner" string from adapter, instead of "DiBcom 7000PC" from adapter's
>>> frontend...
>>> Unsuccefully so far.
>>>
>>> Any suggestions?
>> Hello,
>>
>> I have the same issue, I look a bit to the code of the DVB drivers, it
>> seems not obvious to recover this name as it is written now
>>
>> It is stored in the "struct dvb_adapter". and printed by
>> dvb_register_adapter, but doesn't seems to be available by other functions
>>
> 
> I think putting it somewhere into sysfs is a good idea (along with frontend 
> name).
> Best is to move all dvb sysfs-devices into a per adapter subdirectory.
> 

Hello

Is there already parts of the DVB code that use explicitely sysfs ?

I pehraps missed something, but it seems that everything in sysfs
concerning DVB is coming from the subsystems (PCI, or USB) or the
modules parameters but no DVB wide information

Am I wrong ?

Is there a reason for this ?



-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?
