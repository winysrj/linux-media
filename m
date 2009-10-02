Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n92D4vBa031843
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 09:04:57 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n92D4ksR016796
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 09:04:48 -0400
Received: from partygirl.tmr.com (partygirl.tmr.com [127.0.0.1])
	by partygirl.tmr.com (8.14.2/8.14.2) with ESMTP id n92D4kD5024013
	for <video4linux-list@redhat.com>; Fri, 2 Oct 2009 09:04:46 -0400
Message-ID: <4AC5FA6E.2000201@tmr.com>
Date: Fri, 02 Oct 2009 09:04:46 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: video4linux M/L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Upgrading from FC4 to current Linux
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

I am looking for a video solution which works on recent Linux, like Fedora-11. 
Video used to be easy, plug in the capture device, install xawtv via rpm, and 
use. However, recent versions of Fedora simply don't work, even on the same 
hardware, due to /dev/dsp no longer being created and the applications like 
xawtv or tvtime still looking for it.

The people who will be using this are looking for hardware which is still made 
and sold new, and software which can be installed by a support person who can 
plug in cards (PCI preferred) or USB devices, and install rpms. I maintain the 
servers on Linux there, desktop support is unpaid (meaning I want a solution 
they can use themselves).

We looked at vlc, which seems to want channel frequencies in kHz rather than 
channels, mythtv, which requires a database their tech isn't able (or willing) 
to support, etc.

It seems that video has gone from "easy as Windows" 3-4 years ago to "insanely 
complex" according to to one person in that group who wanted an upgrade on his 
laptop. There is some pressure from Windows users to mandate Win7 as the 
desktop, which Linux users are rejecting.

The local cable is a mix of analog channels (for old TVs) and clear qam. The 
capture feeds from the monitor system are either S-video or three wire composite 
plus L-R audio. Any reasonable combination of cards (PCI best, PCIe acceptable), 
USB device, and application which can monitor/record would be fine, but the 
users are not going to type in kHz values, create channel tables, etc. They want 
something as easy to use as five years ago.

Any thoughts?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
