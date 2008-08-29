Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KZCEe-0006wW-Ey
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 00:14:31 +0200
Received: by fg-out-1718.google.com with SMTP id e21so653158fga.25
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 15:14:25 -0700 (PDT)
Message-ID: <37219a840808291514o76704d60t63986edf391e699f@mail.gmail.com>
Date: Fri, 29 Aug 2008 18:14:25 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Tim Lucas" <lucastim@gmail.com>
In-Reply-To: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500
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

2008/8/29 Tim Lucas <lucastim@gmail.com>:
> Mijhail Moreyra wrote:
>> Steven Toth wrote:
>>> Mijhail Moreyra wrote:
>>>> Steven Toth wrote:
>>>>> Mijhail,
>>>>>
>>>>> http://linuxtv.org/hg/~stoth/cx23885-audio
>>>>>
>>>>> This tree contains your patch with some minor whitespace cleanups
>>>>> and fixes for HUNK related merge issues due to the patch wrapping at
>>>>> 80 cols.
>>>>>
>>>>> Please build this tree and retest in your environment to ensure I
>>>>> did not break anything. Does this tree still work OK for you?
>>>>>
>>>>> After this I will apply some other minor cleanups then invite a few
>>>>> other HVR1500 owners to begin testing.
>>>>>
>>>>> Thanks again.
>>>>>
>>>>> Regards,
>>>>>
>>>>> Steve
>>>>
>>>> Hi, sorry for the delay.
>>>>
>>>> I've tested the http://linuxtv.org/hg/~stoth/cx23885-audio tree and
>>>> it doesn't work well.
>>>>
>>>> You seem to have removed a piece from my patch that avoids some register
>>>> modification in cx25840-core.c:cx23885_
> initialize()
>>>>
>>>> -       cx25840_write(client, 0x2, 0x76);
>>>> +       if (state->rev != 0x0000) /* FIXME: How to detect the bridge
>>>> type ??? */
>>>> +               /* This causes image distortion on a true cx23885
>>>> board */
>>>> +               cx25840_write(client, 0x2, 0x76);
>>>>
>>>> As the patch says that register write causes a horrible image distortion
>>>> on my HVR-1500 which has a real cx23885 (not 23887, 23888, etc) board.
>>>>
>>>> I don't know if it's really required for any bridge as everything seems
>>>> to be auto-configured by default, maybe it can be simply dropped.
>>>>
>>>> Other than that the cx23885-audio tree works well.
>>>>
>>>> WRT the whitespaces, 80 cols, etc; most are also in the sources I took
>>>> as basis, so I didn't think they were a problem.
>>>
>>> That's a mistake, I'll add that later tonight, thanks for finding
>>> this. I must of missed it when I had to tear apart your email because
>>> of HUNK issues caused by patch line wrapping.
>>>
>>> Apart from this, is everything working as you expect?
>>>
>>> Regards,
>>>
>>> Steve
>>>
>>>
>>
>> OK.
>>
>> And sorry about the patch, I didn't know it was going to be broken that
>> way by being sent by email.
>>
>>  >> Other than that the cx23885-audio tree works well.
>>
>
>> Great, thanks for confirming.
>
>> Regards,
>
>> Steve
> I'll try asking again since my replies in gmail were not including the
> correct subject heading.
> Can this code for cx23885 analog support be adapted for the DViCO Fusion
> HDTV7 Dual Express which also uses the cx23885?  Currently the driver for
> that card is digital only and I am stuck with a free antiquated large
> satellite system that is analog only in my apartment. I am willing to put in
> the work if someone can point me in the right direction.  Thank you,

Tim,

The patch currently being tested only enables the analog video path on
the HVR1500, but this does lay down the ground work to bring up analog
on all of the other cards.

If the HVR1500 is working properly, then it will be easy to add analog
support for the HVR1500Q ... Once that is done, the exact same code
(for analog) will be reused for the FusionHDTV7 Dual.

Keep in mind, however, that you will only get ONE analog video device
on the F7 Dual, and that you must not try to use the first DVB adapter
while using the analog on that board.  You can always use the 2nd
adapter , though.

Actually, I think it might be a good idea to reverse the registration
order of the DVB adapters in the cx23885 driver, but I'll have to talk
to Steve about that.

I think it makes more sense to register VIDC first, since VIDC is
always going to be a DTV device, where there *might* be an encoder on
VIDB.

VIDB may or may not share a tuner with VIDA, but VIDC will always be
independant.

What do you think about that, Steve?

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
