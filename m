Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4BElavf018454
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 10:47:37 -0400
Received: from smtp9.trip.net (smtp9.trip.net [216.139.64.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4BElKHf008997
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 10:47:20 -0400
Received: from lhost.ldomain (pool-72-89-142-51.nycmny.fios.verizon.net
	[72.89.142.51]) (authenticated bits=0)
	by smtp9.trip.net (8.14.1/8.14.1) with ESMTP id n4BElJtg017001
	for <video4linux-list@redhat.com>; Mon, 11 May 2009 09:47:19 -0500 (CDT)
Date: Mon, 11 May 2009 10:45:46 -0400
From: MK <halfcountplus@intergate.com>
To: video4linux-list@redhat.com
Message-Id: <1242053146.1729.1@lhost.ldomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: working on webcam driver
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


Hi.  I'm a fledgling C programmer who just started work on a usb webcam 
driver in order to learn about kernel programming.  So far, all I have 
done is gotten the device to register, and iterated through the 
available interfaces (there are nine with three endpoints each, an iso, 
an interrupt, and a bulk in).  

Anyway, before I proceed, I thought I should clarify for myself "the 
big picture" of what I am doing.  I do not have a webcam that works 
under linux, so the whole apparatus is fuzzy; I am under the impression 
that the kernel modules work with the (seperate) video4linux subsystem? 
I have the USB Video Class Specifications and am busy reading that to 
find out how the camera itself operates, but vis. the linux end of 
things, can you point me to any technical documentation that might 
clarify what the driver will be expected to do?  At this point, I am 
assuming I will have to deliver a device node, but I don't know what 
calls will be made to it etc.

Help and advice is much appreciated.  Of course, best of all would be a 
few general pointers from someone who has actually done this before...

Sincerely, Mark Eriksen

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
