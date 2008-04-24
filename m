Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OISe5B011257
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:28:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OISTrg012786
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:28:29 -0400
Date: Thu, 24 Apr 2008 15:28:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux DVB <linux-dvb@linuxtv.org>, Linux and Kernel Video
	<video4linux-list@redhat.com>
Message-ID: <20080424152813.40aab7c4@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [RFC] Move hybrid tuners to common/tuners
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

During 2.6.24 and 2.6.25 cycle, it were noticed several issues on building
tuner drivers, after the hybrid patches. Mostly, this happened due to the fact
that now, those tuners are shared between DVB and V4L.

The proper solution were to move those tuners into common/tuners.

I finally found some time for a patch for it.

Since this kind of patch requires build testing with the in-kernel tree, I've
preferred to develop this one directly at -git. It is at [1]:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commit;h=b251551263a57d8ca518a21008f20dff29964cb9

This patch also do some rearrangements at Kconfig items and move saa7146 to
media/video (where all other hybrid designs are).

After this patch, a good cleanup would be to rename the Kconfig items, since
the namespace is very messy nowadays. Also, I didn't touch on some tuners that
are currently used only by DVB-only drivers. Probably, it would be a good idea
to move the other tuners capable of working on both analog and digital modes
(like mt2060) also to common/tuners, to use the same convention for
all tuners.

Please check and test. If ok, it would be good to merge it during 2.6.26 window.

Cheers,
Mauro

[1] as a plus, -git works very well with "move" patches. I've started working
on this before merging a few patches that changed tea5767 and tea5761. Just
poping the move patch from stgit stack, applying the newer ones and pushing
again solved all conflicts. With Mercurial, I would probably need to re-do the
move for the affected drivers.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
