Return-path: <mchehab@pedra>
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:45344 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0IIMtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 08:49:36 -0400
Date: Thu, 9 Sep 2010 15:40:04 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 5/6] Input: ati-remote2 - switch to using new keycode
 interface
Message-ID: <20100909124003.GT10135@sci.fi>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
 <20100908074205.32365.68835.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100908074205.32365.68835.stgit@hammer.corenet.prv>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 12:42:05AM -0700, Dmitry Torokhov wrote:
> Switch the code to use new style of getkeycode and setkeycode
> methods to allow retrieving and setting keycodes not only by
> their scancodes but also by index.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  drivers/input/misc/ati_remote2.c |   93 +++++++++++++++++++++++++++-----------
>  1 files changed, 65 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
> index 2325765..b2e0d82 100644
> --- a/drivers/input/misc/ati_remote2.c
> +++ b/drivers/input/misc/ati_remote2.c
> @@ -483,51 +483,88 @@ static void ati_remote2_complete_key(struct urb *urb)
>  }
>  
>  static int ati_remote2_getkeycode(struct input_dev *idev,
> -				  unsigned int scancode, unsigned int *keycode)
> +				  struct input_keymap_entry *ke)
>  {
>  	struct ati_remote2 *ar2 = input_get_drvdata(idev);
>  	unsigned int mode;
> -	int index;
> +	int offset;
> +	unsigned int index;
> +	unsigned int scancode;
> +
> +	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
> +		index = ke->index;
> +		if (index >= (ATI_REMOTE2_MODES - 1) *
                                               ^^^^
That -1 looks wrong. Same in setkeycode().

> +				ARRAY_SIZE(ati_remote2_key_table))
> +			return -EINVAL;
> +
> +		mode = ke->index / ARRAY_SIZE(ati_remote2_key_table);
> +		offset = ke->index % ARRAY_SIZE(ati_remote2_key_table);
> +		scancode = (mode << 8) + ati_remote2_key_table[offset].hw_code;
> +	} else {
> +		if (input_scancode_to_scalar(ke, &scancode))
> +			return -EINVAL;
> +
> +		mode = scancode >> 8;
> +		if (mode > ATI_REMOTE2_PC)
> +			return -EINVAL;
> +
> +		offset = ati_remote2_lookup(scancode & 0xff);
> +		if (offset < 0)
> +			return -EINVAL;
> +
> +		index = mode * ARRAY_SIZE(ati_remote2_key_table) + offset;
> +	}
>  
> -	mode = scancode >> 8;
> -	if (mode > ATI_REMOTE2_PC || !((1 << mode) & ar2->mode_mask))
> -		return -EINVAL;

You're removing the mode_mask check here, but I think that's fine. I
don't see why the keymap shouldn't be allowed to be queried/modified for
the unused modes.

> +	ke->keycode = ar2->keycode[mode][offset];
> +	ke->len = sizeof(scancode);
> +	memcpy(&ke->scancode, &scancode, sizeof(scancode));

The scancodes fit into two bytes each. Does it matter that you're
using 4 bytes here?

> +	ke->index = index;
>  
> -	index = ati_remote2_lookup(scancode & 0xFF);
> -	if (index < 0)
> -		return -EINVAL;
> -
> -	*keycode = ar2->keycode[mode][index];
>  	return 0;
>  }
>  
>  static int ati_remote2_setkeycode(struct input_dev *idev,
> -				  unsigned int scancode, unsigned int keycode)
> +				  const struct input_keymap_entry *ke,
> +				  unsigned int *old_keycode)
>  {
>  	struct ati_remote2 *ar2 = input_get_drvdata(idev);
> -	unsigned int mode, old_keycode;
> -	int index;
> -
> -	mode = scancode >> 8;
> -	if (mode > ATI_REMOTE2_PC || !((1 << mode) & ar2->mode_mask))
> -		return -EINVAL;
> -
> -	index = ati_remote2_lookup(scancode & 0xFF);
> -	if (index < 0)
> -		return -EINVAL;
> +	unsigned int mode;
> +	int offset;
> +	unsigned int index;
> +	unsigned int scancode;
> +
> +	if (ke->flags & INPUT_KEYMAP_BY_INDEX) {
> +		if (ke->index >= (ATI_REMOTE2_MODES - 1) *
> +				ARRAY_SIZE(ati_remote2_key_table))
> +			return -EINVAL;
> +
> +		mode = ke->index / ARRAY_SIZE(ati_remote2_key_table);
> +		offset = ke->index % ARRAY_SIZE(ati_remote2_key_table);
> +	} else {
> +		if (input_scancode_to_scalar(ke, &scancode))
> +			return -EINVAL;
> +
> +		mode = scancode >> 8;
> +		if (mode > ATI_REMOTE2_PC)
> +			return -EINVAL;
> +
> +		offset = ati_remote2_lookup(scancode & 0xff);
> +		if (offset < 0)
> +			return -EINVAL;
> +	}
>  
> -	old_keycode = ar2->keycode[mode][index];
> -	ar2->keycode[mode][index] = keycode;
> -	__set_bit(keycode, idev->keybit);
> +	*old_keycode = ar2->keycode[mode][offset];
> +	ar2->keycode[mode][offset] = ke->keycode;
> +	__set_bit(ke->keycode, idev->keybit);
>  
>  	for (mode = 0; mode < ATI_REMOTE2_MODES; mode++) {
>  		for (index = 0; index < ARRAY_SIZE(ati_remote2_key_table); index++) {
> -			if (ar2->keycode[mode][index] == old_keycode)
> +			if (ar2->keycode[mode][index] == *old_keycode)
>  				return 0;
>  		}
>  	}
>  
> -	__clear_bit(old_keycode, idev->keybit);
> +	__clear_bit(*old_keycode, idev->keybit);
>  
>  	return 0;
>  }
> @@ -575,8 +612,8 @@ static int ati_remote2_input_init(struct ati_remote2 *ar2)
>  	idev->open = ati_remote2_open;
>  	idev->close = ati_remote2_close;
>  
> -	idev->getkeycode = ati_remote2_getkeycode;
> -	idev->setkeycode = ati_remote2_setkeycode;
> +	idev->getkeycode_new = ati_remote2_getkeycode;
> +	idev->setkeycode_new = ati_remote2_setkeycode;
>  
>  	idev->name = ar2->name;
>  	idev->phys = ar2->phys;
> 

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
