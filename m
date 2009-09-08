Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n88IcOOI010843
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 14:38:24 -0400
Received: from mail-bw0-f209.google.com (mail-bw0-f209.google.com
	[209.85.218.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n88Ic9dC023900
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 14:38:11 -0400
Received: by bwz5 with SMTP id 5so2818237bwz.3
	for <video4linux-list@redhat.com>; Tue, 08 Sep 2009 11:38:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909081428.05635.gene.heskett@verizon.net>
References: <alpine.LRH.2.00.0909081237170.4833@rray2>
	<200909081428.05635.gene.heskett@verizon.net>
Date: Tue, 8 Sep 2009 14:38:08 -0400
Message-ID: <829197380909081138x5d38f034ne8b7faff3288096@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Gene Heskett <gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: NTSC/ATSC device recommendation
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

On Tue, Sep 8, 2009 at 2:28 PM, Gene Heskett<gene.heskett@verizon.net> wrote:
> Software in linux to support tv in general sucks.  You must build the latest
> kaffeine to get it to sort of work with digital.  Because I have more than
> one sound system here, mythtv has great video but no sound, and as near as I
> can tell, no facility to make sure its using the right mixer.

With regards to Kaffeine, it depends on your distro.  I added support
for the ATSC channel scanning over a year ago now, so it has managed
to make its way into the distros.  And the new Kaffeine that is
packaged with Ubuntu Karmic (1.0 pre1) works MUCH better with playback
of high-bandwidth ATSC streams such as CBS-HD.  So if you are using
Kaffeine and get choppy playback on some channels, I would definitely
recommend getting the latest version.

> tvtime, for NTSC, Just Works(TM) but the author has not to my knowledge, made
> any motions toward ATSC support.  Unforch, here in the states, NTSC is
> deprecated by FCC edict.

It's worth noting that tvtime has no support for digital at all.  It
is only going to support raw analog video capture devices.  Hence,
there is no support forthcoming for DVB, ATSC, QAM, or even products
that have an onboard MPEG encoder.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
