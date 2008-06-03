Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m539QZWf019091
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 05:26:35 -0400
Received: from MTA003E.interbusiness.it (MTA003E.interbusiness.it [88.44.62.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m539QLOD004331
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 05:26:22 -0400
Message-ID: <48450E32.7080700@gmail.com>
Date: Tue, 03 Jun 2008 11:26:10 +0200
From: Mat <heavensdoor78@gmail.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Need help with a new USB framegrabber...
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


Hi all.
Need help again!
Info about the device:

+ Brand:
EasyCAP

+ Site:
I don't know... here's a small review:
  http://gadizmo.com/easycap-usb-review.php

+ lusb:
Bus 001 Device 003: ID 05e1:0408 Syntek Semiconductor Co., Ltd

I got the latest v4l-dvb drivers from Mercurial this morning. Build. Reboot.
No module is loaded automatically.
I modified:
  v4l-dvb/linux/drivers/media/video/stk-webcam.c
There is a device here with the same vendor ID, but different product 
ID... 05e1:0501
I tried to add:
  { USB_DEVICE_AND_INTERFACE_INFO(0x05e1, 0x0408, 0xff, 0xff, 0xff) },
The module stkwebcam is loaded. I activated the option debug=3
When I start xawtv I get:
  ioctl: VIDIOC_STREAMON(int=1): Bad address
  v4l2: oops: select timeout
  v4l2: read: Cannot allocate memory

There's little I can do to get it working soon I suppose...

+ dmesg output:
[  108.275813] stkwebcam: VIDIOC_QUERYCAP driver=stk, card=stk, bus=, 
version=0x00000001, capabilities=0x05000001
[  108.276969] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCAP
[  108.277154] stkwebcam: VIDIOC_QUERYCAP driver=stk, card=stk, bus=, 
version=0x00000001, capabilities=0x05000001
[  108.277275] stkwebcam: VIDIOC_ENUMINPUT index=0, name=Syntek USB 
Camera, type=2, audioset=0, tuner=0, std=00000000, status=0
[  108.277388] stkwebcam: err: on <7>stkwebcam: VIDIOC_ENUMINPUT
[  108.277498] stkwebcam: VIDIOC_ENUM_FMT index=0, type=1, flags=0, 
pixelformat=RGBP, description='r5g6b5'
[  108.277605] stkwebcam: VIDIOC_ENUM_FMT index=1, type=1, flags=0, 
pixelformat=RGBR, description='r5g6b5BE'
[  108.277712] stkwebcam: VIDIOC_ENUM_FMT index=2, type=1, flags=0, 
pixelformat=UYVY, description='yuv4:2:2'
[  108.277860] stkwebcam: VIDIOC_ENUM_FMT index=3, type=1, flags=0, 
pixelformat=BA81, description='Raw bayer'
[  108.277967] stkwebcam: VIDIOC_ENUM_FMT index=4, type=1, flags=0, 
pixelformat=YUYV, description='yuv4:2:2'
[  108.278074] stkwebcam: err: on <7>stkwebcam: VIDIOC_ENUM_FMT
[  108.278182] stkwebcam: VIDIOC_G_PARM type=1
[  108.278282] stkwebcam: VIDIOC_QUERYCTRL id=9963776, type=1, 
name=Brightness, min/max=0/65535, step=256, default=24576, flags=0x00000000
[  108.278393] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.278500] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.278608] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.278715] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.278822] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.278937] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279104] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279213] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279320] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279452] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279559] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279666] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279773] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279880] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.279986] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280093] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280201] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280307] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280414] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280522] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280628] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280734] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280841] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.280947] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281053] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281159] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281264] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281370] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281475] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281580] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281686] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281793] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.281901] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282007] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282114] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282220] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282326] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282432] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282539] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282646] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282774] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282880] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.282987] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283093] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283198] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283305] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283412] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283518] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283624] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283730] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283837] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.283970] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284077] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284204] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284310] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284417] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284524] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284631] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284737] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284844] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.284951] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.285057] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.285164] stkwebcam: err: on <7>stkwebcam: VIDIOC_QUERYCTRL
[  108.909340] stkwebcam: VIDIOC_G_STD value=00000000
[  108.909687] stkwebcam: VIDIOC_G_INPUT value=0
[  108.909869] stkwebcam: VIDIOC_G_CTRL Enum for index=9963776
[  108.909975] stkwebcam: id=9963776, value=32767
[  108.911746] stkwebcam: VIDIOC_S_FMT type=video-cap
[  108.912045] stkwebcam: width=384, height=288, format=YUYV, field=any, 
bytesperline=0 sizeimage=0, colorspace=0
[  108.922005] stkwebcam: Sensor resetting failed
[  109.099313] stkwebcam: VIDIOC_S_FMT type=video-cap
[  109.099547] stkwebcam: width=352, height=288, format=YUYV, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  109.109457] stkwebcam: Sensor resetting failed
[  109.268312] stkwebcam: VIDIOC_REQBUFS count=3, type=video-cap, 
memory=mmap
[  109.268474] stkwebcam: VIDIOC_QUERYBUF 00:00:00.00000000 index=0, 
type=video-cap, bytesused=0, flags=0x00000000, field=1, sequence=0, 
memory=mmap, offset/userptr=0x00000000, length=204800
[  109.268595] stkwebcam: timecode= 00:00:00 type=0, flags=0x00000000, 
frames=0, userbits=0x00000000
[  109.268718] stkwebcam: VIDIOC_QUERYBUF 00:00:00.00000000 index=1, 
type=video-cap, bytesused=0, flags=0x00000000, field=1, sequence=0, 
memory=mmap, offset/userptr=0x00064000, length=204800
[  109.268837] stkwebcam: timecode= 00:00:00 type=0, flags=0x00000000, 
frames=0, userbits=0x00000000
[  109.268944] stkwebcam: VIDIOC_QUERYBUF 00:00:00.00000000 index=2, 
type=video-cap, bytesused=0, flags=0x00000000, field=1, sequence=0, 
memory=mmap, offset/userptr=0x000c8000, length=204800
[  109.269061] stkwebcam: timecode= 00:00:00 type=0, flags=0x00000000, 
frames=0, userbits=0x00000000
[  109.269176] stkwebcam: VIDIOC_QBUF 00:00:00.00000000 index=0, 
type=video-cap, bytesused=0, flags=0x00000003, field=1, sequence=0, 
memory=mmap, offset/userptr=0x00000000, length=204800
[  109.269291] stkwebcam: timecode= 00:00:00 type=0, flags=0x00000000, 
frames=0, userbits=0x00000000
[  109.269439] stkwebcam: VIDIOC_QBUF 00:00:00.00000000 index=1, 
type=video-cap, bytesused=0, flags=0x00000003, field=1, sequence=0, 
memory=mmap, offset/userptr=0x00064000, length=204800
[  109.269555] stkwebcam: timecode= 00:00:00 type=0, flags=0x00000000, 
frames=0, userbits=0x00000000
[  109.269652] stkwebcam: VIDIOC_QBUF 00:00:00.00000000 index=2, 
type=video-cap, bytesused=0, flags=0x00000003, field=1, sequence=0, 
memory=mmap, offset/userptr=0x000c8000, length=204800
[  109.269790] stkwebcam: timecode= 00:00:00 type=0, flags=0x00000000, 
frames=0, userbits=0x00000000
[  109.269911] stkwebcam: VIDIOC_STREAMON type=video-cap
[  109.270011] stkwebcam: FIXME: Buffers are not allocated
[  109.270098] stkwebcam: err: on <7>stkwebcam: VIDIOC_STREAMON
[  109.270966] stkwebcam: VIDIOC_S_CTRL id=9963776, value=32767
[  109.284432] stkwebcam: VIDIOC_S_INPUT value=0
[  109.284576] stkwebcam: VIDIOC_S_STD value=00000000
[  114.306522] stkwebcam: VIDIOC_STREAMOFF type=video-cap
[  114.307613] stkwebcam: stk_sensor_inb failed, status=0x08
[  114.307698] stkwebcam: error suspending the sensor
[  114.933694] stkwebcam: VIDIOC_S_FMT type=video-cap
[  114.933954] stkwebcam: width=384, height=288, format=BGR4, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  114.934057] stkwebcam: err: on <7>stkwebcam: VIDIOC_S_FMT
[  114.934187] stkwebcam: VIDIOC_S_FMT type=video-cap
[  114.934290] stkwebcam: width=384, height=288, format=BGR3, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  114.934388] stkwebcam: err: on <7>stkwebcam: VIDIOC_S_FMT
[  114.934499] stkwebcam: VIDIOC_S_FMT type=video-cap
[  114.934600] stkwebcam: width=384, height=288, format=RGB3, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  114.934697] stkwebcam: err: on <7>stkwebcam: VIDIOC_S_FMT
[  114.934806] stkwebcam: VIDIOC_S_FMT type=video-cap
[  114.934909] stkwebcam: width=384, height=288, format=BGR3, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  114.935005] stkwebcam: err: on <7>stkwebcam: VIDIOC_S_FMT
[  114.935114] stkwebcam: VIDIOC_S_FMT type=video-cap
[  114.935214] stkwebcam: width=384, height=288, format=stkwebcam: err: 
on <7>stkwebcam: VIDIOC_S_FMT
[  114.935332] stkwebcam: VIDIOC_S_FMT type=video-cap
[  114.935433] stkwebcam: width=384, height=288, format=BGR4, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  114.935530] stkwebcam: err: on <7>stkwebcam: VIDIOC_S_FMT
[  114.935638] stkwebcam: VIDIOC_S_FMT type=video-cap
[  114.935739] stkwebcam: width=384, height=288, format=GREY, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  114.935836] stkwebcam: err: on <7>stkwebcam: VIDIOC_S_FMT
[  114.935946] stkwebcam: VIDIOC_S_FMT type=video-cap
[  114.936047] stkwebcam: width=384, height=288, format=YUYV, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  114.939824] stkwebcam: stk_sensor_outb failed, status=0x08
[  114.939908] stkwebcam: Sensor resetting failed
[  115.096567] stkwebcam: VIDIOC_S_FMT type=video-cap
[  115.096741] stkwebcam: width=352, height=264, format=YUYV, field=any, 
bytesperline=0 sizeimage=202752, colorspace=8
[  115.135779] stkwebcam: Sensor resetting failed
[  115.306104] stkwebcam: Sensor resetting failed
[  115.308229] stkwebcam: stk_sensor_inb failed, status=0x08
[  115.308331] stkwebcam: error suspending the sensor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
