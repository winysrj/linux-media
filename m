Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47AgUtW016851
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 06:42:30 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m47Ag8Ul020465
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 06:42:08 -0400
Received: by rv-out-0506.google.com with SMTP id f6so277703rvb.51
	for <video4linux-list@redhat.com>; Wed, 07 May 2008 03:42:07 -0700 (PDT)
Message-ID: <d9def9db0805070342m77ba0ce2obf39299e43a1029a@mail.gmail.com>
Date: Wed, 7 May 2008 12:42:07 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Clinton Taylor" <clintonlee.taylor@gmail.com>
In-Reply-To: <b7b14cbb0805070242s34f6aaf5r39f6226bcdd8af5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b7b14cbb0805070242s34f6aaf5r39f6226bcdd8af5f@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: KWorld VS-USB2800D ...
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

On 5/7/08, Clinton Taylor <clintonlee.taylor@gmail.com> wrote:
> Greetings ...
>
>  Been lurking on the list for about two weeks and hoping that maybe
> somebody can help me ...
>
>  I have a KWorld USB Capture device marked VS-USB2800D.  I'm hoping to
> use it along with a few other capture devices to test ZoneMinder and
> do a few other video capture things ...
>
>  I'm running Fedora 8 64bit with Kernel 2.6.24.5-85.fc8 ...
>
>  When I plug in the device I get ...
>
> May  7 11:10:06 zeus kernel: usb 1-7: new high speed USB device using
> ehci_hcd and address 7
> May  7 11:10:06 zeus kernel: usb 1-7: configuration #1 chosen from 1 choice
> May  7 11:10:06 zeus kernel: em28xx v4l2 driver version 0.0.1 loaded
> May  7 11:10:06 zeus kernel: em28xx new video device (eb1a:2820):
> interface 0, class 255
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate settings: 8
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 0, max size= 0
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 1, max size= 1024
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 2, max size= 1448
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 3, max size= 2048
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 4, max size= 2304
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 5, max size= 2580
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 6, max size= 2892
> May  7 11:10:06 zeus kernel: em28xx #0: Alternate setting 7, max size= 3072
> May  7 11:10:06 zeus kernel: saa7115 6-0025: saa7113 found
> (1f7113d0e100000) @ 0x4a (em28xx #0)
> May  7 11:10:07 zeus kernel: registered VBI
> May  7 11:10:07 zeus kernel: em28xx #0: V4L2 device registered as
> /dev/video2 and /dev/vbi0
> May  7 11:10:07 zeus kernel: em28xx #0: Found MSI VOX USB 2.0
> May  7 11:10:07 zeus kernel: usbcore: registered new interface driver em28xx
>
>  If you see two lines from the bottom, it lists the device as a MSI
> VOX USB 2.0 ... I would think this device is a KWorld USB2800, but I'm
> able to capture with default settings, but not full frame ...  It
> seems that I can only capture 640 of 768 and 480 of 576, which means
> part of the image is missing ... If anybody was samples to explain
> better, I sure I can send them some ...
>

could you try
$ hg clone http://mcentral.de/~mrec/v4l-dvb-experimental
$ cd v4l-dvb-experimental
$ make

> If I modprobe -r em28xx and force as KWorld USB2800 with modprobe
> em28xx i2c_scan=1 card=8 ...
>
> May  7 11:20:57 zeus kernel: em28xx v4l2 driver version 0.0.1 loaded
> May  7 11:20:57 zeus kernel: em28xx new video device (eb1a:2820):
> interface 0, class 255
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate settings: 8
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 0, max size= 0
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 1, max size= 1024
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 2, max size= 1448
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 3, max size= 2048
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 4, max size= 2304
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 5, max size= 2580
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 6, max size= 2892
> May  7 11:20:57 zeus kernel: em28xx #0: Alternate setting 7, max size= 3072
> May  7 11:21:03 zeus kernel: registered VBI
> May  7 11:21:03 zeus kernel: em28xx #0: V4L2 device registered as
> /dev/video2 and /dev/vbi0
> May  7 11:21:03 zeus kernel: em28xx #0: Found Kworld USB2800
> May  7 11:21:03 zeus kernel: usbcore: registered new interface driver em28xx
>
> But then the captures are all current with just black and white fuzzy lines
> ...
>
> Is there a bug with the kernel driver or is this a short coming of the
> capture device?
>

ya the saa711x chipdriver is very likely broken for some devices.

> What are suggested good USB video capture devices with S-Video/
> Composite and build-in audio, not pass-through ... Maybe something
> like" HAUPPAUGE WinTV-PVR USB 2.0 External Video Capture Card", but
> cheaper ...
>

Haupauge WinTV USB 2.0

http://geizhals.at/img/pix/3299.jpg

that device should work, svideo/composite might need some more work I
have that device somewhere here.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
