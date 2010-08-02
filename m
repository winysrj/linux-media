Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52163 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0HBIGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 04:06:09 -0400
Date: Mon, 2 Aug 2010 01:06:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: Handling of large keycodes
Message-ID: <20100802080604.GB9872@core.coreip.homeip.net>
References: <20100731091936.GA22253@core.coreip.homeip.net>
 <4C5402FE.2080002@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5402FE.2080002@s5r6.in-berlin.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 31, 2010 at 01:03:26PM +0200, Stefan Richter wrote:
> Dmitry Torokhov wrote:
> > --- a/include/linux/input.h
> > +++ b/include/linux/input.h
> > @@ -56,22 +56,35 @@ struct input_absinfo {
> >  	__s32 resolution;
> >  };
> >  
> > -struct keycode_table_entry {
> > -	__u32 keycode;		/* e.g. KEY_A */
> > -	__u32 index;            /* Index for the given scan/key table, on EVIOCGKEYCODEBIG */
> > -	__u32 len;		/* Length of the scancode */
> > -	__u32 reserved[2];	/* Reserved for future usage */
> > -	char *scancode;		/* scancode, in machine-endian */
> > +/**
> > + * struct keymap_entry - used by EVIOCGKEYCODE/EVIOCSKEYCODE ioctls
> > + * @scancode: scancode represented in machine-endian form.
> > + * @len: length of the scancode that resides in @scancode buffer.
> > + * @index: index in the keymap, may be used instead of scancode
> > + * @by_index: boolean value indicating that kernel should perform
> > + *	lookup in keymap by @index instead of @scancode
> > + * @keycode: key code assigned to this scancode
> > + *
> > + * The structure is used to retrieve and modify keymap data. Users have
> > + * of performing lookup either by @scancode itself or by @index in
> > + * keymap entry. EVIOCGKEYCODE will also return scancode or index
> > + * (depending on which element was used to perform lookup).
> > + */
> > +struct keymap_entry {
> > +	__u8  len;
> > +	__u8  by_index;
> > +	__u16 index;
> > +	__u32 keycode;
> > +	__u8  scancode[32];
> >  };
> 
> I agree with Dimitry; don't put a pointer typed member into a userspace
> ABI struct.
> 
> Two remarks:
> 
>   - Presently, <linux/input.h> defines three structs named input_... for
>     userspace, two structs named input_... for kernelspace, and a few
>     structs named ff_... specially for force-feedback stuff.  How about
>     calling struct keymap_entry perhaps struct input_keymap_entry
>     instead, to keep namespaces tidy?

Good idea, changed.

> 
>   - I take it from your description that scan codes are fundamentally
>     variable-length data.  How about defining it as __u8 scancode[0]?

In addition to difficulty in adding members (as you mentioned) it also
makes it more difficult for users to allocate such variables on stack or
make them global (anything but malloc with additional memory buffer)...

-- 
Dmitry
