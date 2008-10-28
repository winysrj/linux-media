Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SIfTn5027084
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 14:41:29 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9SIfFDQ020490
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 14:41:16 -0400
Message-ID: <49075DA9.3000501@hhs.nl>
Date: Tue, 28 Oct 2008 19:44:57 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: ian@pickworth.me.uk
References: <49075186.7090101@pickworth.me.uk>
In-Reply-To: <49075186.7090101@pickworth.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: libv4l: Skype terminates after options dialogue is closed
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

Ian Pickworth wrote:
> I have had this problem since I started using libv4l 0.5.1, I've just
> upgraded to 0.5.3 but it still persists unfortunately.
> 
> The process I go through is as follows:
> 	LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so /usr/bin/skype &
> 	
> 	After Skype starts, open the Skype options dialogue
> 	Select the "Video Devices" tab
> 	With "Enable Skype Video" enabled, select the Camera device
> 	Press "test" - which shows the webcam picture correctly
> 
> 	Press close
> 
> At this point Skype aborts.
> I get the same result is I use this command:
> 	LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so /usr/bin/skype &
> 
> I'm not sure what diagnostics would be useful here, so if anyone can
> suggest what is needed I will provide them. I ran it using strace, thus:
> 
> 	LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so strace /usr/bin/skype
> 
> which ended with this:
> ------
> futex(0xa4df064, FUTEX_WAKE, 1)         = 1
> 
> gettimeofday({1225216076, 870558}, NULL) = 0
> 
> clock_gettime(CLOCK_REALTIME, {1225216076, 870611460}) = 0
> 
> futex(0xa88ffd8, FUTEX_WAIT, 1, {9, 999946540}upeek:
> ptrace(PTRACE_PEEKUSER,26933,44,0): No such process
> ------
> 
> Some details:
> 
> ian2 ~ # lsusb
> ...
> Bus 002 Device 003: ID 046d:092e Logitech, Inc.

Thats a spca561 cam, I've just run skype with the latest gspca + libv4l on an 
other spca561 cam with the same revision spca561 asic and it works fine.

So I believe this is caused by something else on your system.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
