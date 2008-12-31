Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVGHQ4o031219
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 11:17:26 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVGH9F4025046
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 11:17:09 -0500
Received: by nf-out-0910.google.com with SMTP id d3so704072nfc.21
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 08:17:08 -0800 (PST)
Message-ID: <4389ffee0812310817m64b4c2bar56d8b35be06fe0f2@mail.gmail.com>
Date: Wed, 31 Dec 2008 17:17:08 +0100
From: "Jens Bongartz" <bongartz@gmail.com>
To: jackson@gotpossum.com, laurent.pinchart@skynet.be, carl@personnelware.com,
	video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Re:Testing Requested: Python Bindings for Video4linux2
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

Hi everybody,

I saw this thread recently and I am interested in this topic too.
I am using a Logitech Quickcam 9000 Pro with the uvcvideo driver. The
camera works properly with the uvccapture application.
I did some experiment with the python-video4linux2 bindings using the
python interactive mode. To be honest I am not really familiar with
v4l2.
Here are my results:

>>> import pyv4l2
>>> cam = pyv4l2.Device('dev/video0')
>>> cam.EnumInput(0)
['Camera 1', 'camera', 0L, 0L, [], []]
>>> cam.EnumFormats(1)
[('MJPG', 'MJPEG'), ('YUYV', 'YUV 4 :2 :2 (YUYV)')]
>>> cam.GetResolutions()
[(320L, 240L), (640L, 480L), (800L, 600L)]
>>> cam.QueryCaps()
>>> cam.driver
'uvcvideo'
>>> cam.businfo
'0000:00:10.1'
>>> cam.card
'UVC Camera (046d:0990)'
>>> cam.GetFormat()
>>> cam.format.width
800L
>>> cam.format.height
600L
>>> cam.format.pixelformat
'MJPEG'
>>> cam.SetFormat()

The Read() method works without an error message and the buffer is created.
>>> cam.Read()
>>> cam.buffer
<ctypes.c_char_Array_62933 object at 0xb7e5053c>

But the camera seems not to react to the Read() call. The camera's LED
does not flash like using the uvccapture application and the buffer is
filled just with '\x00'. Am I doing something wrong?

As Laurent already mentioned the "d.SetStandard( d.standards['NTSC']
)" call creates an exception.
Any suggestions? I would be happy to this webcam work with python.

Wish you all the best for 2009.

Best regards,
Jens


>From: Laurent Pinchart <laurent.pinchart <at> skynet.be>
>Subject: Re: Testing Requested: Python Bindings for Video4linux2
>Date: 2008-11-09 22:07:20 GMT (7 weeks, 2 days, 18 hours and 5 minutes ago)

>Hi,

>On Friday 07 November 2008, Jackson Yee wrote:
>> Lauren,
>>
>> On Wed, Nov 5, 2008 at 7:42 PM, Laurent Pinchart
>>
>> <laurent.pinchart <at> skynet.be> wrote:
>> > The uvcvideo driver doesn't implement the standard ioctls. This should
>> > not be fatal (and you probably want to define FindKeyas well).
>>
>> The standard ioctls are, unfortunately, all I have to go by since I'm
>> testing on my amd64 box with a bttv card. If a function does not
>> succeed though, it should throw an exception and let the user code
>> sort things out.

>That's right. But your sample application should handle that.

>> Do you have a link for the uncvideo driver so I could add support for it?

>Sure. http://linux-uvc.berlios.de/

>> FindKey looks to be Carl's code. ;-) I've added the function now.
>>
>>> > The problem comes from a bad alignment in the PixFormat structure. At
>> > least on my architecture (x86) the type field is 32 bits wide.
>>
>> I've updated the type field on PixFormat to c_long, which should come
>> out to be the right size on both x86 and amd64 platforms now.
>>
>> Thanks for the test. I'm working on adding libavcodec/libavformat
>> support so that we can capture straight to video instead of jpegs like
>> we're doing now. Please let me know if we have any other issues.

>Best regards,

>Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
