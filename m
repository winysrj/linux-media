Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with SMTP id n5CJFO0V025021
	for <video4linux-list@redhat.com>; Fri, 12 Jun 2009 15:15:24 -0400
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com
	[66.111.4.26])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n5CJF6oF029140
	for <video4linux-list@redhat.com>; Fri, 12 Jun 2009 15:15:06 -0400
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 5F8B03604D0
	for <video4linux-list@redhat.com>; Fri, 12 Jun 2009 15:15:06 -0400 (EDT)
Message-Id: <1244834106.19673.1320127457@webmail.messagingengine.com>
From: "Kay Wrobel" <kwrobel@letterboxes.org>
To: "V4L Mailing List" <video4linux-list@redhat.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 14:15:06 -0500
Subject: SUCCESS - KWorld VS-USB2800D recognized as PointNix Intra-Oral
 Camera - No Composite Input
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

Dear folks @ V4L List,

I'd just quickly like to let everybody know that I am now able to
capture S-Video AND Composite video from my KWorld VS-USB2800D using the
latest development snapshot of v4l-dvb. Kudos to Douglas Schilling
Landgraf for helping me with the steps to download and recompile the
v4l-dvb drivers, specifically the em28xx driver which pertains to my
capture device.

As a nice side effect, I am also now able to select a new audio capture
device embedded in the VS-USB2800D device instead of using the extra
line-in wire that comes out of the device. I used to have to feed that
cable into the line-in of my sound card. Now, I get an actual device
called "Empia Em28xx Audio Empia 28xx Capture (ALSA)" in Ubuntu's Sound
Preferences dialog.

These are the steps I followed to get the driver downloaded and compiled
(again, thanks Douglas):

1) rmmod em28xx (remove any driver pre-loaded)

2) Check version of your kernel
   uname -r

3) Making backup
   cp -R /lib/modules/KERNELVERSION/kernel/drivers/media/video/em28xx
      /BACKUPDIR

4) Installing dev stuff
   apt-get install build-essential mercurial -y

5) Download and recompile
shell> hg clone http://www.linuxtv.org/hg/v4l-dvb
shell> cd v4l-dvb
shell> make
shell> make unload
shell> make install 
shell> dmesg -c  (clear your dmesg)
shell> modprobe em28xx 

The new dmesg output is:
> [13703.852052] usb 1-6: new high speed USB device using ehci_hcd and address 6
> [13703.985055] usb 1-6: configuration #1 chosen from 1 choice
> [13704.110261] Linux video capture interface: v2.00
> [13704.142555] em28xx: New device @ 480 Mbps (eb1a:2860, interface 0, class 0)
> [13704.143637] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
> [13704.145734] em28xx #0: chip ID is em2860
> [13704.238342] em28xx #0: board has no eeprom
> [13704.252594] em28xx #0: found i2c device @ 0x4a [saa7113h]
> [13704.286824] em28xx #0: Your board has no unique USB ID.
> [13704.286836] em28xx #0: A hint were successfully done, based on i2c devicelist hash.
> [13704.286843] em28xx #0: This method is not 100% failproof.
> [13704.286849] em28xx #0: If the board were missdetected, please email this log to:
> [13704.286854] em28xx #0:     V4L Mailing List  <linux-media@vger.kernel.org>
> [13704.286859] em28xx #0: Board detected as EM2860/SAA711X Reference Design
> [13704.286865] em28xx #0: Registering snapshot button...
> [13704.287002] input: em28xx snapshot button as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input7
> [13704.712507] saa7115 3-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> [13705.448275] em28xx #0: Config register raw data: 0x00
> [13705.448286] em28xx #0: No AC97 audio processor
> [13705.548029] em28xx #0: v4l2 driver version 0.1.2
> [13705.832260] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> [13705.832324] usbcore: registered new interface driver em28xx
> [13705.832332] em28xx driver loaded
> [13705.871760] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [13705.871780] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [13705.876321] Em28xx: Initialized (Em28xx Audio Extension) extension

So finally I can use the device the way I had intended it to: Play Super
Mario Galaxy on my Wii connected to my laptop ;-)

Cheers.


