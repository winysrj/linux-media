Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40160 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab0IHWtV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 18:49:21 -0400
Date: Thu, 9 Sep 2010 00:49:15 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
Message-ID: <20100908224915.GA6699@hardeman.nu>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
 <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
 <4C88113C.8040703@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C88113C.8040703@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 07:42:04PM -0300, Mauro Carvalho Chehab wrote:
> Em 06-09-2010 18:26, Maxim Levitsky escreveu:
> > Add new event types for timeout & carrier report
> > Move timeout handling from ir_raw_event_store_with_filter to
> > ir-lirc-codec, where it is really needed.
> > Now lirc bridge ensures proper gap handling.
> > Extend lirc bridge for carrier & timeout reports
> > 
> > Note: all new ir_raw_event variables now should be initialized
> > like that: DEFINE_IR_RAW_EVENT(ev);
> > 
> > To clean an existing event, use init_ir_raw_event(&ev);
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/media/IR/ene_ir.c          |    4 +-
> >  drivers/media/IR/ir-core-priv.h    |   13 ++++++-
> >  drivers/media/IR/ir-jvc-decoder.c  |    5 +-
> >  drivers/media/IR/ir-lirc-codec.c   |   78 +++++++++++++++++++++++++++++++-----
> >  drivers/media/IR/ir-nec-decoder.c  |    5 +-
> >  drivers/media/IR/ir-raw-event.c    |   45 +++++++-------------
> >  drivers/media/IR/ir-rc5-decoder.c  |    5 +-
> >  drivers/media/IR/ir-rc6-decoder.c  |    5 +-
> >  drivers/media/IR/ir-sony-decoder.c |    5 +-
> >  drivers/media/IR/mceusb.c          |    3 +-
> >  drivers/media/IR/streamzap.c       |    8 ++-
> >  include/media/ir-core.h            |   40 ++++++++++++++++---
> >  12 files changed, 153 insertions(+), 63 deletions(-)
> > 
> > diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
> > index 7880d9c..dc32509 100644
> > --- a/drivers/media/IR/ene_ir.c
> > +++ b/drivers/media/IR/ene_ir.c
> > @@ -701,7 +701,7 @@ static irqreturn_t ene_isr(int irq, void *data)
> >  	unsigned long flags;
> >  	irqreturn_t retval = IRQ_NONE;
> >  	struct ene_device *dev = (struct ene_device *)data;
> > -	struct ir_raw_event ev;
> > +	DEFINE_IR_RAW_EVENT(ev);
> >  
> >  	spin_lock_irqsave(&dev->hw_lock, flags);
> >  
> > @@ -904,7 +904,7 @@ static int ene_set_learning_mode(void *data, int enable)
> >  }
> >  
> >  /* outside interface: enable or disable idle mode */
> > -static void ene_rx_set_idle(void *data, int idle)
> > +static void ene_rx_set_idle(void *data, bool idle)
> >  {
> >  	struct ene_device *dev = (struct ene_device *)data;
> >  
> > diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
> > index 5d7e08f..2559e72 100644
> > --- a/drivers/media/IR/ir-core-priv.h
> > +++ b/drivers/media/IR/ir-core-priv.h
> > @@ -82,6 +82,12 @@ struct ir_raw_event_ctrl {
> >  		struct ir_input_dev *ir_dev;
> >  		struct lirc_driver *drv;
> >  		int carrier_low;
> > +
> > +		ktime_t gap_start;
> > +		u64 gap_duration;
> > +		bool gap;
> > +		bool send_timeout_reports;
> > +
> >  	} lirc;
> >  };
> >  
> > @@ -109,9 +115,14 @@ static inline void decrease_duration(struct ir_raw_event *ev, unsigned duration)
> >  		ev->duration -= duration;
> >  }
> >  
> > +/* Returns true if event is normal pulse/space event */
> > +static inline bool is_timing_event(struct ir_raw_event ev)
> > +{
> > +	return !ev.carrier_report && !ev.reset;
> > +}
> > +
> >  #define TO_US(duration)			DIV_ROUND_CLOSEST((duration), 1000)
> >  #define TO_STR(is_pulse)		((is_pulse) ? "pulse" : "space")
> > -#define IS_RESET(ev)			(ev.duration == 0)
> >  /*
> >   * Routines from ir-sysfs.c - Meant to be called only internally inside
> >   * ir-core
> > diff --git a/drivers/media/IR/ir-jvc-decoder.c b/drivers/media/IR/ir-jvc-decoder.c
> > index 77a89c4..63dca6e 100644
> > --- a/drivers/media/IR/ir-jvc-decoder.c
> > +++ b/drivers/media/IR/ir-jvc-decoder.c
> > @@ -50,8 +50,9 @@ static int ir_jvc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
> >  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_JVC))
> >  		return 0;
> >  
> > -	if (IS_RESET(ev)) {
> > -		data->state = STATE_INACTIVE;
> > +	if (!is_timing_event(ev)) {
> > +		if (ev.reset)
> > +			data->state = STATE_INACTIVE;
> >  		return 0;
> >  	}
> >  
> > diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
> > index e63f757..0f40bc2 100644
> > --- a/drivers/media/IR/ir-lirc-codec.c
> > +++ b/drivers/media/IR/ir-lirc-codec.c
> > @@ -32,6 +32,7 @@
> >  static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
> >  {
> >  	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
> > +	struct lirc_codec *lirc = &ir_dev->raw->lirc;
> >  	int sample;
> >  
> >  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_LIRC))
> > @@ -40,21 +41,57 @@ static int ir_lirc_decode(struct input_dev *input_dev, struct ir_raw_event ev)
> >  	if (!ir_dev->raw->lirc.drv || !ir_dev->raw->lirc.drv->rbuf)
> >  		return -EINVAL;
> >  
> > -	if (IS_RESET(ev))
> > +	/* Packet start */
> > +	if (ev.reset)
> >  		return 0;
> >  
> > -	IR_dprintk(2, "LIRC data transfer started (%uus %s)\n",
> > -		   TO_US(ev.duration), TO_STR(ev.pulse));
> > +	/* Carrier reports */
> > +	if (ev.carrier_report) {
> > +		sample = LIRC_FREQUENCY(ev.carrier);
> > +
> > +	/* Packet end */
> > +	} else if (ev.timeout) {
> > +
> > +		if (lirc->gap)
> > +			return 0;
> > +
> > +		lirc->gap_start = ktime_get();
> > +		lirc->gap = true;
> > +		lirc->gap_duration = ev.duration;
> > +
> > +		if (!lirc->send_timeout_reports)
> > +			return 0;
> > +
> > +		sample = LIRC_TIMEOUT(ev.duration / 1000);
> >  
> > -	sample = ev.duration / 1000;
> > -	if (ev.pulse)
> > -		sample |= PULSE_BIT;
> > +	/* Normal sample */
> > +	} else {
> > +
> > +		if (lirc->gap) {
> > +			int gap_sample;
> > +
> > +			lirc->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
> > +				lirc->gap_start));
> > +
> > +			/* Convert to ms and cap by LIRC_VALUE_MASK */
> > +			do_div(lirc->gap_duration, 1000);
> > +			lirc->gap_duration = min(lirc->gap_duration,
> > +							(u64)LIRC_VALUE_MASK);
> > +
> > +			gap_sample = LIRC_SPACE(lirc->gap_duration);
> > +			lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
> > +						(unsigned char *) &gap_sample);
> > +			lirc->gap = false;
> > +		}
> > +
> > +		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
> > +					LIRC_SPACE(ev.duration / 1000);
> > +	}
> >  
> >  	lirc_buffer_write(ir_dev->raw->lirc.drv->rbuf,
> >  			  (unsigned char *) &sample);
> >  	wake_up(&ir_dev->raw->lirc.drv->rbuf->wait_poll);
> >  
> > -
> >  	return 0;
> >  }
> >  
> > @@ -103,6 +140,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
> >  	int ret = 0;
> >  	void *drv_data;
> >  	unsigned long val = 0;
> > +	u32 tmp;
> >  
> >  	lirc = lirc_get_pdata(filep);
> >  	if (!lirc)
> > @@ -201,12 +239,26 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
> >  		break;
> >  
> >  	case LIRC_SET_REC_TIMEOUT:
> > -		if (val < ir_dev->props->min_timeout ||
> > -		    val > ir_dev->props->max_timeout)
> > -			return -EINVAL;
> > -		ir_dev->props->timeout = val * 1000;
> > +		tmp = val * 1000;
> > +
> > +		if (tmp < ir_dev->props->min_timeout ||
> > +			tmp > ir_dev->props->max_timeout)
> > +				return -EINVAL;
> > +
> > +		ir_dev->props->timeout = tmp;
> > +		break;
> > +
> > +	case LIRC_SET_REC_TIMEOUT_REPORTS:
> > +		lirc->send_timeout_reports = !!val;
> >  		break;
> >  
> > +	case LIRC_SET_MEASURE_CARRIER_MODE:
> > +
> > +		if (!ir_dev->props->s_carrier_report)
> > +			return -ENOSYS;
> > +		return ir_dev->props->s_carrier_report(
> > +			ir_dev->props->priv, !!val);
> > +
> >  	default:
> >  		return lirc_dev_fop_ioctl(filep, cmd, arg);
> >  	}
> > @@ -277,6 +329,10 @@ static int ir_lirc_register(struct input_dev *input_dev)
> >  	if (ir_dev->props->s_learning_mode)
> >  		features |= LIRC_CAN_USE_WIDEBAND_RECEIVER;
> >  
> > +	if (ir_dev->props->s_carrier_report)
> > +		features |= LIRC_CAN_MEASURE_CARRIER;
> > +
> > +
> >  	if (ir_dev->props->max_timeout)
> >  		features |= LIRC_CAN_SET_REC_TIMEOUT;
> >  
> > diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
> > index d597421..70993f7 100644
> > --- a/drivers/media/IR/ir-nec-decoder.c
> > +++ b/drivers/media/IR/ir-nec-decoder.c
> > @@ -54,8 +54,9 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
> >  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_NEC))
> >  		return 0;
> >  
> > -	if (IS_RESET(ev)) {
> > -		data->state = STATE_INACTIVE;
> > +	if (!is_timing_event(ev)) {
> > +		if (ev.reset)
> > +			data->state = STATE_INACTIVE;
> >  		return 0;
> >  	}
> >  
> > diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
> > index 56797be..d10b8e0 100644
> > --- a/drivers/media/IR/ir-raw-event.c
> > +++ b/drivers/media/IR/ir-raw-event.c
> > @@ -174,7 +174,7 @@ int ir_raw_event_store_with_filter(struct input_dev *input_dev,
> >  	if (ir->idle && !ev->pulse)
> >  		return 0;
> >  	else if (ir->idle)
> > -		ir_raw_event_set_idle(input_dev, 0);
> > +		ir_raw_event_set_idle(input_dev, false);
> >  
> >  	if (!raw->this_ev.duration) {
> >  		raw->this_ev = *ev;
> > @@ -187,48 +187,35 @@ int ir_raw_event_store_with_filter(struct input_dev *input_dev,
> >  
> >  	/* Enter idle mode if nessesary */
> >  	if (!ev->pulse && ir->props->timeout &&
> > -		raw->this_ev.duration >= ir->props->timeout)
> > -		ir_raw_event_set_idle(input_dev, 1);
> > +		raw->this_ev.duration >= ir->props->timeout) {
> > +		ir_raw_event_set_idle(input_dev, true);
> > +	}
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(ir_raw_event_store_with_filter);
> >  
> > -void ir_raw_event_set_idle(struct input_dev *input_dev, int idle)
> > +/**
> > + * ir_raw_event_set_idle() - hint the ir core if device is receiving
> > + * IR data or not
> > + * @input_dev: the struct input_dev device descriptor
> > + * @idle: the hint value
> > + */
> > +void ir_raw_event_set_idle(struct input_dev *input_dev, bool idle)
> >  {
> >  	struct ir_input_dev *ir = input_get_drvdata(input_dev);
> >  	struct ir_raw_event_ctrl *raw = ir->raw;
> > -	ktime_t now;
> > -	u64 delta;
> >  
> > -	if (!ir->props)
> > +	if (!ir->props || !ir->raw)
> >  		return;
> >  
> > -	if (!ir->raw)
> > -		goto out;
> > +	IR_dprintk(2, "%s idle mode\n", idle ? "enter" : "leave");
> >  
> >  	if (idle) {
> > -		IR_dprintk(2, "enter idle mode\n");
> > -		raw->last_event = ktime_get();
> > -	} else {
> > -		IR_dprintk(2, "exit idle mode\n");
> > -
> > -		now = ktime_get();
> > -		delta = ktime_to_ns(ktime_sub(now, ir->raw->last_event));
> > -
> > -		WARN_ON(raw->this_ev.pulse);
> > -
> > -		raw->this_ev.duration =
> > -			min(raw->this_ev.duration + delta,
> > -						(u64)IR_MAX_DURATION);
> > -
> > +		raw->this_ev.timeout = true;
> >  		ir_raw_event_store(input_dev, &raw->this_ev);
> > -
> > -		if (raw->this_ev.duration == IR_MAX_DURATION)
> > -			ir_raw_event_reset(input_dev);
> > -
> > -		raw->this_ev.duration = 0;
> > +		init_ir_raw_event(&raw->this_ev);
> >  	}
> > -out:
> > +
> >  	if (ir->props->s_idle)
> >  		ir->props->s_idle(ir->props->priv, idle);
> >  	ir->idle = idle;
> > diff --git a/drivers/media/IR/ir-rc5-decoder.c b/drivers/media/IR/ir-rc5-decoder.c
> > index df4770d..572ed4c 100644
> > --- a/drivers/media/IR/ir-rc5-decoder.c
> > +++ b/drivers/media/IR/ir-rc5-decoder.c
> > @@ -55,8 +55,9 @@ static int ir_rc5_decode(struct input_dev *input_dev, struct ir_raw_event ev)
> >          if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC5))
> >                  return 0;
> >  
> > -	if (IS_RESET(ev)) {
> > -		data->state = STATE_INACTIVE;
> > +	if (!is_timing_event(ev)) {
> > +		if (ev.reset)
> > +			data->state = STATE_INACTIVE;
> >  		return 0;
> >  	}
> >  
> > diff --git a/drivers/media/IR/ir-rc6-decoder.c b/drivers/media/IR/ir-rc6-decoder.c
> > index f1624b8..d25da91 100644
> > --- a/drivers/media/IR/ir-rc6-decoder.c
> > +++ b/drivers/media/IR/ir-rc6-decoder.c
> > @@ -85,8 +85,9 @@ static int ir_rc6_decode(struct input_dev *input_dev, struct ir_raw_event ev)
> >  	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC6))
> >  		return 0;
> >  
> > -	if (IS_RESET(ev)) {
> > -		data->state = STATE_INACTIVE;
> > +	if (!is_timing_event(ev)) {
> > +		if (ev.reset)
> 
> Again, why do you need to test first for !is_timing_event()?

Because the decoder should return early if the event is not a timing 
event (the return 0 two lines below)...think carrier report event...
> 
> > +			data->state = STATE_INACTIVE;
> >  		return 0;
> >  	}
> >  
