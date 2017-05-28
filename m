Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:39074 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdE1I1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 04:27:01 -0400
Date: Sun, 28 May 2017 10:26:59 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 13/16] lirc_dev: use an ida instead of a hand-rolled
 array to keep track of minors
Message-ID: <20170528082659.pmc3lx33fv4rtrt6@hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
 <149365468212.12922.13495627052808022720.stgit@zeus.hardeman.nu>
 <20170522200942.GA22380@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170522200942.GA22380@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 22, 2017 at 09:09:42PM +0100, Sean Young wrote:
>On Mon, May 01, 2017 at 06:04:42PM +0200, David Härdeman wrote:
>> Using the kernel ida facilities, we can avoid a lot of unnecessary code and at the same
>> time get rid of lirc_dev_lock in favour of per-device locks (the irctls array was used
>> throughout lirc_dev so this patch necessarily touches a lot of code).
>> 
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>> ---
>>  drivers/media/rc/ir-lirc-codec.c        |    9 -
>>  drivers/media/rc/lirc_dev.c             |  258 ++++++++++++-------------------
>>  drivers/staging/media/lirc/lirc_zilog.c |   16 +-
>>  include/media/lirc_dev.h                |   14 --
>>  4 files changed, 115 insertions(+), 182 deletions(-)
>> 
>> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
>> index a30af91710fe..2c1221a61ea1 100644
>> --- a/drivers/media/rc/ir-lirc-codec.c
>> +++ b/drivers/media/rc/ir-lirc-codec.c
>> @@ -382,7 +382,6 @@ static int ir_lirc_register(struct rc_dev *dev)
>>  
>>  	snprintf(drv->name, sizeof(drv->name), "ir-lirc-codec (%s)",
>>  		 dev->driver_name);
>> -	drv->minor = -1;
>>  	drv->features = features;
>>  	drv->data = &dev->raw->lirc;
>>  	drv->rbuf = NULL;
>> @@ -394,11 +393,9 @@ static int ir_lirc_register(struct rc_dev *dev)
>>  	drv->rdev = dev;
>>  	drv->owner = THIS_MODULE;
>>  
>> -	drv->minor = lirc_register_driver(drv);
>> -	if (drv->minor < 0) {
>> -		rc = -ENODEV;
>> +	rc = lirc_register_driver(drv);
>> +	if (rc < 0)
>>  		goto out;
>> -	}
>>  
>>  	dev->raw->lirc.drv = drv;
>>  	dev->raw->lirc.dev = dev;
>> @@ -413,7 +410,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
>>  {
>>  	struct lirc_codec *lirc = &dev->raw->lirc;
>>  
>> -	lirc_unregister_driver(lirc->drv->minor);
>> +	lirc_unregister_driver(lirc->drv);
>>  	kfree(lirc->drv);
>>  	lirc->drv = NULL;
>>  
>> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
>> index e44e0b23b883..7db7d4c57991 100644
>> --- a/drivers/media/rc/lirc_dev.c
>> +++ b/drivers/media/rc/lirc_dev.c
>> @@ -31,23 +31,35 @@
>>  #include <linux/bitops.h>
>>  #include <linux/device.h>
>>  #include <linux/cdev.h>
>> +#include <linux/idr.h>
>>  
>>  #include <media/rc-core.h>
>>  #include <media/lirc.h>
>>  #include <media/lirc_dev.h>
>>  
>>  #define IRCTL_DEV_NAME	"BaseRemoteCtl"
>> -#define NOPLUG		-1
>>  #define LOGHEAD		"lirc_dev (%s[%d]): "
>>  
>>  static dev_t lirc_base_dev;
>>  
>> +/**
>> + * struct irctl - lirc per-device structure
>> + * @d:			internal copy of the &struct lirc_driver for the device
>> + * @dead:		if the device has gone away
>> + * @users:		the number of users of the lirc chardev (currently limited to 1)
>> + * @mutex:		synchronizes open()/close()/ioctl()/etc calls
>> + * @buf:		used to store lirc RX data
>> + * @buf_internal:	whether @buf was allocated internally or not
>> + * @chunk_size:		@buf stores and read() returns data chunks of this size
>> + * @dev:		the &struct device for the lirc device
>> + * @cdev:		the &struct device for the lirc chardev
>> + */
>>  struct irctl {
>>  	struct lirc_driver d;
>> -	int attached;
>> -	int open;
>> +	bool dead;
>> +	unsigned users;
>>  
>> -	struct mutex irctl_lock;
>> +	struct mutex mutex;
>>  	struct lirc_buffer *buf;
>>  	bool buf_internal;
>>  	unsigned int chunk_size;
>> @@ -56,9 +68,9 @@ struct irctl {
>>  	struct cdev cdev;
>>  };
>>  
>> -static DEFINE_MUTEX(lirc_dev_lock);
>> -
>> -static struct irctl *irctls[MAX_IRCTL_DEVICES];
>> +/* Used to keep track of allocated lirc devices */
>> +#define LIRC_MAX_DEVICES 256
>> +static DEFINE_IDA(lirc_ida);
>>  
>>  /* Only used for sysfs but defined to void otherwise */
>>  static struct class *lirc_class;
>> @@ -72,9 +84,6 @@ static void lirc_release(struct device *ld)
>>  		kfree(ir->buf);
>>  	}
>>  
>> -	mutex_lock(&lirc_dev_lock);
>> -	irctls[ir->d.minor] = NULL;
>> -	mutex_unlock(&lirc_dev_lock);
>>  	kfree(ir);
>>  }
>>  
>> @@ -117,7 +126,18 @@ static int lirc_allocate_buffer(struct irctl *ir)
>>  	return err;
>>  }
>>  
>> -int lirc_register_driver(struct lirc_driver *d)
>> +/**
>> + * lirc_register_driver() - create a new lirc device by registering a driver
>> + * @d: the &struct lirc_driver to register
>> + *
>> + * This function allocates and registers a lirc device for a given
>> + * &lirc_driver. The &lirc_driver structure is updated to contain
>> + * information about the allocated device (minor, buffer, etc).
>> + *
>> + * Return: zero on success or a negative error value.
>> + */
>> +int
>> +lirc_register_driver(struct lirc_driver *d)
>>  {
>>  	struct irctl *ir;
>>  	int minor;
>> @@ -138,12 +158,6 @@ int lirc_register_driver(struct lirc_driver *d)
>>  		return -EINVAL;
>>  	}
>>  
>> -	if (d->minor >= MAX_IRCTL_DEVICES) {
>> -		dev_err(d->dev, "minor must be between 0 and %d!\n",
>> -						MAX_IRCTL_DEVICES - 1);
>> -		return -EBADRQC;
>> -	}
>> -
>>  	if (d->code_length < 1 || d->code_length > (BUFLEN * 8)) {
>>  		dev_err(d->dev, "code length must be less than %d bits\n",
>>  								BUFLEN * 8);
>> @@ -156,49 +170,30 @@ int lirc_register_driver(struct lirc_driver *d)
>>  		return -EBADRQC;
>>  	}
>>  
>> -	mutex_lock(&lirc_dev_lock);
>> -
>> -	minor = d->minor;
>> +	d->name[sizeof(d->name)-1] = '\0';
>> +	if (d->features == 0)
>> +		d->features = LIRC_CAN_REC_LIRCCODE;
>>  
>> -	if (minor < 0) {
>> -		/* find first free slot for driver */
>> -		for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
>> -			if (!irctls[minor])
>> -				break;
>> -		if (minor == MAX_IRCTL_DEVICES) {
>> -			dev_err(d->dev, "no free slots for drivers!\n");
>> -			err = -ENOMEM;
>> -			goto out_lock;
>> -		}
>> -	} else if (irctls[minor]) {
>> -		dev_err(d->dev, "minor (%d) just registered!\n", minor);
>> -		err = -EBUSY;
>> -		goto out_lock;
>> -	}
>> +	minor = ida_simple_get(&lirc_ida, 0, LIRC_MAX_DEVICES, GFP_KERNEL);
>> +	if (minor < 0)
>> +		return minor;
>> +	d->minor = minor;
>>  
>>  	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
>>  	if (!ir) {
>>  		err = -ENOMEM;
>> -		goto out_lock;
>> +		goto out_minor;
>>  	}
>>  
>> -	mutex_init(&ir->irctl_lock);
>> -	irctls[minor] = ir;
>> -	d->minor = minor;
>> -
>> -	/* some safety check 8-) */
>> -	d->name[sizeof(d->name)-1] = '\0';
>> -
>> -	if (d->features == 0)
>> -		d->features = LIRC_CAN_REC_LIRCCODE;
>> +	mutex_init(&ir->mutex);
>>  
>>  	ir->d = *d;
>
>Here we copy lirc_driver.
>
>>  
>>  	if (LIRC_CAN_REC(d->features)) {
>> -		err = lirc_allocate_buffer(irctls[minor]);
>> +		err = lirc_allocate_buffer(ir);
>>  		if (err) {
>>  			kfree(ir);
>> -			goto out_lock;
>> +			goto out_minor;
>>  		}
>>  		d->rbuf = ir->buf;
>>  	}
>> @@ -218,107 +213,82 @@ int lirc_register_driver(struct lirc_driver *d)
>>  	if (err)
>>  		goto out_free_dev;
>>  
>> -	ir->attached = 1;
>> -
>>  	err = device_add(&ir->dev);
>>  	if (err)
>>  		goto out_cdev;
>>  
>> -	mutex_unlock(&lirc_dev_lock);
>> -
>>  	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
>>  		 ir->d.name, ir->d.minor);
>>  
>> -	return minor;
>> +	d->lirc_internal = ir;
>
>And now a store a pointer to the copy in the original lirc_driver. 
>
>It would be much better to not copy lirc_driver and the lirc_internal
>member would be unnecessary.

