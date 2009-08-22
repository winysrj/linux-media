Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64204 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129AbZHVCGd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 22:06:33 -0400
Received: from [192.168.1.2] (01-078.155.popsite.net [66.217.131.78])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id n7M26Ust021548
	for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 22:06:31 -0400 (EDT)
Subject: [RFC] v4l2_subdev_ir_ops
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 21 Aug 2009 22:09:00 -0400
Message-Id: <1250906940.3159.20.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the course of implementing code to run the Consumer IR circuitry in
the CX2584[0123] chip and similar cores, I need to add
v4l2_subdev_ir_ops for manipulating the device and fetch and send data.

In line below is a proposal at what I think those subdev ops might be.
Feel free to take shots at it.

The insipration for these comes from two sources, the LIRC v0.8.5 source
code and what the CX2584x chip is capable of doing:

http://prdownloads.sourceforge.net/lirc/lirc-0.8.5.tar.bz2
http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf

Note the Consumer IR in the CX2584x can theoretically measure
unmodulated marks and spaces with a resolution of 37.037... ns (1/27
MHz), hence the references to nanoseconds in the proposal below.  Most
IR devices use pulses on the order of microseconds in real life.

Regards,
Andy

diff -r 44282114d1e3 linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Fri Aug 21 13:26:01 2009 -0400
+++ b/linux/include/media/v4l2-subdev.h	Fri Aug 21 21:51:52 2009 -0400
@@ -229,11 +229,206 @@
 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
 };
 
