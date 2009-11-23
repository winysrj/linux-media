Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489AbZKWLrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 06:47:48 -0500
Message-ID: <4B0A765F.7010204@redhat.com>
Date: Mon, 23 Nov 2009 09:47:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com>
In-Reply-To: <200910200958.50574.jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jarod,

Jarod Wilson wrote:
> Core Linux Infrared Remote Control driver and infrastructure
> 
> -Add Kconfig and Makefile bits
> -Add device driver interface and headers
> 
> The initial Kconfig and Makefile bits were done by Mario Limonciello for
> the Ubuntu kernel, but have been tweaked a bit since then. Any errors are
> probably my doing.
> 
> Changes from prior submission:
> - Now uses dev_dbg instead of its own dprintk
> - Dynamic device numbers used
> - sleep_on() ripped out in favor of wake bits
> - Kconfig text improved and simplified
> - All inline keywords removed where possible
> - Obfuscating #defines and wrapper functions removed
> - We call 'em lirc drivers now instead of lirc plugins

Sorry to not analyze the code before. -ETOOBUSY here...

Some generic comments first:

1) As I said before, this code adds a new input API. So, you should
get input people's ack about it. It seems fine for me;

2) It would be really cool if you could submit a patch for DocBook as
well, in order to describe the API. IMO, the better is to put it together
with media infrastructure docbook, since, although it is possible to use
lirc code with other hardware (and were originally designed for it), the
current wider usage is together with V4L/DVB devices. The Docbooks are
at kernel Documentation/DocBook/ directory. Also, we have a copy of it
at our development tree (http://linuxtv.org/hg/v4l-dvb) at media-specs/
directory.

3) In general, the code looks sane for me. I have just a few small sugestions
for improvements:

> Index: b/drivers/input/lirc/lirc.h
> ===================================================================
> --- /dev/null
> +++ b/drivers/input/lirc/lirc.h

Hmm... as you're defining the kernel userspace interface, it would
be better to put the header under include/linux.

> +#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, unsigned long)
> +
> +#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, unsigned long)
> +#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, unsigned long)
> +#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, unsigned int)
> +#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, unsigned int)
> +#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, unsigned int)
> +#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, unsigned int)
> +#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, unsigned int)
> +
> +/* code length in bits, currently only for LIRC_MODE_LIRCCODE */
> +#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, unsigned long)
> +
> +#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, unsigned long)
> +#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, unsigned long)
> +/* Note: these can reset the according pulse_width */
> +#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, unsigned int)
> +#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, unsigned int)
> +#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, unsigned int)
> +#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, unsigned int)
> +#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, unsigned int)
> +

Hmm... unsigned int/unsigned long are not portable between different architectures.
It would be better to use instead __u16/__u32/__u64. This way, you won't need
a 32 bits compat layer.

