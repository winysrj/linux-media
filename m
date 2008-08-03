Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m73GXdwX024297
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 12:33:39 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m73GXOkp029477
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 12:33:25 -0400
Message-ID: <4895DFEF.1010105@hhs.nl>
Date: Sun, 03 Aug 2008 18:42:23 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: v4l2 library <v4l2-library@linuxtv.org>, video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Announcing libv4l 0.3.8
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

I've installed a pci bttv tv card in my machine to test libv4l xawtv patches 
and I've found that libv4l was being to strict with the circumstances under 
which it allowed changing the fmt and changing between read / mmap mode.

This new version fixes this:
http://people.atrpms.net/~hdegoede/libv4l-0.4.0.tar.gz

Full list of changes:

libv4l-0.4.0
------------
* Be more relaxed in our checks for mixing read and mmap access, we were
   being more strict in this then certain kernel drivers (bttv) making xawtv
   unhappy
* With some drivers the buffers must be mapped before queuing, so when
   converting map the (real) buffers before calling the qbuf ioctl
* Add support for conversion to RGB24 (before we only supported BGR24) based
   on a patch by Jean-Francois Moine
* When the hardware supports a format natively prefer using the native
   version over converting from another supported format
* Various Makefile and pkgconfig file improvements by Gregor Jasny (Debian)
* Drop the appl-patches dir, all application patches are now available and
   tracked here: http://linuxtv.org/v4lwiki/index.php/Libv4l_Progress

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
