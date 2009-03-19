Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2JH95fs022308
	for <video4linux-list@redhat.com>; Thu, 19 Mar 2009 13:09:05 -0400
Received: from mail-ew0-f176.google.com (mail-ew0-f176.google.com
	[209.85.219.176])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2JH8mBm001232
	for <video4linux-list@redhat.com>; Thu, 19 Mar 2009 13:08:48 -0400
Received: by ewy24 with SMTP id 24so529492ewy.3
	for <video4linux-list@redhat.com>; Thu, 19 Mar 2009 10:08:47 -0700 (PDT)
Message-ID: <49C27C1B.10705@gmail.com>
Date: Thu, 19 Mar 2009 18:08:43 +0100
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------080103000608080901060307"
Subject: webcam doesn't working with programs using libv4l
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

This is a multi-part message in MIME format.
--------------080103000608080901060307
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

hi,

both cheese and ekiga does not work with my syneus (174f:5931) webcam while 
luvcview works fine.

linux is v2.6.29-rc8-124-g5bee17f, libv4l is 0.5.9 on debian sid.

This is what cheese -v says:

Cheese 2.24.3
Probing devices with HAL...
Found device 174f:5931, getting capabilities...
Detected v4l2 device: USB2.0 UVC PC Camera
Driver: uvcvideo, version: 256
Capabilities: 0x04000001

Probing supported video formats...
Device: USB2.0 UVC PC Camera (/dev/video0)
video/x-raw-yuv 1280 x 1024 num_framerates 1
7/1 video/x-raw-yuv 1280 x 960 num_framerates 1
7/1 video/x-raw-yuv 1280 x 800 num_framerates 1
7/1 video/x-raw-yuv 1024 x 768 num_framerates 1
7/1 video/x-raw-yuv 800 x 600 num_framerates 1
7/1 video/x-raw-yuv 640 x 480 num_framerates 1
20/1 video/x-raw-yuv 352 x 288 num_framerates 1
24/1 video/x-raw-yuv 320 x 240 num_framerates 1
24/1 video/x-raw-yuv 176 x 144 num_framerates 1
24/1 video/x-raw-yuv 160 x 120 num_framerates 1
24/1 video/x-raw-yuv 1280 x 1024 num_framerates 1
[snip]

v4l2src name=video_source device=/dev/video0 ! capsfilter
name=capsfilter
caps=video/x-raw-rgb,width=800,height=600,framerate=7/1;video/x-raw-yuv,width=800,height=600,framerate=7/1
! identity
libv4l2: error setting pixformat: Device or resource busy
libv4l2: error requesting 4 buffers: Device or resource busy

I've already asked on uvc devel and Laurent comes to this conclusion after 
looking at the driver logs you'll find attached:

That's definitely the problem. After calling VIDIOC_STREAMOFF to stop
streaming, cheese doesn't close the device and opens another instance. This 
is likely a bug in cheese or libv4l2.

thanks.
riccardo

--------------080103000608080901060307
Content-Type: text/x-log;
 name="uvctrace.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="uvctrace.log"

