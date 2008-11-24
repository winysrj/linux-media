Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@makhutov.org>) id 1L4d73-0001QW-Bp
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 16:12:34 +0100
Message-ID: <492AC460.1050203@makhutov.org>
Date: Mon, 24 Nov 2008 16:12:32 +0100
From: Artem Makhutov <artem@makhutov.org>
MIME-Version: 1.0
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
	<492A6E9B.7030906@cadsoft.de>
In-Reply-To: <492A6E9B.7030906@cadsoft.de>
Cc: linux-dvb@linuxtv.org
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

Hi,

Klaus Schmidinger schrieb:
> On 24.11.2008 08:12, Artem Makhutov wrote:
>> Hello,
>>
>> Klaus Schmidinger schrieb:
>>> The attached patch adds a capability flag that allows an application
>>> to determine whether a particular device can handle "second generation
>>> modulation" transponders. This is necessary in order for applications
>>> to be able to decide which device to use for a given channel in
>>> a multi device environment, where DVB-S and DVB-S2 devices are mixed.
>>>
>>> It is assumed that a device capable of handling "second generation
>>> modulation" can implicitly handle "first generation modulation".
>>> The flag is not named anything with DVBS2 in order to allow its
>>> use with future DVBT2 devices as well (should they ever come).
>>>
>>> Signed-off by: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
>> Wouldn't it be better to add something like this:
>>
>> FE_CAN_8PSK
>> FE_CAN_16APSK
>> FE_CAN_32APSK
>>
>> or
>>
>> FE_CAN_DVBS2
>>
>> Instead of FE_CAN_2ND_GEN_MODULATION ? It is too generic for me.
> 
> Well, it's bad enough that we have to "guess" which kind of
> delivery system it is by looking at feinfo.type. If it's FE_QPSK
> then it's DVB-S (or DVB-S2), if it's FE_OFDM then it's DVB-T etc.,
> etc. The "multiproto" API had this cleaned up and introduced a
> clean way of finding out the delivery systems(!) a particular device
> can handle. Unfortunately, as we all know, this approach has been
> dismissed.
> 
> Using some additional flags for "guessing" whether it's DVB-S2
> doesn't seem like a clean solution to me. Why not simply state
> the obvious? After all, the DVB standard for DVB-S2 speaks of
> "second generation modulation", that's why I named this flag
> that way. And since S2API can only handle a single delivery system
> at a time (as opposed to multiproto, where the delivery systems
> were flags, so a device could support several of them), it
> somehow made sense to me to have a flag that could later also
> be used for "second generation DVB-T" devices.
> 
> But I don't want to start another political fight here. All I need
> is a way to determine whether or not a device supports DVB-S2.
> If the commonly agreed on way to do this is to guess it by
> looking at FE_CAN_xyPSK capability flags, so be it. However, so
> far none of the "experts" cared about answering my initial
> question "How to determine DVB-S2 capability in S2API?", so
> I guessed the only way to get something to work was doing something
> about it ;-)

I fully understand what you mean. I would also like to adress the
remarks of Berry:

http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030539.html

So here is an other proposal for this:

typedef enum fe_type {
	FE_QPSK,
	FE_QAM,
	FE_OFDM,
	FE_ATSC,
	FE_DVBS,
	FE_DVBS2,
	FE_DVBT,
	FE_DVBT2,
	[...]
} fe_type_t;


typedef enum fe_caps {
	FE_IS_STUPID			= 0,
	FE_CAN_INVERSION_AUTO		= 0x1,
	FE_CAN_FEC_1_2			= 0x2,
	FE_CAN_FEC_2_3			= 0x4,
	FE_CAN_FEC_3_4			= 0x8,
	FE_CAN_FEC_4_5			= 0x10,
	FE_CAN_FEC_5_6			= 0x20,
	FE_CAN_FEC_6_7			= 0x40,
	FE_CAN_FEC_7_8			= 0x80,
	FE_CAN_FEC_8_9			= 0x100,
	FE_CAN_FEC_AUTO			= 0x200,
	FE_CAN_QPSK			= 0x400,
	FE_CAN_QAM_16			= 0x800,
	FE_CAN_QAM_32			= 0x1000,
	FE_CAN_QAM_64			= 0x2000,
	FE_CAN_QAM_128			= 0x4000,
	FE_CAN_QAM_256			= 0x8000,
	FE_CAN_QAM_AUTO			= 0x10000,
	FE_CAN_TRANSMISSION_MODE_AUTO	= 0x20000,
	FE_CAN_BANDWIDTH_AUTO		= 0x40000,
	FE_CAN_GUARD_INTERVAL_AUTO	= 0x80000,
	FE_CAN_HIERARCHY_AUTO		= 0x100000,
	FE_CAN_8VSB			= 0x200000,
	FE_CAN_16VSB			= 0x400000,
	FE_HAS_EXTENDED_CAPS		= 0x800000,
	FE_NEEDS_BENDING		= 0x20000000,
	FE_CAN_RECOVER			= 0x40000000,
	FE_CAN_MUTE_TS			= 0x80000000,
	FE_CAN_8PSK			= 0x100000000,
	FE_CAN_16APSK			= 0x200000000,
	FE_CAN_32APSK			= 0x400000000,
	[...]
} fe_caps_t;

Here we can define the frontend type and check if it is DVB-S or DVB-S2
or whatever and also define the modulations that the frontend is capable
to handle (in case a device won't work with the "professional"
modulations like 16APSK).

Applications like VDR can check the fe_type flags, and applications that
require more info could check fe_caps.

I am not sure about this all, and I would like to see some comments from
some people that are more familiar it. Specially changing fe_type looks
like it will break the binary compatibility, so maybe it would be better
to define a new enum for this flags...

Regards, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
