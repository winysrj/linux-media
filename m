Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62683 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0JVARY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 20:17:24 -0400
Subject: Re: [PATCH 0/3] Remaining patches in my queue for IR
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <20101020184047.GC15314@redhat.com>
References: <1287269790-17605-1-git-send-email-maximlevitsky@gmail.com>
	 <20101020184047.GC15314@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 02:17:20 +0200
Message-ID: <1287706640.12734.23.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2010-10-20 at 14:40 -0400, Jarod Wilson wrote:
> On Sun, Oct 17, 2010 at 12:56:27AM +0200, Maxim Levitsky wrote:
> > Hi,
> > 
> > This series is rebased on top of media_tree/staging/v2.6.37 only.
> > Really this time, sorry for cheating, last time :-)
> > 
> > The first patch like we agreed extends the raw packets.
> > It touches all drivers (except imon as it isn't a raw IR driver).
> > Code is compile tested with all drivers, 
> > and run tested with ENE and all receiver protocols
> > (except the streamzap rc5 flavour)
> > Since it also moves timeouts to lirc bridge, at least streazap driver
> > should have its timeout gap support removed. I am afraid to break the code
> > if I do so.
> 
> I've tested both mceusb and streamzap with this patchset included, don't
> see any ill side-effects. Only issue I really saw was that the raw event
> init call was added somewhat superfluously to a number of drivers -- the
> rawir struct its initializing was already kzalloc'd, so we're just
> needlessly re-zero'ing it out again. Its not bad for clarity's sake, but
> does add some unnecessary inefficiency.
Yes, I somewhat agree.

On the other hand, I had an idea to add a magic field to ir_raw_event to
guard against uninitialized uses.
(something like the struct scatterlist).

Don't know it that is worth it.
Or that I sound like a typical supporter of OOP style of abstracting
everything because sometime at the future there will be need to change
it..

Anyway, as Andy pointed, note that few drivers became broken due to that
patch because these don't initialize the ir_raw_event.

I will send a patch tomorrow (I was very busy this week).

Best regards,
	Maxim Levitsky

