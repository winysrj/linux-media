Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:27680 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaGYWwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 18:52:43 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A00H27I7UEIA0@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 18:52:42 -0400 (EDT)
Date: Fri, 25 Jul 2014 19:52:37 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 32/49] rc-core: prepare for multiple keytables
Message-id: <20140725195237.3dd5f64c.m.chehab@samsung.com>
In-reply-to: <20140403233357.27099.61837.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
 <20140403233357.27099.61837.stgit@zeus.muc.hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Apr 2014 01:33:57 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Introduce struct rc_keytable which essentially maintains an input device
> and a table with scancode,protocol <-> keycode mappings. Move the relevant
> members from struct rc_dev into struct rc_keytable.

I can't apply this patch (and probably the other patches above patch 31,
because of the file split.

> This is in preparation for supporting multiple keytables, where each
> keytable would correspond to one physical remote controller, each with
> its own keymap and input device for reporting events to userspace.

Again, it deserves some RFC discussions. Why do you need multiple
keytables? How to update them from userspace without breaking the
existing support? 

Also, there are some devices where it is an impossible goal. For
example, there are several dib0700 devices that are identical to
the dibcom SDK hardware. Even the USB ID is the same. The only thing
that differs one device from the others is the IR layout.

This is solved at Kernel level with a table with several devices
inside it.

Ok, we could still use multiple keytables and associate those
generic USB ID to those tables, but it seems overkill, at least
at a first glance.

P.S.: I'll just tag the patches related to multiple keytables
as "Changes requested" just like this one without further notice,
as I'm expecting you to submit this patch series as a separate
patchset, after we have an agreement on your RFC.

