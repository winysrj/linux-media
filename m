Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58359 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1AYFbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 00:31:25 -0500
Date: Mon, 24 Jan 2011 21:31:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125053117.GD7850@core.coreip.homeip.net>
References: <4D3C5F73.2050408@teksavvy.com>
 <20110124175456.GA17855@core.coreip.homeip.net>
 <4D3E1A08.5060303@teksavvy.com>
 <20110125005555.GA18338@core.coreip.homeip.net>
 <4D3E4DD1.60705@teksavvy.com>
 <20110125042016.GA7850@core.coreip.homeip.net>
 <4D3E5372.9010305@teksavvy.com>
 <20110125045559.GB7850@core.coreip.homeip.net>
 <4D3E59CA.6070107@teksavvy.com>
 <4D3E5A91.30207@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3E5A91.30207@teksavvy.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jan 25, 2011 at 12:07:29AM -0500, Mark Lord wrote:
> On 11-01-25 12:04 AM, Mark Lord wrote:
> > On 11-01-24 11:55 PM, Dmitry Torokhov wrote:
> >> On Mon, Jan 24, 2011 at 11:37:06PM -0500, Mark Lord wrote:
> > ..
> >>> This results in (map->size==10) for 2.6.36+ (wrong),
> >>> and a much larger map->size for 2.6.35 and earlier.
> >>>
> >>> So perhaps EVIOCGKEYCODE has changed?
> >>>
> >>
> >> So the utility expects that all devices have flat scancode space and
> >> driver might have changed so it does not recognize scancode 10 as valid
> >> scancode anymore.
> >>
> >> The options are:
> >>
> >> 1. Convert to EVIOCGKEYCODE2
> >> 2. Ignore errors from EVIOCGKEYCODE and go through all 65536 iterations.
> > 
> > or 3. Revert/fix the in-kernel regression.
> > 
> > The EVIOCGKEYCODE ioctl is supposed to return KEY_RESERVED for unmapped
> > (but value) keycodes, and only return -EINVAL when the keycode itself
> > is out of range.
> > 
> > That's how it worked in all kernels prior to 2.6.36,
> > and now it is broken.  It now returns -EINVAL for any unmapped keycode,
> > even though keycodes higher than that still have mappings.
> > 
> > This is a bug, a regression, and breaks userspace.
> > I haven't identified *where* in the kernel the breakage happened,
> > though.. that code confuses me.  :)
> 
> Note that this device DOES have "flat scancode space",
> and the kernel is now incorrectly signalling an error (-EINVAL)
> in response to a perfectly valid query of a VALID (and mappable)
> keycode on the remote control
> 
> The code really is a valid button, it just doesn't have a default mapping
> set by the kernel (I can set a mapping for that code from userspace and it works).
> 

OK, in this case let's ping Mauro - I think he done the adjustments to
IR keymap hanlding.

Thanks.

-- 
Dmitry
