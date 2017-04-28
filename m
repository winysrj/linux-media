Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48697 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164750AbdD1TmO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 15:42:14 -0400
Date: Fri, 28 Apr 2017 20:42:13 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] rc-core: add protocol to EVIOC[GS]KEYCODE_V2 ioctl
Message-ID: <20170428194212.GA7376@gofer.mess.org>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
 <149332526341.32431.11307248841385136294.stgit@zeus.hardeman.nu>
 <20170428083133.2e6621bd@vento.lan>
 <20170428165911.axrlw6aic3cqabas@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170428165911.axrlw6aic3cqabas@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 06:59:11PM +0200, David Härdeman wrote:
> On Fri, Apr 28, 2017 at 08:31:33AM -0300, Mauro Carvalho Chehab wrote:
> >Em Thu, 27 Apr 2017 22:34:23 +0200
> >David Härdeman <david@hardeman.nu> escreveu:
> ...
> >> This patch changes how the "input_keymap_entry" struct is interpreted
> >> by rc-core by casting it to "rc_keymap_entry":
> >> 
> >> struct rc_scancode {
> >> 	__u16 protocol;
> >> 	__u16 reserved[3];
> >> 	__u64 scancode;
> >> }
> >> 
> >> struct rc_keymap_entry {
> >> 	__u8  flags;
> >> 	__u8  len;
> >> 	__u16 index;
> >> 	__u32 keycode;
> >> 	union {
> >> 		struct rc_scancode rc;
> >> 		__u8 raw[32];
> >> 	};
> >> };
> >> 
> ...
> >
> >Nack.
> 
> That's not a very constructive approach. If you have a better approach
> in mind I'm all ears. Because you're surely not suggesting that we stay
> with the current protocol-less approach forever?

Well, what problem are we trying to solve actually?

Looking at the keymaps we have already, there are many scancodes which
overlap and only a few of them use a different protocol. So having this
feature will not suddenly make it possible to load all our keymaps, it
will just make it possible to simultaneously load a few more.

> >No userspace breakages are allowed.
> 
> That's a gross oversimplification.

This can be implemented without breaking userspace.


Sean
