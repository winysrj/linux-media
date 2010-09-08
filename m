Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:49871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab0IHWmC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 18:42:02 -0400
Message-ID: <4C88113C.8040703@infradead.org>
Date: Wed, 08 Sep 2010 19:42:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com> <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 06-09-2010 18:26, Maxim Levitsky escreveu:
> Add new event types for timeout & carrier report
> Move timeout handling from ir_raw_event_store_with_filter to
> ir-lirc-codec, where it is really needed.
> Now lirc bridge ensures proper gap handling.
> Extend lirc bridge for carrier & timeout reports
> 
> Note: all new ir_raw_event variables now should be initialized
> like that: DEFINE_IR_RAW_EVENT(ev);
> 
> To clean an existing event, use init_ir_raw_event(&ev);
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/media/IR/ene_ir.c          |    4 +-
>  drivers/media/IR/ir-core-priv.h    |   13 ++++++-
>  drivers/media/IR/ir-jvc-decoder.c  |    5 +-
>  drivers/media/IR/ir-lirc-codec.c   |   78 +++++++++++++++++++++++++++++++-----
>  drivers/media/IR/ir-nec-decoder.c  |    5 +-
>  drivers/media/IR/ir-raw-event.c    |   45 +++++++-------------
>  drivers/media/IR/ir-rc5-decoder.c  |    5 +-
>  drivers/media/IR/ir-rc6-decoder.c  |    5 +-
>  drivers/media/IR/ir-sony-decoder.c |    5 +-
>  drivers/media/IR/mceusb.c          |    3 +-
>  drivers/media/IR/streamzap.c       |    8 ++-
>  include/media/ir-core.h            |   40 ++++++++++++++++---
>  12 files changed, 153 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
> index 7880d9c..dc32509 100644
> --- a/drivers/media/IR/ene_ir.c
> +++ b/drivers/media/IR/ene_ir.c
> @@ -701,7 +701,7 @@ static irqreturn_t ene_isr(int irq, void *data)
>  	unsigned long flags;
>  	irqreturn_t retval = IRQ_NONE;
>  	struct ene_device *dev = (struct ene_device *)data;
> -	struct ir_raw_event ev;
> +	DEFINE_IR_RAW_EVENT(ev);
>  
>  	spin_lock_irqsave(&dev->hw_lock, flags);
>  
> @@ -904,7 +904,7 @@ static int ene_set_learning_mode(void *data, int enable)
>  }
>  
>  /* outside interface: enable or disable idle mode */
> -static void ene_rx_set_idle(void *data, int idle)
> +static void ene_rx_set_idle(void *data, bool idle)
>  {
>  	struct ene_device *dev = (struct ene_device *)data;
>  
> diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
> index 5d7e08f..2559e72 100644
> --- a/drivers/media/IR/ir-core-priv.h
> +++ b/drivers/media/IR/ir-core-priv.h
> @@ -82,6 +82,12 @@ struct ir_raw_event_ctrl {
>  		struct ir_input_dev *ir_dev;
>  		struct lirc_driver *drv;
>  		int carrier_low;
> +
> +		ktime_t gap_start;
> +		u64 gap_duration;
> +		bool gap;
> +		bool send_timeout_reports;
> +
>  	} lirc;
>  };
>  
> @@ -109,9 +115,14 @@ static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
>  		ev->duration -= duration;
>  }
>  
> +/* Returns true if event is normal pulse/space event */
> +static inline bool is_timing_event(struct ir_raw_event ev)
> +{
> +	return !ev.carrier_report && !ev.reset;
> +}
> +
>  #define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
>  #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
> -#define IS_RESET(ev)			(ev.duration == 0)
>  /*
>   * Routines from ir-sysfs.c - Meant to be called only internally inside
>   * ir-core
> diff --git a/drivers/media/IR/ir-jvc-decoder.c b/drivers/media/IR/ir-jvc-decoder.c
> index 77a89c4..63dca6e 100644
> --- a/drivers/media/IR/ir-jvc-decoder.c
> +++ b/drivers/media/IR/ir-jvc-decoder.c
> @@ -50,8 +50,9 @@ static int ir_jvc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_JVC))
>  		return 0;
>  
> -	if (IS_RESET(ev)) {
> -		data->state = STATE_INACTIVE;
> +	if (!is_timing_event(ev)) {
> +		if (ev.reset)
> +			data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
> index e63f757..0f40bc2 100644
> --- a/drivers/media/IR/ir-lirc-codec.c
> +++ b/drivers/media/IR/ir-lirc-codec.c
> @@ -32,6 +32,7 @@
>  static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>  {
>  	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
> +	struct lirc_codec *lirc = &ir_dev->raw->lirc;
>  	int sample;
>  
>  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_LIRC))
> @@ -40,21 +41,57 @@ static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>  	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
>  		return -EINVAL;
>  
> -	if (IS_RESET(ev))
> +	/* Packet start */
> +	if (ev.reset)
>  		return 0;
>  
> -	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
> -		   TO_US(ev.duration), TO_STR(ev.pulse));
> +	/* Carrier reports */
> +	if (ev.carrier_report) {
> +		sample = LIRC_FREQUENCY(ev.carrier);
> +
> +	/* Packet end */
> +	} else if (ev.timeout) {
> +
> +		if (lirc->gap)
> +			return 0;
> +
> +		lirc->gap_start = ktime_get();
> +		lirc->gap = true;
> +		lirc->gap_duration = ev.duration;
> +
> +		if (!lirc->send_timeout_reports)
> +			return 0;
> +
> +		sample = LIRC_TIMEOUT(ev.duration / 1000);
>  
> -	sample = ev.duration / 1000;
> -	if (ev.pulse)
> -		sample |= PULSE_BIT;
> +	/* Normal sample */
> +	} else {
> +
> +		if (lirc->gap) {
> +			int gap_sample;
> +
> +			lirc->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
> +				lirc->gap_start));
> +
> +			/* Convert to ms and cap by LIRC_VALUE_MASK */
> +			do_div(lirc->gap_duration, 1000);
> +			lirc->gap_duration = min(lirc->gap_duration,
> +							(u64)LIRC_VALUE_MASK);
> +
> +			gap_sample = LIRC_SPACE(lirc->gap_duration);
> +			lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
> +						(unsigned char *) &gap_sample);
> +			lirc->gap = false;
> +		}
> +
> +		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
> +					LIRC_SPACE(ev.duration / 1000);
> +	}
>  
>  	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
>  			  (unsigned char *) &sample);
>  	wake_up(&ir_dev->raw->lirc.drv->rbuf->wait_poll);
>  
> -
>  	return 0;
>  }
>  
> @@ -103,6 +140,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  	int ret = 0;
>  	void *drv_data;
>  	unsigned long val = 0;
> +	u32 tmp;
>  
>  	lirc = lirc_get_pdata(filep);
>  	if (!lirc)
> @@ -201,12 +239,26 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  		break;
>  
>  	case LIRC_SET_REC_TIMEOUT:
> -		if (val < ir_dev->props->min_timeout ||
> -		    val > ir_dev->props->max_timeout)
> -			return -EINVAL;
> -		ir_dev->props->timeout = val * 1000;
> +		tmp = val * 1000;
> +
> +		if (tmp < ir_dev->props->min_timeout ||
> +			tmp > ir_dev->props->max_timeout)
> +				return -EINVAL;
> +
> +		ir_dev->props->timeout = tmp;
> +		break;
> +
> +	case LIRC_SET_REC_TIMEOUT_REPORTS:
> +		lirc->send_timeout_reports = !!val;
>  		break;
>  
> +	case LIRC_SET_MEASURE_CARRIER_MODE:
> +
> +		if (!ir_dev->props->s_carrier_report)
> +			return -ENOSYS;
> +		return ir_dev->props->s_carrier_report(
> +			ir_dev->props->priv, !!val);
> +
>  	default:
>  		return lirc_dev_fop_ioctl(filep, cmd, arg);
>  	}
> @@ -277,6 +329,10 @@ static int ir_lirc_register(struct input_dev *input_dev)
>  	if (ir_dev->props->s_learning_mode)
>  		features |= LIRC_CAN_USE_WIDEBAND_RECEIVER;
>  
> +	if (ir_dev->props->s_carrier_report)
> +		features |= LIRC_CAN_MEASURE_CARRIER;
> +
> +
>  	if (ir_dev->props->max_timeout)
>  		features |= LIRC_CAN_SET_REC_TIMEOUT;
>  
> diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
> index d597421..70993f7 100644
> --- a/drivers/media/IR/ir-nec-decoder.c
> +++ b/drivers/media/IR/ir-nec-decoder.c
> @@ -54,8 +54,9 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_NEC))
>  		return 0;
>  
> -	if (IS_RESET(ev)) {
> -		data->state = STATE_INACTIVE;
> +	if (!is_timing_event(ev)) {
> +		if (ev.reset)
> +			data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
> index 56797be..d10b8e0 100644
> --- a/drivers/media/IR/ir-raw-event.c
> +++ b/drivers/media/IR/ir-raw-event.c
> @@ -174,7 +174,7 @@ int ir_raw_event_store_with_filter(struct input_dev *input_dev,
>  	if (ir->idle && !ev->pulse)
>  		return 0;
>  	else if (ir->idle)
> -		ir_raw_event_set_idle(input_dev, 0);
> +		ir_raw_event_set_idle(input_dev, false);
>  
>  	if (!raw->this_ev.duration) {
>  		raw->this_ev = *ev;
> @@ -187,48 +187,35 @@ int ir_raw_event_store_with_filter(struct input_dev *input_dev,
>  
>  	/* Enter idle mode if nessesary */
>  	if (!ev->pulse && ir->props->timeout &&
> -		raw->this_ev.duration >= ir->props->timeout)
> -		ir_raw_event_set_idle(input_dev, 1);
> +		raw->this_ev.duration >= ir->props->timeout) {
> +		ir_raw_event_set_idle(input_dev, true);
> +	}
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
>  
> -void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
> +/**
> + * ir_raw_event_set_idle() - hint the ir core if device is receiving
> + * IR data or not
> + * @input_dev: the struct input_dev device descriptor
> + * @idle: the hint value
> + */
> +void ir_raw_event_set_idle(struct input_dev *input_dev, bool idle)
>  {
>  	struct ir_input_dev *ir = input_get_drvdata(input_dev);
>  	struct ir_raw_event_ctrl *raw = ir->raw;
> -	ktime_t now;
> -	u64 delta;
>  
> -	if (!ir->props)
> +	if (!ir->props || !ir->raw)
>  		return;
>  
> -	if (!ir->raw)
> -		goto out;
> +	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
>  
>  	if (idle) {
> -		IR_dprintk(2, "enter idle mode\n");
> -		raw->last_event = ktime_get();
> -	} else {
> -		IR_dprintk(2, "exit idle mode\n");
> -
> -		now = ktime_get();
> -		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
> -
> -		WARN_ON(raw->this_ev.pulse);
> -
> -		raw->this_ev.duration =
> -			min(raw->this_ev.duration + delta,
> -						(u64)IR_MAX_DURATION);
> -
> +		raw->this_ev.timeout = true;
>  		ir_raw_event_store(input_dev, &raw->this_ev);
> -
> -		if (raw->this_ev.duration == IR_MAX_DURATION)
> -			ir_raw_event_reset(input_dev);
> -
> -		raw->this_ev.duration = 0;
> +		init_ir_raw_event(&raw->this_ev);
>  	}
> -out:
> +
>  	if (ir->props->s_idle)
>  		ir->props->s_idle(ir->props->priv, idle);
>  	ir->idle = idle;
> diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
> index df4770d..572ed4c 100644
> --- a/drivers/media/IR/ir-rc5-decoder.c
> +++ b/drivers/media/IR/ir-rc5-decoder.c
> @@ -55,8 +55,9 @@ static int ir_rc5_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>          if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC5))
>                  return 0;
>  
> -	if (IS_RESET(ev)) {
> -		data->state = STATE_INACTIVE;
> +	if (!is_timing_event(ev)) {
> +		if (ev.reset)
> +			data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/IR/ir-rc6-decoder.c
> index f1624b8..d25da91 100644
> --- a/drivers/media/IR/ir-rc6-decoder.c
> +++ b/drivers/media/IR/ir-rc6-decoder.c
> @@ -85,8 +85,9 @@ static int ir_rc6_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC6))
>  		return 0;
>  
> -	if (IS_RESET(ev)) {
> -		data->state = STATE_INACTIVE;
> +	if (!is_timing_event(ev)) {
> +		if (ev.reset)

Again, why do you need to test first for !is_timing_event()?

> +			data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> diff --git a/drivers/media/IR/ir-sony-decoder.c b/drivers/media/IR/ir-sony-decoder.c
> index b9074f0..2d15730 100644
> --- a/drivers/media/IR/ir-sony-decoder.c
> +++ b/drivers/media/IR/ir-sony-decoder.c
> @@ -48,8 +48,9 @@ static int ir_sony_decode(struct input_dev *input_dev, struct ir_raw_event ev)
>  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_SONY))
>  		return 0;
>  
> -	if (IS_RESET(ev)) {
> -		data->state = STATE_INACTIVE;
> +	if (!is_timing_event(ev)) {
> +		if (ev.reset)
> +			data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
> index ac6bb2c..d531f9f 100644
> --- a/drivers/media/IR/mceusb.c
> +++ b/drivers/media/IR/mceusb.c
> @@ -656,7 +656,7 @@ static int mceusb_set_tx_carrier(void *priv, u32 carrier)
>  
>  static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  {
> -	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
> +	DEFINE_IR_RAW_EVENT(rawir);
>  	int i, start_index = 0;
>  	u8 hdr = MCE_CONTROL_HEADER;
>  
> @@ -993,6 +993,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
>  	ir->len_in = maxp;
>  	ir->flags.microsoft_gen1 = is_microsoft_gen1;
>  	ir->flags.tx_mask_inverted = tx_mask_inverted;
> +	init_ir_raw_event(&ir->rawir);
>  
>  	/* Saving usb interface data for use by the transmitter routine */
>  	ir->usb_ep_in = ep_in;
> diff --git a/drivers/media/IR/streamzap.c b/drivers/media/IR/streamzap.c
> index 058e29f..18be3d5 100644
> --- a/drivers/media/IR/streamzap.c
> +++ b/drivers/media/IR/streamzap.c
> @@ -170,7 +170,7 @@ static void streamzap_flush_timeout(unsigned long arg)
>  static void streamzap_delay_timeout(unsigned long arg)
>  {
>  	struct streamzap_ir *sz = (struct streamzap_ir *)arg;
> -	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
> +	DEFINE_IR_RAW_EVENT(rawir);
>  	unsigned long flags;
>  	int len, ret;
>  	static unsigned long delay;
> @@ -215,7 +215,7 @@ static void streamzap_delay_timeout(unsigned long arg)
>  
>  static void streamzap_flush_delay_buffer(struct streamzap_ir *sz)
>  {
> -	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
> +	DEFINE_IR_RAW_EVENT(rawir);
>  	bool wake = false;
>  	int ret;
>  
> @@ -233,7 +233,7 @@ static void streamzap_flush_delay_buffer(struct streamzap_ir *sz)
>  
>  static void sz_push(struct streamzap_ir *sz)
>  {
> -	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
> +	DEFINE_IR_RAW_EVENT(rawir);
>  	unsigned long flags;
>  	int ret;
>  
> @@ -512,6 +512,8 @@ static int __devinit streamzap_probe(struct usb_interface *intf,
>  	if (!sz)
>  		return -ENOMEM;
>  
> +	init_ir_raw_event(&sz->rawir);
> +
>  	sz->usbdev = usbdev;
>  	sz->interface = intf;
>  
> diff --git a/include/media/ir-core.h b/include/media/ir-core.h
> index eb7fddf..d88ce2b 100644
> --- a/include/media/ir-core.h
> +++ b/include/media/ir-core.h
> @@ -60,6 +60,7 @@ enum rc_driver_type {
>   * @s_idle: optional: enable/disable hardware idle mode, upon which,
>  	device doesn't interrupt host until it sees IR pulses
>   * @s_learning_mode: enable wide band receiver used for learning
> + * @s_carrier_report: enable carrier reports
>   */
>  struct ir_dev_props {
>  	enum rc_driver_type	driver_type;
> @@ -82,8 +83,9 @@ struct ir_dev_props {
>  	int			(*s_tx_duty_cycle)(void *priv, u32 duty_cycle);
>  	int			(*s_rx_carrier_range)(void *priv, u32 min, u32 max);
>  	int			(*tx_ir)(void *priv, int *txbuf, u32 n);
> -	void			(*s_idle)(void *priv, int enable);
> +	void			(*s_idle)(void *priv, bool enable);
>  	int			(*s_learning_mode)(void *priv, int enable);
> +	int			(*s_carrier_report) (void *priv, int enable);
>  };
>  
>  struct ir_input_dev {
> @@ -162,22 +164,48 @@ u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
>  /* From ir-raw-event.c */
>  
>  struct ir_raw_event {
> -	unsigned                        pulse:1;
> -	unsigned                        duration:31;
> +	union {
> +		u32             duration;
> +
> +		struct {
> +			u32     carrier;
> +			u8      duty_cycle;
> +		};
> +	};
> +
> +	unsigned                pulse:1;
> +	unsigned                reset:1;
> +	unsigned                timeout:1;
> +	unsigned                carrier_report:1;
>  };

Hmm... can an event have, simultaneously, more than one of those bits set? I don't think so.
You could, instead, define the event type as:

#define EV_SPACE	0
#define EV_PULSE	1
#define EV_RESET	2
#define EV_TIMEOUT	3
#define EV_CARRIER	4

unsigned ev_type:3;

And use those macros for the tests:

#define IS_TIMING_EVENT(ev) (ev < EV_RESET)
#define IS_RESET(ev)	    (ev == EV_SPACE)


Also, it is not clear at the data struct that, when carrier_report = 1, it should use the
carrier struct, instead of duration.

My suggestion is to use, instead:

struct ir_raw_event {
	#define EV_SPACE	0
	#define EV_PULSE	1
	#define EV_RESET	2
	#define EV_TIMEOUT	3
	#define EV_CARRIER	4

	unsigned ev_type:3;

	union {
		/* For EV_SPACE and EV_PULSE type of events */
		u32             duration;

		/* For EV_CARRIER type of events */
		struct {
			u32     carrier;
			u8      duty_cycle;
		};
	};

} __attribute__ ((packed));

Btw, as your code is changing the size of the events, it may be a good idea to 
use a larger buffer. For example, defining MAX_IR_EVENT_SIZE as something like

#define MAX_IR_EVENTS_PER_BUF	512

#define MAX_IR_EVENT_SIZE     roundup_pow_of_two((MAX_IR_EVENTS_PER_BUF * sizeof(struct ir_raw_event)))

PS.: I'm not saying that 512 events for the buffer are ok or not. The buffer should be big enough
to at least handle all events generated by one keystroke, as some drivers, like sms, only call the
handler function after receiving all the events for one keystroke, but just leaving 512 without
making it dependent of the size of the struct seems dangerous.

> -#define IR_MAX_DURATION                 0x7FFFFFFF      /* a bit more than 2 seconds */
> +#define DEFINE_IR_RAW_EVENT(event) \
> +	struct ir_raw_event event = { \
> +		{ .duration = 0 } , \
> +		.pulse = 0, \
> +		.reset = 0, \
> +		.timeout = 0, \
> +		.carrier_report = 0 }
> +
> +static inline void init_ir_raw_event(struct ir_raw_event *ev)
> +{
> +	memset(ev, 0, sizeof(*ev));
> +}
> +
> +#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
>  
>  void ir_raw_event_handle(struct input_dev *input_dev);
>  int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev);
>  int ir_raw_event_store_edge(struct input_dev *input_dev, enum raw_event_type type);
>  int ir_raw_event_store_with_filter(struct input_dev *input_dev,
>  				struct ir_raw_event *ev);
> -void ir_raw_event_set_idle(struct input_dev *input_dev, int idle);
> +void ir_raw_event_set_idle(struct input_dev *input_dev, bool idle);
>  
>  static inline void ir_raw_event_reset(struct input_dev *input_dev)
>  {
> -	struct ir_raw_event ev = { .pulse = false, .duration = 0 };
> +	DEFINE_IR_RAW_EVENT(ev);
> +	ev.reset = true;
> +
>  	ir_raw_event_store(input_dev, &ev);
>  	ir_raw_event_handle(input_dev);
>  }

