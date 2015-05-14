Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35700 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbbENQrq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 12:47:46 -0400
Date: Thu, 14 May 2015 13:47:41 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: [RFC PATCH 3/6] [media] rc: lirc bridge should not be a raw
 decoder
Message-ID: <20150514134741.1bf117ef@recife.lan>
In-Reply-To: <3283ce9a61698b5ba9c3f2dbb531982742b4fd83.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
	<3283ce9a61698b5ba9c3f2dbb531982742b4fd83.1426801061.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Mar 2015 21:50:14 +0000
Sean Young <sean@mess.org> escreveu:

> The lirc bridge exists as a raw decoder. We would like to make the bridge
> to also work for scancode drivers in further commits, so it cannot be
> a raw decoder.
> 
> Note that rc-code, lirc_dev, ir-lirc-codec are now calling functions of
> each other, so they've been merged into one module rc-core to avoid
> circular dependencies.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/Kconfig         |  15 +++--
>  drivers/media/rc/Makefile        |   6 +-
>  drivers/media/rc/ir-lirc-codec.c | 117 ++++++++++++---------------------------
>  drivers/media/rc/lirc_dev.c      |  18 +-----
>  drivers/media/rc/rc-core-priv.h  |  38 ++++++-------
>  drivers/media/rc/rc-ir-raw.c     |   4 +-
>  drivers/media/rc/rc-main.c       |  21 +++++--
>  include/media/rc-core.h          |   7 +++
>  8 files changed, 92 insertions(+), 134 deletions(-)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index ddfab25..efdd6f7 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -6,14 +6,8 @@ config RC_CORE
>  
>  source "drivers/media/rc/keymaps/Kconfig"
>  
> -menuconfig RC_DECODERS
> -        bool "Remote controller decoders"
> -	depends on RC_CORE
> -	default y
> -
> -if RC_DECODERS
>  config LIRC
> -	tristate "LIRC interface driver"
> +	bool "LIRC interface driver"
>  	depends on RC_CORE
>  
>  	---help---
> @@ -24,7 +18,7 @@ config LIRC
>  	   encoding for IR transmitting (aka "blasting").
>  
>  config IR_LIRC_CODEC
> -	tristate "Enable IR to LIRC bridge"
> +	bool "Enable IR to LIRC bridge"
>  	depends on RC_CORE
>  	depends on LIRC
>  	default y
> @@ -33,7 +27,12 @@ config IR_LIRC_CODEC
>  	   Enable this option to pass raw IR to and from userspace via
>  	   the LIRC interface.
>  
> +menuconfig RC_DECODERS
> +	bool "Remote controller decoders"
> +	depends on RC_CORE
> +	default y
>  
> +if RC_DECODERS
>  config IR_NEC_DECODER
>  	tristate "Enable IR raw decoder for the NEC protocol"
>  	depends on RC_CORE
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 379a5c0..c8e7b38 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -1,9 +1,10 @@
> -rc-core-objs	:= rc-main.o rc-ir-raw.o
>  
>  obj-y += keymaps/
>  
>  obj-$(CONFIG_RC_CORE) += rc-core.o
> -obj-$(CONFIG_LIRC) += lirc_dev.o
> +rc-core-y := rc-main.o rc-ir-raw.o
> +rc-core-$(CONFIG_LIRC) += lirc_dev.o
> +rc-core-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o

It seems OK to me to not consider LIRC as a decoder, but I wouldn't add
it inside RC core. The best seems to convert lirc dev to be a 
separate module.

Thanks!
Mauro


