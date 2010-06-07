Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0FGUSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 16:18:16 -0400
Date: Mon, 7 Jun 2010 16:15:30 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
Message-ID: <20100607201530.GG16638@redhat.com>
References: <20100424210843.11570.82007.stgit@localhost.localdomain>
 <20100424211411.11570.2189.stgit@localhost.localdomain>
 <4BDF2B45.9060806@redhat.com>
 <20100607190003.GC19390@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100607190003.GC19390@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 07, 2010 at 09:00:03PM +0200, David Härdeman wrote:
> On Mon, May 03, 2010 at 05:00:05PM -0300, Mauro Carvalho Chehab wrote:
> > David Härdeman wrote:
> > > This patch moves the state from each raw decoder into the
> > > ir_raw_event_ctrl struct.
> > > 
> > > This allows the removal of code like this:
> > > 
> > >         spin_lock(&decoder_lock);
> > >         list_for_each_entry(data, &decoder_list, list) {
> > >                 if (data->ir_dev == ir_dev)
> > >                         break;
> > >         }
> > >         spin_unlock(&decoder_lock);
> > >         return data;
> > > 
> > > which is currently run for each decoder on each event in order
> > > to get the client-specific decoding state data.
> > > 
> > > In addition, ir decoding modules and ir driver module load
> > > order is now independent. Centralizing the data also allows
> > > for a nice code reduction of about 30% per raw decoder as
> > > client lists and client registration callbacks are no longer
> > > necessary.
> > 
> > The registration callbacks will likely still be needed by lirc,
> > as you need to create/delete lirc_dev interfaces, when the module
> > is registered, but I might be wrong. It would be interesting to
> > add lirc_dev first, in order to be sure about the better interfaces
> > for it.
> 
> Or the lirc_dev patch can add whatever interfaces it needs. Anyway, the 
> current interfaces are not good enough since it'll break if lirc_dev is 
> loaded after the hardware modules.

This is something I've been meaning to mention myself. On system boot, if
an mceusb device is connected, it pretty regularly only has the NEC
decoder available to use. I have to reload mceusb, or make sure ir-core is
explicitly loaded, wait a bit, then load mceusb, if I want to have all of
the protocol handlers available -- which includes the needed-by-default
rc6 one. I've only briefly tinkered with trying to fix it, sounds like you
may already have fixage within this patchset.

...
> In addition, random module load order is currently broken (try loading 
> decoders first and hardware later and you'll see).  With this patch, it 
> works again.

Want.

> Anyway, I'll post a new patch series this evening and then we can go 
> back to our regular arguing :)

Hey, at least we're making progress too! :)

-- 
Jarod Wilson
jarod@redhat.com

