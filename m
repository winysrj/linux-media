Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m21K0dBD017167
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 15:00:39 -0500
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m21K07Jc001379
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 15:00:08 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JVXsI-00022g-Is
	for video4linux-list@redhat.com; Sat, 01 Mar 2008 20:00:02 +0000
Received: from td9091a5f.pool.terralink.de ([217.9.26.95])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sat, 01 Mar 2008 20:00:02 +0000
Received: from Peter.Nabbefeld by td9091a5f.pool.terralink.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sat, 01 Mar 2008 20:00:02 +0000
To: video4linux-list@redhat.com
From: Peter Nabbefeld <Peter.Nabbefeld@gmx.de>
Date: Sat, 01 Mar 2008 23:00:43 +0100
Message-ID: <fqccdj$flf$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Problems with microdia webcam
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


Hello!

I'm new to video4linux, and I've got a "0c45:624e Microdia" webcam. I've 
already installed the microdia driver from google newsgroup, /dev/v4l 
and /dev/video0 exist.

I've tried to use camorama, vidcat, xsane. Camorama freezes, vidcat with 
default size says "VIDIOCMCAPTURE: Resource temporarily unavailable". 
Calling vidcat with "vidcat -d /dev/video0 -s 640x480" seems at least to 
wait for picture data, but nothing happens. Xsane does detect my camera, 
but when I try to "scan", it also freezes. Seems, the apps are waiting 
for data, but no data arrives for some reason.

Any ideas?

Kind regards

Peter Nabbefeld



BTW: Are there any Java bindings for V4L? Then I could probably try to 
write my own hacks to find out what happens ...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
