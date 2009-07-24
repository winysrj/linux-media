Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZGXVu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 17:50:27 -0400
Date: Fri, 24 Jul 2009 14:48:06 -0700
From: Greg KH <gregkh@suse.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Message-ID: <20090724214806.GA7200@suse.de>
References: <20090724144020.3f5a6bb7@pedra.chehab.org>
 <20090724205015.GA5889@suse.de>
 <829197380907241432m32bb6a51wc9b9bacce86e0c75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <829197380907241432m32bb6a51wc9b9bacce86e0c75@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 24, 2009 at 05:32:23PM -0400, Devin Heitmueller wrote:
> On Fri, Jul 24, 2009 at 4:50 PM, Greg KH<gregkh@suse.de> wrote:
> > On Fri, Jul 24, 2009 at 02:40:20PM -0300, Mauro Carvalho Chehab wrote:
> >> Linus,
> >>
> >> Please pull from:
> >>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus
> >>
> >> This series adds a new gscpca sub-driver for sn9c20x webcams. There are several
> >> popular webcam models supported by those Sonix/Microdia chips.
> >>
> >> Greg can remove some linuxdriverproject.org requests from the project Wiki
> >> after this merge ;) Greg, for the USB ID details, you could take a look at
> >> Documentation/video4linux/gspca.txt changes (32 USB ID's added) or at
> >> http://linuxtv.org/wiki/index.php/Gspca. With this series, gspca alone supports
> >> 660 different webcam models.
> >
> > That's great to see.  As it's a wiki, could someone who knows these ids
> > go through and mark off those devices on the linuxdriverproject.org
> > site?
> >
> > thanks,
> >
> > greg k-h
> 
> I looked at it a few weeks ago, and the V4L section is in pretty bad
> shape.  Lots of the devices in "DriversNeeded" are now supported.
> 
> http://linuxdriverproject.org/twiki/bin/view/Main/DriversNeeded?sortcol=table;up=#Video_for_Linux_devices_Input
> 
> I'm going to try to take a pass over it in the next few days and do
> some cleanup.

That would be much appreciated, thanks.

greg k-h
