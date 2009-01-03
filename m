Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03KSb4d010870
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 15:28:37 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n03KSKVt026689
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 15:28:21 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id EB5928180CE
	for <video4linux-list@redhat.com>; Sat,  3 Jan 2009 21:28:17 +0100 (CET)
Received: from [192.168.0.3] (cac94-1-81-57-151-96.fbx.proxad.net
	[81.57.151.96])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 00A87818152
	for <video4linux-list@redhat.com>; Sat,  3 Jan 2009 21:28:14 +0100 (CET)
Message-ID: <495FCA60.5060008@free.fr>
Date: Sat, 03 Jan 2009 21:28:16 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: v4l1 doesn't work anymore with bttv on 2.6.26
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

This is a copy of the bugreport i did on debian bugtracker : 
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=510621


I got a v4l1 application that worked for years.
With the current kernel, it hangs in a state where VIDIOCMCAPTURE always
return -EBUSY.

After some debug, it seems that VIDIOCMCAPTURE fails the first time
because of videobuf_queue_is_busy 'vbuf: busy: buffer #0 mapped'.

Then after that error it does a VIDIOCSYNC on all buffer.
Then every call of VIDIOCMCAPTURE failed because of check_btres
returning -EBUSY.

I don't know what cause the first videobuf_queue_is_busy error.
But for all the other errors I suppose one of the problem is that
VIDIOCSYNC does a STREAMON but never does a STREAMOFF...


Regards,

Matthieu

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