> +
> +int lirc_register_driver(struct lirc_driver *d)
> +{
> +	struct irctl *ir;
> +	int minor;
> +	int bytes_in_key;
> +	unsigned int chunk_size;
> +	unsigned int buffer_size;
> +	int err;
> +
> +	if (!d) {
> +		printk(KERN_ERR "lirc_dev: lirc_register_driver: "
> +		       "driver pointer must be not NULL!\n");
> +		err = -EBADRQC;
> +		goto out;
> +	}
> +
> +	if (MAX_IRCTL_DEVICES <= d->minor) {
> +		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
> +			"\"minor\" must be between 0 and %d (%d)!\n",
> +			MAX_IRCTL_DEVICES-1, d->minor);
> +		err = -EBADRQC;
> +		goto out;
> +	}
> +
> +	if (1 > d->code_length || (BUFLEN * 8) < d->code_length) {
> +		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
> +			"code length in bits for minor (%d) "
> +			"must be less than %d!\n",
> +			d->minor, BUFLEN * 8);
> +		err = -EBADRQC;
> +		goto out;
> +	}
> +
> +	dev_dbg(d->dev, "lirc_dev: lirc_register_driver: sample_rate: %d\n",
> +		d->sample_rate);
> +	if (d->sample_rate) {
> +		if (2 > d->sample_rate || HZ < d->sample_rate) {
> +			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
> +				"sample_rate must be between 2 and %d!\n", HZ);
> +			err = -EBADRQC;
> +			goto out;
> +		}
> +		if (!d->add_to_buf) {
> +			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
> +				"add_to_buf cannot be NULL when "
> +				"sample_rate is set\n");
> +			err = -EBADRQC;
> +			goto out;
> +		}
> +	} else if (!(d->fops && d->fops->read) && !d->rbuf) {
> +		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
> +			"fops->read and rbuf cannot all be NULL!\n");
> +		err = -EBADRQC;
> +		goto out;
> +	} else if (!d->rbuf) {
> +		if (!(d->fops && d->fops->read && d->fops->poll &&
> +		      d->fops->ioctl)) {
> +			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
> +				"neither read, poll nor ioctl can be NULL!\n");
> +			err = -EBADRQC;
> +			goto out;
> +		}
> +	}
> +
> +	mutex_lock(&lirc_dev_lock);
> +
> +	minor = d->minor;
> +
> +	if (minor < 0) {
> +		/* find first free slot for driver */
> +		for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
> +			if (!irctls[minor])
> +				break;
> +		if (MAX_IRCTL_DEVICES == minor) {
> +			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
> +				"no free slots for drivers!\n");
> +			err = -ENOMEM;
> +			goto out_lock;
> +		}
> +	} else if (irctls[minor]) {
> +		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
> +			"minor (%d) just registered!\n", minor);
> +		err = -EBUSY;
> +		goto out_lock;
> +	}
> +
> +	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
> +	if (!ir) {
> +		err = -ENOMEM;
> +		goto out_lock;
> +	}
> +	init_irctl(ir);
> +	irctls[minor] = ir;
> +	d->minor = minor;
> +
> +	if (d->sample_rate) {
> +		ir->jiffies_to_wait = HZ / d->sample_rate;
> +	} else {
> +		/* it means - wait for external event in task queue */
> +		ir->jiffies_to_wait = 0;
> +	}
> +
> +	/* some safety check 8-) */
> +	d->name[sizeof(d->name)-1] = '\0';
> +
> +	bytes_in_key = BITS_TO_LONGS(d->code_length) +
> +			(d->code_length % 8 ? 1 : 0);
> +	buffer_size = d->buffer_size ? d->buffer_size : BUFLEN / bytes_in_key;
> +	chunk_size  = d->chunk_size  ? d->chunk_size  : bytes_in_key;
> +
> +	if (d->rbuf) {
> +		ir->buf = d->rbuf;
> +	} else {
> +		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);

For security reasons, wouldn't be better to use kzalloc here?

> +#ifdef CONFIG_COMPAT
> +#define LIRC_GET_FEATURES_COMPAT32     _IOR('i', 0x00000000, __u32)
> +
> +#define LIRC_GET_SEND_MODE_COMPAT32    _IOR('i', 0x00000001, __u32)
> +#define LIRC_GET_REC_MODE_COMPAT32     _IOR('i', 0x00000002, __u32)
> +
> +#define LIRC_GET_LENGTH_COMPAT32       _IOR('i', 0x0000000f, __u32)
> +
> +#define LIRC_SET_SEND_MODE_COMPAT32    _IOW('i', 0x00000011, __u32)
> +#define LIRC_SET_REC_MODE_COMPAT32     _IOW('i', 0x00000012, __u32)

You wouldn't need those code, if you declare the ioctl's as __u32 at the
first place.

Also, the compat layer is needed not only for x86_64, but some other architectures
like sparc64 needs it, since userspace is 32 bits and kernelspace is 64 bits.

With V4L ioctls, we needed to do some adjustments for sparc, since the sizes there
are different for other types as well. Unfortunately, I can't remember what were
the difference (maybe int size?).

So, IMO, it would be a way better if you just declare everything using __u16/__u32/__u64
at the original ioctl definition and just remove all compat code.

> +EXPORT_SYMBOL(lirc_register_driver);
> +EXPORT_SYMBOL(lirc_unregister_driver);
> +EXPORT_SYMBOL(lirc_dev_fop_close);
> +EXPORT_SYMBOL(lirc_dev_fop_poll);
> +EXPORT_SYMBOL(lirc_dev_fop_ioctl);
> +EXPORT_SYMBOL(lirc_dev_fop_compat_ioctl);
> +EXPORT_SYMBOL(lirc_dev_fop_read);
> +EXPORT_SYMBOL(lirc_get_pdata);
> +EXPORT_SYMBOL(lirc_dev_fop_write);

I would declare everything as EXPORT_SYMBOL_GPL instead.
