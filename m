Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:50804 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbbESWGo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 18:06:44 -0400
Date: Tue, 19 May 2015 23:37:23 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: s.l-h@gmx.de, linux-media@vger.kernel.org
Subject: Re: [PATCH] rc-core: use an IDA rather than a bitmap
Message-ID: <20150519213723.GI18036@hardeman.nu>
References: <20150402101855.5223.5158.stgit@zeus.muc.hardeman.nu>
 <20150514172929.07e09549@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150514172929.07e09549@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 14, 2015 at 05:29:29PM -0300, Mauro Carvalho Chehab wrote:
>Em Thu, 02 Apr 2015 12:18:55 +0200
>David Härdeman <david@hardeman.nu> escreveu:
>
>> This patch changes rc-core to use the kernel facilities that are already
>> available for handling unique numbers instead of rolling its own bitmap
>> stuff.
>> 
>> Stefan, this should apply cleanly to the media git tree...could you test it?
>
>Patch looks good to me but...
>
>you forgot to add your SOB on it.

I didn't add it 'cause I wanted Stefan to test it first. Seems he's done
so...so I'll resubmit with my SOB and his Tested-by...

>
>> ---
>>  drivers/media/rc/rc-ir-raw.c |    2 +-
>>  drivers/media/rc/rc-main.c   |   40 ++++++++++++++++++++--------------------
>>  include/media/rc-core.h      |    4 ++--
>>  3 files changed, 23 insertions(+), 23 deletions(-)
>> 
>> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
>> index b732ac6..ad26052 100644
>> --- a/drivers/media/rc/rc-ir-raw.c
>> +++ b/drivers/media/rc/rc-ir-raw.c
>> @@ -271,7 +271,7 @@ int ir_raw_event_register(struct rc_dev *dev)
>>  
>>  	spin_lock_init(&dev->raw->lock);
>>  	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
>> -				       "rc%ld", dev->devno);
>> +				       "rc%u", dev->minor);
>>  
>>  	if (IS_ERR(dev->raw->thread)) {
>>  		rc = PTR_ERR(dev->raw->thread);
>> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>> index f8c5e47..d068c4e 100644
>> --- a/drivers/media/rc/rc-main.c
>> +++ b/drivers/media/rc/rc-main.c
>> @@ -18,17 +18,15 @@
>>  #include <linux/input.h>
>>  #include <linux/leds.h>
>>  #include <linux/slab.h>
>> +#include <linux/idr.h>
>>  #include <linux/device.h>
>>  #include <linux/module.h>
>>  #include "rc-core-priv.h"
>>  
>> -/* Bitmap to store allocated device numbers from 0 to IRRCV_NUM_DEVICES - 1 */
>> -#define IRRCV_NUM_DEVICES      256
>> -static DECLARE_BITMAP(ir_core_dev_number, IRRCV_NUM_DEVICES);
>> -
>>  /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
>>  #define IR_TAB_MIN_SIZE	256
>>  #define IR_TAB_MAX_SIZE	8192
>> +#define RC_DEV_MAX	256
>>  
>>  /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
>>  #define IR_KEYPRESS_TIMEOUT 250
>> @@ -38,6 +36,9 @@ static LIST_HEAD(rc_map_list);
>>  static DEFINE_SPINLOCK(rc_map_lock);
>>  static struct led_trigger *led_feedback;
>>  
>> +/* Used to keep track of rc devices */
>> +static DEFINE_IDA(rc_ida);
>> +
>>  static struct rc_map_list *seek_rc_map(const char *name)
>>  {
>>  	struct rc_map_list *map = NULL;
>> @@ -1312,7 +1313,9 @@ int rc_register_device(struct rc_dev *dev)
>>  	static bool raw_init = false; /* raw decoders loaded? */
>>  	struct rc_map *rc_map;
>>  	const char *path;
>> -	int rc, devno, attr = 0;
>> +	int attr = 0;
>> +	int minor;
>> +	int rc;
>>  
>>  	if (!dev || !dev->map_name)
>>  		return -EINVAL;
>> @@ -1332,13 +1335,13 @@ int rc_register_device(struct rc_dev *dev)
>>  	if (dev->close)
>>  		dev->input_dev->close = ir_close;
>>  
>> -	do {
>> -		devno = find_first_zero_bit(ir_core_dev_number,
>> -					    IRRCV_NUM_DEVICES);
>> -		/* No free device slots */
>> -		if (devno >= IRRCV_NUM_DEVICES)
>> -			return -ENOMEM;
>> -	} while (test_and_set_bit(devno, ir_core_dev_number));
>> +	minor = ida_simple_get(&rc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
>> +	if (minor < 0)
>> +		return minor;
>> +
>> +	dev->minor = minor;
>> +	dev_set_name(&dev->dev, "rc%u", dev->minor);
>> +	dev_set_drvdata(&dev->dev, dev);
>>  
>>  	dev->dev.groups = dev->sysfs_groups;
>>  	dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
>> @@ -1358,9 +1361,6 @@ int rc_register_device(struct rc_dev *dev)
>>  	 */
>>  	mutex_lock(&dev->lock);
>>  
>> -	dev->devno = devno;
>> -	dev_set_name(&dev->dev, "rc%ld", dev->devno);
>> -	dev_set_drvdata(&dev->dev, dev);
>>  	rc = device_add(&dev->dev);
>>  	if (rc)
>>  		goto out_unlock;
>> @@ -1433,8 +1433,8 @@ int rc_register_device(struct rc_dev *dev)
>>  
>>  	mutex_unlock(&dev->lock);
>>  
>> -	IR_dprintk(1, "Registered rc%ld (driver: %s, remote: %s, mode %s)\n",
>> -		   dev->devno,
>> +	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
>> +		   dev->minor,
>>  		   dev->driver_name ? dev->driver_name : "unknown",
>>  		   rc_map->name ? rc_map->name : "unknown",
>>  		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
>> @@ -1453,7 +1453,7 @@ out_dev:
>>  	device_del(&dev->dev);
>>  out_unlock:
>>  	mutex_unlock(&dev->lock);
>> -	clear_bit(dev->devno, ir_core_dev_number);
>> +	ida_simple_remove(&rc_ida, minor);
>>  	return rc;
>>  }
>>  EXPORT_SYMBOL_GPL(rc_register_device);
>> @@ -1465,8 +1465,6 @@ void rc_unregister_device(struct rc_dev *dev)
>>  
>>  	del_timer_sync(&dev->timer_keyup);
>>  
>> -	clear_bit(dev->devno, ir_core_dev_number);
>> -
>>  	if (dev->driver_type == RC_DRIVER_IR_RAW)
>>  		ir_raw_event_unregister(dev);
>>  
>> @@ -1479,6 +1477,8 @@ void rc_unregister_device(struct rc_dev *dev)
>>  
>>  	device_del(&dev->dev);
>>  
>> +	ida_simple_remove(&rc_ida, dev->minor);
>> +
>>  	rc_free_device(dev);
>>  }
>>  
>> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
>> index 2c7fbca..6b4400c 100644
>> --- a/include/media/rc-core.h
>> +++ b/include/media/rc-core.h
>> @@ -69,7 +69,7 @@ enum rc_filter_type {
>>   * @rc_map: current scan/key table
>>   * @lock: used to ensure we've filled in all protocol details before
>>   *	anyone can call show_protocols or store_protocols
>> - * @devno: unique remote control device number
>> + * @minor: unique minor remote control device number
>>   * @raw: additional data for raw pulse/space devices
>>   * @input_dev: the input child device used to communicate events to userspace
>>   * @driver_type: specifies if protocol decoding is done in hardware or software
>> @@ -129,7 +129,7 @@ struct rc_dev {
>>  	const char			*map_name;
>>  	struct rc_map			rc_map;
>>  	struct mutex			lock;
>> -	unsigned long			devno;
>> +	unsigned int			minor;
>>  	struct ir_raw_event_ctrl	*raw;
>>  	struct input_dev		*input_dev;
>>  	enum rc_driver_type		driver_type;
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
David Härdeman
