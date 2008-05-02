Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42CUvGT029452
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:30:57 -0400
Received: from MTA001E.interbusiness.it (MTA001E.interbusiness.it [88.44.62.1])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42CUjAh000996
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:30:45 -0400
Message-ID: <481B096C.6000901@gmail.com>
Date: Fri, 02 May 2008 14:30:36 +0200
From: Mat <heavensdoor78@gmail.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Empia em28xx module compilation...
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


Mmm... I'm trying to compile the em28xx module (kernel version 2.6.25).
With a standard kernel conf... all ok.
With a stripped kernel conf... the compilation of v4l-dvb skips that module.
What kernel options are required for that module (other than EVDEV)?
What's the minumum kernel version for that module?
(perhaps I have to use a 2.6.20 ...)
Is there a way to compile only the em28xx module (and required ones)?

Thanks in advance for help.
-Mat-

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
