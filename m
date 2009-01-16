Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZAPDit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 22:38:49 -0500
Date: Fri, 16 Jan 2009 01:38:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: CityK <cityk@rogers.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	V4L <video4linux-list@redhat.com>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090116013813.23d45af8@pedra.chehab.org>
In-Reply-To: <496FFCE2.8010902@rogers.com>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496FE555.7090405@rogers.com>
	<496FFCE2.8010902@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Jan 2009 22:20:02 -0500
CityK <cityk@rogers.com> wrote:

> CityK wrote:
> > If you had meant taking Hans' source and applying your "hack" patch to
> > them, building and then proceeding with the modprobe steps, the answer
> > is that I haven't tried yet. Will test -- might not be tonight though,
> > as I have some other things that need attending too.
> >   
> 
> Okay, I lied -- given that building is really a background process, I
> found time ... i.e. I cleaned up in the kitchen while the system
> compiled ... kneel before me world, as I am a master multi-tasker!
> 
> >> Anyway, if the previous workaround works after Hans' changes, then I
> >> think his changes should be merged -- even though it doesnt fix ATSC115,
> >> it is indeed a step into the right direction.
> >>
> >> If the ATSC115 hack-fix patch doesn't apply anymore, please let me know
> >> -- I'll respin it.
> >>     
> 
> The "hack-fix" patch applies cleanly against Hans' sources. However, the
> test results are negative -- the previous workaround ("modprobe tuner -r
> and "modprobe tuner") fails to produce the desired result. In fact, as
> similar to the results reported in the previous message, performing such
> action produces no result in dmesg.

Such workarounds won't work anymore. If his patch is correct, the behaviour
should be deterministic. Could you please enable the debug messages and probe
cx88 with i2c_scan=1? Please also post the previous dmesg.

Cheers,
Mauro
