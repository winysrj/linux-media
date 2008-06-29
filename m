Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TKZfZo003980
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 16:35:41 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TKZSuv026363
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 16:35:28 -0400
Message-ID: <4867F380.1040803@hhs.nl>
Date: Sun, 29 Jun 2008 22:41:36 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: v4l2 library <v4l2-library@linuxtv.org>, video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Announcing libv4l 0.3.1 aka "the vlc release"
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

I'm happy to announce version 0.3.1 of libv4l:
http://people.atrpms.net/~hdegoede/libv4l-0.3.tar.gz

This release has the following changes (baby steps now):

libv4l-0.3.1
------------
* Only serialize V4L2_BUF_TYPE_VIDEO_CAPTURE type ioctls
* Do not return an uninitialized variable as result code for GPICT
   (fixes vlc, but see below)
* Add a patches directory which includes:
   * vlc-0.8.6-libv4l1.patch, modify vlc's v4l1 plugin to directly call into
     libv4l1, in the end we want all apps todo this as its better then
     LD_PRELOAD tricks, but for vlc this is needed as vlc's plugin system
     causes LD_PRELOAD to not work on symbols in the plugins
   * camorama-0.19-fixes.patch, small bugfixes to camorama's v4l1 support,
     this patch only fixes _real_ bugs in camorama and does not change it to
     work with v4l1compat. Although it does work better with these bugs fixed
     :) With this patch and LD_PRELOAD=<path>/v4l1compat.so it works
     flawless.


Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
