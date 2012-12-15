Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab2LONfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 08:35:25 -0500
Date: Sat, 15 Dec 2012 11:34:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	David =?UTF-8?B?SMOk?= =?UTF-8?B?cmRlbWFu?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
Message-ID: <20121215113448.293eed9e@redhat.com>
In-Reply-To: <50CC76FC.5030208@googlemail.com>
References: <50B5779A.9090807@pyther.net>
	<50C35AD1.3040000@googlemail.com>
	<50C48891.2050903@googlemail.com>
	<50C4A520.6020908@pyther.net>
	<CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com>
	<50C4BA20.8060003@googlemail.com>
	<50C4BAFB.60304@googlemail.com>
	<50C4C525.6020006@googlemail.com>
	<50C4D011.6010700@pyther.net>
	<50C60220.8050908@googlemail.com>
	<CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
	<50C60772.2010904@googlemail.com>
	<CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com>
	<50C6226C.8090302@iki! .fi>
	<50C636E7.8060003@googlemail.com>
	<50C64AB0.7020407@iki.fi>
	<50C79CD6.4060501@googlemail.com>
	<50C79E9A.3050301@iki.fi>
	<20121213182336.2cca9da6@redhat.! com>
	<50CB46CE.60407@googlemail.com>
	<20121214173950.79bb963e@redhat.com>
	<20121214222631.1f191d6e@redhat.co! m>
	<50CBCAB9.602@iki.fi>
	<20121214235412.2598c91c@redhat.com>
	<50CC76FC.5030208@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Dec 2012 14:11:24 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Sorry.... we completely lost the focus !
> Do you remeber the thread title ? ;)
> 
> We have two separate issues here.
> 1) Making Matthews hardware

Didn't read the entire thread, but it seems that this were already solved.

> / the scancode retrieval code work
> And _if_ it turns out that we can't make it work without knowing the sub
> protocol type in advance

The patches for IR to work with NEC-24/32 bits and RC6 mode 0 were posted.

All it lacks after applying the patches is likely to:
	1) put any dummy IR table on the board card logic, to enable IR code;
	2) run ir-keycode -t on his hardware to get the remote controller scancode;
	3) find the table that matches his IR at drivers/media/rc/keymaps/
	   or add a new one with the discovered scancodes;
	4) put the right IR table ad em28xx-cards.c;
	5) send the final patches upstream.

> 2) how to handle this (which doesn't necessarily mean that we have to
> solve it in the RC core)
> 
> So lets focus on 1) first:
> After reading the code again, it boils down to the following code lines
> in em28xx_ir_handle_key():
> 
>     if (unlikely(poll_result.read_count != ir->last_readcount)) {
>         dprintk("%s: toggle: %d, count: %d, key 0x%02x%02x\n", __func__,
>         ...
>         rc_keydown(...)
> 
> With reg 0x50 set to EM2874_IR_NEC=0x00, Matthew doesn't get any
> debugging messages when he presses the RC buttons.
> With reg 0x50 set to 0x01, there are only few messages, with the same
> single scancode:
> 
> Am 10.12.2012 17:00, schrieb Matthew Gyurgyik:
> >>> Here is the dmesg output:
> >>>
> >>>> [root@tux ~]# dmesg -t | sort | uniq | grep 'em28xx IR' | grep handle
> >>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0, count: 1,
> >>>> key 0x61d6
> >>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0, count: 2,
> >>>> key 0x61d6
> >>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 1, count: 1,
> >>>> key 0x61d6
> >>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 1,
> >>>> key 0x61d6
> >>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 2,
> >>>> key 0x61d6
> >>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1, count: 1,
> >>>> key 0x61d6
> >>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1, count: 2,
> >>>> key 0x61d6

The above is obviously not using the patches I sent yesterday/today, otherwise,
it would be seeing, instead, the full 32 bits code there.

Also, the better is to use ir-keytable program on test mode ("ir-keytable -t"),
as it allows to see if the 3 protocol messages received by each keystroke are
being received (EV_MSC, EV_KEY and EV_SYN).

> >>>
> >>> I pressed all the buttons on the remote (40 buttons).
> >>
> >> Did you cut the dmesg output ? Or do you really get these messages for
> >> key 0x61d6 only ?
> >
> > Correct, I only got the messages for key 0x61d6 regardless of which
> > physical button I press. 
> 
> So if Matthew didn't make any mistakes, the problem seems to be the read
> count handling...
> 
> 
> ----------------------------------
> 
> 
> Concerning the rc core / keymap stuff: it seems like there are some weak
> spots.
> The discussion is focussed on the scan codes and it seems to have a long
> history.
> I just want to make clear that I don't have an opinion about this yet
> (nor do I want to change someone elses opinion !). I actually don't care
> about it at the moment.
> If we're going to discuss this further, I suggest to do that in a
> separate thread with a more meaningful title.

Agreed. This is a separate question, and should be handled on a different
thread.

Regards,
Mauro