Regards,
Mauro

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/rc-core-priv.h |   16 +-
>  drivers/media/rc/rc-keytable.c  |  341 ++++++++++++++++++++++-----------------
>  drivers/media/rc/rc-main.c      |  224 +++++++++++---------------
>  include/media/rc-core.h         |   62 +++++--
>  4 files changed, 338 insertions(+), 305 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index 6da8a0d..7a7770e 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -158,16 +158,12 @@ void ir_raw_init(void);
>  /*
>   * Methods from rc-keytable.c to be used internally
>   */
> -void ir_timer_keyup(unsigned long cookie);
> -int rc_input_open(struct input_dev *idev);
> -void rc_input_close(struct input_dev *idev);
> -int ir_setkeytable(struct rc_dev *dev, const struct rc_map *from);
> -void ir_free_table(struct rc_map *rc_map);
> -int ir_getkeycode(struct input_dev *idev,
> -		  struct input_keymap_entry *ke);
> -int ir_setkeycode(struct input_dev *idev,
> -		  const struct input_keymap_entry *ke,
> -		  unsigned int *old_keycode);
> +void rc_keytable_keyup(struct rc_keytable *kt);
> +void rc_keytable_repeat(struct rc_keytable *kt);
> +void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
> +			 u32 scancode, u8 toggle, bool autokeyup);
> +int rc_keytable_add(struct rc_dev *dev, struct rc_map *rc_map);
> +void rc_keytable_del(struct rc_dev *dev);
>  
>  /* Only to be used by rc-core and ir-lirc-codec */
>  void rc_init_ir_rx(struct rc_dev *dev, struct rc_ir_rx *rx);
> diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
> index 25faeba..0f1b817 100644
> --- a/drivers/media/rc/rc-keytable.c
> +++ b/drivers/media/rc/rc-keytable.c
> @@ -187,7 +187,7 @@ static int ir_resize_table(struct rc_map *rc_map, gfp_t gfp_flags)
>  
>  /**
>   * ir_update_mapping() - set a keycode in the scancode->keycode table
> - * @dev:	the struct rc_dev device descriptor
> + * @kt:		the struct rc_keytable
>   * @rc_map:	scancode table to be adjusted
>   * @index:	index of the mapping that needs to be updated
>   * @keycode:	the desired keycode
> @@ -196,7 +196,7 @@ static int ir_resize_table(struct rc_map *rc_map, gfp_t gfp_flags)
>   * This routine is used to update scancode->keycode mapping at given
>   * position.
>   */
> -static unsigned int ir_update_mapping(struct rc_dev *dev,
> +static unsigned int ir_update_mapping(struct rc_keytable *kt,
>  				      struct rc_map *rc_map,
>  				      unsigned int index,
>  				      unsigned int new_keycode)
> @@ -221,16 +221,16 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
>  			   (unsigned long long)rc_map->scan[index].scancode,
>  			   new_keycode);
>  		rc_map->scan[index].keycode = new_keycode;
> -		__set_bit(new_keycode, dev->input_dev->keybit);
> +		__set_bit(new_keycode, kt->idev->keybit);
>  	}
>  
>  	if (old_keycode != KEY_RESERVED) {
>  		/* A previous mapping was updated... */
> -		__clear_bit(old_keycode, dev->input_dev->keybit);
> +		__clear_bit(old_keycode, kt->idev->keybit);
>  		/* ... but another scancode might use the same keycode */
>  		for (i = 0; i < rc_map->len; i++) {
>  			if (rc_map->scan[i].keycode == old_keycode) {
> -				__set_bit(old_keycode, dev->input_dev->keybit);
> +				__set_bit(old_keycode, kt->idev->keybit);
>  				break;
>  			}
>  		}
> @@ -244,7 +244,7 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
>  
>  /**
>   * ir_establish_scancode() - set a keycode in the scancode->keycode table
> - * @dev:	the struct rc_dev device descriptor
> + * @kt:		the struct rc_keytable descriptor
>   * @rc_map:	scancode table to be searched
>   * @entry:	the entry to be added to the table
>   * @resize:	controls whether we are allowed to resize the table to
> @@ -256,7 +256,7 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
>   * If scancode is not yet present the routine will allocate a new slot
>   * for it.
>   */
> -static unsigned int ir_establish_scancode(struct rc_dev *dev,
> +static unsigned int ir_establish_scancode(struct rc_keytable *kt,
>  					  struct rc_map *rc_map,
>  					  struct rc_map_table *entry,
>  					  bool resize)
> @@ -271,8 +271,8 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
>  	 * IR tables from other remotes. So, we support specifying a mask to
>  	 * indicate the valid bits of the scancodes.
>  	 */
> -	if (dev->scancode_mask)
> -		entry->scancode &= dev->scancode_mask;
> +	if (kt->dev->scancode_mask)
> +		entry->scancode &= kt->dev->scancode_mask;
>  
>  	/*
>  	 * First check if we already have a mapping for this command.
> @@ -322,7 +322,7 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
>   */
>  static inline enum rc_type guess_protocol(struct rc_dev *rdev)
>  {
> -	struct rc_map *rc_map = &rdev->rc_map;
> +	struct rc_map *rc_map = &rdev->kt->rc_map;
>  
>  	if (hweight64(rdev->enabled_protocols) == 1)
>  		return rc_bitmap_to_type(rdev->enabled_protocols);
> @@ -367,12 +367,13 @@ static u32 to_nec32(u32 orig)
>   *
>   * This routine is used to handle evdev EVIOCSKEY ioctl.
>   */
> -int ir_setkeycode(struct input_dev *idev,
> -		  const struct input_keymap_entry *ke,
> -		  unsigned int *old_keycode)
> +static int ir_setkeycode(struct input_dev *idev,
> +			 const struct input_keymap_entry *ke,
> +			 unsigned int *old_keycode)
>  {
> -	struct rc_dev *rdev = input_get_drvdata(idev);
> -	struct rc_map *rc_map = &rdev->rc_map;
> +	struct rc_keytable *kt = input_get_drvdata(idev);
> +	struct rc_dev *rdev = kt->dev;
> +	struct rc_map *rc_map = &kt->rc_map;
>  	unsigned int index;
>  	struct rc_map_table entry;
>  	int retval = 0;
> @@ -400,7 +401,7 @@ int ir_setkeycode(struct input_dev *idev,
>  		if (entry.protocol == RC_TYPE_NEC)
>  			entry.scancode = to_nec32(scancode);
>  
> -		index = ir_establish_scancode(rdev, rc_map, &entry, true);
> +		index = ir_establish_scancode(kt, rc_map, &entry, true);
>  		if (index >= rc_map->len) {
>  			retval = -ENOMEM;
>  			goto out;
> @@ -416,7 +417,7 @@ int ir_setkeycode(struct input_dev *idev,
>  			goto out;
>  		}
>  
> -		index = ir_establish_scancode(rdev, rc_map, &entry, true);
> +		index = ir_establish_scancode(kt, rc_map, &entry, true);
>  		if (index >= rc_map->len) {
>  			retval = -ENOMEM;
>  			goto out;
> @@ -426,7 +427,7 @@ int ir_setkeycode(struct input_dev *idev,
>  		goto out;
>  	}
>  
> -	*old_keycode = ir_update_mapping(rdev, rc_map, index, ke->keycode);
> +	*old_keycode = ir_update_mapping(kt, rc_map, index, ke->keycode);
>  
>  out:
>  	spin_unlock_irqrestore(&rc_map->lock, flags);
> @@ -435,16 +436,16 @@ out:
>  
>  /**
>   * ir_setkeytable() - sets several entries in the scancode->keycode table
> - * @dev:	the struct rc_dev device descriptor
> + * @kt:		the struct rc_keytable descriptor
>   * @to:		the struct rc_map to copy entries to
>   * @from:	the struct rc_map to copy entries from
>   * @return:	-ENOMEM if all keycodes could not be inserted, otherwise zero.
>   *
>   * This routine is used to handle table initialization.
>   */
> -int ir_setkeytable(struct rc_dev *dev, const struct rc_map *from)
> +int rc_setkeytable(struct rc_keytable *kt, const struct rc_map *from)
>  {
> -	struct rc_map *rc_map = &dev->rc_map;
> +	struct rc_map *rc_map = &kt->rc_map;
>  	struct rc_map_table entry;
>  	unsigned int i, index;
>  	int rc;
> @@ -463,13 +464,13 @@ int ir_setkeytable(struct rc_dev *dev, const struct rc_map *from)
>  			entry.scancode = from->scan[i].scancode;
>  
>  		entry.protocol = from->rc_type;
> -		index = ir_establish_scancode(dev, rc_map, &entry, false);
> +		index = ir_establish_scancode(kt, rc_map, &entry, false);
>  		if (index >= rc_map->len) {
>  			rc = -ENOMEM;
>  			break;
>  		}
>  
> -		ir_update_mapping(dev, rc_map, index, from->scan[i].keycode);
> +		ir_update_mapping(kt, rc_map, index, from->scan[i].keycode);
>  	}
>  
>  	if (rc)
> @@ -528,8 +529,9 @@ int ir_getkeycode(struct input_dev *idev,
>  		  struct input_keymap_entry *ke)
>  {
>  	struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
> -	struct rc_dev *rdev = input_get_drvdata(idev);
> -	struct rc_map *rc_map = &rdev->rc_map;
> +	struct rc_keytable *kt = input_get_drvdata(idev);
> +	struct rc_dev *rdev = kt->dev;
> +	struct rc_map *rc_map = &kt->rc_map;
>  	struct rc_map_table *entry;
>  	unsigned long flags;
>  	unsigned int index;
> @@ -616,7 +618,7 @@ out:
>  u32 rc_g_keycode_from_table(struct rc_dev *dev,
>  			    enum rc_type protocol, u64 scancode)
>  {
> -	struct rc_map *rc_map = &dev->rc_map;
> +	struct rc_map *rc_map = &dev->kt->rc_map;
>  	unsigned int keycode;
>  	unsigned int index;
>  	unsigned long flags;
> @@ -639,53 +641,51 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev,
>  EXPORT_SYMBOL_GPL(rc_g_keycode_from_table);
>  
>  /**
> - * ir_do_keyup() - internal function to signal the release of a keypress
> - * @dev:	the struct rc_dev descriptor of the device
> + * rc_do_keyup() - internal function to signal the release of a keypress
> + * @kt:		the keytable
>   * @sync:	whether or not to call input_sync
>   *
>   * This function is used internally to release a keypress, it must be
>   * called with keylock held.
>   */
> -static void ir_do_keyup(struct rc_dev *dev, bool sync)
> +static void rc_do_keyup(struct rc_keytable *kt, bool sync)
>  {
> -	if (!dev->keypressed)
> +	if (!kt->keypressed)
>  		return;
>  
> -	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
> -	input_report_key(dev->input_dev, dev->last_keycode, 0);
> +	IR_dprintk(1, "keyup key 0x%04x\n", kt->last_keycode);
> +	input_report_key(kt->idev, kt->last_keycode, 0);
>  	led_trigger_event(led_feedback, LED_OFF);
>  	if (sync)
> -		input_sync(dev->input_dev);
> -	dev->keypressed = false;
> +		input_sync(kt->idev);
> +	kt->keypressed = false;
>  }
>  
>  /**
> - * rc_keyup() - signals the release of a keypress
> - * @dev:	the struct rc_dev descriptor of the device
> + * rc_keytable_keyup() - signals the release of a keypress
> + * @kt:		the keytable
>   *
> - * This routine is used to signal that a key has been released on the
> - * remote control.
> + * This routine is used to generate input keyup events.
>   */
> -void rc_keyup(struct rc_dev *dev)
> +void rc_keytable_keyup(struct rc_keytable *kt)
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&dev->keylock, flags);
> -	ir_do_keyup(dev, true);
> -	spin_unlock_irqrestore(&dev->keylock, flags);
> +	spin_lock_irqsave(&kt->keylock, flags);
> +	rc_do_keyup(kt, true);
> +	spin_unlock_irqrestore(&kt->keylock, flags);
>  }
> -EXPORT_SYMBOL_GPL(rc_keyup);
>  
>  /**
>   * ir_timer_keyup() - generates a keyup event after a timeout
> - * @cookie:	a pointer to the struct rc_dev for the device
> + * @cookie:	a pointer to the struct rc_keytable
>   *
>   * This routine will generate a keyup event some time after a keydown event
>   * is generated when no further activity has been detected.
>   */
> -void ir_timer_keyup(unsigned long cookie)
> +static void rc_timer_keyup(unsigned long cookie)
>  {
> -	struct rc_dev *dev = (struct rc_dev *)cookie;
> +	struct rc_keytable *kt = (struct rc_keytable *)cookie;
>  	unsigned long flags;
>  
>  	/*
> @@ -698,154 +698,203 @@ void ir_timer_keyup(unsigned long cookie)
>  	 * to allow the input subsystem to do its auto-repeat magic or
>  	 * a keyup event might follow immediately after the keydown.
>  	 */
> -	spin_lock_irqsave(&dev->keylock, flags);
> -	if (time_is_before_eq_jiffies(dev->keyup_jiffies))
> -		ir_do_keyup(dev, true);
> -	spin_unlock_irqrestore(&dev->keylock, flags);
> +	spin_lock_irqsave(&kt->keylock, flags);
> +	if (time_is_before_eq_jiffies(kt->keyup_jiffies))
> +		rc_do_keyup(kt, true);
> +	spin_unlock_irqrestore(&kt->keylock, flags);
>  }
>  
>  /**
> - * rc_repeat() - signals that a key is still pressed
> - * @dev:	the struct rc_dev descriptor of the device
> + * rc_keytable_repeat() - signals that a key is still pressed
> + * @kt:		the keytable
>   *
>   * This routine is used by IR decoders when a repeat message which does
>   * not include the necessary bits to reproduce the scancode has been
>   * received.
>   */
> -void rc_repeat(struct rc_dev *dev)
> +void rc_keytable_repeat(struct rc_keytable *kt)
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&dev->keylock, flags);
> +	spin_lock_irqsave(&kt->keylock, flags);
>  
> -	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
> -	input_sync(dev->input_dev);
> -	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
> +	input_event(kt->idev, EV_MSC, MSC_SCAN, kt->last_scancode);
> +	input_sync(kt->idev);
>  
> -	if (!dev->keypressed)
> +	if (!kt->keypressed)
>  		goto out;
>  
> -	dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
> -	mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
> +	kt->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
> +	mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
>  
>  out:
> -	spin_unlock_irqrestore(&dev->keylock, flags);
> +	spin_unlock_irqrestore(&kt->keylock, flags);
>  }
> -EXPORT_SYMBOL_GPL(rc_repeat);
>  
>  /**
> - * ir_do_keydown() - internal function to process a keypress
> - * @dev:	the struct rc_dev descriptor of the device
> - * @protocol:	the protocol of the keypress
> - * @scancode:   the scancode of the keypress
> - * @keycode:    the keycode of the keypress
> - * @toggle:     the toggle value of the keypress
> + * rc_keytable_keydown() - generates input event for a key press
> + * @kt:		the struct rc_keytable descriptor of the keytable
> + * @protocol:	the protocol for the keypress
> + * @scancode:	the scancode for the keypress
> + * @toggle:	the toggle value (protocol dependent, if the protocol doesn't
> + *		support toggle values, this should be set to zero)
> + * @autoup:	should an automatic keyup event be generated in the future
>   *
> - * This function is used internally to register a keypress, it must be
> - * called with keylock held.
> + * This routine is used to signal that a keypress has been detected.
>   */
> -static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
> -			  u32 scancode, u32 keycode, u8 toggle)
> +void rc_keytable_keydown(struct rc_keytable *kt, enum rc_type protocol,
> +			 u32 scancode, u8 toggle, bool autoup)
>  {
> -	bool new_event = (!dev->keypressed		 ||
> -			  dev->last_protocol != protocol ||
> -			  dev->last_scancode != scancode ||
> -			  dev->last_toggle   != toggle);
> +	unsigned long flags;
> +	u32 keycode;
> +	bool new_event;
>  
> -	if (new_event && dev->keypressed)
> -		ir_do_keyup(dev, false);
> +	spin_lock_irqsave(&kt->keylock, flags);
>  
> -	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
> -	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
> -	/*
> -	 * NOTE: If we ever get > 32 bit scancodes, we need to break the
> -	 *	 scancode into 32 bit pieces and feed them to userspace
> -	 *	 as one or more RC_KEY_SCANCODE_PART events followed
> -	 *	 by a final RC_KEY_SCANCODE event.
> -	 */
> -	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
> -	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
> +	keycode = rc_g_keycode_from_table(kt->dev, protocol, scancode);
> +	new_event = (!kt->keypressed ||
> +		     kt->last_protocol != protocol ||
> +		     kt->last_scancode != scancode ||
> +		     kt->last_toggle != toggle);
> +
> +	if (new_event && kt->keypressed)
> +		rc_do_keyup(kt, false);
> +
> +	input_event(kt->idev, EV_MSC, MSC_SCAN, scancode);
>  
>  	if (new_event && keycode != KEY_RESERVED) {
>  		/* Register a keypress */
> -		dev->keypressed = true;
> -		dev->last_protocol = protocol;
> -		dev->last_scancode = scancode;
> -		dev->last_toggle = toggle;
> -		dev->last_keycode = keycode;
> +		kt->keypressed = true;
> +		kt->last_protocol = protocol;
> +		kt->last_scancode = scancode;
> +		kt->last_toggle = toggle;
> +		kt->last_keycode = keycode;
>  
>  		IR_dprintk(1, "%s: key down event, "
> -			   "key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
> -			   dev->input_name, keycode, protocol, scancode);
> -		input_report_key(dev->input_dev, keycode, 1);
> -
> -		led_trigger_event(led_feedback, LED_FULL);
> +			   "key 0x%04x, protocol 0x%04x, scancode 0x%08llx\n",
> +			   kt->dev->input_name, keycode, protocol,
> +			   (long long unsigned)scancode);
> +		input_report_key(kt->idev, keycode, 1);
>  	}
> +	input_sync(kt->idev);
>  
> -	input_sync(dev->input_dev);
> +	if (autoup && kt->keypressed) {
> +		kt->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
> +		mod_timer(&kt->timer_keyup, kt->keyup_jiffies);
> +	}
> +	spin_unlock_irqrestore(&kt->keylock, flags);
>  }
>  
> -/**
> - * rc_keydown() - generates input event for a key press
> - * @dev:	the struct rc_dev descriptor of the device
> - * @protocol:	the protocol for the keypress
> - * @scancode:	the scancode for the keypress
> - * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
> - *              support toggle values, this should be set to zero)
> - *
> - * This routine is used to signal that a key has been pressed on the
> - * remote control.
> - */
> -void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle)
> +static int rc_input_open(struct input_dev *idev)
>  {
> -	unsigned long flags;
> -	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
> +	struct rc_keytable *kt = input_get_drvdata(idev);
>  
> -	spin_lock_irqsave(&dev->keylock, flags);
> -	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
> +	return rc_open(kt->dev);
> +}
>  
> -	if (dev->keypressed) {
> -		dev->keyup_jiffies = jiffies + msecs_to_jiffies(IR_KEYPRESS_TIMEOUT);
> -		mod_timer(&dev->timer_keyup, dev->keyup_jiffies);
> -	}
> -	spin_unlock_irqrestore(&dev->keylock, flags);
> +static void rc_input_close(struct input_dev *idev)
> +{
> +	struct rc_keytable *kt = input_get_drvdata(idev);
> +
> +	rc_close(kt->dev);
>  }
> -EXPORT_SYMBOL_GPL(rc_keydown);
>  
>  /**
> - * rc_keydown_notimeout() - generates input event for a key press without
> - *                          an automatic keyup event at a later time
> - * @dev:	the struct rc_dev descriptor of the device
> - * @protocol:	the protocol for the keypress
> - * @scancode:	the scancode for the keypress
> - * @toggle:     the toggle value (protocol dependent, if the protocol doesn't
> - *              support toggle values, this should be set to zero)
> + * rc_keytable_add() - adds a new keytable
> + * @dev:	the struct rc_dev device this keytable should belong to
> + * @rc_map:	the keymap to use for the new keytable
> + * @return:	zero on success or a negative error code
>   *
> - * This routine is used to signal that a key has been pressed on the
> - * remote control. The driver must manually call rc_keyup() at a later stage.
> + * This function add a new keytable (essentially the combination of a keytable
> + * and an input device along with some state (whether a key is currently
> + * pressed or not, etc).
>   */
> -void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
> -			  u32 scancode, u8 toggle)
> +int rc_keytable_add(struct rc_dev *dev, struct rc_map *rc_map)
>  {
> -	unsigned long flags;
> -	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
> +	struct rc_keytable *kt;
> +	struct input_dev *idev = NULL;
> +	int err;
>  
> -	spin_lock_irqsave(&dev->keylock, flags);
> -	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
> -	spin_unlock_irqrestore(&dev->keylock, flags);
> -}
> -EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
> +	kt = kzalloc(sizeof(*kt), GFP_KERNEL);
> +	if (!kt) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
>  
> -int rc_input_open(struct input_dev *idev)
> -{
> -	struct rc_dev *rdev = input_get_drvdata(idev);
> +	idev = input_allocate_device();
> +	if (!idev) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	kt->idev = idev;
> +	kt->dev = dev;
> +	spin_lock_init(&kt->keylock);
> +	spin_lock_init(&kt->rc_map.lock);
> +	idev->getkeycode = ir_getkeycode;
> +	idev->setkeycode = ir_setkeycode;
> +	idev->open = rc_input_open;
> +	idev->close = rc_input_close;
> +	set_bit(EV_KEY, idev->evbit);
> +	set_bit(EV_REP, idev->evbit);
> +	set_bit(EV_MSC, idev->evbit);
> +	set_bit(MSC_SCAN, idev->mscbit);
> +	input_set_drvdata(idev, kt);
> +	setup_timer(&kt->timer_keyup, rc_timer_keyup, (unsigned long)kt);
> +
> +	err = rc_setkeytable(kt, rc_map);
> +	if (err)
> +		goto out;
> +
> +	idev->dev.parent = &dev->dev;
> +	memcpy(&idev->id, &dev->input_id, sizeof(dev->input_id));
> +	idev->phys = dev->input_phys;
> +	idev->name = dev->input_name;
>  
> -	return rc_open(rdev);
> +	err = input_register_device(idev);
> +	if (err)
> +		goto out;
> +
> +	/*
> +	 * Default delay of 250ms is too short for some protocols, especially
> +	 * since the timeout is currently set to 250ms. Increase it to 500ms,
> +	 * to avoid wrong repetition of the keycodes. Note that this must be
> +	 * set after the call to input_register_device().
> +	 */
> +	idev->rep[REP_DELAY] = 500;
> +
> +	/*
> +	 * As a repeat event on protocols like RC-5 and NEC take as long as
> +	 * 110/114ms, using 33ms as a repeat period is not the right thing
> +	 * to do.
> +	 */
> +	idev->rep[REP_PERIOD] = 125;
> +
> +	dev->kt = kt;
> +	return 0;
> +
> +out:
> +	ir_free_table(&kt->rc_map);
> +	input_free_device(idev);
> +	kfree(kt);
> +	return err;
>  }
>  
> -void rc_input_close(struct input_dev *idev)
> +/**
> + * rc_keytable_del() - unregisters and deletes a keytable
> + * @dev:       the struct rc_dev device with the keytable
> + *
> + * This function unregisters and deletes an existing keytable.
> + */
> +void rc_keytable_del(struct rc_dev *dev)
>  {
> -	struct rc_dev *rdev = input_get_drvdata(idev);
> -	rc_close(rdev);
> +	if (!dev->kt)
> +		return;
> +
> +	del_timer_sync(&dev->kt->timer_keyup);
> +	ir_free_table(&dev->kt->rc_map);
> +	input_unregister_device(dev->kt->idev);
> +	kfree(dev->kt);
> +	dev->kt = NULL;
>  }
>  
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index a01fce2..23a6701 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -136,6 +136,54 @@ void rc_close(struct rc_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(rc_close);
>  
> +/**
> + * rc_do_keydown() - report a key press event
> + * @dev:	the struct rc_dev descriptor of the device
> + * @protocol:	the protocol for the keypress
> + * @scancode:	the scancode for the keypress
> + * @toggle:	the toggle value (protocol dependent, if the protocol doesn't
> + *		support toggle values, this should be set to zero)
> + * @autoup:	whether to automatically generate a keyup event later
> + *
> + * Report that a keypress has been received.
> + */
> +void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
> +		   u32 scancode, u8 toggle, bool autoup)
> +{
> +	led_trigger_event(led_feedback, LED_FULL);
> +	rc_keytable_keydown(dev->kt, protocol, scancode, toggle, autoup);
> +	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
> +	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
> +	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
> +}
> +EXPORT_SYMBOL_GPL(rc_do_keydown);
> +
> +/**
> + * rc_keyup() - signals the release of a keypress
> + * @dev:       the struct rc_dev descriptor of the device
> + *
> + * Report that a key is no longer pressed.
> + */
> +void rc_keyup(struct rc_dev *dev)
> +{
> +	rc_keytable_keyup(dev->kt);
> +}
> +EXPORT_SYMBOL_GPL(rc_keyup);
> +
> +/**
> + * rc_repeat() - report that a key is still pressed
> + * @dev:	the struct rc_dev descriptor of the device
> + *
> + * Report that a repeat message (which does not include the necessary bits to
> + * reproduce the scancode) has been received.
> + */
> +void rc_repeat(struct rc_dev *dev)
> +{
> +	rc_keytable_repeat(dev->kt);
> +	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
> +}
> +EXPORT_SYMBOL_GPL(rc_repeat);
> +
>  /* class for /sys/class/rc */
>  static char *rc_devnode(struct device *dev, umode_t *mode)
>  {
> @@ -214,8 +262,8 @@ struct rc_filter_attribute {
>   * It returns the protocol names of supported protocols.
>   * Enabled protocols are printed in brackets.
>   *
> - * dev->lock is taken to guard against races between device
> - * registration, store_protocols and show_protocols.
> + * dev->lock is taken to guard against races between store_protocols and
> + * show_protocols.
>   */
>  static ssize_t show_protocols(struct device *device,
>  			      struct device_attribute *mattr, char *buf)
> @@ -344,8 +392,8 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
>   * See parse_protocol_change() for the valid commands.
>   * Returns @len on success or a negative error code.
>   *
> - * dev->lock is taken to guard against races between device
> - * registration, store_protocols and show_protocols.
> + * dev->lock is taken to guard against races between store_protocols and
> + * show_protocols.
>   */
>  static ssize_t store_protocols(struct device *device,
>  			       struct device_attribute *mattr,
> @@ -445,8 +493,8 @@ out:
>   * Bits of the filter value corresponding to set bits in the filter mask are
>   * compared against input scancodes and non-matching scancodes are discarded.
>   *
> - * dev->lock is taken to guard against races between device registration,
> - * store_filter and show_filter.
> + * dev->lock is taken to guard against races between store_filter and
> + * show_filter.
>   */
>  static ssize_t show_filter(struct device *device,
>  			   struct device_attribute *attr,
> @@ -492,8 +540,8 @@ static ssize_t show_filter(struct device *device,
>   * Bits of the filter value corresponding to set bits in the filter mask are
>   * compared against input scancodes and non-matching scancodes are discarded.
>   *
> - * dev->lock is taken to guard against races between device registration,
> - * store_filter and show_filter.
> + * dev->lock is taken to guard against races between store_filter and
> + * show_filter.
>   */
>  static ssize_t store_filter(struct device *device,
>  			    struct device_attribute *attr,
> @@ -964,8 +1012,8 @@ static void rc_dev_release(struct device *device)
>  {
>  	struct rc_dev *dev = to_rc_dev(device);
>  
> -	if (dev->input_dev)
> -		input_free_device(dev->input_dev);
> +	if (dev->driver_type == RC_DRIVER_IR_RAW)
> +		ir_raw_event_unregister(dev);
>  
>  	kfifo_free(&dev->txfifo);
>  	kfree(dev);
> @@ -983,11 +1031,8 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
>  {
>  	struct rc_dev *dev = to_rc_dev(device);
>  
> -	if (!dev || !dev->input_dev)
> -		return -ENODEV;
> -
> -	if (dev->rc_map.name)
> -		ADD_HOTPLUG_VAR("NAME=%s", dev->rc_map.name);
> +	if (dev->map_name)
> +		ADD_HOTPLUG_VAR("NAME=%s", dev->map_name);
>  	if (dev->driver_name)
>  		ADD_HOTPLUG_VAR("DRV_NAME=%s", dev->driver_name);
>  
> @@ -1061,25 +1106,12 @@ struct rc_dev *rc_allocate_device(void)
>  	if (!dev)
>  		return NULL;
>  
> -	dev->input_dev = input_allocate_device();
> -	if (!dev->input_dev) {
> -		kfree(dev);
> -		return NULL;
> -	}
> -
> -	dev->input_dev->getkeycode = ir_getkeycode;
> -	dev->input_dev->setkeycode = ir_setkeycode;
> -	input_set_drvdata(dev->input_dev, dev);
> -
>  	INIT_LIST_HEAD(&dev->client_list);
>  	spin_lock_init(&dev->client_lock);
>  	mutex_init(&dev->txmutex);
>  	init_waitqueue_head(&dev->txwait);
>  	init_waitqueue_head(&dev->rxwait);
> -	spin_lock_init(&dev->rc_map.lock);
> -	spin_lock_init(&dev->keylock);
>  	mutex_init(&dev->lock);
> -	setup_timer(&dev->timer_keyup, ir_timer_keyup, (unsigned long)dev);
>  
>  	dev->dev.type = &rc_dev_type;
>  	dev->dev.class = &rc_class;
> @@ -1112,28 +1144,14 @@ EXPORT_SYMBOL_GPL(rc_free_device);
>  int rc_register_device(struct rc_dev *dev)
>  {
>  	static bool raw_init = false; /* raw decoders loaded? */
> -	struct rc_map *rc_map;
> -	const char *path;
> +	struct rc_map *rc_map = NULL;
>  	int attr = 0;
>  	int minor;
>  	int rc;
>  
> -	if (!dev || !dev->map_name)
> -		return -EINVAL;
> -
> -	rc_map = rc_map_get(dev->map_name);
> -	if (!rc_map)
> -		rc_map = rc_map_get(RC_MAP_EMPTY);
> -	if (!rc_map || !rc_map->scan || rc_map->size == 0)
> +	if (!dev)
>  		return -EINVAL;
>  
> -	set_bit(EV_KEY, dev->input_dev->evbit);
> -	set_bit(EV_REP, dev->input_dev->evbit);
> -	set_bit(EV_MSC, dev->input_dev->evbit);
> -	set_bit(MSC_SCAN, dev->input_dev->mscbit);
> -	dev->input_dev->open = rc_input_open;
> -	dev->input_dev->close = rc_input_close;
> -
>  	minor = ida_simple_get(&rc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
>  	if (minor < 0)
>  		return minor;
> @@ -1148,6 +1166,18 @@ int rc_register_device(struct rc_dev *dev)
>  			goto out_minor;
>  	}
>  
> +	if (dev->driver_type == RC_DRIVER_IR_RAW) {
> +		/* Load raw decoders, if they aren't already */
> +		if (!raw_init) {
> +			IR_dprintk(1, "Loading raw decoders\n");
> +			ir_raw_init();
> +			raw_init = true;
> +		}
> +		rc = ir_raw_event_register(dev);
> +		if (rc < 0)
> +			goto out_minor;
> +	}
> +
>  	dev->dev.groups = dev->sysfs_groups;
>  	dev->sysfs_groups[attr++] = &rc_dev_protocol_attr_grp;
>  	if (dev->s_filter)
> @@ -1158,73 +1188,15 @@ int rc_register_device(struct rc_dev *dev)
>  		dev->sysfs_groups[attr++] = &rc_dev_wakeup_protocol_attr_grp;
>  	dev->sysfs_groups[attr++] = NULL;
>  
> -	/*
> -	 * Take the lock here, as the device sysfs node will appear
> -	 * when device_add() is called, which may trigger an ir-keytable udev
> -	 * rule, which will in turn call show_protocols and access
> -	 * dev->enabled_protocols before it has been initialized.
> -	 */
> -	mutex_lock(&dev->lock);
> -
> -	rc = cdev_add(&dev->cdev, dev->dev.devt, 1);
> -	if (rc)
> -		goto out_unlock;
> -
> -	rc = device_add(&dev->dev);
> -	if (rc)
> -		goto out_cdev;
> -
> -	rc = ir_setkeytable(dev, rc_map);
> -	if (rc)
> -		goto out_dev;
> -
> -	dev->input_dev->dev.parent = &dev->dev;
> -	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
> -	dev->input_dev->phys = dev->input_phys;
> -	dev->input_dev->name = dev->input_name;
> -
> -	/* input_register_device can call ir_open, so unlock mutex here */
> -	mutex_unlock(&dev->lock);
> -
> -	rc = input_register_device(dev->input_dev);
> -
> -	mutex_lock(&dev->lock);
> -
> -	if (rc)
> -		goto out_table;
> +	if (dev->map_name)
> +		rc_map = rc_map_get(dev->map_name);
>  
> -	/*
> -	 * Default delay of 250ms is too short for some protocols, especially
> -	 * since the timeout is currently set to 250ms. Increase it to 500ms,
> -	 * to avoid wrong repetition of the keycodes. Note that this must be
> -	 * set after the call to input_register_device().
> -	 */
> -	dev->input_dev->rep[REP_DELAY] = 500;
> -
> -	/*
> -	 * As a repeat event on protocols like RC-5 and NEC take as long as
> -	 * 110/114ms, using 33ms as a repeat period is not the right thing
> -	 * to do.
> -	 */
> -	dev->input_dev->rep[REP_PERIOD] = 125;
> -
> -	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
> -	printk(KERN_INFO "%s: %s as %s\n",
> -		dev_name(&dev->dev),
> -		dev->input_name ? dev->input_name : "Unspecified device",
> -		path ? path : "N/A");
> -	kfree(path);
> +	if (!rc_map)
> +		rc_map = rc_map_get(RC_MAP_EMPTY);
>  
> -	if (dev->driver_type == RC_DRIVER_IR_RAW) {
> -		/* Load raw decoders, if they aren't already */
> -		if (!raw_init) {
> -			IR_dprintk(1, "Loading raw decoders\n");
> -			ir_raw_init();
> -			raw_init = true;
> -		}
> -		rc = ir_raw_event_register(dev);
> -		if (rc < 0)
> -			goto out_input;
> +	if (!rc_map || !rc_map->scan || rc_map->size == 0) {
> +		rc = -EFAULT;
> +		goto out_raw;
>  	}
>  
>  	if (dev->change_protocol && rc_map->len > 0) {
> @@ -1234,31 +1206,34 @@ int rc_register_device(struct rc_dev *dev)
>  			goto out_raw;
>  		dev->enabled_protocols = rc_type;
>  	}
> +	
> +	rc = cdev_add(&dev->cdev, dev->dev.devt, 1);
> +	if (rc)
> +		goto out_raw;
>  
> -	mutex_unlock(&dev->lock);
> +	rc = device_add(&dev->dev);
> +	if (rc)
> +		goto out_cdev;
> +
> +	rc = rc_keytable_add(dev, rc_map);
> +	if (rc)
> +		goto out_dev;
>  
>  	IR_dprintk(1, "Registered %s (driver: %s, remote: %s, mode %s)\n",
>  		   dev_name(&dev->dev),
>  		   dev->driver_name ? dev->driver_name : "unknown",
> -		   rc_map->name ? rc_map->name : "unknown",
> +		   dev->map_name ? dev->map_name : "unknown",
>  		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
>  
>  	return 0;
>  
> -out_raw:
> -	if (dev->driver_type == RC_DRIVER_IR_RAW)
> -		ir_raw_event_unregister(dev);
> -out_input:
> -	input_unregister_device(dev->input_dev);
> -	dev->input_dev = NULL;
> -out_table:
> -	ir_free_table(&dev->rc_map);
>  out_dev:
>  	device_del(&dev->dev);
>  out_cdev:
>  	cdev_del(&dev->cdev);
> -out_unlock:
> -	mutex_unlock(&dev->lock);
> +out_raw:
> +	if (dev->driver_type == RC_DRIVER_IR_RAW)
> +		ir_raw_event_unregister(dev);
>  out_minor:
>  	ida_simple_remove(&rc_ida, minor);
>  	return rc;
> @@ -1285,15 +1260,10 @@ void rc_unregister_device(struct rc_dev *dev)
>  
>  	cdev_del(&dev->cdev);
>  
> -	del_timer_sync(&dev->timer_keyup);
> -
>  	if (dev->driver_type == RC_DRIVER_IR_RAW)
>  		ir_raw_event_unregister(dev);
>  
> -	ir_free_table(&dev->rc_map);
> -
> -	input_unregister_device(dev->input_dev);
> -	dev->input_dev = NULL;
> +	rc_keytable_del(dev);
>  
>  	/* dev is marked as dead so no one changes dev->users */
>  	if (dev->users && dev->close)
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index eacb735..e64d47c 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -249,7 +249,7 @@ enum rc_filter_type {
>   * @input_id: id of the input child device (struct input_id)
>   * @driver_name: name of the hardware driver which registered this device
>   * @map_name: name of the default keymap
> - * @rc_map: current scan/key table
> + * @rc_kt: current rc_keytable
>   * @lock: used to ensure we've filled in all protocol details before
>   *	anyone can call show_protocols or store_protocols
>   * @dead: used to determine if the device is still alive
> @@ -260,7 +260,6 @@ enum rc_filter_type {
>   * @txwait: waitqueue for processes waiting to write data to the txfifo
>   * @rxwait: waitqueue for processes waiting for data to read
>   * @raw: additional data for raw pulse/space devices
> - * @input_dev: the input child device used to communicate events to userspace
>   * @driver_type: specifies if protocol decoding is done in hardware or software
>   * @idle: used to keep track of RX state
>   * @allowed_protocols: bitmask with the supported RC_BIT_* protocols
> @@ -276,14 +275,6 @@ enum rc_filter_type {
>   *	leave this field in blank
>   * @users: number of current users of the device
>   * @priv: driver-specific data
> - * @keylock: protects the remaining members of the struct
> - * @keypressed: whether a key is currently pressed
> - * @keyup_jiffies: time (in jiffies) when the current keypress should be released
> - * @timer_keyup: timer for releasing a keypress
> - * @last_keycode: keycode of last keypress
> - * @last_protocol: protocol of last keypress
> - * @last_scancode: scancode of last keypress
> - * @last_toggle: toggle value of last command
>   * @timeout: optional time after which device stops sending data
>   * @min_timeout: minimum timeout supported by device
>   * @max_timeout: maximum timeout supported by device
> @@ -321,7 +312,7 @@ struct rc_dev {
>  	struct input_id			input_id;
>  	char				*driver_name;
>  	const char			*map_name;
> -	struct rc_map			rc_map;
> +	struct rc_keytable		*kt;
>  	struct mutex			lock;
>  	bool				dead;
>  	struct list_head		client_list;
> @@ -331,7 +322,6 @@ struct rc_dev {
>  	wait_queue_head_t		txwait;
>  	wait_queue_head_t		rxwait;
>  	struct ir_raw_event_ctrl	*raw;
> -	struct input_dev		*input_dev;
>  	enum rc_driver_type		driver_type;
>  	bool				idle;
>  	u64				allowed_protocols;
> @@ -343,14 +333,6 @@ struct rc_dev {
>  	u32				scancode_mask;
>  	u32				users;
>  	void				*priv;
> -	spinlock_t			keylock;
> -	bool				keypressed;
> -	unsigned long			keyup_jiffies;
> -	struct timer_list		timer_keyup;
> -	u32				last_keycode;
> -	enum rc_type			last_protocol;
> -	u32				last_scancode;
> -	u8				last_toggle;
>  	u32				timeout;
>  	u32				min_timeout;
>  	u32				max_timeout;
> @@ -378,6 +360,34 @@ struct rc_dev {
>  	int				(*set_ir_tx)(struct rc_dev *dev, struct rc_ir_tx *tx);
>  };
>  
> +/**
> + * struct rc_keytable - represents one keytable for a rc_dev device
> + * @dev:		the rc_dev device this keytable belongs to
> + * @idev:		the input_dev device which belongs to this keytable
> + * @rc_map:		holds the scancode <-> keycode mappings
> + * @keypressed:		whether a key is currently pressed or not
> + * @keyup_jiffies:	when the key should be auto-released
> + * @timer_keyup:	responsible for the auto-release of keys
> + * @keylock:		protects the key state
> + * @last_keycode:	keycode of the last keypress
> + * @last_protocol:	protocol of the last keypress
> + * @last_scancode:	scancode of the last keypress
> + * @last_toggle:	toggle of the last keypress
> + */
> +struct rc_keytable {
> +	struct rc_dev			*dev;
> +	struct input_dev		*idev;
> +	struct rc_map			rc_map;
> +	bool				keypressed;
> +	unsigned long			keyup_jiffies;
> +	struct timer_list		timer_keyup;
> +	spinlock_t			keylock;
> +	u32				last_keycode;
> +	enum rc_type			last_protocol;
> +	u32				last_scancode;
> +	u8				last_toggle;
> +};
> +
>  #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
>  
>  /*
> @@ -397,11 +407,19 @@ int rc_open(struct rc_dev *rdev);
>  void rc_close(struct rc_dev *rdev);
>  
>  void rc_repeat(struct rc_dev *dev);
> -void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
> -void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
> +void rc_do_keydown(struct rc_dev *dev, enum rc_type protocol,
> +		   u32 scancode, u8 toggle, bool autoup);
>  void rc_keyup(struct rc_dev *dev);
>  u32 rc_g_keycode_from_table(struct rc_dev *dev, enum rc_type protocol, u64 scancode);
>  
> +static inline void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle) {
> +	rc_do_keydown(dev, protocol, scancode, toggle, true);
> +}
> +
> +static inline void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle) {
> +	rc_do_keydown(dev, protocol, scancode, toggle, false);
> +}
> +
>  /*
>   * From rc-raw.c
>   * The Raw interface is specific to InfraRed. It may be a good idea to
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
