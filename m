Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67LeWHp003846
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 17:40:32 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67LdeIx005063
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 17:39:41 -0400
Message-ID: <48728EB6.10409@hhs.nl>
Date: Mon, 07 Jul 2008 23:46:30 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: v4l2 library <v4l2-library@linuxtv.org>, video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Announcing libv4l 0.3.4
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

I'm afraid version 0.3.3 had a nasty bug, so here is 0.3.4:
http://people.atrpms.net/~hdegoede/libv4l-0.3.4.tar.gz

This release has the following changes:


libv4l-0.3.4 (the brownpaperbag release)
----------------------------------------
* The mmap64 support in 0.3.3, has caused a bug in libv4l1 when running on
   32 bit systems (who uses those now a days?), this bug caused v4l1
   compatibility to not work at all, this release fixes this
* Some apps (xawtv, kopete) use an ioctl wrapper internally for various
   reasons. This wrappers request argument is an int, but the real ioctl's
   request argument is an unsigned long. Passing the VIDIOC_xxx defines through
   to the wrapper, and then to the real ioctl, causes the request to get sign
   extended on 64 bit args. The kernel seems to ignore the upper 32 bits,
   causing the sign extension to not make a difference. libv4l now also
   ignores the upper 32 bits of the libv4lx_ioctl request argument on 64 bit
   archs
* Add a bugfix patch for kopete in the appl-patches dir, currently it assumes
   that it got the width and height it asked for when doing a S_FMT, which is a
   wrong assumption


Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
