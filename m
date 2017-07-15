Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38327 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbdGOJF1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 05:05:27 -0400
Date: Sat, 15 Jul 2017 10:05:26 +0100
From: Sean Young <sean@mess.org>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: rc-core: how to use hid (hardware) decoder?
Message-ID: <20170715090525.rp473q3m7wrhgcgf@gofer.mess.org>
References: <a45b045a-e476-9967-db28-4bd9d7359696@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a45b045a-e476-9967-db28-4bd9d7359696@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Fri, Jul 14, 2017 at 04:14:05AM +0300, Antti Palosaari wrote:
> Moikka!
> Some remote controller receivers uses HID interface. I looked rc-core
> implementation, but failed to find how it could be used for hid. I need
> somehow get scancodes and keycodes out from rc-core and write those to
> hardware which then generate hid events. Also, I am not sure if kernel
> keycodes are same than HID codes, but if not then those should be translated
> somehow.
>
> There is rc_g_keycode_from_table() function, which could be used to dump
> current scancode:keycode mapping, but calling it in a loop millions of times
> is not surely correctly :]

Possibly you could use rc_map_get() to get the entire array. However you
would be limited to rc keymaps which are compiled into the kernel.

It be good to expose an interface to userspace which allows you to read and
write the mapping from IR protocol + scancode to hid usage codes; you could
then have an ir-keytable-like tool to change the keymap.


Sean
