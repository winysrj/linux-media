Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:48480 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0FGTAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:00:07 -0400
Date: Mon, 7 Jun 2010 21:00:03 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/4] ir-core: move decoding state to ir_raw_event_ctrl
Message-ID: <20100607190003.GC19390@hardeman.nu>
References: <20100424210843.11570.82007.stgit@localhost.localdomain>
 <20100424211411.11570.2189.stgit@localhost.localdomain>
 <4BDF2B45.9060806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BDF2B45.9060806@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 03, 2010 at 05:00:05PM -0300, Mauro Carvalho Chehab wrote:
> David Härdeman wrote:
> > This patch moves the state from each raw decoder into the
> > ir_raw_event_ctrl struct.
> > 
> > This allows the removal of code like this:
> > 
> >         spin_lock(&decoder_lock);
> >         list_for_each_entry(data, &decoder_list, list) {
> >                 if (data->ir_dev == ir_dev)
> >                         break;
> >         }
> >         spin_unlock(&decoder_lock);
> >         return data;
> > 
> > which is currently run for each decoder on each event in order
> > to get the client-specific decoding state data.
> > 
> > In addition, ir decoding modules and ir driver module load
> > order is now independent. Centralizing the data also allows
> > for a nice code reduction of about 30% per raw decoder as
> > client lists and client registration callbacks are no longer
> > necessary.
> 
> The registration callbacks will likely still be needed by lirc,
> as you need to create/delete lirc_dev interfaces, when the module
> is registered, but I might be wrong. It would be interesting to
> add lirc_dev first, in order to be sure about the better interfaces
> for it.

Or the lirc_dev patch can add whatever interfaces it needs. Anyway, the 
current interfaces are not good enough since it'll break if lirc_dev is 
loaded after the hardware modules.

> Also, from one side, you reduced the code size, but, on the other hand,
> you've increased the memory usage, as now the protocol data will be
> stored even for protocols that weren't compiled/loaded. 

In <4BBF3309.6020909@infradead.org>, Mauro Carvalho Chehab wrote:
>> Andy Walls wrote:
>>> Encoding pulse vs space with a negative sign, even if now hidden 
>>> with macros, is still just using a sign instead of a boolean.  
>>> Memory in modern computers (and now microcontrollers) is cheap and 
>>> only getting cheaper.  Don't give up readability, flexibility, or 
>>> mainatainability, for the sake of saving memory.
>
> That was my point since the beginning: the amount of saved memory 
> doesn't justify the lack of readability.

Are you worried about memory usage now?

> Probably, the code size savings are big enough to justify the runtime 
> memory footprint, at least with the current decoders. Not sure how big 
> this will become when we add lirc_dev and other decoders that might be 
> missing.

Right now, the "reasonable default" is a user machine with one hardware 
decoder and with all of the rc-core decoders loaded (cause that's how 
his/her distro will set it up).  For that machine, the patch will save a 
lot of memory, not waste it (~380 lines less code...I'll assure you it's 
a net gain).

In addition, random module load order is currently broken (try loading 
decoders first and hardware later and you'll see).  With this patch, it 
works again.

Anyway, I'll post a new patch series this evening and then we can go 
back to our regular arguing :)

-- 
David Härdeman
