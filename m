Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:34705 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbbC3VSv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 17:18:51 -0400
Date: Mon, 30 Mar 2015 23:18:19 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Send and receive decoded IR using lirc interface
Message-ID: <20150330211819.GA18426@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1426801061.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 19, 2015 at 09:50:11PM +0000, Sean Young wrote:
>This patch series tries to fix the lirc interface and extend it so it can
>be used to send/recv scancodes in addition to raw IR:
>
> - Make it possible to receive scancodes from hardware that generates 
>   scancodes (with rc protocol information)
> - Make it possible to receive decoded scancodes from raw IR, from the 
>   in-kernel decoders (not mce mouse/keyboard). Now you can take any
>   remote, run ir-rec and you will get both the raw IR and the decoded
>   scancodes plus rc protocol information.
> - Make it possible to send scancodes; in kernel-encoding of IR
> - Make it possible to send scancodes for hardware that can only do that
>   (so that lirc_zilog can be moved out of staging, not completed yet)
> - Possibly the lirc interface can be used for cec?
>
>This requires a little refactoring.
> - All rc-core devices will have a lirc device associated with them
> - The rc-core <-> lirc bridge no longer is a "decoder", this never made 
>   sense and caused confusion

IIRC, it was written that way to make the lirc module optional.

>This requires new API for rc-core lirc devices.
> - New feature LIRC_CAN_REC_SCANCODE and LIRC_CAN_SEND_SCANCODE
> - REC_MODE and SEND_MODE do not enable LIRC_MODE_SCANCODE by default since 
>   this would confuse existing userspace code
> - For each scancode we need: 
>   - rc protocol (RC_TYPE_*) 
>   - toggle and repeat bit for some protocols
>   - 32 bit scancode

I haven't looked at the patches in detail, but I think exposing the
scancodes to userspace requires some careful consideration.

First of all, scancode length should be dynamic, there are protocols
(NEC48 and, at least theoretically, RC6) that have scancodes > 32 bits.

Second, if we expose protocol type (which we should, not doing so is
throwing away valuable information) we should tackle the NEC scancode
question. I've already explained my firm conviction that always
reporting NEC as a 32 bit scancode is the only sane thing to do. Mauro
is of the opinion that NEC16/24/32 should be essentially different
protocols.

Third, we should still have a way to represent the protocol in the
keymap as well.

And on a much more general level...I still think we should start from
scratch with a rc specific chardev with it's own API that is generic
enough to cover both scancode / raw ir / future / other protocols (not
that such an undertaking would preclude adding stuff to the lirc API of
course).

Re,
David

PS
Thanks for your continued RC efforts Sean!

