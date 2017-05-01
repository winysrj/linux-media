Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59283 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752914AbdEARFq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 13:05:46 -0400
Date: Mon, 1 May 2017 18:05:44 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] [RFC] rc-core: report protocol information to userspace
Message-ID: <20170501170544.GB14836@gofer.mess.org>
References: <149346313232.25459.10475301883786006034.stgit@zeus.hardeman.nu>
 <20170501103830.GB10867@gofer.mess.org>
 <20170501124957.yqvy6dcqz5lh3bu5@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170501124957.yqvy6dcqz5lh3bu5@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 02:49:57PM +0200, David Härdeman wrote:
> On Mon, May 01, 2017 at 11:38:30AM +0100, Sean Young wrote:
> >On Sat, Apr 29, 2017 at 12:52:12PM +0200, David Härdeman wrote:
> >> Whether we decide to go for any new keytable ioctl():s or not in rc-core, we
> >> should provide the protocol information of keypresses to userspace.
> >> 
> >> Note that this means that the RC_TYPE_* definitions become part of the
> >> userspace <-> kernel API/ABI (meaning a full patch should maybe move those
> >> defines under include/uapi).
> >> 
> >> This would also need to be ack:ed by the input maintainers.
> >
> >This was already NACKed in the past.
> >
> >http://www.spinics.net/lists/linux-input/msg46941.html
> >
> 
> Didn't know that, thanks for the pointer. I still think we should
> revisit this though. Even if we don't add protocol-aware EVIOC[SG]KEY_V2
> ioctls, that information is useful for a configuration tool when
> creating keymaps for a new remote.
> 
> And examining the parent hardware device (as Dmitry seemed to suggest)
> doesn't help with protocol identification.
> 
> Another option if we don't want to touch the input layer would be to
> export the last_* members from struct rc_dev in sysfs (and I'm guessing
> a timestamp would be necessary then). Seems like a lot of work to
> accomplish what would otherwise be a one-line change in the input layer
> though (one-line since I'm assuming we could provide the protocol
> defines in a separate header, other than input-event-codes.h as the
> protocols are subsystem-specific).

So I have some patches for reading and writing scancodes, which will
give you a u64 scancode, protocol and other bits of information. This
can also be used for transmit where the IR encoders will be used.

http://www.spinics.net/lists/linux-media/msg109836.html

I wanted to make sure that these patches are also sufficient for sending
scancodes for the lirc_zilog driver before merging, which is what I'm
working on right now.


Sean
