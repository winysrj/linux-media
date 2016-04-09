Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:33592 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbcDIINi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Apr 2016 04:13:38 -0400
Received: by mail-lf0-f50.google.com with SMTP id e190so100406099lfe.0
        for <linux-media@vger.kernel.org>; Sat, 09 Apr 2016 01:13:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57086642.4060003@iki.fi>
References: <57083b12.ec3ec20a.eed91.1ea1SMTPIN_ADDED_BROKEN@mx.google.com>
	<CAO8Cc0qC79u_BBV3xaat3Cy6E2XB+GtJfJSf3aCJX==Q++BaXg@mail.gmail.com>
	<570851E4.30801@iki.fi>
	<57085943.5010805@iki.fi>
	<CAO8Cc0p2vw6g_qEVAL8BowU9394gpOJXYVcEbgbQo-e3mN3q0Q@mail.gmail.com>
	<57086642.4060003@iki.fi>
Date: Sat, 9 Apr 2016 10:13:36 +0200
Message-ID: <CAO8Cc0rwLVxGwotpLARM6H6rO+covxbmfYb5HH_5aP-KdbN-Xw@mail.gmail.com>
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
From: Alessandro Radicati <alessandro@radicati.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 9, 2016 at 4:17 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 04/09/2016 04:52 AM, Alessandro Radicati wrote:
>>
>> On Sat, Apr 9, 2016 at 3:22 AM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> Here is patches to test:
>>> http://git.linuxtv.org/anttip/media_tree.git/log/?h=af9035
>>>
>>
>> I've done this already in my testing, and it works for getting a
>> correct chip_id response, but only because it's avoiding the issue
>> with the write/read case in the af9035 driver.  Don't have an
>> af9015... perhaps there's a similar issue with that code or we are
>> dealing with two separate issues since af9035 never does a repeated
>> start?
>
>
> I am pretty sure mxl5007t requires stop between read and write. Usually
> chips are not caring too much if it is repeated start or not, whilst
> datasheets are often register read is S Wr S Rw P.
>
> Even af9035 i2c adapter implementation implements repeated start wrong, I

Where does the assumption that CMD_I2C_RD should issue a repeated
start sequence come from?  From the datasheet?  Maybe it was never
intended as repeated start.  Perhaps if there is another stick  with
mxl5007t and a chip that does repeated start, we can put this to bed.

> would not like to add anymore hacks there. It is currently ugly and complex

Bugfix != hack.  Don't see how putting the register address in the
address fields is a hack (perhaps semantics around the fact that 0xFB
is not really part of the address?); this is the only and intended way
to use that command for write/read.

> as hell. I should be re-written totally in any case. Those tuner I2C
> adapters should be moved to demod. Demod has 1 I2C adapter. USB-bridge has 2
> adapters, one for each demod.
>

Agreed that it can be refactored and improved.  Also to support n
transactions with a simple while loop and only issuing single writes
and reads.  Only downside would be increased USB traffic for 2
commands vs 1 - hence negligible.

> I have to find out af9015 datasheets and check how it is there. But I still
> remember one case where I implemented one FX2 firmware and that same issues
> raises there as well.
>
>>> After that both af9015+mxl5007t and af9035+mxl5007t started working.
>>> Earlier
>>> both were returning bogus values for chip id read.
>>>
>>> Also I am interested to known which kind of communication there is
>>> actually
>>> seen on I2C bus?
>>
>>
>> With this or the patch I proposed, you see exactly what you expect on
>> the I2C bus with repeated stops, as detailed in my previous mails.
>
>
> So it is good?
>

Yes, I2C looks good.

>>> If it starts working then have to find out way to fix it properly so that
>>> any earlier device didn't broke.
>>>
>>
>> I hope that by now I've made abundantly clear that my mxl5007t locks
>> up after *any* read.  It doesn't matter if we are reading the correct
>> register after any of the proposed patches.
>
>
> So it still locks up after any read after the chip id read? And does not
> work then? On my devices I can add multiple mxl5007t_get_chip_id() calls and
> all are returning correct values.
>

No, as mentioned before, it locks up at the end of any read command.
Including the chip_id.  The firmware is not aware of the issue and
wont complain until the next I2C transaction.

> Could you test what happens if you use that CMD_GENERIC_I2C_WR +
> CMD_GENERIC_I2C_RD ? I suspect it is lower level I2C xfer than those
> CMD_I2C_RD + CMD_I2C_WR, which are likely somehow handled by demod core.
>

I will test, but the issue is either electrical or with the state of
the mxl5007t.  I2C bus looks good from AF9035 side once the bug in the
above is patched.

Regards,
Alessandro
