Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FK0Ut2031942
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 16:00:30 -0400
Received: from m1.goneo.de (m1.goneo.de [82.100.220.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FK0GaC024844
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 16:00:16 -0400
From: Jan Frey <linux@janfrey.de>
To: video4linux-list@redhat.com
Date: Sun, 15 Jun 2008 21:58:47 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806152158.48344.linux@janfrey.de>
Cc: linux-dvb@linuxtv.org
Subject: HVR-1300 support lacking quality?
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

Hi all,

I've been a bit absent from this list recently and just checked the changes 
regarding v4l and dvb support of my HVR 1300 card. Actually I am a bit 
astonished that nothing really changed compared to a few months ago.
Please don't get me wrong, I absolutely don't want to offend anybody here - 
I really appreciate all the great work you are doing, but there is a few 
questions regarding HVR 1300 that come to my mind:

1. Why are the patches from http://linuxtv.org/hg/~rmcc/hvr-1300/ not 
included in the mainline? For me they enable usage of the HW MPEG encoder 
with MythTV and don't seem to introduce any problems.

2. I can't get DVB-T to work. All the modules load fine, scanning for 
channels fails, no channel can be tuned - no stations found. I tried to 
use dvbsnoop, only visible effect is the following line repeated in kernel 
log:

 cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000003)  

I think this has been reported earlier on this list.

3. The analog part of the card works only with some workaround in 
rc.sysinit: I have to unload all cx88 modules and reload them in order to 
get the analog tuner working. This has also been discussed on this list 
earlier. By googling I've read from various sources that the order of 
module loading makes a difference...


As mentioned above, this is not meant to be critics on your work, I'd just 
like to (re)-initiate some discussion on these topics and offer my help in 
debugging/testing of patches.

Thanks everybody!

Regards,
Jan

-- 
Jan Frey
linux [at] janfrey.de

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
