Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3HEntcW006374
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 10:49:55 -0400
Received: from QMTA10.westchester.pa.mail.comcast.net
	(qmta10.westchester.pa.mail.comcast.net [76.96.62.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3HElAVq023293
	for <video4linux-list@redhat.com>; Fri, 17 Apr 2009 10:47:10 -0400
Date: Fri, 17 Apr 2009 09:46:49 -0500 (CDT)
From: rray_1@comcast.net
To: video4linux-list@redhat.com
Message-ID: <alpine.LRH.2.00.0904170940260.7851@rray2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Subject: Adding memory to systems screws up playback
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

I increased my system memory from 2GB to 4GB and things are not well
System board is Intel DG965OT
Has 4 memory slots
I've had the machine for a couple of years with 2 1GB dimms in slots 1 & 3
I added 2 1GB dimms in slots 2 & 4
As far as I can tell everything is working OK except for playback to LML33

I removed the original dimms and put the new ones in slots 1 & 3, 2GB
Lavplay works OK
Put original dimms in slots 2 & 4 (4GB total) and lavplay fails

I'm running CentOS 5.2 with kernel-2.6.18-92.1.22.el5.centos.plus.x86_64

$ lavplay -p H foo.avi
lavplay1.9.0
lavtools version 1.9.0
**ERROR: [lavplay] Error syncing on a buffer: Timer expired


Dmesg shows

LML33[0]: zoran_open(lavplay, pid=[14223]), users(-)=0
LML33[0]: jpg_sync() - timeout: codec isr=0x07
LML33[0]: zoran_close(lavplay, pid=[14223]), users(+)=1


Richard

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
