Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35731 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbbENQ6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 12:58:33 -0400
Date: Thu, 14 May 2015 13:58:25 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: [RFC PATCH 5/6] [media] lirc: pass IR scancodes to userspace
 via lirc bridge
Message-ID: <20150514135825.34054e7a@recife.lan>
In-Reply-To: <35de32b7b2061fee0e0b5fca124d09fec17c4e66.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
	<35de32b7b2061fee0e0b5fca124d09fec17c4e66.1426801061.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Mar 2015 21:50:16 +0000
Sean Young <sean@mess.org> escreveu:

> The lirc interface only passes raw IR. Teach the lirc bridge how to pass
> scancodes (along with their IR information) to userspace. This introduces
> a new LIRC_MODE_SCANCODE mode where decoded IR is represented as two
> u32. The first one signifies LIRC_MODE_SCANCODE, the IR protocol, repeat
> and toggle bits, and the next u32 the scancode. This can be enabled with
> LIRC_MODE_MODE2 at the same time so that raw IR and scancodes will all
> be read.
> 
> By default LIRC_MODE_MODE2 is only enabled for raw IR devices so that
> user space does not get confused by the new scancode messages. It can be
> enabled if LIRC_MODE_SCANCODE is set using LIRC_SET_REC_MODE ioctl.
> 
> FIXME: The keycode is not passed via the bridge, but only via the input
> interface. Maybe this should be changed.

What do you mean by "the bridge" in this context? The lirc devnode?

IMHO, if we enable LIRC to use LIRC_MODE_SCANCODE, the output via input
evdev should be suppressed, and only the LIRC interface should be doing
I/O. Yet, eventually it makes sense to provide a way to explicitly allow
or disable I/O via input/evdev interface when LIRC is in scanmode.

