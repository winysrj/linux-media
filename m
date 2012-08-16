Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60259 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750937Ab2HPKXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 06:23:33 -0400
Date: Thu, 16 Aug 2012 13:23:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.7] [media] media: rc: Introduce RX51 IR
 transmitter driver
Message-ID: <20120816102328.GW29636@valkosipuli.retiisi.org.uk>
References: <E1T10iu-0000Xo-L8@www.linuxtv.org>
 <20120815160621.GV29636@valkosipuli.retiisi.org.uk>
 <502BFCA3.5040905@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502BFCA3.5040905@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi,

On Wed, Aug 15, 2012 at 10:46:43PM +0300, Timo Kokkonen wrote:
> Long time no see.

Indeed! Better late than never I guess. :)

> On 08/15/12 19:06, Sakari Ailus wrote:
> > Heippa,
> > 
> > Thanks for the patch! I know Mauro has already applied this so any changes
> > would make a separate patch.
> > 
> 
> Patches are cheap :) I'll have also couple of changes from Sean's comments.
> 
> > I have tested this up to the point I can see that the IR LED blinks  ---
> > using my phone's camera. :-) But I have no receivers so the testing ends to
> > this.
> 
> Thanks for your thorough review and testing.

You're welcome. It's nice to see people working on the N900 support. ;)

> > On Mon, Aug 13, 2012 at 09:53:45PM +0200, Mauro Carvalho Chehab wrote:
> >> This is an automatic generated email to let you know that the following patch were queued at the 
> >> http://git.linuxtv.org/media_tree.git tree:
> >>
> >> Subject: [media] media: rc: Introduce RX51 IR transmitter driver
> >> Author:  Timo Kokkonen <timo.t.kokkonen@iki.fi>
> >> Date:    Fri Aug 10 06:16:36 2012 -0300
> >>
> >> This is the driver for the IR transmitter diode found on the Nokia
> >> N900 (also known as RX51) device. The driver is mostly the same as
> >> found in the original 2.6.28 based kernel that comes with the device.
> >>
> >> The following modifications have been made compared to the original
> >> driver version:
> >>
> >> - Adopt to the changes that has happen in the kernel during the past
> >>   five years, such as the change in the include paths
> >>
> >> - The OMAP DM-timers require much more care nowadays. The timers need
> >>   to be enabled and disabled or otherwise many actions fail. Timers
> >>   must not be freed without first stopping them or otherwise the timer
> >>   cannot be requested again.
> >>
> >> The code has been tested with sending IR codes with N900 device
> >> running Debian userland. The device receiving the codes was Anysee
> >> DVB-C USB receiver.
> > 
> > Just a general question: how much this driver actually depends on the N900?
> > I can see there's a dependency to OMAP DM timers, but couldn't you use the
> > same driver if you just wired the IR LED there? Even the timer configuration
> > is there, so it looks a lot more generic than N900-specific.
> > 
> 
> Yeah, I was thinking that there are no other boards that have an IR
> diode connected to the PWM timer pin. But that doesn't stop anyone from
> soldering a diode one to his/her board.
> 
> >> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> >> Cc: Tony Lindgren <tony@atomide.com>
> >> Cc: linux-omap@vger.kernel.org
> >> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >>  drivers/media/rc/Kconfig   |   10 +
> >>  drivers/media/rc/Makefile  |    1 +
> >>  drivers/media/rc/ir-rx51.c |  496 ++++++++++++++++++++++++++++++++++++++++++++
> >>  include/media/ir-rx51.h    |   10 +
> >>  4 files changed, 517 insertions(+), 0 deletions(-)
> >>
> >> ---
> >>
> >> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=c332e8472d7db67766bcad33390c607fdd9ac5bc
> >>
> >> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> >> index 64be610..016f9ab 100644
> >> --- a/drivers/media/rc/Kconfig
> >> +++ b/drivers/media/rc/Kconfig
> >> @@ -287,6 +287,16 @@ config IR_TTUSBIR
> >>  	   To compile this driver as a module, choose M here: the module will
> >>  	   be called ttusbir.
> >>  
> >> +config IR_RX51
> >> +	tristate "Nokia N900 IR transmitter diode
> >> +	depends on MACH_NOKIA_RX51 && OMAP_DM_TIMER
> > 
> > You also should depend on LIRC.
> 
> Yes. And if one had the diode in some other board than RX51, maybe this
> wouldn't need to depend on MACH_NOKIA_RX51 either.
> 
> ...
> 
> 
> Which gave me an idea. We have this new PWM subsystem that I know
> nothing about. If the omap timer PWM routines were exposed through this
> API, we could modify this driver to a generic PWM lirc driver. I don't
> know how well the PWM api suits for that purpose, but it could be an
> interesting idea.. :)

