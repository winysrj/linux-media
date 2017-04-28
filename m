Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36460
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932342AbdD1Lbi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:31:38 -0400
Date: Fri, 28 Apr 2017 08:31:33 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, sean@mess.org
Subject: Re: [PATCH 6/6] rc-core: add protocol to EVIOC[GS]KEYCODE_V2 ioctl
Message-ID: <20170428083133.2e6621bd@vento.lan>
In-Reply-To: <149332526341.32431.11307248841385136294.stgit@zeus.hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
        <149332526341.32431.11307248841385136294.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Apr 2017 22:34:23 +0200
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
> Note that the heuristics are not 100% guaranteed to get things right.
> That is unavoidable since the protocol information simply isn't there
> when userspace calls the previous ioctl() types.
> 
> However, that is somewhat mitigated by the fact that the "only"
> userspace binary which might need to change is ir-keytable. Userspace
> programs which simply consume input events (i.e. the vast majority)
> won't have to change.

Nack.

No userspace breakages are allowed. There's no way to warrant that
ir-keytable version is compatible with a certain Kernel version.

Thanks,
Mauro
