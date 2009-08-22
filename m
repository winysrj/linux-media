Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2547 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZHVHmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 03:42:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: [RFC] v4l2_subdev_ir_ops
Date: Sat, 22 Aug 2009 09:42:16 +0200
Cc: linux-media@vger.kernel.org
References: <1250906940.3159.20.camel@palomino.walls.org>
In-Reply-To: <1250906940.3159.20.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908220942.16919.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 22 August 2009 04:09:00 Andy Walls wrote:
> In the course of implementing code to run the Consumer IR circuitry in
> the CX2584[0123] chip and similar cores, I need to add
> v4l2_subdev_ir_ops for manipulating the device and fetch and send data.
>
> In line below is a proposal at what I think those subdev ops might be.
> Feel free to take shots at it.
>
> The insipration for these comes from two sources, the LIRC v0.8.5 source
> code and what the CX2584x chip is capable of doing:
>
> http://prdownloads.sourceforge.net/lirc/lirc-0.8.5.tar.bz2
> http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf
>
> Note the Consumer IR in the CX2584x can theoretically measure
> unmodulated marks and spaces with a resolution of 37.037... ns (1/27
> MHz), hence the references to nanoseconds in the proposal below.  Most
> IR devices use pulses on the order of microseconds in real life.

Hi Andy,

My first impressions are that you are trying to do too much here. What you 
want is a simple API to access an IR transmitter or receiver. These devices 
do not care about lirc or any other high-level APIs. All they need 
basically are a setup command and read/write commands. There is probably no 
need for querying capabilities since the flow of information in V4L2 is 
usually the other way around:

if you know the card, then you know the remote, then you know the settings, 
then you can tell the IR module. Based on just the IR module you cannot 
know what the IR timings/modulation etc. will be.

If there is a demonstrable need to get some capabilities for lirc, then I 
would also suggest to combine them all into one g_caps call that returns 
all caps in a struct. Much easier than breaking it all up in small 
functions.

Don't use is_ns BTW, just do everything in ns. I don't see any problem with 
that.

Making a set of ops for IR support is a very good idea, but I think you need 
to actually implement and use it in a driver first. Just the plain act of 
implementing something will show you what the strenghts and weaknesses of 
an API are and will help you prototype a better solution.

Remember that this subdev API is an internal API. It was *designed* for 
change. So it is perfectly reasonable to start off with a subset and extend 
and modify it over time. What I do not want to see are unused ops. So 
everything in there also has to be used somewhere (or known to be used very 
soon).

Regarding interrupt handlers: there is a notify callback in v4l2_device that 
could be used for that purpose as well, rather than setting up separate 
callback functions. Whether that's a good idea or not depends on the way it 
will actually be used. So when you are working on actual code you can try 
each approach and see which works best.

Regards,

	Hans

