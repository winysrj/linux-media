Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:52232 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaGYXTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 19:19:17 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A00KP8JG4TF00@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 19:19:16 -0400 (EDT)
Date: Fri, 25 Jul 2014 20:19:10 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 46/49] rc-core: use struct rc_event for all rc communication
Message-id: <20140725201910.432b78ff.m.chehab@samsung.com>
In-reply-to: <20140403233508.27099.42261.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
 <20140403233508.27099.42261.stgit@zeus.muc.hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Apr 2014 01:35:08 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Remove struct ir_raw_event and use struct rc_event in all stages
> of IR processing. This should help future flexibility and also
> cuts down on the confusing number of structs that are flying
> around in rc-*.

You should rebase this one. Please also add a better explanation,
as I didn't get what you want to do here nor why.

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/hid/hid-picolcd_cir.c              |   18 +++--
>  drivers/media/common/siano/smsir.c         |    7 +-
>  drivers/media/i2c/cx25840/cx25840-ir.c     |   94 +++++++++++++++-------------
>  drivers/media/pci/cx23885/cx23885-input.c  |   11 +--
>  drivers/media/pci/cx23885/cx23888-ir.c     |   91 ++++++++++++++-------------
>  drivers/media/pci/cx88/cx88-input.c        |   13 +++-
>  drivers/media/rc/ene_ir.c                  |   12 ++--
>  drivers/media/rc/fintek-cir.c              |   21 +++---
>  drivers/media/rc/iguanair.c                |   17 ++---
>  drivers/media/rc/ir-jvc-decoder.c          |   48 +++++++-------
>  drivers/media/rc/ir-lirc-codec.c           |   28 ++++----
>  drivers/media/rc/ir-mce_kbd-decoder.c      |   34 +++++-----
>  drivers/media/rc/ir-nec-decoder.c          |   51 ++++++++-------
>  drivers/media/rc/ir-rc5-decoder.c          |   32 +++++-----
>  drivers/media/rc/ir-rc6-decoder.c          |   48 +++++++-------
>  drivers/media/rc/ir-sanyo-decoder.c        |   46 +++++++-------
>  drivers/media/rc/ir-sharp-decoder.c        |   49 +++++++--------
>  drivers/media/rc/ir-sony-decoder.c         |   42 +++++++------
>  drivers/media/rc/ite-cir.c                 |   19 ++----
>  drivers/media/rc/ite-cir.h                 |    2 -
>  drivers/media/rc/mceusb.c                  |   15 +++-
>  drivers/media/rc/nuvoton-cir.c             |   18 +++--
>  drivers/media/rc/rc-core-priv.h            |   40 +++++++-----
>  drivers/media/rc/rc-ir-raw.c               |   89 +++++++++++++++------------
>  drivers/media/rc/rc-loopback.c             |   14 +---
>  drivers/media/rc/redrat3.c                 |   34 ++++------
>  drivers/media/rc/streamzap.c               |   62 +++++++++---------
>  drivers/media/rc/ttusbir.c                 |   31 ++++-----
>  drivers/media/rc/winbond-cir.c             |   23 +++----
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |    6 +-
>  drivers/media/usb/dvb-usb/technisat-usb2.c |   15 +++-
>  include/media/rc-ir-raw.h                  |   47 +++++---------
>  32 files changed, 548 insertions(+), 529 deletions(-)
> 
> diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
> index 59d5eb1..1f9021f 100644
> --- a/drivers/hid/hid-picolcd_cir.c
> +++ b/drivers/hid/hid-picolcd_cir.c
> @@ -45,7 +45,7 @@ int picolcd_raw_cir(struct picolcd_data *data,
>  {
>  	unsigned long flags;
>  	int i, w, sz;
> -	DEFINE_IR_RAW_EVENT(rawir);
> +	DEFINE_IR_RAW_EVENT(ev);
>  
>  	/* ignore if rc_dev is NULL or status is shunned */
>  	spin_lock_irqsave(&data->lock, flags);
> @@ -67,14 +67,18 @@ int picolcd_raw_cir(struct picolcd_data *data,
>  	 */
>  	sz = size > 0 ? min((int)raw_data[0], size-1) : 0;
>  	for (i = 0; i+1 < sz; i += 2) {
> -		init_ir_raw_event(&rawir);
>  		w = (raw_data[i] << 8) | (raw_data[i+1]);
> -		rawir.pulse = !!(w & 0x8000);
> -		rawir.duration = US_TO_NS(rawir.pulse ? (65536 - w) : w);
> +		if (w & 0x8000) {
> +			ev.code = RC_IR_PULSE;
> +			ev.val = US_TO_NS(65536 - w);
> +		} else {
> +			ev.code = RC_IR_SPACE;
> +			ev.val = US_TO_NS(w);
> +		}
>  		/* Quirk!! - see above */
> -		if (i == 0 && rawir.duration > 15000000)
> -			rawir.duration -= 15000000;
> -		ir_raw_event_store(data->rc_dev, &rawir);
> +		if (i == 0 && ev.val > 15000000)
> +			ev.val -= 15000000;
> +		ir_raw_event_store(data->rc_dev, &ev);
>  	}
>  	ir_raw_event_handle(data->rc_dev);
>  
> diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
> index f6938f4..3959a572 100644
> --- a/drivers/media/common/siano/smsir.c
> +++ b/drivers/media/common/siano/smsir.c
> @@ -38,12 +38,11 @@ void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
>  {
>  	int i;
>  	const s32 *samples = (const void *)buf;
> +	DEFINE_IR_RAW_EVENT(ev);
>  
>  	for (i = 0; i < len >> 2; i++) {
> -		DEFINE_IR_RAW_EVENT(ev);
> -
> -		ev.duration = abs(samples[i]) * 1000; /* Convert to ns */
> -		ev.pulse = (samples[i] > 0) ? false : true;
> +		ev.val = US_TO_NS(abs(samples[i]));
> +		ev.code = (samples[i] > 0) ? RC_IR_SPACE : RC_IR_PULSE;
>  
>  		ir_raw_event_store(coredev->ir.dev, &ev);
>  	}
> diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
> index 119d4e8..1672f0e 100644
> --- a/drivers/media/i2c/cx25840/cx25840-ir.c
> +++ b/drivers/media/i2c/cx25840/cx25840-ir.c
> @@ -98,12 +98,12 @@ MODULE_PARM_DESC(ir_debug, "enable integrated IR debug messages");
>  
>  /*
>   * We use this union internally for convenience, but callers to tx_write
> - * and rx_read will be expecting records of type struct ir_raw_event.
> - * Always ensure the size of this union is dictated by struct ir_raw_event.
> + * and rx_read will be expecting records of type struct rc_event.
> + * Always ensure the size of this union is dictated by struct rc_event.
>   */
>  union cx25840_ir_fifo_rec {
>  	u32 hw_fifo_data;
> -	struct ir_raw_event ir_core_data;
> +	struct rc_event ir_core_data;
>  };
>  
>  #define CX25840_IR_RX_KFIFO_SIZE    (256 * sizeof(union cx25840_ir_fifo_rec))
> @@ -659,63 +659,67 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
>  }
>  
>  /* Receiver */
> -static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
> -			      ssize_t *num)
> +static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t bufsize,
> +			      ssize_t *bytes_read)
>  {
> -	struct cx25840_ir_state *ir_state = to_ir_state(sd);
> +	struct cx25840_ir_state *state = to_ir_state(sd);
>  	bool invert;
>  	u16 divider;
> -	unsigned int i, n;
> -	union cx25840_ir_fifo_rec *p;
> -	unsigned u, v, w;
> -
> -	if (ir_state == NULL)
> +	struct rc_event *ev = (struct rc_event *)buf;
> +	union cx25840_ir_fifo_rec rec;
> +	unsigned max_events;
> +	unsigned events = 0;
> +	bool pulse, timeout;
> +	u64 val;
> +
> +	if (!state)
>  		return -ENODEV;
>  
> -	invert = (bool) atomic_read(&ir_state->rx_invert);
> -	divider = (u16) atomic_read(&ir_state->rxclk_divider);
> -
> -	n = count / sizeof(union cx25840_ir_fifo_rec)
> -		* sizeof(union cx25840_ir_fifo_rec);
> -	if (n == 0) {
> -		*num = 0;
> -		return 0;
> -	}
> -
> -	n = kfifo_out_locked(&ir_state->rx_kfifo, buf, n,
> -			     &ir_state->rx_kfifo_lock);
> +	invert = (bool)atomic_read(&state->rx_invert);
> +	divider = (u16)atomic_read(&state->rxclk_divider);
> +	max_events = bufsize / sizeof(union cx25840_ir_fifo_rec);
>  
> -	n /= sizeof(union cx25840_ir_fifo_rec);
> -	*num = n * sizeof(union cx25840_ir_fifo_rec);
> -
> -	for (p = (union cx25840_ir_fifo_rec *) buf, i = 0; i < n; p++, i++) {
> +	while (events + 2 <= max_events) {
> +		if (kfifo_out_spinlocked(&state->rx_kfifo, &rec, sizeof(rec),
> +					 &state->rx_kfifo_lock) != sizeof(rec))
> +			break;
>  
> -		if ((p->hw_fifo_data & FIFO_RXTX_RTO) == FIFO_RXTX_RTO) {
> +		if (rec.hw_fifo_data & FIFO_RXTX_RTO) {
>  			/* Assume RTO was because of no IR light input */
> -			u = 0;
> -			w = 1;
> +			pulse = false;
> +			timeout = true;
>  		} else {
> -			u = (p->hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
> +			pulse = (rec.hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
>  			if (invert)
> -				u = u ? 0 : 1;
> -			w = 0;
> +				pulse = !pulse;
> +			timeout = false;
>  		}
>  
> -		v = (unsigned) pulse_width_count_to_ns(
> -				  (u16) (p->hw_fifo_data & FIFO_RXTX), divider);
> -		if (v > IR_MAX_DURATION)
> -			v = IR_MAX_DURATION;
> -
> -		init_ir_raw_event(&p->ir_core_data);
> -		p->ir_core_data.pulse = u;
> -		p->ir_core_data.duration = v;
> -		p->ir_core_data.timeout = w;
> +		val = min_t(u64, IR_MAX_DURATION,
> +			    pulse_width_count_to_ns(rec.hw_fifo_data & FIFO_RXTX,
> +						    divider));
> +
> +		if (val) {
> +			init_ir_raw_event(ev);
> +			ev->code = pulse ? RC_IR_PULSE : RC_IR_SPACE;
> +			ev->val = val;
> +			events++;
> +			ev++;
> +			v4l2_dbg(2, ir_debug, sd, "rx read: %10llu ns %s\n",
> +				 (long long unsigned)val, pulse ? "pulse" : "space");
> +		}
>  
> -		v4l2_dbg(2, ir_debug, sd, "rx read: %10u ns  %s  %s\n",
> -			 v, u ? "mark" : "space", w ? "(timed out)" : "");
> -		if (w)
> +		if (timeout) {
> +			init_ir_raw_event(ev);
> +			ev->code = RC_IR_STOP;
> +			ev->val = 1;
> +			events++;
> +			ev++;
>  			v4l2_dbg(2, ir_debug, sd, "rx read: end of rx\n");
> +		}
>  	}
> +
> +	*bytes_read = events * sizeof(union cx25840_ir_fifo_rec);
>  	return 0;
>  }
>  
> diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
> index e2ba28d..5eac866 100644
> --- a/drivers/media/pci/cx23885/cx23885-input.c
> +++ b/drivers/media/pci/cx23885/cx23885-input.c
> @@ -52,18 +52,17 @@ static void cx23885_input_process_measurements(struct cx23885_dev *dev,
>  	ssize_t num;
>  	int count, i;
>  	bool handle = false;
> -	struct ir_raw_event ir_core_event[64];
> +	struct rc_event ev[64];
>  
>  	do {
>  		num = 0;
> -		v4l2_subdev_call(dev->sd_ir, ir, rx_read, (u8 *) ir_core_event,
> -				 sizeof(ir_core_event), &num);
> +		v4l2_subdev_call(dev->sd_ir, ir, rx_read, (u8 *)ev,
> +				 sizeof(rc_event), &num);
>  
> -		count = num / sizeof(struct ir_raw_event);
> +		count = num / sizeof(struct rc_event);
>  
>  		for (i = 0; i < count; i++) {
> -			ir_raw_event_store(kernel_ir->rc,
> -					   &ir_core_event[i]);
> +			ir_raw_event_store(kernel_ir->rc, &ev[i]);
>  			handle = true;
>  		}
>  	} while (num != 0);
> diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
> index c4961f8..da1b43e 100644
> --- a/drivers/media/pci/cx23885/cx23888-ir.c
> +++ b/drivers/media/pci/cx23885/cx23888-ir.c
> @@ -116,12 +116,12 @@ MODULE_PARM_DESC(ir_888_debug, "enable debug messages [CX23888 IR controller]");
>  
>  /*
>   * We use this union internally for convenience, but callers to tx_write
> - * and rx_read will be expecting records of type struct ir_raw_event.
> - * Always ensure the size of this union is dictated by struct ir_raw_event.
> + * and rx_read will be expecting records of type struct rc_event.
> + * Always ensure the size of this union is dictated by struct rc_event.
>   */
>  union cx23888_ir_fifo_rec {
>  	u32 hw_fifo_data;
> -	struct ir_raw_event ir_core_data;
> +	struct rc_event ir_core_data;
>  };
>  
>  #define CX23888_IR_RX_KFIFO_SIZE    (256 * sizeof(union cx23888_ir_fifo_rec))
> @@ -660,57 +660,62 @@ static int cx23888_ir_irq_handler(struct v4l2_subdev *sd, u32 status,
>  }
>  
>  /* Receiver */
> -static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
> -			      ssize_t *num)
> +static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t bufsize,
> +			      ssize_t *bytes_read)
>  {
>  	struct cx23888_ir_state *state = to_state(sd);
> -	bool invert = (bool) atomic_read(&state->rx_invert);
> -	u16 divider = (u16) atomic_read(&state->rxclk_divider);
> -
> -	unsigned int i, n;
> -	union cx23888_ir_fifo_rec *p;
> -	unsigned u, v, w;
> -
> -	n = count / sizeof(union cx23888_ir_fifo_rec)
> -		* sizeof(union cx23888_ir_fifo_rec);
> -	if (n == 0) {
> -		*num = 0;
> -		return 0;
> -	}
> -
> -	n = kfifo_out_locked(&state->rx_kfifo, buf, n, &state->rx_kfifo_lock);
> -
> -	n /= sizeof(union cx23888_ir_fifo_rec);
> -	*num = n * sizeof(union cx23888_ir_fifo_rec);
> -
> -	for (p = (union cx23888_ir_fifo_rec *) buf, i = 0; i < n; p++, i++) {
> +	bool invert = (bool)atomic_read(&state->rx_invert);
> +	u16 divider = (u16)atomic_read(&state->rxclk_divider);
> +	struct rc_event *ev = (struct rc_event *)buf;
> +	union cx23888_ir_fifo_rec rec;
> +	unsigned max_events;
> +	unsigned events = 0;
> +	bool pulse, timeout;
> +	u64 val;
> +
> +	max_events = bufsize / sizeof(union cx23888_ir_fifo_rec);
> +
> +	while (events + 2 <= max_events) {
> +		if (kfifo_out_spinlocked(&state->rx_kfifo, &rec, sizeof(rec),
> +					 &state->rx_kfifo_lock) != sizeof(rec))
> +			break;
>  
> -		if ((p->hw_fifo_data & FIFO_RXTX_RTO) == FIFO_RXTX_RTO) {
> +		if (rec.hw_fifo_data & FIFO_RXTX_RTO) {
>  			/* Assume RTO was because of no IR light input */
> -			u = 0;
> -			w = 1;
> +			pulse = false;
> +			timeout = true;
>  		} else {
> -			u = (p->hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
> +			pulse = (rec.hw_fifo_data & FIFO_RXTX_LVL) ? 1 : 0;
>  			if (invert)
> -				u = u ? 0 : 1;
> -			w = 0;
> +				pulse = !pulse;
> +			timeout = false;
>  		}
>  
> -		v = (unsigned) pulse_width_count_to_ns(
> -				  (u16) (p->hw_fifo_data & FIFO_RXTX), divider);
> -		if (v > IR_MAX_DURATION)
> -			v = IR_MAX_DURATION;
> -
> -		init_ir_raw_event(&p->ir_core_data);
> -		p->ir_core_data.pulse = u;
> -		p->ir_core_data.duration = v;
> -		p->ir_core_data.timeout = w;
> +		val = min_t(u64, IR_MAX_DURATION,
> +			    pulse_width_count_to_ns(rec.hw_fifo_data & FIFO_RXTX,
> +						    divider));
> +
> +		if (val) {
> +			init_ir_raw_event(ev);
> +			ev->code = pulse ? RC_IR_PULSE : RC_IR_SPACE;
> +			ev->val = val;
> +			events++;
> +			ev++;
> +			v4l2_dbg(2, ir_888_debug, sd, "rx read: %10llu ns %s\n",
> +				 (long long unsigned)val, pulse ? "pulse" : "space");
> +		}
>  
> -		v4l2_dbg(2, ir_888_debug, sd, "rx read: %10u ns  %s  %s\n",
> -			 v, u ? "mark" : "space", w ? "(timed out)" : "");
> -		if (w)
> +		if (timeout) {
> +			init_ir_raw_event(ev);
> +			ev->code = RC_IR_STOP;
> +			ev->val = 1;
> +			events++;
> +			ev++;
>  			v4l2_dbg(2, ir_888_debug, sd, "rx read: end of rx\n");
> +		}
>  	}
> +
> +	*bytes_read = events * sizeof(union cx23888_ir_fifo_rec);
>  	return 0;
>  }
>  
> diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
> index 2b68ede..b8d3534 100644
> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -524,7 +524,7 @@ void cx88_ir_irq(struct cx88_core *core)
>  	struct cx88_IR *ir = core->ir;
>  	u32 samples;
>  	unsigned todo, bits;
> -	struct ir_raw_event ev;
> +	DEFINE_IR_RAW_EVENT(ev);
>  
>  	if (!ir || !ir->sampling)
>  		return;
> @@ -541,9 +541,14 @@ void cx88_ir_irq(struct cx88_core *core)
>  
>  	init_ir_raw_event(&ev);
>  	for (todo = 32; todo > 0; todo -= bits) {
> -		ev.pulse = samples & 0x80000000 ? false : true;
> -		bits = min(todo, 32U - fls(ev.pulse ? samples : ~samples));
> -		ev.duration = (bits * (NSEC_PER_SEC / 1000)) / ir_samplerate;
> +		if (samples & 0x80000000) {
> +			ev.code = RC_IR_PULSE;
> +			bits = min(todo, 32U - fls(samples));
> +		} else {
> +			ev.code = RC_IR_SPACE;
> +			bits = min(todo, 32U - fls(~samples));
> +		}
> +		ev.val = (bits * (NSEC_PER_SEC / 1000)) / ir_samplerate;
>  		ir_raw_event_store_with_filter(ir->dev, &ev);
>  		samples <<= bits;
>  	}
> diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
> index 57d61e5..df05b2c 100644
> --- a/drivers/media/rc/ene_ir.c
> +++ b/drivers/media/rc/ene_ir.c
> @@ -353,9 +353,11 @@ static void ene_rx_sense_carrier(struct ene_device *dev)
>  	dbg("RX: sensed carrier = %d Hz, duty cycle %d%%",
>  						carrier, duty_cycle);
>  	if (dev->carrier_detect_enabled) {
> -		ev.carrier_report = true;
> -		ev.carrier = carrier;
> -		ev.duty_cycle = duty_cycle;
> +		ev.code = RC_IR_CARRIER;
> +		ev.val = carrier;
> +		ir_raw_event_store(dev->rdev, &ev);
> +		ev.code = RC_IR_DUTY_CYCLE;
> +		ev.val = duty_cycle;
>  		ir_raw_event_store(dev->rdev, &ev);
>  	}
>  }
> @@ -810,8 +812,8 @@ static irqreturn_t ene_isr(int irq, void *data)
>  
>  		dbg("RX: %d (%s)", hw_sample, pulse ? "pulse" : "space");
>  
> -		ev.duration = US_TO_NS(hw_sample);
> -		ev.pulse = pulse;
> +		ev.val = US_TO_NS(hw_sample);
> +		ev.code = pulse ? RC_IR_PULSE : RC_IR_SPACE;
>  		ir_raw_event_store_with_filter(dev->rdev, &ev);
>  	}
>  
> diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
> index dd49c28..bdccef0 100644
> --- a/drivers/media/rc/fintek-cir.c
> +++ b/drivers/media/rc/fintek-cir.c
> @@ -293,7 +293,7 @@ static int fintek_cmdsize(u8 cmd, u8 subcmd)
>  /* process ir data stored in driver buffer */
>  static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
>  {
> -	DEFINE_IR_RAW_EVENT(rawir);
> +	DEFINE_IR_RAW_EVENT(ev);
>  	u8 sample;
>  	bool event = false;
>  	int i;
> @@ -325,17 +325,18 @@ static void fintek_process_rx_ir_data(struct fintek_dev *fintek)
>  			break;
>  		case PARSE_IRDATA:
>  			fintek->rem--;
> -			init_ir_raw_event(&rawir);
> -			rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
> -			rawir.duration = US_TO_NS((sample & BUF_SAMPLE_MASK)
> +			init_ir_raw_event(&ev);
> +			ev.code = RC_IR_SPACE;
> +			if (sample & BUF_PULSE_BIT)
> +				ev.code = RC_IR_PULSE;
> +			ev.val = US_TO_NS((sample & BUF_SAMPLE_MASK)
>  					  * CIR_SAMPLE_PERIOD);
>  
> -			fit_dbg("Storing %s with duration %d",
> -				rawir.pulse ? "pulse" : "space",
> -				rawir.duration);
> -			if (ir_raw_event_store_with_filter(fintek->rdev,
> -									&rawir))
> -				event = true;
> +			fit_dbg("Storing %s with duration %llu",
> +				ev.code == RC_IR_PULSE ? "pulse" : "space",
> +				(long long unsigned)ev.val);
> +			ir_raw_event_store_with_filter(fintek->rdev, &ev);
> +			event = true;
>  			break;
>  		}
>  
> diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
> index 3b7327a..1ab94d2 100644
> --- a/drivers/media/rc/iguanair.c
> +++ b/drivers/media/rc/iguanair.c
> @@ -132,23 +132,22 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
>  			break;
>  		}
>  	} else if (len >= 7) {
> -		DEFINE_IR_RAW_EVENT(rawir);
> +		DEFINE_IR_RAW_EVENT(ev);
>  		unsigned i;
>  		bool event = false;
>  
> -		init_ir_raw_event(&rawir);
> -
>  		for (i = 0; i < 7; i++) {
>  			if (ir->buf_in[i] == 0x80) {
> -				rawir.pulse = false;
> -				rawir.duration = US_TO_NS(21845);
> +				ev.code = RC_IR_SPACE;
> +				ev.val = US_TO_NS(21845);
>  			} else {
> -				rawir.pulse = (ir->buf_in[i] & 0x80) == 0;
> -				rawir.duration = ((ir->buf_in[i] & 0x7f) + 1) *
> -								 RX_RESOLUTION;
> +				ev.code = ir->buf_in[i] & 0x80 ?
> +					  RC_IR_SPACE : RC_IR_PULSE;
> +				ev.val = ((ir->buf_in[i] & 0x7f) + 1) *
> +					 RX_RESOLUTION;
>  			}
>  
> -			if (ir_raw_event_store_with_filter(ir->rc, &rawir))
> +			if (ir_raw_event_store_with_filter(ir->rc, &ev))
>  				event = true;
>  		}
>  
> diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
> index 30bcf18..081cc3f 100644
> --- a/drivers/media/rc/ir-jvc-decoder.c
> +++ b/drivers/media/rc/ir-jvc-decoder.c
> @@ -39,37 +39,39 @@ enum jvc_state {
>  /**
>   * ir_jvc_decode() - Decode one JVC pulse or space
>   * @dev:	the struct rc_dev descriptor of the device
> - * @duration:   the struct ir_raw_event descriptor of the pulse/space
> + * @ev:		the struct rc_event descriptor of the event
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_jvc_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct jvc_dec *data = &dev->raw->jvc;
>  
>  	if (!(dev->enabled_protocols & RC_BIT_JVC))
>  		return 0;
>  
> -	if (!is_timing_event(ev)) {
> -		if (ev.reset)
> -			data->state = STATE_INACTIVE;
> +	if (ev.code == RC_IR_RESET) {
> +		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> -	if (!geq_margin(ev.duration, JVC_UNIT, JVC_UNIT / 2))
> +	if (!is_ir_raw_timing_event(ev))
> +		return 0;
> +
> +	if (!geq_margin(ev.val, JVC_UNIT, JVC_UNIT / 2))
>  		goto out;
>  
>  	IR_dprintk(2, "JVC decode started at state %d (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  
>  again:
>  	switch (data->state) {
>  
>  	case STATE_INACTIVE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, JVC_HEADER_PULSE, JVC_UNIT / 2))
> +		if (!eq_margin(ev.val, JVC_HEADER_PULSE, JVC_UNIT / 2))
>  			break;
>  
>  		data->count = 0;
> @@ -79,34 +81,34 @@ again:
>  		return 0;
>  
>  	case STATE_HEADER_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, JVC_HEADER_SPACE, JVC_UNIT / 2))
> +		if (!eq_margin(ev.val, JVC_HEADER_SPACE, JVC_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_BIT_PULSE;
>  		return 0;
>  
>  	case STATE_BIT_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, JVC_BIT_PULSE, JVC_UNIT / 2))
> +		if (!eq_margin(ev.val, JVC_BIT_PULSE, JVC_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_BIT_SPACE;
>  		return 0;
>  
>  	case STATE_BIT_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
>  		data->bits <<= 1;
> -		if (eq_margin(ev.duration, JVC_BIT_1_SPACE, JVC_UNIT / 2)) {
> +		if (eq_margin(ev.val, JVC_BIT_1_SPACE, JVC_UNIT / 2)) {
>  			data->bits |= 1;
>  			decrease_duration(&ev, JVC_BIT_1_SPACE);
> -		} else if (eq_margin(ev.duration, JVC_BIT_0_SPACE, JVC_UNIT / 2))
> +		} else if (eq_margin(ev.val, JVC_BIT_0_SPACE, JVC_UNIT / 2))
>  			decrease_duration(&ev, JVC_BIT_0_SPACE);
>  		else
>  			break;
> @@ -119,20 +121,20 @@ again:
>  		return 0;
>  
>  	case STATE_TRAILER_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, JVC_TRAILER_PULSE, JVC_UNIT / 2))
> +		if (!eq_margin(ev.val, JVC_TRAILER_PULSE, JVC_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_TRAILER_SPACE;
>  		return 0;
>  
>  	case STATE_TRAILER_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!geq_margin(ev.duration, JVC_TRAILER_SPACE, JVC_UNIT / 2))
> +		if (!geq_margin(ev.val, JVC_TRAILER_SPACE, JVC_UNIT / 2))
>  			break;
>  
>  		if (data->first) {
> @@ -156,10 +158,10 @@ again:
>  		return 0;
>  
>  	case STATE_CHECK_REPEAT:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (eq_margin(ev.duration, JVC_HEADER_PULSE, JVC_UNIT / 2))
> +		if (eq_margin(ev.val, JVC_HEADER_PULSE, JVC_UNIT / 2))
>  			data->state = STATE_INACTIVE;
>    else
>  			data->state = STATE_BIT_PULSE;
> @@ -168,7 +170,7 @@ again:
>  
>  out:
>  	IR_dprintk(1, "JVC decode failed at state %d (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  	data->state = STATE_INACTIVE;
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 7b56f21..1b4d1ff 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -25,12 +25,12 @@
>  /**
>   * ir_lirc_decode() - Send raw IR data to lirc_dev to be relayed to the
>   *		      lircd userspace daemon for decoding.
> - * @input_dev:	the struct rc_dev descriptor of the device
> - * @duration:	the struct ir_raw_event descriptor of the pulse/space
> + * @dev:	the struct rc_dev descriptor of the device
> + * @ev:		the struct rc_event descriptor of the event
>   *
>   * This function returns -EINVAL if the lirc interfaces aren't wired up.
>   */
> -static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_lirc_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct lirc_codec *lirc = &dev->raw->lirc;
>  	int sample;
> @@ -42,29 +42,29 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return -EINVAL;
>  
>  	/* Packet start */
> -	if (ev.reset)
> +	if (ev.code == RC_IR_RESET)
>  		return 0;
>  
>  	/* Carrier reports */
> -	if (ev.carrier_report) {
> -		sample = LIRC_FREQUENCY(ev.carrier);
> +	if (ev.code == RC_IR_CARRIER) {
> +		sample = LIRC_FREQUENCY(ev.val);
>  		IR_dprintk(2, "carrier report (freq: %d)\n", sample);
>  
>  	/* Packet end */
> -	} else if (ev.timeout) {
> +	} else if (ev.code == RC_IR_STOP) {
>  
>  		if (lirc->gap)
>  			return 0;
>  
>  		lirc->gap_start = ktime_get();
>  		lirc->gap = true;
> -		lirc->gap_duration = ev.duration;
> +		lirc->gap_duration = 0;
>  
>  		if (!lirc->send_timeout_reports)
>  			return 0;
>  
> -		sample = LIRC_TIMEOUT(ev.duration / 1000);
> -		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
> +		sample = LIRC_TIMEOUT(0);
> +		IR_dprintk(2, "timeout report\n");
>  
>  	/* Normal sample */
>  	} else {
> @@ -86,10 +86,10 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  			lirc->gap = false;
>  		}
>  
> -		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
> -					LIRC_SPACE(ev.duration / 1000);
> +		sample = is_pulse(ev) ? LIRC_PULSE(ev.val / 1000) :
> +					LIRC_SPACE(ev.val / 1000);
>  		IR_dprintk(2, "delivering %uus %s to lirc_dev\n",
> -			   TO_US(ev.duration), TO_STR(ev.pulse));
> +			   TO_US(ev.val), TO_STR(ev.code));
>  	}
>  
>  	lirc_buffer_write(dev->raw->lirc.drv->rbuf,
> @@ -436,7 +436,7 @@ static int ir_lirc_register(struct rc_dev *dev)
>  	drv->rbuf = rbuf;
>  	drv->set_use_inc = &ir_lirc_open;
>  	drv->set_use_dec = &ir_lirc_close;
> -	drv->code_length = sizeof(struct ir_raw_event) * 8;
> +	drv->code_length = sizeof(struct rc_event) * 8;
>  	drv->fops = &lirc_fops;
>  	drv->dev = &dev->dev;
>  	drv->rdev = dev;
> diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
> index 9f3c9b5..14538dd 100644
> --- a/drivers/media/rc/ir-mce_kbd-decoder.c
> +++ b/drivers/media/rc/ir-mce_kbd-decoder.c
> @@ -206,11 +206,11 @@ static void ir_mce_kbd_process_mouse_data(struct input_dev *idev, u32 scancode)
>  /**
>   * ir_mce_kbd_decode() - Decode one mce_kbd pulse or space
>   * @dev:	the struct rc_dev descriptor of the device
> - * @ev:		the struct ir_raw_event descriptor of the pulse/space
> + * @ev:		the struct rc_event descriptor of the event
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_mce_kbd_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
>  	u32 scancode;
> @@ -219,32 +219,34 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	if (!(dev->enabled_protocols & RC_BIT_MCE_KBD))
>  		return 0;
>  
> -	if (!is_timing_event(ev)) {
> -		if (ev.reset)
> -			data->state = STATE_INACTIVE;
> +	if (ev.code == RC_IR_RESET) {
> +		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> -	if (!geq_margin(ev.duration, MCIR2_UNIT, MCIR2_UNIT / 2))
> +	if (!is_ir_raw_timing_event(ev))
> +		return 0;
> +
> +	if (!geq_margin(ev.val, MCIR2_UNIT, MCIR2_UNIT / 2))
>  		goto out;
>  
>  again:
>  	IR_dprintk(2, "started at state %i (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  
> -	if (!geq_margin(ev.duration, MCIR2_UNIT, MCIR2_UNIT / 2))
> +	if (!geq_margin(ev.val, MCIR2_UNIT, MCIR2_UNIT / 2))
>  		return 0;
>  
>  	switch (data->state) {
>  
>  	case STATE_INACTIVE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
>  		/* Note: larger margin on first pulse since each MCIR2_UNIT
>  		   is quite short and some hardware takes some time to
>  		   adjust to the signal */
> -		if (!eq_margin(ev.duration, MCIR2_PREFIX_PULSE, MCIR2_UNIT))
> +		if (!eq_margin(ev.val, MCIR2_PREFIX_PULSE, MCIR2_UNIT))
>  			break;
>  
>  		data->state = STATE_HEADER_BIT_START;
> @@ -253,11 +255,11 @@ again:
>  		return 0;
>  
>  	case STATE_HEADER_BIT_START:
> -		if (geq_margin(ev.duration, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
> +		if (geq_margin(ev.val, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
>  			break;
>  
>  		data->header <<= 1;
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			data->header |= 1;
>  		data->count++;
>  		data->state = STATE_HEADER_BIT_END;
> @@ -292,11 +294,11 @@ again:
>  		goto again;
>  
>  	case STATE_BODY_BIT_START:
> -		if (geq_margin(ev.duration, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
> +		if (geq_margin(ev.val, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
>  			break;
>  
>  		data->body <<= 1;
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			data->body |= 1;
>  		data->count++;
>  		data->state = STATE_BODY_BIT_END;
> @@ -315,7 +317,7 @@ again:
>  		goto again;
>  
>  	case STATE_FINISHED:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
>  		switch (data->wanted_bits) {
> @@ -348,7 +350,7 @@ again:
>  
>  out:
>  	IR_dprintk(1, "failed at state %i (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  	data->state = STATE_INACTIVE;
>  	input_sync(data->idev);
>  	return -EINVAL;
> diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
> index 861fd86..cf4b8be 100644
> --- a/drivers/media/rc/ir-nec-decoder.c
> +++ b/drivers/media/rc/ir-nec-decoder.c
> @@ -41,11 +41,11 @@ enum nec_state {
>  /**
>   * ir_nec_decode() - Decode one NEC pulse or space
>   * @dev:	the struct rc_dev descriptor of the device
> - * @duration:	the struct ir_raw_event descriptor of the pulse/space
> + * @ev:		the struct rc_event descriptor of the event
>   *
> - * This function returns -EINVAL if the pulse violates the state machine
> + * This function returns -EINVAL if the event violates the state machine
>   */
> -static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_nec_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct nec_dec *data = &dev->raw->nec;
>  	u32 scancode;
> @@ -54,25 +54,27 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	if (!(dev->enabled_protocols & RC_BIT_NEC))
>  		return 0;
>  
> -	if (!is_timing_event(ev)) {
> -		if (ev.reset)
> -			data->state = STATE_INACTIVE;
> +	if (ev.code == RC_IR_RESET) {
> +		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> +	if (!is_ir_raw_timing_event(ev))
> +		return 0;
> +
>  	IR_dprintk(2, "NEC decode started at state %d (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  
>  	switch (data->state) {
>  
>  	case STATE_INACTIVE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT * 2)) {
> +		if (eq_margin(ev.val, NEC_HEADER_PULSE, NEC_UNIT * 2)) {
>  			data->is_nec_x = false;
>  			data->necx_repeat = false;
> -		} else if (eq_margin(ev.duration, NECX_HEADER_PULSE, NEC_UNIT / 2))
> +		} else if (eq_margin(ev.val, NECX_HEADER_PULSE, NEC_UNIT / 2))
>  			data->is_nec_x = true;
>  		else
>  			break;
> @@ -82,13 +84,13 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return 0;
>  
>  	case STATE_HEADER_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (eq_margin(ev.duration, NEC_HEADER_SPACE, NEC_UNIT)) {
> +		if (eq_margin(ev.val, NEC_HEADER_SPACE, NEC_UNIT)) {
>  			data->state = STATE_BIT_PULSE;
>  			return 0;
> -		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
> +		} else if (eq_margin(ev.val, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
>  			rc_repeat(dev);
>  			IR_dprintk(1, "Repeat last key\n");
>  			data->state = STATE_TRAILER_PULSE;
> @@ -98,22 +100,21 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		break;
>  
>  	case STATE_BIT_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, NEC_BIT_PULSE, NEC_UNIT / 2))
> +		if (!eq_margin(ev.val, NEC_BIT_PULSE, NEC_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_BIT_SPACE;
>  		return 0;
>  
>  	case STATE_BIT_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
>  		if (data->necx_repeat && data->count == NECX_REPEAT_BITS &&
> -			geq_margin(ev.duration,
> -			NEC_TRAILER_SPACE, NEC_UNIT / 2)) {
> +		    geq_margin(ev.val, NEC_TRAILER_SPACE, NEC_UNIT / 2)) {
>  				IR_dprintk(1, "Repeat last key\n");
>  				rc_repeat(dev);
>  				data->state = STATE_INACTIVE;
> @@ -123,9 +124,9 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  			data->necx_repeat = false;
>  
>  		data->bits <<= 1;
> -		if (eq_margin(ev.duration, NEC_BIT_1_SPACE, NEC_UNIT / 2))
> +		if (eq_margin(ev.val, NEC_BIT_1_SPACE, NEC_UNIT / 2))
>  			data->bits |= 1;
> -		else if (!eq_margin(ev.duration, NEC_BIT_0_SPACE, NEC_UNIT / 2))
> +		else if (!eq_margin(ev.val, NEC_BIT_0_SPACE, NEC_UNIT / 2))
>  			break;
>  		data->count++;
>  
> @@ -137,20 +138,20 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return 0;
>  
>  	case STATE_TRAILER_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, NEC_TRAILER_PULSE, NEC_UNIT / 2))
> +		if (!eq_margin(ev.val, NEC_TRAILER_PULSE, NEC_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_TRAILER_SPACE;
>  		return 0;
>  
>  	case STATE_TRAILER_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
> +		if (!geq_margin(ev.val, NEC_TRAILER_SPACE, NEC_UNIT / 2))
>  			break;
>  
>  		address     = bitrev8((data->bits >> 24) & 0xff);
> @@ -173,7 +174,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	}
>  
>  	IR_dprintk(1, "NEC decode failed at count %d state %d (%uus %s)\n",
> -		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->count, data->state, TO_US(ev.val), TO_STR(ev.code));
>  	data->state = STATE_INACTIVE;
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
> index 93168da..be43c0d 100644
> --- a/drivers/media/rc/ir-rc5-decoder.c
> +++ b/drivers/media/rc/ir-rc5-decoder.c
> @@ -42,11 +42,11 @@ enum rc5_state {
>  /**
>   * ir_rc5_decode() - Decode one RC-5 pulse or space
>   * @dev:	the struct rc_dev descriptor of the device
> - * @ev:		the struct ir_raw_event descriptor of the pulse/space
> + * @ev:		the struct rc_event descriptor of the event
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_rc5_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct rc5_dec *data = &dev->raw->rc5;
>  	u8 toggle;
> @@ -56,26 +56,28 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
>  		return 0;
>  
> -	if (!is_timing_event(ev)) {
> -		if (ev.reset)
> -			data->state = STATE_INACTIVE;
> +	if (ev.code == RC_IR_RESET) {
> +		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> -	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
> +	if (!is_ir_raw_timing_event(ev))
> +		return 0;
> +
> +	if (!geq_margin(ev.val, RC5_UNIT, RC5_UNIT / 2))
>  		goto out;
>  
>  again:
>  	IR_dprintk(2, "RC5(x/sz) decode started at state %i (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  
> -	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
> +	if (!geq_margin(ev.val, RC5_UNIT, RC5_UNIT / 2))
>  		return 0;
>  
>  	switch (data->state) {
>  
>  	case STATE_INACTIVE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
>  		data->state = STATE_BIT_START;
> @@ -84,16 +86,16 @@ again:
>  		goto again;
>  
>  	case STATE_BIT_START:
> -		if (!ev.pulse && geq_margin(ev.duration, RC5_TRAILER, RC5_UNIT / 2)) {
> +		if (is_space(ev) && geq_margin(ev.val, RC5_TRAILER, RC5_UNIT / 2)) {
>  			data->state = STATE_FINISHED;
>  			goto again;
>  		}
>  
> -		if (!eq_margin(ev.duration, RC5_BIT_START, RC5_UNIT / 2))
> +		if (!eq_margin(ev.val, RC5_BIT_START, RC5_UNIT / 2))
>  			break;
>  
>  		data->bits <<= 1;
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			data->bits |= 1;
>  		data->count++;
>  		data->state = STATE_BIT_END;
> @@ -112,7 +114,7 @@ again:
>  		goto again;
>  
>  	case STATE_CHECK_RC5X:
> -		if (!ev.pulse && geq_margin(ev.duration, RC5X_SPACE, RC5_UNIT / 2)) {
> +		if (is_space(ev) && geq_margin(ev.val, RC5X_SPACE, RC5_UNIT / 2)) {
>  			data->is_rc5x = true;
>  			decrease_duration(&ev, RC5X_SPACE);
>  		} else
> @@ -121,7 +123,7 @@ again:
>  		goto again;
>  
>  	case STATE_FINISHED:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
>  		if (data->is_rc5x && data->count == RC5X_NBITS) {
> @@ -179,7 +181,7 @@ again:
>  
>  out:
>  	IR_dprintk(1, "RC5(x/sz) decode failed at state %i (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  	data->state = STATE_INACTIVE;
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
> index f1f098e..20db209 100644
> --- a/drivers/media/rc/ir-rc6-decoder.c
> +++ b/drivers/media/rc/ir-rc6-decoder.c
> @@ -79,11 +79,11 @@ static enum rc6_mode rc6_mode(struct rc6_dec *data)
>  /**
>   * ir_rc6_decode() - Decode one RC6 pulse or space
>   * @dev:	the struct rc_dev descriptor of the device
> - * @ev:		the struct ir_raw_event descriptor of the pulse/space
> + * @ev:		the struct rc_event descriptor of the event
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_rc6_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct rc6_dec *data = &dev->raw->rc6;
>  	u32 scancode;
> @@ -95,32 +95,34 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
>  		return 0;
>  
> -	if (!is_timing_event(ev)) {
> -		if (ev.reset)
> -			data->state = STATE_INACTIVE;
> +	if (ev.code == RC_IR_RESET) {
> +		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> -	if (!geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
> +	if (!is_ir_raw_timing_event(ev))
> +		return 0;
> +
> +	if (!geq_margin(ev.val, RC6_UNIT, RC6_UNIT / 2))
>  		goto out;
>  
>  again:
>  	IR_dprintk(2, "RC6 decode started at state %i (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  
> -	if (!geq_margin(ev.duration, RC6_UNIT, RC6_UNIT / 2))
> +	if (!geq_margin(ev.val, RC6_UNIT, RC6_UNIT / 2))
>  		return 0;
>  
>  	switch (data->state) {
>  
>  	case STATE_INACTIVE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
>  		/* Note: larger margin on first pulse since each RC6_UNIT
>  		   is quite short and some hardware takes some time to
>  		   adjust to the signal */
> -		if (!eq_margin(ev.duration, RC6_PREFIX_PULSE, RC6_UNIT))
> +		if (!eq_margin(ev.val, RC6_PREFIX_PULSE, RC6_UNIT))
>  			break;
>  
>  		data->state = STATE_PREFIX_SPACE;
> @@ -128,10 +130,10 @@ again:
>  		return 0;
>  
>  	case STATE_PREFIX_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, RC6_PREFIX_SPACE, RC6_UNIT / 2))
> +		if (!eq_margin(ev.val, RC6_PREFIX_SPACE, RC6_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_HEADER_BIT_START;
> @@ -139,11 +141,11 @@ again:
>  		return 0;
>  
>  	case STATE_HEADER_BIT_START:
> -		if (!eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2))
> +		if (!eq_margin(ev.val, RC6_BIT_START, RC6_UNIT / 2))
>  			break;
>  
>  		data->header <<= 1;
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			data->header |= 1;
>  		data->count++;
>  		data->state = STATE_HEADER_BIT_END;
> @@ -162,16 +164,16 @@ again:
>  		goto again;
>  
>  	case STATE_TOGGLE_START:
> -		if (!eq_margin(ev.duration, RC6_TOGGLE_START, RC6_UNIT / 2))
> +		if (!eq_margin(ev.val, RC6_TOGGLE_START, RC6_UNIT / 2))
>  			break;
>  
> -		data->toggle = ev.pulse;
> +		data->toggle = is_pulse(ev);
>  		data->state = STATE_TOGGLE_END;
>  		return 0;
>  
>  	case STATE_TOGGLE_END:
>  		if (!is_transition(&ev, &dev->raw->prev_ev) ||
> -		    !geq_margin(ev.duration, RC6_TOGGLE_END, RC6_UNIT / 2))
> +		    !geq_margin(ev.val, RC6_TOGGLE_END, RC6_UNIT / 2))
>  			break;
>  
>  		if (!(data->header & RC6_STARTBIT_MASK)) {
> @@ -198,17 +200,17 @@ again:
>  		goto again;
>  
>  	case STATE_BODY_BIT_START:
> -		if (eq_margin(ev.duration, RC6_BIT_START, RC6_UNIT / 2)) {
> +		if (eq_margin(ev.val, RC6_BIT_START, RC6_UNIT / 2)) {
>  			/* Discard LSB's that won't fit in data->body */
>  			if (data->count++ < CHAR_BIT * sizeof data->body) {
>  				data->body <<= 1;
> -				if (ev.pulse)
> +				if (is_pulse(ev))
>  					data->body |= 1;
>  			}
>  			data->state = STATE_BODY_BIT_END;
>  			return 0;
> -		} else if (RC6_MODE_6A == rc6_mode(data) && !ev.pulse &&
> -				geq_margin(ev.duration, RC6_SUFFIX_SPACE, RC6_UNIT / 2)) {
> +		} else if (RC6_MODE_6A == rc6_mode(data) && is_space(ev) &&
> +				geq_margin(ev.val, RC6_SUFFIX_SPACE, RC6_UNIT / 2)) {
>  			data->state = STATE_FINISHED;
>  			goto again;
>  		}
> @@ -227,7 +229,7 @@ again:
>  		goto again;
>  
>  	case STATE_FINISHED:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
>  		switch (rc6_mode(data)) {
> @@ -286,7 +288,7 @@ again:
>  
>  out:
>  	IR_dprintk(1, "RC6 decode failed at state %i (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  	data->state = STATE_INACTIVE;
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
> index 9f97648..b1be396 100644
> --- a/drivers/media/rc/ir-sanyo-decoder.c
> +++ b/drivers/media/rc/ir-sanyo-decoder.c
> @@ -48,11 +48,11 @@ enum sanyo_state {
>  /**
>   * ir_sanyo_decode() - Decode one SANYO pulse or space
>   * @dev:	the struct rc_dev descriptor of the device
> - * @duration:	the struct ir_raw_event descriptor of the pulse/space
> + * @ev:		the struct rc_event descriptor of the event
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_sanyo_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct sanyo_dec *data = &dev->raw->sanyo;
>  	u32 scancode;
> @@ -61,24 +61,24 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	if (!(dev->enabled_protocols & RC_BIT_SANYO))
>  		return 0;
>  
> -	if (!is_timing_event(ev)) {
> -		if (ev.reset) {
> -			IR_dprintk(1, "SANYO event reset received. reset to state 0\n");
> -			data->state = STATE_INACTIVE;
> -		}
> +	if (ev.code == RC_IR_RESET) {
> +		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> +	if (!is_ir_raw_timing_event(ev))
> +		return 0;
> +
>  	IR_dprintk(2, "SANYO decode started at state %d (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  
>  	switch (data->state) {
>  
>  	case STATE_INACTIVE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (eq_margin(ev.duration, SANYO_HEADER_PULSE, SANYO_UNIT / 2)) {
> +		if (eq_margin(ev.val, SANYO_HEADER_PULSE, SANYO_UNIT / 2)) {
>  			data->count = 0;
>  			data->state = STATE_HEADER_SPACE;
>  			return 0;
> @@ -87,10 +87,10 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  
>  
>  	case STATE_HEADER_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (eq_margin(ev.duration, SANYO_HEADER_SPACE, SANYO_UNIT / 2)) {
> +		if (eq_margin(ev.val, SANYO_HEADER_SPACE, SANYO_UNIT / 2)) {
>  			data->state = STATE_BIT_PULSE;
>  			return 0;
>  		}
> @@ -98,20 +98,20 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		break;
>  
>  	case STATE_BIT_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, SANYO_BIT_PULSE, SANYO_UNIT / 2))
> +		if (!eq_margin(ev.val, SANYO_BIT_PULSE, SANYO_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_BIT_SPACE;
>  		return 0;
>  
>  	case STATE_BIT_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!data->count && geq_margin(ev.duration, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
> +		if (!data->count && geq_margin(ev.val, SANYO_REPEAT_SPACE, SANYO_UNIT / 2)) {
>  			rc_repeat(dev);
>  			IR_dprintk(1, "SANYO repeat last key\n");
>  			data->state = STATE_INACTIVE;
> @@ -119,9 +119,9 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		}
>  
>  		data->bits <<= 1;
> -		if (eq_margin(ev.duration, SANYO_BIT_1_SPACE, SANYO_UNIT / 2))
> +		if (eq_margin(ev.val, SANYO_BIT_1_SPACE, SANYO_UNIT / 2))
>  			data->bits |= 1;
> -		else if (!eq_margin(ev.duration, SANYO_BIT_0_SPACE, SANYO_UNIT / 2))
> +		else if (!eq_margin(ev.val, SANYO_BIT_0_SPACE, SANYO_UNIT / 2))
>  			break;
>  		data->count++;
>  
> @@ -133,20 +133,20 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return 0;
>  
>  	case STATE_TRAILER_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, SANYO_TRAILER_PULSE, SANYO_UNIT / 2))
> +		if (!eq_margin(ev.val, SANYO_TRAILER_PULSE, SANYO_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_TRAILER_SPACE;
>  		return 0;
>  
>  	case STATE_TRAILER_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!geq_margin(ev.duration, SANYO_TRAILER_SPACE, SANYO_UNIT / 2))
> +		if (!geq_margin(ev.val, SANYO_TRAILER_SPACE, SANYO_UNIT / 2))
>  			break;
>  
>  		address     = bitrev16((data->bits >> 29) & 0x1fff) >> 3;
> @@ -169,7 +169,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	}
>  
>  	IR_dprintk(1, "SANYO decode failed at count %d state %d (%uus %s)\n",
> -		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->count, data->state, TO_US(ev.val), TO_STR(ev.code));
>  	data->state = STATE_INACTIVE;
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
> index b7acdba..435f0ac 100644
> --- a/drivers/media/rc/ir-sharp-decoder.c
> +++ b/drivers/media/rc/ir-sharp-decoder.c
> @@ -39,11 +39,11 @@ enum sharp_state {
>  /**
>   * ir_sharp_decode() - Decode one Sharp pulse or space
>   * @dev:	the struct rc_dev descriptor of the device
> - * @duration:	the struct ir_raw_event descriptor of the pulse/space
> + * @ev:		the struct rc_event descriptor of the event
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_sharp_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct sharp_dec *data = &dev->raw->sharp;
>  	u32 msg, echo, address, command, scancode;
> @@ -51,51 +51,53 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	if (!(dev->enabled_protocols & RC_BIT_SHARP))
>  		return 0;
>  
> -	if (!is_timing_event(ev)) {
> -		if (ev.reset)
> -			data->state = STATE_INACTIVE;
> +	if (ev.code == RC_IR_RESET) {
> +		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> +	if (!is_ir_raw_timing_event(ev))
> +		return 0;
> +
>  	IR_dprintk(2, "Sharp decode started at state %d (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  
>  	switch (data->state) {
>  
>  	case STATE_INACTIVE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, SHARP_BIT_PULSE,
> +		if (!eq_margin(ev.val, SHARP_BIT_PULSE,
>  			       SHARP_BIT_PULSE / 2))
>  			break;
>  
>  		data->count = 0;
> -		data->pulse_len = ev.duration;
> +		data->pulse_len = ev.val;
>  		data->state = STATE_BIT_SPACE;
>  		return 0;
>  
>  	case STATE_BIT_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, SHARP_BIT_PULSE,
> +		if (!eq_margin(ev.val, SHARP_BIT_PULSE,
>  			       SHARP_BIT_PULSE / 2))
>  			break;
>  
> -		data->pulse_len = ev.duration;
> +		data->pulse_len = ev.val;
>  		data->state = STATE_BIT_SPACE;
>  		return 0;
>  
>  	case STATE_BIT_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
>  		data->bits <<= 1;
> -		if (eq_margin(data->pulse_len + ev.duration, SHARP_BIT_1_PERIOD,
> +		if (eq_margin(data->pulse_len + ev.val, SHARP_BIT_1_PERIOD,
>  			      SHARP_BIT_PULSE * 2))
>  			data->bits |= 1;
> -		else if (!eq_margin(data->pulse_len + ev.duration,
> +		else if (!eq_margin(data->pulse_len + ev.val,
>  				    SHARP_BIT_0_PERIOD, SHARP_BIT_PULSE * 2))
>  			break;
>  		data->count++;
> @@ -109,11 +111,10 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return 0;
>  
>  	case STATE_TRAILER_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, SHARP_BIT_PULSE,
> -			       SHARP_BIT_PULSE / 2))
> +		if (!eq_margin(ev.val, SHARP_BIT_PULSE, SHARP_BIT_PULSE / 2))
>  			break;
>  
>  		if (data->count == SHARP_NBITS) {
> @@ -127,11 +128,10 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return 0;
>  
>  	case STATE_ECHO_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, SHARP_ECHO_SPACE,
> -			       SHARP_ECHO_SPACE / 4))
> +		if (!eq_margin(ev.val, SHARP_ECHO_SPACE, SHARP_ECHO_SPACE / 4))
>  			break;
>  
>  		data->state = STATE_BIT_PULSE;
> @@ -139,10 +139,10 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return 0;
>  
>  	case STATE_TRAILER_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!geq_margin(ev.duration, SHARP_TRAILER_SPACE,
> +		if (!geq_margin(ev.val, SHARP_TRAILER_SPACE,
>  				SHARP_BIT_PULSE / 2))
>  			break;
>  
> @@ -168,8 +168,7 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	}
>  
>  	IR_dprintk(1, "Sharp decode failed at count %d state %d (%uus %s)\n",
> -		   data->count, data->state, TO_US(ev.duration),
> -		   TO_STR(ev.pulse));
> +		   data->count, data->state, TO_US(ev.val), TO_STR(ev.code));
>  	data->state = STATE_INACTIVE;
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
> index d12dc3d..f7c4aa1 100644
> --- a/drivers/media/rc/ir-sony-decoder.c
> +++ b/drivers/media/rc/ir-sony-decoder.c
> @@ -35,11 +35,11 @@ enum sony_state {
>  /**
>   * ir_sony_decode() - Decode one Sony pulse or space
>   * @dev:	the struct rc_dev descriptor of the device
> - * @ev:         the struct ir_raw_event descriptor of the pulse/space
> + * @ev:         the struct rc_event descriptor of the event
>   *
>   * This function returns -EINVAL if the pulse violates the state machine
>   */
> -static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +static int ir_sony_decode(struct rc_dev *dev, struct rc_event ev)
>  {
>  	struct sony_dec *data = &dev->raw->sony;
>  	enum rc_type protocol;
> @@ -50,25 +50,27 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
>  		return 0;
>  
> -	if (!is_timing_event(ev)) {
> -		if (ev.reset)
> -			data->state = STATE_INACTIVE;
> +	if (ev.code == RC_IR_RESET) {
> +		data->state = STATE_INACTIVE;
>  		return 0;
>  	}
>  
> -	if (!geq_margin(ev.duration, SONY_UNIT, SONY_UNIT / 2))
> +	if (!is_ir_raw_timing_event(ev))
> +		return 0;
> +
> +	if (!geq_margin(ev.val, SONY_UNIT, SONY_UNIT / 2))
>  		goto out;
>  
>  	IR_dprintk(2, "Sony decode started at state %d (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  
>  	switch (data->state) {
>  
>  	case STATE_INACTIVE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, SONY_HEADER_PULSE, SONY_UNIT / 2))
> +		if (!eq_margin(ev.val, SONY_HEADER_PULSE, SONY_UNIT / 2))
>  			break;
>  
>  		data->count = 0;
> @@ -76,23 +78,23 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return 0;
>  
>  	case STATE_HEADER_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!eq_margin(ev.duration, SONY_HEADER_SPACE, SONY_UNIT / 2))
> +		if (!eq_margin(ev.val, SONY_HEADER_SPACE, SONY_UNIT / 2))
>  			break;
>  
>  		data->state = STATE_BIT_PULSE;
>  		return 0;
>  
>  	case STATE_BIT_PULSE:
> -		if (!ev.pulse)
> +		if (is_space(ev))
>  			break;
>  
>  		data->bits <<= 1;
> -		if (eq_margin(ev.duration, SONY_BIT_1_PULSE, SONY_UNIT / 2))
> +		if (eq_margin(ev.val, SONY_BIT_1_PULSE, SONY_UNIT / 2))
>  			data->bits |= 1;
> -		else if (!eq_margin(ev.duration, SONY_BIT_0_PULSE, SONY_UNIT / 2))
> +		else if (!eq_margin(ev.val, SONY_BIT_0_PULSE, SONY_UNIT / 2))
>  			break;
>  
>  		data->count++;
> @@ -100,15 +102,15 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		return 0;
>  
>  	case STATE_BIT_SPACE:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!geq_margin(ev.duration, SONY_BIT_SPACE, SONY_UNIT / 2))
> +		if (!geq_margin(ev.val, SONY_BIT_SPACE, SONY_UNIT / 2))
>  			break;
>  
>  		decrease_duration(&ev, SONY_BIT_SPACE);
>  
> -		if (!geq_margin(ev.duration, SONY_UNIT, SONY_UNIT / 2)) {
> +		if (!geq_margin(ev.val, SONY_UNIT, SONY_UNIT / 2)) {
>  			data->state = STATE_BIT_PULSE;
>  			return 0;
>  		}
> @@ -117,10 +119,10 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  		/* Fall through */
>  
>  	case STATE_FINISHED:
> -		if (ev.pulse)
> +		if (is_pulse(ev))
>  			break;
>  
> -		if (!geq_margin(ev.duration, SONY_TRAILER_SPACE, SONY_UNIT / 2))
> +		if (!geq_margin(ev.val, SONY_TRAILER_SPACE, SONY_UNIT / 2))
>  			break;
>  
>  		switch (data->count) {
> @@ -168,7 +170,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  
>  out:
>  	IR_dprintk(1, "Sony decode failed at state %d (%uus %s)\n",
> -		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
> +		   data->state, TO_US(ev.val), TO_STR(ev.code));
>  	data->state = STATE_INACTIVE;
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
> index 2755e06..c3eb7e6 100644
> --- a/drivers/media/rc/ite-cir.c
> +++ b/drivers/media/rc/ite-cir.c
> @@ -190,16 +190,15 @@ static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
>  	size = length << 3;
>  	next_one = find_next_bit_le(ldata, size, 0);
>  	if (next_one > 0) {
> -		ev.pulse = true;
> -		ev.duration =
> -		    ITE_BITS_TO_NS(next_one, sample_period);
> +		ev.code = RC_IR_PULSE;
> +		ev.val = ITE_BITS_TO_NS(next_one, sample_period);
>  		ir_raw_event_store_with_filter(dev->rdev, &ev);
>  	}
>  
>  	while (next_one < size) {
>  		next_zero = find_next_zero_bit_le(ldata, size, next_one + 1);
> -		ev.pulse = false;
> -		ev.duration = ITE_BITS_TO_NS(next_zero - next_one, sample_period);
> +		ev.code = RC_IR_SPACE;
> +		ev.val = ITE_BITS_TO_NS(next_zero - next_one, sample_period);
>  		ir_raw_event_store_with_filter(dev->rdev, &ev);
>  
>  		if (next_zero < size) {
> @@ -207,12 +206,10 @@ static void ite_decode_bytes(struct ite_dev *dev, const u8 * data, int
>  			    find_next_bit_le(ldata,
>  						     size,
>  						     next_zero + 1);
> -			ev.pulse = true;
> -			ev.duration =
> -			    ITE_BITS_TO_NS(next_one - next_zero,
> -					   sample_period);
> -			ir_raw_event_store_with_filter
> -			    (dev->rdev, &ev);
> +			ev.code = RC_IR_PULSE;
> +			ev.val = ITE_BITS_TO_NS(next_one - next_zero,
> +						sample_period);
> +			ir_raw_event_store_with_filter(dev->rdev, &ev);
>  		} else
>  			next_one = size;
>  	}
> diff --git a/drivers/media/rc/ite-cir.h b/drivers/media/rc/ite-cir.h
> index aa899a0..5c1fa57 100644
> --- a/drivers/media/rc/ite-cir.h
> +++ b/drivers/media/rc/ite-cir.h
> @@ -125,7 +125,7 @@ struct ite_dev_params {
>  struct ite_dev {
>  	struct pnp_dev *pdev;
>  	struct rc_dev *rdev;
> -	struct ir_raw_event rawir;
> +	struct rc_event rawir;
>  
>  	/* sync data */
>  	spinlock_t lock;
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index eac87ec..7f95d78 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -994,13 +994,16 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  		case PARSE_IRDATA:
>  			ir->rem--;
>  			init_ir_raw_event(&rawir);
> -			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
> -			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
> -					 * US_TO_NS(MCE_TIME_UNIT);
> +			if (ir->buf_in[i] & MCE_PULSE_BIT)
> +				rawir.code = RC_IR_PULSE;
> +			else
> +				rawir.code = RC_IR_SPACE;
> +			rawir.val = (ir->buf_in[i] & MCE_PULSE_MASK) *
> +				    US_TO_NS(MCE_TIME_UNIT);
>  
> -			dev_dbg(ir->dev, "Storing %s with duration %d",
> -				rawir.pulse ? "pulse" : "space",
> -				rawir.duration);
> +			dev_dbg(ir->dev, "Storing %s with duration %llu\n",
> +				rawir.code == RC_IR_PULSE ? "pulse" : "space",
> +				(long long unsigned)rawir.val);
>  
>  			if (ir_raw_event_store_with_filter(ir->rc, &rawir))
>  				event = true;
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 9e63ee6..3a54760 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -611,7 +611,7 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
>   */
>  static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
>  {
> -	DEFINE_IR_RAW_EVENT(rawir);
> +	DEFINE_IR_RAW_EVENT(ev);
>  	u8 sample;
>  	int i;
>  
> @@ -622,19 +622,19 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
>  
>  	nvt_dbg_verbose("Processing buffer of len %d", nvt->pkts);
>  
> -	init_ir_raw_event(&rawir);
> -
>  	for (i = 0; i < nvt->pkts; i++) {
>  		sample = nvt->buf[i];
>  
> -		rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
> -		rawir.duration = US_TO_NS((sample & BUF_LEN_MASK)
> -					  * SAMPLE_PERIOD);
> +		ev.code = RC_IR_SPACE;
> +		if (sample & BUF_PULSE_BIT)
> +			ev.code = RC_IR_PULSE;
> +		ev.val = US_TO_NS((sample & BUF_LEN_MASK) * SAMPLE_PERIOD);
>  
> -		nvt_dbg("Storing %s with duration %d",
> -			rawir.pulse ? "pulse" : "space", rawir.duration);
> +		nvt_dbg("Storing %s with duration %llu",
> +			ev.code == RC_IR_PULSE ? "pulse" : "space",
> +			(long long unsigned)ev.val);
>  
> -		ir_raw_event_store_with_filter(nvt->rdev, &rawir);
> +		ir_raw_event_store_with_filter(nvt->rdev, &ev);
>  
>  		/*
>  		 * BUF_PULSE_BIT indicates end of IR data, BUF_REPEAT_BYTE
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index 04776e8..4945727 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -18,7 +18,6 @@
>  
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> -#include <media/rc-core.h>
>  #include <media/rc-ir-raw.h>
>  
>  enum rc_driver_type {
> @@ -30,7 +29,7 @@ struct ir_raw_handler {
>  	struct list_head list;
>  
>  	unsigned protocols; /* which are handled by this handler */
> -	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
> +	int (*decode)(struct rc_dev *dev, struct rc_event event);
>  
>  	/* These two should only be used by the lirc decoder */
>  	int (*raw_register)(struct rc_dev *dev);
> @@ -43,14 +42,14 @@ struct ir_raw_handler {
>  struct ir_raw_event_ctrl {
>  	struct list_head		list;		/* to keep track of raw clients */
>  	struct task_struct		*thread;
> -	DECLARE_KFIFO(kfifo, struct ir_raw_event, RC_MAX_IR_EVENTS); /* for pulse/space durations */
> +	DECLARE_KFIFO(kfifo, struct rc_event, RC_MAX_IR_EVENTS); /* for pulse/space durations */
>  	ktime_t				last_event;	/* when last event occurred */
>  	enum raw_event_type		last_type;	/* last event type */
>  	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
>  
>  	/* raw decoder state follows */
> -	struct ir_raw_event prev_ev;
> -	struct ir_raw_event this_ev;
> +	struct rc_event prev_ev;
> +	struct rc_event this_ev;
>  	struct nec_dec {
>  		int state;
>  		unsigned count;
> @@ -131,27 +130,34 @@ static inline bool eq_margin(unsigned d1, unsigned d2, unsigned margin)
>  	return ((d1 > (d2 - margin)) && (d1 < (d2 + margin)));
>  }
>  
> -static inline bool is_transition(struct ir_raw_event *x, struct ir_raw_event *y)
> +static inline bool is_transition(struct rc_event *x, struct rc_event *y)
>  {
> -	return x->pulse != y->pulse;
> +	return x->code != y->code;
>  }
>  
> -static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
> +static inline void decrease_duration(struct rc_event *ev, unsigned duration)
>  {
> -	if (duration > ev->duration)
> -		ev->duration = 0;
> -	else
> -		ev->duration -= duration;
> +	ev->val -= min_t(u64, ev->val, duration);
>  }
>  
> -/* Returns true if event is normal pulse/space event */
> -static inline bool is_timing_event(struct ir_raw_event ev)
> +static inline bool is_pulse(struct rc_event ev)
>  {
> -	return !ev.carrier_report && !ev.reset;
> +	return ev.type == RC_IR && ev.code == RC_IR_PULSE;
>  }
>  
> -#define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
> -#define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
> +static inline bool is_space(struct rc_event ev)
> +{
> +	return ev.type == RC_IR && ev.code == RC_IR_SPACE;
> +}
> +
> +static inline bool is_ir_raw_timing_event(struct rc_event ev)
> +{
> +	return ev.type == RC_IR &&
> +	       (ev.code == RC_IR_SPACE || ev.code == RC_IR_PULSE);
> +}
> +
> +#define TO_US(duration)			((unsigned)DIV_ROUND_CLOSEST((duration), 1000))
> +#define TO_STR(code)			((code == RC_IR_PULSE) ? "pulse" : "space")
>  
>  /*
>   * Routines from rc-raw.c to be used internally and by decoders
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index 3b68975..0c1923a 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -19,6 +19,8 @@
>  #include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/freezer.h>
> +#include <media/rc-ir-raw.h>
> +
>  #include "rc-core-priv.h"
>  
>  /* IR raw clients/handlers, writers synchronize with ir_raw_mutex */
> @@ -31,12 +33,12 @@ static atomic_t available_protocols = ATOMIC_INIT(0);
>  
>  static int ir_raw_event_thread(void *data)
>  {
> -	struct ir_raw_event ev;
> +	struct rc_event ev;
>  	struct ir_raw_handler *handler;
>  	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
>  
>  	while (!kthread_should_stop()) {
> -		if (kfifo_out(&raw->kfifo, &ev, 1) == 0) {
> +		if (!kfifo_get(&raw->kfifo, &ev)) {
>  			set_current_state(TASK_INTERRUPTIBLE);
>  			schedule();
>  			continue;
> @@ -55,36 +57,26 @@ static int ir_raw_event_thread(void *data)
>  /**
>   * ir_raw_event_store() - pass a pulse/space duration to the raw ir decoders
>   * @dev:	the struct rc_dev device descriptor
> - * @ev:		the struct ir_raw_event descriptor of the pulse/space
> + * @ev:		the struct rc_event descriptor of the event
> + *
> + * This routine (which may be called from an interrupt context) stores an
> + * event for the raw ir decoding state machines and interested userspace
> + * processes.
>   *
> - * This routine (which may be called from an interrupt context) stores a
> - * pulse/space duration for the raw ir decoding state machines. Pulses are
> - * signalled as positive values and spaces as negative values. A zero value
> - * will reset the decoding state machines. Drivers are responsible for
> - * synchronizing calls to this function.
> + * Drivers are responsible for synchronizing calls to this function.
>   */
> -int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
> +int ir_raw_event_store(struct rc_dev *dev, struct rc_event *ev)
>  {
>  	if (!dev->raw)
>  		return -EINVAL;
>  
> -	IR_dprintk(2, "sample: (%05dus %s)\n",
> -		   TO_US(ev->duration), TO_STR(ev->pulse));
> -
> -	if (ev->reset)
> -		rc_event(dev, RC_IR, RC_IR_RESET, 1);
> -	else if (ev->carrier_report)
> -		rc_event(dev, RC_IR, RC_IR_CARRIER, ev->carrier);
> -	else if (ev->timeout)
> -		rc_event(dev, RC_IR, RC_IR_STOP, 1);
> -	else if (ev->pulse)
> -		rc_event(dev, RC_IR, RC_IR_PULSE, ev->duration);
> -	else
> -		rc_event(dev, RC_IR, RC_IR_SPACE, ev->duration);
> +	if (ev->type != RC_IR)
> +		return -EINVAL;
>  
> -	if (kfifo_in(&dev->raw->kfifo, ev, 1) != 1)
> +	if (!kfifo_put(&dev->raw->kfifo, *ev))
>  		return -ENOMEM;
>  
> +	rc_event(dev, ev->type, ev->code, ev->val);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(ir_raw_event_store);
> @@ -120,15 +112,15 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
>  	if (delta > MS_TO_NS(500) || !dev->raw->last_type)
>  		type |= IR_START_EVENT;
>  	else
> -		ev.duration = delta;
> +		ev.val = delta;
>  
>  	if (type & IR_START_EVENT)
>  		ir_raw_event_reset(dev);
>  	else if (dev->raw->last_type & IR_SPACE) {
> -		ev.pulse = false;
> +		ev.code = RC_IR_SPACE;
>  		rc = ir_raw_event_store(dev, &ev);
>  	} else if (dev->raw->last_type & IR_PULSE) {
> -		ev.pulse = true;
> +		ev.code = RC_IR_PULSE;
>  		rc = ir_raw_event_store(dev, &ev);
>  	} else
>  		return 0;
> @@ -142,7 +134,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
>  /**
>   * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
>   * @dev:	the struct rc_dev device descriptor
> - * @type:	the type of the event that has occurred
> + * @ev:		the struct rc_event descriptor of the event
>   *
>   * This routine (which may be called from an interrupt context) works
>   * in similar manner to ir_raw_event_store_edge.
> @@ -151,29 +143,35 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
>   * if the event was added, and zero if the event was ignored due to idle
>   * processing.
>   */
> -int ir_raw_event_store_with_filter(struct rc_dev *dev, struct ir_raw_event *ev)
> +int ir_raw_event_store_with_filter(struct rc_dev *dev, struct rc_event *ev)
>  {
>  	if (!dev->raw)
>  		return -EINVAL;
>  
>  	/* Ignore spaces in idle mode */
> -	if (dev->idle && !ev->pulse)
> -		return 0;
> -	else if (dev->idle)
> +	if (dev->idle) {
> +		if (ev->code == RC_IR_SPACE)
> +			return 0;
>  		ir_raw_event_set_idle(dev, false);
> +	}
> +
> +	if (!is_ir_raw_timing_event(*ev)) {
> +		ir_raw_event_store(dev, &dev->raw->this_ev);
> +		return 0;
> +	}
>  
> -	if (!dev->raw->this_ev.duration)
> +	if (!dev->raw->this_ev.val)
>  		dev->raw->this_ev = *ev;
> -	else if (ev->pulse == dev->raw->this_ev.pulse)
> -		dev->raw->this_ev.duration += ev->duration;
> +	else if (ev->code == dev->raw->this_ev.code)
> +		dev->raw->this_ev.val += ev->val;
>  	else {
>  		ir_raw_event_store(dev, &dev->raw->this_ev);
>  		dev->raw->this_ev = *ev;
>  	}
>  
>  	/* Enter idle mode if nessesary */
> -	if (!ev->pulse && dev->timeout &&
> -	    dev->raw->this_ev.duration >= dev->timeout)
> +	if (ev->code == RC_IR_SPACE && dev->timeout &&
> +	    dev->raw->this_ev.val >= dev->timeout)
>  		ir_raw_event_set_idle(dev, true);
>  
>  	return 1;
> @@ -187,17 +185,30 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
>   */
>  void ir_raw_event_set_idle(struct rc_dev *dev, bool idle)
>  {
> +	DEFINE_IR_RAW_EVENT(ev);
> +
>  	if (!dev->raw)
>  		return;
>  
> +	if (dev->idle == idle)
> +		return;
> +
>  	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
>  
> +
>  	if (idle) {
> -		dev->raw->this_ev.timeout = true;
> -		ir_raw_event_store(dev, &dev->raw->this_ev);
> -		init_ir_raw_event(&dev->raw->this_ev);
> +		if (dev->raw->this_ev.val > 0)
> +			ir_raw_event_store(dev, &dev->raw->this_ev);
> +		ev.code = RC_IR_STOP;
> +		ev.val = 1;
> +	} else {
> +		ev.code = RC_IR_START;
> +		ev.val = 1;
>  	}
>  
> +	init_ir_raw_event(&dev->raw->this_ev);
> +	ir_raw_event_store(dev, &ev);
> +
>  	if (dev->s_idle)
>  		dev->s_idle(dev, idle);
>  
> diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
> index 343c8d0..26c03bd 100644
> --- a/drivers/media/rc/rc-loopback.c
> +++ b/drivers/media/rc/rc-loopback.c
> @@ -54,7 +54,6 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned count)
>  	struct loopback_dev *lodev = dev->priv;
>  	u32 rxmask;
>  	struct rc_event ev;
> -	DEFINE_IR_RAW_EVENT(rawir);
>  	int tmp;
>  
>  	if (lodev->txcarrier < lodev->rxcarriermin ||
> @@ -78,17 +77,14 @@ static int loop_tx_ir(struct rc_dev *dev, unsigned count)
>  	while ((tmp = ir_raw_get_tx_event(dev, &ev)) != 0) {
>  		if (tmp < 0)
>  			continue;
> -		init_ir_raw_event(&rawir);
> -		rawir.pulse = (ev.code == RC_IR_PULSE);
> -		rawir.duration = ev.val;
> -		ir_raw_event_store_with_filter(dev, &rawir);
> +		ir_raw_event_store_with_filter(dev, &ev);
>  	}
>  
>  	/* Fake a silence long enough to cause us to go idle */
> -	init_ir_raw_event(&rawir);
> -	rawir.pulse = false;
> -	rawir.duration = dev->timeout;
> -	ir_raw_event_store_with_filter(dev, &rawir);
> +	ev.type = RC_IR;
> +	ev.code = RC_IR_SPACE;
> +	ev.val = dev->timeout;
> +	ir_raw_event_store_with_filter(dev, &ev);
>  
>  	ir_raw_event_handle(dev);
>  
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index 17974bf..e93a593 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -365,7 +365,7 @@ static void redrat3_rx_timeout(unsigned long data)
>  
>  static void redrat3_process_ir_data(struct redrat3_dev *rr3)
>  {
> -	DEFINE_IR_RAW_EVENT(rawir);
> +	struct rc_event ev;
>  	struct device *dev;
>  	unsigned i, trailer = 0;
>  	unsigned sig_size, single_len, offset, val;
> @@ -396,34 +396,28 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
>  		single_len = redrat3_len_to_us(val);
>  
>  		/* we should always get pulse/space/pulse/space samples */
> -		if (i % 2)
> -			rawir.pulse = false;
> -		else
> -			rawir.pulse = true;
> +		ev.type = RC_IR;
> +		ev.code = i % 2 ? RC_IR_SPACE : RC_IR_PULSE;
> +		ev.val = min_t(u64, IR_MAX_DURATION, US_TO_NS(single_len));
>  
> -		rawir.duration = US_TO_NS(single_len);
>  		/* Save initial pulse length to fudge trailer */
>  		if (i == 0)
> -			trailer = rawir.duration;
> -		/* cap the value to IR_MAX_DURATION */
> -		rawir.duration &= IR_MAX_DURATION;
> +			trailer = single_len;
>  
> -		rr3_dbg(dev, "storing %s with duration %d (i: %d)\n",
> -			rawir.pulse ? "pulse" : "space", rawir.duration, i);
> -		ir_raw_event_store_with_filter(rr3->rc, &rawir);
> +		rr3_dbg(dev, "storing %s with duration %llu (i: %d)\n",
> +			ev.code == RC_IR_PULSE ? "pulse" : "space",
> +			(long long unsigned)ev.val, i);
> +		ir_raw_event_store_with_filter(rr3->rc, &ev);
>  	}
>  
>  	/* add a trailing space, if need be */
>  	if (i % 2) {
> -		rawir.pulse = false;
> +		ev.code = RC_IR_SPACE;
>  		/* this duration is made up, and may not be ideal... */
> -		if (trailer < US_TO_NS(1000))
> -			rawir.duration = US_TO_NS(2800);
> -		else
> -			rawir.duration = trailer;
> -		rr3_dbg(dev, "storing trailing space with duration %d\n",
> -			rawir.duration);
> -		ir_raw_event_store_with_filter(rr3->rc, &rawir);
> +		ev.val = US_TO_NS(trailer < 1000 ? 2800 : trailer);
> +		rr3_dbg(dev, "storing trailing space with duration %llu\n",
> +			(long long unsigned)ev.val);
> +		ir_raw_event_store_with_filter(rr3->rc, &ev);
>  	}
>  
>  	rr3_dbg(dev, "calling ir_raw_event_handle\n");
> diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
> index 149e824..d30e3f7 100644
> --- a/drivers/media/rc/streamzap.c
> +++ b/drivers/media/rc/streamzap.c
> @@ -129,17 +129,18 @@ static struct usb_driver streamzap_driver = {
>  	.id_table =	streamzap_table,
>  };
>  
> -static void sz_push(struct streamzap_ir *sz, struct ir_raw_event rawir)
> +static void sz_push(struct streamzap_ir *sz, struct rc_event ev)
>  {
>  	dev_dbg(sz->dev, "Storing %s with duration %u us\n",
> -		(rawir.pulse ? "pulse" : "space"), rawir.duration);
> -	ir_raw_event_store_with_filter(sz->rdev, &rawir);
> +		(ev.code == RC_IR_PULSE ? "pulse" : "space"),
> +		(unsigned)(ev.val / 1000));
> +	ir_raw_event_store_with_filter(sz->rdev, &ev);
>  }
>  
>  static void sz_push_full_pulse(struct streamzap_ir *sz,
>  			       unsigned char value)
>  {
> -	DEFINE_IR_RAW_EVENT(rawir);
> +	DEFINE_IR_RAW_EVENT(ev);
>  
>  	if (sz->idle) {
>  		long deltv;
> @@ -148,31 +149,29 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
>  		do_gettimeofday(&sz->signal_start);
>  
>  		deltv = sz->signal_start.tv_sec - sz->signal_last.tv_sec;
> -		rawir.pulse = false;
> +		ev.code = RC_IR_SPACE;
>  		if (deltv > 15) {
>  			/* really long time */
> -			rawir.duration = IR_MAX_DURATION;
> +			ev.val = IR_MAX_DURATION;
>  		} else {
> -			rawir.duration = (int)(deltv * 1000000 +
> -				sz->signal_start.tv_usec -
> -				sz->signal_last.tv_usec);
> -			rawir.duration -= sz->sum;
> -			rawir.duration = US_TO_NS(rawir.duration);
> -			rawir.duration &= IR_MAX_DURATION;
> +			ev.val = (deltv * 1000000 +
> +				  sz->signal_start.tv_usec -
> +				  sz->signal_last.tv_usec);
> +			ev.val -= sz->sum;
> +			ev.val = min_t(u64, US_TO_NS(ev.val), IR_MAX_DURATION);
>  		}
> -		sz_push(sz, rawir);
> +		sz_push(sz, ev);
>  
>  		sz->idle = false;
>  		sz->sum = 0;
>  	}
>  
> -	rawir.pulse = true;
> -	rawir.duration = ((int) value) * SZ_RESOLUTION;
> -	rawir.duration += SZ_RESOLUTION / 2;
> -	sz->sum += rawir.duration;
> -	rawir.duration = US_TO_NS(rawir.duration);
> -	rawir.duration &= IR_MAX_DURATION;
> -	sz_push(sz, rawir);
> +	ev.code = RC_IR_PULSE;
> +	ev.val = value * SZ_RESOLUTION;
> +	ev.val += SZ_RESOLUTION / 2;
> +	sz->sum += ev.val;
> +	ev.val = min_t(u64, US_TO_NS(ev.val), IR_MAX_DURATION);
> +	sz_push(sz, ev);
>  }
>  
>  static void sz_push_half_pulse(struct streamzap_ir *sz,
> @@ -184,14 +183,13 @@ static void sz_push_half_pulse(struct streamzap_ir *sz,
>  static void sz_push_full_space(struct streamzap_ir *sz,
>  			       unsigned char value)
>  {
> -	DEFINE_IR_RAW_EVENT(rawir);
> -
> -	rawir.pulse = false;
> -	rawir.duration = ((int) value) * SZ_RESOLUTION;
> -	rawir.duration += SZ_RESOLUTION / 2;
> -	sz->sum += rawir.duration;
> -	rawir.duration = US_TO_NS(rawir.duration);
> -	sz_push(sz, rawir);
> +	DEFINE_IR_RAW_EVENT(ev);
> +
> +	ev.code = RC_IR_SPACE;
> +	ev.val = value * SZ_RESOLUTION + SZ_RESOLUTION / 2;
> +	sz->sum += ev.val;
> +	ev.val = US_TO_NS(ev.val);
> +	sz_push(sz, ev);
>  }
>  
>  static void sz_push_half_space(struct streamzap_ir *sz,
> @@ -258,13 +256,13 @@ static void streamzap_callback(struct urb *urb)
>  			break;
>  		case FullSpace:
>  			if (sz->buf_in[i] == SZ_TIMEOUT) {
> -				DEFINE_IR_RAW_EVENT(rawir);
> +				DEFINE_IR_RAW_EVENT(ev);
>  
> -				rawir.pulse = false;
> -				rawir.duration = sz->rdev->timeout;
> +				ev.code = RC_IR_STOP;
> +				ev.val = 1;
>  				sz->idle = true;
>  				if (sz->timeout_enabled)
> -					sz_push(sz, rawir);
> +					sz_push(sz, ev);
>  				ir_raw_event_handle(sz->rdev);
>  				ir_raw_event_reset(sz->rdev);
>  			} else {
> diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
> index 19317e2..0e9b05c 100644
> --- a/drivers/media/rc/ttusbir.c
> +++ b/drivers/media/rc/ttusbir.c
> @@ -121,44 +121,43 @@ static void ttusbir_bulk_complete(struct urb *urb)
>   */
>  static void ttusbir_process_ir_data(struct ttusbir *tt, uint8_t *buf)
>  {
> -	struct ir_raw_event rawir;
> +	DEFINE_IR_RAW_EVENT(ev);
>  	unsigned i, v, b;
>  	bool event = false;
>  
> -	init_ir_raw_event(&rawir);
> -
>  	for (i = 0; i < 128; i++) {
>  		v = buf[i] & 0xfe;
>  		switch (v) {
>  		case 0xfe:
> -			rawir.pulse = false;
> -			rawir.duration = NS_PER_BYTE;
> -			if (ir_raw_event_store_with_filter(tt->rc, &rawir))
> +			ev.code = RC_IR_SPACE;
> +			ev.val = NS_PER_BYTE;
> +			if (ir_raw_event_store_with_filter(tt->rc, &ev))
>  				event = true;
>  			break;
>  		case 0:
> -			rawir.pulse = true;
> -			rawir.duration = NS_PER_BYTE;
> -			if (ir_raw_event_store_with_filter(tt->rc, &rawir))
> +			ev.code = RC_IR_PULSE;
> +			ev.val = NS_PER_BYTE;
> +			if (ir_raw_event_store_with_filter(tt->rc, &ev))
>  				event = true;
>  			break;
>  		default:
>  			/* one edge per byte */
>  			if (v & 2) {
>  				b = ffz(v | 1);
> -				rawir.pulse = true;
> +				ev.code = RC_IR_PULSE;
>  			} else {
>  				b = ffs(v) - 1;
> -				rawir.pulse = false;
> +				ev.code = RC_IR_SPACE;
>  			}
>  
> -			rawir.duration = NS_PER_BIT * (8 - b);
> -			if (ir_raw_event_store_with_filter(tt->rc, &rawir))
> +			ev.val = NS_PER_BIT * (8 - b);
> +			if (ir_raw_event_store_with_filter(tt->rc, &ev))
>  				event = true;
>  
> -			rawir.pulse = !rawir.pulse;
> -			rawir.duration = NS_PER_BIT * b;
> -			if (ir_raw_event_store_with_filter(tt->rc, &rawir))
> +			ev.val = ev.val == RC_IR_SPACE ?
> +				 RC_IR_PULSE : RC_IR_SPACE;
> +			ev.code = NS_PER_BIT * b;
> +			if (ir_raw_event_store_with_filter(tt->rc, &ev))
>  				event = true;
>  			break;
>  		}
> diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
> index 07da3e0..930a34e 100644
> --- a/drivers/media/rc/winbond-cir.c
> +++ b/drivers/media/rc/winbond-cir.c
> @@ -342,20 +342,18 @@ wbcir_carrier_report(struct wbcir_data *data)
>  
>  	if (counter > 0 && counter < 0xffff) {
>  		DEFINE_IR_RAW_EVENT(ev);
> -
> -		ev.carrier_report = 1;
> -		ev.carrier = DIV_ROUND_CLOSEST(counter * 1000000u,
> -						data->pulse_duration);
> -
> +		ev.code = RC_IR_CARRIER;
> +		ev.val = DIV_ROUND_CLOSEST(counter * 1000000u,
> +					   data->pulse_duration);
>  		ir_raw_event_store(data->dev, &ev);
>  	}
>  
>  	/* reset and restart the counter */
>  	data->pulse_duration = 0;
>  	wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CCTL, WBCIR_CNTR_R,
> -						WBCIR_CNTR_EN | WBCIR_CNTR_R);
> +		       WBCIR_CNTR_EN | WBCIR_CNTR_R);
>  	wbcir_set_bits(data->ebase + WBCIR_REG_ECEIR_CCTL, WBCIR_CNTR_EN,
> -						WBCIR_CNTR_EN | WBCIR_CNTR_R);
> +		       WBCIR_CNTR_EN | WBCIR_CNTR_R);
>  }
>  
>  static void
> @@ -381,7 +379,7 @@ static void
>  wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
>  {
>  	u8 irdata;
> -	DEFINE_IR_RAW_EVENT(rawir);
> +	struct rc_event ev;
>  	unsigned duration;
>  
>  	/* Since RXHDLEV is set, at least 8 bytes are in the FIFO */
> @@ -392,13 +390,14 @@ wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
>  
>  		duration = ((irdata & 0x7F) + 1) *
>  			(data->carrier_report_enabled ? 2 : 10);
> -		rawir.pulse = irdata & 0x80 ? false : true;
> -		rawir.duration = US_TO_NS(duration);
> +		ev.type = RC_IR;
> +		ev.code = irdata & 0x80 ? RC_IR_SPACE : RC_IR_PULSE;
> +		ev.val = US_TO_NS(duration);
>  
> -		if (rawir.pulse)
> +		if (ev.code == RC_IR_PULSE)
>  			data->pulse_duration += duration;
>  
> -		ir_raw_event_store_with_filter(data->dev, &rawir);
> +		ir_raw_event_store_with_filter(data->dev, &ev);
>  	}
>  
>  	ir_raw_event_handle(data->dev);
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 0412862..dc5d075 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -1281,7 +1281,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
>  {
>  	int ret, i, len;
>  	struct rtl28xxu_priv *priv = d->priv;
> -	struct ir_raw_event ev;
> +	struct rc_event ev;
>  	u8 buf[128];
>  	static const struct rtl28xxu_reg_val_mask refresh_tab[] = {
>  		{IR_RX_IF,               0x03, 0xff},
> @@ -1350,8 +1350,8 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
>  	init_ir_raw_event(&ev);
>  
>  	for (i = 0; i < len; i++) {
> -		ev.pulse = buf[i] >> 7;
> -		ev.duration = 50800 * (buf[i] & 0x7f);
> +		ev.code = buf[i] >> 7 ? RC_IR_PULSE : RC_IR_SPACE;
> +		ev.val = 50800 * (buf[i] & 0x7f);
>  		ir_raw_event_store_with_filter(d->rc_dev, &ev);
>  	}
>  
> diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
> index 288f24c..624a073 100644
> --- a/drivers/media/usb/dvb-usb/technisat-usb2.c
> +++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
> @@ -593,7 +593,7 @@ static int technisat_usb2_get_ir(struct dvb_usb_device *d)
>  {
>  	u8 buf[62], *b;
>  	int ret;
> -	struct ir_raw_event ev;
> +	DEFINE_IR_RAW_EVENT(ev);
>  
>  	buf[0] = GET_IR_DATA_VENDOR_REQUEST;
>  	buf[1] = 0x08;
> @@ -636,16 +636,19 @@ unlock:
>  	debug_dump(b, ret, deb_rc);
>  #endif
>  
> -	ev.pulse = 0;
>  	while (1) {
> -		ev.pulse = !ev.pulse;
> -		ev.duration = (*b * FIRMWARE_CLOCK_DIVISOR * FIRMWARE_CLOCK_TICK) / 1000;
> +		if (ev.code == RC_IR_SPACE)
> +			ev.code = RC_IR_PULSE;
> +		else
> +			ev.code = RC_IR_SPACE;
> +
> +		ev.val = (*b * FIRMWARE_CLOCK_DIVISOR * FIRMWARE_CLOCK_TICK) / 1000;
>  		ir_raw_event_store(d->rc_dev, &ev);
>  
>  		b++;
>  		if (*b == 0xff) {
> -			ev.pulse = 0;
> -			ev.duration = 888888*2;
> +			ev.code = RC_IR_SPACE;
> +			ev.val = 888888*2;
>  			ir_raw_event_store(d->rc_dev, &ev);
>  			break;
>  		}
> diff --git a/include/media/rc-ir-raw.h b/include/media/rc-ir-raw.h
> index dad3eb2..89bf2f7 100644
> --- a/include/media/rc-ir-raw.h
> +++ b/include/media/rc-ir-raw.h
> @@ -27,33 +27,17 @@ enum raw_event_type {
>  	IR_STOP_EVENT   = (1 << 3),
>  };
>  
> -struct ir_raw_event {
> -	union {
> -		u32             duration;
> +#define DEFINE_IR_RAW_EVENT(ev)			\
> +	struct rc_event ev = {			\
> +		.type = RC_IR,			\
> +		.code = RC_IR_PULSE,		\
> +		.val = 0 }
>  
> -		struct {
> -			u32     carrier;
> -			u8      duty_cycle;
> -		};
> -	};
> -
> -	unsigned                pulse:1;
> -	unsigned                reset:1;
> -	unsigned                timeout:1;
> -	unsigned                carrier_report:1;
> -};
> -
> -#define DEFINE_IR_RAW_EVENT(event) \
> -	struct ir_raw_event event = { \
> -		{ .duration = 0 } , \
> -		.pulse = 0, \
> -		.reset = 0, \
> -		.timeout = 0, \
> -		.carrier_report = 0 }
> -
> -static inline void init_ir_raw_event(struct ir_raw_event *ev)
> +static inline void init_ir_raw_event(struct rc_event *ev)
>  {
> -	memset(ev, 0, sizeof(*ev));
> +	ev->type = RC_IR;
> +	ev->code = RC_IR_PULSE;
> +	ev->val = 0;
>  }
>  
>  #define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
> @@ -62,10 +46,9 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
>  #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
>  
>  void ir_raw_event_handle(struct rc_dev *dev);
> -int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
> +int ir_raw_event_store(struct rc_dev *dev, struct rc_event *ev);
>  int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
> -int ir_raw_event_store_with_filter(struct rc_dev *dev,
> -				struct ir_raw_event *ev);
> +int ir_raw_event_store_with_filter(struct rc_dev *dev, struct rc_event *ev);
>  void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
>  int ir_raw_get_tx_event(struct rc_dev *dev, struct rc_event *ev);
>  int rc_register_ir_raw_device(struct rc_dev *dev);
> @@ -73,9 +56,11 @@ void rc_unregister_ir_raw_device(struct rc_dev *dev);
>  
>  static inline void ir_raw_event_reset(struct rc_dev *dev)
>  {
> -	DEFINE_IR_RAW_EVENT(ev);
> -	ev.reset = true;
> -
> +	struct rc_event ev = {
> +		.type = RC_IR,
> +		.code = RC_IR_RESET,
> +		.val = 1
> +	};
>  	ir_raw_event_store(dev, &ev);
>  	ir_raw_event_handle(dev);
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