I know, but this is a more minimal fix. The struct copy is already in
the current code and I'd prefer removing it in a separate patch once the
use of lirc_driver has been vetted.

>> +	return 0;
>>  
>>  out_cdev:
>>  	cdev_del(&ir->cdev);
>>  out_free_dev:
>>  	put_device(&ir->dev);
>> -out_lock:
>> -	mutex_unlock(&lirc_dev_lock);
>> +out_minor:
>> +	ida_simple_remove(&lirc_ida, minor);
>>  
>>  	return err;
>>  }
>>  EXPORT_SYMBOL(lirc_register_driver);
>>  
>> -int lirc_unregister_driver(int minor)
>> +/**
>> + * lirc_unregister_driver() - remove the lirc device for a given driver
>> + * @d: the &struct lirc_driver to unregister
>> + *
>> + * This function unregisters the lirc device for a given &lirc_driver.
>> + */
>> +void
>> +lirc_unregister_driver(struct lirc_driver *d)
>>  {
>>  	struct irctl *ir;
>>  
>> -	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
>> -		pr_err("minor (%d) must be between 0 and %d!\n",
>> -					minor, MAX_IRCTL_DEVICES - 1);
>> -		return -EBADRQC;
>> -	}
>> +	if (!d->lirc_internal)
>> +		return;
>>  
>> -	ir = irctls[minor];
>> -	if (!ir) {
>> -		pr_err("failed to get irctl\n");
>> -		return -ENOENT;
>> -	}
>> +	ir = d->lirc_internal;
>
>This is done to find a our copy again.
>
>> -	mutex_lock(&lirc_dev_lock);
>> -
>> -	if (ir->d.minor != minor) {
>> -		dev_err(ir->d.dev, "lirc_dev: minor %d device not registered\n",
>> -									minor);
>> -		mutex_unlock(&lirc_dev_lock);
>> -		return -ENOENT;
>> -	}
>> +	mutex_lock(&ir->mutex);
>>  
>>  	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
>>  		ir->d.name, ir->d.minor);
>>  
>> -	ir->attached = 0;
>> -	if (ir->open) {
>> +	ir->dead = true;
>> +	if (ir->users) {
>>  		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
>>  			ir->d.name, ir->d.minor);
>>  		wake_up_interruptible(&ir->buf->wait_poll);
>>  	}
>>  
>> -	mutex_unlock(&lirc_dev_lock);
>> +	mutex_unlock(&ir->mutex);
>>  
>>  	device_del(&ir->dev);
>>  	cdev_del(&ir->cdev);
>> -	put_device(&ir->dev);
>> -
>> -	return 0;
>> +	ida_simple_remove(&lirc_ida, d->minor);
>> +	d->minor = -1;
>> +	d->lirc_internal = NULL;
>>  }
>>  EXPORT_SYMBOL(lirc_unregister_driver);
>>  
>>  int lirc_dev_fop_open(struct inode *inode, struct file *file)
>>  {
>> -	struct irctl *ir;
>> +	struct irctl *ir = container_of(inode->i_cdev, struct irctl, cdev);
>>  	int retval;
>>  
>> -	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
>> -		pr_err("open result for %d is -ENODEV\n", iminor(inode));
>> -		return -ENODEV;
>> -	}
>> -
>> -	if (mutex_lock_interruptible(&lirc_dev_lock))
>> -		return -ERESTARTSYS;
>> +	mutex_lock(&ir->mutex);
>>  
>> -	ir = irctls[iminor(inode)];
>> -	mutex_unlock(&lirc_dev_lock);
>> -
>> -	if (!ir) {
>> -		retval = -ENODEV;
>> +	if (ir->users) {
>> +		retval = -EBUSY;
>> +		mutex_unlock(&ir->mutex);
>>  		goto error;
>>  	}
>> +	ir->users++;
>>  
>> -	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
>> -
>> -	if (ir->d.minor == NOPLUG) {
>> -		retval = -ENODEV;
>> -		goto error;
>> -	}
>> +	mutex_unlock(&ir->mutex);
>>  
>> -	if (ir->open) {
>> -		retval = -EBUSY;
>> -		goto error;
>> -	}
>> +	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
>>  
>>  	if (ir->d.rdev) {
>>  		retval = rc_open(ir->d.rdev);
>> @@ -329,8 +299,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
>>  	if (ir->buf)
>>  		lirc_buffer_clear(ir->buf);
>>  
>> -	ir->open++;
>> -
>> +	file->private_data = ir;
>>  	nonseekable_open(inode, file);
>>  
>>  	return 0;
>> @@ -342,22 +311,14 @@ EXPORT_SYMBOL(lirc_dev_fop_open);
>>  
>>  int lirc_dev_fop_close(struct inode *inode, struct file *file)
>>  {
>> -	struct irctl *ir = irctls[iminor(inode)];
>> -	int ret;
>> -
>> -	if (!ir) {
>> -		pr_err("called with invalid irctl\n");
>> -		return -EINVAL;
>> -	}
>> +	struct irctl *ir = file->private_data;
>>  
>> -	ret = mutex_lock_killable(&lirc_dev_lock);
>> -	WARN_ON(ret);
>> +	mutex_lock(&ir->mutex);
>>  
>>  	rc_close(ir->d.rdev);
>> +	ir->users--;
>>  
>> -	ir->open--;
>> -	if (!ret)
>> -		mutex_unlock(&lirc_dev_lock);
>> +	mutex_unlock(&ir->mutex);
>>  
>>  	return 0;
>>  }
>> @@ -365,26 +326,21 @@ EXPORT_SYMBOL(lirc_dev_fop_close);
>>  
>>  unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
>>  {
>> -	struct irctl *ir = irctls[iminor(file_inode(file))];
>> +	struct irctl *ir = file->private_data;
>>  	unsigned int ret;
>>  
>> -	if (!ir) {
>> -		pr_err("called with invalid irctl\n");
>> -		return POLLERR;
>> -	}
>> -
>> -	if (!ir->attached)
>> +	if (ir->dead)
>>  		return POLLHUP | POLLERR;
>>  
>> -	if (ir->buf) {
>> -		poll_wait(file, &ir->buf->wait_poll, wait);
>> +	if (!ir->buf)
>> +		return POLLERR;
>> +
>> +	poll_wait(file, &ir->buf->wait_poll, wait);
>>  
>> -		if (lirc_buffer_empty(ir->buf))
>> -			ret = 0;
>> -		else
>> -			ret = POLLIN | POLLRDNORM;
>> -	} else
>> -		ret = POLLERR;
>> +	if (lirc_buffer_empty(ir->buf))
>> +		ret = 0;
>> +	else
>> +		ret = POLLIN | POLLRDNORM;
>>  
>>  	dev_dbg(ir->d.dev, LOGHEAD "poll result = %d\n",
>>  		ir->d.name, ir->d.minor, ret);
>> @@ -395,25 +351,20 @@ EXPORT_SYMBOL(lirc_dev_fop_poll);
>>  
>>  long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>  {
>> +	struct irctl *ir = file->private_data;
>>  	__u32 mode;
>>  	int result = 0;
>> -	struct irctl *ir = irctls[iminor(file_inode(file))];
>> -
>> -	if (!ir) {
>> -		pr_err("no irctl found!\n");
>> -		return -ENODEV;
>> -	}
>>  
>>  	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
>>  		ir->d.name, ir->d.minor, cmd);
>>  
>> -	if (ir->d.minor == NOPLUG || !ir->attached) {
>> +	if (ir->dead) {
>>  		dev_err(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
>>  			ir->d.name, ir->d.minor);
>>  		return -ENODEV;
>>  	}
>>  
>> -	mutex_lock(&ir->irctl_lock);
>> +	mutex_lock(&ir->mutex);
>>  
>>  	switch (cmd) {
>>  	case LIRC_GET_FEATURES:
>> @@ -468,7 +419,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>  		result = -ENOTTY;
>>  	}
>>  
>> -	mutex_unlock(&ir->irctl_lock);
>> +	mutex_unlock(&ir->mutex);
>>  
>>  	return result;
>>  }
>> @@ -479,16 +430,11 @@ ssize_t lirc_dev_fop_read(struct file *file,
>>  			  size_t length,
>>  			  loff_t *ppos)
>>  {
>> -	struct irctl *ir = irctls[iminor(file_inode(file))];
>> +	struct irctl *ir = file->private_data;
>>  	unsigned char *buf;
>>  	int ret = 0, written = 0;
>>  	DECLARE_WAITQUEUE(wait, current);
>>  
>> -	if (!ir) {
>> -		pr_err("called with invalid irctl\n");
>> -		return -ENODEV;
>> -	}
>> -
>>  	if (!LIRC_CAN_REC(ir->d.features))
>>  		return -EINVAL;
>>  
>> @@ -498,11 +444,12 @@ ssize_t lirc_dev_fop_read(struct file *file,
>>  	if (!buf)
>>  		return -ENOMEM;
>>  
>> -	if (mutex_lock_interruptible(&ir->irctl_lock)) {
>> +	if (mutex_lock_interruptible(&ir->mutex)) {
>>  		ret = -ERESTARTSYS;
>>  		goto out_unlocked;
>>  	}
>> -	if (!ir->attached) {
>> +
>> +	if (ir->dead) {
>>  		ret = -ENODEV;
>>  		goto out_locked;
>>  	}
>> @@ -541,18 +488,18 @@ ssize_t lirc_dev_fop_read(struct file *file,
>>  				break;
>>  			}
>>  
>> -			mutex_unlock(&ir->irctl_lock);
>> +			mutex_unlock(&ir->mutex);
>>  			set_current_state(TASK_INTERRUPTIBLE);
>>  			schedule();
>>  			set_current_state(TASK_RUNNING);
>>  
>> -			if (mutex_lock_interruptible(&ir->irctl_lock)) {
>> +			if (mutex_lock_interruptible(&ir->mutex)) {
>>  				ret = -ERESTARTSYS;
>>  				remove_wait_queue(&ir->buf->wait_poll, &wait);
>>  				goto out_unlocked;
>>  			}
>>  
>> -			if (!ir->attached) {
>> +			if (ir->dead) {
>>  				ret = -ENODEV;
>>  				goto out_locked;
>>  			}
>> @@ -570,7 +517,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
>>  	remove_wait_queue(&ir->buf->wait_poll, &wait);
>>  
>>  out_locked:
>> -	mutex_unlock(&ir->irctl_lock);
>> +	mutex_unlock(&ir->mutex);
>>  
>>  out_unlocked:
>>  	kfree(buf);
>> @@ -581,7 +528,8 @@ EXPORT_SYMBOL(lirc_dev_fop_read);
>>  
>>  void *lirc_get_pdata(struct file *file)
>>  {
>> -	return irctls[iminor(file_inode(file))]->d.data;
>> +	struct irctl *ir = file->private_data;
>> +	return ir->d.data;
>>  }
>>  EXPORT_SYMBOL(lirc_get_pdata);
>>  
>> @@ -596,7 +544,7 @@ static int __init lirc_dev_init(void)
>>  		return PTR_ERR(lirc_class);
>>  	}
>>  
>> -	retval = alloc_chrdev_region(&lirc_base_dev, 0, MAX_IRCTL_DEVICES,
>> +	retval = alloc_chrdev_region(&lirc_base_dev, 0, LIRC_MAX_DEVICES,
>>  				     IRCTL_DEV_NAME);
>>  	if (retval) {
>>  		class_destroy(lirc_class);
>> @@ -613,7 +561,7 @@ static int __init lirc_dev_init(void)
>>  static void __exit lirc_dev_exit(void)
>>  {
>>  	class_destroy(lirc_class);
>> -	unregister_chrdev_region(lirc_base_dev, MAX_IRCTL_DEVICES);
>> +	unregister_chrdev_region(lirc_base_dev, LIRC_MAX_DEVICES);
>>  	pr_info("module unloaded\n");
>>  }
>>  
>> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
>> index 59e05aa1bc55..ffb70dee4547 100644
>> --- a/drivers/staging/media/lirc/lirc_zilog.c
>> +++ b/drivers/staging/media/lirc/lirc_zilog.c
>> @@ -183,11 +183,7 @@ static void release_ir_device(struct kref *ref)
>>  	 * ir->open_count ==  0 - happens on final close()
>>  	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
>>  	 */
>> -	if (ir->l.minor >= 0) {
>> -		lirc_unregister_driver(ir->l.minor);
>> -		ir->l.minor = -1;
>> -	}
>> -
>> +	lirc_unregister_driver(&ir->l);
>>  	if (kfifo_initialized(&ir->rbuf.fifo))
>>  		lirc_buffer_free(&ir->rbuf);
>>  	list_del(&ir->list);
>> @@ -1382,7 +1378,6 @@ static const struct file_operations lirc_fops = {
>>  
>>  static struct lirc_driver lirc_template = {
>>  	.name		= "lirc_zilog",
>> -	.minor		= -1,
>>  	.code_length	= 13,
>>  	.buffer_size	= BUFLEN / 2,
>>  	.chunk_size	= 2,
>> @@ -1597,14 +1592,13 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>>  	}
>>  
>>  	/* register with lirc */
>> -	ir->l.minor = lirc_register_driver(&ir->l);
>> -	if (ir->l.minor < 0) {
>> +	ret = lirc_register_driver(&ir->l);
>> +	if (ret < 0) {
>>  		dev_err(tx->ir->l.dev,
>> -			"%s: lirc_register_driver() failed: %i\n",
>> -			__func__, ir->l.minor);
>> -		ret = -EBADRQC;
>> +			"%s: lirc_register_driver failed: %i\n", __func__, ret);
>>  		goto out_put_xx;
>>  	}
>> +
>>  	dev_info(ir->l.dev,
>>  		 "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
>>  		 adap->name, adap->nr, ir->l.minor);
>> diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
>> index 1f327e25a9be..f7629ff116a9 100644
>> --- a/include/media/lirc_dev.h
>> +++ b/include/media/lirc_dev.h
>> @@ -9,7 +9,6 @@
>>  #ifndef _LINUX_LIRC_DEV_H
>>  #define _LINUX_LIRC_DEV_H
>>  
>> -#define MAX_IRCTL_DEVICES 8
>>  #define BUFLEN            16
>>  
>>  #define mod(n, div) ((n) % (div))
>> @@ -164,6 +163,8 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
>>   *			device.
>>   *
>>   * @owner:		the module owning this struct
>> + *
>> + * @lirc_internal:	lirc_dev bookkeeping data, don't touch.
>
>It's not a great name or comment :)
>
>Otherwise, it's a good idea.
>
>
>Sean
>
>>   */
>>  struct lirc_driver {
>>  	char name[40];
>> @@ -182,19 +183,12 @@ struct lirc_driver {
>>  	const struct file_operations *fops;
>>  	struct device *dev;
>>  	struct module *owner;
>> +	void *lirc_internal;
>>  };
>>  
>> -/* following functions can be called ONLY from user context
>> - *
>> - * returns negative value on error or minor number
>> - * of the registered device if success
>> - * contents of the structure pointed by p is copied
>> - */
>>  extern int lirc_register_driver(struct lirc_driver *d);
>>  
>> -/* returns negative value on error or 0 if success
>> -*/
>> -extern int lirc_unregister_driver(int minor);
>> +extern void lirc_unregister_driver(struct lirc_driver *d);
>>  
>>  /* Returns the private data stored in the lirc_driver
>>   * associated with the given device file pointer.

-- 
David Härdeman
