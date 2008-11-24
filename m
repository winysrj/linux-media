Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L4XOx-0002rJ-Mk
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 10:06:41 +0100
Received: from [192.168.1.71] (falcon.cadsoft.de [192.168.1.71])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mAO96ZXM003591
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 10:06:35 +0100
Message-ID: <492A6E9B.7030906@cadsoft.de>
Date: Mon, 24 Nov 2008 10:06:35 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
In-Reply-To: <492A53C4.5030509@makhutov.org>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

On 24.11.2008 08:12, Artem Makhutov wrote:
> Hello,
> 
> Klaus Schmidinger schrieb:
>> The attached patch adds a capability flag that allows an application
>> to determine whether a particular device can handle "second generation
>> modulation" transponders. This is necessary in order for applications
>> to be able to decide which device to use for a given channel in
>> a multi device environment, where DVB-S and DVB-S2 devices are mixed.
>>
>> It is assumed that a device capable of handling "second generation
>> modulation" can implicitly handle "first generation modulation".
>> The flag is not named anything with DVBS2 in order to allow its
>> use with future DVBT2 devices as well (should they ever come).
>>
>> Signed-off by: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
> 
> Wouldn't it be better to add something like this:
> 
> FE_CAN_8PSK
> FE_CAN_16APSK
> FE_CAN_32APSK
> 
> or
> 
> FE_CAN_DVBS2
> 
> Instead of FE_CAN_2ND_GEN_MODULATION ? It is too generic for me.

Well, it's bad enough that we have to "guess" which kind of
delivery system it is by looking at feinfo.type. If it's FE_QPSK
then it's DVB-S (or DVB-S2), if it's FE_OFDM then it's DVB-T etc.,
etc. The "multiproto" API had this cleaned up and introduced a
clean way of finding out the delivery systems(!) a particular device
can handle. Unfortunately, as we all know, this approach has been
dismissed.

Using some additional flags for "guessing" whether it's DVB-S2
doesn't seem like a clean solution to me. Why not simply state
the obvious? After all, the DVB standard for DVB-S2 speaks of
"second generation modulation", that's why I named this flag
that way. And since S2API can only handle a single delivery system
at a time (as opposed to multiproto, where the delivery systems
were flags, so a device could support several of them), it
somehow made sense to me to have a flag that could later also
be used for "second generation DVB-T" devices.

But I don't want to start another political fight here. All I need
is a way to determine whether or not a device supports DVB-S2.
If the commonly agreed on way to do this is to guess it by
looking at FE_CAN_xyPSK capability flags, so be it. However, so
far none of the "experts" cared about answering my initial
question "How to determine DVB-S2 capability in S2API?", so
I guessed the only way to get something to work was doing something
about it ;-)

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
