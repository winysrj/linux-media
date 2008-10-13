Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DBlVtX026626
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 07:47:31 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DBlHTK006905
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 07:47:17 -0400
Message-ID: <48F335D9.5020104@hhs.nl>
Date: Mon, 13 Oct 2008 13:49:45 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: libv4l release: 0.5.1 (The Skype release)
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

After much frustration about the very poor implementation of v4l in skype, I'm 
happy to announce libv4l-0.5.1, in which after much pain, I've managed to 
implemented a fix for the skype problem in a way which does not make me feel dirty.

libv4l-0.5.1
------------
* Add support for software cropping from 352x288 -> 320x240 / 176x144 ->
   160x120, so that apps which will only work with vga resolutions like
   320x240 (Skype!) will work with cams/drivers which do not support cropping
   CIF resolutions to VGA resolutions in hardware. This makes all 2.6.27 gspca
   supported cams, except for the pac7302 which only does 640x480 (and skype
   wants 320x240), work with skype
* The v4lconvert_convert function was becoming a bit of a mess, so split the
   functionailiy into separate v4lconvert_convert_pixfmt, v4lconvert_rotate and
   v4lconvert_crop functions, and make v4lconvert_convert a frontend to
   these
* Do not link the wrapper libs against libpthread (patch from Gregor Jasny)


Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.1.tar.gz

Regards,

Hans



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
