Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n05ILibY020146
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 13:21:44 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n05IKkLY027392
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 13:20:57 -0500
Received: by yx-out-2324.google.com with SMTP id 31so2176823yxl.81
	for <video4linux-list@redhat.com>; Mon, 05 Jan 2009 10:20:46 -0800 (PST)
Message-ID: <c785bba30901051020n27f61e4fje5717092169bbde2@mail.gmail.com>
Date: Mon, 5 Jan 2009 11:20:45 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: "Jens Bongartz" <bongartz@gmail.com>
In-Reply-To: <4389ffee0901041522n2fab030andc82e9fb9565524@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4389ffee0812310817m64b4c2bar56d8b35be06fe0f2@mail.gmail.com>
	<200901040102.37947.laurent.pinchart@skynet.be>
	<4389ffee0901041522n2fab030andc82e9fb9565524@mail.gmail.com>
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

Jens,

I'd give it a try. Can you include a make file or tell me compile command?

thanks,
Paul

2009/1/4 Jens Bongartz <bongartz@gmail.com>:
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
> role. I suppose that the 16 v4l2_buffer becomes unsynchronised. But
> when I decrease the NB_BUFFER constant of "v4l2uvc.h" everything
> compiles flawless but on excecution I get a Segmentation fault with a
> fatal error. Only NB_BUFEER = 16 works. Is this correct?
>
> What do you think? Do you have any hints for me, why I get this delay?
>
> Many thanks in advance.
> Jens
>
>
> 2009/1/4 Laurent Pinchart <laurent.pinchart@skynet.be>:
>> HI Jens,
>>
>> On Wednesday 31 December 2008, Jens Bongartz wrote:
>>> Hi everybody,
>>>
>>> I saw this thread recently and I am interested in this topic too.
>>> I am using a Logitech Quickcam 9000 Pro with the uvcvideo driver. The
>>> camera works properly with the uvccapture application.
>>> I did some experiment with the python-video4linux2 bindings using the
>>> python interactive mode. To be honest I am not really familiar with
>>> v4l2.
>>>
>>> Here are my results:
>>> >>> import pyv4l2
>>> >>> cam = pyv4l2.Device('dev/video0')
>>> >>> cam.EnumInput(0)
>>>
>>> ['Camera 1', 'camera', 0L, 0L, [], []]
>>>
>>> >>> cam.EnumFormats(1)
>>>
>>> [('MJPG', 'MJPEG'), ('YUYV', 'YUV 4 :2 :2 (YUYV)')]
>>>
>>> >>> cam.GetResolutions()
>>>
>>> [(320L, 240L), (640L, 480L), (800L, 600L)]
>>>
>>> >>> cam.QueryCaps()
>>> >>> cam.driver
>>>
>>> 'uvcvideo'
>>>
>>> >>> cam.businfo
>>>
>>> '0000:00:10.1'
>>>
>>> >>> cam.card
>>>
>>> 'UVC Camera (046d:0990)'
>>>
>>> >>> cam.GetFormat()
>>> >>> cam.format.width
>>>
>>> 800L
>>>
>>> >>> cam.format.height
>>>
>>> 600L
>>>
>>> >>> cam.format.pixelformat
>>>
>>> 'MJPEG'
>>>
>>> >>> cam.SetFormat()
>>>
>>> The Read() method works without an error message and the buffer is created.
>>>
>>> >>> cam.Read()
>>> >>> cam.buffer
>>>
>>> <ctypes.c_char_Array_62933 object at 0xb7e5053c>
>>>
>>> But the camera seems not to react to the Read() call. The camera's LED
>>> does not flash like using the uvccapture application and the buffer is
>>> filled just with '\x00'. Am I doing something wrong?
>>
>> The read method is not supported by the uvcvideo driver. You should use the
>> mmap video capture method.
>>
>>> As Laurent already mentioned the "d.SetStandard( d.standards['NTSC']
>>> )" call creates an exception.
>>> Any suggestions? I would be happy to this webcam work with python.
>>
>> Don't use the SetStandard function with UVC cameras :-). Or handle the
>> exception and recover gracefully.
>>
>> Best regards,
>>
>> Laurent Pinchart
>>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
