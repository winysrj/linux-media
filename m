Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab1AaMaX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 07:30:23 -0500
Message-ID: <4D46AB5B.5060101@redhat.com>
Date: Mon, 31 Jan 2011 10:30:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-media@vger.kernel.org,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [PATCH] dvb-usb-remote - convert to new style of get/setkeycode
References: <20110131085352.GA30343@core.coreip.homeip.net>
In-Reply-To: <20110131085352.GA30343@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Dmitry,

Em 31-01-2011 06:53, Dmitry Torokhov escreveu:
> Input: dvb-usb-remote - convert to new style of get/setkeycode
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
> Mauro,
> 
> This is needed so that I could rename get/setkeycode_new into
> get/setkeycode and get rid of duplicate pointers and compat code in
> input core.
> 
> Compiled only, not tested.

I can't test this patch, since all the DVB-USB devices I have here,
I converted to use rc-core.

> If you are OK with the patch then I'd like to merge this through my
> tree.

Yeah, I'm ok. I don't have any intention on touching on those legacy
support functions (except for their removal, after having the remaining
drivers converted). So, feel free to submit it via your tree.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Thanks!
> 
>  drivers/media/dvb/dvb-usb/dvb-usb-remote.c |  113 +++++++++++++++++-----------
>  1 files changed, 70 insertions(+), 43 deletions(-)
> 
> 
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
> index 23005b3..347fbd4 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
> @@ -8,60 +8,71 @@
>  #include "dvb-usb-common.h"
>  #include <linux/usb/input.h>
>  
> +static unsigned int
> +legacy_dvb_usb_get_keymap_index(const struct input_keymap_entry *ke,
> +				struct rc_map_table *keymap,
> +				unsigned int keymap_size)
> +{
> +	unsigned int index;
> +	unsigned int scancode;
> +
> +	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
> +		index = ke->index;
> +	} else {
> +		if (input_scancode_to_scalar(ke, &scancode))
> +			return keymap_size;
> +
> +		/* See if we can match the raw key code. */
> +		for (index = 0; index < keymap_size; index++)
> +			if (keymap[index].scancode == scancode)
> +				break;
> +
> +		/* See if there is an unused hole in the map */
> +		if (index >= keymap_size) {
> +			for (index = 0; index < keymap_size; index++) {
> +				if (keymap[index].keycode == KEY_RESERVED ||
> +				    keymap[index].keycode == KEY_UNKNOWN) {
> +					break;
> +				}
> +			}
> +		}
> +	}
> +
> +	return index;
> +}
> +
>  static int legacy_dvb_usb_getkeycode(struct input_dev *dev,
> -				unsigned int scancode, unsigned int *keycode)
> +				     struct input_keymap_entry *ke)
>  {
>  	struct dvb_usb_device *d = input_get_drvdata(dev);
> -
>  	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
> -	int i;
> +	unsigned int keymap_size = d->props.rc.legacy.rc_map_size;
> +	unsigned int index;
>  
> -	/* See if we can match the raw key code. */
> -	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++)
> -		if (keymap[i].scancode == scancode) {
> -			*keycode = keymap[i].keycode;
> -			return 0;
> -		}
> +	index = legacy_dvb_usb_get_keymap_index(ke, keymap, keymap_size);
> +	if (index >= keymap_size)
> +		return -EINVAL;
>  
> -	/*
> -	 * If is there extra space, returns KEY_RESERVED,
> -	 * otherwise, input core won't let legacy_dvb_usb_setkeycode
> -	 * to work
> -	 */
> -	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++)
> -		if (keymap[i].keycode == KEY_RESERVED ||
> -		    keymap[i].keycode == KEY_UNKNOWN) {
> -			*keycode = KEY_RESERVED;
> -			return 0;
> -		}
> +	ke->keycode = keymap[index].keycode;
> +	if (ke->keycode == KEY_UNKNOWN)
> +		ke->keycode = KEY_RESERVED;
> +	ke->len = sizeof(keymap[index].scancode);
> +	memcpy(&ke->scancode, &keymap[index].scancode, ke->len);
> +	ke->index = index;
>  
> -	return -EINVAL;
> +	return 0;
>  }
>  
>  static int legacy_dvb_usb_setkeycode(struct input_dev *dev,
> -				unsigned int scancode, unsigned int keycode)
> +				     const struct input_keymap_entry *ke,
> +				     unsigned int *old_keycode)
>  {
>  	struct dvb_usb_device *d = input_get_drvdata(dev);
> -
>  	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
> -	int i;
> -
> -	/* Search if it is replacing an existing keycode */
> -	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++)
> -		if (keymap[i].scancode == scancode) {
> -			keymap[i].keycode = keycode;
> -			return 0;
> -		}
> -
> -	/* Search if is there a clean entry. If so, use it */
> -	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++)
> -		if (keymap[i].keycode == KEY_RESERVED ||
> -		    keymap[i].keycode == KEY_UNKNOWN) {
> -			keymap[i].scancode = scancode;
> -			keymap[i].keycode = keycode;
> -			return 0;
> -		}
> +	unsigned int keymap_size = d->props.rc.legacy.rc_map_size;
> +	unsigned int index;
>  
> +	index = legacy_dvb_usb_get_keymap_index(ke, keymap, keymap_size);
>  	/*
>  	 * FIXME: Currently, it is not possible to increase the size of
>  	 * scancode table. For it to happen, one possibility
> @@ -69,8 +80,24 @@ static int legacy_dvb_usb_setkeycode(struct input_dev *dev,
>  	 * copying data, appending the new key on it, and freeing
>  	 * the old one - or maybe just allocating some spare space
>  	 */
> +	if (index >= keymap_size)
> +		return -EINVAL;
> +
> +	*old_keycode = keymap[index].keycode;
> +	keymap->keycode = ke->keycode;
> +	__set_bit(ke->keycode, dev->keybit);
> +
> +	if (*old_keycode != KEY_RESERVED) {
> +		__clear_bit(*old_keycode, dev->keybit);
> +		for (index = 0; index < keymap_size; index++) {
> +			if (keymap[index].keycode == *old_keycode) {
> +				__set_bit(*old_keycode, dev->keybit);
> +				break;
> +			}
> +		}
> +	}
>  
> -	return -EINVAL;
> +	return 0;
>  }
>  
>  /* Remote-control poll function - called every dib->rc_query_interval ms to see
> @@ -171,8 +198,8 @@ static int legacy_dvb_usb_remote_init(struct dvb_usb_device *d)
>  	d->input_dev = input_dev;
>  	d->rc_dev = NULL;
>  
> -	input_dev->getkeycode = legacy_dvb_usb_getkeycode;
> -	input_dev->setkeycode = legacy_dvb_usb_setkeycode;
> +	input_dev->getkeycode_new = legacy_dvb_usb_getkeycode;
> +	input_dev->setkeycode_new = legacy_dvb_usb_setkeycode;
>  
>  	/* set the bits for the keys */
>  	deb_rc("key map size: %d\n", d->props.rc.legacy.rc_map_size);

