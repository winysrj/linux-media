Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m74IFrp8025426
	for <video4linux-list@redhat.com>; Mon, 4 Aug 2008 14:16:03 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m74IFBrP010819
	for <video4linux-list@redhat.com>; Mon, 4 Aug 2008 14:15:17 -0400
Message-ID: <4897494B.1010307@hhs.nl>
Date: Mon, 04 Aug 2008 20:24:11 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: 2.6.27rc1 installs a broken /usr/include/linux/videodev2.h
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

When doing "make headers_install" 2.6.27rc1 install a broken 
/usr/include/linux/videodev2.h

The problem are the 2 userspace lines of the following part of videodev2.h:

#ifdef __KERNEL__
#include <linux/time.h>     /* need struct timeval */
#include <linux/compiler.h> /* need __user */
#else
#define __user
#include <sys/time.h>
#endif

2.6.27rc1 seems to handle __user usage in userspace itself now, simply by 
removing __user + whitespace after it resulting in the following in userspace 
for the 2 lines in the userspace of the if else above:

#define #include <sys/time.h>

The fix for 2/6/27rc1 is to simply remove the "#define __user" line, but I 
wonder how that will effect our usage with older kernels?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
