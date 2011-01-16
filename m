Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1APS1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 13:27:34 -0500
Message-ID: <4D333877.6040900@redhat.com>
Date: Sun, 16 Jan 2011 16:27:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Jarod Wilson <jarod@wilsonet.com>,
	Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC PATCH] ir-kbd-i2c, lirc_zilog: Allow bridge drivers to pass
 an IR trasnceiver mutex to I2C IR modules
References: <1295149788.7147.34.camel@localhost>
In-Reply-To: <1295149788.7147.34.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jarod/Andy,

For now, I'm marking all those ir-kbd-i2c/lirc_zilog patches as "RFC" at patchwork,
as I'm not sure if they're ok, and because there are a few revisions of them and
I'm afraid to apply some wrong version.

Please, after finishing and testing, send me a patch series or, preferably, a
git pull with those stuff.

Thanks!
Mauro

Em 16-01-2011 01:49, Andy Walls escreveu:
> The following patch allows bridge drivers, with an I2C IR Tx/Rx
> transceiver, to pass a mutex for serializing access to a single I2C IR
> chip between separate IR Tx and Rx modules.
> 
> The change modifies struct IR_i2c_init_data and struct IR_i2c to add
> 
> 	struct mutex *transceiver_lock
> 
> that ir-kbd-i2c and lirc_zilog will use, if provided by the bridge
> driver.  The changes to ir-kbd-i2c.[ch] and lirc_zilog.c provide the
> functional change in the patch.
> 
> This patch also modifies cx18, ivtv, and hdpvr (sans Jarrod's recent
> patches) to provide a transceiver_lock mutex to ir-kbd-i2c and
> lirc_zilog.
> 
> I skimmed all the other modules that use IR_i2c_init_data. They all
> appear to zero-fill the init_data properly before handing the data over
> to ir-kbd-i2c.c.  
> 
> I did find that pvrusb2 IR Rx for address 0x71 was broken, due to my
> recommendation to remove automatic config for address 0x71 from
> ir-kbd-i2c.c.  I'll fix that in another patch, if someone with a pvrusb2
> device doesn't beat me to it.
> 
> So without further ado...
> 
> 
> diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
> index 676e5be..da1ef93 100644
> --- a/drivers/media/video/cx18/cx18-driver.c
> +++ b/drivers/media/video/cx18/cx18-driver.c
> @@ -701,6 +701,7 @@ static int __devinit cx18_init_struct1(struct cx18 *cx)
>  
>  	mutex_init(&cx->serialize_lock);
>  	mutex_init(&cx->gpio_lock);
> +	mutex_init(&cx->ir_transceiver_lock);
>  	mutex_init(&cx->epu2apu_mb_lock);
>  	mutex_init(&cx->epu2cpu_mb_lock);
>  
> diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
> index f6f3e50..82dc747 100644
> --- a/drivers/media/video/cx18/cx18-driver.h
> +++ b/drivers/media/video/cx18/cx18-driver.h
> @@ -626,6 +626,7 @@ struct cx18 {
>  	struct cx18_i2c_algo_callback_data i2c_algo_cb_data[2];
>  
>  	struct IR_i2c_init_data ir_i2c_init_data;
> +	struct mutex ir_transceiver_lock;
>  
>  	/* gpio */
>  	u32 gpio_dir;
> diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
> index c330fb9..7782de1 100644
> --- a/drivers/media/video/cx18/cx18-i2c.c
> +++ b/drivers/media/video/cx18/cx18-i2c.c
> @@ -96,10 +96,12 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
>  	/* Our default information for ir-kbd-i2c.c to use */
>  	switch (hw) {
>  	case CX18_HW_Z8F0811_IR_RX_HAUP:
> +	case CX18_HW_Z8F0811_IR_TX_HAUP:
>  		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
>  		init_data->type = RC_TYPE_RC5;
>  		init_data->name = cx->card_name;
> +		init_data->transceiver_lock = &cx->ir_transceiver_lock;
>  		info.platform_data = init_data;
>  		break;
>  	}
> diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
> index f7d1ee5..df4a02a 100644
> --- a/drivers/media/video/hdpvr/hdpvr-core.c
> +++ b/drivers/media/video/hdpvr/hdpvr-core.c
> @@ -304,6 +304,7 @@ static int hdpvr_probe(struct usb_interface *interface,
>  
>  	mutex_init(&dev->io_mutex);
>  	mutex_init(&dev->i2c_mutex);
> +	mutex_init(&dev->ir_transceiver_mutex);
>  	mutex_init(&dev->usbc_mutex);
>  	dev->usbc_buf = kmalloc(64, GFP_KERNEL);
>  	if (!dev->usbc_buf) {
> diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
> index 24966aa..b1e68b8 100644
> --- a/drivers/media/video/hdpvr/hdpvr-i2c.c
> +++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
> @@ -48,13 +48,15 @@ static int hdpvr_new_i2c_ir(struct hdpvr_device *dev, struct i2c_adapter *adap,
>  	memset(&info, 0, sizeof(struct i2c_board_info));
>  	strlcpy(info.type, type, I2C_NAME_SIZE);
>  
> -	/* Our default information for ir-kbd-i2c.c to use */
> +	/* Our default information for ir-kbd-i2c.c and lirc_zilog.c to use */
>  	switch (addr) {
>  	case Z8F0811_IR_RX_I2C_ADDR:
> +	case Z8F0811_IR_TX_I2C_ADDR:
>  		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
>  		init_data->type = RC_TYPE_RC5;
>  		init_data->name = "HD PVR";
> +		init_data->transceiver_lock = &dev->ir_transceiver_mutex;
>  		info.platform_data = init_data;
>  		break;
>  	}
> diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/video/hdpvr/hdpvr.h
> index 37f1e4c..00c8563 100644
> --- a/drivers/media/video/hdpvr/hdpvr.h
> +++ b/drivers/media/video/hdpvr/hdpvr.h
> @@ -112,6 +112,7 @@ struct hdpvr_device {
>  
>  	/* For passing data to ir-kbd-i2c */
>  	struct IR_i2c_init_data	ir_i2c_init_data;
> +	struct mutex ir_transceiver_mutex;
>  
>  	/* usb control transfer buffer and lock */
>  	struct mutex		usbc_mutex;
> diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> index c87b6bc..6714e1e 100644
> --- a/drivers/media/video/ir-kbd-i2c.c
> +++ b/drivers/media/video/ir-kbd-i2c.c
> @@ -245,7 +245,15 @@ static void ir_key_poll(struct IR_i2c *ir)
>  	int rc;
>  
>  	dprintk(2,"ir_poll_key\n");
> +
> +	if (ir->transceiver_lock)
> +		mutex_lock(ir->transceiver_lock);
> +
>  	rc = ir->get_key(ir, &ir_key, &ir_raw);
> +
> +	if (ir->transceiver_lock)
> +		mutex_unlock(ir->transceiver_lock);
> +
>  	if (rc < 0) {
>  		dprintk(2,"error\n");
>  		return;
> @@ -362,6 +370,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  			ir->get_key = get_key_avermedia_cardbus;
>  			break;
>  		}
> +
> +		ir->transceiver_lock = init_data->transceiver_lock;
>  	}
>  
>  	if (!rc) {
> diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
> index 3994642..ea2afeb 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c
> @@ -713,6 +713,7 @@ static int __devinit ivtv_init_struct1(struct ivtv *itv)
>  	itv->dec_mbox.max_mbox = 1; /* the decoder has 2 mailboxes (0-1) */
>  
>  	mutex_init(&itv->serialize_lock);
> +	mutex_init(&itv->ir_transceiver_lock);
>  	mutex_init(&itv->i2c_bus_lock);
>  	mutex_init(&itv->udma.lock);
>  
> diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
> index 04bacdb..2c8d7c1 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.h
> +++ b/drivers/media/video/ivtv/ivtv-driver.h
> @@ -699,6 +699,7 @@ struct ivtv {
>  	struct mutex i2c_bus_lock;      /* lock i2c bus */
>  
>  	struct IR_i2c_init_data ir_i2c_init_data;
> +	struct mutex ir_transceiver_lock;
>  
>  	/* Program Index information */
>  	u32 pgm_info_offset;            /* start of pgm info in encoder memory */
> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
> index e103b8f..4233b48 100644
> --- a/drivers/media/video/ivtv/ivtv-i2c.c
> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
> @@ -184,7 +184,21 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>  	if (hw & IVTV_HW_IR_TX_ANY) {
>  		if (itv->hw_flags & IVTV_HW_IR_TX_ANY)
>  			return -1;
> +
> +		/* Our default information for lirc_zilog.c to use */
> +		switch (hw) {
> +		case IVTV_HW_Z8F0811_IR_TX_HAUP:
> +			/* Default to grey remote */
> +			init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
> +			init_data->internal_get_key_func =
> +							IR_KBD_GET_KEY_HAUP_XVR;
> +			init_data->type = RC_TYPE_RC5;
> +			init_data->name = itv->card_name;
> +			init_data->transceiver_lock = &itv->ir_transceiver_lock;
> +			break;
> +		}
>  		memset(&info, 0, sizeof(struct i2c_board_info));
> +		info.platform_data = init_data;
>  		strlcpy(info.type, type, I2C_NAME_SIZE);
>  		return i2c_new_probed_device(adap, &info, addr_list, NULL)
>  							   == NULL ? -1 : 0;
> @@ -217,6 +231,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
>  		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
>  		init_data->type = RC_TYPE_RC5;
>  		init_data->name = itv->card_name;
> +		init_data->transceiver_lock = &itv->ir_transceiver_lock;
>  		break;
>  	case IVTV_HW_I2C_IR_RX_ADAPTEC:
>  		init_data->get_key = get_key_adaptec;
> diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
> index 18fae54..8185581 100644
> --- a/drivers/staging/lirc/lirc_zilog.c
> +++ b/drivers/staging/lirc/lirc_zilog.c
> @@ -59,6 +59,7 @@
>  
>  #include <media/lirc_dev.h>
>  #include <media/lirc.h>
> +#include <media/ir-kbd-i2c.h>
>  
>  struct IR_rx {
>  	/* RX device */
> @@ -89,6 +90,7 @@ struct IR {
>  	struct lirc_driver l;
>  
>  	struct mutex ir_lock;
> +	struct mutex *xcvr_lock;
>  	int open;
>  
>  	struct i2c_adapter *adapter;
> @@ -175,10 +177,10 @@ static int add_to_buf(struct IR *ir)
>  		 * Lock i2c bus for the duration.  RX/TX chips interfere so
>  		 * this is worth it
>  		 */
> -		mutex_lock(&ir->ir_lock);
> +		mutex_lock(ir->xcvr_lock);
>  
>  		if (kthread_should_stop()) {
> -			mutex_unlock(&ir->ir_lock);
> +			mutex_unlock(ir->xcvr_lock);
>  			return -ENODATA;
>  		}
>  
> @@ -190,7 +192,7 @@ static int add_to_buf(struct IR *ir)
>  		if (ret != 1) {
>  			zilog_error("i2c_master_send failed with %d\n",	ret);
>  			if (failures >= 3) {
> -				mutex_unlock(&ir->ir_lock);
> +				mutex_unlock(ir->xcvr_lock);
>  				zilog_error("unable to read from the IR chip "
>  					    "after 3 resets, giving up\n");
>  				return ret;
> @@ -202,23 +204,23 @@ static int add_to_buf(struct IR *ir)
>  
>  			set_current_state(TASK_UNINTERRUPTIBLE);
>  			if (kthread_should_stop()) {
> -				mutex_unlock(&ir->ir_lock);
> +				mutex_unlock(ir->xcvr_lock);
>  				return -ENODATA;
>  			}
>  			schedule_timeout((100 * HZ + 999) / 1000);
>  			ir->tx->need_boot = 1;
>  
>  			++failures;
> -			mutex_unlock(&ir->ir_lock);
> +			mutex_unlock(ir->xcvr_lock);
>  			continue;
>  		}
>  
>  		if (kthread_should_stop()) {
> -			mutex_unlock(&ir->ir_lock);
> +			mutex_unlock(ir->xcvr_lock);
>  			return -ENODATA;
>  		}
>  		ret = i2c_master_recv(rx->c, keybuf, sizeof(keybuf));
> -		mutex_unlock(&ir->ir_lock);
> +		mutex_unlock(ir->xcvr_lock);
>  		if (ret != sizeof(keybuf)) {
>  			zilog_error("i2c_master_recv failed with %d -- "
>  				    "keeping last read buffer\n", ret);
> @@ -920,7 +922,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
>  		return -EINVAL;
>  
>  	/* Lock i2c bus for the duration */
> -	mutex_lock(&ir->ir_lock);
> +	mutex_lock(ir->xcvr_lock);
>  
>  	/* Send each keypress */
>  	for (i = 0; i < n;) {
> @@ -928,7 +930,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
>  		int command;
>  
>  		if (copy_from_user(&command, buf + i, sizeof(command))) {
> -			mutex_unlock(&ir->ir_lock);
> +			mutex_unlock(ir->xcvr_lock);
>  			return -EFAULT;
>  		}
>  
> @@ -944,7 +946,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
>  			ret = send_code(tx, (unsigned)command >> 16,
>  					    (unsigned)command & 0xFFFF);
>  			if (ret == -EPROTO) {
> -				mutex_unlock(&ir->ir_lock);
> +				mutex_unlock(ir->xcvr_lock);
>  				return ret;
>  			}
>  		}
> @@ -961,7 +963,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
>  			if (failures >= 3) {
>  				zilog_error("unable to send to the IR chip "
>  					    "after 3 resets, giving up\n");
> -				mutex_unlock(&ir->ir_lock);
> +				mutex_unlock(ir->xcvr_lock);
>  				return ret;
>  			}
>  			set_current_state(TASK_UNINTERRUPTIBLE);
> @@ -973,7 +975,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
>  	}
>  
>  	/* Release i2c bus */
> -	mutex_unlock(&ir->ir_lock);
> +	mutex_unlock(ir->xcvr_lock);
>  
>  	/* All looks good */
>  	return n;
> @@ -1079,15 +1081,15 @@ static int open(struct inode *node, struct file *filep)
>  		return -ENODEV;
>  
>  	/* increment in use count */
> -	mutex_lock(&ir->ir_lock);
> +	mutex_lock(ir->xcvr_lock);
>  	++ir->open;
>  	ret = set_use_inc(ir);
>  	if (ret != 0) {
>  		--ir->open;
> -		mutex_unlock(&ir->ir_lock);
> +		mutex_unlock(ir->xcvr_lock);
>  		return ret;
>  	}
> -	mutex_unlock(&ir->ir_lock);
> +	mutex_unlock(ir->xcvr_lock);
>  
>  	/* stash our IR struct */
>  	filep->private_data = ir;
> @@ -1106,10 +1108,10 @@ static int close(struct inode *node, struct file *filep)
>  	}
>  
>  	/* decrement in use count */
> -	mutex_lock(&ir->ir_lock);
> +	mutex_lock(ir->xcvr_lock);
>  	--ir->open;
>  	set_use_dec(ir);
> -	mutex_unlock(&ir->ir_lock);
> +	mutex_unlock(ir->xcvr_lock);
>  
>  	return 0;
>  }
> @@ -1251,6 +1253,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
>  	struct IR *ir;
>  	struct i2c_adapter *adap = client->adapter;
> +	const struct IR_i2c_init_data *init_data = client->dev.platform_data;
>  	int ret;
>  	bool tx_probe = false;
>  
> @@ -1288,6 +1291,12 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		ir->adapter = adap;
>  		mutex_init(&ir->ir_lock);
>  
> +		/* Use bridge driver's transceiver lock, if provided */
> +		if (init_data != NULL)
> +			ir->xcvr_lock = init_data->transceiver_lock;
> +		if (ir->xcvr_lock == NULL)
> +			ir->xcvr_lock = &ir->ir_lock;
> +
>  		/* set lirc_dev stuff */
>  		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
>  		ir->l.minor       = minor; /* module option */
> diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
> index 768aa77..5893fd8 100644
> --- a/include/media/ir-kbd-i2c.h
> +++ b/include/media/ir-kbd-i2c.h
> @@ -21,6 +21,7 @@ struct IR_i2c {
>  	char                   name[32];
>  	char                   phys[32];
>  	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
> +	struct mutex	       *transceiver_lock;
>  };
>  
>  enum ir_kbd_get_key_fn {
> @@ -48,5 +49,7 @@ struct IR_i2c_init_data {
>  	enum ir_kbd_get_key_fn internal_get_key_func;
>  
>  	struct rc_dev		*rc_dev;
> +
> +	struct mutex		*transceiver_lock;
>  };
>  #endif
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

