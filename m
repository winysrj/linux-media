Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab2JBLFT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 07:05:19 -0400
Date: Tue, 2 Oct 2012 08:05:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
Message-ID: <20121002080503.76869be7@redhat.com>
In-Reply-To: <506ABA2B.3070908@iki.fi>
References: <1349139145-22113-1-git-send-email-crope@iki.fi>
	<CAGoCfiwfTkTs1DPa0cWHLOgGcgS0Df3h7zZ=4YW51dr_AS78nQ@mail.gmail.com>
	<CAOcJUbw+ToEAaqKPx1phWsKdWvPRXUOhtWwm7VaESwkW=fpqyg@mail.gmail.com>
	<506ABA2B.3070908@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Oct 2012 12:55:55 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> On 10/02/2012 06:17 AM, Michael Krufky wrote:
> > On Mon, Oct 1, 2012 at 9:58 PM, Devin Heitmueller
> > <dheitmueller@kernellabs.com> wrote:
> >> On Mon, Oct 1, 2012 at 8:52 PM, Antti Palosaari <crope@iki.fi> wrote:
> >>> New drxk firmware download does not work with tda18271. Actual
> >>> reason is more drxk driver than tda18271. Anyhow, tda18271c2dd
> >>> will work as it does not do as much I/O during attach than tda18271.
> >>>
> >>> Root of cause is tuner I/O during drx-k asynchronous firmware
> >>> download. request_firmware_nowait()... :-/
> >>
> >> This seems like it's just changing the timing of the initialization
> >> process, which isn't really any better than the "msleep(2000)".  It's
> >> just dumb luck that it happens to work on the developer's system.
> >>
> >> Don't get me wrong, I agree with Michael that this whole situation is
> >> ridiculous, but I don't see why swapping out the entire driver is a
> >> reasonable fix.
> >
> > I just send out a patch entitled, "tda18271: prevent register access
> > during attach() if delay_cal is set"   Antti, could you set
> > tda18271_config.delay_cal = 1 with this patch applied and see if it
> > solves your problem?
> >
> > Again, although this may solve the problem for this particular device,
> > the *real* problem is this asynchronous firmware download in the demod
> > driver.
> >
> > Nonetheless, Antti has been asking for this feature, to not allow
> > register access during attach, I was against it and I have my reasons,
> > but I believe that this patch is a fair compromise.
> >
> > After somebody can test it, I think we should merge this -- any comments?
> >
> > http://patchwork.linuxtv.org/patch/14799/
> 
> I tested. It does not help. I also looked it more and it really bails 
> out with error much earlier, in function where it reads chip ID. That 
> makes me look the tda18271c2dd driver. 

I saw Antti's logs: basically, tda18271_get_id() reads all registers at the
chip during attach(), returning -EINVAL if tda18271_read_regs(fe) can't
read the value for R_ID register.

Btw, why do you need to read 16 registers at once, instead of just reading
the needed register? read_extended and write operations are even more evil:
they read/write the full set of 39 registers on each operation. That seems
to be overkill, especially on places like tda18271_get_id(), where
all the driver is doing is to check for the ID register.

Worse than that, tda18271_get_id() doesn't even check if the read()
operation failed: it assumes that it will always work, letting the
switch(regs[R_ID]) to print a wrong message (device unknown) when
what actually failed where the 16 registers dump.

> I found that for some reason 
> these drivers uses different method for register read. tda18271 uses I2C 
> transaction with 2 messages, write and read with REPEATED START 
> condition. tda18271c2dd driver is just simple I2C read. So which one is 
> correct?

That's due to the I2C locking schema: if you do two separate I2C
transfers, the I2C core will allow an event to happen between the
two operations. That typically causes troubles on read operations.
So, it is recommended to use just one i2c_transfer() call for read
operations that are mapped via a write and a read.

> 
> Also other note. tda18271c2dd does not have almost any error logging. 
> Only error log is failed I2C write. So it could be even possible 
> tda18271c2dd fails too, but as it keeps silence and discards all the 
> error I don't see it and it even works :S

I don't think this is the case. The tda18271c2dd driver is just for version
v2 of the silicon, while tda18271 supports both v1 and v2. As there are
differences between them, tda18271 needs to read the chip version, in
order to adjust a few internal settings.

Of course, before making the driver available, tda18271_get_id() needs
to be called and to successfully return the chip ID.

Whenever it should be at attach() or later is a good point for discussions.

> And 3rd issue. It crashes. Very often. I didn't take picture anymore as 
> I have taken earlier. I am so f***ing pissed off all the long time 
> problems with that em28xx driver! It has crashed more than any other 
> driver I have ever seen. It is really, really, problematic. The amount 
> of time what I have loosen em28xx driver problems when hacking with 
> relatively small amount of devices is huge. It is surely more time that 
> it will take me to write whole driver from the scratch using DVB USB. 

For sure rewriting it into dvb-usb will take a lot more time: these
chipsets are lot more complex than pure DVB ones, due to the analog part
and audio part. Also, there are lots of supported devices on it, each with
their own particular configuration, and there are a few different options
on how remote controllers and audio work there.

It is weird that you're experiencing so many issues on this driver.
One thing that may help you during development is to not compile the
remote controller and the alsa drivers. Removing an alsa driver during
development can be a pain, if you have pulseaudio running, as it will
keep the audio opened forever, preventing driver removal. So, you need
first to tell pulseaudio to unload the driver module before being able
to remove it, by using a proper pacmd/pactl enchant.

> As 
> I cannot trust em28xx correctness it is very hard to debug these 
> crashes. That one seems to come from drxk, but is it really?
> 
> http://palosaari.fi/linux/v4l-dvb/em28xx_drxk_crash/

Not sure how you work, but I suspect you're not using a serial console.
The best thing you can do for yourself, when developing drivers, is to buy
or wire a cross serial cable and use it. That saves you a lot time when
you get crashes.

It is hard to analyze that log without actually knowing what you were
doing, but the above log could even be caused by your 2 seconds delay ;)
I suspect that request_firmware callback call got delayed for a long time
and maybe you asked to remove the driver before the callback is called.
So, at the time i2c_lock_adapter() is called, there's no more I2C bus
there. That's my initial guess. Ok, if I'm right, there's a real bug at
the driver (or at I2C core), as it shouldn't be allowed to unregister
the I2C bus while there are some deferred work there.

Regards,
Mauro
