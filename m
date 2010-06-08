Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52837 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab0FHRuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 13:50:22 -0400
Date: Tue, 8 Jun 2010 19:50:17 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
Message-ID: <20100608175017.GC5181@hardeman.nu>
References: <20100424210843.11570.82007.stgit@localhost.localdomain>
 <20100424211411.11570.2189.stgit@localhost.localdomain>
 <4BDF2B45.9060806@redhat.com>
 <20100607190003.GC19390@hardeman.nu>
 <20100607201530.GG16638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100607201530.GG16638@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 07, 2010 at 04:15:30PM -0400, Jarod Wilson wrote:
> On Mon, Jun 07, 2010 at 09:00:03PM +0200, David H�rdeman wrote:
> > On Mon, May 03, 2010 at 05:00:05PM -0300, Mauro Carvalho Chehab wrote:
> > > David H�rdeman wrote:
> > > > This patch moves the state from each raw decoder into the
> > > > ir_raw_event_ctrl struct.
> > > > 
> > > > This allows the removal of code like this:
> > > > 
> > > >         spin_lock(&decoder_lock);
> > > >         list_for_each_entry(data, &decoder_list, list) {
> > > >                 if (data->ir_dev == ir_dev)
> > > >                         break;
> > > >         }
> > > >         spin_unlock(&decoder_lock);
> > > >         return data;
> > > > 
> > > > which is currently run for each decoder on each event in order
> > > > to get the client-specific decoding state data.
> > > > 
> > > > In addition, ir decoding modules and ir driver module load
> > > > order is now independent. Centralizing the data also allows
> > > > for a nice code reduction of about 30% per raw decoder as
> > > > client lists and client registration callbacks are no longer
> > > > necessary.
> > > 
> > > The registration callbacks will likely still be needed by lirc,
> > > as you need to create/delete lirc_dev interfaces, when the module
> > > is registered, but I might be wrong. It would be interesting to
> > > add lirc_dev first, in order to be sure about the better interfaces
> > > for it.
> > 
> > Or the lirc_dev patch can add whatever interfaces it needs. Anyway, the 
> > current interfaces are not good enough since it'll break if lirc_dev is 
> > loaded after the hardware modules.
> 
> This is something I've been meaning to mention myself. On system boot, if
> an mceusb device is connected, it pretty regularly only has the NEC
> decoder available to use. I have to reload mceusb, or make sure ir-core is
> explicitly loaded, wait a bit, then load mceusb, if I want to have all of
> the protocol handlers available -- which includes the needed-by-default
> rc6 one. I've only briefly tinkered with trying to fix it, sounds like you
> may already have fixage within this patchset.

The problem is that without the patchset, each decoder is expected to 
carry it's own list of datastructures for each hardware receiver.  
Hardware receiver addition/removal is signalled through a callback to 
the decoder, but the callback will (naturally) not be invoked if the 
hardware driver is already loaded when the decoder is. So loading a 
decoder "late" or reloading a decoder will mean that it doesn't know 
about pre-existing hardware.

> > In addition, random module load order is currently broken (try loading 
> > decoders first and hardware later and you'll see).  With this patch, it 
> > works again.
> 
> Want.

Then please help me with two things:

a) Test the patches I just sent (especially 6/8 and 7/8, they should
   be independent from the rest)

b) Mauro mentioned in <4BDF28C0.4060102@redhat.com> that:

	I liked the idea of your redesign, but I didn't like the removal
	of a per-decoder sysfs entry. As already discussed, there are
	cases where we'll need a per-decoder sysfs entry (lirc_dev is
	probably one of those cases - also Jarod's imon driver is
	currently implementing a modprobe parameter that needs to be
	moved to the driver).

   could you please confirm if your lirc and/or imon drivers would be
   negatively affected by the proposed patches?


-- 
David H�rdeman