----- Original message -----
From: "Kay Wrobel" <kwrobel@letterboxes.org>
To: "V4L Mailing List" <video4linux-list@redhat.com>
Date: Tue, 09 Jun 2009 14:58:01 -0500
Subject: KWorld VS-USB2800D recognized as PointNix Intra-Oral Camera -
No Composite Input

Hi video4linux list,

This may be something that has been asked in the past. I have a KWorld
VS-USB2800D video capture device and my Ubuntu 9.04 Jaunty recognizes it
as a PointNix Intra-Oral Camera. The only thing that works is the
S-Video input. However, I'd like to use the Composite input (regular
yellow RCA). So here's the dmesg:

[18325.975026] usb 3-2.2: USB disconnect, address 7
[18406.553718] usb 3-2.2: new full speed USB device using uhci_hcd and
address 8
[18406.655706] usb 3-2.2: not running at top speed; connect to a high
speed hub
[18406.664296] usb 3-2.2: configuration #1 chosen from 1 choice
[18406.666788] hub 3-2.2:1.0: USB hub found
[18406.668783] hub 3-2.2:1.0: 4 ports detected
[20149.760030] usb 1-6: new high speed USB device using ehci_hcd and
address 5
[20149.892966] usb 1-6: configuration #1 chosen from 1 choice
[20149.954275] Linux video capture interface: v2.00
[20149.964580] em28xx v4l2 driver version 0.1.0 loaded
[20149.964632] em28xx new video device (eb1a:2860): interface 0, class
255
[20149.964640] em28xx Doesn't have usb audio class
[20149.964645] em28xx #0: Alternate settings: 8
[20149.964649] em28xx #0: Alternate setting 0, max size= 0
[20149.964653] em28xx #0: Alternate setting 1, max size= 0
[20149.964657] em28xx #0: Alternate setting 2, max size= 1448
[20149.964661] em28xx #0: Alternate setting 3, max size= 2048
[20149.964666] em28xx #0: Alternate setting 4, max size= 2304
[20149.964670] em28xx #0: Alternate setting 5, max size= 2580
[20149.964674] em28xx #0: Alternate setting 6, max size= 2892
[20149.964678] em28xx #0: Alternate setting 7, max size= 3072
[20149.964926] em28xx #0: chip ID is em2860
[20150.196540] em28xx #0: board has no eeprom
[20150.210897] em28xx #0: found i2c device @ 0x4a [saa7113h]
[20150.252142] em28xx #0: Your board has no unique USB ID.
[20150.252150] em28xx #0: A hint were successfully done, based on i2c
devicelist hash.
[20150.252155] em28xx #0: This method is not 100% failproof.
[20150.252160] em28xx #0: If the board were missdetected, please email
this log to:
[20150.252164] em28xx #0:       V4L Mailing List 
<video4linux-list@redhat.com>
[20150.252170] em28xx #0: Board detected as PointNix Intra-Oral Camera
[20150.252175] em28xx #0: Registering snapshot button...
[20150.252411] input: em28xx snapshot button as
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input6
[20150.643094] saa7115' 4-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[20151.920343] em28xx #0: V4L2 device registered as /dev/video0 and
/dev/vbi0
[20151.920351] em28xx #0: Found PointNix Intra-Oral Camera
[20151.920395] usbcore: registered new interface driver em28xx
[20151.927004] em28xx-audio.c: probing for em28x1 non standard usbaudio
[20151.927009] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[20151.927534] Em28xx: Initialized (Em28xx Audio Extension) extension

Notice how it only generates /dev/video0 and /dev/vbi0. I would have
expected to see two additional devices, like /dev/video1 and /dev/vbi1.

Maybe the detected Intra-Oral camera doesn't have that input, but the
KWorld VS-USB2008D does. What can be done to make the driver recognize
the Composite input correctly?

Thanks for any help...
-- 
  Kay Wrobel
  kwrobel@letterboxes.org

-- 
http://www.fastmail.fm - IMAP accessible web-mail

--
video4linux-list mailing list
Unsubscribe
mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
-- 
  Kay Wrobel
  kwrobel@letterboxes.org

-- 
http://www.fastmail.fm - Email service worth paying for. Try it for free

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
