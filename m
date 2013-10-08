Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3JHUdh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 16:33:37 -0400
Date: Wed, 9 Oct 2013 05:33:27 +0900
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFD] use-counting V4L2 clocks
Message-ID: <20131009053327.091686f3@concha.lan>
In-Reply-To: <Pine.LNX.4.64.1309121947590.7038@axis700.grange>
References: <Pine.LNX.4.64.1309121947590.7038@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 12 Sep 2013 21:13:49 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> Hi all
> 
> We've got a broken driver in 3.11 and in 3.12-rc and we don't have a clear 
> way to properly fix it. The problem has been originally reported and 
> discussed in [1], a patch-set to fix the problem has been proposed in [2], 
> which actually lead to the topic of this mail - whether or not calls to 
> v4l2_clk_enable() and v4l2_clk_disable(), or respectively to s_power(1) 
> and s_power(0) subdevice core operations should be balanced. Currently 
> they aren't in em28xx driver, and the V4L2 clock API throws warnings on 
> attempts to disable already disabled clock. Patch [3] attempted to fix 
> that. So, the question is - whether to enforce balanced power on / off 
> calls, or to remove the warning.
> 
> Let's try to have a look at other examples in the kernel:
> 
> 1. runtime PM: pm_runtime_get*() / pm_runtime_put*() only work, if 
> balanced, but no warning is issued, if the balance is broken, AFAICS.
> 
> 2. clock API: clk_enable() / clk_disable() in drivers/clk/clk.c have to be 
> balanced and a warning is issued, if clk_disable() is called for an 
> already disabled clock.
> 
> 3. regulator API: regulator_enable() / regulator_disable() have to be 
> balanced. A warning is issued if regulator_disable() is called for a 
> disabled regulator.
> 
> So, I think, our V4L2 clock enable / disable calls should be balanced, and 
> to enforce that a warning is helpful. Other opinions?

Guennadi,

On non-embedded hardware, the clocks and power supply are typically
controlled by GPIO pins that are part of the driver initialization
sequence.

The only control that most of those devices have is to either enable
or disable the clock line.

Actually, the way most such devices work is with a circuit like:
                 _______
                 |      )
     CLK ----->  |       )
                 | AND   )---->
NOT(RST) ----->  |______)

and the clock is hardwired (either it is a XTAL or a clock obtained from
some bridge clock line). On Several of those devices, there's just one
allowed CLK frequency. For example, on most analog TV devices, the clock
is just a 27MHz XTAL.

In other words:
	1) the clock is directly wired inside the I2C chips;
	2) it can be disabled by rising the RST pin;
	3) there's just one possible clock frequency, due to the hardware
limitation.

Of course, there are some devices where the above doesn't apply or only
applies partially.

On the drivers where the 3 above conditions apply, the device initialization
logic sends the needed GPIO sequence to reset the device and to let the clock
flow into them, by simply writing some value to GPIO, enabling all the chips
inside the board at the same time.

When the driver puts some devices on power saving mode, it rises
the RST pin of the sub-devices, with prevents the clock signal to flow
internally into the chips, making them to (almost) not consume power.

Not all sub-devices have it through. For example, on most devices,
you can't disable the clock of the I2C eeprom devices: those eeproms
are always on.

Nobody ever cared to split the GPIO pins individually and to document 
what GPIO pins are used to enable each device inside a hardware.

Also, nobody cared to document what sub-devices are always powered
and have the clock always wired and the ones that don't.

Due to that, V4L2 drivers always assumed that the default is to have the
RST pin disabled at device's initialization, so the device gets powered
on during device's probe().

On modern hardware (mostly USB ones), where power consumption can be an 
issue, an API was added to allow disabling the power on the sub-devices.
On most cases, calling that sub-device API actually disables the clock
there, by rising the RST pin (although a few sub-devices have a separate
GPIO to put the device on standby mode, plus the RST line).

So, that API callback was actually .sleep() (or a similar naming - I don't 
remember the exact callback name).

Later on, someone renamed that callback to s_power(), adding a boolean there
to allow to use the same API call to enable or disable the power/clock on
those sub-devices.

That change introduced one issue, through:

- on embedded devices, s_power() assumes that the original state is
  to have the sub-device disabled. So, s_power() is what you call "balanced",
  e. g. the device is assumed to be on POWER OFF mode. So, the first call is
  to enable it, and a second call is used to disable it, when the device is
  not needed anymore, or need to be put in power saving mode.

- on the existing PC drivers on that time where sleep() was used, the 
  s_power() support were added on a different way. On those, the default is
  that the RST and standby pins are by default not enabled. So, the initial
  state of the device is to be in POWER ON mode. Still, s_power()
  is balanced, but on the reverse way: the driver calls it to make the device
  to power off (for example, during S1/S3 suspend), calling it again to power
  it on at resume.

- newer PC drivers after that patch in general uses the POWER ON default, but
  I won't doubt that a few could be assuming the POWER OFF default.

In other words, what you're actually proposing is to change the default used
by most drivers since 1997 from a POWER ON/CLOCK ON default, into a POWER OFF/
CLOCK OFF default.

Well, for me, it sounds that someone will need to re-test all supported devices,
to be sure that such change won't cause regressions.

If you are willing to do such tests (and to get all those hardware to be sure
that nothing will break) or to find someone to do it for you, I'm ok with
such change.

Otherwise, we should stick with the present behavior, as otherwise we will cause
regressions.

Regards,
Mauro
