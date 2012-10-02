Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab2JBNSB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 09:18:01 -0400
Date: Tue, 2 Oct 2012 10:17:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
Message-ID: <20121002101746.3dc259d0@redhat.com>
In-Reply-To: <CAOcJUbzpf=ZsUYxYJ+MHNtC-YaAGfE1Hegk12Vqk+mSYuQ8Qyw@mail.gmail.com>
References: <1349139145-22113-1-git-send-email-crope@iki.fi>
	<CAGoCfiwfTkTs1DPa0cWHLOgGcgS0Df3h7zZ=4YW51dr_AS78nQ@mail.gmail.com>
	<CAOcJUbw+ToEAaqKPx1phWsKdWvPRXUOhtWwm7VaESwkW=fpqyg@mail.gmail.com>
	<506ABA2B.3070908@iki.fi>
	<20121002080503.76869be7@redhat.com>
	<CAOcJUbzpf=ZsUYxYJ+MHNtC-YaAGfE1Hegk12Vqk+mSYuQ8Qyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 2 Oct 2012 08:22:28 -0400
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> On Tue, Oct 2, 2012 at 7:05 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Btw, why do you need to read 16 registers at once, instead of just reading
> > the needed register? read_extended and write operations are even more evil:
> > they read/write the full set of 39 registers on each operation. That seems
> > to be overkill, especially on places like tda18271_get_id(), where
> > all the driver is doing is to check for the ID register.
> 
> TDA18271 does not support subaddressing for read operations.  The only
> way to read a register is by dumping full register contents.  16
> registers in simple mode, 39 registers in extended mode.

Well, at least at get_id() I think you should just read the ID register
and not the full set.

> > Worse than that, tda18271_get_id() doesn't even check if the read()
> > operation failed: it assumes that it will always work, letting the
> > switch(regs[R_ID]) to print a wrong message (device unknown) when
> > what actually failed where the 16 registers dump.
> 
> That's a pretty standard operation to be able to read a chip's ID in
> its driver attach function.  You even have some drivers that continue
> trying to attach frontends and tuners as long as they continue to get
> an error in the attach() function.  If we dont read the chip's ID
> during attach() then how do we know we're attaching to the correct
> chip?

Yes, reading the chip ID there seems ok.

Btw, I think we should re-visit the I2C gate control logic where implemented.

Antti pasted me yesterday the logs from the driver:

By looking on those messages:

Sep 28 01:35:57 localhost kernel: [44798.782787] drxk: i2c_read: read from 63 42 c0 00, value =  00 00
Sep 28 01:35:57 localhost kernel: [44798.782804] tda18271_read_regs: [5-0060|M] ERROR: i2c_transfer returned: -19
...
Sep 28 01:35:57 localhost kernel: [44798.782980] Unknown device (16) detected @ 5-0060, device not supported.
Sep 28 01:35:57 localhost kernel: [44798.782985] tda18271_attach: [5-0060|M] error -22 on line 1274
Sep 28 01:35:57 localhost kernel: [44798.782989] tda18271 5-0060: destroying instance
Sep 28 01:35:57 localhost kernel: [44798.783003] drxk: drxk_release

I'm almost sure that the I2C gate control is at the wrong state there.

Very likely, the tda code is trying to access the I2C bus before DRX-K to
restore the I2C switch back to its original way.

In other words, I think that drivers with an I2C switch should be doing:
	- take I2C lock;
	- switch I2C gate;
	- do writes and/or read ops;
	- switch I2C gate back;
	- release I2C lock.

What's implemented, however, is:

	- switch I2C gate;
	- take I2C lock;
	- do writes and/or read ops;
	- release I2C lock.
	- switch I2C gate back;

So, there is a chance of a race condition where a pending I2C
operation will be handled with the I2C gate switch at the wrong
state.

Such change is not trivial, as it requires reviewing all drivers. Also,
the I2C switching may also require access to the I2C bus, making it
harder to do.

I know khali coded something for I2C switch at I2C core. We should likely
visit it and see if it could improve things there.

> I'll look at the fact that it doesn't check for a read error -- that
> can be easily fixed.

Please do so.

> > Whenever it should be at attach() or later is a good point for discussions.
> 
> The tda18271 driver supports running multiple tda18271 devices in
> tandem with one another, including the ability to share xtal input and
> rf loop thru.  In some cases, the order in which we initialize the
> different tda18271's (when there are multiples) must be carefully
> controlled, and we do this by attaching them to the bridge driver in
> the order needed, such as in the saa7164 driver -- we need to be ABLE
> to initialize the tuner during the attach, but being able to defer it
> *as an option* is OK with me.

Just wrote an email to Greg, c/c the involved parts, with regards to it.

I think the better, in the short term, is to apply the change for tda18271dd.

For the long term, to revert the drx-k asynchronous load, as I suspect
that, while delaying tda18271 init would fix for this device, we'll end
by getting problems on other parts.

That OOPS pointed by Antti shows that, by using an async load there, we'll
need to add some task to kill the deferred firmware loads if the I2C
bus got removed. I'm sure we'll also find other regressions by deferring
initialization task.

Regards,
Mauro
