Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54432 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426AbZHWCRn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 22:17:43 -0400
Subject: Re: [RFC] v4l2_subdev_ir_ops
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jwilson@redhat.com>, linux-media@vger.kernel.org
In-Reply-To: <1250952450.4091.167.camel@palomino.walls.org>
References: <1250906940.3159.20.camel@palomino.walls.org>
	 <200908220942.16919.hverkuil@xs4all.nl>
	 <1250952450.4091.167.camel@palomino.walls.org>
Content-Type: text/plain
Date: Sat, 22 Aug 2009 22:14:04 -0400
Message-Id: <1250993644.5363.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-08-22 at 10:47 -0400, Andy Walls wrote:
> On Sat, 2009-08-22 at 09:42 +0200, Hans Verkuil wrote:
> > On Saturday 22 August 2009 04:09:00 Andy Walls wrote:
> > > In the course of implementing code to run the Consumer IR circuitry in
> > > the CX2584[0123] chip and similar cores, I need to add
> > > v4l2_subdev_ir_ops for manipulating the device and fetch and send data.
> > >
> > > In line below is a proposal at what I think those subdev ops might be.
> > > Feel free to take shots at it.
> > >

> > My first impressions are that you are trying to do too much here. What you 
> > want is a simple API to access an IR transmitter or receiver.

> > All they need 
> > basically are a setup command and read/write commands.

?Hans and Mauro,

Here's an v4l2_subdev_ir_ops definition implemented in another way.  It
has only 7 operations.

I'll probably continue working with this definition for now.

I think this definition might be problematic in that there's no good way
to communicate back to the callee what particular setting failed, if
there is a problem.  The callee will have to go through the returned
operational values to see what may have failed.  Then again, that may
not be something anyone cares about in practice.  Prototyping will
tell...

Regards,
Andy


diff -r 44282114d1e3 linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Fri Aug 21 13:26:01 2009 -0400
+++ b/linux/include/media/v4l2-subdev.h	Sat Aug 22 21:59:06 2009 -0400
@@ -23,6 +23,10 @@
 
 #include <media/v4l2-common.h>
 
+/* generic v4l2_device notify callback notification values */
+#define V4L2_SUBDEV_IR_RX_DATA_READY		_IO('v', 0)
+#define V4L2_SUBDEV_IR_TX_READY_FOR_DATA	_IO('v', 1)
+
 struct v4l2_device;
 struct v4l2_subdev;
 struct tuner_setup;
@@ -229,11 +233,94 @@
 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
 };
 
+/*
+   interrupt_service_routine: Called by the bridge chip's interrupt service
+	handler, when an IR interrupt status has be raised due to this subdev,
+	so that this subdev can handle the details.  It may schedule work to be
+	performed later.  It must not sleep.  *Called from an IRQ context*.
+
+   [rt]_g_parameters: Get the current operating parameters and state of the
+	the IR receiver or transmitter.
+
+   [rt]_s_parameters: Set the current operating parameters and state of the
+	the IR receiver or transmitter.  It is recommended to call
+	[rt]_g_parameters first to fill out the current state, and only change
+	the fields that need to be changed.  Upon return, the actual device
+	operating parameters and state will be returned.  Note that hardware
+	limitations may prevent the actual settings from matching the requested
+	settings - e.g. an actual carrier setting of 35,904 Hz when 36,000 Hz
+	was requested.  An exception is when the shutdown parameter is true.
+	The last used operational parameters will be returned, but the actual
+	state of the hardware be different to minimize power consumption and
+	processing when shutdown is true.
+
+   rx_read: Reads received codes or pulse width data.
+	The semantics are similar to a non-blocking read() call.
+
+   tx_write: Writes codes or pulse width data for transmission.
+	The semantics are similar to a non-blocking write() call.
+ */
+
+enum v4l2_subdev_ir_mode {
+	V4L2_SUBDEV_IR_MODE_PULSE_WIDTH, /* space & mark widths in nanosecs */
+};
+
+struct v4l2_subdev_ir_parameters {
+	/* Either Rx or Tx */
+	unsigned int bytes_per_data_element; /* of data in read or write call */
+	enum v4l2_subdev_ir_mode mode;
+
+	bool enable;
+	bool interrupt_enable;
+	bool shutdown; /* true: set hardware to low/no power, false: normal */
+
+	bool modulation;           /* true: uses carrier, false: baseband */
+	u32 max_pulse_width;       /* ns,      valid only for baseband signal */
+	unsigned int carrier_freq; /* Hz,      valid only for modulated signal*/
+	unsigned int duty_cycle;   /* percent, valid only for modulated signal*/
+
+	/* Rx only */
+	u32 noise_filter_min_width;       /* ns, min time of a valid pulse */
+	unsigned int carrier_range_lower; /* Hz, valid only for modulated sig */
+	unsigned int carrier_range_upper; /* Hz, valid only for modulated sig */
+	unsigned int duty_cycle_lower;    /* percent, valid only for modulated*/
+	unsigned int duty_cycle_upper;    /* percent, valid only for modulated*/
+	u32 resolution;                   /* ns */
+
+	/* Tx only */
+	u32 enabled_transmitters; /* bitmask of enabled transmitter drivers */
+};
+
+struct v4l2_subdev_ir_ops {
+	/* Common to receiver and transmitter */
+	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
+						u32 status, bool *handled);
+
+	/* Receiver */
+	int (*rx_read)(struct v4l2_subdev *sd, u8 *buf, size_t count,
+				ssize_t *num);
+
+	int (*rx_g_parameters)(struct v4l2_subdev *sd,
+				struct v4l2_subdev_ir_parameters *params);
+	int (*rx_s_parameters)(struct v4l2_subdev *sd,
+				struct v4l2_subdev_ir_parameters *params);
+
+	/* Transmitter */
+	int (*tx_write)(struct v4l2_subdev *sd, u8 *buf, size_t count,
+				ssize_t *num);
+
+	int (*tx_g_parameters)(struct v4l2_subdev *sd,
+				struct v4l2_subdev_ir_parameters *params);
+	int (*tx_s_parameters)(struct v4l2_subdev *sd,
+				struct v4l2_subdev_ir_parameters *params);
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




