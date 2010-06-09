Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:60911 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab0FIR4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 13:56:25 -0400
Date: Wed, 9 Jun 2010 19:56:21 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
Message-ID: <20100609175621.GA19620@hardeman.nu>
References: <20100424210843.11570.82007.stgit@localhost.localdomain>
 <20100424211411.11570.2189.stgit@localhost.localdomain>
 <4BDF2B45.9060806@redhat.com>
 <20100607190003.GC19390@hardeman.nu>
 <20100607201530.GG16638@redhat.com>
 <20100608175017.GC5181@hardeman.nu>
 <AANLkTimuYkKzDPvtnrWKoT8sh1H9paPBQQNmYWOT7-R2@mail.gmail.com>
 <20100609132908.GM16638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100609132908.GM16638@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 09, 2010 at 09:29:08AM -0400, Jarod Wilson wrote:
> On Tue, Jun 08, 2010 at 11:46:36PM -0400, Jarod Wilson wrote:
> > On Tue, Jun 8, 2010 at 1:50 PM, David Härdeman <david@hardeman.nu> wrote:
> > > b) Mauro mentioned in <4BDF28C0.4060102@redhat.com> that:
> > >
> > >        I liked the idea of your redesign, but I didn't like the removal
> > >        of a per-decoder sysfs entry. As already discussed, there are
> > >        cases where we'll need a per-decoder sysfs entry (lirc_dev is
> > >        probably one of those cases - also Jarod's imon driver is
> > >        currently implementing a modprobe parameter that needs to be
> > >        moved to the driver).
> > >
> > >   could you please confirm if your lirc and/or imon drivers would be
> > >   negatively affected by the proposed patches?
> > 
> > Will do so once I get them wedged in on top.
> 
> Got it all merged and compiling, but not yet runtime tested. Compiling
> alone sheds some light on things though...
> 
> So this definitely negatively impacts my ir-core-to-lirc_dev
> (ir-lirc-codec.c) bridge driver, as it was doing the lirc_dev device
> registration work in its register function. However, if (after your
> patchset) we add a new pair of callbacks replacing raw_register and
> raw_unregister, which are optional, that work could be done there instead,
> so I don't think this is an insurmountable obstacle for the lirc bits.

While I'm not sure exactly what callbacks you're suggesting, it still 
sounds like the callbacks would have the exact same problems that the 
current code has (i.e. the decoder will be blissfully unaware of 
hardware which exists before the decoder is loaded). Right?

> As for the imon driver, the modprobe parameter in question (iirc) was
> already removed from the driver, as its functionality is replaced by
> implementing a change_protocol callback. However, there's a request to
> add it (or something like it) back to the driver to allow disabling the
> IR part altogether, and there are a few other modparams that might be
> better suited as sysfs entries. However, its actually not relevant to the
> case of registering raw protocol handlers, as the imon devices do their
> decoding in hardware. I can see the possibility for protocol-specific
> knobs in sysfs though. But I think the same optional callbacks I'd use to
> keep the lirc bits working could also be used for this. Can't think of a
> good name for these yet, probably need more coffee first... ;)

But those sysfs entries wouldn't be 
per-decoder-per-hardware-device....they'd just be 
per-hardware-device...right?

-- 
David Härdeman
