Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37601 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbaC1AI7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Mar 2014 20:08:59 -0400
Date: Fri, 28 Mar 2014 01:08:56 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] rc-core: do not change 32bit NEC scancode format for now
Message-ID: <20140328000856.GB22491@hardeman.nu>
References: <20140327210037.20406.93136.stgit@zeus.muc.hardeman.nu>
 <7983411.lVWEDlBWc6@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7983411.lVWEDlBWc6@radagast>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 27, 2014 at 11:21:23PM +0000, James Hogan wrote:
>Hi David,
>
>On Thursday 27 March 2014 22:00:37 David Härdeman wrote:
>> This reverts 18bc17448147e93f31cc9b1a83be49f1224657b2
>> 
>> The patch ignores the fact that NEC32 scancodes are generated not only in
>> the NEC raw decoder but also directly in some drivers. Whichever approach
>> is chosen it should be consistent across drivers and this patch needs more
>> discussion.
>
>Fair enough. For reference which drivers are you referring to?

The ones I'm aware of right now are:
drivers/media/usb/dvb-usb/dib0700_core.c
drivers/media/usb/dvb-usb-v2/az6007.c
drivers/media/usb/dvb-usb-v2/af9035.c
drivers/media/usb/dvb-usb-v2/rtl28xxu.c
drivers/media/usb/dvb-usb-v2/af9015.c
drivers/media/usb/em28xx/em28xx-input.c

>> Furthermore, I'm convinced that we have to stop playing games trying to
>> decipher the "meaning" of NEC scancodes (what's the customer/vendor/address,
>> which byte is the MSB, etc).
>
>Well when all the buttons on a remote have the same address, and the numeric
>buttons are sequential commands only in a certain bit/byte order, then I think
>the word "decipher" is probably a bit of a stretch.

I think you misunderstood me. "decipher" is a bit of a stretch when
talking of one remote control (I'm guessing you're referring to the Tivo
remote). It's not that much of a stretch if we're referring to trying to
derive a common meaning from the encoding used for *all* remote controls
out there.

The discussion about the 24-bit version of NEC and whether the address
bytes were in MSB or LSB order was a good example. Andy Walls cited a
NEC manual which stated one thing and people also referred to
http://www.sbprojects.com/knowledge/ir/nec.php which stated the opposite
(while referring to an unnamed VCR service manual).

As a third example...I've read a Samsung service manual which happily
stated that the remote (which used the NEC protocol) sent IR commands
starting with the address x 2 (and looking at the raw NEC command, it
did start with something like 0x07 0x07).

So don't get me wrong, I wasn't referring to your analysis of the Tivo
remote but more the general approach that has been taken until now wrt.
the NEC protocol in the kernel drivers.

>Nevertheless I don't have any attachment to 32-bit NEC. If it's likely to
>change again I'd prefer img-ir-nec just not support it for now, so please
>could you add the following hunks to your patch (or if the original patch is
>to be dropped this could be squashed into the img-ir-nec patch):

I'd rather show you my complete proposal first before doing something
radical with your driver. But it was a good reminder that I need to keep
the NEC32 parsing in your driver in mind as well.

>> I'll post separate proposals to that effect later.
>
>Great, please do Cc me
>
>(I have a work in progress branch to unify NEC scancodes, but I'm not sure
>I'd have time to complete it any time soon anyway)

That is what I'm working on as well at the moment. It's actually to
solve two problems...both to unify NEC scancodes (by simply using 32 bit
scancodes everywhere and some fallback code...I'm not 100% sure it's
doable but I hope so since it's the only sane solution I can think of in
the long run)...and to make sure that protocol information actually gets
used in keymaps, etc.

I hope to post patches soon that'll make it clearer.

Regards,
David

