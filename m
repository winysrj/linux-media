Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0BCSc1g026710
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 07:28:38 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0BCSKRG009397
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 07:28:21 -0500
Message-ID: <4969E641.1080703@hhs.nl>
Date: Sun, 11 Jan 2009 13:29:53 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: libv4l release: 0.5.8
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

Various small fixes, see the changelog entry below:

libv4l-0.5.8
------------
* Add support for UYVY (for USB Apple iSight) patch by Julien BLACHE
   <jb@jblache.org>
* Remove v4lconvert_yvyu_to_yuv420 function as its functionality is
   duplicate with v4lconvert_yuyv_to_yuv420
* Use Requires.private where appropiate in .pc files (patch by Gregor Jasny)
* Switch to using USB-id's instead of USB product string, as not all devices
   set a unique product string. This fixes the upside down issues with
   genius e-messenger 112 cams
* Add support for sn9c20x-i420 format patch by Vasily Khoruzhick
   <anarsoul@gmail.com>

Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.5.8.tar.gz

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
