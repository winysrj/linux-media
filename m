Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:42123 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758313AbZAQRmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 12:42:15 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: CityK <cityk@rogers.com>, Michael Krufky <mkrufky@linuxtv.org>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <200901171720.03890.hverkuil@xs4all.nl>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	 <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com>
	 <200901171720.03890.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 18:42:24 +0100
Message-Id: <1232214144.2702.77.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 17.01.2009, 17:20 +0100 schrieb Hans Verkuil:
> On Friday 16 January 2009 04:20:02 CityK wrote:
> > CityK wrote:
> > > If you had meant taking Hans' source and applying your "hack" patch
> > > to them, building and then proceeding with the modprobe steps, the
> > > answer is that I haven't tried yet. Will test -- might not be
> > > tonight though, as I have some other things that need attending
> > > too.
> >
> > Okay, I lied -- given that building is really a background process, I
> > found time ... i.e. I cleaned up in the kitchen while the system
> > compiled ... kneel before me world, as I am a master multi-tasker!
> >
> > >> Anyway, if the previous workaround works after Hans' changes, then
> > >> I think his changes should be merged -- even though it doesnt fix
> > >> ATSC115, it is indeed a step into the right direction.
> > >>
> > >> If the ATSC115 hack-fix patch doesn't apply anymore, please let me
> > >> know -- I'll respin it.
> >
> > The "hack-fix" patch applies cleanly against Hans' sources. However,
> > the test results are negative -- the previous workaround ("modprobe
> > tuner -r and "modprobe tuner") fails to produce the desired result.
> 
> If you try to run 'modprobe -r tuner' when the saa7134 module build from 
> my sources is loaded, then that should not work since saa7134 increases 
> the use-count of the tuner module preventing it from being unloaded.
> 
> If you can do this, then that suggests that you are perhaps not using my 
> modified driver at all.
> 
> BTW, I've asked Mauro to pull from my tree 
> (www.linuxtv.org/hg/~hverkuil/v4l-dvb) which contains the converted 
> saa7134 and saa6752hs drivers. It's definitely something that needs to 
> be done regardless.

Hans, Mauro has pulled them in already.

For my report for the old issue with the tda9987 not loaded for the
md7134 card=12 with eeprom tuner detection and all the types with
FMD1216ME MK3 hybrid subsumed there beside the older ones with analog
only tuners (CTX917/918/925triple/946mpeg/921cardbus), the users must
just unload the saa7134 and tuner modules and then load tda9887 and
tuner before the saa7134 for now.

> Regards,
> 
> 	Hans
> 
> > In fact, as similar to the results reported in the previous message,
> > performing such action produces no result in dmesg.
> 

Cheers,
Hermann


