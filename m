Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55303 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933396AbdGKVgj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 17:36:39 -0400
Date: Tue, 11 Jul 2017 22:36:36 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
Subject: Re: Infrared support on tango boards
Message-ID: <20170711213636.x5cwdtytrrczftn6@gofer.mess.org>
References: <e5063c2c-52db-7d75-e090-fbc49ab76deb@free.fr>
 <20170711195058.y425mohdbzjeihgy@gofer.mess.org>
 <bc1fd24d-8568-ffe1-4eed-d3df0987176e@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc1fd24d-8568-ffe1-4eed-d3df0987176e@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 11, 2017 at 11:16:13PM +0200, Mason wrote:
> On 11/07/2017 21:50, Sean Young wrote:
> 
> > On Mon, Jul 10, 2017 at 11:44:08AM +0200, Mason wrote:
> >
> >> How does one know which decoder to use, out of
> >> the dozen protocols available?
> > 
> > Well, that depends on the protocol the remote uses to send.
> 
> Is there a way to "guess" the protocol used, just by
> looking at the raw bitstream?

We should be able to figure that out from the raw IR, the pulse
and space information. For that, you do need to have a different
IR receiver (one that handles raw IR). If you have one which can
send IR too, then that makes testing the driver much easier as
you can try all the different protocols that the driver supports.

> >> Once we have a scancode, there is another translation pass,
> >> to the higher-level concept of an actual key, such as "1",
> >> which all applications can agree on.
> > 
> > Yep, that's what the keymaps in drivers/media/rc/keymaps/ are for.
> 
> Suppose I wrote a keymap "driver" for my remote control,
> 
> Does loading a kernel keymap change what is output on
> /dev/input/event0 ?

Yes, you get EV_KEY events in addition to the scancode events. Here is
volume up on an rc6_mce remote:

1499808305.895525: event type EV_MSC(0x04): scancode = 0x800f0410
1499808305.895525: event type EV_KEY(0x01) key_down: KEY_VOLUMEUP(0x0073)
1499808305.895525: event type EV_SYN(0x00).

> I mean, does the output changes from 'struct input_event'
> to input-event-codes? (so 4-byte int?)
> Or is that sent on a different dev node?
> 
> http://elixir.free-electrons.com/linux/latest/source/include/uapi/linux/input-event-codes.h

Event codes are the type and code field of the struct input_event.

> >> Back on topic: it seems to me that Linux supports many protocol
> >> decoders, including the 3 supported by block A. I am also assuming
> >> that IR signals are pretty low bandwidth? Thus, it would appear
> >> to make sense to only use block B, to have the widest support.
> > 
> > Absolutely right. That's what the winbond-cir driver does too. However,
> > for wakeup from suspend the winbond-cir uses the hardware decoder.
> 
> I was later told that the "universal" HW block had not
> received extensive testing; and everyone just uses the
> NEC/RC5/RC6 block. So I guess I'll forget about the
> UIR block for now.

OK. That's a shame. The "universal" hw block should be much simpler,
depending how it is implemented.

Please note that nec, rc5 and rc6 all have protocol variants, and the
driver should report which variant has been decoded, and process the
scancode correctly. If you an have an IR transmitter, you can use 
ir-ctl to verify all the variants.


Sean
