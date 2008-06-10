Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5ABoodr016824
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 07:50:51 -0400
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5ABoMgD031373
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 07:50:22 -0400
Message-ID: <.195.6.25.114.1213098615.squirrel@82.255.184.47>
In-Reply-To: <484C594A.3040908@hhs.nl>
References: <484C594A.3040908@hhs.nl>
Date: Tue, 10 Jun 2008 13:50:15 +0200 (CEST)
From: "Thierry Merle" <thierry.merle@free.fr>
To: "Hans de Goede" <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Elmar Kleijn <elmar_kleijn@hotmail.com>, spca50x-devs@lists.sourceforge.net,
	video4linux-list@redhat.com, "need4weed@gmail.com" <need4weed@gmail.com>
Subject: Re: v4l1 compat version 0.6 aka V4L2 apps stay working
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

Hi Hans,
> Hi All,
>
> Changes since last version:
> v4l1-compat-0.6 (V4L2 apps stay working)
> ----------------------------------------
> * Do not go into emulation mode of rgb24 immediately, but only after a
>    GPICT ioctl which has not been preceded by a SPICT ioctl, AKA do not
> get
>    in the way of V4L2 read calls by doing conversion on them
> * Do not get in the way of mmap calls made by V4L2 applications
> * Fix swapping of red and blue in bayer -> bgr24 decode routine
> * Remember the v4l1 palette asked for with SPICT and return that, as
>    otherwise we loose information when going v4l1 -> v4l2 -> v4l1, for
> example
>    YUV420P becomes YUV420, which are separate in v4l1.
>
> Given the high rate of me pushing out releases I was planning to stop
> spamming
> the list with tarbals (however small), but my personal webspace is down
> (yeah!)
> so one more time in spam modues, sorry.
>
> With this version all apps tried sofar:
> * spcaview read / mmap mode, yuv420 and bgr24
> * ekiga v4l1 read / mmap mode
> * camorama including changing capture resolution while streaming
>
> Work fine, note with some cams camorama might need a small bugfix though,
> as it
> assumes that cams have a resolution exactly half of their max resolution
> available, and as such ignores then width/height returned by VIDEOCSWIN,
> assuming it got what it asked for, the patch against camorama 0.19
> attached to
> my 0.5 announcement mail fixes this.
>
> Regards,
>
> Hans
>
I took a look at your library, seems simple and interesting!
You are overloading open/close/ioctl/read/mmap and catch these operations
on /dev/videoX path to do whatever you want, like frame conversion.
This is a simpler solution than the one on
http://www.linuxtv.org/v4lwiki/index.php/V4L2UserspaceLibrary
that is complex and incomplete regarding the implementation, sadly.
- You said that arts is using the same system. Does it conflict with the
use of arts from an application point of view?
- The device driver will still have to declare the compressed pixel
formats (V4L2_PIX_FMT_MJPEG, ...) to interface the library. The usbvision
device provides a proprietary pixel format but I cannot name it; how we
will cope with that?

Regards,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
