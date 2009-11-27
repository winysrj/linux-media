Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:49565 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZK0Deu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 22:34:50 -0500
MIME-Version: 1.0
In-Reply-To: <4B0F43B3.4090804@wilsonet.com>
References: <20091127013217.7671.32355.stgit@terra>
	 <4B0F43B3.4090804@wilsonet.com>
Date: Thu, 26 Nov 2009 22:34:55 -0500
Message-ID: <9e4733910911261934u43804e4bt6baa4302f302b536@mail.gmail.com>
Subject: Re: [IR-RFC PATCH v4 0/6] In-kernel IR support using evdev
From: Jon Smirl <jonsmirl@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2009 at 10:12 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> This part... Not so wild about. The common thought I'm seeing from people is
> that we should be using setkeycode to load keymaps. I mean, sure, I suppose
> this could be abstracted away so the user never sees it, but it seems to be
> reinventing a way to set up key mapping when setkeycode already exists, and
> is used by a number of existing IR devices in the v4l/dvb subsystem (as well
> as misc things like the ati rf remotes, iirc). Is there some distinct
> advantage to going this route vs. setkeycode that I'm missing?

The configfs scheme and keymaps offer the same abilities. One is an
ancient binary protocol and the other one uses Unix standard commands
like mkdir and echo to build the map. You need special commands -
setkeycodes, getkeycodes, showkey, loadkeys, xmodmap, dump-keys to use
a keymap.  I've been using Linux forever and I can't remember how
these commands work.

Keymaps are a binary protocol written by Risto Kankkunen in 1993.
Configfs was added by Oracle about two years ago but it has not been
used for mapping purposes.

It's another discussion, but if IR goes the configfs route I'd
consider writing a patch to switch keymaps/keycodes onto the configfs
model. It is a huge advantage to get rid of these pointless special
purpose commands that nobody knows how to use. I'd keep the legacy
IOCTLs working and redirect the data structure to a configfs one
instead of the existing structure.

The same idea is behind getting rid of IOCTLs and using sysfs. Normal
Unix commands can manipulate sysfs. IOCTLs have problems with strace,
endianess and the size of int (32/64b).

-- 
Jon Smirl
jonsmirl@gmail.com