Mar 19 15:09:20 montag kernel: [  618.793018] uvcvideo: uvc_v4l2_open
Mar 19 15:09:20 montag kernel: [  618.793036] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
Mar 19 15:09:20 montag kernel: [  618.795442] uvcvideo: uvc_v4l2_release
Mar 19 15:09:20 montag kernel: [  618.877081] uvcvideo: uvc_v4l2_open
Mar 19 15:09:20 montag kernel: [  618.877100] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
Mar 19 15:09:20 montag kernel: [  618.877114] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
Mar 19 15:09:20 montag kernel: [  618.877141] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FMT)
Mar 19 15:09:20 montag kernel: [  618.877152] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877161] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877168] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877176] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877183] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877190] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877198] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877206] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877213] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877221] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877229] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  618.877236] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FMT)
Mar 19 15:09:20 montag kernel: [  618.877317] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
Mar 19 15:09:20 montag kernel: [  618.877344] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
Mar 19 15:09:20 montag kernel: [  618.877354] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMINPUT)
Mar 19 15:09:20 montag kernel: [  618.877431] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMINPUT)
Mar 19 15:09:20 montag kernel: [  618.877445] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMSTD)
Mar 19 15:09:20 montag kernel: [  618.877452] uvcvideo: Unsupported ioctl 0xc0485619
Mar 19 15:09:20 montag kernel: [  618.877458] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  618.926223] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  618.976556] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.026805] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077050] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077060] uvcvideo: Control 0x00980904 not found.
Mar 19 15:09:20 montag kernel: [  619.077065] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077072] uvcvideo: Control 0x00980905 not found.
Mar 19 15:09:20 montag kernel: [  619.077076] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077083] uvcvideo: Control 0x00980906 not found.
Mar 19 15:09:20 montag kernel: [  619.077087] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077093] uvcvideo: Control 0x00980907 not found.
Mar 19 15:09:20 montag kernel: [  619.077097] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077104] uvcvideo: Control 0x00980908 not found.
Mar 19 15:09:20 montag kernel: [  619.077108] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077114] uvcvideo: Control 0x00980909 not found.
Mar 19 15:09:20 montag kernel: [  619.077119] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077125] uvcvideo: Control 0x0098090a not found.
Mar 19 15:09:20 montag kernel: [  619.077129] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077135] uvcvideo: Control 0x0098090b not found.
Mar 19 15:09:20 montag kernel: [  619.077140] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077146] uvcvideo: Control 0x0098090c not found.
Mar 19 15:09:20 montag kernel: [  619.077150] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077156] uvcvideo: Control 0x0098090d not found.
Mar 19 15:09:20 montag kernel: [  619.077161] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077167] uvcvideo: Control 0x0098090e not found.
Mar 19 15:09:20 montag kernel: [  619.077171] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.077177] uvcvideo: Control 0x0098090f not found.
Mar 19 15:09:20 montag kernel: [  619.077181] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127550] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127559] uvcvideo: Control 0x00980911 not found.
Mar 19 15:09:20 montag kernel: [  619.127564] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127571] uvcvideo: Control 0x00980912 not found.
Mar 19 15:09:20 montag kernel: [  619.127575] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127582] uvcvideo: Control 0x00980913 not found.
Mar 19 15:09:20 montag kernel: [  619.127586] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127592] uvcvideo: Control 0x00980914 not found.
Mar 19 15:09:20 montag kernel: [  619.127597] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127603] uvcvideo: Control 0x00980915 not found.
Mar 19 15:09:20 montag kernel: [  619.127608] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127614] uvcvideo: Control 0x00980916 not found.
Mar 19 15:09:20 montag kernel: [  619.127618] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127625] uvcvideo: Control 0x00980917 not found.
Mar 19 15:09:20 montag kernel: [  619.127629] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127635] uvcvideo: Control 0x00980918 not found.
Mar 19 15:09:20 montag kernel: [  619.127640] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127646] uvcvideo: Control 0x00980919 not found.
Mar 19 15:09:20 montag kernel: [  619.127650] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.127656] uvcvideo: Control 0x0098091a not found.
Mar 19 15:09:20 montag kernel: [  619.127661] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.178034] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.228287] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.228297] uvcvideo: Control 0x0098091d not found.
Mar 19 15:09:20 montag kernel: [  619.228302] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:20 montag kernel: [  619.228309] uvcvideo: Control 0x0098091e not found.
Mar 19 15:09:20 montag kernel: [  619.228350] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_STD)
Mar 19 15:09:20 montag kernel: [  619.228357] uvcvideo: Unsupported ioctl 0x80085617
Mar 19 15:09:20 montag kernel: [  619.228369] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_INPUT)
Mar 19 15:09:20 montag kernel: [  619.228416] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FMT)
Mar 19 15:09:20 montag kernel: [  619.228456] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228469] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228485] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228541] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228550] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228561] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228590] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228599] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228609] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228636] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228644] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228654] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228680] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228689] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228698] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228725] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228734] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228744] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228770] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228778] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228788] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228815] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228823] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228833] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228859] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228867] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228877] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228902] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.228910] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228920] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.228946] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:20 montag kernel: [  619.229056] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229074] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229116] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229132] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229170] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229185] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229221] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229237] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229273] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229290] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229326] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229343] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229378] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229395] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229431] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229447] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229482] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229499] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229534] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229551] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229633] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229649] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229687] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229703] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229739] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229755] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229790] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229806] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229841] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229853] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229884] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229896] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229927] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229939] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229970] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.229983] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230014] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230026] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230057] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230069] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230151] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230164] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230198] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230210] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230242] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230253] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230285] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230297] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230328] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230340] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230372] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230384] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230416] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230428] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230461] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230472] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230504] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230516] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230550] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230566] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230657] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230674] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230712] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230729] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230765] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230781] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230819] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230834] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230871] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230887] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230923] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230940] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230977] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.230993] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.231030] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.231046] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.231083] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.231098] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.231135] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.231151] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:20 montag kernel: [  619.236051] uvcvideo: uvc_v4l2_ioctl(VIDIOC_TRY_FMT)
Mar 19 15:09:20 montag kernel: [  619.236062] uvcvideo: Trying format 0x56595559 (YUYV): 1280x1024.
Mar 19 15:09:20 montag kernel: [  619.236067] uvcvideo: Using default frame interval 142857.1 us (7.0 fps).
Mar 19 15:09:20 montag kernel: [  619.308541] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_FMT)
Mar 19 15:09:20 montag kernel: [  619.308551] uvcvideo: Trying format 0x56595559 (YUYV): 1280x1024.
Mar 19 15:09:20 montag kernel: [  619.308557] uvcvideo: Using default frame interval 142857.1 us (7.0 fps).
Mar 19 15:09:21 montag kernel: [  619.381169] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_PARM)
Mar 19 15:09:21 montag kernel: [  619.381194] uvcvideo: uvc_v4l2_ioctl(VIDIOC_REQBUFS)
Mar 19 15:09:21 montag kernel: [  619.381910] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYBUF)
Mar 19 15:09:21 montag kernel: [  619.381932] uvcvideo: uvc_v4l2_mmap
Mar 19 15:09:21 montag kernel: [  619.382183] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYBUF)
Mar 19 15:09:21 montag kernel: [  619.382195] uvcvideo: uvc_v4l2_mmap
Mar 19 15:09:21 montag kernel: [  619.382427] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QBUF)
Mar 19 15:09:21 montag kernel: [  619.382433] uvcvideo: Queuing buffer 0.
Mar 19 15:09:21 montag kernel: [  619.382439] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QBUF)
Mar 19 15:09:21 montag kernel: [  619.382445] uvcvideo: Queuing buffer 1.
Mar 19 15:09:21 montag kernel: [  619.382451] uvcvideo: uvc_v4l2_ioctl(VIDIOC_STREAMON)
Mar 19 15:09:21 montag kernel: [  620.237911] uvcvideo: uvc_v4l2_ioctl(VIDIOC_DQBUF)
Mar 19 15:09:22 montag kernel: [  620.545087] uvcvideo: Frame complete (EOF found).
Mar 19 15:09:22 montag kernel: [  620.545094] uvcvideo: EOF in empty payload.
Mar 19 15:09:22 montag kernel: [  620.545131] uvcvideo: Dequeuing buffer 0 (3, 2621440 bytes).
Mar 19 15:09:22 montag kernel: [  620.553902] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QBUF)
Mar 19 15:09:22 montag kernel: [  620.553916] uvcvideo: Queuing buffer 0.
Mar 19 15:09:22 montag kernel: [  620.554840] uvcvideo: uvc_v4l2_ioctl(VIDIOC_DQBUF)
Mar 19 15:09:22 montag kernel: [  620.739968] uvcvideo: Frame complete (EOF found).
Mar 19 15:09:22 montag kernel: [  620.739975] uvcvideo: EOF in empty payload.
Mar 19 15:09:22 montag kernel: [  620.740046] uvcvideo: Dequeuing buffer 1 (3, 2621440 bytes).
Mar 19 15:09:22 montag kernel: [  620.748664] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QBUF)
Mar 19 15:09:22 montag kernel: [  620.748677] uvcvideo: Queuing buffer 1.
Mar 19 15:09:22 montag kernel: [  620.840400] uvcvideo: uvc_v4l2_ioctl(VIDIOC_STREAMOFF)
Mar 19 15:09:23 montag kernel: [  621.636942] uvcvideo: uvc_v4l2_open
Mar 19 15:09:23 montag kernel: [  621.636948] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
Mar 19 15:09:23 montag kernel: [  621.636954] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
Mar 19 15:09:23 montag kernel: [  621.636960] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FMT)
Mar 19 15:09:23 montag kernel: [  621.636964] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636967] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636970] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636973] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636976] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636979] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636982] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636985] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636988] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636992] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636995] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.636998] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FMT)
Mar 19 15:09:23 montag kernel: [  621.637033] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
Mar 19 15:09:23 montag kernel: [  621.637038] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
Mar 19 15:09:23 montag kernel: [  621.637043] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMINPUT)
Mar 19 15:09:23 montag kernel: [  621.637053] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMINPUT)
Mar 19 15:09:23 montag kernel: [  621.637056] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMSTD)
Mar 19 15:09:23 montag kernel: [  621.637059] uvcvideo: Unsupported ioctl 0xc0485619
Mar 19 15:09:23 montag kernel: [  621.637061] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.676520] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.717276] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.758177] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799174] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799184] uvcvideo: Control 0x00980904 not found.
Mar 19 15:09:23 montag kernel: [  621.799189] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799196] uvcvideo: Control 0x00980905 not found.
Mar 19 15:09:23 montag kernel: [  621.799201] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799207] uvcvideo: Control 0x00980906 not found.
Mar 19 15:09:23 montag kernel: [  621.799211] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799218] uvcvideo: Control 0x00980907 not found.
Mar 19 15:09:23 montag kernel: [  621.799222] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799228] uvcvideo: Control 0x00980908 not found.
Mar 19 15:09:23 montag kernel: [  621.799233] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799239] uvcvideo: Control 0x00980909 not found.
Mar 19 15:09:23 montag kernel: [  621.799243] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799250] uvcvideo: Control 0x0098090a not found.
Mar 19 15:09:23 montag kernel: [  621.799254] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799260] uvcvideo: Control 0x0098090b not found.
Mar 19 15:09:23 montag kernel: [  621.799265] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799271] uvcvideo: Control 0x0098090c not found.
Mar 19 15:09:23 montag kernel: [  621.799275] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799282] uvcvideo: Control 0x0098090d not found.
Mar 19 15:09:23 montag kernel: [  621.799286] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799292] uvcvideo: Control 0x0098090e not found.
Mar 19 15:09:23 montag kernel: [  621.799297] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.799303] uvcvideo: Control 0x0098090f not found.
Mar 19 15:09:23 montag kernel: [  621.799307] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840084] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840095] uvcvideo: Control 0x00980911 not found.
Mar 19 15:09:23 montag kernel: [  621.840100] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840107] uvcvideo: Control 0x00980912 not found.
Mar 19 15:09:23 montag kernel: [  621.840111] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840118] uvcvideo: Control 0x00980913 not found.
Mar 19 15:09:23 montag kernel: [  621.840122] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840129] uvcvideo: Control 0x00980914 not found.
Mar 19 15:09:23 montag kernel: [  621.840133] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840139] uvcvideo: Control 0x00980915 not found.
Mar 19 15:09:23 montag kernel: [  621.840144] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840150] uvcvideo: Control 0x00980916 not found.
Mar 19 15:09:23 montag kernel: [  621.840154] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840161] uvcvideo: Control 0x00980917 not found.
Mar 19 15:09:23 montag kernel: [  621.840165] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840171] uvcvideo: Control 0x00980918 not found.
Mar 19 15:09:23 montag kernel: [  621.840176] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840182] uvcvideo: Control 0x00980919 not found.
Mar 19 15:09:23 montag kernel: [  621.840186] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.840193] uvcvideo: Control 0x0098091a not found.
Mar 19 15:09:23 montag kernel: [  621.840197] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.881288] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.922288] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.922297] uvcvideo: Control 0x0098091d not found.
Mar 19 15:09:23 montag kernel: [  621.922302] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
Mar 19 15:09:23 montag kernel: [  621.922308] uvcvideo: Control 0x0098091e not found.
Mar 19 15:09:23 montag kernel: [  621.922330] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_STD)
Mar 19 15:09:23 montag kernel: [  621.922337] uvcvideo: Unsupported ioctl 0x80085617
Mar 19 15:09:23 montag kernel: [  621.922349] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_INPUT)
Mar 19 15:09:23 montag kernel: [  621.922383] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FMT)
Mar 19 15:09:23 montag kernel: [  621.922414] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922424] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922439] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922490] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922499] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922510] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922539] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922547] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922557] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922585] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922593] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922603] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922629] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922637] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922647] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922673] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922682] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922691] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922717] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922726] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922735] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922762] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922770] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922780] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922805] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922814] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922824] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922849] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922857] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922867] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922893] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMESIZES)
Mar 19 15:09:23 montag kernel: [  621.922954] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.922966] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923003] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923015] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923047] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923059] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923090] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923102] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923133] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923145] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923176] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923187] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923219] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923231] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923263] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923275] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923307] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923318] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923350] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923362] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923438] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923451] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923483] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923494] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923526] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923537] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923568] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923579] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923610] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923621] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923653] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923665] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923696] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923708] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923738] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923750] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923781] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923794] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923825] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923836] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923918] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923930] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923966] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.923978] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925074] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925089] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925133] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925145] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925179] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925191] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925224] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925236] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925270] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925286] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925323] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925339] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925377] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925393] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925430] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925446] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925544] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925560] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925600] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925616] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925654] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925669] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925706] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925723] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925759] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925775] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925813] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925829] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925867] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925883] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925920] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925936] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925972] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.925984] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.926016] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  621.926028] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FRAMEINTERVALS)
Mar 19 15:09:23 montag kernel: [  622.057335] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_FMT)
Mar 19 15:09:23 montag kernel: [  622.068082] uvcvideo: uvc_v4l2_ioctl(VIDIOC_REQBUFS)
Mar 19 15:09:26 montag kernel: [  624.621930] uvcvideo: uvc_v4l2_release
Mar 19 15:09:26 montag kernel: [  624.807635] uvcvideo: uvc_v4l2_release

--------------080103000608080901060307
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080103000608080901060307--
