Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:44515 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754599AbcKQRWY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 12:22:24 -0500
Date: Thu, 17 Nov 2016 13:45:26 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161117134526.GA8485@gofer.mess.org>
References: <20161116105256.GA9998@shambles.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161116105256.GA9998@shambles.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 16, 2016 at 09:52:58PM +1100, Vincent McIntyre wrote:
> I have a fairly old dvico dual digital 4 tuner and remote.
> There seem to be some issues with support for it, can I help fix them?
> 
> I am using ir-keytable 1.10.0-1 on Ubuntu 16.04 LTS,
> with kernel 4.4.0-47-generic (package version 4.4.0-47-generic)
> 
> The remote's keymapping is the one in /lib/udev/rc_keymaps/dvico_mce;
> kernel support for the device is in media/usb/dvb-usb/cxusb.c.
> 
> Mostly it works, in that I get correct keycodes back from evtest
> and ir-keytable -t. But I want to change some of the keycode mappings
> and that is not working.

I suspect the problem here is rc-core is not used and 
legacy_dvb_usb_setkeycode has a bug (it has several problems).

It would be nicer if we could move it rc-core, but for that to work
we need to know what scancodes remote sends (and in what protocol).
A scancode of 0xfe47 is not a valid RC5 scancode.

Would it be possible to test the remote with another device (say an
usb mce receiver or so) and see what scancodes it sends? Then we can
translate the keymap to a real one and make the cxusb driver send
correct scancodes to rc-core.


Sean
