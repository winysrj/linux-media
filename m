Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1L4tZD-0006qa-PY
	for linux-dvb@linuxtv.org; Tue, 25 Nov 2008 09:46:46 +0100
Received: from webmail.xs4all.nl (dovemail10.xs4all.nl [194.109.26.12])
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id mAP8kdtH015493
	for <linux-dvb@linuxtv.org>; Tue, 25 Nov 2008 09:46:39 +0100 (CET)
	(envelope-from n.wagenaar@xs4all.nl)
Message-ID: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>
Date: Tue, 25 Nov 2008 09:46:39 +0100 (CET)
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
Reply-To: n.wagenaar@xs4all.nl
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Op Ma, 24 november, 2008 20:33, schreef Manu Abraham:
> Klaus Schmidinger wrote:
>> On 24.11.2008 16:55, Niels Wagenaar wrote:
>>> ...
>>> For the time being I have only two options which will work without any
>>> additional patching in S2API:
>>>
>>> - Let the user set this as an option
>>> - Use my VUP (very ugly patch) by checking the deliverystem for the
>>> string
>>> "DVBS2".
>>
>> Both are ugly workarounds and any reasonable API requiring them instead
>> of simply reporting the -S2 capability of a device should
>> be ashamed, go home and do its homework.
>
> ACK
>

And still, I see many popular/free/commercial DVB software on the Windows
platform where you need to select the DVB-S2 option on the DVB-card. So I
wouldn't just throw away this option as an ugly work-around.

In fact, I would like to set the specific type for my DVB cards if I
could. So an override option is definately not a ugly work-around and for
several people this will not be problem.

But, the other option is definately a very ugly work-around. But then
again, it works ;)

>> For the time being I'll work with my suggested FE_CAN_2ND_GEN_MODULATION
>> patch - until somebody can suggest a different way of doing this
>> (without
>> parsing strings or requiring the user to do it).
>
> ACK.
>
> That is a saner way of doing it rather than anything else, as it stands.
>
> Anyway, we won't be seeing professional device support as it stands with
> the current API anytime soon, so as it stands the better alternative is
> thus.
>
> But it would be nice to have something shorter: say FE_IS_2G or
> something that way, for the minimal typing.
>

I disagree on both of the proposals. Add an other flag is indeed the way
(I ACK that), but not a general one like you both proposed. When DVB-T2
(or DVB-S3 or DVB-C2 or whatever new enhancement of past DVB standards)
becomes mainstream we get the exact same discussion again.

IMHO, an non-general flag like FE_CAN_DVBT, FE_CAN_DVBS, FE_CAN_DVBS2,
FE_CAN_DVBC, etc would be more clearer. Since it's an DVB standard, it
must support certain modulation types, etc. So if the driver set its
frontendtype to FE_CAN_DVBT, you know for sure what tuning types it
supports.

But it al depends if people want to add this in the v4l driver also. If
they don't, it doesn't matter which proposal or patch makes it. And for
that a manual override or setting would become very handy.

> Regards,
> Manu
>

Look, I'm not an developer perse and you can ignore what I just wrote. But
my logic tells me that an manual override or a non-general FE_CAN flag for
the current DVB standards is a very clean sollution. Just my =80 0,02.

Regards,

Niels Wagenaar



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
