Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6CJgxrm010014
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:42:59 -0400
Received: from vsmtp14.tin.it (vsmtp14.tin.it [212.216.176.118])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6CJgjV8015035
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:42:45 -0400
Received: from [192.168.3.11] (77.103.126.124) by vsmtp14.tin.it (8.0.016.5)
	(authenticated as aodetti@tin.it)
	id 486FB976006DA8C7 for video4linux-list@redhat.com;
	Sat, 12 Jul 2008 21:42:39 +0200
Message-ID: <487908CA.8000304@tiscali.it>
Date: Sat, 12 Jul 2008 20:40:58 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: prototype of a USB v4l2 driver?
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

Hi,

I would like to learn more in detail how a video driver works.
Basically in the last days I've looked at pwc to see why it is not so robust with mplayer.
I found something in the streaming ioctl calls.

As an exercise I would like to port it to the "best" and "more elegant" framework, reusing as much 
as possible the existing v4l2 framework are writing as little code as possible (e.g. using 
videobuf). And remove all the v4l1 code.

I would like to know which is the best USB driver to look at.
Which is the best USB driver that implements videobuf?

This is a good overview of a driver
http://lwn.net/Articles/203924/

I think vivi.c is an other good one.

Does anybody have any other good reference to look at?

Thanks for your help.

Cheers

Andrea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
