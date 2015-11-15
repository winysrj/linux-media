Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55872 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbbKOWqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 17:46:21 -0500
Date: Sun, 15 Nov 2015 20:46:15 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Chris Rankin <rankincj@googlemail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Trying to enable RC6 IR for PCTV T2 290e
Message-ID: <20151115204615.0831ff21@recife.lan>
In-Reply-To: <CAK2bqVLk1TxiS9-3P7GoWjGtkyH3D36K4vnxv6vmDtxYyK_PiA@mail.gmail.com>
References: <CAK2bqVL1kyz=gjqKjs_W6oge-_h8qjE=7OwPhaX=OH47U2+z+g@mail.gmail.com>
	<CAGoCfiz9k3V0Z4ejVL4is4+t5WFMWo6EY7jjkiSEFrYj8zDqiA@mail.gmail.com>
	<CAK2bqVL76sbs4fXia2eU3gk+OLs_QsZMHo=HfctUtFM+4bOG8A@mail.gmail.com>
	<CAGoCfiwg14U=mmpcQ-E9zOHyS4bguJzfvRf-QgZOEuJn1x8cwg@mail.gmail.com>
	<CAK2bqVLk1TxiS9-3P7GoWjGtkyH3D36K4vnxv6vmDtxYyK_PiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 15 Nov 2015 22:18:48 +0000
Chris Rankin <rankincj@googlemail.com> escreveu:

> > How are you "switching back to RC5"?
> 
> I use the command "ir-keytable -p rc-5" or "ir-keytable -p rc-6" to
> switch between IR protocols, which does seem to invoke the
> em2874_ir_change_protocol() function. I'm not sure that I have a
> suitable RC6 keymap for this IR, and was expecting to have to create
> it myself by logging the scancodes returned by the driver.

Did you test with ir-keytable -t? If you don't load a keytable,
you'll be able to only see the scancodes.

Also, AFAIKT, the hardware decoder on em2874 only supports one
variant of RC6 protocol.

> 
> Cheers,
> Chris
> 
> On Sun, Nov 15, 2015 at 9:48 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
> >> I've dug a bit deeper and discovered that the reason the
> >> em28xx_info(...) lines that I'd added to em2874_polling_getkey()
> >> weren't appearing is because I'd loaded the wrong version of the
> >> em28xx-rc module! (Doh!)
> >
> > Ok, good.
> >
> >> The polling function *is* being called regularly, but
> >> em28xx_ir_handle_key() isn't noticing any keypresses. (However, it
> >> does notice when I switch back to RC5).
> >
> > How are you "switching back to RC5"?  Are you actually loading in an
> > RC6 versus RC5 keymap?  The reason I ask is because the onboard
> > receiver has to be explicitly configured into one of the two modes,
> > and IIRC this happens based on code type for the loaded keymap.  Hence
> > if you have an RC5 keymap loaded, you'll never see the IR receiver
> > reporting RC6 codes.
> >
> > And of course it's always possible you've hit a bug/regression.  I
> > haven't touched that code in years and I know it's been through a
> > couple of rounds of refactoring.
> >
> > Devin
> >
> > --
> > Devin J. Heitmueller - Kernel Labs
> > http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
