Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0403WC6025369
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 19:03:32 -0500
Received: from mailrelay011.isp.belgacom.be (mailrelay011.isp.belgacom.be
	[195.238.6.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0402o4Z022546
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 19:02:51 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Jens Bongartz" <bongartz@gmail.com>
Date: Sun, 4 Jan 2009 01:02:37 +0100
References: <4389ffee0812310817m64b4c2bar56d8b35be06fe0f2@mail.gmail.com>
In-Reply-To: <4389ffee0812310817m64b4c2bar56d8b35be06fe0f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901040102.37947.laurent.pinchart@skynet.be>
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

HI Jens,

On Wednesday 31 December 2008, Jens Bongartz wrote:
> Hi everybody,
>
> I saw this thread recently and I am interested in this topic too.
> I am using a Logitech Quickcam 9000 Pro with the uvcvideo driver. The
> camera works properly with the uvccapture application.
> I did some experiment with the python-video4linux2 bindings using the
> python interactive mode. To be honest I am not really familiar with
> v4l2.
>
> Here are my results:
> >>> import pyv4l2
> >>> cam = pyv4l2.Device('dev/video0')
> >>> cam.EnumInput(0)
>
> ['Camera 1', 'camera', 0L, 0L, [], []]
>
> >>> cam.EnumFormats(1)
>
> [('MJPG', 'MJPEG'), ('YUYV', 'YUV 4 :2 :2 (YUYV)')]
>
> >>> cam.GetResolutions()
>
> [(320L, 240L), (640L, 480L), (800L, 600L)]
>
> >>> cam.QueryCaps()
> >>> cam.driver
>
> 'uvcvideo'
>
> >>> cam.businfo
>
> '0000:00:10.1'
>
> >>> cam.card
>
> 'UVC Camera (046d:0990)'
>
> >>> cam.GetFormat()
> >>> cam.format.width
>
> 800L
>
> >>> cam.format.height
>
> 600L
>
> >>> cam.format.pixelformat
>
> 'MJPEG'
>
> >>> cam.SetFormat()
>
> The Read() method works without an error message and the buffer is created.
>
> >>> cam.Read()
> >>> cam.buffer
>
> <ctypes.c_char_Array_62933 object at 0xb7e5053c>
>
> But the camera seems not to react to the Read() call. The camera's LED
> does not flash like using the uvccapture application and the buffer is
> filled just with '\x00'. Am I doing something wrong?

The read method is not supported by the uvcvideo driver. You should use the 
mmap video capture method.

> As Laurent already mentioned the "d.SetStandard( d.standards['NTSC']
> )" call creates an exception.
> Any suggestions? I would be happy to this webcam work with python.

Don't use the SetStandard function with UVC cameras :-). Or handle the 
exception and recover gracefully.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
