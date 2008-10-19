Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9JGgnpO032086
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 12:42:49 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9JGgXlx005992
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 12:42:33 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 6E11811FF3DC
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 17:42:32 +0100 (BST)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Kf1nY4Rz1UwI for <video4linux-list@redhat.com>;
	Sun, 19 Oct 2008 17:42:31 +0100 (BST)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 6EDD011CF8B0
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 17:42:31 +0100 (BST)
Message-ID: <48FB6377.40707@pickworth.me.uk>
Date: Sun, 19 Oct 2008 17:42:31 +0100
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: gspca_spca561/gspca-main on 2.6.27-gentoo: webcam doesn't work, and
 udev attribute missing
Reply-To: ian@pickworth.me.uk
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

I'm having a go at the latest hg (pulled at 16:00 today - 19 October).
This is because I previously used the gspcav1-20071224 drivers for my
webcam, and these no longer compile under 2.6.27, so have to change.

The two modules that are relevant are gspca_main and gspca_spca561

Two problems. First is that my udev rule for the web cam no longer
works. Checking the device attributes, it shows:

----------------------------------------
  looking at device '/class/video4linux/video1':
    KERNEL=="video1"
    SUBSYSTEM=="video4linux"
    DRIVER==""
    ATTR{name}=="gspca main driver"
    ATTR{index}=="0"

  looking at parent device
'/devices/pci0000:00/0000:00:0a.1/usb1/1-4/1-4.2':
    KERNELS=="1-4.2"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{configuration}==""
    ATTRS{bNumInterfaces}==" 1"
    ATTRS{bConfigurationValue}=="1"
    ATTRS{bmAttributes}=="80"
    ATTRS{bMaxPower}=="100mA"
    ATTRS{urbnum}=="2084"
    ATTRS{idVendor}=="046d"
    ATTRS{idProduct}=="092e"
    ATTRS{bcdDevice}=="0000"
    ATTRS{bDeviceClass}=="ff"
    ATTRS{bDeviceSubClass}=="ff"
    ATTRS{bDeviceProtocol}=="00"
    ATTRS{bNumConfigurations}=="1"
    ATTRS{bMaxPacketSize0}=="8"
    ATTRS{speed}=="12"
    ATTRS{busnum}=="1"
    ATTRS{devnum}=="11"
    ATTRS{version}==" 1.10"
    ATTRS{maxchild}=="0"
    ATTRS{quirks}=="0x0"
    ATTRS{authorized}=="1"
    ATTRS{manufacturer}=="        "
    ATTRS{product}=="Camera"

etc...
---------------------------------

In the "old" driver in a kernel 2.6.26, there was an attribute that
showed this
	ATTR{model}=="Logitech QuickCam EC"
which allowed various applications to display its full device name. Now
they can just show "Camera" - which is sort of no good if you have more
than one.

lsusb manages to find the maker correctly - so I assume the new gspca
framework could as well:
	Bus 001 Device 011: ID 046d:092e Logitech, Inc.

Second problem is the biggy. The camera doesn't work :-(.
To test it I ran this:

------------------------
$ gst-launch-0.10 v4lsrc device="/dev/video1" ! xvimagesink
Setting pipeline to PAUSED ...
Pipeline is live and does not need PREROLL ...
Setting pipeline to PLAYING ...
New clock: GstSystemClock
ERROR: from element /pipeline0/v4lsrc0: Could not synchronise on resource.
Additional debug info:
v4lsrc_calls.c(124): gst_v4lsrc_sync_frame (): /pipeline0/v4lsrc0:
system error: Invalid argument
Execution ended after 75374214 ns.
Setting pipeline to PAUSED ...
Setting pipeline to READY ...
Setting pipeline to NULL ...
FREEING pipeline ...
------------------------------

So, pipeline just quits with no output.
I put full tracing on gspca_main (debug=0x01ff), and the trace is below.

Anyone know how to solve this, or need more diagnostics? I have no idea
what this trace is telling me - besides that a lot went in the the
second it was running.

This same pipeline works fine in a 2.6.26 kernel, with previous gspca1
driver.

Thanks
Ian

