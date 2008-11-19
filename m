Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJ5EcAU030571
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 00:14:38 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJ5DbWE023541
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 00:13:37 -0500
From: Andy Walls <awalls@radix.net>
To: ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org,
	linux-dvb@linuxtv.org, video4linux-list@redhat.com
Content-Type: text/plain
Date: Wed, 19 Nov 2008 00:10:37 -0500
Message-Id: <1227071437.3117.42.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: cx18: Extensive interrupt and buffer handling changes need test
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

cx18 driver users:

I have implemented quite a few cx18 driver changes in my current
experimental repo at

http://linuxtv.org/hg/~awalls/cx18-bugfix

The goal behind these changes is to fix problems with simultaneous
analog and digital capture causing the driver to quit after a while.
And to fix related problems with buffers getting lost and falling out of
the driver<->firmware transfer rotation.

To achieve that result, I had to do extensive rework of how interrupts
were handled and some buffer handling tweaks.  I'm looking for (brave)
testers to give this stuff a try, or an inspection, before I ask Mauro
to pull it.  I also plan to do testing on my other two machines in a day
or two.

Please test the debug parameter with at least info and warn set:

# modprobe cx18 debug=3


I am especially interested in


1. How often you get messages like the following on your system?

cx18-0 warning: Possibly falling behind: CPU self-ack'ed our incoming CPU to EPU mailbox (sequence no. nnnn)

I need to get a feel for if I need to have the cx18 driver not request a
shared IRQ line for most user applications.

On my system where irq balance/migration is turned off, and the HVR-1600
shares an interrupt with the SATA controller, I get them quite a bit
doing simultaneous analog and digital capture with MythTV (I've
approximated a busy, single CPU machine with that setup).

BTW, the current cx18 driver software processes these self-ack'ed and
potentially incoherent mailboxes which the firmware has timed out and
potentially started to overwrite.  This change is just nice enough to
tell you about them, and it also does something more robust than just
blindly process them. :)


2. If the cx18 driver still works on older machines?

I got rid of PCI MMIO read retries, as they never seemed to do anything
useful and wasted time.  I needed to get the irq top half handler
timeline down to as little time as possible.  PCI MMIO write retries
still occur, because those actually get things to work in older
machines, AFAICT.

I will also be testing in my one older machine later this week.


Thanks.

Regards,
Andy

N.B. If replying to this message, you may wish to prune list email
addresses for lists for which you are not subscribed.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
