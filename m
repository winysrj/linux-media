Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6KClnhM027708
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 08:47:49 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6KClb3B018692
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 08:47:37 -0400
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id m6KCla9l025225
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>;
	Sun, 20 Jul 2008 14:47:36 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sun, 20 Jul 2008 14:47:35 +0200
References: <200807181625.12619.hverkuil@xs4all.nl>
In-Reply-To: <200807181625.12619.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807201447.35659.hverkuil@xs4all.nl>
Subject: An example for RFC: Add support to query and change connections
	inside a media device
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

I've been playing around with a simple controller device and udev to see 
how to make this work.

While it is not difficult to create a controller device and allow 
application to query which v4l2, alsa, etc. devices there are, it is 
another matter on how to setup a /dev/v4l hierarchy so that the user 
knows which /dev device to open when the application returns 
dvb0.demux0 or video0 or fb1 or something like that.

After some experimentation I found that the following works quite well, 
and it's easy to implement too.

After a driver creates a media controller device, all other devices it 
creates will have the media controller as their parent device. As far 
as I can tell this works in all cases, also for alsa drivers like 
cx88-alsa.

With a few simple additional rules in udev I can contruct the following:

$ l /dev/v4l/ -lR
/dev/v4l/:
total 0
drwxr-xr-x 2 root root    140 Jul 20 14:03 controller0/
drwxr-xr-x 2 root root    160 Jul 20 14:03 controller1/
crw-rw---- 1 root root 81,  0 Jul 20 14:03 video0
crw-rw---- 1 root root 81, 24 Jul 20 14:03 video24
crw-rw---- 1 root root 81, 32 Jul 20 14:03 video32

/dev/v4l/controller0:
total 0
crw-rw---- 1 root root 81, 200 Jul 20 14:03 controller
lrwxrwxrwx 1 root root      11 Jul 20 14:03 i2c-4 -> ../../i2c-4
lrwxrwxrwx 1 root root       9 Jul 20 14:03 video0 -> ../video0
lrwxrwxrwx 1 root root      10 Jul 20 14:03 video24 -> ../video24
lrwxrwxrwx 1 root root      10 Jul 20 14:03 video32 -> ../video32

/dev/v4l/controller1:
total 0
crw-rw---- 1 root root 81, 201 Jul 20 14:03 controller
lrwxrwxrwx 1 root root      17 Jul 20 14:03 
dvb0.demux0 -> ../../dvb0.demux0
lrwxrwxrwx 1 root root      15 Jul 20 14:03 dvb0.dvr0 -> ../../dvb0.dvr0
lrwxrwxrwx 1 root root      20 Jul 20 14:03 
dvb0.frontend0 -> ../../dvb0.frontend0
lrwxrwxrwx 1 root root      15 Jul 20 14:03 dvb0.net0 -> ../../dvb0.net0
lrwxrwxrwx 1 root root      11 Jul 20 14:03 i2c-5 -> ../../i2c-5

This is for the cx18 driver that I hacked. It has two controllers 
(artificial separation, normally cx18 will have one controller only. 
But ivtv will have two, one for the encoder, one for the decoder).

For each controller a subdirectory is made and inside that there is the 
controller device itself and links to all the child devices. I've even 
added the i2c bus here, although I think that might be overkill.

Since all these devices are children of the mediacontroller it is likely 
that for most existing drivers the mediacontroller part can just 
iterate over its children and return the relevant data. It would be 
very nice if this can be done, since that will make it very easy to add 
media controller support to existing drivers.

And applications can just open a controller device, read the names of 
available devices (e.g. video1) and open the device 
(/dev/v4l/controller0/video1). This method should adapt automatically 
if the udev rules change and, say, the alsa devices are suddenly in a 
non-standard directory. As long as the application has the path to the 
controller it can find the other devices by substituting 'controller' 
with 'video0' or 'dvb0.dvr0', etc.

Also note that no changes are made to the existing device nodes. It's 
just the addition of controller directories and their contents. So it 
remains fully backwards compatible (as it should be).

One reason why I am working on reducing videodev.c to a module that just 
does v4l device registration is that having a 'lean and mean' videodev 
module makes it possible for other media-related subsystems (alsa and 
dvb spring to mind) to also create a controller device. They would not 
want the overhead of the video4linux ioctl stuff, but just a controller 
device for applications to use.

It will probably only matter for drivers that use several subsystems. A 
purely dvb or alsa driver should not need it.

For those who are interested: the udev rules I've added are:

SUBSYSTEM=="video4linux", PROGRAM="v4l_controller", SYMLINK+="%c"
SUBSYSTEM=="dvb", PROGRAM="v4l_controller", SYMLINK+="%c"
SUBSYSTEM=="i2c*", PROGRAM="v4l_controller", SYMLINK+="%c"

and here is the magic v4l_controller script:

#!/bin/sh
shopt -s nullglob
dev=${DEVPATH##*/}
controller=`echo -n /sys/$PHYSDEVPATH/video4linux:controller*`
if [ -n "$controller" ]; then
        ctrl=`echo /sys/$PHYSDEVPATH/video4linux:controller*/*:$dev`
        ctrl=${ctrl#*video4linux:}
        ctrl=${ctrl%%/*}
        echo v4l/$ctrl/$dev
fi

Basically it checks if the device has one or more controllers, then it 
finds out which controller is the parent and returns the corresponding 
link.

As usual, comments are welcome.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