----------------------
Oct 19 17:07:11 ian2 kernel: [ 3010.577944] gspca: gst-launch-0.10 open
Oct 19 17:07:11 ian2 kernel: [ 3010.577951] gspca: open done
Oct 19 17:07:11 ian2 kernel: [ 3010.577961] gspca main driver:
VIDIOC_QUERYCAP driver=spca561, card=Camera, bus=0000:00:0a.1,
version=0x00020300, capabilities=0x05000001
Oct 19 17:07:11 ian2 kernel: [ 3010.577967] gspca main driver:
VIDIOC_ENUMINPUT index=0, name=spca561, type=2, audioset=0, tuner=0,
std=00000000, status=0
Oct 19 17:07:11 ian2 kernel: [ 3010.577971] gspca main driver:
VIDIOC_ENUMINPUT error -22
Oct 19 17:07:11 ian2 kernel: [ 3010.577974] gspca main driver:
VIDIOC_ENUM_FMT index=0, type=1, flags=1, pixelformat=S561,
description='S561'
Oct 19 17:07:11 ian2 kernel: [ 3010.577978] gspca main driver:
VIDIOC_TRY_FMT type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.577981] gspca: try fmt cap S561
10000x10000
Oct 19 17:07:11 ian2 kernel: [ 3010.577984] gspca main driver:
width=352, height=288, format=S561, field=none, bytesperline=352
sizeimage=50688, colorspace=8
Oct 19 17:07:11 ian2 kernel: [ 3010.577988] gspca main driver:
VIDIOC_G_FMT type=vid-overlay
Oct 19 17:07:11 ian2 kernel: [ 3010.577990] gspca main driver:
VIDIOC_G_FMT error -22
Oct 19 17:07:11 ian2 kernel: [ 3010.577993] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.577996] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:11 ian2 kernel: [ 3010.578053] gspca main driver:
VIDIOC_ENUMINPUT index=0, name=spca561, type=2, audioset=0, tuner=0,
std=00000000, status=0
Oct 19 17:07:11 ian2 kernel: [ 3010.578074] gspca main driver:
VIDIOC_G_STD std=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.578094] gspca main driver:
VIDIOC_S_INPUT value=0
Oct 19 17:07:11 ian2 kernel: [ 3010.578096] gspca main driver:
VIDIOC_S_STD std=000000ff
Oct 19 17:07:11 ian2 kernel: [ 3010.578103] gspca main driver:
VIDIOC_ENUMINPUT index=0, name=spca561, type=2, audioset=0, tuner=0,
std=00000000, status=0
Oct 19 17:07:11 ian2 kernel: [ 3010.578107] gspca main driver:
VIDIOC_G_STD std=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.578115] gspca: cgmbuf
Oct 19 17:07:11 ian2 kernel: [ 3010.578117] gspca: try fmt cap BGR3 352x288
Oct 19 17:07:11 ian2 kernel: [ 3010.578119] gspca: frame alloc frsz: 50688
Oct 19 17:07:11 ian2 kernel: [ 3010.578169] gspca: reqbufs st:0 c:4
Oct 19 17:07:11 ian2 kernel: [ 3010.578170] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:11 ian2 kernel: [ 3010.578178] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:11 ian2 kernel: [ 3010.578197] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.578203] gspca main driver:
width=352, height=288, format=S561, field=none, bytesperline=352
sizeimage=50688, colorspace=8
Oct 19 17:07:11 ian2 kernel: [ 3010.578206] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.578213] gspca main driver: width=48,
height=32, format=YUYV, field=any, bytesperline=0 sizeimage=50688,
colorspace=8
Oct 19 17:07:11 ian2 kernel: [ 3010.578216] gspca: try fmt cap YUYV 48x32
Oct 19 17:07:11 ian2 kernel: [ 3010.578219] gspca main driver:
VIDIOC_QUERYBUF 00:44:51.00100183 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=0, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.578228] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.578231] gspca: qbuf 0
Oct 19 17:07:11 ian2 kernel: [ 3010.578234] gspca: qbuf q:1 i:0 o:0
Oct 19 17:07:11 ian2 kernel: [ 3010.578236] gspca main driver:
VIDIOC_QBUF 00:44:51.00100183 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=0, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.578245] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.578248] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.578254] gspca: init transfer alt 8
Oct 19 17:07:11 ian2 kernel: [ 3010.578257] gspca: use alt 7 ep 0x81
Oct 19 17:07:11 ian2 kernel: [ 3010.578945] gspca: isoc 32 pkts size
1023 = bsize:32736
Oct 19 17:07:11 ian2 kernel: [ 3010.579066] spca561: reg write: 0x8500:0x03
Oct 19 17:07:11 ian2 kernel: [ 3010.579316] spca561: reg write: 0x8700:0x8a
Oct 19 17:07:11 ian2 kernel: [ 3010.579440] spca561: reg write: 0x8112:0x3e
Oct 19 17:07:11 ian2 kernel: [ 3010.579565] spca561: reg write: 0x850b:0x03
Oct 19 17:07:11 ian2 kernel: [ 3010.579987] spca561: reg write: 0x8616:0x68
Oct 19 17:07:11 ian2 kernel: [ 3010.580097] spca561: reg write: 0x8614:0x38
Oct 19 17:07:11 ian2 kernel: [ 3010.580207] gspca: usb_submit_urb [0]
err -28
Oct 19 17:07:11 ian2 kernel: [ 3010.580208] gspca: kill transfer
Oct 19 17:07:11 ian2 kernel: [ 3010.580213] gspca: init transfer alt 7
Oct 19 17:07:11 ian2 kernel: [ 3010.580215] gspca: use alt 6 ep 0x81
Oct 19 17:07:11 ian2 kernel: [ 3010.580367] gspca: isoc 32 pkts size 896
= bsize:28672
Oct 19 17:07:11 ian2 kernel: [ 3010.580450] spca561: reg write: 0x8500:0x03
Oct 19 17:07:11 ian2 kernel: [ 3010.580691] spca561: reg write: 0x8700:0x8a
Oct 19 17:07:11 ian2 kernel: [ 3010.580815] spca561: reg write: 0x8112:0x3e
Oct 19 17:07:11 ian2 kernel: [ 3010.580940] spca561: reg write: 0x850b:0x03
Oct 19 17:07:11 ian2 kernel: [ 3010.584957] spca561: reg write: 0x8616:0x68
Oct 19 17:07:11 ian2 kernel: [ 3010.585067] spca561: reg write: 0x8614:0x38
Oct 19 17:07:11 ian2 kernel: [ 3010.585376] gspca: stream on OK GBRG 160x120
Oct 19 17:07:11 ian2 kernel: [ 3010.585389] gspca main driver:
VIDIOC_QUERYBUF 00:44:51.00100183 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=0, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.585398] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.585401] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.585404] gspca: stream on OK GBRG 160x120
Oct 19 17:07:11 ian2 kernel: [ 3010.585406] gspca: poll
Oct 19 17:07:11 ian2 kernel: [ 3010.626578] gspca: isoc irq
Oct 19 17:07:11 ian2 kernel: [ 3010.626590] gspca: packet [0] o:0 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626592] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626594] gspca: packet [1] o:896 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626596] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626597] gspca: packet [2] o:1792 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626599] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626600] gspca: packet [3] o:2688 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626601] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626603] gspca: packet [4] o:3584 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626605] gspca: packet [5] o:4480 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626606] gspca: packet [6] o:5376 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626608] gspca: packet [7] o:6272 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626609] gspca: packet [8] o:7168 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626611] gspca: packet [9] o:8064 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626613] gspca: packet [10] o:8960 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626614] gspca: packet [11] o:9856 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626616] gspca: packet [12] o:10752 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626617] gspca: packet [13] o:11648 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626619] gspca: packet [14] o:12544 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626621] gspca: packet [15] o:13440 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626622] gspca: packet [16] o:14336 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626624] gspca: packet [17] o:15232 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626625] gspca: packet [18] o:16128 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626627] gspca: packet [19] o:17024 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626629] gspca: add t:3 l:0
Oct 19 17:07:11 ian2 kernel: [ 3010.626630] gspca: add t:1 l:875
Oct 19 17:07:11 ian2 kernel: [ 3010.626632] gspca: packet [20] o:17920 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626634] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626636] gspca: packet [21] o:18816 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626637] gspca: packet [22] o:19712 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626639] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626641] gspca: packet [23] o:20608 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626642] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626644] gspca: packet [24] o:21504 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626646] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626648] gspca: packet [25] o:22400 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626649] gspca: packet [26] o:23296 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626651] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626653] gspca: packet [27] o:24192 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626654] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626656] gspca: packet [28] o:25088 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626658] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626660] gspca: packet [29] o:25984 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626661] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.626663] gspca: packet [30] o:26880 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626665] gspca: packet [31] o:27776 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.626666] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658570] gspca: isoc irq
Oct 19 17:07:11 ian2 kernel: [ 3010.658578] gspca: packet [0] o:0 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658580] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658582] gspca: packet [1] o:896 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658583] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658585] gspca: packet [2] o:1792 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658587] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658589] gspca: packet [3] o:2688 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658590] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658592] gspca: packet [4] o:3584 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658594] gspca: packet [5] o:4480 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658595] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658597] gspca: packet [6] o:5376 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658598] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658600] gspca: packet [7] o:6272 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658602] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658604] gspca: packet [8] o:7168 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658605] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658607] gspca: packet [9] o:8064 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658609] gspca: packet [10] o:8960 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658610] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658612] gspca: packet [11] o:9856 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658614] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658616] gspca: packet [12] o:10752 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658617] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658619] gspca: packet [13] o:11648 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658620] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.658623] gspca: packet [14] o:12544 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658624] gspca: packet [15] o:13440 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658626] gspca: packet [16] o:14336 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658627] gspca: packet [17] o:15232 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658629] gspca: packet [18] o:16128 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658630] gspca: packet [19] o:17024 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658632] gspca: packet [20] o:17920 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.658634] gspca: add t:3 l:0
Oct 19 17:07:11 ian2 kernel: [ 3010.658637] gspca: frame complete
len:19670 q:1 i:1 o:0
Oct 19 17:07:11 ian2 kernel: [ 3010.658638] gspca: add t:1 l:875
Oct 19 17:07:11 ian2 kernel: [ 3010.658769] gspca: poll
Oct 19 17:07:11 ian2 kernel: [ 3010.658773] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00793414 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=1, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.658781] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.658783] gspca: dqbuf
Oct 19 17:07:11 ian2 kernel: [ 3010.658785] gspca: frame wait q:1 i:1 o:1
Oct 19 17:07:11 ian2 kernel: [ 3010.658787] gspca: dqbuf 0
Oct 19 17:07:11 ian2 kernel: [ 3010.658788] gspca main driver:
VIDIOC_DQBUF 00:45:10.00793414 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=1, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.658794] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.658829] gspca: cgmbuf
Oct 19 17:07:11 ian2 kernel: [ 3010.658830] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:11 ian2 kernel: [ 3010.658838] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:11 ian2 kernel: [ 3010.658854] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.658859] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:11 ian2 kernel: [ 3010.658861] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.658865] gspca main driver: width=48,
height=32, format=YU12, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:11 ian2 kernel: [ 3010.658868] gspca: try fmt cap YU12 48x32
Oct 19 17:07:11 ian2 kernel: [ 3010.658869] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00793414 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=1, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.658875] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.658877] gspca: qbuf 0
Oct 19 17:07:11 ian2 kernel: [ 3010.658879] gspca: qbuf q:2 i:1 o:1
Oct 19 17:07:11 ian2 kernel: [ 3010.658880] gspca main driver:
VIDIOC_QBUF 00:45:10.00793414 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=1, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.658886] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.658889] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.658892] gspca: stream on OK GBRG 160x120
Oct 19 17:07:11 ian2 kernel: [ 3010.658898] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00793414 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=1, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.658904] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.658906] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.658909] gspca: stream on OK GBRG 160x120
Oct 19 17:07:11 ian2 kernel: [ 3010.658910] gspca: poll
Oct 19 17:07:11 ian2 kernel: [ 3010.690583] gspca: isoc irq
Oct 19 17:07:11 ian2 kernel: [ 3010.690591] gspca: packet [0] o:0 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690594] gspca: packet [1] o:896 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690596] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690597] gspca: packet [2] o:1792 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690599] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690600] gspca: packet [3] o:2688 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690601] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690603] gspca: packet [4] o:3584 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690604] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690606] gspca: packet [5] o:4480 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690607] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690608] gspca: packet [6] o:5376 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690610] gspca: packet [7] o:6272 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690612] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690613] gspca: packet [8] o:7168 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690614] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690616] gspca: packet [9] o:8064 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690617] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690619] gspca: packet [10] o:8960 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690620] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690621] gspca: packet [11] o:9856 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690623] gspca: packet [12] o:10752 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690625] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690626] gspca: packet [13] o:11648 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690627] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690629] gspca: packet [14] o:12544 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690630] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690632] gspca: packet [15] o:13440 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690633] gspca: packet [16] o:14336 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690635] gspca: packet [17] o:15232 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690636] gspca: packet [18] o:16128 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690638] gspca: packet [19] o:17024 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690640] gspca: packet [20] o:17920 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690641] gspca: packet [21] o:18816 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690643] gspca: add t:3 l:0
Oct 19 17:07:11 ian2 kernel: [ 3010.690644] gspca: add t:1 l:875
Oct 19 17:07:11 ian2 kernel: [ 3010.690646] gspca: packet [22] o:19712 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690648] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690650] gspca: packet [23] o:20608 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690651] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690654] gspca: packet [24] o:21504 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690655] gspca: packet [25] o:22400 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690657] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690659] gspca: packet [26] o:23296 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690660] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690662] gspca: packet [27] o:24192 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690664] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690666] gspca: packet [28] o:25088 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690667] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690669] gspca: packet [29] o:25984 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690670] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.690672] gspca: packet [30] o:26880 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690674] gspca: packet [31] o:27776 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.690675] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722577] gspca: isoc irq
Oct 19 17:07:11 ian2 kernel: [ 3010.722585] gspca: packet [0] o:0 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722588] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722590] gspca: packet [1] o:896 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722592] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722594] gspca: packet [2] o:1792 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722595] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722597] gspca: packet [3] o:2688 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722598] gspca: packet [4] o:3584 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722600] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722602] gspca: packet [5] o:4480 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722603] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722605] gspca: packet [6] o:5376 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722606] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722608] gspca: packet [7] o:6272 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722610] gspca: packet [8] o:7168 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722611] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722613] gspca: packet [9] o:8064 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722614] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722616] gspca: packet [10] o:8960 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722618] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722620] gspca: packet [11] o:9856 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722621] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722623] gspca: packet [12] o:10752 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722624] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722626] gspca: packet [13] o:11648 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722628] gspca: packet [14] o:12544 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722629] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722631] gspca: packet [15] o:13440 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722633] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.722635] gspca: packet [16] o:14336 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722636] gspca: packet [17] o:15232 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722638] gspca: packet [18] o:16128 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722639] gspca: packet [19] o:17024 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722641] gspca: packet [20] o:17920 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722642] gspca: packet [21] o:18816 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722644] gspca: packet [22] o:19712 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.722645] gspca: add t:3 l:0
Oct 19 17:07:11 ian2 kernel: [ 3010.722648] gspca: frame complete
len:19670 q:2 i:2 o:1
Oct 19 17:07:11 ian2 kernel: [ 3010.722650] gspca: add t:1 l:875
Oct 19 17:07:11 ian2 kernel: [ 3010.722799] gspca: poll
Oct 19 17:07:11 ian2 kernel: [ 3010.722804] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00857418 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=2, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.722811] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.722814] gspca: dqbuf
Oct 19 17:07:11 ian2 kernel: [ 3010.722815] gspca: frame wait q:2 i:2 o:2
Oct 19 17:07:11 ian2 kernel: [ 3010.722817] gspca: dqbuf 0
Oct 19 17:07:11 ian2 kernel: [ 3010.722818] gspca main driver:
VIDIOC_DQBUF 00:45:10.00857418 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=2, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.722824] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.722856] gspca: cgmbuf
Oct 19 17:07:11 ian2 kernel: [ 3010.722857] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:11 ian2 kernel: [ 3010.722865] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:11 ian2 kernel: [ 3010.722881] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.722885] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:11 ian2 kernel: [ 3010.722887] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.722891] gspca main driver: width=48,
height=32, format=UYVY, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:11 ian2 kernel: [ 3010.722894] gspca: try fmt cap UYVY 48x32
Oct 19 17:07:11 ian2 kernel: [ 3010.722895] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00857418 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=2, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.722901] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.722903] gspca: qbuf 0
Oct 19 17:07:11 ian2 kernel: [ 3010.722905] gspca: qbuf q:3 i:2 o:2
Oct 19 17:07:11 ian2 kernel: [ 3010.722906] gspca main driver:
VIDIOC_QBUF 00:45:10.00857418 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=2, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.722912] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.722914] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.722917] gspca: stream on OK GBRG 160x120
Oct 19 17:07:11 ian2 kernel: [ 3010.722924] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00857418 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=2, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:11 ian2 kernel: [ 3010.722930] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:11 ian2 kernel: [ 3010.722932] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:11 ian2 kernel: [ 3010.722934] gspca: stream on OK GBRG 160x120
Oct 19 17:07:11 ian2 kernel: [ 3010.722936] gspca: poll
Oct 19 17:07:11 ian2 kernel: [ 3010.754577] gspca: isoc irq
Oct 19 17:07:11 ian2 kernel: [ 3010.754594] gspca: packet [0] o:0 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754596] gspca: packet [1] o:896 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754598] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754601] gspca: packet [2] o:1792 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754603] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754605] gspca: packet [3] o:2688 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754608] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754610] gspca: packet [4] o:3584 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754613] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754615] gspca: packet [5] o:4480 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754617] gspca: packet [6] o:5376 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754620] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754622] gspca: packet [7] o:6272 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754625] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754627] gspca: packet [8] o:7168 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754629] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754632] gspca: packet [9] o:8064 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754634] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754637] gspca: packet [10] o:8960 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754639] gspca: packet [11] o:9856 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754642] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754644] gspca: packet [12] o:10752 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754646] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754649] gspca: packet [13] o:11648 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754651] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754654] gspca: packet [14] o:12544 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754656] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754658] gspca: packet [15] o:13440 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754661] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754663] gspca: packet [16] o:14336 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754666] gspca: packet [17] o:15232 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754668] gspca: packet [18] o:16128 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754671] gspca: packet [19] o:17024 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754673] gspca: packet [20] o:17920 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754676] gspca: packet [21] o:18816 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754679] gspca: packet [22] o:19712 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754681] gspca: add t:3 l:0
Oct 19 17:07:11 ian2 kernel: [ 3010.754683] gspca: add t:1 l:875
Oct 19 17:07:11 ian2 kernel: [ 3010.754687] gspca: packet [23] o:20608 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754689] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754692] gspca: packet [24] o:21504 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754694] gspca: packet [25] o:22400 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754697] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754700] gspca: packet [26] o:23296 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754702] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754705] gspca: packet [27] o:24192 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754707] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754710] gspca: packet [28] o:25088 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754713] gspca: packet [29] o:25984 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754715] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754718] gspca: packet [30] o:26880 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754721] gspca: add t:2 l:895
Oct 19 17:07:11 ian2 kernel: [ 3010.754723] gspca: packet [31] o:27776 l:896
Oct 19 17:07:11 ian2 kernel: [ 3010.754726] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786579] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3010.786589] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786591] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786594] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786595] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786597] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786599] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786600] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786602] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786604] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786606] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786607] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786609] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786610] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786612] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786614] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786616] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786617] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786619] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786621] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786622] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786624] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786626] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786628] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786629] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786631] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786633] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786634] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786636] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786638] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786640] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786641] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.786643] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786644] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786646] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786648] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786649] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786651] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786652] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.786654] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3010.786657] gspca: frame complete
len:19670 q:3 i:3 o:2
Oct 19 17:07:12 ian2 kernel: [ 3010.786659] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3010.786811] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3010.786815] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00921422 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=3, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.786822] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.786825] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3010.786827] gspca: frame wait q:3 i:3 o:3
Oct 19 17:07:12 ian2 kernel: [ 3010.786828] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3010.786829] gspca main driver:
VIDIOC_DQBUF 00:45:10.00921422 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=3, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.786835] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.786870] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3010.786872] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3010.786879] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3010.786896] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.786899] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3010.786902] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.786905] gspca main driver: width=48,
height=32, format=411P, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3010.786908] gspca: try fmt cap 411P 48x32
Oct 19 17:07:12 ian2 kernel: [ 3010.786910] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00921422 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=3, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.786916] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.786918] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3010.786920] gspca: qbuf q:0 i:3 o:3
Oct 19 17:07:12 ian2 kernel: [ 3010.786921] gspca main driver:
VIDIOC_QBUF 00:45:10.00921422 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=3, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.786927] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.786929] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.786932] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3010.786937] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00921422 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=3, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.786943] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.786945] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.786948] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3010.786949] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3010.818578] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3010.818590] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818592] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818594] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818595] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818596] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818598] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818599] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818601] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818602] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818604] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818605] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818607] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818608] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818609] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818611] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818612] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818614] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818615] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818617] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818618] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818620] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818621] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818622] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818624] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818625] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818627] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818628] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818630] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818631] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818632] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818634] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818635] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818637] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818638] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818640] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818641] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818643] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818644] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818646] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818648] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818649] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3010.818650] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3010.818653] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818654] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818656] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818657] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818659] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818661] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818663] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818664] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818666] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818668] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818669] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.818671] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.818673] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850518] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3010.850527] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850530] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850532] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850533] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850535] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850537] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850538] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850540] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850542] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850544] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850545] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850547] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850549] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850550] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850552] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850553] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850555] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850557] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850559] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850560] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850562] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850564] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850566] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850567] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850569] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850571] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850572] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850574] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850576] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850578] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850579] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850581] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850583] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850584] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.850586] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850588] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850589] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850591] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850592] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850594] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.850596] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3010.850599] gspca: frame complete
len:19670 q:0 i:0 o:3
Oct 19 17:07:12 ian2 kernel: [ 3010.850601] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3010.850731] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3010.850735] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00985426 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=4, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.850742] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.850745] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3010.850747] gspca: frame wait q:0 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3010.850748] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3010.850749] gspca main driver:
VIDIOC_DQBUF 00:45:10.00985426 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=4, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.850755] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.850784] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3010.850786] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3010.850792] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3010.850808] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.850812] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3010.850814] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.850817] gspca main driver: width=48,
height=32, format=422P, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3010.850820] gspca: try fmt cap 422P 48x32
Oct 19 17:07:12 ian2 kernel: [ 3010.850822] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00985426 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=4, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.850828] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.850830] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3010.850832] gspca: qbuf q:1 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3010.850833] gspca main driver:
VIDIOC_QBUF 00:45:10.00985426 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=4, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.850839] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.850841] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.850844] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3010.850850] gspca main driver:
VIDIOC_QUERYBUF 00:45:10.00985426 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=4, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.850856] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.850858] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.850861] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3010.850862] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3010.882578] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3010.882588] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882590] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882592] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882593] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882595] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882596] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882598] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882600] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882601] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882603] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882605] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882606] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882608] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882609] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882611] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882612] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882615] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882616] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882618] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882619] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882621] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882623] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882624] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882626] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882627] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882629] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882631] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882633] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882635] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882636] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882638] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882639] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882641] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882642] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882644] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882646] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882648] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882650] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882652] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882653] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882655] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882657] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882659] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3010.882660] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3010.882663] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882664] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882667] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882668] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882670] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882672] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882674] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882676] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882678] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.882680] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.882682] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914574] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3010.914583] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914584] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914586] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914588] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914589] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914591] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914592] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914594] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914596] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914598] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914599] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914601] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914603] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914604] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914606] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914607] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914609] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914611] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914613] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914614] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914616] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914618] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914619] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914621] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914622] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914624] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914626] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914628] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914629] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914631] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914633] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914634] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914636] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914637] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914639] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914641] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.914643] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914644] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914646] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914647] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914649] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914650] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914652] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.914653] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3010.914656] gspca: frame complete
len:19670 q:1 i:1 o:0
Oct 19 17:07:12 ian2 kernel: [ 3010.914658] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3010.914784] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3010.914788] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00049430 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=5, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.914794] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.914797] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3010.914798] gspca: frame wait q:1 i:1 o:1
Oct 19 17:07:12 ian2 kernel: [ 3010.914799] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3010.914801] gspca main driver:
VIDIOC_DQBUF 00:45:11.00049430 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=5, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.914807] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.914836] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3010.914838] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3010.914844] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3010.914860] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.914863] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3010.914865] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.914869] gspca main driver: width=48,
height=32, format=YUV9, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3010.914871] gspca: try fmt cap YUV9 48x32
Oct 19 17:07:12 ian2 kernel: [ 3010.914873] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00049430 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=5, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.914879] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.914881] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3010.914883] gspca: qbuf q:2 i:1 o:1
Oct 19 17:07:12 ian2 kernel: [ 3010.914884] gspca main driver:
VIDIOC_QBUF 00:45:11.00049430 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=5, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.914890] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.914892] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.914895] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3010.914901] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00049430 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=5, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.914907] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.914909] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.914911] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3010.914913] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3010.946574] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3010.946586] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946588] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946590] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946591] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946593] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946594] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946595] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946597] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946598] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946600] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946601] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946603] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946604] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946605] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946607] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946608] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946610] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946611] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946613] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946614] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946615] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946617] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946618] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946620] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946621] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946623] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946624] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946626] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946627] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946628] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946630] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946631] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946633] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946634] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946636] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946637] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946638] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946640] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946641] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946643] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946644] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946646] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946648] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946649] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946651] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946652] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3010.946654] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3010.946656] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946657] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946659] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946661] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946663] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.946664] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.946666] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978579] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3010.978591] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978593] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978596] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978597] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978599] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978600] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978602] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978604] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978606] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978607] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978609] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978611] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978612] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978614] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978615] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978617] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978618] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978620] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978622] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978624] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978625] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978627] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978629] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978630] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978632] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978633] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978636] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978637] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978639] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978640] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978642] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978644] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978645] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978647] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978649] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978651] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978652] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978654] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978655] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3010.978657] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978659] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978660] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978662] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978664] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978665] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978667] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3010.978668] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3010.978671] gspca: frame complete
len:19670 q:2 i:2 o:1
Oct 19 17:07:12 ian2 kernel: [ 3010.978673] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3010.978816] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3010.978821] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00113434 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=6, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.978828] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.978831] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3010.978832] gspca: frame wait q:2 i:2 o:2
Oct 19 17:07:12 ian2 kernel: [ 3010.978834] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3010.978835] gspca main driver:
VIDIOC_DQBUF 00:45:11.00113434 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=6, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.978841] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.978875] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3010.978877] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3010.978884] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3010.978901] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.978905] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3010.978907] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.978911] gspca main driver: width=48,
height=32, format=<6>gspca: try fmt cap 0x00000000 48x32
Oct 19 17:07:12 ian2 kernel: [ 3010.978914] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00113434 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=6, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.978920] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.978922] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3010.978924] gspca: qbuf q:3 i:2 o:2
Oct 19 17:07:12 ian2 kernel: [ 3010.978925] gspca main driver:
VIDIOC_QBUF 00:45:11.00113434 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=6, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.978931] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.978933] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.978936] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3010.978943] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00113434 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=6, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3010.978949] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3010.978951] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3010.978953] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3010.978955] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.010599] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.010613] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010616] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010618] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010621] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010623] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010625] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010628] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010630] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010632] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010635] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010637] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010639] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010642] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010644] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010647] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010649] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010651] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010654] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010656] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010659] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010661] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010664] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010666] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010669] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010671] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010673] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010676] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010678] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010680] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010683] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010685] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010687] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010690] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010692] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010695] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010697] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010699] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010702] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010704] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010706] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010709] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010711] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010714] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010716] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010719] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010721] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010724] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010727] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.010729] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.010732] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010734] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010737] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.010740] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.010743] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042574] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.042582] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042584] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042587] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042588] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042590] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042591] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042593] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042594] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042596] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042598] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042599] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042601] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042603] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042605] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042606] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042608] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042609] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042611] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042613] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042614] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042616] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042617] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042619] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042621] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042623] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042624] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042626] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042628] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042629] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042631] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042632] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042634] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042636] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042638] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042639] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042641] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042642] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042644] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042646] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042647] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042649] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042650] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.042652] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042654] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042655] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042657] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042659] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042660] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042662] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.042663] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.042667] gspca: frame complete
len:19670 q:3 i:3 o:2
Oct 19 17:07:12 ian2 kernel: [ 3011.042668] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.042825] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.042829] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00177438 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=7, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.042836] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.042839] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.042840] gspca: frame wait q:3 i:3 o:3
Oct 19 17:07:12 ian2 kernel: [ 3011.042842] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.042843] gspca main driver:
VIDIOC_DQBUF 00:45:11.00177438 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=7, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.042849] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.042881] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.042882] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3011.042890] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3011.042906] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.042910] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.042912] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.042916] gspca main driver: width=48,
height=32, format=RGBO, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.042918] gspca: try fmt cap RGBO 48x32
Oct 19 17:07:12 ian2 kernel: [ 3011.042920] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00177438 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=7, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.042926] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.042928] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.042930] gspca: qbuf q:0 i:3 o:3
Oct 19 17:07:12 ian2 kernel: [ 3011.042931] gspca main driver:
VIDIOC_QBUF 00:45:11.00177438 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=7, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.042937] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.042939] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.042942] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.042944] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00177438 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=7, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.042950] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.042952] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.042954] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.042956] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.074580] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.074591] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074593] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074595] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074596] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074598] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074599] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074600] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074602] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074603] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074604] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074606] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074607] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074609] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074610] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074611] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074613] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074614] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074615] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074617] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074618] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074620] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074621] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074623] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074624] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074625] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074627] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074628] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074629] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074631] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074632] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074634] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074635] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074637] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074638] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074639] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074641] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074642] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074643] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074645] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074646] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074648] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074649] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074650] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.074652] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074653] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074655] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074656] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074658] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074660] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074661] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074662] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.074664] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.074666] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.074667] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106573] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.106583] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106585] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106587] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106588] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106590] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106592] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106594] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106595] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106597] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106599] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106600] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106602] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106603] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106605] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106607] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106609] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106610] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106611] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106614] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106615] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106617] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106618] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106620] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106622] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106624] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106625] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106627] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106629] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106630] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106632] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106633] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106635] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106637] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106639] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106640] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106642] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106644] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106645] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106647] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106648] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106650] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106652] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106654] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106655] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.106657] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106658] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106660] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106662] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106663] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106665] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106666] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.106668] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.106671] gspca: frame complete
len:19670 q:0 i:0 o:3
Oct 19 17:07:12 ian2 kernel: [ 3011.106672] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.109326] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.109342] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00241442 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=8, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.109349] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.109352] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.109353] gspca: frame wait q:0 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.109355] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.109356] gspca main driver:
VIDIOC_DQBUF 00:45:11.00241442 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=8, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.109362] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.109811] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.109815] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3011.109904] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3011.109974] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.109981] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.109984] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.109987] gspca main driver: width=48,
height=32, format=RGBP, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.109990] gspca: try fmt cap RGBP 48x32
Oct 19 17:07:12 ian2 kernel: [ 3011.109991] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00241442 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=8, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.109998] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.110000] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.110001] gspca: qbuf q:1 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.110002] gspca main driver:
VIDIOC_QBUF 00:45:11.00241442 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=8, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.110008] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.110011] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.110013] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.110447] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00241442 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=8, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.110456] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.110458] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.110460] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.110462] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.138603] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.138622] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138624] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138626] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138627] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138629] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138630] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138631] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138633] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138634] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138636] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138637] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138639] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138640] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138641] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138643] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138644] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138646] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138647] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138648] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138650] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138651] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138653] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138654] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138655] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138657] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138658] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138660] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138661] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138662] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138664] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138665] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138667] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138668] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138669] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138671] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138672] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138673] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138675] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138676] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138678] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138679] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138680] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138682] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138683] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138685] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.138686] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138688] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138689] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138691] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138692] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138694] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138695] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.138697] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.138698] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.170577] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.170589] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170591] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170593] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170595] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170597] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170598] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170600] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170602] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170603] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170605] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170606] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170608] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170609] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170611] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170613] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170614] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170616] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170618] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170620] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170621] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170623] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170624] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170626] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170628] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170630] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170631] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170633] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170635] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170636] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170638] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170640] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170642] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170643] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170644] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170647] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170648] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170650] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170651] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170653] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170655] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170657] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170658] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170660] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170662] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170663] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170665] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170666] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.170668] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170670] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170672] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170673] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170675] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.170676] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.202585] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.202596] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.202598] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.202602] gspca: frame complete
len:19670 q:1 i:1 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.202603] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.202891] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.202896] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00305446 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=9, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.202904] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.202906] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.202908] gspca: frame wait q:1 i:1 o:1
Oct 19 17:07:12 ian2 kernel: [ 3011.202909] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.202910] gspca main driver:
VIDIOC_DQBUF 00:45:11.00305446 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=9, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.202916] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.203280] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.203283] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3011.203367] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3011.203433] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.203438] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.203441] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.203444] gspca main driver: width=48,
height=32, format=BGR3, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.203447] gspca: try fmt cap BGR3 48x32
Oct 19 17:07:12 ian2 kernel: [ 3011.203448] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00305446 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=9, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.203455] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.203457] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.203458] gspca: qbuf q:2 i:1 o:1
Oct 19 17:07:12 ian2 kernel: [ 3011.203459] gspca main driver:
VIDIOC_QBUF 00:45:11.00305446 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=9, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.203465] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.203468] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.203470] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.203913] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00305446 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=9, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.203920] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.203922] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.203925] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.203927] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.234580] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.234590] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234592] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.234593] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.234596] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234597] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234599] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234600] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234602] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234604] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234605] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234607] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234609] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234610] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234612] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234613] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234615] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234617] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234619] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234620] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234622] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234623] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234625] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234627] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234628] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234630] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234632] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234634] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234635] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234637] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234639] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234641] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234642] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234644] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234646] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234647] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234649] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234651] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234653] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234654] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234656] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234657] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234659] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234661] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234662] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234664] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234666] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234668] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234669] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234671] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234672] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.234674] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234676] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234678] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234679] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.234681] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.266578] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.266591] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.266593] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.266594] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.266598] gspca: frame complete
len:19670 q:2 i:2 o:1
Oct 19 17:07:12 ian2 kernel: [ 3011.266599] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.266907] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.266912] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00401452 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=10, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.266919] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.266922] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.266924] gspca: frame wait q:2 i:2 o:2
Oct 19 17:07:12 ian2 kernel: [ 3011.266925] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.266926] gspca main driver:
VIDIOC_DQBUF 00:45:11.00401452 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=10, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.266932] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.267212] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.267219] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3011.267303] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3011.267370] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.267375] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.267378] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.267381] gspca main driver: width=48,
height=32, format=BGR4, field=any, bytesperline=0 sizeimage=19200,
colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.267384] gspca: try fmt cap BGR4 48x32
Oct 19 17:07:12 ian2 kernel: [ 3011.267385] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00401452 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=10, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.267391] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.267394] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.267395] gspca: qbuf q:3 i:2 o:2
Oct 19 17:07:12 ian2 kernel: [ 3011.267396] gspca main driver:
VIDIOC_QBUF 00:45:11.00401452 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=10, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.267402] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.267405] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.267408] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.267820] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00401452 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=10, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.267827] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.267829] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.267831] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.267833] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.298585] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.298595] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298597] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298598] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298600] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.298601] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.298604] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298605] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298607] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298608] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298611] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298612] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298613] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298615] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298617] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298619] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298620] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298622] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298623] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298626] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298627] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298629] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298630] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298632] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298634] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298635] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298637] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298639] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298641] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298642] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298644] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298646] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298647] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298649] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298650] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298653] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298654] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298656] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298657] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298659] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298661] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298662] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298664] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298666] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298668] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298669] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298671] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298673] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298675] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298676] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298678] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298680] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298681] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.298683] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298685] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.298686] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.330583] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.330591] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.330594] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.330595] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.330597] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.330599] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.330602] gspca: frame complete
len:19670 q:3 i:3 o:2
Oct 19 17:07:12 ian2 kernel: [ 3011.330603] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.330917] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.330922] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00465456 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=11, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.330929] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.330932] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.330933] gspca: frame wait q:3 i:3 o:3
Oct 19 17:07:12 ian2 kernel: [ 3011.330935] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.330936] gspca main driver:
VIDIOC_DQBUF 00:45:11.00465456 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=11, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.330942] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.331433] gspca main driver:
VIDIOC_QUERYCAP driver=spca561, card=Camera, bus=0000:00:0a.1,
version=0x00020300, capabilities=0x05000001
Oct 19 17:07:12 ian2 kernel: [ 3011.331447] gspca main driver:
VIDIOC_ENUMINPUT index=0, name=spca561, type=2, audioset=0, tuner=0,
std=00000000, status=0
Oct 19 17:07:12 ian2 kernel: [ 3011.331451] gspca main driver:
VIDIOC_ENUMINPUT error -22
Oct 19 17:07:12 ian2 kernel: [ 3011.331455] gspca main driver:
VIDIOC_ENUM_FMT index=0, type=1, flags=1, pixelformat=S561,
description='S561'
Oct 19 17:07:12 ian2 kernel: [ 3011.331458] gspca main driver:
VIDIOC_TRY_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.331461] gspca: try fmt cap S561
10000x10000
Oct 19 17:07:12 ian2 kernel: [ 3011.331464] gspca main driver:
width=352, height=288, format=S561, field=none, bytesperline=352
sizeimage=50688, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.331687] gspca main driver:
VIDIOC_G_FMT type=vid-overlay
Oct 19 17:07:12 ian2 kernel: [ 3011.331691] gspca main driver:
VIDIOC_G_FMT error -22
Oct 19 17:07:12 ian2 kernel: [ 3011.331693] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.331696] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.331847] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.331850] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3011.331933] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3011.332024] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.332028] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.332031] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.332034] gspca main driver:
width=160, height=120, format=YUYV, field=any, bytesperline=0
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.332036] gspca: try fmt cap YUYV 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.332038] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00465456 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=11, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.332045] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.332047] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.332048] gspca: qbuf q:0 i:3 o:3
Oct 19 17:07:12 ian2 kernel: [ 3011.332049] gspca main driver:
VIDIOC_QBUF 00:45:11.00465456 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=11, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.332055] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.332058] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.332061] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.332509] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00465456 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=11, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.332517] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.332519] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.332521] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.332523] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.362577] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.362585] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362588] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362589] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362591] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362593] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.362594] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.362596] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362598] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362600] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362601] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362603] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362605] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362606] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362608] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362610] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362612] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362613] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362615] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362617] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362618] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362620] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362622] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362624] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362625] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362627] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362628] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362631] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362632] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362633] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362636] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362637] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362639] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362640] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362642] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362644] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362646] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362647] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362649] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362651] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362652] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362655] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362656] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362658] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362659] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362661] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362663] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362664] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362666] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362668] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362670] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362671] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362673] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362675] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.362676] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.362678] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.394589] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.394598] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.394601] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.394602] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.394604] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.394605] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.394607] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.394611] gspca: frame complete
len:19670 q:0 i:0 o:3
Oct 19 17:07:12 ian2 kernel: [ 3011.394612] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.394937] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.394942] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00529460 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=12, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.394950] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.394952] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.394954] gspca: frame wait q:0 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.394955] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.394956] gspca main driver:
VIDIOC_DQBUF 00:45:11.00529460 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=12, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.394963] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.395275] gspca: cgmbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.395280] gspca main driver:
VIDIOCGMBUF size=212992, frames=4, offsets=0xefe40b88
Oct 19 17:07:12 ian2 kernel: [ 3011.395372] gspca: mmap start:b6e4c000
size:212992
Oct 19 17:07:12 ian2 kernel: [ 3011.395442] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.395447] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.395450] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.395453] gspca main driver:
width=160, height=120, format=YUYV, field=any, bytesperline=0
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.395456] gspca: try fmt cap YUYV 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.395458] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00529460 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=12, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.395464] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.395466] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.395467] gspca: qbuf q:1 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.395469] gspca main driver:
VIDIOC_QBUF 00:45:11.00529460 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=12, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.395475] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.395477] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.395480] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.395911] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.395915] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.395917] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.395920] gspca main driver:
width=160, height=120, format=YUYV, field=any, bytesperline=0
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.395923] gspca: try fmt cap YUYV 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.395924] gspca main driver:
VIDIOC_QUERYBUF 00:44:51.00132185 index=1, type=vid-cap,
bytesused=19670, flags=0x00000000, field=1, sequence=0, memory=mmap,
offset/userptr=0x0000d000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.395930] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.395932] gspca: qbuf 1
Oct 19 17:07:12 ian2 kernel: [ 3011.395934] gspca: qbuf q:2 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.395935] gspca main driver:
VIDIOC_QBUF 00:44:51.00132185 index=1, type=vid-cap, bytesused=19670,
flags=0x00000002, field=1, sequence=0, memory=mmap,
offset/userptr=0x0000d000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.395941] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.395943] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.395945] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.396431] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.396437] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.396439] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.396442] gspca main driver:
width=160, height=120, format=YUYV, field=any, bytesperline=0
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.396444] gspca: try fmt cap YUYV 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.396446] gspca main driver:
VIDIOC_QUERYBUF 00:44:51.00164187 index=2, type=vid-cap, bytesused=0,
flags=0x00000000, field=1, sequence=0, memory=mmap,
offset/userptr=0x0001a000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.396452] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.396454] gspca: qbuf 2
Oct 19 17:07:12 ian2 kernel: [ 3011.396455] gspca: qbuf q:3 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.396456] gspca main driver:
VIDIOC_QBUF 00:44:51.00164187 index=2, type=vid-cap, bytesused=0,
flags=0x00000002, field=1, sequence=0, memory=mmap,
offset/userptr=0x0001a000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.396462] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.396464] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.396467] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.396895] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.396901] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.396903] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.396906] gspca main driver:
width=160, height=120, format=YUYV, field=any, bytesperline=0
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.396908] gspca: try fmt cap YUYV 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.396910] gspca main driver:
VIDIOC_QUERYBUF 00:00:00.00000000 index=3, type=vid-cap, bytesused=0,
flags=0x00000000, field=1, sequence=0, memory=mmap,
offset/userptr=0x00027000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.396916] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.396918] gspca: qbuf 3
Oct 19 17:07:12 ian2 kernel: [ 3011.396919] gspca: qbuf q:0 i:0 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.396920] gspca main driver:
VIDIOC_QBUF 00:00:00.00000000 index=3, type=vid-cap, bytesused=0,
flags=0x00000002, field=1, sequence=0, memory=mmap,
offset/userptr=0x00027000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.396926] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.396928] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.396931] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.397943] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00529460 index=0, type=vid-cap,
bytesused=19670, flags=0x00000003, field=1, sequence=12, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.397955] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.397958] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.397962] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.397964] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.426584] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.426596] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426598] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426599] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426601] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426603] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426604] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426606] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.426607] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.426610] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426611] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426613] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426614] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426616] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426618] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426620] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426621] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426623] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426625] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426626] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426629] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426630] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426632] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426633] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426635] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426637] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426638] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426640] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426642] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426644] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426645] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426647] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426648] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426650] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426652] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426653] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426655] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426657] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426659] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426660] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426662] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426664] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426666] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426667] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426669] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426670] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426672] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426674] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426675] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426678] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426679] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426681] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426682] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426684] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.426686] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.426687] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458581] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.458594] gspca: packet [0] o:0 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458596] gspca: packet [1] o:896 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458598] gspca: packet [2] o:1792 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458600] gspca: packet [3] o:2688 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458601] gspca: packet [4] o:3584 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458603] gspca: packet [5] o:4480 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458604] gspca: add t:3 l:0
Oct 19 17:07:12 ian2 kernel: [ 3011.458609] gspca: frame complete
len:19670 q:0 i:1 o:0
Oct 19 17:07:12 ian2 kernel: [ 3011.458611] gspca: add t:1 l:875
Oct 19 17:07:12 ian2 kernel: [ 3011.458615] gspca: poll
Oct 19 17:07:12 ian2 kernel: [ 3011.458618] gspca: packet [6] o:5376 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458620] gspca: packet [7] o:6272 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458622] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458624] gspca: packet [8] o:7168 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458626] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458628] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00593464 index=0, type=vid-cap,
bytesused=19670, flags=0x00000005, field=1, sequence=13, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.458637] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.458640] gspca: dqbuf
Oct 19 17:07:12 ian2 kernel: [ 3011.458641] gspca: packet [9] o:8064 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458643] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458646] gspca: packet [10] o:8960 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458648] gspca: frame wait q:0 i:1 o:1
Oct 19 17:07:12 ian2 kernel: [ 3011.458649] gspca: dqbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.458651] gspca main driver:
VIDIOC_DQBUF 00:45:11.00593464 index=0, type=vid-cap, bytesused=19670,
flags=0x00000001, field=1, sequence=13, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.458658] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.458661] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458663] gspca: packet [11] o:9856 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458665] gspca: packet [12] o:10752 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458666] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458668] gspca: packet [13] o:11648 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458670] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458672] gspca: packet [14] o:12544 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458673] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458675] gspca: packet [15] o:13440 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458677] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458679] gspca: packet [16] o:14336 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458680] gspca: packet [17] o:15232 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458682] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458684] gspca: packet [18] o:16128 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458686] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458688] gspca: packet [19] o:17024 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458689] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458691] gspca: packet [20] o:17920 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458693] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458695] gspca: packet [21] o:18816 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458696] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458698] gspca: packet [22] o:19712 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458700] gspca: packet [23] o:20608 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458701] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458704] gspca: packet [24] o:21504 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458705] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458707] gspca: packet [25] o:22400 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458708] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458711] gspca: packet [26] o:23296 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458712] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458714] gspca: packet [27] o:24192 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458716] gspca: packet [28] o:25088 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458717] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458719] gspca: packet [29] o:25984 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458721] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458723] gspca: packet [30] o:26880 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458724] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.458726] gspca: packet [31] o:27776 l:896
Oct 19 17:07:12 ian2 kernel: [ 3011.458728] gspca: add t:2 l:895
Oct 19 17:07:12 ian2 kernel: [ 3011.472955] gspca main driver:
VIDIOC_G_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.472969] gspca main driver:
width=160, height=120, format=GBRG, field=none, bytesperline=160
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.472973] gspca main driver:
VIDIOC_S_FMT type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.472979] gspca main driver:
width=160, height=120, format=YUYV, field=any, bytesperline=0
sizeimage=19200, colorspace=8
Oct 19 17:07:12 ian2 kernel: [ 3011.472984] gspca: try fmt cap YUYV 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.472986] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00593464 index=0, type=vid-cap,
bytesused=19670, flags=0x00000001, field=1, sequence=13, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.472996] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.473013] gspca: qbuf 0
Oct 19 17:07:12 ian2 kernel: [ 3011.473016] gspca: qbuf q:1 i:1 o:1
Oct 19 17:07:12 ian2 kernel: [ 3011.473018] gspca main driver:
VIDIOC_QBUF 00:45:11.00593464 index=0, type=vid-cap, bytesused=19670,
flags=0x00000003, field=1, sequence=13, memory=mmap,
offset/userptr=0x00000000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.473027] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.473030] gspca main driver:
VIDIOC_STREAMON type=vid-cap
Oct 19 17:07:12 ian2 kernel: [ 3011.473036] gspca: stream on OK GBRG 160x120
Oct 19 17:07:12 ian2 kernel: [ 3011.473040] gspca main driver:
VIDIOC_QUERYBUF 00:45:11.00625466 index=1, type=vid-cap,
bytesused=19670, flags=0x00000002, field=1, sequence=14, memory=mmap,
offset/userptr=0x0000d000, length=53248
Oct 19 17:07:12 ian2 kernel: [ 3011.473050] gspca main driver:
timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Oct 19 17:07:12 ian2 kernel: [ 3011.473494] gspca: gst-launch-0.10 close
Oct 19 17:07:12 ian2 kernel: [ 3011.473932] spca561: reg write: 0x8112:0x0e
Oct 19 17:07:12 ian2 kernel: [ 3011.473937] gspca: kill transfer
Oct 19 17:07:12 ian2 kernel: [ 3011.490086] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.522091] gspca: isoc irq
Oct 19 17:07:12 ian2 kernel: [ 3011.527209] spca561: reg write: 0x8118:0x29
Oct 19 17:07:12 ian2 kernel: [ 3011.527453] spca561: reg write: 0x8114:0x08
Oct 19 17:07:12 ian2 kernel: [ 3011.527508] gspca: stream off OK
Oct 19 17:07:12 ian2 kernel: [ 3011.527564] gspca: frame free
Oct 19 17:07:12 ian2 kernel: [ 3011.527672] gspca: close done
-----------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
