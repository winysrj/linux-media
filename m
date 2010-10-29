Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54668 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab0J2VgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 17:36:19 -0400
From: James Hogan <james@albanarts.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/6] Input: add support for large scancodes
Date: Fri, 29 Oct 2010 22:36:06 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>,
	linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv> <20100908074144.32365.27232.stgit@hammer.corenet.prv>
In-Reply-To: <20100908074144.32365.27232.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010292236.07437.james@albanarts.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> diff --git a/include/linux/input.h b/include/linux/input.h
> index 7892651..0057698 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
<snip>
> +/**
> + * struct input_keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
> + * @scancode: scancode represented in machine-endian form.
> + * @len: length of the scancode that resides in @scancode buffer.
> + * @index: index in the keymap, may be used instead of scancode
> + * @flags: allows to specify how kernel should handle the request. For
> + *	example, setting INPUT_KEYMAP_BY_INDEX flag indicates that kernel
> + *	should perform lookup in keymap by @index instead of @scancode
> + * @keycode: key code assigned to this scancode
> + *
> + * The structure is used to retrieve and modify keymap data. Users have
> + * option of performing lookup either by @scancode itself or by @index
> + * in keymap entry. EVIOCGKEYCODE will also return scancode or index
> + * (depending on which element was used to perform lookup).
> + */
> +struct input_keymap_entry {
> +#define INPUT_KEYMAP_BY_INDEX	(1 << 0)
> +	__u8  flags;
> +	__u8  len;
> +	__u16 index;
> +	__u32 keycode;
> +	__u8  scancode[32];
> +};

I thought I better point out that this breaks make htmldocs (see below) 
because of the '<' characters "in" a kernel doc'd struct. This is with 
12ba8d1e9262ce81a695795410bd9ee5c9407ba1 from Linus' tree (>2.6.36). Moving 
the #define below the struct works around the problem, but I guess the real 
issue is in the kerneldoc code.

Cheers
James

$ make htmldocs
  DOCPROC Documentation/DocBook/device-drivers.xml
  HTML    Documentation/DocBook/device-drivers.html
/home/james/src/kernel/linux-2.6/Documentation/DocBook/device-
drivers.xml:41883: parser error : StartTag: invalid element name
#define INPUT_KEYMAP_BY_INDEX   (1 << 0)
                                    ^
/home/james/src/kernel/linux-2.6/Documentation/DocBook/device-
drivers.xml:41883: parser error : StartTag: invalid element name
#define INPUT_KEYMAP_BY_INDEX   (1 << 0)
                                     ^
unable to parse /home/james/src/kernel/linux-2.6/Documentation/DocBook/device-
drivers.xml
/bin/cp: cannot stat `*.*htm*': No such file or directory
make[1]: *** [Documentation/DocBook/device-drivers.html] Error 1
make: *** [htmldocs] Error 2
