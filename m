Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KiQlC-0002Tx-Ny
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 11:34:16 +0200
Message-ID: <48DA098F.1030803@gmail.com>
Date: Wed, 24 Sep 2008 13:34:07 +0400
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

You can add in a field for diversity in the relevant delivery system
data structure (in frontend.h) for it to be handled by the application
optionally, that shouldn't be an issue as far as i can see.


> 2) My vote for S2API is final.
> 
> It is final, because the S2API is mainly affecting
> include/linux/dvb/frontend.h to add user-API support for new standards.
> I prefer the user-API of S2API over the one of multiproto because of 1).
> 


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
