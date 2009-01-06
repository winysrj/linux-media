Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n06GbjNd032506
	for <video4linux-list@redhat.com>; Tue, 6 Jan 2009 11:37:45 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n06GbWuV008413
	for <video4linux-list@redhat.com>; Tue, 6 Jan 2009 11:37:33 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Jens Bongartz" <bongartz@gmail.com>
Date: Tue, 6 Jan 2009 17:37:31 +0100
References: <4389ffee0812310817m64b4c2bar56d8b35be06fe0f2@mail.gmail.com>
	<200901040102.37947.laurent.pinchart@skynet.be>
	<4389ffee0901041522n2fab030andc82e9fb9565524@mail.gmail.com>
In-Reply-To: <4389ffee0901041522n2fab030andc82e9fb9565524@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061737.31577.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com
Subject: Re: Testing Requested: Python Bindings for Video4linux2
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

Hi Jens,

On Monday 05 January 2009, Jens Bongartz wrote:
> Dear Laurent, dear Jackson,
>
> thanks for your reply to my request.
> I don't want to impose on you but maybe you are interested in my
> findings. To get a better impression of my intention I attached a
> brief description of my just started "FB-Py-Vision" project.
>
> Form the source-code of uvccapture-0.5 I derived a shared library to
> get access to the webcam from python using ctypes (file attached
> "pycapture_03.c"). Please show mercy to me, I am not a C-expert. To
> get continous grabbing I seperated init_videoIn(), uvcGrab() and
> close() in different functions. I discovered that init_videoIn() /
> free(videoIn) on every uvcGrab() is very time consuming and not
> suitable for high framerates.
> The functions I wrote are quite fixed and unflexible because right now
> I am only interested in luminance/YUV with 640 by 480. The
> corresponding python-program is also attached. ('python_capture.py')
>
> Now something interesting appears: Grabbing the luminance images works
> without problems (high frame rate). When I switch to the contour-mode
> the python image processing workload is higher and the uvcGrab() calls
> are fewer. For a short period the framerate slows down but after a few
> seconds recovers but now with a delay between captured and displayed
> images of around 4 seconds. Very curious! When I switch back to
> "normal mode" the framerate speeds up (!) a short time and then
> recovers again without a delay.
>
> I suppose this effect is a result of the weak VIA-CPU I use (see my
> project-description). In general I don't mind if the framerate drops
> when the image processing load rises but the problem is that I want to
> process an actual image and not an image which is a few seconds old.
> (I hope you understand what I mean).
>
> Furthermore I assume that the uvcvideo streaming mode plays also a
> role. I suppose that the 16 v4l2_buffer becomes unsynchronised.

The buffers can indeed contain old data. An easy way to flush them would be to 
dequeue all buffers without processing the data and requeue them.

> But when I decrease the NB_BUFFER constant of "v4l2uvc.h" everything
> compiles flawless but on excecution I get a Segmentation fault with a
> fatal error. Only NB_BUFEER = 16 works. Is this correct?

The uvcvideo driver doesn't require to number of buffers to be exactly 16. To 
debug your problem, when your application segfaults, check the kernel log 
(with dmesg). If the log shows a kernel crash (called an 'oops') please 
report it with the complete oops report. If it doesn't, you probably have a 
bug in your application, either in the code you wrote or in the uvccapture 
sources. gdb is your friend.

> What do you think? Do you have any hints for me, why I get this delay?

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
