Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m576WPl7012582
	for <video4linux-list@redhat.com>; Sat, 7 Jun 2008 02:32:25 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m576VjlW022544
	for <video4linux-list@redhat.com>; Sat, 7 Jun 2008 02:31:46 -0400
Message-ID: <484A2B45.1090200@hhs.nl>
Date: Sat, 07 Jun 2008 08:31:33 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
References: <484934FD.1080401@hhs.nl>
	<200806061519.50350.laurent.pinchart@skynet.be>
	<48494770.7060503@hhs.nl>
	<200806070054.51210.laurent.pinchart@skynet.be>
In-Reply-To: <200806070054.51210.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: uvc open/close race (Was Re: v4l1 compat wrapper version 0.3)
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

Laurent Pinchart wrote:
> Hi Hans,
> 
>> Some notes:
>> 1) TRY_FMT should really never do I/O (but then I guess the
>>     problem would still persists with S_FMT)
> 
> Why not ? The UVC specification defines probe requests to negotiate the 
> streaming format. Unlike for most other devices, the UVC model requires I/O 
> in TRY_FMT.
> 

I would expect the driver to ask the camera what format it supports once, at 
probe and then cache that info, many applications do a lot of TRY_FMT calls in 
quick succession, so doing the querying then and each time seems like a bad 
idea to me. Esp as, as seen in my example try_fmt can now throw IO/errors 
whichs is somewhat strange IMHO.

Quoting from:
http://lwn.net/Articles/227533/

"The VIDIOC_TRY_FMT handlers are optional for drivers, but omitting this 
functionality is not recommended. If provided, this function is callable at any 
time, even if the device is currently operating. It should not make any changes 
to the actual hardware operating parameters; it is just a way for the 
application to find out what is possible."

>> 2) I've also seen it fail at TRY_FMT 1 without first failing
>>     a TRY_FMT 2, I guess that was just me doing arrow-up -> enter to
>> quickly :)
> 
> Could you please tell me what webcam you used, as well as what kernel version 
> you are running ?

I'm using a Logitech sphere usb id: 046d:08cc

Fedora kernel: kernel-2.6.25-8.fc9, which includes UVC (added by Fedora).

> I would also appreciate if you could check the kernel log 
> for error messages after triggering the problem.

No messages I'm afraid.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
