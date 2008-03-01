Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m21MMNoJ027118
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 17:22:23 -0500
Received: from QMTA10.westchester.pa.mail.comcast.net
	(qmta10.westchester.pa.mail.comcast.net [76.96.62.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m21MLlV6008047
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 17:21:47 -0500
Message-ID: <47C9D6FF.10905@personnelware.com>
Date: Sat, 01 Mar 2008 16:21:51 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
CC: video4linux-list@redhat.com
References: <BAY122-W46E61F0928F2E422B22355AA150@phx.gbl>
In-Reply-To: <BAY122-W46E61F0928F2E422B22355AA150@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: newbie programming help:  grabbing image(s) from /dev/video0,
 example code?
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

Elvis Chen wrote:
> Greetings,
> 
> I'm a researcher in computer-science.  I'm very new to V4L2 but am reasonably proficient in  C++ programming.  I seek your help in getting something simple done, in the meanwhile I'm trying to learn V4L2 programming API (http://v4l2spec.bytesex.org/)
> 
> We have 2 Hauppauge WInTV PVR-150 installed on a ubuntu 7.10 x86_64 machine.  They appear to the linux as /dev/video0 and /dev/video1, respectively.  What we like to do is to capture still images (or video) via s-video inputs on each card, and perform image-processing algorithms on them (in C++) and display the resultant images on the screen (C++/OpenGL).  Basically what I want to do is very simple:  open a linux/video device, capture an image, store it as a C array/buffer, display it, and refresh the C array/buffer.
> 
> Both cards work with kdetv and mplayer, so hardware-wise they work fine.
> 
> My first attempt was to find a small/simple API to access the linux/video device.  I came across videodog  (http://linux.softpedia.com/get/Multimedia/Video/VideoDog-9261.shtml) but it looks like it isn't been developed anymore (no source either).  Currently I'm trying to learn V4L2 (and trying to utilize the sample capture.c).
> 
> 
> Can anyone please give me a pointer on where I should start learning the V4L2 API?  Are there more example codes available?

http://lwn.net/Articles/203924/

I think the code you need may be in
http://www.video4linux.org/browser/v4l2-apps/test

btw - I am on a campaign to get better tests, so if you are in the mood, use one 
or more of those apps to test your driver, and improve the tests (they are 
currently not very extensive.)

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
