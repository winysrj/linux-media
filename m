Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L4trR-00081E-2R
	for linux-dvb@linuxtv.org; Tue, 25 Nov 2008 10:05:34 +0100
Received: from [192.168.1.71] (falcon.cadsoft.de [192.168.1.71])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mAP95Tv0022129
	for <linux-dvb@linuxtv.org>; Tue, 25 Nov 2008 10:05:29 +0100
Message-ID: <492BBFD9.50909@cadsoft.de>
Date: Tue, 25 Nov 2008 10:05:29 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>
In-Reply-To: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 25.11.2008 09:46, Niels Wagenaar wrote:
> Op Ma, 24 november, 2008 20:33, schreef Manu Abraham:
>> Klaus Schmidinger wrote:
>>> On 24.11.2008 16:55, Niels Wagenaar wrote:
>>>> ...
>>>> For the time being I have only two options which will work without any
>>>> additional patching in S2API:
>>>>
>>>> - Let the user set this as an option
>>>> - Use my VUP (very ugly patch) by checking the deliverystem for the
>>>> string
>>>> "DVBS2".
>>> Both are ugly workarounds and any reasonable API requiring them instead
>>> of simply reporting the -S2 capability of a device should
>>> be ashamed, go home and do its homework.
>> ACK
>>
> =

> And still, I see many popular/free/commercial DVB software on the Windows
> platform where you need to select the DVB-S2 option on the DVB-card. So I
> wouldn't just throw away this option as an ugly work-around.
> =

> In fact, I would like to set the specific type for my DVB cards if I
> could. So an override option is definately not a ugly work-around and for
> several people this will not be problem.
> =

> But, the other option is definately a very ugly work-around. But then
> again, it works ;)
> =

>>> For the time being I'll work with my suggested FE_CAN_2ND_GEN_MODULATION
>>> patch - until somebody can suggest a different way of doing this
>>> (without
>>> parsing strings or requiring the user to do it).
>> ACK.
>>
>> That is a saner way of doing it rather than anything else, as it stands.
>>
>> Anyway, we won't be seeing professional device support as it stands with
>> the current API anytime soon, so as it stands the better alternative is
>> thus.
>>
>> But it would be nice to have something shorter: say FE_IS_2G or
>> something that way, for the minimal typing.
>>
> =

> I disagree on both of the proposals. Add an other flag is indeed the way
> (I ACK that), but not a general one like you both proposed. When DVB-T2
> (or DVB-S3 or DVB-C2 or whatever new enhancement of past DVB standards)
> becomes mainstream we get the exact same discussion again.
> =

> IMHO, an non-general flag like FE_CAN_DVBT, FE_CAN_DVBS, FE_CAN_DVBS2,
> FE_CAN_DVBC, etc would be more clearer. Since it's an DVB standard, it
> must support certain modulation types, etc. So if the driver set its
> frontendtype to FE_CAN_DVBT, you know for sure what tuning types it
> supports.
> =

> But it al depends if people want to add this in the v4l driver also. If
> they don't, it doesn't matter which proposal or patch makes it. And for
> that a manual override or setting would become very handy.
> =

>> Regards,
>> Manu
>>
> =

> Look, I'm not an developer perse and you can ignore what I just wrote. But
> my logic tells me that an manual override or a non-general FE_CAN flag for
> the current DVB standards is a very clean sollution. Just my =80 0,02.

I find it a completely unacceptable thing to have the user tell
the application what type of DVB devices the hardware provides.
This is pretty much the first and simplest thing the *DRIVER* has
to do. If a driver (API) doesn't allow this in a clean way, it's
worthless!

I don't care if this is a specific or a general flag, as long as
it allows the application to clearly find out the kind of hardware
that's available. It leaves me dumbfounded that this is suddenly
such a big problem...

If my proposal is not acceptable, then please can one of the S2API
experts come up with a solution that better fits the S2API way of
thinking?

<conspiracy_theory><sarcasm>
Or is the S2API already "dead", and it's sole purpose was to
prevent "multiproto" to make its way into the kernel? And now that
this has been achieved, nodody really cares whether it can be used
in real life?
</sarcasm></conspiracy_theory>

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
