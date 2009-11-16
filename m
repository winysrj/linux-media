Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4302 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZKPVo0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 16:44:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 3/4 v7] TVP7002 driver for DM365
Date: Mon, 16 Nov 2009 22:44:09 +0100
Cc: "santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"diego.dompe@ridgerun.com" <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"Grosen, Mark" <mgrosen@ti.com>
References: <1257889836-19208-1-git-send-email-santiago.nunez@ridgerun.com> <200911151416.00674.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE401559C558C@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401559C558C@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911162244.09409.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 November 2009 19:33:19 Karicheri, Muralidharan wrote:
> Hans,
> 
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/*
> >> + * tvp7002_s_stream() - V4L2 decoder i/f handler for s_stream
> >> + * @sd: pointer to standard V4L2 sub-device structure
> >> + * @enable: streaming enable or disable
> >> + *
> >> + * Sets streaming to enable or disable, if possible.
> >> + */
> >> +static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
> >> +{
> >> +	struct tvp7002 *device = to_tvp7002(sd);
> >> +	int error = 0;
> >> +
> >> +	if (device->streaming == enable)
> >> +		return 0;
> >> +
> >> +	if (enable) {
> >> +		/* Set output state on (low impedance means stream on) */
> >> +		device->registers[TVP7002_MISC_CTL_2].value = 0x00;
> >> +		/* Power off chip */
> >> +		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x7f);
> >> +		if (error) {
> >> +			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
> >> +			error = -EINVAL;
> >> +		}
> >> +		/* Power on chip */
> >> +		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x00);
> >> +		if (error) {
> >> +			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
> >> +			return error;
> >> +		}
> >> +		/* Re-set register values with stored ones */
> >> +		error = tvp7002_write_inittab(sd, device->registers);
> >
> >I still think that this register storing code sucks.
> 
> I think Santiago based his driver on tvp514x which doesn't update the register until the chip is ready to stream. Only when STREAMON is called
> the chip is powered On and the register values are configured. This looks
> perfectly fine to me ( For example due to power savings considerations).
> So please elaborate why you think this is not right. IMO, keeping the driver design similar to TVP514x helps in understanding the driver better. So unless you see a serious design flaw with this approach, I wouldn't change
> the code.
> 
> I would like Vaibhav's opinion as well since he is the owner of TVP514x
> driver.

OK, I took a closer look at both tvp5147 and tvp7002 and also went through the
datasheets. As far as I am concerned both drivers are very weird...

In both cases the devices start up in fully powered mode. Only the tvp514x
will be powered off if s_stream(false) is called, but that happens only after
streaming has started first. I would expect it to start up in powersaving mode,
otherwise it's rather pointless. And going in powersaving will preserve all
register values on both devices as far as I can tell from the datasheets. So
why rewrite the registers again? Frankly, I see no reason why tvp514x uses the
tvp514x_regs array.

And in the case of the tvp7002 I see no mention in the datasheet why you would
need to power down and up in quick succession when you start streaming. Or why
that would reset all registers for that matter since the i2c part always remains
up.

So I see this disconnect between what the drivers are doing and what I read in
the datasheets. Perhaps there is some errata sheet or appnote somewhere that I
don't know about, and in that case the drivers need to point to it or describe
what is going on since right now it makes no sense to me.

In general keeping shadow registers is bad coding practice. The only case I
know where that is valid is with write-only registers. And that only tends to
appear in really, really low-end devices.

Actually, I tried to find examples of that, but the only two write-only devices
I could find (wm8775.c and wm8739.c) were rewritten to avoid having to keep
shadow registers.

In all other devices I know of the i2c registers are never reset, so you can
just configure them directly. Even if the i2c registers are reset at some point,
then it is much better to just reconfigure the device by re-initializing the
registers and updating them based on the configuration (e.g. preset and gain in
the case of the tvp7002) stored in the driver state struct.

You need to have functions to set the preset/gain/whatever anyway, so just call
them again.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