>  obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
>  obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
>  obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
> @@ -12,7 +13,6 @@ obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
>  obj-$(CONFIG_IR_SANYO_DECODER) += ir-sanyo-decoder.o
>  obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
>  obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
> -obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
>  obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
>  
>  # stand-alone IR receivers/transmitters
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 17fd956..475f6af 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -14,7 +14,6 @@
>  
>  #include <linux/sched.h>
>  #include <linux/wait.h>
> -#include <linux/module.h>
>  #include <media/lirc.h>
>  #include <media/lirc_dev.h>
>  #include <media/rc-core.h>
> @@ -30,15 +29,12 @@
>   *
>   * This function returns -EINVAL if the lirc interfaces aren't wired up.
>   */
> -static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  {
> -	struct lirc_codec *lirc = &dev->raw->lirc;
> +	struct lirc_driver *lirc = dev->lirc;
>  	int sample;
>  
> -	if (!(dev->enabled_protocols & RC_BIT_LIRC))
> -		return 0;
> -
> -	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
> +	if (!lirc || !lirc->rbuf)
>  		return -EINVAL;
>  
>  	/* Packet start */
> @@ -59,14 +55,14 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	/* Packet end */
>  	} else if (ev.timeout) {
>  
> -		if (lirc->gap)
> +		if (dev->gap)
>  			return 0;
>  
> -		lirc->gap_start = ktime_get();
> -		lirc->gap = true;
> -		lirc->gap_duration = ev.duration;
> +		dev->gap_start = ktime_get();
> +		dev->gap = true;
> +		dev->gap_duration = ev.duration;
>  
> -		if (!lirc->send_timeout_reports)
> +		if (!dev->send_timeout_reports)
>  			return 0;
>  
>  		sample = LIRC_TIMEOUT(ev.duration / 1000);
> @@ -75,21 +71,21 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  	/* Normal sample */
>  	} else {
>  
> -		if (lirc->gap) {
> +		if (dev->gap) {
>  			int gap_sample;
>  
> -			lirc->gap_duration += ktime_to_ns(ktime_sub(ktime_get(),
> -				lirc->gap_start));
> +			dev->gap_duration += ktime_to_ns(
> +				ktime_sub(ktime_get(), dev->gap_start));
>  
>  			/* Convert to ms and cap by LIRC_VALUE_MASK */
> -			do_div(lirc->gap_duration, 1000);
> -			lirc->gap_duration = min(lirc->gap_duration,
> -							(u64)LIRC_VALUE_MASK);
> +			do_div(dev->gap_duration, 1000);
> +			dev->gap_duration = min_t(u64, dev->gap_duration,
> +							LIRC_VALUE_MASK);
>  
> -			gap_sample = LIRC_SPACE(lirc->gap_duration);
> -			lirc_buffer_write(dev->raw->lirc.drv->rbuf,
> +			gap_sample = LIRC_SPACE(dev->gap_duration);
> +			lirc_buffer_write(lirc->rbuf,
>  						(unsigned char *) &gap_sample);
> -			lirc->gap = false;
> +			dev->gap = false;
>  		}
>  
>  		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
> @@ -98,9 +94,9 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  			   TO_US(ev.duration), TO_STR(ev.pulse));
>  	}
>  
> -	lirc_buffer_write(dev->raw->lirc.drv->rbuf,
> +	lirc_buffer_write(lirc->rbuf,
>  			  (unsigned char *) &sample);
> -	wake_up(&dev->raw->lirc.drv->rbuf->wait_poll);
> +	wake_up(&lirc->rbuf->wait_poll);
>  
>  	return 0;
>  }
> @@ -108,7 +104,6 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
>  static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  				   size_t n, loff_t *ppos)
>  {
> -	struct lirc_codec *lirc;
>  	struct rc_dev *dev;
>  	unsigned int *txbuf; /* buffer with values to transmit */
>  	ssize_t ret = -EINVAL;
> @@ -120,8 +115,8 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  
>  	start = ktime_get();
>  
> -	lirc = lirc_get_pdata(file);
> -	if (!lirc)
> +	dev = lirc_get_pdata(file);
> +	if (!dev || !dev->lirc)
>  		return -EFAULT;
>  
>  	if (n < sizeof(unsigned) || n % sizeof(unsigned))
> @@ -135,12 +130,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
>  	if (IS_ERR(txbuf))
>  		return PTR_ERR(txbuf);
>  
> -	dev = lirc->dev;
> -	if (!dev) {
> -		ret = -EFAULT;
> -		goto out;
> -	}
> -
>  	if (!dev->tx_ir) {
>  		ret = -ENOSYS;
>  		goto out;
> @@ -183,18 +172,13 @@ out:
>  static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  			unsigned long arg)
>  {
> -	struct lirc_codec *lirc;
>  	struct rc_dev *dev;
>  	u32 __user *argp = (u32 __user *)(arg);
>  	int ret = 0;
>  	__u32 val = 0, tmp;
>  
> -	lirc = lirc_get_pdata(filep);
> -	if (!lirc)
> -		return -EFAULT;
> -
> -	dev = lirc->dev;
> -	if (!dev)
> +	dev  = lirc_get_pdata(filep);
> +	if (!dev || !dev->lirc)
>  		return -EFAULT;
>  
>  	if (_IOC_DIR(cmd) & _IOC_WRITE) {
> @@ -253,14 +237,14 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  			return -EINVAL;
>  
>  		return dev->s_rx_carrier_range(dev,
> -					       dev->raw->lirc.carrier_low,
> +					       dev->carrier_low,
>  					       val);
>  
>  	case LIRC_SET_REC_CARRIER_RANGE:
>  		if (val <= 0)
>  			return -EINVAL;
>  
> -		dev->raw->lirc.carrier_low = val;
> +		dev->carrier_low = val;
>  		return 0;
>  
>  	case LIRC_GET_REC_RESOLUTION:
> @@ -306,7 +290,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  		break;
>  
>  	case LIRC_SET_REC_TIMEOUT_REPORTS:
> -		lirc->send_timeout_reports = !!val;
> +		dev->send_timeout_reports = !!val;
>  		break;
>  
>  	default:
> @@ -343,7 +327,7 @@ static const struct file_operations lirc_fops = {
>  	.llseek		= no_llseek,
>  };
>  
> -static int ir_lirc_register(struct rc_dev *dev)
> +int ir_lirc_register(struct rc_dev *dev)
>  {
>  	struct lirc_driver *drv;
>  	struct lirc_buffer *rbuf;
> @@ -390,7 +374,7 @@ static int ir_lirc_register(struct rc_dev *dev)
>  		 dev->driver_name);
>  	drv->minor = -1;
>  	drv->features = features;
> -	drv->data = &dev->raw->lirc;
> +	drv->data = dev;
>  	drv->rbuf = rbuf;
>  	drv->set_use_inc = &ir_lirc_open;
>  	drv->set_use_dec = &ir_lirc_close;
> @@ -406,8 +390,7 @@ static int ir_lirc_register(struct rc_dev *dev)
>  		goto lirc_register_failed;
>  	}
>  
> -	dev->raw->lirc.drv = drv;
> -	dev->raw->lirc.dev = dev;
> +	dev->lirc = drv;
>  	return 0;
>  
>  lirc_register_failed:
> @@ -419,41 +402,11 @@ rbuf_alloc_failed:
>  	return rc;
>  }
>  
> -static int ir_lirc_unregister(struct rc_dev *dev)
> +void ir_lirc_unregister(struct rc_dev *dev)
>  {
> -	struct lirc_codec *lirc = &dev->raw->lirc;
> -
> -	lirc_unregister_driver(lirc->drv->minor);
> -	lirc_buffer_free(lirc->drv->rbuf);
> -	kfree(lirc->drv);
> -
> -	return 0;
> -}
> -
> -static struct ir_raw_handler lirc_handler = {
> -	.protocols	= RC_BIT_LIRC,
> -	.decode		= ir_lirc_decode,
> -	.raw_register	= ir_lirc_register,
> -	.raw_unregister	= ir_lirc_unregister,
> -};
> -
> -static int __init ir_lirc_codec_init(void)
> -{
> -	ir_raw_handler_register(&lirc_handler);
> -
> -	printk(KERN_INFO "IR LIRC bridge handler initialized\n");
> -	return 0;
> -}
> -
> -static void __exit ir_lirc_codec_exit(void)
> -{
> -	ir_raw_handler_unregister(&lirc_handler);
> +	if (dev->lirc) {
> +		lirc_unregister_driver(dev->lirc->minor);
> +		lirc_buffer_free(dev->lirc->rbuf);
> +		kfree(dev->lirc);
> +	}
>  }
> -
> -module_init(ir_lirc_codec_init);
> -module_exit(ir_lirc_codec_exit);
> -
> -MODULE_LICENSE("GPL");
> -MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
> -MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
> -MODULE_DESCRIPTION("LIRC IR handler bridge");
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index 4de0e85..44a61e81 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -39,8 +39,6 @@
>  #include <media/lirc.h>
>  #include <media/lirc_dev.h>
>  
> -static bool debug;
> -
>  #define IRCTL_DEV_NAME	"BaseRemoteCtl"
>  #define NOPLUG		-1
>  #define LOGHEAD		"lirc_dev (%s[%d]): "
> @@ -785,8 +783,7 @@ ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
>  }
>  EXPORT_SYMBOL(lirc_dev_fop_write);
>  
> -
> -static int __init lirc_dev_init(void)
> +int __init lirc_dev_init(void)
>  {
>  	int retval;
>  
> @@ -813,21 +810,10 @@ error:
>  	return retval;
>  }
>  
> -
> -
> -static void __exit lirc_dev_exit(void)
> +void __exit lirc_dev_exit(void)
>  {
>  	class_destroy(lirc_class);
>  	unregister_chrdev_region(lirc_base_dev, MAX_IRCTL_DEVICES);
>  	printk(KERN_INFO "lirc_dev: module unloaded\n");
>  }
>  
> -module_init(lirc_dev_init);
> -module_exit(lirc_dev_exit);
> -
> -MODULE_DESCRIPTION("LIRC base driver module");
> -MODULE_AUTHOR("Artur Lipowski");
> -MODULE_LICENSE("GPL");
> -
> -module_param(debug, bool, S_IRUGO | S_IWUSR);
> -MODULE_PARM_DESC(debug, "Enable debugging messages");
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index b68d4f76..732479d 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -26,7 +26,7 @@ struct ir_raw_handler {
>  	u64 protocols; /* which are handled by this handler */
>  	int (*decode)(struct rc_dev *dev, struct ir_raw_event event);
>  
> -	/* These two should only be used by the lirc decoder */
> +	/* These two should only be used by the mce kbd decoder */
>  	int (*raw_register)(struct rc_dev *dev);
>  	int (*raw_unregister)(struct rc_dev *dev);
>  };
> @@ -99,17 +99,6 @@ struct ir_raw_event_ctrl {
>  		unsigned count;
>  		unsigned wanted_bits;
>  	} mce_kbd;
> -	struct lirc_codec {
> -		struct rc_dev *dev;
> -		struct lirc_driver *drv;
> -		int carrier_low;
> -
> -		ktime_t gap_start;
> -		u64 gap_duration;
> -		bool gap;
> -		bool send_timeout_reports;
> -
> -	} lirc;
>  	struct xmp_dec {
>  		int state;
>  		unsigned count;
> @@ -223,13 +212,6 @@ static inline void load_sharp_decode(void) { }
>  static inline void load_mce_kbd_decode(void) { }
>  #endif
>  
> -/* from ir-lirc-codec.c */
> -#ifdef CONFIG_IR_LIRC_CODEC_MODULE
> -#define load_lirc_codec()	request_module_nowait("ir-lirc-codec")
> -#else
> -static inline void load_lirc_codec(void) { }
> -#endif
> -
>  /* from ir-xmp-decoder.c */
>  #ifdef CONFIG_IR_XMP_DECODER_MODULE
>  #define load_xmp_decode()      request_module_nowait("ir-xmp-decoder")
> @@ -237,5 +219,23 @@ static inline void load_lirc_codec(void) { }
>  static inline void load_xmp_decode(void) { }
>  #endif
>  
> +#ifdef CONFIG_IR_LIRC_CODEC
> +void ir_lirc_unregister(struct rc_dev *dev);
> +int ir_lirc_register(struct rc_dev *dev);
> +int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev);
> +#else
> +static inline void ir_lirc_unregister(struct rc_dev *dev) {}
> +static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
> +static inline int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
> +								{ return 0; }
> +#endif
> +
> +#ifdef CONFIG_LIRC
> +int __init lirc_dev_init(void);
> +void __exit lirc_dev_exit(void);
> +#else
> +int __init lirc_dev_init(void) { return 0; }
> +void __exit lirc_dev_exit(void) {}
> +#endif
>  
>  #endif /* _RC_CORE_PRIV */
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index b732ac6..d298be7 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -57,6 +57,9 @@ static int ir_raw_event_thread(void *data)
>  		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
>  		spin_unlock_irq(&raw->lock);
>  
> +		if (raw->dev->lirc)
> +			ir_lirc_decode(raw->dev, ev);
> +
>  		mutex_lock(&ir_raw_handler_lock);
>  		list_for_each_entry(handler, &ir_raw_handler_list, list)
>  			handler->decode(raw->dev, ev);
> @@ -360,7 +363,6 @@ void ir_raw_init(void)
>  	load_sanyo_decode();
>  	load_sharp_decode();
>  	load_mce_kbd_decode();
> -	load_lirc_codec();
>  	load_xmp_decode();
>  
>  	/* If needed, we may later add some init code. In this case,
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index f8c5e47..128909c 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -732,7 +732,6 @@ int rc_open(struct rc_dev *rdev)
>  
>  	return rval;
>  }
> -EXPORT_SYMBOL_GPL(rc_open);
>  
>  static int ir_open(struct input_dev *idev)
>  {
> @@ -752,7 +751,6 @@ void rc_close(struct rc_dev *rdev)
>  		mutex_unlock(&rdev->lock);
>  	}
>  }
> -EXPORT_SYMBOL_GPL(rc_close);
>  
>  static void ir_close(struct input_dev *idev)
>  {
> @@ -1419,15 +1417,17 @@ int rc_register_device(struct rc_dev *dev)
>  		mutex_lock(&dev->lock);
>  		if (rc < 0)
>  			goto out_input;
> +
> +		rc = ir_lirc_register(dev);
> +		if (rc < 0)
> +			goto out_raw;
>  	}
>  
>  	if (dev->change_protocol) {
>  		u64 rc_type = (1ll << rc_map->rc_type);
> -		if (dev->driver_type == RC_DRIVER_IR_RAW)
> -			rc_type |= RC_BIT_LIRC;
>  		rc = dev->change_protocol(dev, &rc_type);
>  		if (rc < 0)
> -			goto out_raw;
> +			goto out_lirc;
>  		dev->enabled_protocols = rc_type;
>  	}
>  
> @@ -1441,6 +1441,8 @@ int rc_register_device(struct rc_dev *dev)
>  
>  	return 0;
>  
> +out_lirc:
> +	ir_lirc_unregister(dev);
>  out_raw:
>  	if (dev->driver_type == RC_DRIVER_IR_RAW)
>  		ir_raw_event_unregister(dev);
> @@ -1470,6 +1472,8 @@ void rc_unregister_device(struct rc_dev *dev)
>  	if (dev->driver_type == RC_DRIVER_IR_RAW)
>  		ir_raw_event_unregister(dev);
>  
> +	ir_lirc_unregister(dev);
> +
>  	/* Freeing the table should also call the stop callback */
>  	ir_free_table(&dev->rc_map);
>  	IR_dprintk(1, "Freed keycode table\n");
> @@ -1495,6 +1499,12 @@ static int __init rc_core_init(void)
>  		printk(KERN_ERR "rc_core: unable to register rc class\n");
>  		return rc;
>  	}
> +	rc = lirc_dev_init();
> +	if (rc) {
> +		class_unregister(&rc_class);
> +		printk(KERN_ERR "rc_core: unable to register lirc class\n");
> +		return rc;
> +	}
>  
>  	led_trigger_register_simple("rc-feedback", &led_feedback);
>  	rc_map_register(&empty_map);
> @@ -1507,6 +1517,7 @@ static void __exit rc_core_exit(void)
>  	class_unregister(&rc_class);
>  	led_trigger_unregister_simple(led_feedback);
>  	rc_map_unregister(&empty_map);
> +	lirc_dev_exit();
>  }
>  
>  subsys_initcall(rc_core_init);
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 2c7fbca..e3f217c 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -156,6 +156,13 @@ struct rc_dev {
>  	u32				max_timeout;
>  	u32				rx_resolution;
>  	u32				tx_resolution;
> +	/* lirc state */
> +	struct lirc_driver		*lirc;
> +	int				carrier_low;
> +	ktime_t				gap_start;
> +	u64				gap_duration;
> +	bool				gap;
> +	bool				send_timeout_reports;
>  	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*change_wakeup_protocol)(struct rc_dev *dev, u64 *rc_type);
>  	int				(*open)(struct rc_dev *dev);
