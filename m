Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KiQQH-0000vR-Qd
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 11:12:38 +0200
Date: Wed, 24 Sep 2008 11:11:54 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <48D9F6F3.8090501@gmail.com>
Message-ID: <alpine.LRH.1.10.0809241051170.12985@pub3.ifh.de>
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<48D9F6F3.8090501@gmail.com>
MIME-Version: 1.0
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

Manu,

On Wed, 24 Sep 2008, Manu Abraham wrote:

> Mauro Carvalho Chehab wrote:
> [..]
>> The main arguments in favor of S2API over Multiproto are:
>>
>
> [..]
>
>> 	- Capability of allowing improvements even on the existing standards,
>> 	  like allowing diversity control that starts to appear on newer DVB
>> 	  devices.
>
>
> I just heard from Patrick, what he meant by this at the meeting and the
> reason why he voted for S2API, due to a fact that he was convinced
> incorrectly. Multiproto _already_has_ this implementation, while it is
> non-existant in S2API.

In order to not have people getting me wrong here, I'm stating now in 
public:

1) I like the idea of having diversity optionally controlled by the 
application.

2) My vote for S2API is final.

It is final, because the S2API is mainly affecting 
include/linux/dvb/frontend.h to add user-API support for new standards. I 
prefer the user-API of S2API over the one of multiproto because of 1).

All the other things around multiproto are dvb-core/dvb_frontend internal.
They have no relation with the user-interface. This I understood during 
the BOF, the microconf and the numberless talks we had around LPC.

Manu, it would be extremely good to have your modifications of 
dvb-core/dvb_frontend within the 4 weeks schedule in order to have the 
maximum number of hardware supported by that time. If you do not have the 
time to do that right now, I'm sure people are willing to help.

However - we can always change dvb_frontend/dvb-core internals at any time 
without breaking the user-interface.

best regards,
Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
