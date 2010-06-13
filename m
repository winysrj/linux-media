Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46122 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab0FMU3t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 16:29:49 -0400
Date: Sun, 13 Jun 2010 22:29:45 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
Message-ID: <20100613202945.GA5883@hardeman.nu>
References: <20100424211411.11570.2189.stgit@localhost.localdomain>
 <4BDF2B45.9060806@redhat.com>
 <20100607190003.GC19390@hardeman.nu>
 <20100607201530.GG16638@redhat.com>
 <20100608175017.GC5181@hardeman.nu>
 <AANLkTimuYkKzDPvtnrWKoT8sh1H9paPBQQNmYWOT7-R2@mail.gmail.com>
 <20100609132908.GM16638@redhat.com>
 <20100609175621.GA19620@hardeman.nu>
 <20100609181506.GO16638@redhat.com>
 <AANLkTims0dmYCOoI_K4S6Q8hwLV_MqUdGQjVwFu43sCL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTims0dmYCOoI_K4S6Q8hwLV_MqUdGQjVwFu43sCL@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 09, 2010 at 09:25:44PM -0400, Jarod Wilson wrote:
> On Wed, Jun 9, 2010 at 2:15 PM, Jarod Wilson <jarod@redhat.com> wrote:
> > On Wed, Jun 09, 2010 at 07:56:21PM +0200, David Härdeman wrote:
> >> On Wed, Jun 09, 2010 at 09:29:08AM -0400, Jarod Wilson wrote:
> ...
> >> > So this definitely negatively impacts my ir-core-to-lirc_dev
> >> > (ir-lirc-codec.c) bridge driver, as it was doing the lirc_dev device
> >> > registration work in its register function. However, if (after your
> >> > patchset) we add a new pair of callbacks replacing raw_register and
> >> > raw_unregister, which are optional, that work could be done there instead,
> >> > so I don't think this is an insurmountable obstacle for the lirc bits.
> >>
> >> While I'm not sure exactly what callbacks you're suggesting,
> >
> > Essentially:
> >
> > .setup_other_crap
> > .tear_down_other_crap
> >
> > ...which in the ir-lirc-codec case, register ir-lirc-codec for a specific
> > hardware receiver as an lirc_dev client, and conversely, tear it down.
> >
> >> it still
> >> sounds like the callbacks would have the exact same problems that the
> >> current code has (i.e. the decoder will be blissfully unaware of
> >> hardware which exists before the decoder is loaded). Right?
> >
> > In my head, this was going to work out, but you're correct, I still have
> > the exact same problem -- its not in ir_raw_handler_list yet when
> > ir_raw_event_register runs, and thus the callback never fires, so lirc_dev
> > never actually gets wired up to ir-lirc-codec. It now knows about the lirc
> > decoder, but its completely useless. Narf.
> 
> And now I have it working atop your patches. Its a bit of a nasty-ish
> hack, at least for the lirc case, but its working, even in the case
> where the decoder drivers aren't actually loaded until after the
> device driver. I've added one extra param to each protocol-specific
> struct in ir-core-priv.h (bool initialized) and hooked into the
> protocol-specific decode functions to both determine whether a
> protocol should be enabled or disabled by default, and to run any
> additionally required initialization (such as in the ir-lirc-codec
> case).
> 
> So initially, mceusb comes up with all decoders enabled. Then when ir
> comes in, every protocol-specific decoder fires. Each of them check
> for whether or not they've been fully initialized, and if not, we
> check the loaded keymap, and if it doesn't match, we disable that
> decoder (bringing back the "disable protocol handlers we don't need"
> functionality that disappeared w/this patchset). In the lirc case, we
> actually do all the work needed to wire up the connection over to
> lirc_dev.
> 
> This works perfectly fine for all the in-kernel decoders, but has one
> minor shortcoming for ir-lirc-codec, in that /dev/lirc0 won't actually
> exist until the first incoming ir signal is seen. lircd can handle
> this case just fine, it'll wait for /dev/lirc0 to show up, but it
> doesn't come up fast enough to catch and decode the very first
> incoming ir signal. Subsequent ones work perfectly fine though. This
> need to initialize the link via incoming ir is a bit problematic if
> you're using a device for transmit-only (e.g., and mceusb device
> hooked to a mythtv backend in the closet or something), as there would
> be a strong possibility of /dev/lirc0 never getting hooked up. I can
> think of a few workarounds, but none are particularly clean and/or
> automagic.
> 
> Not sure how palatable it is, but here it is:

I think it sounds pretty awful :)

I have another suggestion, let's keep the client register/unregister 
callbacks for decoders (but add a comment that they're only used for 
lirc). Then teach drivers/media/IR/ir-raw-event.c to keep track of the 
raw clients so that it can pass all pre-existing clients to newly added 
decoders.

I'll post two patches (compile tested only) in a few seconds to show 
what I mean.

-- 
David Härdeman
