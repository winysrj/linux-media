Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SHsgWg029686
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 13:54:42 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9SHrBkU023944
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 13:53:12 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id AB1B513123F9
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 17:53:11 +0000 (GMT)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bnx2zHWrVFbo for <video4linux-list@redhat.com>;
	Tue, 28 Oct 2008 17:53:11 +0000 (GMT)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 66BF513123F6
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 17:53:11 +0000 (GMT)
Message-ID: <49075186.7090101@pickworth.me.uk>
Date: Tue, 28 Oct 2008 17:53:10 +0000
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: libv4l: Skype terminates after options dialogue is closed
Reply-To: ian@pickworth.me.uk
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

I have had this problem since I started using libv4l 0.5.1, I've just
upgraded to 0.5.3 but it still persists unfortunately.

The process I go through is as follows:
	LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so /usr/bin/skype &
	
	After Skype starts, open the Skype options dialogue
	Select the "Video Devices" tab
	With "Enable Skype Video" enabled, select the Camera device
	Press "test" - which shows the webcam picture correctly

	Press close

At this point Skype aborts.
I get the same result is I use this command:
	LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so /usr/bin/skype &

I'm not sure what diagnostics would be useful here, so if anyone can
suggest what is needed I will provide them. I ran it using strace, thus:

	LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so strace /usr/bin/skype

which ended with this:
------
futex(0xa4df064, FUTEX_WAKE, 1)         = 1

gettimeofday({1225216076, 870558}, NULL) = 0

clock_gettime(CLOCK_REALTIME, {1225216076, 870611460}) = 0

futex(0xa88ffd8, FUTEX_WAIT, 1, {9, 999946540}upeek:
ptrace(PTRACE_PEEKUSER,26933,44,0): No such process
------

Some details:

ian2 ~ # lsusb
...
Bus 002 Device 003: ID 046d:092e Logitech, Inc.
...
ian2 ~ # uname -r
2.6.27-gentoo-r1

I am using the gspca modules as provided in this kernel.
I have tried the latest version from hg - there is no change with that,
which makes me think this may be to do with the compatibility layer.

Thanks
Regards
Ian

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
