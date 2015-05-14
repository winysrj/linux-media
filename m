Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36619 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422699AbbENVF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 17:05:58 -0400
Date: Thu, 14 May 2015 18:05:48 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] rc-core: don't throw away protocol information
Message-ID: <20150514180548.22702e56@recife.lan>
In-Reply-To: <20150406112313.23209.8412.stgit@zeus.muc.hardeman.nu>
References: <20150406112204.23209.27664.stgit@zeus.muc.hardeman.nu>
	<20150406112313.23209.8412.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 06 Apr 2015 13:23:13 +0200
David Härdeman <david@hardeman.nu> escreveu:

> It is currently impossible to distinguish between scancodes which have
> been generated using different protocols (and scancodes can, and will,
> overlap).
> 
> For example:
> RC5 message to address 0x00, command 0x03 has scancode 0x00000503
> JVC message to address 0x00, command 0x03 has scancode 0x00000503
> 
> It is only possible to distinguish (and parse) scancodes by known the
> scancode *and* the protocol.
> 
> Setting and getting keycodes in the input subsystem used to be done via
> the EVIOC[GS]KEYCODE ioctl and "unsigned int[2]" (one int for scancode
> and one for the keycode).
> 
> The interface has now been extended to use the EVIOC[GS]KEYCODE_V2 ioctl
> which uses the following struct:
> 
> struct input_keymap_entry {
> 	__u8  flags;
> 	__u8  len;
> 	__u16 index;
> 	__u32 keycode;
> 	__u8  scancode[32];
> };
> 
> (scancode can of course be even bigger, thanks to the len member).
> 
> This patch changes how the "input_keymap_entry" struct is interpreted
> by rc-core by casting it to "rc_keymap_entry":
> 
> struct rc_scancode {
> 	__u16 protocol;
> 	__u16 reserved[3];
> 	__u64 scancode;
> }
> 
> struct rc_keymap_entry {
> 	__u8  flags;
> 	__u8  len;
> 	__u16 index;
> 	__u32 keycode;
> 	union {
> 		struct rc_scancode rc;
> 		__u8 raw[32];
> 	};
> };
> 
> The u64 scancode member is large enough for all current protocols and it
> would be possible to extend it in the future should it be necessary for
> some exotic protocol.
> 
> The main advantage with this change is that the protocol is made explicit,
> which means that we're not throwing away data (the protocol type).
> 
> This also means that struct rc_map no longer hardcodes the protocol, meaning
> that keytables with mixed entries are possible.
> 
> Heuristics are also added to hopefully do the right thing with older
> ioctls in order to preserve backwards compatibility.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/ati_remote.c |    1 
>  drivers/media/rc/imon.c       |    7 +
>  drivers/media/rc/rc-main.c    |  196 +++++++++++++++++++++++++++++------------
>  include/media/rc-core.h       |   26 +++++
>  include/media/rc-map.h        |    7 +
>  5 files changed, 172 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
> index a356318..a1df608 100644
> --- a/drivers/media/rc/ati_remote.c
> +++ b/drivers/media/rc/ati_remote.c
> @@ -544,6 +544,7 @@ static void ati_remote_input_report(struct urb *urb)
>  		 * set, assume this is a scrollwheel up/down event.
>  		 */
>  		wheel_keycode = rc_g_keycode_from_table(ati_remote->rdev,
> +							RC_TYPE_OTHER,
>  							scancode & 0x78);
>  
>  		if (wheel_keycode == KEY_RESERVED) {
> diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
> index 65f80b8..ec4414a 100644
> --- a/drivers/media/rc/imon.c
> +++ b/drivers/media/rc/imon.c
> @@ -1263,14 +1263,15 @@ static u32 imon_remote_key_lookup(struct imon_context *ictx, u32 scancode)
>  	bool is_release_code = false;
>  
>  	/* Look for the initial press of a button */
> -	keycode = rc_g_keycode_from_table(ictx->rdev, scancode);
> +	keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type, scancode);
>  	ictx->rc_toggle = 0x0;
>  	ictx->rc_scancode = scancode;
>  
>  	/* Look for the release of a button */
>  	if (keycode == KEY_RESERVED) {
>  		release = scancode & ~0x4000;
> -		keycode = rc_g_keycode_from_table(ictx->rdev, release);
> +		keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type,
> +						  release);
>  		if (keycode != KEY_RESERVED)
>  			is_release_code = true;
>  	}
> @@ -1299,7 +1300,7 @@ static u32 imon_mce_key_lookup(struct imon_context *ictx, u32 scancode)
>  		scancode = scancode | MCE_KEY_MASK | MCE_TOGGLE_BIT;
>  
>  	ictx->rc_scancode = scancode;
> -	keycode = rc_g_keycode_from_table(ictx->rdev, scancode);
> +	keycode = rc_g_keycode_from_table(ictx->rdev, ictx->rc_type, scancode);
>  
>  	/* not used in mce mode, but make sure we know its false */
>  	ictx->release_code = false;
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 3379379..52b792d 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -103,7 +103,7 @@ EXPORT_SYMBOL_GPL(rc_map_unregister);
>  
>  
>  static struct rc_map_table empty[] = {
> -	{ 0x2a, KEY_COFFEE },
> +	{ RC_TYPE_OTHER, 0x2a, KEY_COFFEE },
>  };
>  
>  static struct rc_map_list empty_map = {
> @@ -119,7 +119,6 @@ static struct rc_map_list empty_map = {
>   * ir_create_table() - initializes a scancode table
>   * @rc_map:	the rc_map to initialize
>   * @name:	name to assign to the table
> - * @rc_type:	ir type to assign to the new table
>   * @size:	initial size of the table
>   * @return:	zero on success or a negative error code
>   *
> @@ -127,10 +126,9 @@ static struct rc_map_list empty_map = {
>   * memory to hold at least the specified number of elements.
>   */
>  static int ir_create_table(struct rc_map *rc_map,
> -			   const char *name, u64 rc_type, size_t size)
> +			   const char *name, size_t size)
>  {
>  	rc_map->name = name;
> -	rc_map->rc_type = rc_type;
>  	rc_map->alloc = roundup_pow_of_two(size * sizeof(struct rc_map_table));
>  	rc_map->size = rc_map->alloc / sizeof(struct rc_map_table);
>  	rc_map->scan = kmalloc(rc_map->alloc, GFP_KERNEL);
> @@ -225,16 +223,20 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
>  
>  	/* Did the user wish to remove the mapping? */
>  	if (new_keycode == KEY_RESERVED || new_keycode == KEY_UNKNOWN) {
> -		IR_dprintk(1, "#%d: Deleting scan 0x%04x\n",
> -			   index, rc_map->scan[index].scancode);
> +		IR_dprintk(1, "#%d: Deleting proto 0x%04x, scan 0x%08llx\n",
> +			   index, rc_map->scan[index].protocol,
> +			   (unsigned long long)rc_map->scan[index].scancode);
>  		rc_map->len--;
>  		memmove(&rc_map->scan[index], &rc_map->scan[index+ 1],
>  			(rc_map->len - index) * sizeof(struct rc_map_table));
>  	} else {
> -		IR_dprintk(1, "#%d: %s scan 0x%04x with key 0x%04x\n",
> +		IR_dprintk(1, "#%d: %s proto 0x%04x, scan 0x%08llx "
> +			   "with key 0x%04x\n",
>  			   index,
>  			   old_keycode == KEY_RESERVED ? "New" : "Replacing",
> -			   rc_map->scan[index].scancode, new_keycode);
> +			   rc_map->scan[index].protocol,
> +			   (unsigned long long)rc_map->scan[index].scancode,
> +			   new_keycode);
>  		rc_map->scan[index].keycode = new_keycode;
>  		__set_bit(new_keycode, dev->input_dev->keybit);
>  	}
> @@ -261,9 +263,9 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
>   * ir_establish_scancode() - set a keycode in the scancode->keycode table
>   * @dev:	the struct rc_dev device descriptor
>   * @rc_map:	scancode table to be searched
> - * @scancode:	the desired scancode
> - * @resize:	controls whether we allowed to resize the table to
> - *		accommodate not yet present scancodes
> + * @entry:	the entry to be added to the table
> + * @resize:	controls whether we are allowed to resize the table to
> + *		accomodate not yet present scancodes
>   * @return:	index of the mapping containing scancode in question
>   *		or -1U in case of failure.
>   *
> @@ -273,7 +275,7 @@ static unsigned int ir_update_mapping(struct rc_dev *dev,
>   */
>  static unsigned int ir_establish_scancode(struct rc_dev *dev,
>  					  struct rc_map *rc_map,
> -					  unsigned int scancode,
> +					  struct rc_map_table *entry,
>  					  bool resize)
>  {
>  	unsigned int i;
> @@ -287,16 +289,27 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
>  	 * indicate the valid bits of the scancodes.
>  	 */
>  	if (dev->scancode_mask)
> -		scancode &= dev->scancode_mask;
> +		entry->scancode &= dev->scancode_mask;
>  
> -	/* First check if we already have a mapping for this ir command */
> +	/*
> +	 * First check if we already have a mapping for this command.
> +	 * Note that the keytable is sorted first on protocol and second
> +	 * on scancode (lowest to highest).
> +	 */
>  	for (i = 0; i < rc_map->len; i++) {
> -		if (rc_map->scan[i].scancode == scancode)
> -			return i;
> +		if (rc_map->scan[i].protocol < entry->protocol)
> +			continue;
> +
> +		if (rc_map->scan[i].protocol > entry->protocol)
> +			break;
> +
> +		if (rc_map->scan[i].scancode < entry->scancode)
> +			continue;

Perhaps because I'm too tired after spending the entire day reviewing
patches, but I didn't understand well the algo you're trying to do
here.

The most important thing: would this be backward-compatible when
multiple protocols are enabled and the user is using the legacy
struct to set a keycode?

I guess not, because I'm not seeing any special check for such
case.

So, could you better explain (using some comments at this code), how
do you expect it to work, especially with legacy calls and multiple
enabled protocols whose tables are set from userspace?

>  
> -		/* Keytable is sorted from lowest to highest scancode */
> -		if (rc_map->scan[i].scancode >= scancode)
> +		if (rc_map->scan[i].scancode > entry->scancode)
>  			break;
> +
> +		return i;
>  	}
>  
>  	/* No previous mapping found, we might need to grow the table */
> @@ -309,7 +322,8 @@ static unsigned int ir_establish_scancode(struct rc_dev *dev,
>  	if (i < rc_map->len)
>  		memmove(&rc_map->scan[i + 1], &rc_map->scan[i],
>  			(rc_map->len - i) * sizeof(struct rc_map_table));
> -	rc_map->scan[i].scancode = scancode;
> +	rc_map->scan[i].scancode = entry->scancode;
> +	rc_map->scan[i].protocol = entry->protocol;
>  	rc_map->scan[i].keycode = KEY_RESERVED;
>  	rc_map->len++;
>  
> @@ -331,8 +345,10 @@ static inline enum rc_type guess_protocol(struct rc_dev *rdev)
>  		return rc_bitmap_to_type(rdev->enabled_protocols);
>  	else if (hweight64(rdev->allowed_protocols) == 1)
>  		return rc_bitmap_to_type(rdev->allowed_protocols);
> +	else if (rc_map->len > 0)
> +		return rc_map->scan[0].protocol;
>  	else
> -		return rc_map->rc_type;
> +		return RC_TYPE_OTHER;
>  }
>  
>  /**
> @@ -375,10 +391,12 @@ static int ir_setkeycode(struct input_dev *idev,
>  	struct rc_dev *rdev = input_get_drvdata(idev);
>  	struct rc_map *rc_map = &rdev->rc_map;
>  	unsigned int index;
> -	unsigned int scancode;
> +	struct rc_map_table entry;
>  	int retval = 0;
>  	unsigned long flags;
>  
> +	entry.keycode = ke->keycode;
> +
>  	spin_lock_irqsave(&rc_map->lock, flags);
>  
>  	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
> @@ -387,19 +405,42 @@ static int ir_setkeycode(struct input_dev *idev,
>  			retval = -EINVAL;
>  			goto out;
>  		}
> -	} else {
> +	} else if (ke->len == sizeof(int)) {
> +		/* Old EVIOCSKEYCODE[_V2] ioctl */
> +		u32 scancode;
>  		retval = input_scancode_to_scalar(ke, &scancode);
>  		if (retval)
>  			goto out;
>  
> -		if (guess_protocol(rdev) == RC_TYPE_NEC)
> -			scancode = to_nec32(scancode);
> +		entry.scancode = scancode;
> +		entry.protocol = guess_protocol(rdev);
> +		if (entry.protocol == RC_TYPE_NEC)
> +			entry.scancode = to_nec32(scancode);
>  
> -		index = ir_establish_scancode(rdev, rc_map, scancode, true);
> +		index = ir_establish_scancode(rdev, rc_map, &entry, true);
>  		if (index >= rc_map->len) {
>  			retval = -ENOMEM;
>  			goto out;
>  		}
> +	} else if (ke->len == sizeof(struct rc_scancode)) {
> +		/* New EVIOCSKEYCODE_V2 ioctl */
> +		const struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
> +		entry.protocol = rke->rc.protocol;
> +		entry.scancode = rke->rc.scancode;
> +
> +		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[2]) {
> +			retval = -EINVAL;
> +			goto out;
> +		}
> +
> +		index = ir_establish_scancode(rdev, rc_map, &entry, true);
> +		if (index >= rc_map->len) {
> +			retval = -ENOMEM;
> +			goto out;
> +		}
> +	} else {
> +		retval = -EINVAL;
> +		goto out;
>  	}
>  
>  	*old_keycode = ir_update_mapping(rdev, rc_map, index, ke->keycode);
> @@ -422,11 +463,11 @@ static int ir_setkeytable(struct rc_dev *dev,
>  			  const struct rc_map *from)
>  {
>  	struct rc_map *rc_map = &dev->rc_map;
> +	struct rc_map_table entry;
>  	unsigned int i, index;
>  	int rc;
>  
> -	rc = ir_create_table(rc_map, from->name,
> -			     from->rc_type, from->size);
> +	rc = ir_create_table(rc_map, from->name, from->size);
>  	if (rc)
>  		return rc;
>  
> @@ -434,18 +475,19 @@ static int ir_setkeytable(struct rc_dev *dev,
>  		   rc_map->size, rc_map->alloc);
>  
>  	for (i = 0; i < from->size; i++) {
> -		index = ir_establish_scancode(dev, rc_map,
> -					      from->rc_type == RC_TYPE_NEC ?
> -					      to_nec32(from->scan[i].scancode) :
> -					      from->scan[i].scancode,
> -					      false);
> +		if (from->rc_type == RC_TYPE_NEC)
> +			entry.scancode = to_nec32(from->scan[i].scancode);
> +		else
> +			entry.scancode = from->scan[i].scancode;
> +
> +		entry.protocol = from->rc_type;
> +		index = ir_establish_scancode(dev, rc_map, &entry, false);
>  		if (index >= rc_map->len) {
>  			rc = -ENOMEM;
>  			break;
>  		}
>  
> -		ir_update_mapping(dev, rc_map, index,
> -				  from->scan[i].keycode);
> +		ir_update_mapping(dev, rc_map, index, from->scan[i].keycode);
>  	}
>  
>  	if (rc)
> @@ -457,6 +499,7 @@ static int ir_setkeytable(struct rc_dev *dev,
>  /**
>   * ir_lookup_by_scancode() - locate mapping by scancode
>   * @rc_map:	the struct rc_map to search
> + * @protocol:	protocol to look for in the table
>   * @scancode:	scancode to look for in the table
>   * @return:	index in the table, -1U if not found
>   *
> @@ -464,17 +507,24 @@ static int ir_setkeytable(struct rc_dev *dev,
>   * given scancode.
>   */
>  static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
> -					  unsigned int scancode)
> +					  u16 protocol, u64 scancode)
>  {
>  	int start = 0;
>  	int end = rc_map->len - 1;
>  	int mid;
> +	struct rc_map_table *m;
>  
>  	while (start <= end) {
>  		mid = (start + end) / 2;
> -		if (rc_map->scan[mid].scancode < scancode)
> +		m = &rc_map->scan[mid];
> +
> +		if (m->protocol < protocol)
> +			start = mid + 1;
> +		else if (m->protocol > protocol)
> +			end = mid - 1;
> +		else if (m->scancode < scancode)
>  			start = mid + 1;
> -		else if (rc_map->scan[mid].scancode > scancode)
> +		else if (m->scancode > scancode)
>  			end = mid - 1;
>  		else
>  			return mid;
> @@ -495,35 +545,61 @@ static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
>  static int ir_getkeycode(struct input_dev *idev,
>  			 struct input_keymap_entry *ke)
>  {
> +	struct rc_keymap_entry *rke = (struct rc_keymap_entry *)ke;
>  	struct rc_dev *rdev = input_get_drvdata(idev);
>  	struct rc_map *rc_map = &rdev->rc_map;
>  	struct rc_map_table *entry;
>  	unsigned long flags;
>  	unsigned int index;
> -	unsigned int scancode;
>  	int retval;
>  
> +	printk(KERN_ERR "ir_getkeycode: ke->len is %i\n", ke->len);
>  	spin_lock_irqsave(&rc_map->lock, flags);
>  
>  	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
>  		index = ke->index;
> -	} else {
> +	} else if (ke->len == sizeof(int)) {
> +		/* Legacy EVIOCGKEYCODE ioctl */
> +		u32 scancode;
> +		u16 protocol;
> +
>  		retval = input_scancode_to_scalar(ke, &scancode);
>  		if (retval)
>  			goto out;
>  
> -		if (guess_protocol(rdev) == RC_TYPE_NEC)
> +		protocol = guess_protocol(rdev);
> +		if (protocol == RC_TYPE_NEC)
>  			scancode = to_nec32(scancode);
> -		index = ir_lookup_by_scancode(rc_map, scancode);
> +
> +		index = ir_lookup_by_scancode(rc_map, protocol, scancode);
> +
> +	} else if (ke->len == sizeof(struct rc_scancode)) {
> +		/* New EVIOCGKEYCODE_V2 ioctl */
> +		if (rke->rc.reserved[0] || rke->rc.reserved[1] || rke->rc.reserved[2]) {
> +			retval = -EINVAL;
> +			goto out;
> +		}
> +
> +		index = ir_lookup_by_scancode(rc_map,
> +					      rke->rc.protocol, rke->rc.scancode);
> +
> +	} else {
> +		retval = -EINVAL;
> +		goto out;
>  	}
>  
>  	if (index < rc_map->len) {
>  		entry = &rc_map->scan[index];
> -
>  		ke->index = index;
>  		ke->keycode = entry->keycode;
> -		ke->len = sizeof(entry->scancode);
> -		memcpy(ke->scancode, &entry->scancode, sizeof(entry->scancode));
> +		if (ke->len == sizeof(int)) {
> +			u32 scancode = entry->scancode;
> +			memcpy(ke->scancode, &scancode, sizeof(scancode));
> +		} else {
> +			ke->len = sizeof(struct rc_scancode);
> +			rke->rc.protocol = entry->protocol;
> +			rke->rc.scancode = entry->scancode;
> +		}
>  
>  	} else if (!(ke->flags & INPUT_KEYMAP_BY_INDEX)) {
>  		/*
> @@ -548,6 +624,7 @@ out:
>  /**
>   * rc_g_keycode_from_table() - gets the keycode that corresponds to a scancode
>   * @dev:	the struct rc_dev descriptor of the device
> + * @protocol:	the protocol to look for
>   * @scancode:	the scancode to look for
>   * @return:	the corresponding keycode, or KEY_RESERVED
>   *
> @@ -555,7 +632,8 @@ out:
>   * keycode. Normally it should not be used since drivers should have no
>   * interest in keycodes.
>   */
> -u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
> +u32 rc_g_keycode_from_table(struct rc_dev *dev,
> +			    enum rc_type protocol, u64 scancode)
>  {
>  	struct rc_map *rc_map = &dev->rc_map;
>  	unsigned int keycode;
> @@ -564,15 +642,16 @@ u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode)
>  
>  	spin_lock_irqsave(&rc_map->lock, flags);
>  
> -	index = ir_lookup_by_scancode(rc_map, scancode);
> +	index = ir_lookup_by_scancode(rc_map, protocol, scancode);
>  	keycode = index < rc_map->len ?
>  			rc_map->scan[index].keycode : KEY_RESERVED;
>  
>  	spin_unlock_irqrestore(&rc_map->lock, flags);
>  
>  	if (keycode != KEY_RESERVED)
> -		IR_dprintk(1, "%s: scancode 0x%04x keycode 0x%02x\n",
> -			   dev->input_name, scancode, keycode);
> +		IR_dprintk(1, "%s: protocol 0x%04x scancode 0x%08llx keycode 0x%02x\n",
> +			   dev->input_name, protocol,
> +			   (unsigned long long)scancode, keycode);
>  
>  	return keycode;
>  }
> @@ -705,8 +784,9 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
>  		dev->last_keycode = keycode;
>  
>  		IR_dprintk(1, "%s: key down event, "
> -			   "key 0x%04x, protocol 0x%04x, scancode 0x%08x\n",
> -			   dev->input_name, keycode, protocol, scancode);
> +			   "key 0x%04x, protocol 0x%04x, scancode 0x%08llx\n",
> +			   dev->input_name, keycode, protocol,
> +			   (long long unsigned)scancode);
>  		input_report_key(dev->input_dev, keycode, 1);
>  
>  		led_trigger_event(led_feedback, LED_FULL);
> @@ -725,10 +805,11 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
>   * This routine is used to signal that a key has been pressed on the
>   * remote control.
>   */
> -void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle)
> +void rc_keydown(struct rc_dev *dev, enum rc_type protocol,
> +		u64 scancode, u8 toggle)
>  {
>  	unsigned long flags;
> -	u32 keycode = rc_g_keycode_from_table(dev, scancode);
> +	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
>  
>  	spin_lock_irqsave(&dev->keylock, flags);
>  	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
> @@ -754,10 +835,10 @@ EXPORT_SYMBOL_GPL(rc_keydown);
>   * remote control. The driver must manually call rc_keyup() at a later stage.
>   */
>  void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
> -			  u32 scancode, u8 toggle)
> +			  u64 scancode, u8 toggle)
>  {
>  	unsigned long flags;
> -	u32 keycode = rc_g_keycode_from_table(dev, scancode);
> +	u32 keycode = rc_g_keycode_from_table(dev, protocol, scancode);
>  
>  	spin_lock_irqsave(&dev->keylock, flags);
>  	ir_do_keydown(dev, protocol, scancode, keycode, toggle);
> @@ -1472,9 +1553,14 @@ int rc_register_device(struct rc_dev *dev)
>  	}
>  
>  	if (dev->change_protocol) {
> -		u64 rc_type = (1ll << rc_map->rc_type);
> +		u64 rc_type = 0;
> +
> +		if (rc_map->len > 0)
> +			rc_type = (1ll << rc_map->scan[0].protocol);
> +
>  		if (dev->driver_type == RC_DRIVER_IR_RAW)
>  			rc_type |= RC_BIT_LIRC;
> +
>  		rc = dev->change_protocol(dev, &rc_type);
>  		if (rc < 0)
>  			goto out_raw;
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 6b4400c..c414ece 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -34,6 +34,24 @@ enum rc_driver_type {
>  	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
>  };
>  
> +/* This is used for the input EVIOC[SG]KEYCODE_V2 ioctls */
> +struct rc_scancode {
> +	__u16 protocol;
> +	__u16 reserved[3];
> +	__u64 scancode;
> +};
> +
> +struct rc_keymap_entry {
> +	__u8  flags;
> +	__u8  len;
> +	__u16 index;
> +	__u32 keycode;
> +	union {
> +		struct rc_scancode rc;
> +		__u8 raw[32];
> +	};
> +};
> +
>  /**
>   * struct rc_scancode_filter - Filter scan codes.
>   * @data:	Scancode data to match.
> @@ -149,7 +167,7 @@ struct rc_dev {
>  	struct timer_list		timer_keyup;
>  	u32				last_keycode;
>  	enum rc_type			last_protocol;
> -	u32				last_scancode;
> +	u64				last_scancode;
>  	u8				last_toggle;
>  	u32				timeout;
>  	u32				min_timeout;
> @@ -192,10 +210,10 @@ int rc_open(struct rc_dev *rdev);
>  void rc_close(struct rc_dev *rdev);
>  
>  void rc_repeat(struct rc_dev *dev);
> -void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
> -void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u32 scancode, u8 toggle);
> +void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);
> +void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);
>  void rc_keyup(struct rc_dev *dev);
> -u32 rc_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
> +u32 rc_g_keycode_from_table(struct rc_dev *dev, enum rc_type protocol, u64 scancode);
>  
>  /*
>   * From rc-raw.c
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index d0bbfc1..4f36869 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -87,8 +87,9 @@ enum rc_type {
>  #define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)
>  
>  struct rc_map_table {
> -	u32	scancode;
> -	u32	keycode;
> +	u64		scancode;
> +	u32		keycode;
> +	enum rc_type	protocol;
>  };
>  
>  struct rc_map {
> @@ -96,7 +97,7 @@ struct rc_map {
>  	unsigned int		size;	/* Max number of entries */
>  	unsigned int		len;	/* Used number of entries */
>  	unsigned int		alloc;	/* Size of *scan in bytes */
> -	enum rc_type		rc_type;
> +	enum rc_type		rc_type; /* For in-kernel keymaps */
>  	const char		*name;
>  	spinlock_t		lock;
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
