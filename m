Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5E4MCOZ023060
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 00:22:12 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5E4LnXl001630
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 00:21:49 -0400
From: Andy Walls <awalls@radix.net>
To: ivtv-devel@ivtvdriver.org, video4linux-list@redhat.com
Content-Type: text/plain
Date: Sat, 14 Jun 2008 00:17:46 -0400
Message-Id: <1213417066.19877.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: cx18: Fix unintended auto configurations in cx18-av-core
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

At

http://linuxtv.org/hg/~awalls/v4l-dvb/

I have just pushed a change to the cx18-av-core code so that accesses to
cx23418 av core that cause auto-configuration will be adjusted to
emulate the auto-configuration behavior of the cx25843. This fixes the
VBI displayed as rapidly changing B&W video at the top of the frame for
NTSC and probably other things as well.


The strategy I took of saving and restoring registers makes the change
less invasive to the cx18-av-core.c code.  I wasn't up for a rewrite of
the entire cx18-av-*c code.  Plus, fixes for the cx25840 module will
still be relatively easy to apply to the cx18-av-*c code without an
extensive rewrite.

-Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
