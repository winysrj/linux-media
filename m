Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m665vRdZ007724
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 01:57:27 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m665uli8028781
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 01:56:48 -0400
Message-ID: <4870602F.7050000@hhs.nl>
Date: Sun, 06 Jul 2008 08:03:27 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: v4l2 library <v4l2-library@linuxtv.org>, video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Announcing libv4l 0.3.3
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

I'm happy to announce version 0.3.3 of libv4l:
http://people.atrpms.net/~hdegoede/libv4l-0.3.3.tar.gz

This release has the following changes (aka the xawtv release):


libv4l-0.3.3
------------
* Add open64 and mmap64 wrappers to the LD_PRELOAD wrapper libs, so that
   they also work for applications compiled with FILE_OFFSET_BITS=64, this
   fixes using them with v4l-info
* While looking at xawtv in general, found a few bugs in xawtv itself, added
   a patch to fix those to the appl-patches dir
* Talking about the appl-patches dir, restore that as it accidentally got
   dropped from 0.3.2
* Be more verbose in various places when it comes to logging (esp errors)
* Change v4lconvert_enum_fmt code a bit, so that it is easier to add more
   supported destination formats to libv4lconvert
* Don't return -EINVAL from try_fmt when we cannot convert because the cam
   doesn't have any formats we know. Instead just return as format whatever the
   cam returns from try_fmt, this new behavior is compliant with the v4l2
   api as documented


Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