+/*
+   interrupt_service_routine: Called by the bridge chip's interrupt service
+	handler, when an IR interrupt status has be raised due to this subdev,
+	so that this subdev can handle the details.  It may schedule work to be
+	performed later.  It must not sleep.  *Called from an IRQ context*.
+
+   g_features: Return IR features supported by this device.  Intended to be
+	used to support the LIRC_GET_FEATURES ioctl() and to return the same
+	flags.
+
+   g_code_length: Return the cooked IR code length.  Intended to be used to
+	support the LIRC_GET_LENGTH ioctl(), returning the length of a code
+	in bits.  Currently only used in lirc for the LIRC_MODE_LIRCCODE.
+
+   [rt]x_s_notify_callback: Allows the subdev caller to set a callback for
+	notification of events due to the IR recevier or transmitter.
+
+   rx_read_pulse_widths: Reads received data in the form of consective space and
+	mark pulse widths in microseconds, or nanoseconds if in_ns is true.  The
+	semantics are similar to a non-blocking read() call.
+
+   tx_write_pulse_widths: Reads received data in the form of consective mark and
+	space pulse widths in microseconds, or nanoseconds if in_ns is true.
+	The semantics are similar to a non-blocking write() call.
+
+   rx_read: Reads received codes or other non-pulse width data.
+	The semantics are similar to a non-blocking read() call.
+
+   tx_write: Writes codes or other non-pulse width data to transmit.
+	The semantics are similar to a non-blocking write() call.
+
+   [rt]x_enable: enable or disable the receiver or transmitter using or
+	preserving the current setting.
+
+   [rt]x_shutdown: disable the receiver or transmitter and adjust all setting
+	to shut off or slow down hardware and disable interrupts.
+
+   [rt]x_s_interrupt_enable: enable or diable the receiver or transmitter
+	interrupts.
+
+   rx_s_demodulation: enable demodulation of received pulses from a carrier or
+	disable demodulation and read "baseband" light pulses.
+
+   rx_g_demodulation: query if demodulation of received pulses from a carrier is
+	enabled.
+
+   tx_s_modulation: enable modulation of transmitted pulses onto a carrier or
+	disable modulation and transmit "baseband" light pulses.
+
+   tx_g_modulation: query if modulation of transmitted pulses onto a carrier is
+	enabled.
+
+   rx_s_noise_filter: set the threshold pulse width for a received pulse to be
+	considered valid and not a glitch or noise.  A value of 0 disables the
+	noise filter.
+
+   rx_g_noise_filter: query the threshold pulse width for a received pulse to be
+	considered valid and not a glitch or noise.  A value of 0 means the
+	noise filter is disabled.
+
+   [rt]x_s_max_pulse_width: sets the max valid pulse width expected to be
+	received or transmitted, when receiving or transmitting baseband pulses,
+	in order to optimize the pulse width timer's resolution.  This call will
+	likely have the side effect of disabling demodulation/modulation of
+	pulses from/onto a carrier.
+
+   [rt]x_g_max_pulse_width: gets the max valid pulse width expected to be
+	received or transmitted, when receiving or transmitting baseband pulses.
+	This call should return error if demodulation/modulation of
+	pulses from/onto a carrier is enabled.
+
+   [rt]x_[sg]_lirc_mode: Set or get the LIRC "mode" for the receiver or
+	transmitter.  Intended to support the LIRC_{SET,GET}_{REC,SEND}_MODE
+	ioctl() calls.
+
+   [rt]x_[sg]_carrier: Set or get the carrier frequency for the receiver or
+	transmitter.  Frequency is in Hz.  Hardware limitations may
+	mean the actual frequency set varies from the desired frequency.  The
+	_g_ calls should return the precise frequency set.  The _s_ calls will
+	have the side effect of enabling demodulation/modulation when the
+	freq is not 0, and disabling demodulation/modulation when the
+	freq is 0.  These calls can also be used to support the
+	LIRC_{SET,GET}_{REC,SEND}_CARRIER ioctl() calls.
+
+   rx_s_carrier_range: Set a window of expected carrier frequencies for the
+	receiver.  Intended to support the LIRC_SET_REC_CARRIER_RANGE ioctl().
+	Due to hardware limitations, the full range may not be supportable and
+	the center of the supportable range may not be at the exact center of
+	the desired range.
+
+   [rt]x_[sg]_duty_cycle: Set or get the carrier duty cycle for the receiver or
+	transmitter.  Hardware limitations may mean the actual duty cycle set
+	varies from the desired duty_cycle.  The _g_ calls should return the
+	precise duty cycle set.  These calls can also be used to
+	support the LIRC_{SET,GET}_{REC,SEND}_DUTY_CYCLE ioctl() calls.
+
+   rx_s_duty_cycle_range: Set a window of expected received carrier duty cycles
+	Intended to support the LIRC_SET_REC_DUTY_CYCLE_RANGE ioctl().
+	Due to hardware limitations, the full range may not be supportable and
+	the center of the supportable range may not be at the exact center of
+	the desired range.
+
+   rx_g_resolution: get the pulse measurment resolution of the receiver.
+	Intended to support the LIRC_GET_REC_RESOLUTION ioctl().
+
+   tx_s_mask: set the mask of enabled transmitters for devices that have
+	more than one trasnmitter.  Intended to support the
+	LIRC_SET_TRANSMITTER_MASK ioctl().
+ */
+enum v4l2_subdev_ir_event {
+	V4L2_SUBDEV_IR_RX_DATA_READY     = 0,
+	V4L2_SUBDEV_IR_TX_READY_FOR_DATA = 1,
+};
+
+typedef int (*v4l2_subdev_ir_notify_callback)(void *priv,
+					      struct v4l2_subdev *sd,
+					      enum v4l2_subdev_ir_event event);
+
+struct v4l2_subdev_ir_ops {
+	/* Common to receiver and transmitter */
+	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
+						u32 status, bool *handled);
+
+	/* LIRC ioctl inspired calls */
+	int (*g_features)(struct v4l2_subdev *sd, u32 *features);
+	int (*g_code_length)(struct v4l2_subdev *sd, u32 *bits);
+
+	/* Receiver */
+	int (*rx_s_notify_callback)(struct v4l2_subdev *sd,
+					v4l2_subdev_ir_notify_callback callback,
+					void *priv);
+
+	int (*rx_read_pulse_widths)(struct v4l2_subdev *sd, u32 *widths,
+					size_t count, bool in_ns, ssize_t *num);
+	int (*rx_read)(struct v4l2_subdev *sd, u8 *buf, size_t count,
+				ssize_t *num);
+
+	int (*rx_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*rx_shutdown)(struct v4l2_subdev *sd);
+
+	int (*rx_s_interrupt_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*rx_s_demodulation)(struct v4l2_subdev *sd, bool enable);
+	int (*rx_s_noise_filter)(struct v4l2_subdev *sd, u32 min_width_ns);
+	int (*rx_s_max_pulse_width)(struct v4l2_subdev *sd, u64 max_width_ns);
+
+	int (*rx_g_demodulation)(struct v4l2_subdev *sd, bool *enabled);
+	int (*rx_g_noise_filter)(struct v4l2_subdev *sd, u32 *min_width_ns);
+	int (*rx_g_max_pulse_width)(struct v4l2_subdev *sd, u64 *max_width_ns);
+
+	/* LIRC receiver ioctl inspired calls */
+	int (*rx_s_lirc_mode)(struct v4l2_subdev *sd, u32 mode);
+	int (*rx_s_carrier)(struct v4l2_subdev *sd, u32 freq);
+	int (*rx_s_carrier_range)(struct v4l2_subdev *sd,
+					u32 lower, u32 upper);
+	int (*rx_s_duty_cycle)(struct v4l2_subdev *sd, u32 duty_cycle);
+	int (*rx_s_duty_cycle_range)(struct v4l2_subdev *sd,
+					u32 lower, u32 upper);
+
+	int (*rx_g_lirc_mode)(struct v4l2_subdev *sd, u32 *mode);
+	int (*rx_g_carrier)(struct v4l2_subdev *sd, u32 *freq);
+	int (*rx_g_duty_cycle)(struct v4l2_subdev *sd, u32 *duty_cycle);
+	int (*rx_g_resolution)(struct v4l2_subdev *sd, u32 *nsec);
+
+	/* Transmitter */
+	int (*tx_s_notify_callback)(struct v4l2_subdev *sd,
+					v4l2_subdev_ir_notify_callback callback,
+					void *priv);
+
+	int (*tx_write_pulse_widths)(struct v4l2_subdev *sd, u32 *widths,
+					size_t count, bool in_ns, ssize_t *num);
+	int (*tx_write)(struct v4l2_subdev *sd, u8 *buf, size_t count,
+				ssize_t *num);
+
+	int (*tx_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*tx_shutdown)(struct v4l2_subdev *sd);
+
+	int (*tx_s_interrupt_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*tx_s_modulation)(struct v4l2_subdev *sd, bool enable);
+	int (*tx_s_max_pulse_width)(struct v4l2_subdev *sd, u64 max_width_ns);
+
+	int (*tx_g_modulation)(struct v4l2_subdev *sd, bool *enabled);
+	int (*tx_g_max_pulse_width)(struct v4l2_subdev *sd, u64 *max_width_ns);
+
+	/* LIRC transmitter ioctl inspired calls */
+	int (*tx_s_lirc_mode)(struct v4l2_subdev *sd, u32 mode);
+	int (*tx_s_carrier)(struct v4l2_subdev *sd, u32 freq);
+	int (*tx_s_duty_cycle)(struct v4l2_subdev *sd, u32 duty_cycle);
+	int (*tx_s_mask)(struct v4l2_subdev *sd, u32 enabled_transmitters);
+
+	int (*tx_g_lirc_mode)(struct v4l2_subdev *sd, u32 *mode);
+	int (*tx_g_carrier)(struct v4l2_subdev *sd, u32 *freq);
+	int (*tx_g_duty_cycle)(struct v4l2_subdev *sd, u32 *duty_cycle);
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops  *core;
 	const struct v4l2_subdev_tuner_ops *tuner;
 	const struct v4l2_subdev_audio_ops *audio;
 	const struct v4l2_subdev_video_ops *video;
+	const struct v4l2_subdev_ir_ops    *ir;
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32


