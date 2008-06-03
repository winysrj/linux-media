Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53F4vYu031922
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 11:04:57 -0400
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.121])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53F4eI6029767
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 11:04:40 -0400
Date: Tue, 3 Jun 2008 10:04:33 -0500
From: David Engel <david@istwok.net>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080603150433.GA30532@opus.istwok.net>
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
	<37219a840806010018m342ff1bh394248e62e0a8807@mail.gmail.com>
	<20080601190328.GA23388@opus.istwok.net>
	<37219a840806011210h6c7b55b0tc4bcfec1bcf3ad9b@mail.gmail.com>
	<20080601205522.GA2793@opus.istwok.net>
	<37219a840806021309x516f204ep8b25d8a730c4f0e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840806021309x516f204ep8b25d8a730c4f0e0@mail.gmail.com>
Cc: video4linux-list@redhat.com, Jason Pontious <jpontious@gmail.com>
Subject: Re: Kworld 115-No Analog Channels
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, Jun 02, 2008 at 04:09:12PM -0400, Michael Krufky wrote:
> On Sun, Jun 1, 2008 at 4:55 PM, David Engel <david@istwok.net> wrote:
> > The tuner is detected this time and analog capture works.
> 
> The fact that reloading tuner.ko confirms my suspicion --
> 
> In the case of the ATSC110 / ATSC115, we can't attach the tuner client
> module until after the NXT2004 has been initialized with its i2c gate
> left in open state.
> 
> If you unload all v4l/dvb drivers and modprobe saa7134, I believe this
> will work properly, since the demod has already been initialized once,
> with the gate left open by default.

This jives with what I saw in further testing.  After it worked once,
it would continue to work across all sorts of module reloads.  I
thought there was one time it didn't continue to work, though, but I
could never reproduce it.

> So, that's a workaround to your problem.  When I find some spare time,
> I'll investigate into what changed in 2.6.25 that led to this issue.
> This is *not* the same issue that Hermann described in his mail.

Thanks.  It would be very nice to get this fixed.  FWIW, I just tried
unloading and reloading tuner/tuner-simple on my system with 2 ATSC
115s and 2 PVR x50s.  All tuners were detected for the first time I
can remember.  The PVR x50 tuners were always detected but no more
than one of the ATSC 115 tuners was ever detected before.

David
-- 
David Engel
david@istwok.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
