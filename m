Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KiRZ4-0005ZL-LB
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 12:25:47 +0200
Message-ID: <48DA15A2.40109@gmail.com>
Date: Wed, 24 Sep 2008 14:25:38 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<48D9F6F3.8090501@gmail.com>
	<alpine.LRH.1.10.0809241051170.12985@pub3.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0809241051170.12985@pub3.ifh.de>
Cc: DVB ML <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
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

Patrick Boettcher wrote:
> Manu,
> 
> On Wed, 24 Sep 2008, Manu Abraham wrote:
> 
>> Mauro Carvalho Chehab wrote:
>> [..]
>>> The main arguments in favor of S2API over Multiproto are:
>>>
>>
>> [..]
>>
>>>     - Capability of allowing improvements even on the existing
>>> standards,
>>>       like allowing diversity control that starts to appear on newer DVB
>>>       devices.
>>
>>
>> I just heard from Patrick, what he meant by this at the meeting and the
>> reason why he voted for S2API, due to a fact that he was convinced
>> incorrectly. Multiproto _already_has_ this implementation, while it is
>> non-existant in S2API.
> 
> In order to not have people getting me wrong here, I'm stating now in
> public:
> 
> 1) I like the idea of having diversity optionally controlled by the
> application.
> 
> 2) My vote for S2API is final.
> 
> It is final, because the S2API is mainly affecting
> include/linux/dvb/frontend.h to add user-API support for new standards.
> I prefer the user-API of S2API over the one of multiproto because of 1).

After adding in diversity to frontend.h,

Would you prefer to update the diversity related event on the event list
as well ?


> All the other things around multiproto are dvb-core/dvb_frontend internal.
> They have no relation with the user-interface. This I understood during
> the BOF, the microconf and the numberless talks we had around LPC.
> 
> Manu, it would be extremely good to have your modifications of
> dvb-core/dvb_frontend within the 4 weeks schedule in order to have the
> maximum number of hardware supported by that time. If you do not have
> the time to do that right now, I'm sure people are willing to help.
> 
> However - we can always change dvb_frontend/dvb-core internals at any
> time without breaking the user-interface.


Since the very same can be achieved with multiproto without breaking the
user interface and without porting it to anything else, it makes much
sense to simply add in a field for diversity into the multiproto tree,
is it not ?


Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
