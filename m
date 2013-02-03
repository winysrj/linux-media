Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42734 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3BCVC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 16:02:28 -0500
Received: by mail-lb0-f170.google.com with SMTP id ge1so6150569lbb.15
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 13:02:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510EC8A5.5070209@iki.fi>
References: <50F05C09.3010104@iki.fi>
	<2909559.M1IsAHpWSv@jar7.dominio>
	<CAOcJUbyt418Cg=5JawNq_U_4bUG+ztqB_7n7iOvwWgo-zvROhg@mail.gmail.com>
	<2616361.Xo6SKdVfQO@jar7.dominio>
	<510E645A.80103@iki.fi>
	<CAOcJUbxMBs=P8VJ_F50hXK+gxUuQ+kGYzD1yS9N7z48nDA-Ntw@mail.gmail.com>
	<510EBC47.7040301@iki.fi>
	<CAOcJUbyYp7p9F3wQhi1uq=RcaT44i7Y2=ax6Z3eDaMCX--kgSg@mail.gmail.com>
	<510EC8A5.5070209@iki.fi>
Date: Sun, 3 Feb 2013 16:02:26 -0500
Message-ID: <CAOcJUbzccegcFOyp00y0kNBw-+2exF3GtMXewL8XF_3J5_nH=g@mail.gmail.com>
Subject: Re: af9035 test needed!
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 3, 2013 at 3:29 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 02/03/2013 09:53 PM, Michael Krufky wrote:
>>
>> (history chopped cuz it got messy)
>>
>> quoting Antti with my responses inline.
>>
>> <<
>> I agree that it should be split multiple patches.
>>
>> KRUFKY:  YES.
>>
>> 1) soft reset should be moved to attach() (it could not be on init()
>> nor set_parameters() as it stops clock out and loop-through in few ms
>> or so causing slave tuner errors)
>>
>> KRUFKY: NO.  This is not the solution.  If there is a bug in the
>> driver, then we fix the bug.  Moving the soft reset to a one time only
>> call during attach can cause worse problems.  If you feel strongly
>> about this, then submit it in a separate patch and we can work on that
>> issue separately.  The soft reset needs to be done each time the tuner
>> is programmed for good reason - if we are screwing up some registers,
>> then it means that there is a bug - lets fix the bug.
>
>
> You cannot do soft reset all the time. MxL5007t soft reset looks like just
> jump instruction to chip reset vector, it simply clears all the registers to
> the default state (I think just same state as power on reset).
>
> That means you taint clock output and loop-through every time you call that
> soft reset. Why the hell there is such outputs offered by the chip if those
> are aimed to shut off frequently by soft resetting chip? Such outputs are
> useless. Due to that analogy, there will be only one conclusion: soft reset
> is not aimed to be called for every tuning attempt.
>
> It is just easy way to ensure chip is known default state on attach(). For
> example you warm boot from windows to linux and wish to ensure chip is known
> state after attach(). It is driver bug if soft resetting all the registers
> to default is needed frequently in order to operate normally!
>
>
>
>> 2) clock out and loop-through must be set on attach() and not touch after
>> that
>>
>> KRUFKY: NO.  attach() is called once, ever.   I admit that the current
>> code may be buggy but doing this would cause unpredicable behavior
>> after low-power states...  If this needs to be fixed then it needs to
>> be fixed in a thorough way, not by moving the code away into the
>> attach function where it will only be called once.  Clearly this issue
>> is directly related to issue number 1, so I understand if these two
>> items might be the focus of future discussion :-/
>
>
> Shutting down clock output when not needed surely saves few mA from the
> current drain. But currently there is no DVB framework support for it, so
> better to leave clock out enabled always. It is relative small amount of
> current you will save - there is a lot of bigger power management issues
> about all the drivers currently.
>
>
>
>> 3) no_probe option should not be added unless it is really needed. If
>> chip ID reading fails with some I/O error then there is two
>> possibilities a) block reads like now b) add glue to AF9035 brain-dead
>> I2C adapter to handle / fake such case
>>
>> KRUFKY:  I agree -- this may be required in order to work around some
>> questionable hardware implementations.  If the problem is really in
>> the i2c adapter, then the hack belongs there, not in the tuner driver.
>
>
> The one thing what I think I has already mentioned for Jose - test some
> other tuner IDs. There is many tuners supported by AF9035 FW and about all
> of those uses register reads. So telling wrong tuner ID to AF9035 just
> before attach tuner could do the trick. And after successful tuner attach
> just tell AF9035 FW that MXL5007T tuner id.
>
>
>> 4) loop_thru_enable to 3 bit wide should not be done unless really
>> needed. What happens if it is left as it is?
>>
>> KRUFKY: Agreed.  We don't make a change just because you saw something
>> in 'the windows driver'  As per the current Linux driver, the loop
>> thru setting is 1 bit wide.  If this is wrong, please provide a better
>> explanation of those bits.
>>
>> These are the four logical changes that should be sent as own patch.
>> Jose, we are waiting for you :)
>>>>
>>>>
>>
>> -Mike
>>
>
> Antti

I was just thinking and I realize fault in my own arguments where I
said "No."  ...  Coincidentally you sent this email just as I was
thinking of doing the same.

I retract my "No" s :-)

Let's just see a patch series and we'll evaluate each patch individually.

Cheers,

Mike
