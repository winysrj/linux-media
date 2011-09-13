Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:54292 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab1IMVeM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 17:34:12 -0400
Subject: Re: recursive locking problem
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>
Cc: David Waring <davidjw@rd.bbc.co.uk>, linux-media@vger.kernel.org
In-Reply-To: <4E6FC41A.5030803@iki.fi>
References: <4E68EE98.90201@iki.fi> <4E69EE5E.8080605@rd.bbc.co.uk>
	 <4E6FC41A.5030803@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 22:34:04 +0100
Message-ID: <1315949644.10987.25.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At the risk of sounding silly, why do we rely on i2c gating so much? The
whole point of i2c is that you can sit a bunch of devices on the same
pair of wires and talk to one at a time.

Why not just open up the gates and be done with it, except for
situations where the i2c chain foolishly has two devices that have the
same address because somebody didn't net the address configuration pins
correctly, or it's a really big system with more devices on it that a
particular chip family has sub-addresses?

>From a signal-driving point of view, the gate circuitry is surely a
sufficient buffer. I guess the only two things I can think of as real
reasons are to 1) reduce the chance of misbehaving devices from causing
problems and 2) to save power by not sending clocks and data where we
know they aren't needed.

Can any one shed some light on this? I appreciate it's not a linux or
indeed linux-media specific issue as the hardware itself is designed
this way.

Getting back to the subject, Antti's af9015 example demonstrates
precisely when gating is needed. But I have to ask, does the MXL5003
really only support one address; can it not be reconfigured? it's a bit
late to ask that question once the PCB is fabbed, I admit.

Would it make any sense to haul the gate locking (or some wrapper at
least) up into the uC for that particular configuration?

E.g:

Tuner driver wants to i2c write tuner 0
Calls i2c_gate_ctrl(open)
uC checks if a gate is already open, if it is, and is the same gate as
is already open, just carry on. If not, wait on a lock, then set which
gate is open and proceed to the 'real' gate_ctrl op.
Similar path for i2c_gate_ctrl(close), as relaxed as it needs to be to
cope with how different tuner drivers work.

You could wrap the checking of which gate is open in a lock for
atomicity, and only wait on a device lock where necessary. This way you
can also check whether you're trying to change the state of a gate or
not and early-out (unless calling gate_ctrl(open) more than once does
something /different/ to calling it just once, in which case we're
doomed and this was nothing more than naive rambling).

Cheers,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Tue, 2011-09-13 at 23:59 +0300, Antti Palosaari wrote:
> On 09/09/2011 01:45 PM, David Waring wrote:
> > On 08/09/11 17:34, Antti Palosaari wrote:
> >> [snip]
> >>
> >> Is there any lock can do recursive locking but unlock frees all locks?
> >>
> >> Like that:
> >> gate_open
> >> +gate_open
> >> +gate_close
> >> == lock is free
> >>
> >> AFAIK mutex can do only simple lock() + unlock(). Semaphore can do
> >> recursive locking, like lock() + lock() + unlock() + unlock(). But how I
> >> can do lock() + lock() + unlock() == free.
> >>
> > Antti,
> >
> > It's a very bad idea to try and use a mutex like that. The number of
> > locks and unlocks must be balanced otherwise you risk accessing
> > variables without a lock.
> >
> > Consider:
> >
> > static struct mutex foo_mutex;
> > static int foo=3;
> >
> > void a() {
> >    mutex_lock(&foo_mutex);
> >    if (foo<5) foo++;
> >    b();
> >    foo--; /*<<<  still need lock here */
> >    mutex_unlock(&foo_mutex);
> > }
> >
> > void b() {
> >    mutex_lock(&foo_mutex);
> >    if (foo>6) foo=(foo>>1);
> >    mutex_unlock(&foo_mutex);
> > }
> >
> > Note: this assumes mutex_lock will allow the same thread get multiple
> > locks as you would like (which it doesn't).
> >
> > As pointed out in the code, when a() is called, you still need the lock
> > for accesses to foo after the call to b() that also requires the lock.
> > If we used the locks in the way you propose then foo would be accessed
> > without a lock.
> >
> > To code properly for cases like these I usually use a wrapper functions
> > to acquire the lock and call a thread unsafe version (i.e. doesn't use
> > locks) of the function that only uses other thread unsafe functions. e.g.
> >
> > void a() {
> >    mutex_lock(&foo_mutex);
> >    __a_thr_unsafe();
> >    mutex_unlock(&foo_mutex);
> > }
> >
> > void b() {
> >    mutex_lock(&foo_mutex);
> >    __b_thr_unsafe();
> >    mutex_unlock(&foo_mutex);
> > }
> >
> > static void __a_thr_unsafe() {
> >    if (foo<5) foo++;
> >    __b_thr_unsafe();
> >    foo--;
> > }
> >
> > static void __b_thr_unsafe() {
> >    if (foo>6) foo=(foo>>1);
> > }
> >
> > This way a call to a() or b() will acquire the lock once for that
> > thread, perform all actions and then release the lock. The mutex is
> > handled properly.
> >
> > Can you restructure the code so that you don't need multiple locks?
> 
> Thank you for very long and detailed reply with examples :)
> 
> I need lock for hardware access. Single I2C-adapter have two I2C-clients 
> that have same I2C-address in same bus. There is gate (demod I2C-gate) 
> logic that is used to select desired tuner. See that:
> http://palosaari.fi/linux/v4l-dvb/controlling_tuner_af9015_dual_demod.txt
> 
> You can never know surely how tuner drivers calls to open or close gate, 
> very commonly there is situations where multiple close or open happens. 
> That's why lock/unlock is problematic.
> 
> .i2c_gate_ctrl() is demod driver callback (struct dvb_frontend_ops) 
> which controls gate that gate. That callback is always called from tuner 
> driver when gate is needed to open or close.
> 
> regards
> Antti
> 

