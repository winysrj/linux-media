Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6CJqoGL012482
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:52:50 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6CJqO35019467
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 15:52:24 -0400
Message-ID: <48790D29.1010404@hhs.nl>
Date: Sat, 12 Jul 2008 21:59:37 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Andrea <audetto@tiscali.it>
References: <487908CA.8000304@tiscali.it>
In-Reply-To: <487908CA.8000304@tiscali.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: prototype of a USB v4l2 driver?
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

Andrea wrote:
> Hi,
> 
> I would like to learn more in detail how a video driver works.
> Basically in the last days I've looked at pwc to see why it is not so 
> robust with mplayer.
> I found something in the streaming ioctl calls.
> 
> As an exercise I would like to port it to the "best" and "more elegant" 
> framework, reusing as much as possible the existing v4l2 framework are 
> writing as little code as possible (e.g. using videobuf). And remove all 
> the v4l1 code.
> 
> I would like to know which is the best USB driver to look at.
> Which is the best USB driver that implements videobuf?
> 
> This is a good overview of a driver
> http://lwn.net/Articles/203924/
> 
> I think vivi.c is an other good one.
> 
> Does anybody have any other good reference to look at?
> 

What kind of device, I think that for webcams you;re best using gspca, (now 
merged in mecurial), that handles all the usb specific stuff, buffer 
management, etc. In general it makes it easy to write a webcam driver allowing 
you to focus on the interaction with the cam, rather then having to worry about 
looking, usb specifics, buffer management etc.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
