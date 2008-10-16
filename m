Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GLPR50019211
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 17:25:27 -0400
Received: from mx1.wp.pl (mx1.wp.pl [212.77.101.5])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m9GLPCi2027359
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 17:25:13 -0400
Received: from poczta-15.free.wp-sa.pl (HELO localhost) ([10.1.1.43])
	(envelope-sender <jurskij@wp.pl>) by smtp.wp.pl (WP-SMTPD) with SMTP
	for <video4linux-list@redhat.com>; 16 Oct 2008 23:25:03 +0200
Date: Thu, 16 Oct 2008 23:25:02 +0200
From: "Janusz Jurski" <jurskij@wp.pl>
To: video4linux-list@redhat.com
Message-ID: <48f7b12e150698.01964229@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Subject: Problem with gspca driver
Reply-To: jj@ds.pg.gda.pl
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

Hi,

I have a problem with gspca driver for my USB camera. My kernel is 
2.6.18. I followed the instructions at 
http://moinejf.free.fr/gspca_README.txt to build and install the driver 
and v4l library. When I plug in my camera the sonixj module gets loaded 
to support it (0c45:612a Microdia) and the /dev/video0 device appears - 
no errors or suspicious messages in kernel log returned by dmesg:

usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
gspca: main v2.3.0 registered
gspca: probing 0c45:612a
sonixj: Sonix chip id: 12
videodev: "" has no release callback. Please fix your driver for proper 
sysfs support, see http://lwn.net/Articles/36850/
gspca: probe ok
usbcore: registered new driver sonixj
sonixj: registered

But when I start streamer, I get the following errors:
jj@piw:/mnt/dane/samba/motion.src$
LD_PRELOAD=/usr/local/lib/libv4l/v4l1compat.so streamer -ddd -o a.jpeg
checking writer files [multiple image files] ...
  video name=ppm ext=ppm: ext mismatch [need jpeg]
  video name=pgm ext=pgm: ext mismatch [need jpeg]
  video name=jpeg ext=jpeg: OK
files / video: JPEG (JFIF) / audio: none
vid-open: trying: v4l2-old...
vid-open: failed: v4l2-old
vid-open: trying: v4l2...
ioctl: 
VIDIOC_QUERYCAP(driver="";card="";bus_info="";version=0.0.0;capabilities=0x0[]): 
Invalid argument
vid-open: failed: v4l2
vid-open: trying: v4l...
vid-open: failed: v4l
no grabber device available
jj@piw:/mnt/dane/samba/motion.src$

A similar error when starting motion:
jj@piw:/mnt/dane/samba/motion.src/motion-3.2.3$
LD_PRELOAD=/usr/local/lib/libv4l/v4l1compat.so ./motion -n -ddd -c 
`pwd`/motion.conf
[0] Processing thread 0 - config file 
/mnt/dane/samba/motion.src/motion-3.2.3/motion.conf
[1] Thread is from /mnt/dane/samba/motion.src/motion-3.2.3/motion.conf
[1] Thread started
[1] ioctl (VIDIOCGCAP): Invalid argument
[1] Capture error calling vid_start
[1] Thread finishing...
jj@piw:/mnt/dane/samba/motion.src/motion-3.2.3$

The same problem when starting streamer or motion with root privileges. 
Any idea what is wrong? What is the reason of the errors

Regards,
JJ

----------------------------------------------------
Kto jest bardziej SEXY?! 
Tysi±ce zdjêæ i profili 
najseksowaniejszych Polaków! 
Do³±cz do nich: http://klik.wp.pl/?adr=http%3A%2F%2Fcorto.www.wp.pl%2Fas%2Famisexy.html&sid=523


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
