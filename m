Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733Ab0FISSP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jun 2010 14:18:15 -0400
Date: Wed, 9 Jun 2010 14:15:06 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
Message-ID: <20100609181506.GO16638@redhat.com>
References: <20100424210843.11570.82007.stgit@localhost.localdomain>
 <20100424211411.11570.2189.stgit@localhost.localdomain>
 <4BDF2B45.9060806@redhat.com>
 <20100607190003.GC19390@hardeman.nu>
 <20100607201530.GG16638@redhat.com>
 <20100608175017.GC5181@hardeman.nu>
 <AANLkTimuYkKzDPvtnrWKoT8sh1H9paPBQQNmYWOT7-R2@mail.gmail.com>
 <20100609132908.GM16638@redhat.com>
 <20100609175621.GA19620@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100609175621.GA19620@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 09, 2010 at 07:56:21PM +0200, David Härdeman wrote:
> On Wed, Jun 09, 2010 at 09:29:08AM -0400, Jarod Wilson wrote:
> > On Tue, Jun 08, 2010 at 11:46:36PM -0400, Jarod Wilson wrote:
> > > On Tue, Jun 8, 2010 at 1:50 PM, David Härdeman <david@hardeman.nu> wrote:
> > > > b) Mauro mentioned in <4BDF28C0.4060102@redhat.com> that:
> > > >
> > > >        I liked the idea of your redesign, but I didn't like the removal
> > > >        of a per-decoder sysfs entry. As already discussed, there are
> > > >        cases where we'll need a per-decoder sysfs entry (lirc_dev is
> > > >        probably one of those cases - also Jarod's imon driver is
> > > >        currently implementing a modprobe parameter that needs to be
> > > >        moved to the driver).
> > > >
> > > >   could you please confirm if your lirc and/or imon drivers would be
> > > >   negatively affected by the proposed patches?
> > > 
> > > Will do so once I get them wedged in on top.
> > 
> > Got it all merged and compiling, but not yet runtime tested. Compiling
> > alone sheds some light on things though...
> > 
> > So this definitely negatively impacts my ir-core-to-lirc_dev
> > (ir-lirc-codec.c) bridge driver, as it was doing the lirc_dev device
> > registration work in its register function. However, if (after your
> > patchset) we add a new pair of callbacks replacing raw_register and
> > raw_unregister, which are optional, that work could be done there instead,
> > so I don't think this is an insurmountable obstacle for the lirc bits.
> 
> While I'm not sure exactly what callbacks you're suggesting,

Essentially:

.setup_other_crap
.tear_down_other_crap

...which in the ir-lirc-codec case, register ir-lirc-codec for a specific
hardware receiver as an lirc_dev client, and conversely, tear it down.

> it still 
> sounds like the callbacks would have the exact same problems that the 
> current code has (i.e. the decoder will be blissfully unaware of 
> hardware which exists before the decoder is loaded). Right?

In my head, this was going to work out, but you're correct, I still have
the exact same problem -- its not in ir_raw_handler_list yet when
ir_raw_event_register runs, and thus the callback never fires, so lirc_dev
never actually gets wired up to ir-lirc-codec. It now knows about the lirc
decoder, but its completely useless. Narf.

> > As for the imon driver, the modprobe parameter in question (iirc) was
> > already removed from the driver, as its functionality is replaced by
> > implementing a change_protocol callback. However, there's a request to
> > add it (or something like it) back to the driver to allow disabling the
> > IR part altogether, and there are a few other modparams that might be
> > better suited as sysfs entries. However, its actually not relevant to the
> > case of registering raw protocol handlers, as the imon devices do their
> > decoding in hardware. I can see the possibility for protocol-specific
> > knobs in sysfs though. But I think the same optional callbacks I'd use to
> > keep the lirc bits working could also be used for this. Can't think of a
> > good name for these yet, probably need more coffee first... ;)
> 
> But those sysfs entries wouldn't be 
> per-decoder-per-hardware-device....they'd just be 
> per-hardware-device...right?

Most likely. But I think its possible someone would want to want to tweak
some parameter that is both protocol and hardware device specific. Just
sheer speculation at the moment though, I don't have a concrete example.

-- 
Jarod Wilson
jarod@redhat.com

