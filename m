Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1669 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZGDSyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jul 2009 14:54:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Short experiment with libudev to support media controller concept
Date: Sat, 4 Jul 2009 20:54:02 +0200
Cc: linux-media@vger.kernel.org
References: <1246729935.2826.43.camel@morgan.walls.org>
In-Reply-To: <1246729935.2826.43.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907042054.02393.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 04 July 2009 19:52:15 Andy Walls wrote:
> Hans,
> 
> The inline source file at the end of this post is a small program I used
> to play with libudev to see if it would complement the media controller
> concept (as you suspected it would).
> 
> Documentation on the libudev calls is here:
> 
> 	http://www.kernel.org/pub/linux/utils/kernel/hotplug/libudev/
> 
> The test program I wrote takes a (type,major,minor) tuple and lists the
> device node and device symlinks as fetched by libudev.
> 
> My test setup was a little strange since libudev is no longer maintained
> separately but is bundled in with udev.  On my Fedora 9 system I have
> udev v124 (Fedora 9 stock) and libudev v143 (custom built from the udev
> 143 source).
> 
> Here's some output:
> 
> $ ./finddev -c -M 1 -m 3
> Requested device: type 'c', major 1, minor 3
> Device directory path: '/dev'
> Device node: '/dev/null'
> Device link: '/dev/XOR'
> 
> $ ls -al /dev/ | grep '[ /]null'
> crw-rw-rw-   1 root root     1,   3 2009-07-04 08:34 null
> lrwxrwxrwx   1 root root          4 2009-07-04 08:34 X0R -> null
> lrwxrwxrwx   1 root root          4 2009-07-04 08:34 XOR -> null
> 
> (Hmmm, not perfect for /dev/null)
> 
> 
> $ ./finddev -b -M 11 -m 0
> Requested device: type 'b', major 11, minor 0
> Device directory path: '/dev'
> Device node: '/dev/sr0'
> Device link: '/dev/scd0'
> Device link: '/dev/disk/by-path/pci-0000:00:14.1-scsi-1:0:0:0'
> Device link: '/dev/cdrom'
> Device link: '/dev/cdrw'
> 
> $ ls -alR /dev/* | grep '[ /]sr0'
> lrwxrwxrwx  1 root root          3 2009-07-04 08:34 /dev/cdrom -> sr0
> lrwxrwxrwx  1 root root          3 2009-07-04 08:34 /dev/cdrw -> sr0
> lrwxrwxrwx  1 root root          3 2009-07-04 08:34 /dev/scd0 -> sr0
> brw-rw----+ 1 root disk    11,   0 2009-07-04 08:34 /dev/sr0
> lrwxrwxrwx 1 root root   9 2009-07-04 08:34 pci-0000:00:14.1-scsi-1:0:0:0 -> ../../sr0
> 
> (OK for the CDROM drive.)
> 
> 
> $ ./finddev -c -M 81 -m 9
> Requested device: type 'c', major 81, minor 9
> Device directory path: '/dev'
> Device node: '/dev/video0'
> Device link: '/dev/video'
> 
> $ ls -alR /dev/* | grep '[ /]video0'
> lrwxrwxrwx  1 root root          6 2009-07-04 08:34 /dev/video -> video0
> crw-rw----+ 1 root root    81,   9 2009-07-04 08:34 /dev/video0
> 
> (OK for video nodes)
> 
> 
> $ ./finddev -c -M 116 -m 6
> Requested device: type 'c', major 116, minor 6
> Device directory path: '/dev'
> Device node: '/dev/snd/pcmC0D0p'
> 
> $ ls -alR /dev/* | grep '[ /]pcmC0D0p'
> crw-rw----+  1 root root 116, 6 2009-07-04 13:43 pcmC0D0p
> 
> (OK for ALSA PCM stream nodes).
> 
> 
> Do you have any other particular questions about libudev's capabilities?

Hi Andy,

This looks very promising. Can you try a few things like adding new symlinks
for video devices in the udev config file, or renaming the video0 node to,
say, mpeg0? If finddev still returns the right nodes, then all that a media
controller needs to do is to export the major and minor numbers for each
node. That's exactly what I'm hoping for.

Note that I will not have a lot of time to work in v4l-dvb for the next 10 to
14 days as I have visitors this week and will be traveling abroad next week.

Thanks!

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
