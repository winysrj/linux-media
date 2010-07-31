Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49195 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0GaLDs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 07:03:48 -0400
Message-ID: <4C5402FE.2080002@s5r6.in-berlin.de>
Date: Sat, 31 Jul 2010 13:03:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Subject: Re: Handling of large keycodes
References: <20100731091936.GA22253@core.coreip.homeip.net>
In-Reply-To: <20100731091936.GA22253@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -56,22 +56,35 @@ struct input_absinfo {
>  	__s32 resolution;
>  };
>  
> -struct keycode_table_entry {
> -	__u32 keycode;		/* e.g. KEY_A */
> -	__u32 index;            /* Index for the given scan/key table, on EVIOCGKEYCODEBIG */
> -	__u32 len;		/* Length of the scancode */
> -	__u32 reserved[2];	/* Reserved for future usage */
> -	char *scancode;		/* scancode, in machine-endian */
> +/**
> + * struct keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
> + * @scancode: scancode represented in machine-endian form.
> + * @len: length of the scancode that resides in @scancode buffer.
> + * @index: index in the keymap, may be used instead of scancode
> + * @by_index: boolean value indicating that kernel should perform
> + *	lookup in keymap by @index instead of @scancode
> + * @keycode: key code assigned to this scancode
> + *
> + * The structure is used to retrieve and modify keymap data. Users have
> + * of performing lookup either by @scancode itself or by @index in
> + * keymap entry. EVIOCGKEYCODE will also return scancode or index
> + * (depending on which element was used to perform lookup).
> + */
> +struct keymap_entry {
> +	__u8  len;
> +	__u8  by_index;
> +	__u16 index;
> +	__u32 keycode;
> +	__u8  scancode[32];
>  };

I agree with Dimitry; don't put a pointer typed member into a userspace
ABI struct.

Two remarks:

  - Presently, <linux/input.h> defines three structs named input_... for
    userspace, two structs named input_... for kernelspace, and a few
    structs named ff_... specially for force-feedback stuff.  How about
    calling struct keymap_entry perhaps struct input_keymap_entry
    instead, to keep namespaces tidy?

  - I take it from your description that scan codes are fundamentally
    variable-length data.  How about defining it as __u8 scancode[0]?
-- 
Stefan Richter
-=====-==-=- -=== =====
http://arcgraph.de/sr/