>
> Regards,
> Andy
>
> diff -r 44282114d1e3 linux/include/media/v4l2-subdev.h
> --- a/linux/include/media/v4l2-subdev.h	Fri Aug 21 13:26:01 2009 -0400
> +++ b/linux/include/media/v4l2-subdev.h	Fri Aug 21 21:51:52 2009 -0400
> @@ -229,11 +229,206 @@
>  	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
> v4l2_frmivalenum *fival); };
>
> +/*
> +   interrupt_service_routine: Called by the bridge chip's interrupt
> service +	handler, when an IR interrupt status has be raised due to this
> subdev, +	so that this subdev can handle the details.  It may schedule
> work to be +	performed later.  It must not sleep.  *Called from an IRQ
> context*. +
> +   g_features: Return IR features supported by this device.  Intended to
> be +	used to support the LIRC_GET_FEATURES ioctl() and to return the same
> +	flags.
> +
> +   g_code_length: Return the cooked IR code length.  Intended to be used
> to +	support the LIRC_GET_LENGTH ioctl(), returning the length of a code
> +	in bits.  Currently only used in lirc for the LIRC_MODE_LIRCCODE. +
> +   [rt]x_s_notify_callback: Allows the subdev caller to set a callback
> for +	notification of events due to the IR recevier or transmitter.
> +
> +   rx_read_pulse_widths: Reads received data in the form of consective
> space and +	mark pulse widths in microseconds, or nanoseconds if in_ns is
> true.  The +	semantics are similar to a non-blocking read() call.
> +
> +   tx_write_pulse_widths: Reads received data in the form of consective
> mark and +	space pulse widths in microseconds, or nanoseconds if in_ns is
> true. +	The semantics are similar to a non-blocking write() call.
> +
> +   rx_read: Reads received codes or other non-pulse width data.
> +	The semantics are similar to a non-blocking read() call.
> +
> +   tx_write: Writes codes or other non-pulse width data to transmit.
> +	The semantics are similar to a non-blocking write() call.
> +
> +   [rt]x_enable: enable or disable the receiver or transmitter using or
> +	preserving the current setting.
> +
> +   [rt]x_shutdown: disable the receiver or transmitter and adjust all
> setting +	to shut off or slow down hardware and disable interrupts.
> +
> +   [rt]x_s_interrupt_enable: enable or diable the receiver or
> transmitter +	interrupts.
> +
> +   rx_s_demodulation: enable demodulation of received pulses from a
> carrier or +	disable demodulation and read "baseband" light pulses.
> +
> +   rx_g_demodulation: query if demodulation of received pulses from a
> carrier is +	enabled.
> +
> +   tx_s_modulation: enable modulation of transmitted pulses onto a
> carrier or +	disable modulation and transmit "baseband" light pulses.
> +
> +   tx_g_modulation: query if modulation of transmitted pulses onto a
> carrier is +	enabled.
> +
> +   rx_s_noise_filter: set the threshold pulse width for a received pulse
> to be +	considered valid and not a glitch or noise.  A value of 0
> disables the +	noise filter.
> +
> +   rx_g_noise_filter: query the threshold pulse width for a received
> pulse to be +	considered valid and not a glitch or noise.  A value of 0
> means the +	noise filter is disabled.
> +
> +   [rt]x_s_max_pulse_width: sets the max valid pulse width expected to
> be +	received or transmitted, when receiving or transmitting baseband
> pulses, +	in order to optimize the pulse width timer's resolution.  This
> call will +	likely have the side effect of disabling
> demodulation/modulation of +	pulses from/onto a carrier.
> +
> +   [rt]x_g_max_pulse_width: gets the max valid pulse width expected to
> be +	received or transmitted, when receiving or transmitting baseband
> pulses. +	This call should return error if demodulation/modulation of
> +	pulses from/onto a carrier is enabled.
> +
> +   [rt]x_[sg]_lirc_mode: Set or get the LIRC "mode" for the receiver or
> +	transmitter.  Intended to support the LIRC_{SET,GET}_{REC,SEND}_MODE
> +	ioctl() calls.
> +
> +   [rt]x_[sg]_carrier: Set or get the carrier frequency for the receiver
> or +	transmitter.  Frequency is in Hz.  Hardware limitations may
> +	mean the actual frequency set varies from the desired frequency.  The
> +	_g_ calls should return the precise frequency set.  The _s_ calls will
> +	have the side effect of enabling demodulation/modulation when the
> +	freq is not 0, and disabling demodulation/modulation when the
> +	freq is 0.  These calls can also be used to support the
> +	LIRC_{SET,GET}_{REC,SEND}_CARRIER ioctl() calls.
> +
> +   rx_s_carrier_range: Set a window of expected carrier frequencies for
> the +	receiver.  Intended to support the LIRC_SET_REC_CARRIER_RANGE
> ioctl(). +	Due to hardware limitations, the full range may not be
> supportable and +	the center of the supportable range may not be at the
> exact center of +	the desired range.
> +
> +   [rt]x_[sg]_duty_cycle: Set or get the carrier duty cycle for the
> receiver or +	transmitter.  Hardware limitations may mean the actual duty
> cycle set +	varies from the desired duty_cycle.  The _g_ calls should
> return the +	precise duty cycle set.  These calls can also be used to
> +	support the LIRC_{SET,GET}_{REC,SEND}_DUTY_CYCLE ioctl() calls.
> +
> +   rx_s_duty_cycle_range: Set a window of expected received carrier duty
> cycles +	Intended to support the LIRC_SET_REC_DUTY_CYCLE_RANGE ioctl().
> +	Due to hardware limitations, the full range may not be supportable and
> +	the center of the supportable range may not be at the exact center of
> +	the desired range.
> +
> +   rx_g_resolution: get the pulse measurment resolution of the receiver.
> +	Intended to support the LIRC_GET_REC_RESOLUTION ioctl().
> +
> +   tx_s_mask: set the mask of enabled transmitters for devices that have
> +	more than one trasnmitter.  Intended to support the
> +	LIRC_SET_TRANSMITTER_MASK ioctl().
> + */
> +enum v4l2_subdev_ir_event {
> +	V4L2_SUBDEV_IR_RX_DATA_READY     = 0,
> +	V4L2_SUBDEV_IR_TX_READY_FOR_DATA = 1,
> +};
> +
> +typedef int (*v4l2_subdev_ir_notify_callback)(void *priv,
> +					      struct v4l2_subdev *sd,
> +					      enum v4l2_subdev_ir_event event);
> +
> +struct v4l2_subdev_ir_ops {
> +	/* Common to receiver and transmitter */
> +	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
> +						u32 status, bool *handled);
> +
> +	/* LIRC ioctl inspired calls */
> +	int (*g_features)(struct v4l2_subdev *sd, u32 *features);
> +	int (*g_code_length)(struct v4l2_subdev *sd, u32 *bits);
> +
> +	/* Receiver */
> +	int (*rx_s_notify_callback)(struct v4l2_subdev *sd,
> +					v4l2_subdev_ir_notify_callback callback,
> +					void *priv);
> +
> +	int (*rx_read_pulse_widths)(struct v4l2_subdev *sd, u32 *widths,
> +					size_t count, bool in_ns, ssize_t *num);
> +	int (*rx_read)(struct v4l2_subdev *sd, u8 *buf, size_t count,
> +				ssize_t *num);
> +
> +	int (*rx_enable)(struct v4l2_subdev *sd, bool enable);
> +	int (*rx_shutdown)(struct v4l2_subdev *sd);
> +
> +	int (*rx_s_interrupt_enable)(struct v4l2_subdev *sd, bool enable);
> +	int (*rx_s_demodulation)(struct v4l2_subdev *sd, bool enable);
> +	int (*rx_s_noise_filter)(struct v4l2_subdev *sd, u32 min_width_ns);
> +	int (*rx_s_max_pulse_width)(struct v4l2_subdev *sd, u64 max_width_ns);
> +
> +	int (*rx_g_demodulation)(struct v4l2_subdev *sd, bool *enabled);
> +	int (*rx_g_noise_filter)(struct v4l2_subdev *sd, u32 *min_width_ns);
> +	int (*rx_g_max_pulse_width)(struct v4l2_subdev *sd, u64 *max_width_ns);
> +
> +	/* LIRC receiver ioctl inspired calls */
> +	int (*rx_s_lirc_mode)(struct v4l2_subdev *sd, u32 mode);
> +	int (*rx_s_carrier)(struct v4l2_subdev *sd, u32 freq);
> +	int (*rx_s_carrier_range)(struct v4l2_subdev *sd,
> +					u32 lower, u32 upper);
> +	int (*rx_s_duty_cycle)(struct v4l2_subdev *sd, u32 duty_cycle);
> +	int (*rx_s_duty_cycle_range)(struct v4l2_subdev *sd,
> +					u32 lower, u32 upper);
> +
> +	int (*rx_g_lirc_mode)(struct v4l2_subdev *sd, u32 *mode);
> +	int (*rx_g_carrier)(struct v4l2_subdev *sd, u32 *freq);
> +	int (*rx_g_duty_cycle)(struct v4l2_subdev *sd, u32 *duty_cycle);
> +	int (*rx_g_resolution)(struct v4l2_subdev *sd, u32 *nsec);
> +
> +	/* Transmitter */
> +	int (*tx_s_notify_callback)(struct v4l2_subdev *sd,
> +					v4l2_subdev_ir_notify_callback callback,
> +					void *priv);
> +
> +	int (*tx_write_pulse_widths)(struct v4l2_subdev *sd, u32 *widths,
> +					size_t count, bool in_ns, ssize_t *num);
> +	int (*tx_write)(struct v4l2_subdev *sd, u8 *buf, size_t count,
> +				ssize_t *num);
> +
> +	int (*tx_enable)(struct v4l2_subdev *sd, bool enable);
> +	int (*tx_shutdown)(struct v4l2_subdev *sd);
> +
> +	int (*tx_s_interrupt_enable)(struct v4l2_subdev *sd, bool enable);
> +	int (*tx_s_modulation)(struct v4l2_subdev *sd, bool enable);
> +	int (*tx_s_max_pulse_width)(struct v4l2_subdev *sd, u64 max_width_ns);
> +
> +	int (*tx_g_modulation)(struct v4l2_subdev *sd, bool *enabled);
> +	int (*tx_g_max_pulse_width)(struct v4l2_subdev *sd, u64 *max_width_ns);
> +
> +	/* LIRC transmitter ioctl inspired calls */
> +	int (*tx_s_lirc_mode)(struct v4l2_subdev *sd, u32 mode);
> +	int (*tx_s_carrier)(struct v4l2_subdev *sd, u32 freq);
> +	int (*tx_s_duty_cycle)(struct v4l2_subdev *sd, u32 duty_cycle);
> +	int (*tx_s_mask)(struct v4l2_subdev *sd, u32 enabled_transmitters);
> +
> +	int (*tx_g_lirc_mode)(struct v4l2_subdev *sd, u32 *mode);
> +	int (*tx_g_carrier)(struct v4l2_subdev *sd, u32 *freq);
> +	int (*tx_g_duty_cycle)(struct v4l2_subdev *sd, u32 *duty_cycle);
> +};
> +
>  struct v4l2_subdev_ops {
>  	const struct v4l2_subdev_core_ops  *core;
>  	const struct v4l2_subdev_tuner_ops *tuner;
>  	const struct v4l2_subdev_audio_ops *audio;
>  	const struct v4l2_subdev_video_ops *video;
> +	const struct v4l2_subdev_ir_ops    *ir;
>  };
>
>  #define V4L2_SUBDEV_NAME_SIZE 32
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
