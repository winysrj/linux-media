Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:48816 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZATWgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:36:04 -0500
Received: by qyk4 with SMTP id 4so3682936qyk.13
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 14:36:02 -0800 (PST)
Message-ID: <412bdbff0901201436i363cd9d8r7d6cd4f37150e6c2@mail.gmail.com>
Date: Tue, 20 Jan 2009 17:36:02 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: haupauge remote keycode for av7110_loadkeys
Cc: "matthieu castet" <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org
In-Reply-To: <20090120201830.2945fba5@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4974E428.7020702@free.fr>
	 <20090119185326.29da37da@caramujo.chehab.org>
	 <4976295E.2070509@free.fr>
	 <412bdbff0901201150w2a8a66b4r50670eccc3d8340a@mail.gmail.com>
	 <20090120201830.2945fba5@caramujo.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 20, 2009 at 5:18 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>> Your assessment of the current situation is correct. Yes, it's a
>> pretty annoying situation.  It does have the upside that we
>> automatically provide the right keycodes for whatever remote comes by
>> default with a particular product, but obviously it is a mess if you
>> want to use some different remote and if your remote wasn't supported,
>> adding support requires a kernel recompile.
>
> No. Replacing the keycodes is as easy as adding something like this on your
> rc.local, or adding an equivalent udev rule:
>
> ./v4l2-apps/util/keycode /dev/input/event3 ./v4l2-apps/util/keycodes/avertv_303
>
> This will replace the keys of the input device (assumed above that the event
> device is event3) by the keys at avertv_303 file.
>
> The in-kernel tables are just the default ones for that device.

I guess the thing I disagree with is the notion that what you have
described is "easy".

* It requires keymaps being maintained both in-kernel and out-of-kernel
* It doesn't work with all drivers (like the dib0700)
* It doesn't let you select a different in-kernel keymap unless you
translate it to a file that can be passed to the keycode utility
* The interactions with lircd is inconsistent across drivers.

I'm all in favor of some way for making sure the correct default
keymap is selected for a given device, but the current approach is
pretty haphazard.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
