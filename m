Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SE9Qe0019807
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 10:09:26 -0400
Received: from MTA006E.interbusiness.it (MTA006E.interbusiness.it [88.44.62.6])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SE9Aj5029477
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 10:09:10 -0400
Message-ID: <47ECFBFC.4070708@gmail.com>
Date: Fri, 28 Mar 2008 15:09:00 +0100
From: Mat <heavensdoor78@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Empia em28xx based USB video device...
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
I have an em2821 device ( brand Digitus ) and some problems with it.
+ lsusb:
Bus 001 Device 004: ID eb1a:2821 eMPIA Technology, Inc.

I have 2 situations:
+ machine1: standard PC - kernel 2.6.24.3 - CPU AMD - 512 Mb RAM - last 
snapshot of v4l-dvb ( 2 days ago )
   if I load the module ( em28xx ) with card=0 ( Unknown EM2800 video 
grabber ) it doesn't work ( tested with xawtv )
   if I load the module ( em28xx ) with card=1 ( Unknown EM2750/28xx 
video grabber ) it doesn't work ( tested with xawtv )
   if I load the module ( em28xx ) with card=9 ( Pinnacle Dazzle DVC 
90/DVC 100 ) it works ok...
+ machine2: SBC - kernel 2.6.24.3 - CPU x86 ( like a 586 ) - 64 Mb RAM - 
last snapshot of v4l-dvb ( 2 days ago )
   if I load the module ( em28xx ) with card=0 ( Unknown EM2800 video 
grabber ) it doesn't work ( tested with xawtv )
   if I load the module ( em28xx ) with card=1 ( Unknown EM2750/28xx 
video grabber ) it doesn't work ( tested with xawtv )
   if I load the module ( em28xx ) with card=9 ( Pinnacle Dazzle DVC 
90/DVC 100 ) it works badly... I get something like an image compressed 
in the firt rows... ( image here: 
http://www.flickr.com/photos/17101105@N00/2368937536/ )

Same module parameters, same kernel config (changed only the CPU), same 
distro (Debian Etch).
Any ideas...?

dmesg for these machines ( card=9 ):
+ machine1:
[  198.848725] Linux video capture interface: v2.00
[  198.872627] em28xx v4l2 driver version 0.1.0 loaded
[  198.872680] em28xx new video device (eb1a:2821): interface 0, class 255
[  198.872690] em28xx Has usb audio class
[  198.872693] em28xx #0: Alternate settings: 8
[  198.872696] em28xx #0: Alternate setting 0, max size= 0
[  198.872699] em28xx #0: Alternate setting 1, max size= 1024
[  198.872702] em28xx #0: Alternate setting 2, max size= 1448
[  198.872705] em28xx #0: Alternate setting 3, max size= 2048
[  198.872708] em28xx #0: Alternate setting 4, max size= 2304
[  198.872711] em28xx #0: Alternate setting 5, max size= 2580
[  198.872714] em28xx #0: Alternate setting 6, max size= 2892
[  198.872717] em28xx #0: Alternate setting 7, max size= 3072
[  198.873529] em28xx #0: em28xx chip ID = 18
[  199.894188] saa7115' 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a 
(em28xx #0)
[  202.023636] em28xx #0: V4L2 device registered as /dev/video0 and 
/dev/vbi0
[  202.023647] em28xx #0: Found Pinnacle Dazzle DVC 90/DVC 100
[  202.023678] em28xx audio device (eb1a:2821): interface 1, class 1
[  202.023696] em28xx audio device (eb1a:2821): interface 2, class 1
[  202.023723] usbcore: registered new interface driver em28xx
+ machine2:
[ 4097.440853] Linux video capture interface: v2.00
[ 4097.523858] em28xx v4l2 driver version 0.1.0 loaded
[ 4097.527087] em28xx new video device (eb1a:2821): interface 0, class 255
[ 4097.529568] em28xx Has usb audio class
[ 4097.532138] em28xx #0: Alternate settings: 8
[ 4097.535497] em28xx #0: Alternate setting 0, max size= 0
[ 4097.537769] em28xx #0: Alternate setting 1, max size= 512
[ 4097.540333] em28xx #0: Alternate setting 2, max size= 640
[ 4097.542892] em28xx #0: Alternate setting 3, max size= 768
[ 4097.550248] em28xx #0: Alternate setting 4, max size= 832
[ 4097.552683] em28xx #0: Alternate setting 5, max size= 896
[ 4097.554952] em28xx #0: Alternate setting 6, max size= 960
[ 4097.558217] em28xx #0: Alternate setting 7, max size= 1020
[ 4097.563767] em28xx #0: em28xx chip ID = 18
[ 4098.712659] saa7115' 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a 
(em28xx #0)
[ 4100.859282] em28xx #0: V4L2 device registered as /dev/video0 and 
/dev/vbi0
[ 4100.859513] em28xx #0: Found Pinnacle Dazzle DVC 90/DVC 100
[ 4100.859899] em28xx audio device (eb1a:2821): interface 1, class 1
[ 4100.860353] em28xx audio device (eb1a:2821): interface 2, class 1
[ 4100.860835] usbcore: registered new interface driver em28xx


dmesg when I get a frame:
+ machine1:
[  325.500770] em28xx #0 em28xx_v4l2_open :open minor=0 type=video-cap 
users=0
[  325.501025] em28xx #0 em28xx_set_alternate :minimum isoc packet size: 
2888 (alt=6)
[  325.501129] em28xx #0 em28xx_set_alternate :setting alternate 6 with 
wMaxPacketSize=2892
[  325.607430] em28xx #0 em28xx_accumulator_set :em28xx Scale: 
(1,1)-(179,71)
[  325.687483] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
[  325.848541] em28xx #0 em28xx_init_isoc :Submitting 5 urbs of 40 
packets (2892 each)
[  325.917396] em28xx #0 em28xx_set_alternate :minimum isoc packet size: 
708 (alt=1)
[  325.917635] em28xx #0 em28xx_set_alternate :setting alternate 1 with 
wMaxPacketSize=1024
[  326.027345] em28xx #0 em28xx_accumulator_set :em28xx Scale: 
(1,1)-(179,71)
[  326.107364] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
[  326.267676] em28xx #0 em28xx_init_isoc :Submitting 5 urbs of 40 
packets (1024 each)
[  326.268090] em28xx #0 em28xx_request_buffers :requested 8 buffers 
with size 204800
[  326.567226] em28xx #0 em28xx_accumulator_set :em28xx Scale: 
(1,1)-(179,71)
[  326.647213] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
[  326.988678] em28xx #0 vidioc_streamoff :VIDIOC_STREAMOFF: 
interrupting stream
[  327.187180] em28xx #0 em28xx_v4l2_close :users=1
[  327.267154] em28xx #0 em28xx_v4l2_close :setting alternate 0
+ machine2:
[ 4122.561436] em28xx #0 em28xx_v4l2_open :open minor=0 type=video-cap 
users=0
[ 4122.564097] em28xx #0 em28xx_set_alternate :minimum isoc packet size: 
2888 (alt=7)
[ 4122.566725] em28xx #0 em28xx_set_alternate :setting alternate 7 with 
wMaxPacketSize=1020
[ 4122.698385] em28xx #0 em28xx_accumulator_set :em28xx Scale: 
(1,1)-(179,71)
[ 4122.778116] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
[ 4122.945537] em28xx #0 em28xx_init_isoc :Submitting 5 urbs of 40 
packets (1020 each)
[ 4122.998140] em28xx #0 em28xx_set_alternate :minimum isoc packet size: 
708 (alt=3)
[ 4123.000799] em28xx #0 em28xx_set_alternate :setting alternate 3 with 
wMaxPacketSize=768
[ 4123.128254] em28xx #0 em28xx_accumulator_set :em28xx Scale: 
(1,1)-(179,71)
[ 4123.208133] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
[ 4123.373769] em28xx #0 em28xx_init_isoc :Submitting 5 urbs of 40 
packets (768 each)
[ 4123.375432] em28xx #0 em28xx_request_buffers :requested 8 buffers 
with size 204800
[ 4123.698138] em28xx #0 em28xx_accumulator_set :em28xx Scale: 
(1,1)-(179,71)
[ 4123.778138] em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
[ 4124.132320] em28xx #0 vidioc_streamoff :VIDIOC_STREAMOFF: 
interrupting stream
[ 4124.329479] em28xx #0 em28xx_v4l2_close :users=1
[ 4124.378950] em28xx #0 em28xx_v4l2_close :setting alternate 0


I saw that there's a difference with the "Alternate settings" but I 
don't know what are they...
Help please !! :)

Thank you in advance...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
