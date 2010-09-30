Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49546 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0I3TSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 15:18:15 -0400
Received: by yxp4 with SMTP id 4so904757yxp.19
        for <linux-media@vger.kernel.org>; Thu, 30 Sep 2010 12:18:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CA4E115.2080607@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
	<20100928154659.0e7e4147@pedra>
	<AANLkTik_3MSjyqokvam28g5ohhCP=bb=_uzyzK0iM8Et@mail.gmail.com>
	<4CA4E115.2080607@redhat.com>
Date: Thu, 30 Sep 2010 15:18:11 -0400
Message-ID: <AANLkTinRy4Dd54=RhBhewrSSOLHyRXLVpXJwehTeX2ih@mail.gmail.com>
Subject: Re: [PATCH 08/10] V4L/DVB: tda18271: allow restricting max out to 4 bytes
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 30, 2010 at 3:12 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Michael,
>
> Em 30-09-2010 15:52, Michael Krufky escreveu:
>> On Tue, Sep 28, 2010 at 2:46 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> By default, tda18271 tries to optimize I2C bus by updating all registers
>>> at the same time. Unfortunately, some devices doesn't support it.
>>>
>>> The current logic has a problem when small_i2c is equal to 8, since there
>>> are some transfers using 11 + 1 bytes.
>>>
>>> Fix the problem by enforcing the max size at the right place, and allows
>>> reducing it to max = 3 + 1.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> This looks to me as if it is working around a problem on the i2c
>> master.  I believe that a fix like this really belongs in the i2c
>> master driver, it should be able to break the i2c transactions down
>> into transactions that the i2c master can handle.
>>
>> I wouldn't want to merge this without a better explanation of why it
>> is necessary in the tda18271 driver.  It seems to be a band-aid to
>> cover up a problem in the i2c master device driver code.
>
> In the specific case of cx231xx the hardware don't support any I2C transactions
> with more than 4 bytes. It is common to find this kind of limit on other types
> of hardware as well.
>
> In the specific case of tda18271, the workaround for tda18271 is already there:
>
> enum tda18271_small_i2c {
>        TDA18271_39_BYTE_CHUNK_INIT = 0,
>        TDA18271_16_BYTE_CHUNK_INIT = 1,
>        TDA18271_08_BYTE_CHUNK_INIT = 2,
> };
> (from upstream tda18271.h header)
>
> Yet, it is currently broken. In thesis, if you use small_i2c, it should limit the
> transactions size to a certain value, but, if you try to limit to 8, you'll still
> see some transactions with size=11, since the code that honors small_i2c only works
> for the initial dump of the 39 registers, as there are some cases where writes to
> EP3 registers are done with:
>        tda18271_write_regs(fe, R_EP3, 11);
>
> and the current code for tda18271_write_regs don't check it.
>
> So, if there's a code there that allows limiting small_i2c:
>        1) this code should work for all transactions, not only to the initial init;
>        2) if there is such code, why not allow specifying a max size of 4 bytes?
>
> Another aspect is that doing such kind or restriction at the i2c adapter would require
> a very ugly logic, as some devices like tda18271 have only 8 bits registers per i2c address,
> and a write (or read) with length > 1 byte update/read the next consecutive registers,
> while other devices like xc3028 have one single I2C address for multi-byte operations like
> updating the firmware.
>
> If this logic would be moved into the bridge drivers, they would need to have some ugly
> tests, checking for each specific i2c sub-driver at their core drivers.

Hmm... If you don't mind, would you allow me to think about this a
bit, and run some tests of my own?

I have already seen the tda18271 work properly on the cx231xx with 8
byte transactions, the issue that I saw was actually a 12-byte
transaction limit, so the 11 byte transfer didn't cause a problem.
I'd like to test this again myself using the cx231xx device that I
have on hand.

However, this transaction in particular:

tda18271_write_regs(fe, R_EP3, 11);

...is not supposed to be broken down to smaller transaction -- this
particular transaction is supposed to be a one shot change to all 11
regs at once.  Straying from this could result in unpredictable
behavior.

I'd just like to review some other options and retest this before we
merge.  Is that okay with you?

Regards,

Mike Krufky