Sounds like an excellent idea. If the PWM subsystem couldn't be used for
this it'd be very valuable input for the design of that API.

That's something for future though, as I guess the OMAP DM timers aren't yet
supported by the PWM framework. This pull req has support for many sub-archs
but not for OMAPs. :I

<URL:http://www.spinics.net/lists/arm-kernel/msg180746.html>

It might not make sense to rename the driver before moving to PWM API but a
note saying it can be used on any OMAP ? for the same would be nice.

> >> +	---help---
> >> +	   Say Y or M here if you want to enable support for the IR
> >> +	   transmitter diode built in the Nokia N900 (RX51) device.
> >> +
> >> +	   The driver uses omap DM timers for gereating the carrier
> > 
> > s/gereating/renerating/
> > 
> 
> Uh oh, will fix..
> 
> >> +	   wave and pulses.
> >> +
> >>  config RC_LOOPBACK
> >>  	tristate "Remote Control Loopback Driver"
> >>  	depends on RC_CORE
> >> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> >> index 66c8bae..56bacf0 100644
> >> --- a/drivers/media/rc/Makefile
> >> +++ b/drivers/media/rc/Makefile
> >> @@ -23,6 +23,7 @@ obj-$(CONFIG_IR_FINTEK) += fintek-cir.o
> >>  obj-$(CONFIG_IR_NUVOTON) += nuvoton-cir.o
> >>  obj-$(CONFIG_IR_ENE) += ene_ir.o
> >>  obj-$(CONFIG_IR_REDRAT3) += redrat3.o
> >> +obj-$(CONFIG_IR_RX51) += ir-rx51.o
> >>  obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
> >>  obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
> >>  obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
> >> diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
> >> new file mode 100644
> >> index 0000000..9487dd3
> >> --- /dev/null
> >> +++ b/drivers/media/rc/ir-rx51.c
> >> @@ -0,0 +1,496 @@
> >> +/*
> >> + *  Copyright (C) 2008 Nokia Corporation
> >> + *
> >> + *  Based on lirc_serial.c
> >> + *
> >> + *  This program is free software; you can redistribute it and/or modify
> >> + *  it under the terms of the GNU General Public License as published by
> >> + *  the Free Software Foundation; either version 2 of the License, or
> >> + *  (at your option) any later version.
> >> + *
> >> + *  This program is distributed in the hope that it will be useful,
> >> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + *  GNU General Public License for more details.
> >> + *
> >> + *  You should have received a copy of the GNU General Public License
> >> + *  along with this program; if not, write to the Free Software
> >> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> >> + *
> >> + */
> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/uaccess.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/sched.h>
> >> +#include <linux/wait.h>
> >> +
> >> +#include <plat/dmtimer.h>
> >> +#include <plat/clock.h>
> >> +#include <plat/omap-pm.h>
> >> +
> >> +#include <media/lirc.h>
> >> +#include <media/lirc_dev.h>
> >> +#include <media/ir-rx51.h>
> >> +
> >> +#define LIRC_RX51_DRIVER_FEATURES (LIRC_CAN_SET_SEND_DUTY_CYCLE |	\
> >> +				   LIRC_CAN_SET_SEND_CARRIER |		\
> >> +				   LIRC_CAN_SEND_PULSE)
> >> +
> >> +#define DRIVER_NAME "lirc_rx51"
> >> +
> >> +#define WBUF_LEN 256
> >> +
> >> +#define TIMER_MAX_VALUE 0xffffffff
> >> +
> >> +struct lirc_rx51 {
> >> +	struct omap_dm_timer *pwm_timer;
> >> +	struct omap_dm_timer *pulse_timer;
> >> +	struct device	     *dev;
> >> +	struct lirc_rx51_platform_data *pdata;
> >> +	wait_queue_head_t     wqueue;
> >> +
> >> +	unsigned long	fclk_khz;
> >> +	unsigned int	freq;		/* carrier frequency */
> >> +	unsigned int	duty_cycle;	/* carrier duty cycle */
> >> +	unsigned int	irq_num;
> >> +	unsigned int	match;
> 
> And I just noticed this match variable has absolutely no useful purpose
> at all..
> 
> >> +	int		wbuf[WBUF_LEN];
> >> +	int		wbuf_index;
> >> +	unsigned long	device_is_open;
> >> +	unsigned int	pwm_timer_num;
> > 
> > pwm_timer is signed in platform data. Shouldn't this one be as well?
> > 
> 
> Yes, it should.
> 
> >> +};
> >> +
> >> +static void lirc_rx51_on(struct lirc_rx51 *lirc_rx51)
> >> +{
> >> +	omap_dm_timer_set_pwm(lirc_rx51->pwm_timer, 0, 1,
> >> +			      OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE);
> >> +}
> >> +
> >> +static void lirc_rx51_off(struct lirc_rx51 *lirc_rx51)
> >> +{
> >> +	omap_dm_timer_set_pwm(lirc_rx51->pwm_timer, 0, 1,
> >> +			      OMAP_TIMER_TRIGGER_NONE);
> >> +}
> >> +
> >> +static int init_timing_params(struct lirc_rx51 *lirc_rx51)
> >> +{
> >> +	u32 load, match;
> >> +
> >> +	load = -(lirc_rx51->fclk_khz * 1000 / lirc_rx51->freq);
> >> +	match = -(lirc_rx51->duty_cycle * -load / 100);
> >> +	omap_dm_timer_set_load(lirc_rx51->pwm_timer, 1, load);
> >> +	omap_dm_timer_set_match(lirc_rx51->pwm_timer, 1, match);
> >> +	omap_dm_timer_write_counter(lirc_rx51->pwm_timer, TIMER_MAX_VALUE - 2);
> >> +	omap_dm_timer_start(lirc_rx51->pwm_timer);
> >> +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> >> +	omap_dm_timer_start(lirc_rx51->pulse_timer);
> >> +
> >> +	lirc_rx51->match = 0;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +#define tics_after(a, b) ((long)(b) - (long)(a) < 0)
> >> +
> >> +static int pulse_timer_set_timeout(struct lirc_rx51 *lirc_rx51, int usec)
> >> +{
> >> +	int counter;
> > 
> > Shouldn't counter be unsigned int?
> > 
> 
> Actually no. From here..
> 
> >> +	BUG_ON(usec < 0);
> >> +
> >> +	if (lirc_rx51->match == 0)
> >> +		counter = omap_dm_timer_read_counter(lirc_rx51->pulse_timer);
> >> +	else
> >> +		counter = lirc_rx51->match;
> >> +
> >> +	counter += (u32)(lirc_rx51->fclk_khz * usec / (1000));
> >> +	omap_dm_timer_set_match(lirc_rx51->pulse_timer, 1, counter);
> >> +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer,
> >> +				     OMAP_TIMER_INT_MATCH);
> 
> ..to here the sign doesn't count.
> 
> >> +	if (tics_after(omap_dm_timer_read_counter(lirc_rx51->pulse_timer),
> >> +		       counter)) {
> > 
> > Do you really need the macro and the casting to long it does? You could
> > replace this with
> > 
> > return (int)(omap_dm_timer_read_counter(lirc_rx51->pulse_timer) - counter) < 0;
> > 
> 
> But here we need the types to be signed so that the comparison can
> become negative. And we can't just test whether counter variable is less
> than the timer counter as those can overflow quite rapidly..
> 
> I'll have it this way:
> 
> > 	int counter, counter_now;
> > 
> [snip]
> > 
> > 	counter_now = omap_dm_timer_read_counter(lirc_rx51->pulse_timer);
> > 	return (counter_now - counter) < 0;
> 
> ..which I hope should be quite readable, at least compared to the
> original code.

Looks good to me.

> >> +		return 1;
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static irqreturn_t lirc_rx51_interrupt_handler(int irq, void *ptr)
> >> +{
> >> +	unsigned int retval;
> >> +	struct lirc_rx51 *lirc_rx51 = ptr;
> >> +
> >> +	retval = omap_dm_timer_read_status(lirc_rx51->pulse_timer);
> >> +	if (!retval)
> >> +		return IRQ_NONE;
> >> +
> >> +	if ((retval & ~OMAP_TIMER_INT_MATCH))
> > 
> > Unneeded parenthesis.
> > 
> 
> Extra parenthesis removed.
> 
> >> +		dev_err_ratelimited(lirc_rx51->dev,
> >> +				": Unexpected interrupt source: %x\n", retval);
> >> +
> >> +	omap_dm_timer_write_status(lirc_rx51->pulse_timer, 7);
> > 
> > What does "7" actually signify?
> > 
> 
> I had to browse through the TRM to figure out what I had in my mind back
> then. Apparently I just wanted to ensure all possible IRQ flags were
> cleared from the interrupt status register. It shouldn't happen that
> there are anything else than the match bit set, but I'm just being
> overly cautious. I'll replace that magic seven with this:
> 
> 	omap_dm_timer_write_status(lirc_rx51->pulse_timer,
> 				OMAP_TIMER_INT_MATCH	|
> 				OMAP_TIMER_INT_OVERFLOW	|
> 				OMAP_TIMER_INT_CAPTURE);

Much more readable! Thanks.

> >> +	if (lirc_rx51->wbuf_index < 0) {
> >> +		dev_err_ratelimited(lirc_rx51->dev,
> >> +				": BUG wbuf_index has value of %i\n",
> >> +				lirc_rx51->wbuf_index);
> >> +		goto end;
> >> +	}
> >> +
> >> +	/*
> >> +	 * If we happen to hit an odd latency spike, loop through the
> >> +	 * pulses until we catch up.
> >> +	 */
> >> +	do {
> >> +		if (lirc_rx51->wbuf_index >= WBUF_LEN)
> >> +			goto end;
> >> +		if (lirc_rx51->wbuf[lirc_rx51->wbuf_index] == -1)
> >> +			goto end;
> >> +
> >> +		if (lirc_rx51->wbuf_index % 2)
> >> +			lirc_rx51_off(lirc_rx51);
> >> +		else
> >> +			lirc_rx51_on(lirc_rx51);
> >> +
> >> +		retval = pulse_timer_set_timeout(lirc_rx51,
> >> +					lirc_rx51->wbuf[lirc_rx51->wbuf_index]);
> >> +		lirc_rx51->wbuf_index++;
> >> +
> >> +	} while (retval);
> >> +
> >> +	return IRQ_HANDLED;
> >> +end:
> >> +	/* Stop TX here */
> >> +	lirc_rx51_off(lirc_rx51);
> >> +	lirc_rx51->wbuf_index = -1;
> >> +	omap_dm_timer_stop(lirc_rx51->pwm_timer);
> >> +	omap_dm_timer_stop(lirc_rx51->pulse_timer);
> >> +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> >> +	wake_up_interruptible(&lirc_rx51->wqueue);
> >> +
> >> +	return IRQ_HANDLED;
> >> +}
> >> +
> >> +static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
> >> +{
> >> +	struct clk *clk_fclk;
> >> +	int retval, pwm_timer = lirc_rx51->pwm_timer_num;
> >> +
> >> +	lirc_rx51->pwm_timer = omap_dm_timer_request_specific(pwm_timer);
> >> +	if (lirc_rx51->pwm_timer == NULL) {
> >> +		dev_err(lirc_rx51->dev, ": Error requesting GPT%d timer\n",
> >> +			pwm_timer);
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	lirc_rx51->pulse_timer = omap_dm_timer_request();
> >> +	if (lirc_rx51->pulse_timer == NULL) {
> >> +		dev_err(lirc_rx51->dev, ": Error requesting pulse timer\n");
> >> +		retval = -EBUSY;
> >> +		goto err1;
> >> +	}
> >> +
> >> +	omap_dm_timer_set_source(lirc_rx51->pwm_timer, OMAP_TIMER_SRC_SYS_CLK);
> >> +	omap_dm_timer_set_source(lirc_rx51->pulse_timer,
> >> +				OMAP_TIMER_SRC_SYS_CLK);
> >> +
> >> +	omap_dm_timer_enable(lirc_rx51->pwm_timer);
> >> +	omap_dm_timer_enable(lirc_rx51->pulse_timer);
> >> +
> >> +	lirc_rx51->irq_num = omap_dm_timer_get_irq(lirc_rx51->pulse_timer);
> >> +	retval = request_irq(lirc_rx51->irq_num, lirc_rx51_interrupt_handler,
> >> +			     IRQF_DISABLED | IRQF_SHARED,
> >> +			     "lirc_pulse_timer", lirc_rx51);
> >> +	if (retval) {
> >> +		dev_err(lirc_rx51->dev, ": Failed to request interrupt line\n");
> >> +		goto err2;
> >> +	}
> >> +
> >> +	clk_fclk = omap_dm_timer_get_fclk(lirc_rx51->pwm_timer);
> >> +	lirc_rx51->fclk_khz = clk_fclk->rate / 1000;
> >> +
> >> +	return 0;
> >> +
> >> +err2:
> >> +	omap_dm_timer_free(lirc_rx51->pulse_timer);
> >> +err1:
> >> +	omap_dm_timer_free(lirc_rx51->pwm_timer);
> >> +
> >> +	return retval;
> >> +}
> >> +
> >> +static int lirc_rx51_free_port(struct lirc_rx51 *lirc_rx51)
> >> +{
> >> +	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
> >> +	free_irq(lirc_rx51->irq_num, lirc_rx51);
> >> +	lirc_rx51_off(lirc_rx51);
> >> +	omap_dm_timer_disable(lirc_rx51->pwm_timer);
> >> +	omap_dm_timer_disable(lirc_rx51->pulse_timer);
> >> +	omap_dm_timer_free(lirc_rx51->pwm_timer);
> >> +	omap_dm_timer_free(lirc_rx51->pulse_timer);
> >> +	lirc_rx51->wbuf_index = -1;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static ssize_t lirc_rx51_write(struct file *file, const char *buf,
> >> +			  size_t n, loff_t *ppos)
> >> +{
> >> +	int count, i;
> >> +	struct lirc_rx51 *lirc_rx51 = file->private_data;
> >> +
> >> +	if (n % sizeof(int))
> >> +		return -EINVAL;
> >> +
> >> +	count = n / sizeof(int);
> >> +	if ((count > WBUF_LEN) || (count % 2 == 0))
> >> +		return -EINVAL;
> >> +
> >> +	/* Wait any pending transfers to finish */
> >> +	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
> >> +
> >> +	if (copy_from_user(lirc_rx51->wbuf, buf, n))
> >> +		return -EFAULT;
> >> +
> >> +	/* Sanity check the input pulses */
> >> +	for (i = 0; i < count; i++)
> >> +		if (lirc_rx51->wbuf[i] < 0)
> >> +			return -EINVAL;
> >> +
> >> +	init_timing_params(lirc_rx51);
> >> +	if (count < WBUF_LEN)
> >> +		lirc_rx51->wbuf[count] = -1; /* Insert termination mark */
> >> +
> >> +	/*
> >> +	 * Adjust latency requirements so the device doesn't go in too
> >> +	 * deep sleep states
> >> +	 */
> >> +	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, 50);
> >> +
> >> +	lirc_rx51_on(lirc_rx51);
> >> +	lirc_rx51->wbuf_index = 1;
> >> +	pulse_timer_set_timeout(lirc_rx51, lirc_rx51->wbuf[0]);
> >> +
> >> +	/*
> >> +	 * Don't return back to the userspace until the transfer has
> >> +	 * finished
> >> +	 */
> >> +	wait_event_interruptible(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0);
> >> +
> >> +	/* We can sleep again */
> >> +	lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, -1);
> >> +
> >> +	return n;
> >> +}
> >> +
> >> +static long lirc_rx51_ioctl(struct file *filep,
> >> +			unsigned int cmd, unsigned long arg)
> >> +{
> >> +	int result;
> >> +	unsigned long value;
> >> +	unsigned int ivalue;
> >> +	struct lirc_rx51 *lirc_rx51 = filep->private_data;
> >> +
> >> +	switch (cmd) {
> >> +	case LIRC_GET_SEND_MODE:
> >> +		result = put_user(LIRC_MODE_PULSE, (unsigned long *)arg);
> >> +		if (result)
> >> +			return result;
> >> +		break;
> >> +
> >> +	case LIRC_SET_SEND_MODE:
> >> +		result = get_user(value, (unsigned long *)arg);
> >> +		if (result)
> >> +			return result;
> >> +
> >> +		/* only LIRC_MODE_PULSE supported */
> >> +		if (value != LIRC_MODE_PULSE)
> >> +			return -ENOSYS;
> >> +		break;
> >> +
> >> +	case LIRC_GET_REC_MODE:
> >> +		result = put_user(0, (unsigned long *) arg);
> >> +		if (result)
> >> +			return result;
> >> +		break;
> >> +
> >> +	case LIRC_GET_LENGTH:
> >> +		return -ENOSYS;
> >> +		break;
> >> +
> >> +	case LIRC_SET_SEND_DUTY_CYCLE:
> >> +		result = get_user(ivalue, (unsigned int *) arg);
> >> +		if (result)
> >> +			return result;
> >> +
> >> +		if (ivalue <= 0 || ivalue > 100) {
> >> +			dev_err(lirc_rx51->dev, ": invalid duty cycle %d\n",
> >> +				ivalue);
> >> +			return -EINVAL;
> >> +		}
> >> +
> >> +		lirc_rx51->duty_cycle = ivalue;
> >> +		break;
> >> +
> >> +	case LIRC_SET_SEND_CARRIER:
> >> +		result = get_user(ivalue, (unsigned int *) arg);
> >> +		if (result)
> >> +			return result;
> >> +
> >> +		if (ivalue > 500000 || ivalue < 20000) {
> >> +			dev_err(lirc_rx51->dev, ": invalid carrier freq %d\n",
> >> +				ivalue);
> >> +			return -EINVAL;
> >> +		}
> >> +
> >> +		lirc_rx51->freq = ivalue;
> >> +		break;
> >> +
> >> +	case LIRC_GET_FEATURES:
> >> +		result = put_user(LIRC_RX51_DRIVER_FEATURES,
> >> +				  (unsigned long *) arg);
> >> +		if (result)
> >> +			return result;
> >> +		break;
> >> +
> >> +	default:
> >> +		return -ENOIOCTLCMD;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int lirc_rx51_open(struct inode *inode, struct file *file)
> >> +{
> >> +	struct lirc_rx51 *lirc_rx51 = lirc_get_pdata(file);
> >> +	BUG_ON(!lirc_rx51);
> > 
> > BUG_ON() here seems a little harsh. I'd remove it and check platform data in
> > probe() instead --- which isn't done btw.
> > 
> 
> I'll move the check there and make it return -ENODEV in case platform
> data is missing.

Ack.

> >> +
> >> +	file->private_data = lirc_rx51;
> >> +
> >> +	if (test_and_set_bit(1, &lirc_rx51->device_is_open))
> >> +		return -EBUSY;
> >> +
> >> +	return lirc_rx51_init_port(lirc_rx51);
> >> +}
> >> +
> >> +static int lirc_rx51_release(struct inode *inode, struct file *file)
> >> +{
> >> +	struct lirc_rx51 *lirc_rx51 = file->private_data;
> >> +
> >> +	lirc_rx51_free_port(lirc_rx51);
> >> +
> >> +	clear_bit(1, &lirc_rx51->device_is_open);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static struct lirc_rx51 lirc_rx51 = {
> >> +	.freq		= 38000,
> >> +	.duty_cycle	= 50,
> >> +	.wbuf_index	= -1,
> >> +};
> >> +
> >> +static const struct file_operations lirc_fops = {
> >> +	.owner		= THIS_MODULE,
> >> +	.write		= lirc_rx51_write,
> >> +	.unlocked_ioctl	= lirc_rx51_ioctl,
> >> +	.read		= lirc_dev_fop_read,
> >> +	.poll		= lirc_dev_fop_poll,
> >> +	.open		= lirc_rx51_open,
> >> +	.release	= lirc_rx51_release,
> >> +};
> >> +
> >> +static struct lirc_driver lirc_rx51_driver = {
> >> +	.name		= DRIVER_NAME,
> >> +	.minor		= -1,
> >> +	.code_length	= 1,
> >> +	.data		= &lirc_rx51,
> >> +	.fops		= &lirc_fops,
> >> +	.owner		= THIS_MODULE,
> >> +};
> > 
> > Could you allocate lirc_driver and lirc_rx51 dynamically instead? I guess
> > no-one is going to add a second IR transmitter to RX-51 but as noted
> > earlier, the driver is more generic than that.
> > 
> 
> hmm.. I wonder if it makes any sense at all to have multiple IR
> transmitter diodes acting as independent transmitters. Thinking about
> the interference.. But, yes, I guess there is no technical limitation so
> why not..
> 
> >> +#ifdef CONFIG_PM
> >> +
> >> +static int lirc_rx51_suspend(struct platform_device *dev, pm_message_t state)
> >> +{
> >> +	/*
> >> +	 * In case the device is still open, do not suspend. Normally
> >> +	 * this should not be a problem as lircd only keeps the device
> >> +	 * open only for short periods of time. We also don't want to
> >> +	 * get involved with race conditions that might happen if we
> >> +	 * were in a middle of a transmit. Thus, we defer any suspend
> >> +	 * actions until transmit has completed.
> >> +	 */
> >> +	if (test_and_set_bit(1, &lirc_rx51.device_is_open))
> >> +		return -EAGAIN;
> >> +
> >> +	clear_bit(1, &lirc_rx51.device_is_open);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int lirc_rx51_resume(struct platform_device *dev)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +#else
> >> +
> >> +#define lirc_rx51_suspend	NULL
> >> +#define lirc_rx51_resume	NULL
> >> +
> >> +#endif /* CONFIG_PM */
> >> +
> >> +static int __devinit lirc_rx51_probe(struct platform_device *dev)
> >> +{
> >> +	lirc_rx51_driver.features = LIRC_RX51_DRIVER_FEATURES;
> >> +	lirc_rx51.pdata = dev->dev.platform_data;
> >> +	lirc_rx51.pwm_timer_num = lirc_rx51.pdata->pwm_timer;
> >> +	lirc_rx51.dev = &dev->dev;
> >> +	lirc_rx51_driver.dev = &dev->dev;
> >> +	lirc_rx51_driver.minor = lirc_register_driver(&lirc_rx51_driver);
> >> +	init_waitqueue_head(&lirc_rx51.wqueue);
> >> +
> >> +	if (lirc_rx51_driver.minor < 0) {
> >> +		dev_err(lirc_rx51.dev, ": lirc_register_driver failed: %d\n",
> >> +		       lirc_rx51_driver.minor);
> >> +		return lirc_rx51_driver.minor;
> >> +	}
> >> +	dev_info(lirc_rx51.dev, "registration ok, minor: %d, pwm: %d\n",
> >> +		 lirc_rx51_driver.minor, lirc_rx51.pwm_timer_num);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int __exit lirc_rx51_remove(struct platform_device *dev)
> >> +{
> >> +	return lirc_unregister_driver(lirc_rx51_driver.minor);
> >> +}
> >> +
> >> +struct platform_driver lirc_rx51_platform_driver = {
> >> +	.probe		= lirc_rx51_probe,
> >> +	.remove		= __exit_p(lirc_rx51_remove),
> >> +	.suspend	= lirc_rx51_suspend,
> >> +	.resume		= lirc_rx51_resume,
> >> +	.remove		= __exit_p(lirc_rx51_remove),
> >> +	.driver		= {
> >> +		.name	= DRIVER_NAME,
> >> +		.owner	= THIS_MODULE,
> >> +	},
> >> +};
> >> +
> >> +static int __init lirc_rx51_init(void)
> >> +{
> >> +	return platform_driver_register(&lirc_rx51_platform_driver);
> >> +}
> >> +module_init(lirc_rx51_init);
> >> +
> >> +static void __exit lirc_rx51_exit(void)
> >> +{
> >> +	platform_driver_unregister(&lirc_rx51_platform_driver);
> >> +}
> >> +module_exit(lirc_rx51_exit);
> > 
> > You could use module_platform_driver macro.
> > 
> >> +MODULE_DESCRIPTION("LIRC TX driver for Nokia RX51");
> >> +MODULE_AUTHOR("Nokia Corporation");
> >> +MODULE_LICENSE("GPL");
> >> diff --git a/include/media/ir-rx51.h b/include/media/ir-rx51.h
> >> new file mode 100644
> >> index 0000000..104aa89
> >> --- /dev/null
> >> +++ b/include/media/ir-rx51.h
> >> @@ -0,0 +1,10 @@
> >> +#ifndef _LIRC_RX51_H
> >> +#define _LIRC_RX51_H
> >> +
> >> +struct lirc_rx51_platform_data {
> >> +	int pwm_timer;
> >> +
> >> +	int(*set_max_mpu_wakeup_lat)(struct device *dev, long t);
> > 
> > Could we call directly omap_pm_set_max_mpu_wakeup_lat() instead of having a
> > pointer in the platform data? The issue with that, however, is that the
> > function isn't exported to modules, forcing to link ir-rx51 into the kernel
> > directly.
> > 
> 
> It was an requirement back then that this driver needs to be a module as
> 99% of the N900 owners still don't even know they have this kind of
> capability on their devices, so it doesn't make sense to keep the module
> loaded unless the user actually needs it.

I don't think that's so important --- currently the vast majority of the
N900 users using the mainline kernel compile it themselves. It's more
important to have a clean implementation at this point.

> > The board code has to be converted to device tree anyway and I don't think
> > we can have pointers to the kernel binary there. You may also get a NAK on
> > patches adding new things to board code files.
> > 
> > One example of how to do this is arch/arm/plat-omap/i2c.c .
> > 
> > I think that the OMAP 3 ISP suffers from exactly the same issue of not being
> > able to wake up the MPU. For the ISP it's been handled here:
> > 
> > 	arch/arm/mach-omap2/cpuidle34xx.c
> > 
> > Look for "CAM". I wonder if we should / could do something similar for DM
> > timers.
> > 
> > The discussion on the issue with the ISP is here:
> > 
> > <URL:http://www.spinics.net/lists/linux-omap/msg63736.html>
> > 
> 
> That is something I will take a closer look at.
> 
> Thanks for the very good comments!

You're welcome! :)

Terveisin,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
