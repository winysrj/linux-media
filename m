Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANId8XE001859
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 13:39:08 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANIcP5v025192
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 13:38:26 -0500
Message-ID: <4929A47E.4030302@hhs.nl>
Date: Sun, 23 Nov 2008 19:44:14 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: libv4l release: 0.5.6 (The UVC release)
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

Hi All,

And another release, well 2 actually, so close together I never got a change to 
release 0.5.5, but as it is out there, I decided to things properly and jump to 
0.5.6 for the second fix in this announcement.

So these 2 releases are all about UVC, uvc cams support the enum_framesize 
ioctrl, and gstreamer uses this and then also tries the enum_framerate ioctrl, 
libv4l used to generate lots of try_fmt calls for each (emulated) 
enum_framerate call, as try_fmt actually generates IO on UVC cams, this made 
things slow, and worse made some buggy cams crash.

The second UVC related fix, is a work around for some UVC cams not liking 
libv4l not sending a setfmt before starting the stream, if the current format 
matches the to set format. This is fixed in at the driver level for 2.6.28, but 
in the mean time I've added a workaround to make these cams work with libv4l 
and older kernels.

libv4l-0.5.6
------------
* Always do a s_fmt on uvc cams even if this changes nothing, as not doing
   the s_fmt triggers a bug in the uvcvideo driver in kernel <= 2.6.28
   (with certain cams)

libv4l-0.5.5
------------
* Avoid the use of try_fmt as much as possible on UVC cams, instead use the
   results of the enum_framesizes ioctl. This is because:
   1) try_fmt actually causes IO with UVC cams making apps which do lot of
      querrying of device capabilities slow (cheese)
   2) some buggy cams don't like getting lots of UVC video probes and crash
      when they do

Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.6.tar.gz

Regards,

Hans



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
