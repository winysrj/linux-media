Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:51201 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbbETIyA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 04:54:00 -0400
To: Sean Young <sean@mess.org>
Subject: Re: [RFC PATCH 6/6] [media] rc: teach lirc how to send scancodes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 20 May 2015 10:53:59 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
In-Reply-To: <985a9b11e5e02eb43e16d27db23086528434be24.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
 <985a9b11e5e02eb43e16d27db23086528434be24.1426801061.git.sean@mess.org>
Message-ID: <d83477bae9a733323fd072def6384a3b@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-03-19 22:50, Sean Young wrote:
> The send mode has to be switched to LIRC_MODE_SCANCODE and then you can
> send one scancode with a write. The encoding is the same as for 
> receiving
> scancodes.

Why do the encoding in-kernel when it can be done in userspace?

I'd understand if it was hardware that accepted a scancode as input, but 
that doesn't seem to be the case?

> FIXME: Currently only the nec encoder can encode IR.
> FIXME: The "decoders" should be renamed (codec?)
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  .../DocBook/media/v4l/lirc_device_interface.xml    | 39 
> +++++++++--------
>  drivers/media/rc/ir-lirc-codec.c                   | 49 
> +++++++++++++++------
>  drivers/media/rc/ir-nec-decoder.c                  | 50 
> ++++++++++++++++++++++
>  drivers/media/rc/rc-core-priv.h                    |  1 +
>  drivers/media/rc/rc-ir-raw.c                       | 19 ++++++++
>  include/media/lirc.h                               |  1 +
>  include/media/rc-core.h                            |  3 +-
>  7 files changed, 132 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> index f92b5a5..e7f8139 100644
> --- a/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> +++ b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
> @@ -37,8 +37,8 @@ The lower 24 bits signify the value either in Hertz
> or nanoseconds.
>  </para>
>  <para>If LIRC_MODE_SCANCODE is enabled then the type in the highest 8 
> bits
>  is LIRC_MODE2_SCANCODE. The 24 bit signifies a repeat, 23 bit toggle 
> set and
> -the lowest 8 bits is the rc protocol (see rc_type in rc-core.h). The 
> next full
> -unsigned int is the scancode; there is no type in the highest 8 bits.
> +the lowest 8 bits is the rc protocol (see enum rc_type in rc-map.h). 
> The next
> +full unsigned int is the scancode; there is no type in the highest 8 
> bits.
>  </para>
>  <para>The mode can be set and get using <xref linkend="lirc_ioctl"/>. 
> </para>
> 
> @@ -47,13 +47,24 @@ unsigned int is the scancode; there is no type in
> the highest 8 bits.
>  <section id="lirc_write">
>  <title>LIRC write fop</title>
> 
> -<para>The data written to the chardev is a pulse/space sequence of 
> integer
> -values. Pulses and spaces are only marked implicitly by their 
> position. The
> -data must start and end with a pulse, therefore, the data must always 
> include
> -an uneven number of samples. The write function must block until the 
> data has
> -been transmitted by the hardware. If more data is provided than the 
> hardware
> -can send, the driver returns EINVAL.</para>
> +<para>
> +This is for sending or "blasting" IR. The format depends on the send 
> mode,
> +this is either LIRC_MODE_PULSE or LIRC_MODE_SCANCODE. The mode can be 
> set
> +and get using <xref linkend="lirc_ioctl"/>. </para>
> +</para>
> +<para>In LIRC_MODE_PULSE, the data written to the chardev is a 
> pulse/space
> +sequence of integer values. Pulses and spaces are only marked 
> implicitly by
> +their position. The data must start and end with a pulse, therefore, 
> the
> +data must always include an uneven number of samples. The write 
> function
> +must block until the data has been transmitted by the hardware. If 
> more data
> +is provided than the hardware can send, the driver returns 
> EINVAL.</para>
> 
> +<para>In LIRC_MODE_SCANCODE, two 32 bit unsigneds must be written. The
> +first unsigned must have it highest 8 bits set to LIRC_MODE2_SCANCODE 
> and
> +the lowest 8 bit signify the rc protocol (see enum rc_type in 
> rc-map.h).
> +If the protocol supports repeats then that can be set using
> +LIRC_SCANCODE_REPEAT and the same for LIRC_SCANCODE_TOGGLE. The next 
> 32 bit
> +unsigned is the scancode.
>  </section>
> 
>  <section id="lirc_ioctl">
> @@ -81,9 +92,10 @@ on working with the default settings 
> initially.</para>
>      </listitem>
>    </varlistentry>
>    <varlistentry>
> -    <term>LIRC_GET_SEND_MODE</term>
> +    <term>LIRC_{G,S}ET_SEND_MODE</term>
>      <listitem>
> -      <para>Get supported transmit mode. Only LIRC_MODE_PULSE is
> supported by lircd.</para>
> +      <para>Get or set the send mode. This can either be 
> LIRC_MODE_PULSE or
> +      LIRC_MODE_SCANCODE. </para>
>      </listitem>
>    </varlistentry>
>    <varlistentry>
> @@ -155,13 +167,6 @@ on working with the default settings 
> initially.</para>
>      </listitem>
>    </varlistentry>
>    <varlistentry>
> -    <term>LIRC_SET_{SEND,REC}_MODE</term>
> -    <listitem>
> -      <para>Set send/receive mode. Largely obsolete for send, as only
> -      LIRC_MODE_PULSE is supported.</para>
> -    </listitem>
> -  </varlistentry>
> -  <varlistentry>
>      <term>LIRC_SET_{SEND,REC}_CARRIER</term>
>      <listitem>
>        <para>Set send/receive carrier (in Hz).</para>
> diff --git a/drivers/media/rc/ir-lirc-codec.c 
> b/drivers/media/rc/ir-lirc-codec.c
> index 594535e..14d9b41 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -141,16 +141,39 @@ static ssize_t ir_lirc_transmit_ir(struct file
> *file, const char __user *buf,
>  	if (!dev || !dev->lirc)
>  		return -EFAULT;
> 
> -	if (n < sizeof(unsigned) || n % sizeof(unsigned))
> -		return -EINVAL;
> +	if (dev->send_mode == LIRC_MODE_SCANCODE) {
> +		unsigned c[2];
> 
> -	count = n / sizeof(unsigned);
> -	if (count > LIRCBUF_SIZE || count % 2 == 0)
> -		return -EINVAL;
> +		if (n != sizeof(unsigned) * 2)
> +			return -EINVAL;
> +
> +		ret = copy_from_user(c, buf, n);
> +		if (ret)
> +			return ret;
> +
> +		txbuf = kmalloc(GFP_KERNEL, sizeof(unsigned) * LIRCBUF_SIZE);
> +		if (!txbuf)
> +			return -ENOMEM;
> 
> -	txbuf = memdup_user(buf, n);
> -	if (IS_ERR(txbuf))
> -		return PTR_ERR(txbuf);
> +		ret = ir_raw_encode(c[0] & LIRC_SCANCODE_PROTOCOL_MASK, c[1],
> +				(c[0] & LIRC_SCANCODE_REPEAT) != 0,
> +				(c[0] & LIRC_SCANCODE_TOGGLE) != 0,
> +				txbuf, LIRCBUF_SIZE);
> +		if (ret < 0)
> +			goto out;
> +		count = ret;
> +	} else {
> +		if (n < sizeof(unsigned) || n % sizeof(unsigned))
> +			return -EINVAL;
> +
> +		count = n / sizeof(unsigned);
> +		if (count > LIRCBUF_SIZE || count % 2 == 0)
> +			return -EINVAL;
> +
> +		txbuf = memdup_user(buf, n);
> +		if (IS_ERR(txbuf))
> +			return PTR_ERR(txbuf);
> +	}
> 
>  	if (!dev->tx_ir) {
>  		ret = -ENOSYS;
> @@ -173,7 +196,7 @@ static ssize_t ir_lirc_transmit_ir(struct file
> *file, const char __user *buf,
>  	for (duration = i = 0; i < ret; i++)
>  		duration += txbuf[i];
> 
> -	ret *= sizeof(unsigned int);
> +	ret = n;
> 
>  	/*
>  	 * The lircd gap calculation expects the write function to
> @@ -216,16 +239,17 @@ static long ir_lirc_ioctl(struct file *filep,
> unsigned int cmd,
>  		if (!(dev->lirc->features & LIRC_CAN_SEND_MASK))
>  			return -ENOSYS;
> 
> -		val = LIRC_MODE_PULSE;
> +		val = dev->send_mode;
>  		break;
> 
>  	case LIRC_SET_SEND_MODE:
>  		if (!(dev->lirc->features & LIRC_CAN_SEND_MASK))
>  			return -ENOSYS;
> 
> -		if (val != LIRC_MODE_PULSE)
> +		if (val != LIRC_MODE_PULSE && val != LIRC_MODE_SCANCODE)
>  			return -EINVAL;
> 
> +		dev->send_mode = val;
>  		return 0;
> 
>  	case LIRC_GET_REC_MODE:
> @@ -386,13 +410,14 @@ int ir_lirc_register(struct rc_dev *dev)
>  	if (dev->driver_type == RC_DRIVER_IR_RAW)
>  		features |= LIRC_CAN_REC_MODE2;
>  	if (dev->tx_ir) {
> -		features |= LIRC_CAN_SEND_PULSE;
> +		features |= LIRC_CAN_SEND_PULSE | LIRC_CAN_SEND_SCANCODE;
>  		if (dev->s_tx_mask)
>  			features |= LIRC_CAN_SET_TRANSMITTER_MASK;
>  		if (dev->s_tx_carrier)
>  			features |= LIRC_CAN_SET_SEND_CARRIER;
>  		if (dev->s_tx_duty_cycle)
>  			features |= LIRC_CAN_SET_SEND_DUTY_CYCLE;
> +		dev->send_mode = LIRC_MODE_PULSE;
>  	}
> 
>  	if (dev->s_rx_carrier_range)
> diff --git a/drivers/media/rc/ir-nec-decoder.c
> b/drivers/media/rc/ir-nec-decoder.c
> index 7b81fec..1232084 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -200,9 +200,59 @@ static int ir_nec_decode(struct rc_dev *dev,
> struct ir_raw_event ev)
>  	return -EINVAL;
>  }
> 
> +static int ir_nec_encode(enum rc_type type, u32 scancode, bool repeat,
> +				bool toggle, unsigned *buf, unsigned count)
> +{
> +	unsigned i = 0, bits;
> +
> +	if (type != RC_TYPE_NEC)
> +		return -EINVAL;
> +
> +	if (count < 3)
> +		return -ENOSPC;
> +
> +	if (repeat) {
> +		buf[i++] = NEC_HEADER_PULSE;
> +		buf[i++] = NEC_REPEAT_SPACE;
> +		buf[i++] = STATE_TRAILER_PULSE;
> +		return 3;
> +	}
> +
> +	if (count < 3 + NEC_NBITS * 2)
> +		return -ENOSPC;
> +
> +	if (scancode < 0x10000) { /* normal NEC */
> +		u32 cmd, addr;
> +
> +		addr = (scancode >> 8) & 0xff;
> +		cmd = scancode & 0xff;
> +
> +		scancode = addr << 24 | (~addr & 0xff) << 16 |
> +						cmd << 8 | (~cmd & 0xff);
> +	} else if (scancode < 0x1000000) { /* extended NEC */
> +		u32 cmd = scancode & 0xff;
> +
> +		scancode = (scancode & 0xffff00) << 8 |
> +						(cmd << 8) | (~cmd & 0xff);
> +	}
> +
> +	buf[i++] = NEC_HEADER_PULSE;
> +	buf[i++] = NEC_HEADER_SPACE;
> +	for (bits = 0; bits < NEC_NBITS; bits++) {
> +		buf[i++] = NEC_BIT_PULSE;
> +		buf[i++] = (scancode & 0x80000000) ?
> +					NEC_BIT_1_SPACE : NEC_BIT_0_SPACE;
> +		scancode <<= 1;
> +	}
> +	buf[i++] = STATE_TRAILER_PULSE;
> +
> +	return i;
> +}
> +
>  static struct ir_raw_handler nec_handler = {
>  	.protocols	= RC_BIT_NEC,
>  	.decode		= ir_nec_decode,
> +	.encode		= ir_nec_encode,
>  };
> 
>  static int __init ir_nec_decode_init(void)
> diff --git a/drivers/media/rc/rc-core-priv.h 
> b/drivers/media/rc/rc-core-priv.h
> index f613306..82d9132 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -25,6 +25,7 @@ struct ir_raw_handler {
> 
>  	u64 protocols; /* which are handled by this handler */
>  	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
> +	int (*encode)(enum rc_type protocol, u32 scancode, bool repeat, bool
> toggle, unsigned *buf, unsigned size);
> 
>  	/* These two should only be used by the mce kbd decoder */
>  	int (*raw_register)(struct rc_dev *dev);
> diff --git a/drivers/media/rc/rc-ir-raw.c 
> b/drivers/media/rc/rc-ir-raw.c
> index d298be7..d4e2144 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -351,6 +351,25 @@ void ir_raw_handler_unregister(struct
> ir_raw_handler *ir_raw_handler)
>  }
>  EXPORT_SYMBOL(ir_raw_handler_unregister);
> 
> +int ir_raw_encode(enum rc_type type, u32 scancode, bool repeat, bool 
> toggle,
> +					unsigned *buf, unsigned size)
> +{
> +	struct ir_raw_handler *handler;
> +	u64 protocol = 1ull << type;
> +	int ret = -ENOSYS;
> +
> +	mutex_lock(&ir_raw_handler_lock);
> +	list_for_each_entry(handler, &ir_raw_handler_list, list) {
> +		if (handler->protocols & protocol && handler->encode) {
> +			ret = handler->encode(type, scancode, repeat, toggle,
> +								buf, size);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&ir_raw_handler_lock);
> +	return ret;
> +}
> +
>  void ir_raw_init(void)
>  {
>  	/* Load the decoder modules */
> diff --git a/include/media/lirc.h b/include/media/lirc.h
> index a635fc9..3807ded 100644
> --- a/include/media/lirc.h
> +++ b/include/media/lirc.h
> @@ -60,6 +60,7 @@
>  #define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
>  #define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
>  #define LIRC_CAN_SEND_LIRCCODE         
> LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
> +#define LIRC_CAN_SEND_SCANCODE         
> LIRC_MODE2SEND(LIRC_MODE_SCANCODE)
> 
>  #define LIRC_CAN_SEND_MASK             0x0000003f
> 
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index a8cef8c..601a5ba 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -163,7 +163,7 @@ struct rc_dev {
>  	u64				gap_duration;
>  	bool				gap;
>  	bool				send_timeout_reports;
> -	u32				rec_mode;
> +	u32				rec_mode, send_mode;
>  	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*change_wakeup_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*open)(struct rc_dev *dev);
> @@ -258,6 +258,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev,
> enum raw_event_type type);
>  int ir_raw_event_store_with_filter(struct rc_dev *dev,
>  				struct ir_raw_event *ev);
>  void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
> +int ir_raw_encode(enum rc_type type, u32 scancode, bool repeat, bool
> toggle, unsigned *buf, unsigned size);
> 
>  static inline void ir_raw_event_reset(struct rc_dev *dev)
>  {
