Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab0IJNVj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:21:39 -0400
Date: Fri, 10 Sep 2010 09:21:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	lirc-list@lists.sourceforge.net,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8 V5] Many fixes for in-kernel decoding and for the ENE
 driver
Message-ID: <20100910132125.GE13554@redhat.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
 <4C8805FA.3060102@infradead.org>
 <20100908224227.GL22323@redhat.com>
 <AANLkTikBVSYpD_+qomCad-OvXg6CRam4b01wSBV-pNw8@mail.gmail.com>
 <20100910020129.GA26845@redhat.com>
 <1284107723.3498.21.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284107723.3498.21.camel@maxim-laptop>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, Sep 10, 2010 at 11:35:23AM +0300, Maxim Levitsky wrote:
> On Thu, 2010-09-09 at 22:01 -0400, Jarod Wilson wrote: 
> > On Thu, Sep 09, 2010 at 12:34:27AM -0400, Jarod Wilson wrote:
> > ...
> > > >> For now, I've applied patches 3, 4 and 5, as it is nice to have Jarod's review also.
> > > >
> > > > I've finally got them all applied atop current media_tree staging/v2.6.37,
> > > > though none of the streamzap bits in patch 7 are applicable any longer.
> > > > Will try to get through looking and commenting (and testing) of the rest
> > > > of them tonight.
> > > 
> > > Also had to make a minor addition to the rc5-sz decoder (same change
> > > as in the other decoders). Almost have all the requisite test kernels
> > > for David's, Maxim's and Dmitry's patchsets built and installed, wish
> > > my laptop was faster... Probably would have been faster to use a lab
> > > box and copy data over. Oh well. So functional testing to hopefully
> > > commence tomorrow morning.
> > 
> > Wuff. None of the three builds is at all stable on my laptop, but I can't
> > actually point the finger at any of the three patchsets, since I'm getting
> > spontaneous lockups doing nothing at all before even plugging in a
> > receiver. I did however get occasional periods of a non-panicking (not
> > starting X seems to help a lot). Initial results:
> > 
> 
> Btw, my printk blackbox patch could help you a lot.
> I can't count how many times it helped me.
> I just enable softlockup, hardlockup, and nmi watchdog, and let system
> panic on oopses, and reboot. Or if you have hardware reboot button, you
> can just use it. The point is that most BIOSES don't clear the ram, and
> I take advantage of that.

Interesting. I was thinking perhaps I'd give a go at trying kdump on my
laptop, but I've had pretty mixed results with kdump working correctly on
random kernels (generally works quite well in RHEL, notsomuch in Fedora).

My hope is that this is something already fixed in later Linus' kernels,
so I'll try a current Linus snap before I try looking any deeper. I'll
file this away for consideration though!


-- 
Jarod Wilson
jarod@redhat.com