> 
> With this change every rc device will have a lirc interface, including
> those which only produce scancodes in which case LIRC_MODE_SCANCODE will
> be enabled (else the lirc device will never produce anything).
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  .../DocBook/media/v4l/lirc_device_interface.xml    | 31 +++++++++-------
>  drivers/media/rc/Kconfig                           |  4 +--
>  drivers/media/rc/ir-lirc-codec.c                   | 42 +++++++++++++++++++++-
>  drivers/media/rc/rc-core-priv.h                    |  4 +++
>  drivers/media/rc/rc-main.c                         | 15 +++++---
>  include/media/lirc.h                               |  8 +++++
>  include/media/rc-core.h                            |  1 +
>  7 files changed, 86 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> index 25926bd..f92b5a5 100644
> --- a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> +++ b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> @@ -6,10 +6,10 @@
>  <title>Introduction</title>
>  
>  <para>The LIRC device interface is a bi-directional interface for
> -transporting raw IR data between userspace and kernelspace. Fundamentally,
> +transporting IR data between userspace and kernelspace. Fundamentally,
>  it is just a chardev (/dev/lircX, for X = 0, 1, 2, ...), with a number
>  of standard struct file_operations defined on it. With respect to
> -transporting raw IR data to and fro, the essential fops are read, write
> +transporting IR data to and fro, the essential fops are read, write
>  and ioctl.</para>
>  
>  <para>Example dmesg output upon a driver registering w/LIRC:</para>
> @@ -29,14 +29,19 @@ and ioctl.</para>
>  <section id="lirc_read">
>  <title>LIRC read fop</title>
>  
> -<para>The lircd userspace daemon reads raw IR data from the LIRC chardev. The
> -exact format of the data depends on what modes a driver supports, and what
> -mode has been selected. lircd obtains supported modes and sets the active mode
> -via the ioctl interface, detailed at <xref linkend="lirc_ioctl"/>. The generally
> -preferred mode is LIRC_MODE_MODE2, in which packets containing an int value
> -describing an IR signal are read from the chardev.</para>
> +<para>The data read from the chardev is IR. The format depends on the rec mode;
> +this is either in LIRC_MODE_MODE2, LIRC_MODE_SCANCODE or both. In MODE2, data
> +is read as 32 bit unsigned values. The highest 8 bits signifies the type:
> +LIRC_MODE2_PULSE, LIRC_MODE2_SPACE, LIRC_MODE2_FREQUENCY, LIRC_MODE2_TIMEOUT.
> +The lower 24 bits signify the value either in Hertz or nanoseconds.
> +</para>
> +<para>If LIRC_MODE_SCANCODE is enabled then the type in the highest 8 bits
> +is LIRC_MODE2_SCANCODE. The 24 bit signifies a repeat, 23 bit toggle set and
> +the lowest 8 bits is the rc protocol (see rc_type in rc-core.h). The next full
> +unsigned int is the scancode; there is no type in the highest 8 bits.
> +</para>
> +<para>The mode can be set and get using <xref linkend="lirc_ioctl"/>. </para>
>  
> -<para>See also <ulink url="http://www.lirc.org/html/technical.html">http://www.lirc.org/html/technical.html</ulink> for more info.</para>
>  </section>
>  
>  <section id="lirc_write">
> @@ -82,10 +87,12 @@ on working with the default settings initially.</para>
>      </listitem>
>    </varlistentry>
>    <varlistentry>
> -    <term>LIRC_GET_REC_MODE</term>
> +    <term>LIRC_{G,S}ET_REC_MODE</term>
>      <listitem>
> -      <para>Get supported receive modes. Only LIRC_MODE_MODE2 and LIRC_MODE_LIRCCODE
> -      are supported by lircd.</para>
> +      <para>Get or set the receive mode. Devices that support raw IR will
> +      support LIRC_MODE_MODE2; all devices support LIRC_MODE_SCANCODE. Note
> +      that both modes can be enabled by ORing. That way, both raw IR and
> +      decoded scancodes can be read simultaneously.</para>
>      </listitem>
>    </varlistentry>
>    <varlistentry>
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index efdd6f7..247c22c 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -13,7 +13,7 @@ config LIRC
>  	---help---
>  	   Enable this option to build the Linux Infrared Remote
>  	   Control (LIRC) core device interface driver. The LIRC
> -	   interface passes raw IR to and from userspace, where the
> +	   interface passes IR to and from userspace, where the
>  	   LIRC daemon handles protocol decoding for IR reception and
>  	   encoding for IR transmitting (aka "blasting").
>  
> @@ -24,7 +24,7 @@ config IR_LIRC_CODEC
>  	default y
>  
>  	---help---
> -	   Enable this option to pass raw IR to and from userspace via
> +	   Enable this option to pass IR to and from userspace via
>  	   the LIRC interface.
>  
>  menuconfig RC_DECODERS
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 475f6af..594535e 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -36,6 +36,8 @@ int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  
>  	if (!lirc || !lirc->rbuf)
>  		return -EINVAL;
> +	if (!(dev->rec_mode & LIRC_MODE_MODE2))
> +		return 0;
>  
>  	/* Packet start */
>  	if (ev.reset) {
> @@ -101,6 +103,26 @@ int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	return 0;
>  }
>  
> +void ir_lirc_scancode(struct rc_dev *dev, enum rc_type proto, u32 scancode,
> +						bool toggle, bool repeat)
> +{
> +	struct lirc_driver *lirc = dev->lirc;
> +	int sample;
> +
> +	if (!lirc || !lirc->rbuf || !(dev->rec_mode & LIRC_MODE_SCANCODE))
> +		return;
> +
> +	sample = LIRC_MODE2_SCANCODE | proto;
> +	if (toggle)
> +		sample |= LIRC_SCANCODE_TOGGLE;
> +	if (repeat)
> +		sample |= LIRC_SCANCODE_REPEAT;
> +
> +	lirc_buffer_write(lirc->rbuf, (unsigned char *) &sample);
> +	lirc_buffer_write(lirc->rbuf, (unsigned char *) &scancode);
> +	wake_up(&lirc->rbuf->wait_poll);
> +}
> +
>  static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  				   size_t n, loff_t *ppos)
>  {
> @@ -206,6 +228,20 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  
>  		return 0;
>  
> +	case LIRC_GET_REC_MODE:
> +		val = dev->rec_mode;
> +		break;
> +
> +	case LIRC_SET_REC_MODE:
> +		if (val == 0 ||
> +			val & ~(LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE) ||
> +			(!(dev->lirc->features & LIRC_CAN_REC_MODE2) &&
> +					(val & LIRC_MODE_MODE2)))
> +			return -EINVAL;
> +
> +		dev->rec_mode = val;
> +		return 0;
> +
>  	/* TX settings */
>  	case LIRC_SET_TRANSMITTER_MASK:
>  		if (!dev->s_tx_mask)
> @@ -346,7 +382,9 @@ int ir_lirc_register(struct rc_dev *dev)
>  	if (rc)
>  		goto rbuf_init_failed;
>  
> -	features = LIRC_CAN_REC_MODE2;
> +	features = LIRC_CAN_REC_SCANCODE;
> +	if (dev->driver_type == RC_DRIVER_IR_RAW)
> +		features |= LIRC_CAN_REC_MODE2;
>  	if (dev->tx_ir) {
>  		features |= LIRC_CAN_SEND_PULSE;
>  		if (dev->s_tx_mask)
> @@ -374,6 +412,8 @@ int ir_lirc_register(struct rc_dev *dev)
>  		 dev->driver_name);
>  	drv->minor = -1;
>  	drv->features = features;
> +	dev->rec_mode = features & LIRC_CAN_REC_MODE2 ?
> +					LIRC_MODE_MODE2 : LIRC_MODE2_SCANCODE;
>  	drv->data = dev;
>  	drv->rbuf = rbuf;
>  	drv->set_use_inc = &ir_lirc_open;
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index 732479d..f613306 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -223,11 +223,15 @@ static inline void load_xmp_decode(void) { }
>  void ir_lirc_unregister(struct rc_dev *dev);
>  int ir_lirc_register(struct rc_dev *dev);
>  int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev);
> +void ir_lirc_scancode(struct rc_dev *dev, enum rc_type proto, u32 scancode,
> +						bool toggle, bool repeat);
>  #else
>  static inline void ir_lirc_unregister(struct rc_dev *dev) {}
>  static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
>  static inline int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  								{ return 0; }
> +static inline void ir_lirc_scancode(struct rc_dev *dev, enum rc_type proto,
> +				u32 scancode, bool toggle, bool repeat) {}
>  #endif
>  
>  #ifdef CONFIG_LIRC
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index e717dc9..483038b 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -606,6 +606,10 @@ void rc_repeat(struct rc_dev *dev)
>  
>  	spin_lock_irqsave(&dev->keylock, flags);
>  
> +	if (dev->lirc)
> +		ir_lirc_scancode(dev, dev->last_protocol, dev->last_scancode,
> +								false, true);
> +
>  	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
>  	input_sync(dev->input_dev);
>  
> @@ -642,6 +646,9 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
>  	if (new_event && dev->keypressed)
>  		ir_do_keyup(dev, false);
>  
> +	if (dev->lirc)
> +		ir_lirc_scancode(dev, protocol, scancode, toggle, false);
> +
>  	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
>  
>  	if (new_event && keycode != KEY_RESERVED) {
> @@ -1416,12 +1423,12 @@ int rc_register_device(struct rc_dev *dev)
>  		mutex_lock(&dev->lock);
>  		if (rc < 0)
>  			goto out_input;
> -
> -		rc = ir_lirc_register(dev);
> -		if (rc < 0)
> -			goto out_raw;
>  	}
>  
> +	rc = ir_lirc_register(dev);
> +	if (rc < 0)
> +		goto out_raw;
> +
>  	if (dev->change_protocol) {
>  		u64 rc_type = (1ll << rc_map->rc_type);
>  		rc = dev->change_protocol(dev, &rc_type);
> diff --git a/include/media/lirc.h b/include/media/lirc.h
> index 7b845f8..a635fc9 100644
> --- a/include/media/lirc.h
> +++ b/include/media/lirc.h
> @@ -16,6 +16,7 @@
>  #define LIRC_MODE2_PULSE     0x01000000
>  #define LIRC_MODE2_FREQUENCY 0x02000000
>  #define LIRC_MODE2_TIMEOUT   0x03000000
> +#define LIRC_MODE2_SCANCODE  0x04000000
>  
>  #define LIRC_VALUE_MASK      0x00FFFFFF
>  #define LIRC_MODE2_MASK      0xFF000000
> @@ -32,6 +33,11 @@
>  #define LIRC_IS_PULSE(val) (LIRC_MODE2(val) == LIRC_MODE2_PULSE)
>  #define LIRC_IS_FREQUENCY(val) (LIRC_MODE2(val) == LIRC_MODE2_FREQUENCY)
>  #define LIRC_IS_TIMEOUT(val) (LIRC_MODE2(val) == LIRC_MODE2_TIMEOUT)
> +#define LIRC_IS_SCANCODE(val) (LIRC_MODE2(val) == LIRC_MODE2_SCANCODE)
> +
> +#define LIRC_SCANCODE_TOGGLE		0x00800000
> +#define LIRC_SCANCODE_REPEAT		0x00400000
> +#define LIRC_SCANCODE_PROTOCOL_MASK	0x000000ff
>  
>  /* used heavily by lirc userspace */
>  #define lirc_t int
> @@ -46,6 +52,7 @@
>  #define LIRC_MODE_RAW                  0x00000001
>  #define LIRC_MODE_PULSE                0x00000002
>  #define LIRC_MODE_MODE2                0x00000004
> +#define LIRC_MODE_SCANCODE             0x00000008
>  #define LIRC_MODE_LIRCCODE             0x00000010
>  
>  
> @@ -64,6 +71,7 @@
>  #define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
>  #define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
>  #define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
> +#define LIRC_CAN_REC_SCANCODE          LIRC_MODE2REC(LIRC_MODE_SCANCODE)
>  
>  #define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
>  
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index e3f217c..a8cef8c 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -163,6 +163,7 @@ struct rc_dev {
>  	u64				gap_duration;
>  	bool				gap;
>  	bool				send_timeout_reports;
> +	u32				rec_mode;
>  	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*change_wakeup_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*open)(struct rc_dev *dev);
